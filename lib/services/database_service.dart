import 'dart:convert';
import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import '../models/character.dart';
import '../models/game_state.dart';
import '../models/item.dart';
import '../models/combat_state.dart';

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
}
