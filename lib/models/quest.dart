import 'monster.dart';
import 'item.dart';
import '../services/procedural_generation.dart';

enum QuestStatus {
  notStarted,
  active,
  completed,
  failed,
}

enum QuestType {
  kill, // Kill specific monsters/boss
  fetch, // Retrieve an item
  escort, // Escort NPC to location
  investigate, // Investigate mystery/location
  rescue, // Rescue captured NPC
  delivery, // Deliver item to NPC
  explore, // Explore location
  defend, // Defend location from waves
  persuade, // Convince NPC through dialogue
  puzzle, // Solve puzzle or riddle
}

class QuestObjective {
  String id;
  String description;
  bool isCompleted;
  bool isOptional; // Optional objectives grant bonus rewards

  // Objective-specific data
  String? targetMonsterId;
  int? targetMonsterCount;
  int? currentMonsterCount;
  String? targetItemId;
  String? targetNPCId;
  String? targetLocationId;
  Map<String, dynamic>? customData;

  QuestObjective({
    required this.id,
    required this.description,
    this.isCompleted = false,
    this.isOptional = false,
    this.targetMonsterId,
    this.targetMonsterCount,
    this.currentMonsterCount,
    this.targetItemId,
    this.targetNPCId,
    this.targetLocationId,
    this.customData,
  });

  void updateProgress({
    String? monsterId,
    String? itemId,
    bool? npcReached,
    bool? locationReached,
  }) {
    if (monsterId != null && monsterId == targetMonsterId) {
      currentMonsterCount = (currentMonsterCount ?? 0) + 1;
      if (currentMonsterCount! >= (targetMonsterCount ?? 1)) {
        isCompleted = true;
      }
    }

    if (itemId != null && itemId == targetItemId) {
      isCompleted = true;
    }

    if (npcReached == true && targetNPCId != null) {
      isCompleted = true;
    }

    if (locationReached == true && targetLocationId != null) {
      isCompleted = true;
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'description': description,
        'isCompleted': isCompleted,
        'isOptional': isOptional,
        'targetMonsterId': targetMonsterId,
        'targetMonsterCount': targetMonsterCount,
        'currentMonsterCount': currentMonsterCount,
        'targetItemId': targetItemId,
        'targetNPCId': targetNPCId,
        'targetLocationId': targetLocationId,
        'customData': customData,
      };

  factory QuestObjective.fromJson(Map<String, dynamic> json) => QuestObjective(
        id: json['id'] as String,
        description: json['description'] as String,
        isCompleted: json['isCompleted'] as bool? ?? false,
        isOptional: json['isOptional'] as bool? ?? false,
        targetMonsterId: json['targetMonsterId'] as String?,
        targetMonsterCount: json['targetMonsterCount'] as int?,
        currentMonsterCount: json['currentMonsterCount'] as int?,
        targetItemId: json['targetItemId'] as String?,
        targetNPCId: json['targetNPCId'] as String?,
        targetLocationId: json['targetLocationId'] as String?,
        customData: json['customData'] as Map<String, dynamic>?,
      );
}

class QuestReward {
  int experiencePoints;
  int goldPieces;
  List<Item> items;
  int? reputationChange; // For faction system
  String? factionId;
  String? unlockQuestId; // Unlocks follow-up quest

  QuestReward({
    required this.experiencePoints,
    required this.goldPieces,
    List<Item>? items,
    this.reputationChange,
    this.factionId,
    this.unlockQuestId,
  }) : items = items ?? [];

  Map<String, dynamic> toJson() => {
        'experiencePoints': experiencePoints,
        'goldPieces': goldPieces,
        'items': items.map((i) => i.toJson()).toList(),
        'reputationChange': reputationChange,
        'factionId': factionId,
        'unlockQuestId': unlockQuestId,
      };

  factory QuestReward.fromJson(Map<String, dynamic> json) => QuestReward(
        experiencePoints: json['experiencePoints'] as int,
        goldPieces: json['goldPieces'] as int,
        items: (json['items'] as List<dynamic>?)
                ?.map((i) => Item.fromJson(i as Map<String, dynamic>))
                .toList() ??
            [],
        reputationChange: json['reputationChange'] as int?,
        factionId: json['factionId'] as String?,
        unlockQuestId: json['unlockQuestId'] as String?,
      );
}

class QuestBranch {
  String id;
  String choiceDescription; // The choice the player makes
  String resultDescription; // What happens after choice
  List<QuestObjective> additionalObjectives; // New objectives from this branch
  QuestReward? bonusReward;

  QuestBranch({
    required this.id,
    required this.choiceDescription,
    required this.resultDescription,
    List<QuestObjective>? additionalObjectives,
    this.bonusReward,
  }) : additionalObjectives = additionalObjectives ?? [];

  Map<String, dynamic> toJson() => {
        'id': id,
        'choiceDescription': choiceDescription,
        'resultDescription': resultDescription,
        'additionalObjectives':
            additionalObjectives.map((o) => o.toJson()).toList(),
        'bonusReward': bonusReward?.toJson(),
      };

  factory QuestBranch.fromJson(Map<String, dynamic> json) => QuestBranch(
        id: json['id'] as String,
        choiceDescription: json['choiceDescription'] as String,
        resultDescription: json['resultDescription'] as String,
        additionalObjectives: (json['additionalObjectives'] as List<dynamic>?)
                ?.map((o) => QuestObjective.fromJson(o as Map<String, dynamic>))
                .toList() ??
            [],
        bonusReward: json['bonusReward'] != null
            ? QuestReward.fromJson(json['bonusReward'] as Map<String, dynamic>)
            : null,
      );
}

class Quest {
  String id;
  String name;
  String description;
  QuestType type;
  QuestStatus status;
  int recommendedLevel; // Suggested party level
  String? questGiverNPCId; // Who gave the quest
  NPC? questGiver;

  List<QuestObjective> objectives;
  List<QuestBranch> branches; // Branching storylines
  String? selectedBranchId; // Which branch was chosen

  QuestReward mainReward;
  QuestReward? bonusReward; // For completing optional objectives

  // Story elements
  String? loreBackground;
  List<String>? dialogueOptions;
  Map<String, String>? npcDialogue; // npcId -> dialogue text

  // Related content
  Dungeon? relatedDungeon;
  List<NPC> relatedNPCs;
  List<Monster> relatedMonsters;

  // Quest chain
  String? previousQuestId;
  String? nextQuestId;

  // Time limits (optional)
  int? timeLimit; // In game days
  int? daysElapsed;

  Quest({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    this.status = QuestStatus.notStarted,
    required this.recommendedLevel,
    this.questGiverNPCId,
    this.questGiver,
    required this.objectives,
    List<QuestBranch>? branches,
    this.selectedBranchId,
    required this.mainReward,
    this.bonusReward,
    this.loreBackground,
    this.dialogueOptions,
    this.npcDialogue,
    this.relatedDungeon,
    List<NPC>? relatedNPCs,
    List<Monster>? relatedMonsters,
    this.previousQuestId,
    this.nextQuestId,
    this.timeLimit,
    this.daysElapsed,
  })  : branches = branches ?? [],
        relatedNPCs = relatedNPCs ?? [],
        relatedMonsters = relatedMonsters ?? [];

  bool areAllObjectivesComplete({bool includeOptional = false}) {
    if (includeOptional) {
      return objectives.every((o) => o.isCompleted);
    } else {
      return objectives.where((o) => !o.isOptional).every((o) => o.isCompleted);
    }
  }

  bool areAllOptionalObjectivesComplete() {
    var optionals = objectives.where((o) => o.isOptional);
    return optionals.isNotEmpty && optionals.every((o) => o.isCompleted);
  }

  void selectBranch(String branchId) {
    var branch = branches.firstWhere((b) => b.id == branchId);
    selectedBranchId = branchId;
    objectives.addAll(branch.additionalObjectives);
  }

  void completeQuest() {
    status = QuestStatus.completed;
  }

  void failQuest() {
    status = QuestStatus.failed;
  }

  void advanceTime({int days = 1}) {
    daysElapsed = (daysElapsed ?? 0) + days;
    if (timeLimit != null && daysElapsed! >= timeLimit!) {
      failQuest();
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'type': type.toString(),
        'status': status.toString(),
        'recommendedLevel': recommendedLevel,
        'questGiverNPCId': questGiverNPCId,
        'questGiver': questGiver?.toJson(),
        'objectives': objectives.map((o) => o.toJson()).toList(),
        'branches': branches.map((b) => b.toJson()).toList(),
        'selectedBranchId': selectedBranchId,
        'mainReward': mainReward.toJson(),
        'bonusReward': bonusReward?.toJson(),
        'loreBackground': loreBackground,
        'dialogueOptions': dialogueOptions,
        'npcDialogue': npcDialogue,
        'relatedDungeon': relatedDungeon?.toJson(),
        'relatedNPCs': relatedNPCs.map((n) => n.toJson()).toList(),
        'relatedMonsters': relatedMonsters.map((m) => m.toJson()).toList(),
        'previousQuestId': previousQuestId,
        'nextQuestId': nextQuestId,
        'timeLimit': timeLimit,
        'daysElapsed': daysElapsed,
      };

  factory Quest.fromJson(Map<String, dynamic> json) => Quest(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        type: QuestType.values.firstWhere(
            (t) => t.toString() == json['type'],
            orElse: () => QuestType.kill),
        status: QuestStatus.values.firstWhere(
            (s) => s.toString() == json['status'],
            orElse: () => QuestStatus.notStarted),
        recommendedLevel: json['recommendedLevel'] as int,
        questGiverNPCId: json['questGiverNPCId'] as String?,
        questGiver: json['questGiver'] != null
            ? NPC.fromJson(json['questGiver'] as Map<String, dynamic>)
            : null,
        objectives: (json['objectives'] as List<dynamic>)
            .map((o) => QuestObjective.fromJson(o as Map<String, dynamic>))
            .toList(),
        branches: (json['branches'] as List<dynamic>?)
                ?.map((b) => QuestBranch.fromJson(b as Map<String, dynamic>))
                .toList() ??
            [],
        selectedBranchId: json['selectedBranchId'] as String?,
        mainReward:
            QuestReward.fromJson(json['mainReward'] as Map<String, dynamic>),
        bonusReward: json['bonusReward'] != null
            ? QuestReward.fromJson(json['bonusReward'] as Map<String, dynamic>)
            : null,
        loreBackground: json['loreBackground'] as String?,
        dialogueOptions: (json['dialogueOptions'] as List<dynamic>?)?.cast<String>(),
        npcDialogue: (json['npcDialogue'] as Map<String, dynamic>?)?.cast<String, String>(),
        relatedDungeon: json['relatedDungeon'] != null
            ? Dungeon.fromJson(json['relatedDungeon'] as Map<String, dynamic>)
            : null,
        relatedNPCs: (json['relatedNPCs'] as List<dynamic>?)
                ?.map((n) => NPC.fromJson(n as Map<String, dynamic>))
                .toList() ??
            [],
        relatedMonsters: (json['relatedMonsters'] as List<dynamic>?)
                ?.map((m) => Monster.fromJson(m as Map<String, dynamic>))
                .toList() ??
            [],
        previousQuestId: json['previousQuestId'] as String?,
        nextQuestId: json['nextQuestId'] as String?,
        timeLimit: json['timeLimit'] as int?,
        daysElapsed: json['daysElapsed'] as int?,
      );
}
