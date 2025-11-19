import 'package:eden_preprocessor_demo/models/character_development.dart';
import 'package:uuid/uuid.dart';

/// Service for managing character arcs, personal quests, and growth milestones
class CharacterArcService {
  final Map<String, List<PersonalQuest>> _characterPersonalQuests = {}; // characterId -> quests
  final Map<String, List<CharacterArc>> _characterArcs = {}; // characterId -> arcs
  final Map<String, List<GrowthMilestone>> _characterGrowthMilestones = {}; // characterId -> milestones

  final Uuid _uuid = const Uuid();

  /// Create a personal quest for a character
  PersonalQuest createPersonalQuest({
    required String characterId,
    required String questName,
    required PersonalQuestType questType,
    required String backstoryHook,
    required String motivation,
    required String description,
    List<QuestObjective>? questObjectives,
    List<QuestMilestone>? questMilestones,
    String? successConsequence,
    String? failureConsequence,
    bool canFail = true,
    Map<String, int>? relationshipImpacts,
    List<String>? potentialRewards,
    String? characterGrowth,
    int? timeLimit,
  }) {
    var personalQuest = PersonalQuest(
      questId: _uuid.v4(),
      questName: questName,
      characterId: characterId,
      questType: questType,
      backstoryHook: backstoryHook,
      motivation: motivation,
      description: description,
      questObjectives: questObjectives,
      questMilestones: questMilestones,
      successConsequence: successConsequence,
      failureConsequence: failureConsequence,
      canFail: canFail,
      relationshipImpacts: relationshipImpacts,
      potentialRewards: potentialRewards,
      characterGrowth: characterGrowth,
      timeLimit: timeLimit,
      daysRemaining: timeLimit,
    );

    _characterPersonalQuests.putIfAbsent(characterId, () => []).add(personalQuest);
    return personalQuest;
  }

  /// Get all personal quests for a character
  List<PersonalQuest> getPersonalQuests(String characterId) {
    return _characterPersonalQuests[characterId] ?? [];
  }

  /// Get active personal quests for a character
  List<PersonalQuest> getActivePersonalQuests(String characterId) {
    return getPersonalQuests(characterId)
        .where((q) => q.questStatus == PersonalQuestStatus.active ||
            q.questStatus == PersonalQuestStatus.progressing)
        .toList();
  }

  /// Get personal quest by ID
  PersonalQuest? getPersonalQuestById(String questId) {
    for (var questsList in _characterPersonalQuests.values) {
      try {
        return questsList.firstWhere((q) => q.questId == questId);
      } catch (e) {
        continue;
      }
    }
    return null;
  }

  /// Complete a quest objective
  void completeQuestObjective(String questId, String objectiveId) {
    var personalQuest = getPersonalQuestById(questId);
    personalQuest?.completeObjective(objectiveId);
  }

  /// Reach a quest milestone
  void reachQuestMilestone(String questId, String milestoneId) {
    var personalQuest = getPersonalQuestById(questId);
    personalQuest?.reachMilestone(milestoneId);
  }

  /// Activate a personal quest
  void activatePersonalQuest(String questId) {
    var personalQuest = getPersonalQuestById(questId);
    if (personalQuest != null) {
      personalQuest.questStatus = PersonalQuestStatus.active;
    }
  }

  /// Complete a personal quest
  void completePersonalQuest(String questId) {
    var personalQuest = getPersonalQuestById(questId);
    personalQuest?.complete();
  }

  /// Fail a personal quest
  void failPersonalQuest(String questId) {
    var personalQuest = getPersonalQuestById(questId);
    personalQuest?.fail();
  }

  /// Update quest time limits (call daily)
  void updateQuestTimeLimit(int currentGameDay) {
    for (var questsList in _characterPersonalQuests.values) {
      for (var personalQuest in questsList) {
        if (personalQuest.daysRemaining != null && personalQuest.daysRemaining! > 0) {
          personalQuest.daysRemaining = personalQuest.daysRemaining! - 1;

          if (personalQuest.daysRemaining == 0 && personalQuest.canFail) {
            failPersonalQuest(personalQuest.questId);
          }
        }
      }
    }
  }

  /// Create a character arc
  CharacterArc createCharacterArc({
    required String characterId,
    required String arcName,
    required ArcType arcType,
    required String startingState,
    required String endingState,
    required String thematicFocus,
    List<ArcStageDefinition>? arcStages,
    List<String>? relatedQuestIds,
    List<String>? relatedNPCIds,
  }) {
    var characterArc = CharacterArc(
      arcId: _uuid.v4(),
      arcName: arcName,
      characterId: characterId,
      arcType: arcType,
      startingState: startingState,
      endingState: endingState,
      thematicFocus: thematicFocus,
      arcStages: arcStages,
      relatedQuestIds: relatedQuestIds,
      relatedNPCIds: relatedNPCIds,
    );

    _characterArcs.putIfAbsent(characterId, () => []).add(characterArc);
    return characterArc;
  }

  /// Get all character arcs
  List<CharacterArc> getCharacterArcs(String characterId) {
    return _characterArcs[characterId] ?? [];
  }

  /// Get active character arc (the primary one)
  CharacterArc? getActiveCharacterArc(String characterId) {
    var characterArcs = getCharacterArcs(characterId);
    return characterArcs.isNotEmpty ? characterArcs.first : null;
  }

  /// Get character arc by ID
  CharacterArc? getCharacterArcById(String arcId) {
    for (var arcsList in _characterArcs.values) {
      try {
        return arcsList.firstWhere((a) => a.arcId == arcId);
      } catch (e) {
        continue;
      }
    }
    return null;
  }

  /// Advance character arc stage
  void advanceArcStage(String arcId) {
    var characterArc = getCharacterArcById(arcId);
    characterArc?.advanceStage();
  }

  /// Add key moment to character arc
  void addKeyMomentToArc({
    required String arcId,
    required String momentName,
    required String description,
    required int sessionDay,
    required int transformationImpact,
    required MomentType momentType,
    required String narrativeDescription,
  }) {
    var characterArc = getCharacterArcById(arcId);
    if (characterArc != null) {
      var moment = CharacterMoment(
        momentId: _uuid.v4(),
        momentName: momentName,
        description: description,
        timestamp: DateTime.now(),
        sessionDay: sessionDay,
        transformationImpact: transformationImpact,
        momentType: momentType,
        narrativeDescription: narrativeDescription,
      );

      characterArc.addKeyMoment(moment);
    }
  }

  /// Record growth milestone
  void recordGrowthMilestone({
    required String characterId,
    required String milestoneName,
    required int characterLevel,
    required int sessionDay,
    List<String>? newAbilities,
    List<String>? newFeats,
    Map<String, int>? abilityScoreImprovements,
    String? narrativeSignificance,
  }) {
    var growthMilestone = GrowthMilestone(
      milestoneId: _uuid.v4(),
      milestoneName: milestoneName,
      characterId: characterId,
      characterLevel: characterLevel,
      achievedDate: DateTime.now(),
      sessionDay: sessionDay,
      newAbilities: newAbilities,
      newFeats: newFeats,
      abilityScoreImprovements: abilityScoreImprovements,
      narrativeSignificance: narrativeSignificance,
    );

    _characterGrowthMilestones.putIfAbsent(characterId, () => []).add(growthMilestone);
  }

  /// Get growth milestones for character
  List<GrowthMilestone> getGrowthMilestones(String characterId) {
    return _characterGrowthMilestones[characterId] ?? [];
  }

  /// Get recent growth milestones
  List<GrowthMilestone> getRecentGrowthMilestones(String characterId, int count) {
    var growthMilestones = getGrowthMilestones(characterId);
    return growthMilestones.reversed.take(count).toList();
  }

  /// Get character development summary for AI context
  String getCharacterDevelopmentSummary(String characterId) {
    var summary = StringBuffer();

    // Active Arc
    var activeArc = getActiveCharacterArc(characterId);
    if (activeArc != null) {
      summary.writeln('Character Arc: ${activeArc.arcName} (${activeArc.arcType.name})');
      summary.writeln('Current Stage: ${activeArc.currentStage.name}');
      summary.writeln('Focus: ${activeArc.thematicFocus}');
      summary.writeln('Transformation: ${activeArc.transformationLevel}%');

      if (activeArc.keyMoments.isNotEmpty) {
        summary.writeln('\nRecent Key Moments:');
        for (var moment in activeArc.keyMoments.reversed.take(3)) {
          summary.writeln('- ${moment.momentName}: ${moment.description}');
        }
      }
    }

    // Active Personal Quests
    var activeQuests = getActivePersonalQuests(characterId);
    if (activeQuests.isNotEmpty) {
      summary.writeln('\nActive Personal Quests:');
      for (var personalQuest in activeQuests) {
        summary.writeln('- ${personalQuest.questName} (${personalQuest.questType.name})');
        summary.writeln('  Motivation: ${personalQuest.motivation}');
        summary.writeln('  Progress: ${personalQuest.progressPercentage}%');
        if (personalQuest.daysRemaining != null) {
          summary.writeln('  Time Remaining: ${personalQuest.daysRemaining} days');
        }
      }
    }

    // Recent Growth
    var recentGrowth = getRecentGrowthMilestones(characterId, 3);
    if (recentGrowth.isNotEmpty) {
      summary.writeln('\nRecent Growth:');
      for (var growthMilestone in recentGrowth) {
        summary.writeln('- Level ${growthMilestone.characterLevel}: ${growthMilestone.milestoneName}');
        if (growthMilestone.narrativeSignificance != null) {
          summary.writeln('  ${growthMilestone.narrativeSignificance}');
        }
      }
    }

    return summary.toString();
  }

  /// Check if character has quest of a certain type
  bool hasQuestType(String characterId, PersonalQuestType questType) {
    var personalQuests = getPersonalQuests(characterId);
    return personalQuests.any((q) => q.questType == questType);
  }

  /// Get quest by type
  PersonalQuest? getQuestByType(String characterId, PersonalQuestType questType) {
    var personalQuests = getPersonalQuests(characterId);
    try {
      return personalQuests.firstWhere((q) => q.questType == questType);
    } catch (e) {
      return null;
    }
  }

  /// Link quest to arc
  void linkQuestToArc(String questId, String arcId) {
    var characterArc = getCharacterArcById(arcId);
    var personalQuest = getPersonalQuestById(questId);

    if (characterArc != null && personalQuest != null) {
      if (!characterArc.relatedQuestIds.contains(questId)) {
        characterArc.relatedQuestIds.add(questId);
      }
    }
  }

  /// Get quests related to an arc
  List<PersonalQuest> getQuestsForArc(String arcId) {
    var characterArc = getCharacterArcById(arcId);
    if (characterArc == null) return [];

    List<PersonalQuest> relatedQuests = [];
    for (var questId in characterArc.relatedQuestIds) {
      var personalQuest = getPersonalQuestById(questId);
      if (personalQuest != null) {
        relatedQuests.add(personalQuest);
      }
    }

    return relatedQuests;
  }

  /// Calculate overall character development score
  int calculateDevelopmentScore(String characterId) {
    int score = 0;

    // Arc transformation
    var activeArc = getActiveCharacterArc(characterId);
    if (activeArc != null) {
      score += activeArc.transformationLevel;
    }

    // Quest completion
    var personalQuests = getPersonalQuests(characterId);
    var completedQuests = personalQuests.where((q) => q.questStatus == PersonalQuestStatus.completed).length;
    score += completedQuests * 10;

    // Key moments
    if (activeArc != null) {
      score += activeArc.keyMoments.length * 5;
    }

    return score;
  }
}
