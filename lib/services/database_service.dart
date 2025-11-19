import 'dart:convert';
import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import '../models/character.dart';
import '../models/game_state.dart';
import '../models/item.dart';
import '../models/combat_state.dart';
import '../models/game_session.dart';
import '../models/enhanced_character.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Initialize FFI for desktop platforms
    if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    String path = join(await getDatabasesPath(), 'ai_dungeon_master.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Characters table
    await db.execute('''
      CREATE TABLE characters (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        race TEXT NOT NULL,
        class_name TEXT NOT NULL,
        level INTEGER NOT NULL,
        experience INTEGER NOT NULL,
        strength INTEGER NOT NULL,
        dexterity INTEGER NOT NULL,
        constitution INTEGER NOT NULL,
        intelligence INTEGER NOT NULL,
        wisdom INTEGER NOT NULL,
        charisma INTEGER NOT NULL,
        hp_current INTEGER NOT NULL,
        hp_max INTEGER NOT NULL,
        armor_class INTEGER NOT NULL,
        initiative_bonus INTEGER NOT NULL,
        proficiency_bonus INTEGER NOT NULL,
        second_wind_uses INTEGER NOT NULL,
        action_surge_uses INTEGER NOT NULL,
        fighting_style TEXT,
        athletics_proficient INTEGER NOT NULL DEFAULT 1,
        perception_proficient INTEGER NOT NULL DEFAULT 1,
        survival_proficient INTEGER NOT NULL DEFAULT 0,
        intimidation_proficient INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL
      )
    ''');

    // Game states table
    await db.execute('''
      CREATE TABLE game_states (
        campaign_id TEXT PRIMARY KEY,
        campaign_name TEXT NOT NULL,
        character_id TEXT NOT NULL,
        current_location TEXT,
        current_scene TEXT,
        session_number INTEGER NOT NULL,
        last_saved TEXT NOT NULL,
        FOREIGN KEY (character_id) REFERENCES characters (id)
      )
    ''');

    // Narrative events table
    await db.execute('''
      CREATE TABLE narrative_events (
        id TEXT PRIMARY KEY,
        campaign_id TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        event_type TEXT NOT NULL,
        description TEXT NOT NULL,
        player_action TEXT,
        dm_response TEXT,
        metadata TEXT,
        FOREIGN KEY (campaign_id) REFERENCES game_states (campaign_id)
      )
    ''');

    // Inventory table
    await db.execute('''
      CREATE TABLE inventory (
        id TEXT PRIMARY KEY,
        character_id TEXT NOT NULL,
        item_name TEXT NOT NULL,
        item_type TEXT NOT NULL,
        weight INTEGER NOT NULL,
        value INTEGER NOT NULL,
        damage_dice TEXT,
        damage_type TEXT,
        weapon_properties TEXT,
        armor_bonus INTEGER,
        armor_type TEXT,
        effect TEXT,
        quantity INTEGER,
        equipped INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (character_id) REFERENCES characters (id)
      )
    ''');

    // Combat states table
    await db.execute('''
      CREATE TABLE combat_states (
        campaign_id TEXT PRIMARY KEY,
        current_round INTEGER NOT NULL,
        current_turn_index INTEGER NOT NULL,
        combatants TEXT NOT NULL,
        combat_log TEXT NOT NULL,
        FOREIGN KEY (campaign_id) REFERENCES game_states (campaign_id)
      )
    ''');

    // Objectives table
    await db.execute('''
      CREATE TABLE objectives (
        id TEXT PRIMARY KEY,
        campaign_id TEXT NOT NULL,
        objective TEXT NOT NULL,
        completed INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (campaign_id) REFERENCES game_states (campaign_id)
      )
    ''');
  }

  Future<String> getDatabasesPath() async {
    // For desktop apps, use a local directory
    String home = Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'] ?? '.';
    String appDir = join(home, '.ai_dungeon_master');
    Directory(appDir).createSync(recursive: true);
    return appDir;
  }

  // Character operations
  Future<void> saveCharacter(Character character) async {
    final db = await database;
    await db.insert(
      'characters',
      {
        'id': character.id,
        'name': character.name,
        'race': character.race,
        'class_name': character.className,
        'level': character.level,
        'experience': character.experience,
        'strength': character.strength,
        'dexterity': character.dexterity,
        'constitution': character.constitution,
        'intelligence': character.intelligence,
        'wisdom': character.wisdom,
        'charisma': character.charisma,
        'hp_current': character.hpCurrent,
        'hp_max': character.hpMax,
        'armor_class': character.armorClass,
        'initiative_bonus': character.initiativeBonus,
        'proficiency_bonus': character.proficiencyBonus,
        'second_wind_uses': character.secondWindUses,
        'action_surge_uses': character.actionSurgeUses,
        'fighting_style': character.fightingStyle,
        'athletics_proficient': character.athleticsProficient ? 1 : 0,
        'perception_proficient': character.perceptionProficient ? 1 : 0,
        'survival_proficient': character.survivalProficient ? 1 : 0,
        'intimidation_proficient': character.intimidationProficient ? 1 : 0,
        'created_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Save inventory
    await saveInventory(character);
  }

  Future<Character?> loadCharacter(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'characters',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;

    var data = maps.first;
    var character = Character(
      id: data['id'],
      name: data['name'],
      race: data['race'],
      className: data['class_name'],
      level: data['level'],
      experience: data['experience'],
      strength: data['strength'],
      dexterity: data['dexterity'],
      constitution: data['constitution'],
      intelligence: data['intelligence'],
      wisdom: data['wisdom'],
      charisma: data['charisma'],
      hpCurrent: data['hp_current'],
      hpMax: data['hp_max'],
      armorClass: data['armor_class'],
      proficiencyBonus: data['proficiency_bonus'],
      secondWindUses: data['second_wind_uses'],
      actionSurgeUses: data['action_surge_uses'],
      fightingStyle: data['fighting_style'],
      athleticsProficient: data['athletics_proficient'] == 1,
      perceptionProficient: data['perception_proficient'] == 1,
      survivalProficient: data['survival_proficient'] == 1,
      intimidationProficient: data['intimidation_proficient'] == 1,
    );

    // Load inventory
    character.inventory = await loadInventory(id);

    // Set equipped items
    for (var item in character.inventory) {
      if (item.equipped) {
        if (item.type == 'weapon') {
          character.equippedWeapon = item;
        } else if (item.type == 'armor' && item.armorType != 'shield') {
          character.equippedArmor = item;
        } else if (item.type == 'armor' && item.armorType == 'shield') {
          character.equippedShield = item;
        }
      }
    }

    return character;
  }

  Future<void> saveInventory(Character character) async {
    final db = await database;

    // Delete existing inventory
    await db.delete(
      'inventory',
      where: 'character_id = ?',
      whereArgs: [character.id],
    );

    // Insert all items
    for (var item in character.inventory) {
      // Check if this item is equipped
      bool isEquipped = item == character.equippedWeapon ||
          item == character.equippedArmor ||
          item == character.equippedShield;

      await db.insert('inventory', {
        'id': item.id,
        'character_id': character.id,
        'item_name': item.name,
        'item_type': item.type,
        'weight': item.weight,
        'value': item.value,
        'damage_dice': item.damageDice,
        'damage_type': item.damageType,
        'weapon_properties': item.weaponProperties?.join(','),
        'armor_bonus': item.armorBonus,
        'armor_type': item.armorType,
        'effect': item.effect,
        'quantity': item.quantity,
        'equipped': isEquipped ? 1 : 0,
      });
    }
  }

  Future<List<Item>> loadInventory(String characterId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'inventory',
      where: 'character_id = ?',
      whereArgs: [characterId],
    );

    return maps.map((data) {
      return Item(
        id: data['id'],
        name: data['item_name'],
        type: data['item_type'],
        weight: data['weight'],
        value: data['value'],
        damageDice: data['damage_dice'],
        damageType: data['damage_type'],
        weaponProperties: data['weapon_properties'] != null
            ? (data['weapon_properties'] as String).split(',')
            : null,
        armorBonus: data['armor_bonus'],
        armorType: data['armor_type'],
        effect: data['effect'],
        quantity: data['quantity'],
        equipped: data['equipped'] == 1,
      );
    }).toList();
  }

  // Game state operations
  Future<void> saveGameState(GameState gameState) async {
    final db = await database;

    // Save character first
    await saveCharacter(gameState.character);

    // Save game state
    await db.insert(
      'game_states',
      {
        'campaign_id': gameState.campaignId,
        'campaign_name': gameState.campaignName,
        'character_id': gameState.character.id,
        'current_location': gameState.currentLocation,
        'current_scene': gameState.currentSceneDescription,
        'session_number': gameState.sessionNumber,
        'last_saved': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Save narrative events
    await _saveNarrativeEvents(gameState);

    // Save objectives
    await _saveObjectives(gameState);

    // Save combat state if active
    if (gameState.activeCombat != null) {
      await saveCombatState(gameState.campaignId, gameState.activeCombat!);
    } else {
      await clearCombatState(gameState.campaignId);
    }
  }

  Future<void> _saveNarrativeEvents(GameState gameState) async {
    final db = await database;

    // For efficiency, only save new events (this is simplified for MVP)
    // In production, you'd track which events are already saved
    await db.delete(
      'narrative_events',
      where: 'campaign_id = ?',
      whereArgs: [gameState.campaignId],
    );

    for (var event in gameState.narrativeHistory) {
      await db.insert('narrative_events', {
        'id': '${gameState.campaignId}_${event.timestamp.millisecondsSinceEpoch}',
        'campaign_id': gameState.campaignId,
        'timestamp': event.timestamp.toIso8601String(),
        'event_type': event.eventType,
        'description': event.description,
        'player_action': event.playerAction,
        'dm_response': event.dmResponse,
        'metadata': event.metadata != null ? jsonEncode(event.metadata) : null,
      });
    }
  }

  Future<void> _saveObjectives(GameState gameState) async {
    final db = await database;

    await db.delete(
      'objectives',
      where: 'campaign_id = ?',
      whereArgs: [gameState.campaignId],
    );

    int index = 0;
    for (var objective in gameState.activeObjectives) {
      await db.insert('objectives', {
        'id': '${gameState.campaignId}_active_$index',
        'campaign_id': gameState.campaignId,
        'objective': objective,
        'completed': 0,
      });
      index++;
    }

    index = 0;
    for (var objective in gameState.completedObjectives) {
      await db.insert('objectives', {
        'id': '${gameState.campaignId}_completed_$index',
        'campaign_id': gameState.campaignId,
        'objective': objective,
        'completed': 1,
      });
      index++;
    }
  }

  Future<GameState?> loadGameState(String campaignId) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      'game_states',
      where: 'campaign_id = ?',
      whereArgs: [campaignId],
    );

    if (maps.isEmpty) return null;

    var data = maps.first;

    // Load character
    var character = await loadCharacter(data['character_id']);
    if (character == null) return null;

    // Load narrative events
    var narrativeEvents = await _loadNarrativeEvents(campaignId);

    // Load objectives
    var objectives = await _loadObjectives(campaignId);

    // Load combat state
    var combatState = await loadCombatState(campaignId);

    return GameState(
      campaignId: campaignId,
      campaignName: data['campaign_name'],
      character: character,
      narrativeHistory: narrativeEvents,
      currentLocation: data['current_location'] ?? 'Unknown',
      currentSceneDescription: data['current_scene'] ?? 'The adventure continues...',
      activeCombat: combatState,
      activeObjectives: objectives['active']!,
      completedObjectives: objectives['completed']!,
      lastSaved: DateTime.parse(data['last_saved']),
      sessionNumber: data['session_number'],
    );
  }

  Future<List<GameEvent>> _loadNarrativeEvents(String campaignId) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      'narrative_events',
      where: 'campaign_id = ?',
      whereArgs: [campaignId],
      orderBy: 'timestamp ASC',
    );

    return maps.map((data) {
      return GameEvent(
        timestamp: DateTime.parse(data['timestamp']),
        eventType: data['event_type'],
        description: data['description'],
        playerAction: data['player_action'],
        dmResponse: data['dm_response'],
        metadata: data['metadata'] != null
            ? jsonDecode(data['metadata']) as Map<String, dynamic>
            : null,
      );
    }).toList();
  }

  Future<Map<String, List<String>>> _loadObjectives(String campaignId) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      'objectives',
      where: 'campaign_id = ?',
      whereArgs: [campaignId],
    );

    List<String> active = [];
    List<String> completed = [];

    for (var data in maps) {
      if (data['completed'] == 1) {
        completed.add(data['objective']);
      } else {
        active.add(data['objective']);
      }
    }

    return {'active': active, 'completed': completed};
  }

  // Combat state operations
  Future<void> saveCombatState(String campaignId, CombatState combat) async {
    final db = await database;

    await db.insert(
      'combat_states',
      {
        'campaign_id': campaignId,
        'current_round': combat.currentRound,
        'current_turn_index': combat.currentTurnIndex,
        'combatants': jsonEncode(combat.combatants.map((c) => c.toJson()).toList()),
        'combat_log': jsonEncode(combat.combatLog),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<CombatState?> loadCombatState(String campaignId) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      'combat_states',
      where: 'campaign_id = ?',
      whereArgs: [campaignId],
    );

    if (maps.isEmpty) return null;

    var data = maps.first;

    List<dynamic> combatantsJson = jsonDecode(data['combatants']);
    List<Combatant> combatants = combatantsJson
        .map((c) => Combatant.fromJson(c as Map<String, dynamic>))
        .toList();

    return CombatState(
      currentRound: data['current_round'],
      currentTurnIndex: data['current_turn_index'],
      combatants: combatants,
      combatLog: (jsonDecode(data['combat_log']) as List<dynamic>).cast<String>(),
    );
  }

  Future<void> clearCombatState(String campaignId) async {
    final db = await database;
    await db.delete(
      'combat_states',
      where: 'campaign_id = ?',
      whereArgs: [campaignId],
    );
  }

  // List all saved campaigns
  Future<List<Map<String, dynamic>>> listCampaigns() async {
    final db = await database;
    return await db.query(
      'game_states',
      orderBy: 'last_saved DESC',
    );
  }

  // ==================== NEW: GameSession Support ====================

  /// Save a GameSession (new multi-user session format)
  Future<void> saveGameSession(GameSession session) async {
    final db = await database;

    // Create sessions table if it doesn't exist (migration support)
    await _ensureSessionTableExists(db);

    // Save main session data
    await db.insert(
      'game_sessions',
      {
        'session_id': session.sessionId,
        'campaign_id': session.campaignId,
        'campaign_name': session.campaignName,
        'dm_player_id': session.dmPlayerId,
        'current_scene': jsonEncode(session.currentScene.toJson()),
        'game_time_days': session.gameTimeDays,
        'session_number': session.sessionNumber,
        'created_at': session.createdAt.toIso8601String(),
        'last_saved': session.lastSaved.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Save players
    await _saveSessionPlayers(session);

    // Save characters
    await _saveSessionCharacters(session);

    // Save events
    await _saveSessionEvents(session);

    // Save DM secrets
    await _saveSessionDMSecrets(session);

    // Save active combat if any
    if (session.activeCombat != null) {
      await saveCombatState(session.sessionId, session.activeCombat!);
    } else {
      await clearCombatState(session.sessionId);
    }
  }

  Future<void> _ensureSessionTableExists(Database db) async {
    // Check if table exists
    var result = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name='game_sessions'",
    );

    if (result.isEmpty) {
      // Create new tables for session support
      await db.execute('''
        CREATE TABLE game_sessions (
          session_id TEXT PRIMARY KEY,
          campaign_id TEXT NOT NULL,
          campaign_name TEXT NOT NULL,
          dm_player_id TEXT NOT NULL,
          current_scene TEXT NOT NULL,
          game_time_days INTEGER NOT NULL DEFAULT 0,
          session_number INTEGER NOT NULL DEFAULT 1,
          created_at TEXT NOT NULL,
          last_saved TEXT NOT NULL
        )
      ''');

      await db.execute('''
        CREATE TABLE session_players (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          session_id TEXT NOT NULL,
          player_id TEXT NOT NULL,
          player_name TEXT NOT NULL,
          character_id TEXT,
          role TEXT NOT NULL,
          is_connected INTEGER NOT NULL DEFAULT 1,
          joined_at TEXT NOT NULL,
          last_activity TEXT NOT NULL,
          FOREIGN KEY (session_id) REFERENCES game_sessions (session_id),
          UNIQUE(session_id, player_id)
        )
      ''');

      await db.execute('''
        CREATE TABLE session_events (
          id TEXT PRIMARY KEY,
          session_id TEXT NOT NULL,
          timestamp TEXT NOT NULL,
          event_type TEXT NOT NULL,
          description TEXT NOT NULL,
          player_action TEXT,
          dm_response TEXT,
          metadata TEXT,
          is_dm_secret INTEGER NOT NULL DEFAULT 0,
          importance INTEGER NOT NULL DEFAULT 5,
          FOREIGN KEY (session_id) REFERENCES game_sessions (session_id)
        )
      ''');

      await db.execute('''
        CREATE TABLE session_dm_secrets (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          session_id TEXT NOT NULL,
          secret_type TEXT NOT NULL,
          secret_key TEXT NOT NULL,
          secret_value TEXT NOT NULL,
          FOREIGN KEY (session_id) REFERENCES game_sessions (session_id)
        )
      ''');

      await db.execute('''
        CREATE TABLE enhanced_characters (
          id TEXT PRIMARY KEY,
          session_id TEXT NOT NULL,
          character_data TEXT NOT NULL,
          FOREIGN KEY (session_id) REFERENCES game_sessions (session_id)
        )
      ''');
    }
  }

  Future<void> _saveSessionPlayers(GameSession session) async {
    final db = await database;

    // Delete existing players for this session
    await db.delete(
      'session_players',
      where: 'session_id = ?',
      whereArgs: [session.sessionId],
    );

    // Insert all players
    for (var entry in session.players.entries) {
      var player = entry.value;
      await db.insert('session_players', {
        'session_id': session.sessionId,
        'player_id': player.playerId,
        'player_name': player.playerName,
        'character_id': player.characterId,
        'role': player.role.toString(),
        'is_connected': player.isConnected ? 1 : 0,
        'joined_at': player.joinedAt.toIso8601String(),
        'last_activity': player.lastActivity.toIso8601String(),
      });
    }
  }

  Future<void> _saveSessionCharacters(GameSession session) async {
    final db = await database;

    // Delete existing characters for this session
    await db.delete(
      'enhanced_characters',
      where: 'session_id = ?',
      whereArgs: [session.sessionId],
    );

    // Insert all characters
    for (var character in session.activeCharacters) {
      await db.insert('enhanced_characters', {
        'id': character.id,
        'session_id': session.sessionId,
        'character_data': jsonEncode(character.toJson()),
      });
    }
  }

  Future<void> _saveSessionEvents(GameSession session) async {
    final db = await database;

    // For efficiency, only save new events (simplified for now)
    // TODO: Track which events are already saved
    await db.delete(
      'session_events',
      where: 'session_id = ?',
      whereArgs: [session.sessionId],
    );

    for (var event in session.sharedHistory) {
      await db.insert('session_events', {
        'id': event.id,
        'session_id': session.sessionId,
        'timestamp': event.timestamp.toIso8601String(),
        'event_type': event.eventType.toString(),
        'description': event.description,
        'player_action': event.playerAction,
        'dm_response': event.dmResponse,
        'metadata': event.metadata != null ? jsonEncode(event.metadata) : null,
        'is_dm_secret': event.isDMSecret ? 1 : 0,
        'importance': event.importance,
      });
    }
  }

  Future<void> _saveSessionDMSecrets(GameSession session) async {
    final db = await database;

    // Delete existing secrets
    await db.delete(
      'session_dm_secrets',
      where: 'session_id = ?',
      whereArgs: [session.sessionId],
    );

    // Save DM notes
    for (var note in session.dmSecrets.dmNotes) {
      await db.insert('session_dm_secrets', {
        'session_id': session.sessionId,
        'secret_type': 'note',
        'secret_key': DateTime.now().millisecondsSinceEpoch.toString(),
        'secret_value': note,
      });
    }

    // Save NPC secrets
    for (var entry in session.dmSecrets.npcSecrets.entries) {
      await db.insert('session_dm_secrets', {
        'session_id': session.sessionId,
        'secret_type': 'npc_secret',
        'secret_key': entry.key,
        'secret_value': entry.value,
      });
    }

    // Save hidden info
    await db.insert('session_dm_secrets', {
      'session_id': session.sessionId,
      'secret_type': 'hidden_info',
      'secret_key': 'data',
      'secret_value': jsonEncode(session.dmSecrets.hiddenInfo),
    });
  }

  /// Load a GameSession
  Future<GameSession?> loadGameSession(String sessionId) async {
    final db = await database;

    // Ensure tables exist
    await _ensureSessionTableExists(db);

    // Load main session data
    final sessionData = await db.query(
      'game_sessions',
      where: 'session_id = ?',
      whereArgs: [sessionId],
    );

    if (sessionData.isEmpty) return null;

    var data = sessionData.first;

    // Load players
    var players = await _loadSessionPlayers(sessionId);

    // Load characters
    var characters = await _loadSessionCharacters(sessionId);

    // Load events
    var events = await _loadSessionEvents(sessionId);

    // Load DM secrets
    var dmSecrets = await _loadSessionDMSecrets(sessionId);

    // Load combat if exists
    var combat = await loadCombatState(sessionId);

    return GameSession(
      sessionId: data['session_id'] as String,
      campaignId: data['campaign_id'] as String,
      campaignName: data['campaign_name'] as String,
      dmPlayerId: data['dm_player_id'] as String,
      players: players,
      activeCharacters: characters,
      currentScene: Scene.fromJson(jsonDecode(data['current_scene'] as String) as Map<String, dynamic>),
      sharedHistory: events,
      dmSecrets: dmSecrets,
      activeCombat: combat,
      gameTimeDays: data['game_time_days'] as int? ?? 0,
      sessionNumber: data['session_number'] as int? ?? 1,
      createdAt: DateTime.parse(data['created_at'] as String),
      lastSaved: DateTime.parse(data['last_saved'] as String),
    );
  }

  Future<Map<String, PlayerConnection>> _loadSessionPlayers(String sessionId) async {
    final db = await database;

    var results = await db.query(
      'session_players',
      where: 'session_id = ?',
      whereArgs: [sessionId],
    );

    Map<String, PlayerConnection> players = {};

    for (var row in results) {
      var player = PlayerConnection(
        playerId: row['player_id'] as String,
        playerName: row['player_name'] as String,
        characterId: row['character_id'] as String?,
        role: SessionRole.values.firstWhere(
          (e) => e.toString() == row['role'],
          orElse: () => SessionRole.player,
        ),
        isConnected: (row['is_connected'] as int) == 1,
        joinedAt: DateTime.parse(row['joined_at'] as String),
        lastActivity: DateTime.parse(row['last_activity'] as String),
      );

      players[player.playerId] = player;
    }

    return players;
  }

  Future<List<EnhancedCharacter>> _loadSessionCharacters(String sessionId) async {
    final db = await database;

    var results = await db.query(
      'enhanced_characters',
      where: 'session_id = ?',
      whereArgs: [sessionId],
    );

    List<EnhancedCharacter> characters = [];

    for (var row in results) {
      var characterData = jsonDecode(row['character_data'] as String) as Map<String, dynamic>;
      characters.add(EnhancedCharacter.fromJson(characterData));
    }

    return characters;
  }

  Future<List<GameEvent>> _loadSessionEvents(String sessionId) async {
    final db = await database;

    var results = await db.query(
      'session_events',
      where: 'session_id = ?',
      whereArgs: [sessionId],
      orderBy: 'timestamp ASC',
    );

    List<GameEvent> events = [];

    for (var row in results) {
      events.add(GameEvent(
        id: row['id'] as String,
        timestamp: DateTime.parse(row['timestamp'] as String),
        eventType: EventType.values.firstWhere(
          (e) => e.toString() == row['event_type'],
          orElse: () => EventType.narrative,
        ),
        description: row['description'] as String,
        playerAction: row['player_action'] as String?,
        dmResponse: row['dm_response'] as String?,
        metadata: row['metadata'] != null ? jsonDecode(row['metadata'] as String) as Map<String, dynamic> : null,
        isDMSecret: (row['is_dm_secret'] as int) == 1,
        importance: row['importance'] as int? ?? 5,
      ));
    }

    return events;
  }

  Future<DMSecrets> _loadSessionDMSecrets(String sessionId) async {
    final db = await database;

    var results = await db.query(
      'session_dm_secrets',
      where: 'session_id = ?',
      whereArgs: [sessionId],
    );

    List<String> dmNotes = [];
    Map<String, String> npcSecrets = {};
    Map<String, dynamic> hiddenInfo = {};

    for (var row in results) {
      String type = row['secret_type'] as String;
      String key = row['secret_key'] as String;
      String value = row['secret_value'] as String;

      switch (type) {
        case 'note':
          dmNotes.add(value);
          break;
        case 'npc_secret':
          npcSecrets[key] = value;
          break;
        case 'hidden_info':
          hiddenInfo = jsonDecode(value) as Map<String, dynamic>;
          break;
      }
    }

    return DMSecrets(
      dmNotes: dmNotes,
      npcSecrets: npcSecrets,
      hiddenInfo: hiddenInfo,
    );
  }

  /// List all saved sessions
  Future<List<Map<String, dynamic>>> listGameSessions() async {
    final db = await database;

    await _ensureSessionTableExists(db);

    return await db.query(
      'game_sessions',
      orderBy: 'last_saved DESC',
    );
  }
}
