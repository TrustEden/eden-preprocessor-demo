// Campaign Template Models
// For offline campaign creation and design

class CampaignTemplate {
  String id;
  String name;
  String description;
  String theme; // high fantasy, horror, urban, etc.
  int recommendedLevel;
  List<Act> acts;
  List<Location> locations;
  List<NPC> npcs;
  List<QuestTemplate> quests;
  List<EncounterTemplate> encounters;
  Map<String, String> variables; // Custom campaign variables

  CampaignTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.theme,
    required this.recommendedLevel,
    List<Act>? acts,
    List<Location>? locations,
    List<NPC>? npcs,
    List<QuestTemplate>? quests,
    List<EncounterTemplate>? encounters,
    Map<String, String>? variables,
  })  : acts = acts ?? [],
        locations = locations ?? [],
        npcs = npcs ?? [],
        quests = quests ?? [],
        encounters = encounters ?? [],
        variables = variables ?? {};

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'theme': theme,
        'recommendedLevel': recommendedLevel,
        'acts': acts.map((a) => a.toJson()).toList(),
        'locations': locations.map((l) => l.toJson()).toList(),
        'npcs': npcs.map((n) => n.toJson()).toList(),
        'quests': quests.map((q) => q.toJson()).toList(),
        'encounters': encounters.map((e) => e.toJson()).toList(),
        'variables': variables,
      };

  factory CampaignTemplate.fromJson(Map<String, dynamic> json) {
    return CampaignTemplate(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      theme: json['theme'],
      recommendedLevel: json['recommendedLevel'],
      acts: (json['acts'] as List?)?.map((a) => Act.fromJson(a)).toList(),
      locations: (json['locations'] as List?)?.map((l) => Location.fromJson(l)).toList(),
      npcs: (json['npcs'] as List?)?.map((n) => NPC.fromJson(n)).toList(),
      quests: (json['quests'] as List?)?.map((q) => QuestTemplate.fromJson(q)).toList(),
      encounters: (json['encounters'] as List?)?.map((e) => EncounterTemplate.fromJson(e)).toList(),
      variables: Map<String, String>.from(json['variables'] ?? {}),
    );
  }
}

class Act {
  String id;
  String name;
  String description;
  int actNumber;
  List<String> sceneIds;
  List<String> questIds;
  String? completionCondition;

  Act({
    required this.id,
    required this.name,
    required this.description,
    required this.actNumber,
    List<String>? sceneIds,
    List<String>? questIds,
    this.completionCondition,
  })  : sceneIds = sceneIds ?? [],
        questIds = questIds ?? [];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'actNumber': actNumber,
        'sceneIds': sceneIds,
        'questIds': questIds,
        'completionCondition': completionCondition,
      };

  factory Act.fromJson(Map<String, dynamic> json) => Act(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        actNumber: json['actNumber'],
        sceneIds: List<String>.from(json['sceneIds'] ?? []),
        questIds: List<String>.from(json['questIds'] ?? []),
        completionCondition: json['completionCondition'],
      );
}

class Location {
  String id;
  String name;
  String description;
  String type; // dungeon, city, wilderness, etc.
  List<String> connectedLocationIds;
  List<String> npcIds;
  List<String> encounterIds;
  Map<String, String> features; // Key points of interest

  Location({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    List<String>? connectedLocationIds,
    List<String>? npcIds,
    List<String>? encounterIds,
    Map<String, String>? features,
  })  : connectedLocationIds = connectedLocationIds ?? [],
        npcIds = npcIds ?? [],
        encounterIds = encounterIds ?? [],
        features = features ?? {};

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'type': type,
        'connectedLocationIds': connectedLocationIds,
        'npcIds': npcIds,
        'encounterIds': encounterIds,
        'features': features,
      };

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        type: json['type'],
        connectedLocationIds: List<String>.from(json['connectedLocationIds'] ?? []),
        npcIds: List<String>.from(json['npcIds'] ?? []),
        encounterIds: List<String>.from(json['encounterIds'] ?? []),
        features: Map<String, String>.from(json['features'] ?? {}),
      );
}

class NPC {
  String id;
  String name;
  String description;
  String race;
  String? characterClass;
  int level;
  String alignment;
  String personality;
  String motivation;
  List<String> questIds;
  Map<String, int> relationships; // npcId -> relationship score (-100 to 100)
  List<String> dialogue; // Pre-written dialogue options

  NPC({
    required this.id,
    required this.name,
    required this.description,
    required this.race,
    this.characterClass,
    required this.level,
    required this.alignment,
    required this.personality,
    required this.motivation,
    List<String>? questIds,
    Map<String, int>? relationships,
    List<String>? dialogue,
  })  : questIds = questIds ?? [],
        relationships = relationships ?? {},
        dialogue = dialogue ?? [];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'race': race,
        'characterClass': characterClass,
        'level': level,
        'alignment': alignment,
        'personality': personality,
        'motivation': motivation,
        'questIds': questIds,
        'relationships': relationships,
        'dialogue': dialogue,
      };

  factory NPC.fromJson(Map<String, dynamic> json) => NPC(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        race: json['race'],
        characterClass: json['characterClass'],
        level: json['level'],
        alignment: json['alignment'],
        personality: json['personality'],
        motivation: json['motivation'],
        questIds: List<String>.from(json['questIds'] ?? []),
        relationships: Map<String, int>.from(json['relationships'] ?? {}),
        dialogue: List<String>.from(json['dialogue'] ?? []),
      );
}

class QuestTemplate {
  String id;
  String name;
  String description;
  String type; // main, side, personal
  String giver; // NPC id
  List<QuestObjectiveTemplate> objectives;
  Map<String, dynamic> rewards;
  List<String> prerequisites; // Quest IDs that must be completed first
  int recommendedLevel;

  QuestTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.giver,
    List<QuestObjectiveTemplate>? objectives,
    Map<String, dynamic>? rewards,
    List<String>? prerequisites,
    required this.recommendedLevel,
  })  : objectives = objectives ?? [],
        rewards = rewards ?? {},
        prerequisites = prerequisites ?? [];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'type': type,
        'giver': giver,
        'objectives': objectives.map((o) => o.toJson()).toList(),
        'rewards': rewards,
        'prerequisites': prerequisites,
        'recommendedLevel': recommendedLevel,
      };

  factory QuestTemplate.fromJson(Map<String, dynamic> json) => QuestTemplate(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        type: json['type'],
        giver: json['giver'],
        objectives: (json['objectives'] as List?)?.map((o) => QuestObjectiveTemplate.fromJson(o)).toList(),
        rewards: Map<String, dynamic>.from(json['rewards'] ?? {}),
        prerequisites: List<String>.from(json['prerequisites'] ?? []),
        recommendedLevel: json['recommendedLevel'],
      );
}

class QuestObjectiveTemplate {
  String id;
  String description;
  String type; // kill, collect, explore, talk, escort
  Map<String, dynamic> parameters;
  bool optional;

  QuestObjectiveTemplate({
    required this.id,
    required this.description,
    required this.type,
    Map<String, dynamic>? parameters,
    this.optional = false,
  }) : parameters = parameters ?? {};

  Map<String, dynamic> toJson() => {
        'id': id,
        'description': description,
        'type': type,
        'parameters': parameters,
        'optional': optional,
      };

  factory QuestObjectiveTemplate.fromJson(Map<String, dynamic> json) => QuestObjectiveTemplate(
        id: json['id'],
        description: json['description'],
        type: json['type'],
        parameters: Map<String, dynamic>.from(json['parameters'] ?? {}),
        optional: json['optional'] ?? false,
      );
}

class EncounterTemplate {
  String id;
  String name;
  String description;
  String type; // combat, social, puzzle, trap
  int difficulty; // 1-10
  List<String> monsterIds;
  List<int> monsterCounts;
  String? locationId;
  String? trigger;
  Map<String, dynamic> rewards;

  EncounterTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.difficulty,
    List<String>? monsterIds,
    List<int>? monsterCounts,
    this.locationId,
    this.trigger,
    Map<String, dynamic>? rewards,
  })  : monsterIds = monsterIds ?? [],
        monsterCounts = monsterCounts ?? [],
        rewards = rewards ?? {};

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'type': type,
        'difficulty': difficulty,
        'monsterIds': monsterIds,
        'monsterCounts': monsterCounts,
        'locationId': locationId,
        'trigger': trigger,
        'rewards': rewards,
      };

  factory EncounterTemplate.fromJson(Map<String, dynamic> json) => EncounterTemplate(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        type: json['type'],
        difficulty: json['difficulty'],
        monsterIds: List<String>.from(json['monsterIds'] ?? []),
        monsterCounts: List<int>.from(json['monsterCounts'] ?? []),
        locationId: json['locationId'],
        trigger: json['trigger'],
        rewards: Map<String, dynamic>.from(json['rewards'] ?? {}),
      );
}
