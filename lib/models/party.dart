import 'enhanced_character.dart';
import 'item.dart';
import 'quest.dart';

enum LootDistribution {
  equal, // Split equally
  needBefore Greed, // Based on usefulness
  rollingContest, // Roll for items
  leaderDecides, // Party leader distributes
}

class Party {
  String id;
  String name;
  List<EnhancedCharacter> members;
  EnhancedCharacter? leader; // Party leader/face

  // Shared Resources
  int partyGold;
  List<Item> partyInventory; // Shared inventory
  LootDistribution lootMode;

  // Active Quests
  List<Quest> activeQuests;
  List<Quest> completedQuests;

  // Party Stats
  int totalCombatEncounters;
  int totalMonstersDefeated;
  int totalGoldEarned;
  int totalExperienceEarned;

  // Resting
  bool hasShortRest;
  bool hasLongRest;

  // Party Formation (for tactical combat)
  Map<String, String> formation; // characterId -> position ('front', 'middle', 'back')

  Party({
    required this.id,
    required this.name,
    List<EnhancedCharacter>? members,
    this.leader,
    this.partyGold = 0,
    List<Item>? partyInventory,
    this.lootMode = LootDistribution.equal,
    List<Quest>? activeQuests,
    List<Quest>? completedQuests,
    this.totalCombatEncounters = 0,
    this.totalMonstersDefeated = 0,
    this.totalGoldEarned = 0,
    this.totalExperienceEarned = 0,
    this.hasShortRest = true,
    this.hasLongRest = true,
    Map<String, String>? formation,
  })  : members = members ?? [],
        partyInventory = partyInventory ?? [],
        activeQuests = activeQuests ?? [],
        completedQuests = completedQuests ?? [],
        formation = formation ?? {};

  // ==================== MEMBER MANAGEMENT ====================

  void addMember(EnhancedCharacter character) {
    if (members.length >= 6) {
      throw Exception('Party is full (max 6 members)');
    }
    members.add(character);

    // Auto-assign formation based on class
    if (character.characterClass.id == 'fighter' ||
        character.characterClass.id == 'barbarian' ||
        character.characterClass.id == 'paladin') {
      formation[character.id!] = 'front';
    } else if (character.characterClass.id == 'wizard' ||
               character.characterClass.id == 'sorcerer' ||
               character.characterClass.id == 'warlock') {
      formation[character.id!] = 'back';
    } else {
      formation[character.id!] = 'middle';
    }
  }

  void removeMember(String characterId) {
    members.removeWhere((c) => c.id == characterId);
    formation.remove(characterId);
    if (leader?.id == characterId) {
      leader = members.isNotEmpty ? members.first : null;
    }
  }

  void setLeader(String characterId) {
    leader = members.firstWhere((c) => c.id == characterId);
  }

  // ==================== PARTY STATS ====================

  int get averageLevel {
    if (members.isEmpty) return 0;
    return members.map((c) => c.level).reduce((a, b) => a + b) ~/ members.length;
  }

  int get totalHitPoints {
    return members.map((c) => c.hitPointsCurrent).reduce((a, b) => a + b);
  }

  int get maxHitPoints {
    return members.map((c) => c.hitPointsMax).reduce((a, b) => a + b);
  }

  bool get isHealthy {
    return totalHitPoints >= (maxHitPoints * 0.75).round();
  }

  bool get needsRest {
    return members.any((c) => c.hitPointsCurrent < c.hitPointsMax * 0.5);
  }

  List<EnhancedCharacter> get frontLine {
    return members.where((c) => formation[c.id] == 'front').toList();
  }

  List<EnhancedCharacter> get middleLine {
    return members.where((c) => formation[c.id] == 'middle').toList();
  }

  List<EnhancedCharacter> get backLine {
    return members.where((c) => formation[c.id] == 'back').toList();
  }

  // ==================== EXPERIENCE & LEVELING ====================

  void distributeExperience(int totalXP) {
    int xpPerMember = totalXP ~/ members.length;
    totalExperienceEarned += totalXP;

    for (var member in members) {
      // Check if member should level up
      int currentLevel = member.level;
      // Simple XP formula: level * 300 per level
      int xpNeeded = member.level * 300;

      if (xpPerMember >= xpNeeded) {
        member.levelUp();
      }
    }
  }

  // ==================== GOLD & LOOT MANAGEMENT ====================

  void addGold(int amount) {
    partyGold += amount;
    totalGoldEarned += amount;
  }

  void spendGold(int amount) {
    if (partyGold < amount) {
      throw Exception('Not enough gold');
    }
    partyGold -= amount;
  }

  void addToPartyInventory(Item item) {
    partyInventory.add(item);
  }

  void distributeLoot(List<Item> loot) {
    switch (lootMode) {
      case LootDistribution.equal:
        _distributeEqually(loot);
        break;
      case LootDistribution.needBeforeGreed:
        _distributeByNeed(loot);
        break;
      case LootDistribution.rollingContest:
        _distributeByRoll(loot);
        break;
      case LootDistribution.leaderDecides:
        // Items go to party inventory for leader to distribute
        partyInventory.addAll(loot);
        break;
    }
  }

  void _distributeEqually(List<Item> loot) {
    // Currency goes to party gold
    for (var item in loot) {
      if (item.type == 'currency') {
        addGold(item.value);
      }
    }

    // Other items go to party inventory
    var nonCurrency = loot.where((i) => i.type != 'currency').toList();
    partyInventory.addAll(nonCurrency);
  }

  void _distributeByNeed(List<Item> loot) {
    for (var item in loot) {
      if (item.type == 'currency') {
        addGold(item.value);
        continue;
      }

      // Find member who can best use this item
      EnhancedCharacter? bestUser;

      if (item.type == 'weapon') {
        bestUser = members.firstWhere(
          (c) => c.characterClass.id == 'fighter' ||
                 c.characterClass.id == 'barbarian',
          orElse: () => members.first,
        );
      } else if (item.type == 'armor') {
        bestUser = members.firstWhere(
          (c) => c.characterClass.id == 'fighter' ||
                 c.characterClass.id == 'paladin',
          orElse: () => members.first,
        );
      } else if (item.type == 'wand' || item.type == 'staff') {
        bestUser = members.firstWhere(
          (c) => c.characterClass.id == 'wizard' ||
                 c.characterClass.id == 'sorcerer',
          orElse: () => members.first,
        );
      } else {
        partyInventory.add(item);
        continue;
      }

      bestUser.inventory.add(item);
    }
  }

  void _distributeByRoll(List<Item> loot) {
    // Simple implementation: random member gets each item
    for (var item in loot) {
      if (item.type == 'currency') {
        addGold(item.value);
        continue;
      }

      members[DateTime.now().millisecond % members.length].inventory.add(item);
    }
  }

  // ==================== RESTING ====================

  void shortRest() {
    if (!hasShortRest) {
      throw Exception('Party has already taken a short rest');
    }

    for (var member in members) {
      member.shortRest();
    }

    hasShortRest = false;
  }

  void longRest() {
    for (var member in members) {
      member.longRest();
    }

    hasShortRest = true;
    hasLongRest = true;
  }

  // ==================== QUEST MANAGEMENT ====================

  void acceptQuest(Quest quest) {
    if (!activeQuests.any((q) => q.id == quest.id)) {
      quest.status = QuestStatus.active;
      activeQuests.add(quest);
    }
  }

  void completeQuest(String questId) {
    var quest = activeQuests.firstWhere((q) => q.id == questId);
    quest.completeQuest();

    // Distribute rewards
    distributeExperience(quest.mainReward.experiencePoints);
    addGold(quest.mainReward.goldPieces);
    distributeLoot(quest.mainReward.items);

    // Bonus rewards if all optional objectives complete
    if (quest.areAllOptionalObjectivesComplete() && quest.bonusReward != null) {
      distributeExperience(quest.bonusReward!.experiencePoints);
      addGold(quest.bonusReward!.goldPieces);
      distributeLoot(quest.bonusReward!.items);
    }

    activeQuests.removeWhere((q) => q.id == questId);
    completedQuests.add(quest);
  }

  void abandonQuest(String questId) {
    activeQuests.removeWhere((q) => q.id == questId);
  }

  // ==================== COMBAT TRACKING ====================

  void recordCombatEncounter({
    required int monstersDefeated,
    required int experienceGained,
    required int goldGained,
    List<Item>? loot,
  }) {
    totalCombatEncounters++;
    totalMonstersDefeated += monstersDefeated;
    distributeExperience(experienceGained);
    addGold(goldGained);

    if (loot != null && loot.isNotEmpty) {
      distributeLoot(loot);
    }
  }

  // ==================== PARTY COMPOSITION ====================

  bool get hasHealer {
    return members.any((c) =>
      c.characterClass.id == 'cleric' ||
      c.characterClass.id == 'druid' ||
      c.characterClass.id == 'bard'
    );
  }

  bool get hasTank {
    return members.any((c) =>
      c.characterClass.id == 'fighter' ||
      c.characterClass.id == 'barbarian' ||
      c.characterClass.id == 'paladin'
    );
  }

  bool get hasCaster {
    return members.any((c) =>
      c.characterClass.id == 'wizard' ||
      c.characterClass.id == 'sorcerer' ||
      c.characterClass.id == 'warlock'
    );
  }

  bool get isBalanced {
    return hasHealer && hasTank && hasCaster;
  }

  String get compositionSuggestion {
    List<String> missing = [];
    if (!hasHealer) missing.add('Healer (Cleric/Druid/Bard)');
    if (!hasTank) missing.add('Tank (Fighter/Barbarian/Paladin)');
    if (!hasCaster) missing.add('Caster (Wizard/Sorcerer/Warlock)');

    if (missing.isEmpty) {
      return 'Party composition is balanced!';
    } else {
      return 'Consider adding: ${missing.join(', ')}';
    }
  }

  // ==================== SERIALIZATION ====================

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'members': members.map((m) => m.toJson()).toList(),
        'leader': leader?.toJson(),
        'partyGold': partyGold,
        'partyInventory': partyInventory.map((i) => i.toJson()).toList(),
        'lootMode': lootMode.toString(),
        'activeQuests': activeQuests.map((q) => q.toJson()).toList(),
        'completedQuests': completedQuests.map((q) => q.toJson()).toList(),
        'totalCombatEncounters': totalCombatEncounters,
        'totalMonstersDefeated': totalMonstersDefeated,
        'totalGoldEarned': totalGoldEarned,
        'totalExperienceEarned': totalExperienceEarned,
        'hasShortRest': hasShortRest,
        'hasLongRest': hasLongRest,
        'formation': formation,
      };

  factory Party.fromJson(Map<String, dynamic> json) => Party(
        id: json['id'] as String,
        name: json['name'] as String,
        members: (json['members'] as List<dynamic>)
            .map((m) => EnhancedCharacter.fromJson(m as Map<String, dynamic>))
            .toList(),
        leader: json['leader'] != null
            ? EnhancedCharacter.fromJson(json['leader'] as Map<String, dynamic>)
            : null,
        partyGold: json['partyGold'] as int? ?? 0,
        partyInventory: (json['partyInventory'] as List<dynamic>?)
                ?.map((i) => Item.fromJson(i as Map<String, dynamic>))
                .toList() ??
            [],
        lootMode: LootDistribution.values.firstWhere(
          (l) => l.toString() == json['lootMode'],
          orElse: () => LootDistribution.equal,
        ),
        activeQuests: (json['activeQuests'] as List<dynamic>?)
                ?.map((q) => Quest.fromJson(q as Map<String, dynamic>))
                .toList() ??
            [],
        completedQuests: (json['completedQuests'] as List<dynamic>?)
                ?.map((q) => Quest.fromJson(q as Map<String, dynamic>))
                .toList() ??
            [],
        totalCombatEncounters: json['totalCombatEncounters'] as int? ?? 0,
        totalMonstersDefeated: json['totalMonstersDefeated'] as int? ?? 0,
        totalGoldEarned: json['totalGoldEarned'] as int? ?? 0,
        totalExperienceEarned: json['totalExperienceEarned'] as int? ?? 0,
        hasShortRest: json['hasShortRest'] as bool? ?? true,
        hasLongRest: json['hasLongRest'] as bool? ?? true,
        formation:
            (json['formation'] as Map<String, dynamic>?)?.cast<String, String>() ?? {},
      );
}
