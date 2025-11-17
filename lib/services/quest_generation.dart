import 'dart:math';
import '../models/quest.dart';
import '../models/item.dart';
import '../models/monster.dart';
import 'procedural_generation.dart';
import '../data/magic_items.dart';

class QuestGenerator {
  static final Random _rng = Random();

  /// Generate a random quest based on party level
  static Quest generate({
    required int partyLevel,
    QuestType? preferredType,
    String? theme, // 'undead', 'goblin', 'dragon', etc.
  }) {
    QuestType questType = preferredType ?? _selectRandomQuestType();

    switch (questType) {
      case QuestType.kill:
        return _generateKillQuest(partyLevel, theme);
      case QuestType.fetch:
        return _generateFetchQuest(partyLevel, theme);
      case QuestType.escort:
        return _generateEscortQuest(partyLevel, theme);
      case QuestType.investigate:
        return _generateInvestigateQuest(partyLevel, theme);
      case QuestType.rescue:
        return _generateRescueQuest(partyLevel, theme);
      case QuestType.delivery:
        return _generateDeliveryQuest(partyLevel, theme);
      case QuestType.explore:
        return _generateExploreQuest(partyLevel, theme);
      case QuestType.defend:
        return _generateDefendQuest(partyLevel, theme);
      case QuestType.persuade:
        return _generatePersuadeQuest(partyLevel, theme);
      case QuestType.puzzle:
        return _generatePuzzleQuest(partyLevel, theme);
    }
  }

  static QuestType _selectRandomQuestType() {
    double roll = _rng.nextDouble();
    if (roll < 0.25) return QuestType.kill;
    if (roll < 0.40) return QuestType.fetch;
    if (roll < 0.50) return QuestType.escort;
    if (roll < 0.60) return QuestType.investigate;
    if (roll < 0.70) return QuestType.rescue;
    if (roll < 0.80) return QuestType.delivery;
    if (roll < 0.85) return QuestType.explore;
    if (roll < 0.90) return QuestType.defend;
    if (roll < 0.95) return QuestType.persuade;
    return QuestType.puzzle;
  }

  // ==================== KILL QUEST ====================
  static Quest _generateKillQuest(int partyLevel, String? theme) {
    theme ??= _selectTheme();
    NPC questGiver = NPCGenerator.generate();

    String bossName = _generateBossName(theme);
    String questId = 'kill_${DateTime.now().millisecondsSinceEpoch}';

    List<QuestObjective> objectives = [
      QuestObjective(
        id: '${questId}_obj1',
        description: 'Defeat $bossName and their minions',
        targetMonsterId: bossName.toLowerCase().replaceAll(' ', '_'),
        targetMonsterCount: 1,
        currentMonsterCount: 0,
      ),
      QuestObjective(
        id: '${questId}_obj2_optional',
        description: 'Retrieve $bossName\'s treasure hoard (optional)',
        isOptional: true,
        targetItemId: 'boss_treasure_${questId}',
      ),
    ];

    // Branching: Spare or Kill the boss
    List<QuestBranch> branches = [
      QuestBranch(
        id: 'kill_branch',
        choiceDescription: 'Slay $bossName without mercy',
        resultDescription: '$bossName is defeated permanently. You gain their most powerful artifact.',
        bonusReward: QuestReward(
          experiencePoints: partyLevel * 50,
          goldPieces: 0,
          items: [_generateMagicItem(partyLevel)],
        ),
      ),
      QuestBranch(
        id: 'spare_branch',
        choiceDescription: 'Spare $bossName and accept their surrender',
        resultDescription: '$bossName pledges to leave the region. You gain a powerful ally.',
        additionalObjectives: [
          QuestObjective(
            id: '${questId}_ally_objective',
            description: '$bossName will aid you once in the future',
          ),
        ],
      ),
    ];

    return Quest(
      id: questId,
      name: 'Defeat $bossName',
      description: '${questGiver.name} has asked you to defeat $bossName, who has been terrorizing the local area.',
      type: QuestType.kill,
      recommendedLevel: partyLevel,
      questGiver: questGiver,
      objectives: objectives,
      branches: branches,
      mainReward: QuestReward(
        experiencePoints: partyLevel * 100,
        goldPieces: partyLevel * 50,
        items: [_generateMagicItem(partyLevel ~/ 2)],
      ),
      bonusReward: QuestReward(
        experiencePoints: partyLevel * 50,
        goldPieces: partyLevel * 25,
      ),
      loreBackground: _generateLore(theme, bossName),
    );
  }

  // ==================== FETCH QUEST ====================
  static Quest _generateFetchQuest(int partyLevel, String? theme) {
    theme ??= _selectTheme();
    NPC questGiver = NPCGenerator.generate();

    String itemName = _generateArtifactName();
    String location = _generateLocationName(theme);
    String questId = 'fetch_${DateTime.now().millisecondsSinceEpoch}';

    List<QuestObjective> objectives = [
      QuestObjective(
        id: '${questId}_obj1',
        description: 'Travel to $location',
        targetLocationId: location.toLowerCase().replaceAll(' ', '_'),
      ),
      QuestObjective(
        id: '${questId}_obj2',
        description: 'Retrieve the $itemName',
        targetItemId: itemName.toLowerCase().replaceAll(' ', '_'),
      ),
      QuestObjective(
        id: '${questId}_obj3',
        description: 'Return the $itemName to ${questGiver.name}',
        targetNPCId: questGiver.id,
      ),
    ];

    // Branching: Return item or keep it
    List<QuestBranch> branches = [
      QuestBranch(
        id: 'return_branch',
        choiceDescription: 'Return the $itemName to ${questGiver.name}',
        resultDescription: '${questGiver.name} is grateful and rewards you handsomely.',
        bonusReward: QuestReward(
          experiencePoints: partyLevel * 75,
          goldPieces: partyLevel * 100,
        ),
      ),
      QuestBranch(
        id: 'keep_branch',
        choiceDescription: 'Keep the $itemName for yourself',
        resultDescription: 'You keep the powerful artifact, but ${questGiver.name} is furious.',
        bonusReward: QuestReward(
          experiencePoints: 0,
          goldPieces: 0,
          items: [_generateMagicItem(partyLevel)],
          reputationChange: -50,
        ),
      ),
    ];

    return Quest(
      id: questId,
      name: 'Retrieve the $itemName',
      description: '${questGiver.name} seeks the legendary $itemName, which is said to be hidden in $location.',
      type: QuestType.fetch,
      recommendedLevel: partyLevel,
      questGiver: questGiver,
      objectives: objectives,
      branches: branches,
      mainReward: QuestReward(
        experiencePoints: partyLevel * 75,
        goldPieces: partyLevel * 50,
      ),
      loreBackground: 'The $itemName was lost generations ago when $location fell into ruin.',
    );
  }

  // ==================== ESCORT QUEST ====================
  static Quest _generateEscortQuest(int partyLevel, String? theme) {
    NPC escortNPC = NPCGenerator.generate();
    NPC destinationNPC = NPCGenerator.generate();

    String destination = _selectRandomLocation();
    String questId = 'escort_${DateTime.now().millisecondsSinceEpoch}';

    List<QuestObjective> objectives = [
      QuestObjective(
        id: '${questId}_obj1',
        description: 'Safely escort ${escortNPC.name} to $destination',
        targetNPCId: escortNPC.id,
        targetLocationId: destination.toLowerCase().replaceAll(' ', '_'),
      ),
      QuestObjective(
        id: '${questId}_obj2_optional',
        description: 'Arrive within 3 days (optional)',
        isOptional: true,
      ),
    ];

    return Quest(
      id: questId,
      name: 'Escort ${escortNPC.name}',
      description: '${escortNPC.name} needs safe passage to $destination and has hired you for protection.',
      type: QuestType.escort,
      recommendedLevel: partyLevel,
      questGiver: escortNPC,
      objectives: objectives,
      mainReward: QuestReward(
        experiencePoints: partyLevel * 60,
        goldPieces: partyLevel * 40,
      ),
      bonusReward: QuestReward(
        experiencePoints: partyLevel * 30,
        goldPieces: partyLevel * 20,
      ),
      relatedNPCs: [escortNPC, destinationNPC],
      timeLimit: 5,
      loreBackground: '${escortNPC.name} carries important documents for ${destinationNPC.name}.',
    );
  }

  // ==================== INVESTIGATE QUEST ====================
  static Quest _generateInvestigateQuest(int partyLevel, String? theme) {
    theme ??= _selectTheme();
    NPC questGiver = NPCGenerator.generate();

    String mysterySite = _generateLocationName(theme);
    String questId = 'investigate_${DateTime.now().millisecondsSinceEpoch}';

    List<QuestObjective> objectives = [
      QuestObjective(
        id: '${questId}_obj1',
        description: 'Investigate mysterious events at $mysterySite',
        targetLocationId: mysterySite.toLowerCase().replaceAll(' ', '_'),
      ),
      QuestObjective(
        id: '${questId}_obj2',
        description: 'Discover the source of the disturbance',
      ),
      QuestObjective(
        id: '${questId}_obj3',
        description: 'Report your findings to ${questGiver.name}',
        targetNPCId: questGiver.id,
      ),
    ];

    return Quest(
      id: questId,
      name: 'Investigate $mysterySite',
      description: 'Strange occurrences have been reported at $mysterySite. ${questGiver.name} needs someone to investigate.',
      type: QuestType.investigate,
      recommendedLevel: partyLevel,
      questGiver: questGiver,
      objectives: objectives,
      mainReward: QuestReward(
        experiencePoints: partyLevel * 80,
        goldPieces: partyLevel * 60,
        items: [_generateMagicItem(max(1, partyLevel ~/ 3))],
      ),
      loreBackground: 'Locals report seeing strange lights and hearing unearthly sounds from $mysterySite.',
    );
  }

  // ==================== RESCUE QUEST ====================
  static Quest _generateRescueQuest(int partyLevel, String? theme) {
    theme ??= _selectTheme();
    NPC questGiver = NPCGenerator.generate();
    NPC captive = NPCGenerator.generate();

    String location = _generateLocationName(theme);
    String captor = _generateBossName(theme);
    String questId = 'rescue_${DateTime.now().millisecondsSinceEpoch}';

    List<QuestObjective> objectives = [
      QuestObjective(
        id: '${questId}_obj1',
        description: 'Locate ${captive.name} at $location',
        targetLocationId: location.toLowerCase().replaceAll(' ', '_'),
        targetNPCId: captive.id,
      ),
      QuestObjective(
        id: '${questId}_obj2',
        description: 'Defeat or evade $captor',
      ),
      QuestObjective(
        id: '${questId}_obj3',
        description: 'Escort ${captive.name} to safety',
      ),
      QuestObjective(
        id: '${questId}_obj4_optional',
        description: 'Free all captives (optional)',
        isOptional: true,
      ),
    ];

    return Quest(
      id: questId,
      name: 'Rescue ${captive.name}',
      description: '${questGiver.name}\'s ${_selectRelation()} ${captive.name} has been captured by $captor and taken to $location.',
      type: QuestType.rescue,
      recommendedLevel: partyLevel,
      questGiver: questGiver,
      objectives: objectives,
      mainReward: QuestReward(
        experiencePoints: partyLevel * 90,
        goldPieces: partyLevel * 70,
      ),
      bonusReward: QuestReward(
        experiencePoints: partyLevel * 40,
        goldPieces: partyLevel * 30,
        reputationChange: 25,
      ),
      relatedNPCs: [questGiver, captive],
      timeLimit: 7,
      loreBackground: '$captor has been raiding nearby settlements and taking prisoners.',
    );
  }

  // ==================== DELIVERY QUEST ====================
  static Quest _generateDeliveryQuest(int partyLevel, String? theme) {
    NPC sender = NPCGenerator.generate();
    NPC recipient = NPCGenerator.generate();

    String destination = _selectRandomLocation();
    String package = _selectPackageType();
    String questId = 'delivery_${DateTime.now().millisecondsSinceEpoch}';

    List<QuestObjective> objectives = [
      QuestObjective(
        id: '${questId}_obj1',
        description: 'Deliver $package to ${recipient.name} in $destination',
        targetItemId: package.toLowerCase().replaceAll(' ', '_'),
        targetNPCId: recipient.id,
        targetLocationId: destination.toLowerCase().replaceAll(' ', '_'),
      ),
      QuestObjective(
        id: '${questId}_obj2_optional',
        description: 'Keep the package intact (optional)',
        isOptional: true,
      ),
    ];

    return Quest(
      id: questId,
      name: 'Deliver to ${recipient.name}',
      description: '${sender.name} needs you to deliver $package to ${recipient.name} in $destination.',
      type: QuestType.delivery,
      recommendedLevel: partyLevel,
      questGiver: sender,
      objectives: objectives,
      mainReward: QuestReward(
        experiencePoints: partyLevel * 50,
        goldPieces: partyLevel * 40,
      ),
      bonusReward: QuestReward(
        experiencePoints: partyLevel * 25,
        goldPieces: partyLevel * 20,
      ),
      relatedNPCs: [sender, recipient],
      timeLimit: 4,
    );
  }

  // ==================== EXPLORE QUEST ====================
  static Quest _generateExploreQuest(int partyLevel, String? theme) {
    theme ??= _selectTheme();
    NPC questGiver = NPCGenerator.generate();

    String location = _generateLocationName(theme);
    String questId = 'explore_${DateTime.now().millisecondsSinceEpoch}';

    Dungeon dungeon = DungeonGenerator.generate(
      partyLevel: partyLevel,
      difficulty: 2,
      numberOfRooms: 5 + _rng.nextInt(3),
      theme: theme,
    );

    List<QuestObjective> objectives = [
      QuestObjective(
        id: '${questId}_obj1',
        description: 'Explore $location',
        targetLocationId: location.toLowerCase().replaceAll(' ', '_'),
      ),
      QuestObjective(
        id: '${questId}_obj2',
        description: 'Map all rooms in the location',
      ),
      QuestObjective(
        id: '${questId}_obj3_optional',
        description: 'Recover any treasures found (optional)',
        isOptional: true,
      ),
    ];

    return Quest(
      id: questId,
      name: 'Explore $location',
      description: '${questGiver.name} seeks brave adventurers to explore the recently discovered $location.',
      type: QuestType.explore,
      recommendedLevel: partyLevel,
      questGiver: questGiver,
      objectives: objectives,
      relatedDungeon: dungeon,
      mainReward: QuestReward(
        experiencePoints: partyLevel * 70,
        goldPieces: partyLevel * 50,
      ),
      bonusReward: QuestReward(
        experiencePoints: partyLevel * 35,
        items: [_generateMagicItem(partyLevel ~/ 2)],
      ),
      loreBackground: '$location was thought to be a myth until recent excavations revealed its entrance.',
    );
  }

  // ==================== DEFEND QUEST ====================
  static Quest _generateDefendQuest(int partyLevel, String? theme) {
    theme ??= _selectTheme();
    NPC questGiver = NPCGenerator.generate();

    String location = _selectRandomLocation();
    String enemy = _generateBossName(theme);
    String questId = 'defend_${DateTime.now().millisecondsSinceEpoch}';

    List<QuestObjective> objectives = [
      QuestObjective(
        id: '${questId}_obj1',
        description: 'Defend $location from $enemy\'s forces',
      ),
      QuestObjective(
        id: '${questId}_obj2',
        description: 'Survive 3 waves of attackers',
      ),
      QuestObjective(
        id: '${questId}_obj3_optional',
        description: 'Ensure no civilians are harmed (optional)',
        isOptional: true,
      ),
    ];

    return Quest(
      id: questId,
      name: 'Defend $location',
      description: '$enemy is launching an attack on $location. ${questGiver.name} needs heroes to defend the settlement.',
      type: QuestType.defend,
      recommendedLevel: partyLevel,
      questGiver: questGiver,
      objectives: objectives,
      mainReward: QuestReward(
        experiencePoints: partyLevel * 100,
        goldPieces: partyLevel * 80,
        items: [_generateMagicItem(partyLevel)],
        reputationChange: 50,
      ),
      bonusReward: QuestReward(
        experiencePoints: partyLevel * 50,
        goldPieces: partyLevel * 40,
        reputationChange: 25,
      ),
      timeLimit: 1,
      loreBackground: '$enemy has been gathering forces for weeks, and scouts report the attack is imminent.',
    );
  }

  // ==================== PERSUADE QUEST ====================
  static Quest _generatePersuadeQuest(int partyLevel, String? theme) {
    NPC questGiver = NPCGenerator.generate();
    NPC targetNPC = NPCGenerator.generate();

    String goal = _selectPersuasionGoal();
    String questId = 'persuade_${DateTime.now().millisecondsSinceEpoch}';

    List<QuestObjective> objectives = [
      QuestObjective(
        id: '${questId}_obj1',
        description: 'Meet with ${targetNPC.name}',
        targetNPCId: targetNPC.id,
      ),
      QuestObjective(
        id: '${questId}_obj2',
        description: 'Convince ${targetNPC.name} to $goal',
      ),
    ];

    List<QuestBranch> branches = [
      QuestBranch(
        id: 'persuade_branch',
        choiceDescription: 'Use diplomacy and reason',
        resultDescription: '${targetNPC.name} is convinced through your eloquent arguments.',
      ),
      QuestBranch(
        id: 'intimidate_branch',
        choiceDescription: 'Intimidate ${targetNPC.name}',
        resultDescription: '${targetNPC.name} reluctantly agrees out of fear.',
        bonusReward: QuestReward(
          experiencePoints: 0,
          goldPieces: 0,
          reputationChange: -25,
        ),
      ),
      QuestBranch(
        id: 'bribe_branch',
        choiceDescription: 'Offer a substantial bribe',
        resultDescription: '${targetNPC.name} accepts your gold and agrees.',
      ),
    ];

    return Quest(
      id: questId,
      name: 'Persuade ${targetNPC.name}',
      description: '${questGiver.name} needs you to convince ${targetNPC.name} to $goal.',
      type: QuestType.persuade,
      recommendedLevel: partyLevel,
      questGiver: questGiver,
      objectives: objectives,
      branches: branches,
      mainReward: QuestReward(
        experiencePoints: partyLevel * 60,
        goldPieces: partyLevel * 50,
      ),
      relatedNPCs: [questGiver, targetNPC],
    );
  }

  // ==================== PUZZLE QUEST ====================
  static Quest _generatePuzzleQuest(int partyLevel, String? theme) {
    theme ??= _selectTheme();
    NPC questGiver = NPCGenerator.generate();

    String location = _generateLocationName(theme);
    String puzzle = _selectPuzzleType();
    String questId = 'puzzle_${DateTime.now().millisecondsSinceEpoch}';

    List<QuestObjective> objectives = [
      QuestObjective(
        id: '${questId}_obj1',
        description: 'Travel to $location',
        targetLocationId: location.toLowerCase().replaceAll(' ', '_'),
      ),
      QuestObjective(
        id: '${questId}_obj2',
        description: 'Solve the $puzzle',
      ),
      QuestObjective(
        id: '${questId}_obj3',
        description: 'Claim the reward chamber',
      ),
    ];

    return Quest(
      id: questId,
      name: 'Solve the $puzzle',
      description: '${questGiver.name} has discovered $location, which contains a legendary $puzzle. Solve it to claim its treasure.',
      type: QuestType.puzzle,
      recommendedLevel: partyLevel,
      questGiver: questGiver,
      objectives: objectives,
      mainReward: QuestReward(
        experiencePoints: partyLevel * 85,
        goldPieces: partyLevel * 100,
        items: [_generateMagicItem(partyLevel)],
      ),
      loreBackground: 'The $puzzle was created by ancient wizards to guard their most precious treasures.',
    );
  }

  // ==================== HELPER METHODS ====================

  static String _selectTheme() {
    List<String> themes = ['undead', 'goblin_lair', 'dragon_lair', 'dungeon', 'cave'];
    return themes[_rng.nextInt(themes.length)];
  }

  static String _generateBossName(String theme) {
    Map<String, List<String>> bossNames = {
      'undead': ['Lich Lord Malachar', 'Death Knight Vorgoth', 'Vampire Count Strahd'],
      'goblin_lair': ['Goblin King Grix', 'Hobgoblin Warlord Kragg', 'Bugbear Chief Thorg'],
      'dragon_lair': ['Red Dragon Infernus', 'Black Dragon Umbrath', 'Green Dragon Chloravax'],
      'dungeon': ['Baron Blackheart', 'The Iron Jailer', 'Lord Torment'],
      'cave': ['Cyclops Grogthar', 'Troll King Grulnak', 'Ettin Twins'],
    };

    List<String> names = bossNames[theme] ?? ['Mysterious Villain'];
    return names[_rng.nextInt(names.length)];
  }

  static String _generateArtifactName() {
    List<String> artifacts = [
      'Crystal of Eternity',
      'Sword of a Thousand Truths',
      'Crown of the Ancient Kings',
      'Orb of Dragon Command',
      'Tome of Forbidden Knowledge',
      'Staff of the Archmage',
      'Amulet of Life and Death',
      'Ring of Ultimate Power',
    ];
    return artifacts[_rng.nextInt(artifacts.length)];
  }

  static String _generateLocationName(String theme) {
    Map<String, List<String>> locations = {
      'undead': ['Tomb of Endless Night', 'Necropolis of Shadows', 'Catacombs of the Damned'],
      'goblin_lair': ['Filthy Warrens', 'Goblin Stronghold', 'The Dark Caves'],
      'dragon_lair': ['Mount Inferno', 'Dragon\'s Peak', 'The Scorched Caverns'],
      'dungeon': ['Black Iron Prison', 'Fortress of Despair', 'The Forgotten Keep'],
      'cave': ['Crystal Caverns', 'The Deep Hollow', 'Echoing Grottos'],
    };

    List<String> names = locations[theme] ?? ['Mysterious Ruins'];
    return names[_rng.nextInt(names.length)];
  }

  static String _selectRandomLocation() {
    List<String> locations = [
      'Silverdale',
      'Ironforge',
      'Mistwood',
      'Stonehaven',
      'Riverport',
      'Goldcrest',
      'Shadowvale',
      'Brightwater',
    ];
    return locations[_rng.nextInt(locations.length)];
  }

  static String _selectRelation() {
    List<String> relations = ['sibling', 'child', 'parent', 'friend', 'apprentice'];
    return relations[_rng.nextInt(relations.length)];
  }

  static String _selectPackageType() {
    List<String> packages = [
      'an important letter',
      'a sealed box',
      'a mysterious artifact',
      'rare alchemical components',
      'a family heirloom',
    ];
    return packages[_rng.nextInt(packages.length)];
  }

  static String _selectPersuasionGoal() {
    List<String> goals = [
      'support the treaty',
      'lower taxes on the merchants',
      'provide troops for defense',
      'share their knowledge',
      'forgive a debt',
    ];
    return goals[_rng.nextInt(goals.length)];
  }

  static String _selectPuzzleType() {
    List<String> puzzles = [
      'Ancient Riddle Chamber',
      'Elemental Lock Mechanism',
      'Arcane Symbol Puzzle',
      'Mirror Maze',
      'Pressure Plate Trial',
    ];
    return puzzles[_rng.nextInt(puzzles.length)];
  }

  static String _generateLore(String theme, String bossName) {
    return '$bossName has terrorized the region for months. Ancient texts suggest they seek a powerful artifact to increase their power.';
  }

  static Item _generateMagicItem(int level) {
    if (level <= 2) {
      return MagicItems.potionOfHealing();
    } else if (level <= 5) {
      return MagicItems.weaponPlus1('Longsword');
    } else if (level <= 10) {
      return MagicItems.weaponPlus2('Longsword');
    } else {
      return MagicItems.weaponPlus3('Longsword');
    }
  }
}
