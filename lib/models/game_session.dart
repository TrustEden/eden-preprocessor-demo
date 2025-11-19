import 'enhanced_character.dart';
import 'combat_state.dart';
import 'quest.dart';
import 'monster.dart';
import 'faction.dart';

/// Represents a complete game session with DM and players
class GameSession {
  String sessionId;
  String campaignId;
  String campaignName;

  // Participants
  String dmPlayerId;
  Map<String, PlayerConnection> players; // playerId -> connection info
  List<EnhancedCharacter> activeCharacters;

  // Current state
  Scene currentScene;
  CombatState? activeCombat;

  // Shared narrative (visible to all)
  List<GameEvent> sharedHistory;

  // DM-only information
  DMSecrets dmSecrets;

  // Quest tracking
  List<Quest> activeQuests;
  List<Quest> completedQuests;

  // World state
  Map<String, FactionStanding> factionStandings;
  Map<String, NPCRelationship> npcRelationships;
  int gameTimeDays; // Days elapsed in-game

  // Meta information
  int sessionNumber;
  DateTime createdAt;
  DateTime lastSaved;

  GameSession({
    required this.sessionId,
    required this.campaignId,
    required this.campaignName,
    required this.dmPlayerId,
    Map<String, PlayerConnection>? players,
    List<EnhancedCharacter>? activeCharacters,
    required this.currentScene,
    this.activeCombat,
    List<GameEvent>? sharedHistory,
    DMSecrets? dmSecrets,
    List<Quest>? activeQuests,
    List<Quest>? completedQuests,
    Map<String, FactionStanding>? factionStandings,
    Map<String, NPCRelationship>? npcRelationships,
    this.gameTimeDays = 0,
    this.sessionNumber = 1,
    DateTime? createdAt,
    DateTime? lastSaved,
  })  : players = players ?? {},
        activeCharacters = activeCharacters ?? [],
        sharedHistory = sharedHistory ?? [],
        dmSecrets = dmSecrets ?? DMSecrets(),
        activeQuests = activeQuests ?? [],
        completedQuests = completedQuests ?? [],
        factionStandings = factionStandings ?? {},
        npcRelationships = npcRelationships ?? {},
        createdAt = createdAt ?? DateTime.now(),
        lastSaved = lastSaved ?? DateTime.now();

  /// Get a character by ID
  EnhancedCharacter? getCharacter(String characterId) {
    try {
      return activeCharacters.firstWhere((c) => c.id == characterId);
    } catch (e) {
      return null;
    }
  }

  /// Get a character by player ID
  EnhancedCharacter? getCharacterForPlayer(String playerId) {
    var connection = players[playerId];
    if (connection == null || connection.characterId == null) return null;
    return getCharacter(connection.characterId!);
  }

  /// Check if a player is connected
  bool isPlayerConnected(String playerId) {
    return players[playerId]?.isConnected ?? false;
  }

  /// Get all connected players
  List<PlayerConnection> getConnectedPlayers() {
    return players.values.where((p) => p.isConnected).toList();
  }

  Map<String, dynamic> toJson() => {
        'sessionId': sessionId,
        'campaignId': campaignId,
        'campaignName': campaignName,
        'dmPlayerId': dmPlayerId,
        'players': players.map((k, v) => MapEntry(k, v.toJson())),
        'activeCharacters': activeCharacters.map((c) => c.toJson()).toList(),
        'currentScene': currentScene.toJson(),
        'activeCombat': activeCombat?.toJson(),
        'sharedHistory': sharedHistory.map((e) => e.toJson()).toList(),
        'dmSecrets': dmSecrets.toJson(),
        'activeQuests': activeQuests.map((q) => q.toJson()).toList(),
        'completedQuests': completedQuests.map((q) => q.toJson()).toList(),
        'factionStandings': factionStandings.map((k, v) => MapEntry(k, v.toJson())),
        'npcRelationships': npcRelationships.map((k, v) => MapEntry(k, v.toJson())),
        'gameTimeDays': gameTimeDays,
        'sessionNumber': sessionNumber,
        'createdAt': createdAt.toIso8601String(),
        'lastSaved': lastSaved.toIso8601String(),
      };

  factory GameSession.fromJson(Map<String, dynamic> json) {
    return GameSession(
      sessionId: json['sessionId'] as String,
      campaignId: json['campaignId'] as String,
      campaignName: json['campaignName'] as String,
      dmPlayerId: json['dmPlayerId'] as String,
      players: (json['players'] as Map<String, dynamic>).map(
        (k, v) => MapEntry(k, PlayerConnection.fromJson(v as Map<String, dynamic>)),
      ),
      activeCharacters: (json['activeCharacters'] as List<dynamic>)
          .map((c) => EnhancedCharacter.fromJson(c as Map<String, dynamic>))
          .toList(),
      currentScene: Scene.fromJson(json['currentScene'] as Map<String, dynamic>),
      activeCombat: json['activeCombat'] != null
          ? CombatState.fromJson(json['activeCombat'] as Map<String, dynamic>)
          : null,
      sharedHistory: (json['sharedHistory'] as List<dynamic>)
          .map((e) => GameEvent.fromJson(e as Map<String, dynamic>))
          .toList(),
      dmSecrets: DMSecrets.fromJson(json['dmSecrets'] as Map<String, dynamic>),
      activeQuests: (json['activeQuests'] as List<dynamic>?)
              ?.map((q) => Quest.fromJson(q as Map<String, dynamic>))
              .toList() ??
          [],
      completedQuests: (json['completedQuests'] as List<dynamic>?)
              ?.map((q) => Quest.fromJson(q as Map<String, dynamic>))
              .toList() ??
          [],
      factionStandings: (json['factionStandings'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, FactionStanding.fromJson(v as Map<String, dynamic>)),
          ) ??
          {},
      npcRelationships: (json['npcRelationships'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, NPCRelationship.fromJson(v as Map<String, dynamic>)),
          ) ??
          {},
      gameTimeDays: json['gameTimeDays'] as int? ?? 0,
      sessionNumber: json['sessionNumber'] as int? ?? 1,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastSaved: DateTime.parse(json['lastSaved'] as String),
    );
  }
}

/// Player connection information
class PlayerConnection {
  String playerId;
  String playerName;
  String? characterId;
  SessionRole role;
  bool isConnected;
  DateTime joinedAt;
  DateTime lastActivity;

  PlayerConnection({
    required this.playerId,
    required this.playerName,
    this.characterId,
    this.role = SessionRole.player,
    this.isConnected = true,
    DateTime? joinedAt,
    DateTime? lastActivity,
  })  : joinedAt = joinedAt ?? DateTime.now(),
        lastActivity = lastActivity ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'playerId': playerId,
        'playerName': playerName,
        'characterId': characterId,
        'role': role.toString(),
        'isConnected': isConnected,
        'joinedAt': joinedAt.toIso8601String(),
        'lastActivity': lastActivity.toIso8601String(),
      };

  factory PlayerConnection.fromJson(Map<String, dynamic> json) {
    return PlayerConnection(
      playerId: json['playerId'] as String,
      playerName: json['playerName'] as String,
      characterId: json['characterId'] as String?,
      role: SessionRole.values.firstWhere(
        (e) => e.toString() == json['role'],
        orElse: () => SessionRole.player,
      ),
      isConnected: json['isConnected'] as bool? ?? true,
      joinedAt: DateTime.parse(json['joinedAt'] as String),
      lastActivity: DateTime.parse(json['lastActivity'] as String),
    );
  }
}

/// Session roles with different permissions
enum SessionRole {
  dungeonMaster, // Full control over everything
  player, // Control own character, view shared content
  observer, // Read-only access
  coHost, // Can control NPCs and monsters, assist DM
}

/// Current scene information
class Scene {
  String location;
  String description;
  List<String> visibleNPCIds;
  List<String> availableActions;
  Map<String, dynamic> metadata;

  Scene({
    required this.location,
    required this.description,
    List<String>? visibleNPCIds,
    List<String>? availableActions,
    Map<String, dynamic>? metadata,
  })  : visibleNPCIds = visibleNPCIds ?? [],
        availableActions = availableActions ?? [],
        metadata = metadata ?? {};

  Map<String, dynamic> toJson() => {
        'location': location,
        'description': description,
        'visibleNPCIds': visibleNPCIds,
        'availableActions': availableActions,
        'metadata': metadata,
      };

  factory Scene.fromJson(Map<String, dynamic> json) {
    return Scene(
      location: json['location'] as String,
      description: json['description'] as String,
      visibleNPCIds: (json['visibleNPCIds'] as List<dynamic>?)?.cast<String>() ?? [],
      availableActions: (json['availableActions'] as List<dynamic>?)?.cast<String>() ?? [],
      metadata: (json['metadata'] as Map<String, dynamic>?) ?? {},
    );
  }
}

/// DM-only information hidden from players
class DMSecrets {
  List<PlannedEvent> upcomingEvents;
  Map<String, String> npcSecrets; // npcId -> secret information
  List<String> dmNotes;
  Map<String, dynamic> hiddenInfo; // Trap locations, hidden doors, etc.
  List<Monster> preparedMonsters; // Pre-generated monsters for encounters

  DMSecrets({
    List<PlannedEvent>? upcomingEvents,
    Map<String, String>? npcSecrets,
    List<String>? dmNotes,
    Map<String, dynamic>? hiddenInfo,
    List<Monster>? preparedMonsters,
  })  : upcomingEvents = upcomingEvents ?? [],
        npcSecrets = npcSecrets ?? {},
        dmNotes = dmNotes ?? [],
        hiddenInfo = hiddenInfo ?? {},
        preparedMonsters = preparedMonsters ?? [];

  Map<String, dynamic> toJson() => {
        'upcomingEvents': upcomingEvents.map((e) => e.toJson()).toList(),
        'npcSecrets': npcSecrets,
        'dmNotes': dmNotes,
        'hiddenInfo': hiddenInfo,
        'preparedMonsters': preparedMonsters.map((m) => m.toJson()).toList(),
      };

  factory DMSecrets.fromJson(Map<String, dynamic> json) {
    return DMSecrets(
      upcomingEvents: (json['upcomingEvents'] as List<dynamic>?)
              ?.map((e) => PlannedEvent.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      npcSecrets: (json['npcSecrets'] as Map<String, dynamic>?)?.cast<String, String>() ?? {},
      dmNotes: (json['dmNotes'] as List<dynamic>?)?.cast<String>() ?? [],
      hiddenInfo: (json['hiddenInfo'] as Map<String, dynamic>?) ?? {},
      preparedMonsters: (json['preparedMonsters'] as List<dynamic>?)
              ?.map((m) => Monster.fromJson(m as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

/// Planned events for DM preparation
class PlannedEvent {
  String id;
  String title;
  String description;
  EventTrigger trigger;
  bool hasTriggered;
  DateTime? scheduledTime;

  PlannedEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.trigger,
    this.hasTriggered = false,
    this.scheduledTime,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'trigger': trigger.toJson(),
        'hasTriggered': hasTriggered,
        'scheduledTime': scheduledTime?.toIso8601String(),
      };

  factory PlannedEvent.fromJson(Map<String, dynamic> json) {
    return PlannedEvent(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      trigger: EventTrigger.fromJson(json['trigger'] as Map<String, dynamic>),
      hasTriggered: json['hasTriggered'] as bool? ?? false,
      scheduledTime: json['scheduledTime'] != null ? DateTime.parse(json['scheduledTime'] as String) : null,
    );
  }
}

/// Trigger conditions for planned events
class EventTrigger {
  EventTriggerType type;
  Map<String, dynamic> conditions;

  EventTrigger({
    required this.type,
    required this.conditions,
  });

  bool shouldTrigger(GameSession session) {
    switch (type) {
      case EventTriggerType.time:
        int targetDay = conditions['day'] as int;
        return session.gameTimeDays >= targetDay;

      case EventTriggerType.location:
        String targetLocation = conditions['location'] as String;
        return session.currentScene.location.toLowerCase() == targetLocation.toLowerCase();

      case EventTriggerType.questProgress:
        String questId = conditions['questId'] as String;
        var quest = session.activeQuests.where((q) => q.id == questId).firstOrNull;
        if (quest == null) return false;
        int requiredProgress = conditions['progress'] as int? ?? 100;
        return quest.progressPercent >= requiredProgress;

      case EventTriggerType.npcInteraction:
        String npcId = conditions['npcId'] as String;
        return session.currentScene.visibleNPCIds.contains(npcId);

      case EventTriggerType.manual:
        return false; // DM manually triggers
    }
  }

  Map<String, dynamic> toJson() => {
        'type': type.toString(),
        'conditions': conditions,
      };

  factory EventTrigger.fromJson(Map<String, dynamic> json) {
    return EventTrigger(
      type: EventTriggerType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => EventTriggerType.manual,
      ),
      conditions: json['conditions'] as Map<String, dynamic>,
    );
  }
}

enum EventTriggerType {
  time, // Triggers at specific game time
  location, // Triggers when entering location
  questProgress, // Triggers at quest milestone
  npcInteraction, // Triggers when interacting with NPC
  manual, // DM manually triggers
}

/// Game event (shared or DM-only)
class GameEvent {
  String id;
  DateTime timestamp;
  EventType eventType;
  String description;
  String? playerAction;
  String? dmResponse;
  Map<String, dynamic>? metadata;
  bool isDMSecret; // If true, only DM can see this
  int importance; // 1-10, helps with recap generation

  GameEvent({
    String? id,
    DateTime? timestamp,
    required this.eventType,
    required this.description,
    this.playerAction,
    this.dmResponse,
    this.metadata,
    this.isDMSecret = false,
    this.importance = 5,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'timestamp': timestamp.toIso8601String(),
        'eventType': eventType.toString(),
        'description': description,
        'playerAction': playerAction,
        'dmResponse': dmResponse,
        'metadata': metadata,
        'isDMSecret': isDMSecret,
        'importance': importance,
      };

  factory GameEvent.fromJson(Map<String, dynamic> json) {
    return GameEvent(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      eventType: EventType.values.firstWhere(
        (e) => e.toString() == json['eventType'],
        orElse: () => EventType.narrative,
      ),
      description: json['description'] as String,
      playerAction: json['playerAction'] as String?,
      dmResponse: json['dmResponse'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      isDMSecret: json['isDMSecret'] as bool? ?? false,
      importance: json['importance'] as int? ?? 5,
    );
  }
}

enum EventType {
  narrative, // Story progression
  combat, // Combat event
  skillCheck, // Skill check
  levelUp, // Character advancement
  loot, // Item acquisition
  questUpdate, // Quest progress
  npcInteraction, // NPC dialogue
  exploration, // Discovery
  rest, // Short or long rest
  dmNote, // DM-only note
}

/// NPC relationship tracking
class NPCRelationship {
  String npcId;
  String npcName;
  String characterId; // Which character has this relationship
  int attitude; // -100 to +100
  RelationshipType type;
  List<RelationshipEvent> history;

  NPCRelationship({
    required this.npcId,
    required this.npcName,
    required this.characterId,
    this.attitude = 0,
    this.type = RelationshipType.stranger,
    List<RelationshipEvent>? history,
  }) : history = history ?? [];

  /// Calculate merchant discount based on attitude
  int getMerchantDiscount() {
    if (attitude > 50) {
      return ((attitude - 50) / 10).floor().clamp(0, 10);
    }
    return 0;
  }

  /// Will NPC help in combat
  bool willHelpInCombat() => attitude > 70;

  /// Will NPC betray party
  bool willBetray() => attitude < -50;

  Map<String, dynamic> toJson() => {
        'npcId': npcId,
        'npcName': npcName,
        'characterId': characterId,
        'attitude': attitude,
        'type': type.toString(),
        'history': history.map((h) => h.toJson()).toList(),
      };

  factory NPCRelationship.fromJson(Map<String, dynamic> json) {
    return NPCRelationship(
      npcId: json['npcId'] as String,
      npcName: json['npcName'] as String,
      characterId: json['characterId'] as String,
      attitude: json['attitude'] as int? ?? 0,
      type: RelationshipType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => RelationshipType.stranger,
      ),
      history: (json['history'] as List<dynamic>?)
              ?.map((h) => RelationshipEvent.fromJson(h as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

enum RelationshipType {
  stranger,
  acquaintance,
  friend,
  ally,
  rival,
  enemy,
  romantic,
  mentor,
  apprentice,
}

class RelationshipEvent {
  DateTime timestamp;
  String description;
  int attitudeChange;

  RelationshipEvent({
    DateTime? timestamp,
    required this.description,
    required this.attitudeChange,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp.toIso8601String(),
        'description': description,
        'attitudeChange': attitudeChange,
      };

  factory RelationshipEvent.fromJson(Map<String, dynamic> json) {
    return RelationshipEvent(
      timestamp: DateTime.parse(json['timestamp'] as String),
      description: json['description'] as String,
      attitudeChange: json['attitudeChange'] as int,
    );
  }
}

/// Faction standing (separate from NPC relationships)
class FactionStanding {
  String factionId;
  String factionName;
  int reputation; // 0-100
  FactionRank rank;
  List<String> completedQuests;

  FactionStanding({
    required this.factionId,
    required this.factionName,
    this.reputation = 0,
    this.rank = FactionRank.neutral,
    List<String>? completedQuests,
  }) : completedQuests = completedQuests ?? [];

  /// Get benefits based on reputation
  Map<String, dynamic> getBenefits() {
    if (reputation >= 80) {
      return {
        'merchant_discount': 15,
        'safe_houses': true,
        'exclusive_quests': true,
        'faction_backup': true,
      };
    } else if (reputation >= 60) {
      return {
        'merchant_discount': 10,
        'safe_houses': true,
        'exclusive_quests': true,
      };
    } else if (reputation >= 40) {
      return {
        'merchant_discount': 5,
        'safe_houses': false,
        'exclusive_quests': false,
      };
    }
    return {};
  }

  Map<String, dynamic> toJson() => {
        'factionId': factionId,
        'factionName': factionName,
        'reputation': reputation,
        'rank': rank.toString(),
        'completedQuests': completedQuests,
      };

  factory FactionStanding.fromJson(Map<String, dynamic> json) {
    return FactionStanding(
      factionId: json['factionId'] as String,
      factionName: json['factionName'] as String,
      reputation: json['reputation'] as int? ?? 0,
      rank: FactionRank.values.firstWhere(
        (e) => e.toString() == json['rank'],
        orElse: () => FactionRank.neutral,
      ),
      completedQuests: (json['completedQuests'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }
}

enum FactionRank {
  hostile,
  unfriendly,
  neutral,
  friendly,
  honored,
  revered,
  exalted,
}
