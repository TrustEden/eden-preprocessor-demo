/// Dynamic world event system for creating living, reactive campaign worlds

/// Types of world events that can occur
enum WorldEventType {
  seasonal, // Seasonal changes, festivals, weather
  political, // Wars, elections, coups
  economic, // Market crashes, trade route changes
  natural, // Earthquakes, plagues, meteor strikes
  faction, // Faction conflicts, alliances
  quest, // Quest-related world changes
  playerDriven, // Events caused by player actions
  random, // Random encounters and happenings
  custom,
}

/// Event scale - how widespread the impact is
enum EventScale {
  personal, // Affects individuals
  local, // Single town/village
  regional, // Multiple settlements
  national, // Entire kingdom
  continental, // Multiple nations
  global, // Entire world
}

/// Current status of a world event
enum WorldEventStatus {
  upcoming, // Scheduled but not yet occurred
  active, // Currently happening
  concluded, // Finished with outcomes
  cancelled, // Prevented by players or other events
}

/// Trigger conditions for automatic world events
class EventTrigger {
  final String triggerId;
  final EventTriggerType triggerType;

  // Time-based triggers
  final int? targetGameDay;
  final Season? targetSeason;

  // Location-based triggers
  final String? requiredLocation;
  final double? proximityRadius; // In miles

  // Quest-based triggers
  final String? requiredQuestId;
  final String? requiredQuestStatus; // 'completed', 'failed', 'active'

  // Condition-based triggers
  final String? requiredFactionId;
  final int? requiredFactionStanding; // Min standing needed
  final String? requiredItemId;

  // Manual triggers
  final bool isManualTrigger; // DM manually triggers

  EventTrigger({
    required this.triggerId,
    required this.triggerType,
    this.targetGameDay,
    this.targetSeason,
    this.requiredLocation,
    this.proximityRadius,
    this.requiredQuestId,
    this.requiredQuestStatus,
    this.requiredFactionId,
    this.requiredFactionStanding,
    this.requiredItemId,
    this.isManualTrigger = false,
  });

  Map<String, dynamic> toJson() => {
        'triggerId': triggerId,
        'triggerType': triggerType.name,
        'targetGameDay': targetGameDay,
        'targetSeason': targetSeason?.name,
        'requiredLocation': requiredLocation,
        'proximityRadius': proximityRadius,
        'requiredQuestId': requiredQuestId,
        'requiredQuestStatus': requiredQuestStatus,
        'requiredFactionId': requiredFactionId,
        'requiredFactionStanding': requiredFactionStanding,
        'requiredItemId': requiredItemId,
        'isManualTrigger': isManualTrigger,
      };

  factory EventTrigger.fromJson(Map<String, dynamic> json) {
    return EventTrigger(
      triggerId: json['triggerId'] as String,
      triggerType: EventTriggerType.values.firstWhere(
        (e) => e.name == json['triggerType'],
        orElse: () => EventTriggerType.manual,
      ),
      targetGameDay: json['targetGameDay'] as int?,
      targetSeason: json['targetSeason'] != null
          ? Season.values.firstWhere((e) => e.name == json['targetSeason'])
          : null,
      requiredLocation: json['requiredLocation'] as String?,
      proximityRadius: json['proximityRadius'] as double?,
      requiredQuestId: json['requiredQuestId'] as String?,
      requiredQuestStatus: json['requiredQuestStatus'] as String?,
      requiredFactionId: json['requiredFactionId'] as String?,
      requiredFactionStanding: json['requiredFactionStanding'] as int?,
      requiredItemId: json['requiredItemId'] as String?,
      isManualTrigger: json['isManualTrigger'] as bool? ?? false,
    );
  }
}

enum EventTriggerType {
  time,
  location,
  quest,
  faction,
  item,
  manual,
}

enum Season {
  spring,
  summer,
  autumn,
  winter,
}

/// World event that affects the campaign world
class WorldEvent {
  final String eventId;
  final String eventName;
  final String description;
  final WorldEventType eventType;
  final EventScale eventScale;
  WorldEventStatus eventStatus;

  // Trigger information
  final EventTrigger? eventTrigger;

  // Timing
  final int? scheduledDay; // Game day when event should occur
  int? startedDay; // When event actually started
  int? endedDay; // When event concluded
  final int? durationDays; // How long event lasts

  // Impact tracking
  final List<String> affectedLocations;
  final List<String> affectedFactions;
  final Map<String, int> factionStandingChanges; // factionId -> change
  final Map<String, double> economicImpacts; // itemCategory -> price modifier

  // Consequences
  final List<EventConsequence> possibleConsequences;
  final List<EventConsequence> actualConsequences;

  // Player interaction
  bool playerAware; // Do players know about this event?
  bool canPlayerIntervene;
  String? playerInterventionResult; // What happened when players intervened

  // Narrative
  final String narrativeHook; // How to introduce this to players
  final List<String> narrativeUpdates; // Updates as event progresses
  final String? resolutionNarrative; // How it concluded

  WorldEvent({
    required this.eventId,
    required this.eventName,
    required this.description,
    required this.eventType,
    required this.eventScale,
    this.eventStatus = WorldEventStatus.upcoming,
    this.eventTrigger,
    this.scheduledDay,
    this.startedDay,
    this.endedDay,
    this.durationDays,
    List<String>? affectedLocations,
    List<String>? affectedFactions,
    Map<String, int>? factionStandingChanges,
    Map<String, double>? economicImpacts,
    List<EventConsequence>? possibleConsequences,
    List<EventConsequence>? actualConsequences,
    this.playerAware = false,
    this.canPlayerIntervene = true,
    this.playerInterventionResult,
    required this.narrativeHook,
    List<String>? narrativeUpdates,
    this.resolutionNarrative,
  })  : affectedLocations = affectedLocations ?? [],
        affectedFactions = affectedFactions ?? [],
        factionStandingChanges = factionStandingChanges ?? {},
        economicImpacts = economicImpacts ?? {},
        possibleConsequences = possibleConsequences ?? [],
        actualConsequences = actualConsequences ?? [],
        narrativeUpdates = narrativeUpdates ?? [];

  /// Start the event
  void startEvent(int currentGameDay) {
    eventStatus = WorldEventStatus.active;
    startedDay = currentGameDay;
  }

  /// Conclude the event with outcomes
  void concludeEvent(int currentGameDay, List<EventConsequence> consequences) {
    eventStatus = WorldEventStatus.concluded;
    endedDay = currentGameDay;
    actualConsequences.addAll(consequences);
  }

  /// Cancel the event (prevented by players)
  void cancelEvent(int currentGameDay, String reason) {
    eventStatus = WorldEventStatus.cancelled;
    endedDay = currentGameDay;
    playerInterventionResult = reason;
  }

  /// Check if event should auto-trigger based on current game state
  bool shouldTrigger(int currentGameDay) {
    if (eventStatus != WorldEventStatus.upcoming) return false;
    if (scheduledDay != null && currentGameDay >= scheduledDay!) return true;
    return false;
  }

  Map<String, dynamic> toJson() => {
        'eventId': eventId,
        'eventName': eventName,
        'description': description,
        'eventType': eventType.name,
        'eventScale': eventScale.name,
        'eventStatus': eventStatus.name,
        'eventTrigger': eventTrigger?.toJson(),
        'scheduledDay': scheduledDay,
        'startedDay': startedDay,
        'endedDay': endedDay,
        'durationDays': durationDays,
        'affectedLocations': affectedLocations,
        'affectedFactions': affectedFactions,
        'factionStandingChanges': factionStandingChanges,
        'economicImpacts': economicImpacts,
        'possibleConsequences': possibleConsequences.map((e) => e.toJson()).toList(),
        'actualConsequences': actualConsequences.map((e) => e.toJson()).toList(),
        'playerAware': playerAware,
        'canPlayerIntervene': canPlayerIntervene,
        'playerInterventionResult': playerInterventionResult,
        'narrativeHook': narrativeHook,
        'narrativeUpdates': narrativeUpdates,
        'resolutionNarrative': resolutionNarrative,
      };

  factory WorldEvent.fromJson(Map<String, dynamic> json) {
    return WorldEvent(
      eventId: json['eventId'] as String,
      eventName: json['eventName'] as String,
      description: json['description'] as String,
      eventType: WorldEventType.values.firstWhere(
        (e) => e.name == json['eventType'],
        orElse: () => WorldEventType.custom,
      ),
      eventScale: EventScale.values.firstWhere(
        (e) => e.name == json['eventScale'],
        orElse: () => EventScale.local,
      ),
      eventStatus: WorldEventStatus.values.firstWhere(
        (e) => e.name == json['eventStatus'],
        orElse: () => WorldEventStatus.upcoming,
      ),
      eventTrigger: json['eventTrigger'] != null
          ? EventTrigger.fromJson(json['eventTrigger'] as Map<String, dynamic>)
          : null,
      scheduledDay: json['scheduledDay'] as int?,
      startedDay: json['startedDay'] as int?,
      endedDay: json['endedDay'] as int?,
      durationDays: json['durationDays'] as int?,
      affectedLocations: (json['affectedLocations'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      affectedFactions: (json['affectedFactions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      factionStandingChanges: (json['factionStandingChanges'] as Map<String, dynamic>?)
              ?.map((key, value) => MapEntry(key, value as int)) ??
          {},
      economicImpacts: (json['economicImpacts'] as Map<String, dynamic>?)
              ?.map((key, value) => MapEntry(key, (value as num).toDouble())) ??
          {},
      possibleConsequences: (json['possibleConsequences'] as List<dynamic>?)
              ?.map((e) => EventConsequence.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      actualConsequences: (json['actualConsequences'] as List<dynamic>?)
              ?.map((e) => EventConsequence.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      playerAware: json['playerAware'] as bool? ?? false,
      canPlayerIntervene: json['canPlayerIntervene'] as bool? ?? true,
      playerInterventionResult: json['playerInterventionResult'] as String?,
      narrativeHook: json['narrativeHook'] as String,
      narrativeUpdates: (json['narrativeUpdates'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      resolutionNarrative: json['resolutionNarrative'] as String?,
    );
  }
}

/// Possible consequence of a world event
class EventConsequence {
  final String consequenceId;
  final String description;
  final ConsequenceType consequenceType;
  final ConsequenceSeverity severity;

  // Mechanical effects
  final Map<String, int>? factionStandingChanges;
  final Map<String, double>? priceModifiers;
  final List<String>? unlockedQuests;
  final List<String>? lockedQuests;
  final List<String>? spawnedNPCs;
  final List<String>? removedNPCs;

  EventConsequence({
    required this.consequenceId,
    required this.description,
    required this.consequenceType,
    this.severity = ConsequenceSeverity.moderate,
    this.factionStandingChanges,
    this.priceModifiers,
    this.unlockedQuests,
    this.lockedQuests,
    this.spawnedNPCs,
    this.removedNPCs,
  });

  Map<String, dynamic> toJson() => {
        'consequenceId': consequenceId,
        'description': description,
        'consequenceType': consequenceType.name,
        'severity': severity.name,
        'factionStandingChanges': factionStandingChanges,
        'priceModifiers': priceModifiers,
        'unlockedQuests': unlockedQuests,
        'lockedQuests': lockedQuests,
        'spawnedNPCs': spawnedNPCs,
        'removedNPCs': removedNPCs,
      };

  factory EventConsequence.fromJson(Map<String, dynamic> json) {
    return EventConsequence(
      consequenceId: json['consequenceId'] as String,
      description: json['description'] as String,
      consequenceType: ConsequenceType.values.firstWhere(
        (e) => e.name == json['consequenceType'],
        orElse: () => ConsequenceType.narrative,
      ),
      severity: ConsequenceSeverity.values.firstWhere(
        (e) => e.name == json['severity'],
        orElse: () => ConsequenceSeverity.moderate,
      ),
      factionStandingChanges: (json['factionStandingChanges'] as Map<String, dynamic>?)
          ?.map((key, value) => MapEntry(key, value as int)),
      priceModifiers: (json['priceModifiers'] as Map<String, dynamic>?)
          ?.map((key, value) => MapEntry(key, (value as num).toDouble())),
      unlockedQuests: (json['unlockedQuests'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      lockedQuests: (json['lockedQuests'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      spawnedNPCs: (json['spawnedNPCs'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      removedNPCs: (json['removedNPCs'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );
  }
}

enum ConsequenceType {
  narrative, // Story-only impact
  economic, // Affects prices/trade
  political, // Affects factions
  quest, // Unlocks/locks quests
  npc, // Spawns/removes NPCs
  environmental, // Changes locations
}

enum ConsequenceSeverity {
  minor,
  moderate,
  major,
  catastrophic,
}

/// Faction conflict - special type of political world event
class FactionConflict {
  final String conflictId;
  final String conflictName;
  final String faction1Id;
  final String faction2Id;
  final ConflictType conflictType;
  ConflictStatus conflictStatus;

  // Progression
  int conflictIntensity; // 0-100, affects how aggressive the conflict is
  String? winningFactionId; // Current leader in the conflict
  final List<String> battleLocations; // Where fighting has occurred

  // Player involvement
  String? playerAlignedFaction; // Which faction players support
  int playerInfluence; // How much players have affected outcome (0-100)

  // Resolution
  final List<ConflictResolution> possibleResolutions;
  ConflictResolution? actualResolution;

  FactionConflict({
    required this.conflictId,
    required this.conflictName,
    required this.faction1Id,
    required this.faction2Id,
    required this.conflictType,
    this.conflictStatus = ConflictStatus.brewing,
    this.conflictIntensity = 0,
    this.winningFactionId,
    List<String>? battleLocations,
    this.playerAlignedFaction,
    this.playerInfluence = 0,
    List<ConflictResolution>? possibleResolutions,
    this.actualResolution,
  })  : battleLocations = battleLocations ?? [],
        possibleResolutions = possibleResolutions ?? [];

  /// Escalate the conflict
  void escalate(int amount) {
    conflictIntensity = (conflictIntensity + amount).clamp(0, 100);
    if (conflictIntensity >= 75 && conflictStatus == ConflictStatus.brewing) {
      conflictStatus = ConflictStatus.openWar;
    } else if (conflictIntensity >= 30 && conflictStatus == ConflictStatus.brewing) {
      conflictStatus = ConflictStatus.skirmishing;
    }
  }

  /// De-escalate the conflict
  void deEscalate(int amount) {
    conflictIntensity = (conflictIntensity - amount).clamp(0, 100);
    if (conflictIntensity < 30 && conflictStatus == ConflictStatus.skirmishing) {
      conflictStatus = ConflictStatus.brewing;
    }
  }

  /// Resolve the conflict
  void resolve(ConflictResolution resolution) {
    conflictStatus = ConflictStatus.resolved;
    actualResolution = resolution;
  }

  Map<String, dynamic> toJson() => {
        'conflictId': conflictId,
        'conflictName': conflictName,
        'faction1Id': faction1Id,
        'faction2Id': faction2Id,
        'conflictType': conflictType.name,
        'conflictStatus': conflictStatus.name,
        'conflictIntensity': conflictIntensity,
        'winningFactionId': winningFactionId,
        'battleLocations': battleLocations,
        'playerAlignedFaction': playerAlignedFaction,
        'playerInfluence': playerInfluence,
        'possibleResolutions': possibleResolutions.map((e) => e.toJson()).toList(),
        'actualResolution': actualResolution?.toJson(),
      };

  factory FactionConflict.fromJson(Map<String, dynamic> json) {
    return FactionConflict(
      conflictId: json['conflictId'] as String,
      conflictName: json['conflictName'] as String,
      faction1Id: json['faction1Id'] as String,
      faction2Id: json['faction2Id'] as String,
      conflictType: ConflictType.values.firstWhere(
        (e) => e.name == json['conflictType'],
        orElse: () => ConflictType.territorial,
      ),
      conflictStatus: ConflictStatus.values.firstWhere(
        (e) => e.name == json['conflictStatus'],
        orElse: () => ConflictStatus.brewing,
      ),
      conflictIntensity: json['conflictIntensity'] as int? ?? 0,
      winningFactionId: json['winningFactionId'] as String?,
      battleLocations: (json['battleLocations'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      playerAlignedFaction: json['playerAlignedFaction'] as String?,
      playerInfluence: json['playerInfluence'] as int? ?? 0,
      possibleResolutions: (json['possibleResolutions'] as List<dynamic>?)
              ?.map((e) => ConflictResolution.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      actualResolution: json['actualResolution'] != null
          ? ConflictResolution.fromJson(json['actualResolution'] as Map<String, dynamic>)
          : null,
    );
  }
}

enum ConflictType {
  territorial, // Fighting over land
  ideological, // Different beliefs
  economic, // Trade disputes
  succession, // Who should rule
  religious, // Holy wars
  revenge, // Blood feuds
}

enum ConflictStatus {
  brewing, // Tensions rising
  skirmishing, // Small battles
  openWar, // Full-scale war
  stalemate, // Neither side winning
  resolved, // Concluded
}

/// How a faction conflict can be resolved
class ConflictResolution {
  final String resolutionId;
  final String resolutionName;
  final String description;
  final ResolutionType resolutionType;
  final String? victorFactionId; // Winner, if applicable
  final Map<String, int> factionStandingChanges;
  final List<String> territoryChanges; // Which lands change hands

  ConflictResolution({
    required this.resolutionId,
    required this.resolutionName,
    required this.description,
    required this.resolutionType,
    this.victorFactionId,
    Map<String, int>? factionStandingChanges,
    List<String>? territoryChanges,
  })  : factionStandingChanges = factionStandingChanges ?? {},
        territoryChanges = territoryChanges ?? [];

  Map<String, dynamic> toJson() => {
        'resolutionId': resolutionId,
        'resolutionName': resolutionName,
        'description': description,
        'resolutionType': resolutionType.name,
        'victorFactionId': victorFactionId,
        'factionStandingChanges': factionStandingChanges,
        'territoryChanges': territoryChanges,
      };

  factory ConflictResolution.fromJson(Map<String, dynamic> json) {
    return ConflictResolution(
      resolutionId: json['resolutionId'] as String,
      resolutionName: json['resolutionName'] as String,
      description: json['description'] as String,
      resolutionType: ResolutionType.values.firstWhere(
        (e) => e.name == json['resolutionType'],
        orElse: () => ResolutionType.peace,
      ),
      victorFactionId: json['victorFactionId'] as String?,
      factionStandingChanges: (json['factionStandingChanges'] as Map<String, dynamic>?)
              ?.map((key, value) => MapEntry(key, value as int)) ??
          {},
      territoryChanges: (json['territoryChanges'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }
}

enum ResolutionType {
  peace, // Negotiated peace
  victory, // One side wins
  playerMediated, // Players brokered peace
  stalemate, // Neither side wins
  absorption, // One faction absorbed by other
  destruction, // One faction destroyed
}
