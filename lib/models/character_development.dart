/// Character development system for personal quests, character arcs, and growth

/// Types of personal quests tied to character backstories
enum PersonalQuestType {
  revenge, // Seeking vengeance
  redemption, // Atoning for past sins
  discovery, // Finding lost family, heritage, etc.
  mastery, // Becoming the best at something
  protection, // Protecting someone or something
  ambition, // Achieving power, wealth, status
  mystery, // Solving a mystery from their past
  duty, // Fulfilling an obligation
  custom,
}

/// Status of a personal quest
enum PersonalQuestStatus {
  dormant, // Not yet activated
  active, // Currently pursuing
  progressing, // Making progress
  climax, // Reaching critical moment
  completed, // Successfully finished
  failed, // Quest failed
  abandoned, // Character gave up
}

/// Personal quest tied to a character's backstory
class PersonalQuest {
  final String questId;
  final String questName;
  final String characterId;
  final PersonalQuestType questType;
  PersonalQuestStatus questStatus;

  // Quest details
  final String backstoryHook; // How it ties to character's past
  final String motivation; // Why the character cares
  final String description;

  // Objectives
  final List<QuestObjective> questObjectives;
  final List<String> completedObjectives;

  // Progress tracking
  int progressPercentage; // 0-100
  final List<QuestMilestone> questMilestones;
  final List<String> reachedMilestones;

  // Stakes and consequences
  final String? successConsequence; // What happens if completed
  final String? failureConsequence; // What happens if failed
  final bool canFail; // Some quests can't be failed, just delayed

  // Character impact
  final Map<String, int> relationshipImpacts; // NPCs affected
  final List<String> potentialRewards; // Items, abilities, etc.
  final String? characterGrowth; // How it changes the character

  // Timing
  final int? timeLimit; // Game days before quest fails
  int? daysRemaining;
  final DateTime startedDate;
  DateTime? completedDate;

  PersonalQuest({
    required this.questId,
    required this.questName,
    required this.characterId,
    required this.questType,
    this.questStatus = PersonalQuestStatus.dormant,
    required this.backstoryHook,
    required this.motivation,
    required this.description,
    List<QuestObjective>? questObjectives,
    List<String>? completedObjectives,
    this.progressPercentage = 0,
    List<QuestMilestone>? questMilestones,
    List<String>? reachedMilestones,
    this.successConsequence,
    this.failureConsequence,
    this.canFail = true,
    Map<String, int>? relationshipImpacts,
    List<String>? potentialRewards,
    this.characterGrowth,
    this.timeLimit,
    this.daysRemaining,
    DateTime? startedDate,
    this.completedDate,
  })  : questObjectives = questObjectives ?? [],
        completedObjectives = completedObjectives ?? [],
        questMilestones = questMilestones ?? [],
        reachedMilestones = reachedMilestones ?? [],
        relationshipImpacts = relationshipImpacts ?? {},
        potentialRewards = potentialRewards ?? [],
        startedDate = startedDate ?? DateTime.now();

  /// Complete an objective
  void completeObjective(String objectiveId) {
    if (!completedObjectives.contains(objectiveId)) {
      completedObjectives.add(objectiveId);
      _updateProgress();
    }
  }

  /// Reach a milestone
  void reachMilestone(String milestoneId) {
    if (!reachedMilestones.contains(milestoneId)) {
      reachedMilestones.add(milestoneId);
      questStatus = PersonalQuestStatus.progressing;
    }
  }

  /// Update progress percentage
  void _updateProgress() {
    if (questObjectives.isEmpty) {
      progressPercentage = 0;
      return;
    }
    progressPercentage =
        ((completedObjectives.length / questObjectives.length) * 100).round();

    if (progressPercentage == 100) {
      questStatus = PersonalQuestStatus.climax; // Ready to complete
    } else if (progressPercentage > 0) {
      questStatus = PersonalQuestStatus.progressing;
    }
  }

  /// Complete the quest
  void complete() {
    questStatus = PersonalQuestStatus.completed;
    completedDate = DateTime.now();
    progressPercentage = 100;
  }

  /// Fail the quest
  void fail() {
    if (canFail) {
      questStatus = PersonalQuestStatus.failed;
      completedDate = DateTime.now();
    }
  }

  Map<String, dynamic> toJson() => {
        'questId': questId,
        'questName': questName,
        'characterId': characterId,
        'questType': questType.name,
        'questStatus': questStatus.name,
        'backstoryHook': backstoryHook,
        'motivation': motivation,
        'description': description,
        'questObjectives': questObjectives.map((e) => e.toJson()).toList(),
        'completedObjectives': completedObjectives,
        'progressPercentage': progressPercentage,
        'questMilestones': questMilestones.map((e) => e.toJson()).toList(),
        'reachedMilestones': reachedMilestones,
        'successConsequence': successConsequence,
        'failureConsequence': failureConsequence,
        'canFail': canFail,
        'relationshipImpacts': relationshipImpacts,
        'potentialRewards': potentialRewards,
        'characterGrowth': characterGrowth,
        'timeLimit': timeLimit,
        'daysRemaining': daysRemaining,
        'startedDate': startedDate.toIso8601String(),
        'completedDate': completedDate?.toIso8601String(),
      };

  factory PersonalQuest.fromJson(Map<String, dynamic> json) {
    return PersonalQuest(
      questId: json['questId'] as String,
      questName: json['questName'] as String,
      characterId: json['characterId'] as String,
      questType: PersonalQuestType.values.firstWhere(
        (e) => e.name == json['questType'],
        orElse: () => PersonalQuestType.custom,
      ),
      questStatus: PersonalQuestStatus.values.firstWhere(
        (e) => e.name == json['questStatus'],
        orElse: () => PersonalQuestStatus.dormant,
      ),
      backstoryHook: json['backstoryHook'] as String,
      motivation: json['motivation'] as String,
      description: json['description'] as String,
      questObjectives: (json['questObjectives'] as List<dynamic>?)
              ?.map((e) => QuestObjective.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      completedObjectives: (json['completedObjectives'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      progressPercentage: json['progressPercentage'] as int? ?? 0,
      questMilestones: (json['questMilestones'] as List<dynamic>?)
              ?.map((e) => QuestMilestone.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      reachedMilestones: (json['reachedMilestones'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      successConsequence: json['successConsequence'] as String?,
      failureConsequence: json['failureConsequence'] as String?,
      canFail: json['canFail'] as bool? ?? true,
      relationshipImpacts: (json['relationshipImpacts'] as Map<String, dynamic>?)
              ?.map((key, value) => MapEntry(key, value as int)) ??
          {},
      potentialRewards: (json['potentialRewards'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      characterGrowth: json['characterGrowth'] as String?,
      timeLimit: json['timeLimit'] as int?,
      daysRemaining: json['daysRemaining'] as int?,
      startedDate: DateTime.parse(json['startedDate'] as String),
      completedDate: json['completedDate'] != null
          ? DateTime.parse(json['completedDate'] as String)
          : null,
    );
  }
}

/// Objective within a personal quest
class QuestObjective {
  final String objectiveId;
  final String description;
  final bool isOptional;
  final String? hint; // Optional hint for players

  QuestObjective({
    required this.objectiveId,
    required this.description,
    this.isOptional = false,
    this.hint,
  });

  Map<String, dynamic> toJson() => {
        'objectiveId': objectiveId,
        'description': description,
        'isOptional': isOptional,
        'hint': hint,
      };

  factory QuestObjective.fromJson(Map<String, dynamic> json) {
    return QuestObjective(
      objectiveId: json['objectiveId'] as String,
      description: json['description'] as String,
      isOptional: json['isOptional'] as bool? ?? false,
      hint: json['hint'] as String?,
    );
  }
}

/// Milestone in a personal quest
class QuestMilestone {
  final String milestoneId;
  final String milestoneName;
  final String description;
  final int requiredProgress; // Percentage needed to reach this
  final String narrativeDescription; // How it plays out

  QuestMilestone({
    required this.milestoneId,
    required this.milestoneName,
    required this.description,
    required this.requiredProgress,
    required this.narrativeDescription,
  });

  Map<String, dynamic> toJson() => {
        'milestoneId': milestoneId,
        'milestoneName': milestoneName,
        'description': description,
        'requiredProgress': requiredProgress,
        'narrativeDescription': narrativeDescription,
      };

  factory QuestMilestone.fromJson(Map<String, dynamic> json) {
    return QuestMilestone(
      milestoneId: json['milestoneId'] as String,
      milestoneName: json['milestoneName'] as String,
      description: json['description'] as String,
      requiredProgress: json['requiredProgress'] as int,
      narrativeDescription: json['narrativeDescription'] as String,
    );
  }
}

/// Character arc - overarching character development theme
class CharacterArc {
  final String arcId;
  final String arcName;
  final String characterId;
  final ArcType arcType;
  ArcStage currentStage;

  // Arc definition
  final String startingState; // Character at beginning
  final String endingState; // Character at end (if completed)
  final String thematicFocus; // What this arc is about

  // Stages of the arc
  final List<ArcStageDefinition> arcStages;
  int currentStageIndex;

  // Progress tracking
  final List<CharacterMoment> keyMoments;
  int transformationLevel; // 0-100, how much character has changed

  // Integration with gameplay
  final List<String> relatedQuestIds;
  final List<String> relatedNPCIds;
  final Map<String, String> personalityShifts; // trait -> new value

  CharacterArc({
    required this.arcId,
    required this.arcName,
    required this.characterId,
    required this.arcType,
    this.currentStage = ArcStage.setup,
    required this.startingState,
    required this.endingState,
    required this.thematicFocus,
    List<ArcStageDefinition>? arcStages,
    this.currentStageIndex = 0,
    List<CharacterMoment>? keyMoments,
    this.transformationLevel = 0,
    List<String>? relatedQuestIds,
    List<String>? relatedNPCIds,
    Map<String, String>? personalityShifts,
  })  : arcStages = arcStages ?? [],
        keyMoments = keyMoments ?? [],
        relatedQuestIds = relatedQuestIds ?? [],
        relatedNPCIds = relatedNPCIds ?? [],
        personalityShifts = personalityShifts ?? {};

  /// Advance to next stage
  void advanceStage() {
    if (currentStageIndex < arcStages.length - 1) {
      currentStageIndex++;
      currentStage = arcStages[currentStageIndex].stage;
    }
  }

  /// Add a key character moment
  void addKeyMoment(CharacterMoment moment) {
    keyMoments.add(moment);
    transformationLevel = (transformationLevel + moment.transformationImpact).clamp(0, 100);
  }

  Map<String, dynamic> toJson() => {
        'arcId': arcId,
        'arcName': arcName,
        'characterId': characterId,
        'arcType': arcType.name,
        'currentStage': currentStage.name,
        'startingState': startingState,
        'endingState': endingState,
        'thematicFocus': thematicFocus,
        'arcStages': arcStages.map((e) => e.toJson()).toList(),
        'currentStageIndex': currentStageIndex,
        'keyMoments': keyMoments.map((e) => e.toJson()).toList(),
        'transformationLevel': transformationLevel,
        'relatedQuestIds': relatedQuestIds,
        'relatedNPCIds': relatedNPCIds,
        'personalityShifts': personalityShifts,
      };

  factory CharacterArc.fromJson(Map<String, dynamic> json) {
    return CharacterArc(
      arcId: json['arcId'] as String,
      arcName: json['arcName'] as String,
      characterId: json['characterId'] as String,
      arcType: ArcType.values.firstWhere(
        (e) => e.name == json['arcType'],
        orElse: () => ArcType.transformation,
      ),
      currentStage: ArcStage.values.firstWhere(
        (e) => e.name == json['currentStage'],
        orElse: () => ArcStage.setup,
      ),
      startingState: json['startingState'] as String,
      endingState: json['endingState'] as String,
      thematicFocus: json['thematicFocus'] as String,
      arcStages: (json['arcStages'] as List<dynamic>?)
              ?.map((e) => ArcStageDefinition.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      currentStageIndex: json['currentStageIndex'] as int? ?? 0,
      keyMoments: (json['keyMoments'] as List<dynamic>?)
              ?.map((e) => CharacterMoment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      transformationLevel: json['transformationLevel'] as int? ?? 0,
      relatedQuestIds: (json['relatedQuestIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      relatedNPCIds: (json['relatedNPCIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      personalityShifts: (json['personalityShifts'] as Map<String, dynamic>?)
              ?.map((key, value) => MapEntry(key, value as String)) ??
          {},
    );
  }
}

enum ArcType {
  transformation, // Character fundamentally changes
  testing, // Character's values are tested
  growth, // Character becomes better version of self
  corruption, // Character becomes worse
  redemption, // Character atones and improves
  fall, // Character descends into darkness
}

enum ArcStage {
  setup, // Establishing the character
  incitingIncident, // Something that starts the arc
  risingAction, // Building toward change
  crisis, // Point of no return
  climax, // Moment of transformation
  resolution, // New equilibrium
}

/// Definition of an arc stage
class ArcStageDefinition {
  final String stageId;
  final ArcStage stage;
  final String description;
  final String characterState; // How character should be at this stage
  final List<String> suggestedScenes; // Types of scenes that fit this stage

  ArcStageDefinition({
    required this.stageId,
    required this.stage,
    required this.description,
    required this.characterState,
    List<String>? suggestedScenes,
  }) : suggestedScenes = suggestedScenes ?? [];

  Map<String, dynamic> toJson() => {
        'stageId': stageId,
        'stage': stage.name,
        'description': description,
        'characterState': characterState,
        'suggestedScenes': suggestedScenes,
      };

  factory ArcStageDefinition.fromJson(Map<String, dynamic> json) {
    return ArcStageDefinition(
      stageId: json['stageId'] as String,
      stage: ArcStage.values.firstWhere(
        (e) => e.name == json['stage'],
        orElse: () => ArcStage.setup,
      ),
      description: json['description'] as String,
      characterState: json['characterState'] as String,
      suggestedScenes: (json['suggestedScenes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }
}

/// Key moment in a character's development
class CharacterMoment {
  final String momentId;
  final String momentName;
  final String description;
  final DateTime timestamp;
  final int sessionDay;
  final int transformationImpact; // 1-20, how much this changed character
  final MomentType momentType;
  final String narrativeDescription;

  CharacterMoment({
    required this.momentId,
    required this.momentName,
    required this.description,
    required this.timestamp,
    required this.sessionDay,
    required this.transformationImpact,
    required this.momentType,
    required this.narrativeDescription,
  });

  Map<String, dynamic> toJson() => {
        'momentId': momentId,
        'momentName': momentName,
        'description': description,
        'timestamp': timestamp.toIso8601String(),
        'sessionDay': sessionDay,
        'transformationImpact': transformationImpact,
        'momentType': momentType.name,
        'narrativeDescription': narrativeDescription,
      };

  factory CharacterMoment.fromJson(Map<String, dynamic> json) {
    return CharacterMoment(
      momentId: json['momentId'] as String,
      momentName: json['momentName'] as String,
      description: json['description'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      sessionDay: json['sessionDay'] as int,
      transformationImpact: json['transformationImpact'] as int,
      momentType: MomentType.values.firstWhere(
        (e) => e.name == json['momentType'],
        orElse: () => MomentType.decision,
      ),
      narrativeDescription: json['narrativeDescription'] as String,
    );
  }
}

enum MomentType {
  decision, // Character made important choice
  revelation, // Character learned something important
  loss, // Character lost something/someone
  triumph, // Character achieved something
  betrayal, // Character was betrayed
  sacrifice, // Character gave up something important
}

/// Growth milestone - mechanical character advancement milestone
class GrowthMilestone {
  final String milestoneId;
  final String milestoneName;
  final String characterId;
  final int characterLevel; // Level this milestone occurred at
  final DateTime achievedDate;
  final int sessionDay;

  // What was gained
  final List<String> newAbilities;
  final List<String> newFeats;
  final Map<String, int> abilityScoreImprovements;
  final String? narrativeSignificance; // Story reason for this growth

  GrowthMilestone({
    required this.milestoneId,
    required this.milestoneName,
    required this.characterId,
    required this.characterLevel,
    required this.achievedDate,
    required this.sessionDay,
    List<String>? newAbilities,
    List<String>? newFeats,
    Map<String, int>? abilityScoreImprovements,
    this.narrativeSignificance,
  })  : newAbilities = newAbilities ?? [],
        newFeats = newFeats ?? [],
        abilityScoreImprovements = abilityScoreImprovements ?? {};

  Map<String, dynamic> toJson() => {
        'milestoneId': milestoneId,
        'milestoneName': milestoneName,
        'characterId': characterId,
        'characterLevel': characterLevel,
        'achievedDate': achievedDate.toIso8601String(),
        'sessionDay': sessionDay,
        'newAbilities': newAbilities,
        'newFeats': newFeats,
        'abilityScoreImprovements': abilityScoreImprovements,
        'narrativeSignificance': narrativeSignificance,
      };

  factory GrowthMilestone.fromJson(Map<String, dynamic> json) {
    return GrowthMilestone(
      milestoneId: json['milestoneId'] as String,
      milestoneName: json['milestoneName'] as String,
      characterId: json['characterId'] as String,
      characterLevel: json['characterLevel'] as int,
      achievedDate: DateTime.parse(json['achievedDate'] as String),
      sessionDay: json['sessionDay'] as int,
      newAbilities: (json['newAbilities'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      newFeats: (json['newFeats'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      abilityScoreImprovements: (json['abilityScoreImprovements'] as Map<String, dynamic>?)
              ?.map((key, value) => MapEntry(key, value as int)) ??
          {},
      narrativeSignificance: json['narrativeSignificance'] as String?,
    );
  }
}
