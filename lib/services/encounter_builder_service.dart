import 'package:eden_preprocessor_demo/models/monster.dart';
import 'dart:math';

/// Service for building balanced encounters with CR calculations
class EncounterBuilderService {
  final Random _random = Random();

  /// Calculate adjusted XP for encounter difficulty
  int calculateAdjustedXP(List<Monster> monsters, int partySize) {
    // Base XP from all monsters
    int totalXP = monsters.fold(0, (sum, m) => sum + _getMonsterXP(m.challengeRating));

    // XP multiplier based on number of monsters
    double multiplier = _getXPMultiplier(monsters.length, partySize);

    return (totalXP * multiplier).round();
  }

  /// Get XP value for a CR
  int _getMonsterXP(double challengeRating) {
    // Standard D&D 5e XP by CR
    Map<double, int> xpByCR = {
      0.0: 10,
      0.125: 25,
      0.25: 50,
      0.5: 100,
      1.0: 200,
      2.0: 450,
      3.0: 700,
      4.0: 1100,
      5.0: 1800,
      6.0: 2300,
      7.0: 2900,
      8.0: 3900,
      9.0: 5000,
      10.0: 5900,
      11.0: 7200,
      12.0: 8400,
      13.0: 10000,
      14.0: 11500,
      15.0: 13000,
      16.0: 15000,
      17.0: 18000,
      18.0: 20000,
      19.0: 22000,
      20.0: 25000,
      21.0: 33000,
      22.0: 41000,
      23.0: 50000,
      24.0: 62000,
      25.0: 75000,
      26.0: 90000,
      27.0: 105000,
      28.0: 120000,
      29.0: 135000,
      30.0: 155000,
    };

    return xpByCR[challengeRating] ?? 200; // Default to CR 1 if not found
  }

  /// Get XP multiplier based on number of monsters
  double _getXPMultiplier(int monsterCount, int partySize) {
    // Adjust for small/large parties
    bool smallParty = partySize < 3;
    bool largeParty = partySize > 5;

    if (monsterCount == 1) {
      return smallParty ? 1.5 : 1.0;
    } else if (monsterCount == 2) {
      return smallParty ? 2.0 : (largeParty ? 1.0 : 1.5);
    } else if (monsterCount <= 6) {
      return smallParty ? 2.5 : (largeParty ? 1.5 : 2.0);
    } else if (monsterCount <= 10) {
      return smallParty ? 3.0 : (largeParty ? 2.0 : 2.5);
    } else if (monsterCount <= 14) {
      return smallParty ? 4.0 : (largeParty ? 2.5 : 3.0);
    } else {
      return smallParty ? 5.0 : (largeParty ? 3.0 : 4.0);
    }
  }

  /// Calculate XP thresholds for party
  PartyThresholds calculatePartyThresholds(List<int> characterLevels) {
    int totalEasy = 0;
    int totalMedium = 0;
    int totalHard = 0;
    int totalDeadly = 0;

    for (int characterLevel in characterLevels) {
      var thresholds = _getThresholdsForLevel(characterLevel);
      totalEasy += thresholds['easy']!;
      totalMedium += thresholds['medium']!;
      totalHard += thresholds['hard']!;
      totalDeadly += thresholds['deadly']!;
    }

    return PartyThresholds(
      easyThreshold: totalEasy,
      mediumThreshold: totalMedium,
      hardThreshold: totalHard,
      deadlyThreshold: totalDeadly,
    );
  }

  /// Get XP thresholds for a character level
  Map<String, int> _getThresholdsForLevel(int characterLevel) {
    // Standard D&D 5e thresholds per level
    List<Map<String, int>> thresholds = [
      {'easy': 25, 'medium': 50, 'hard': 75, 'deadly': 100}, // Level 1
      {'easy': 50, 'medium': 100, 'hard': 150, 'deadly': 200}, // Level 2
      {'easy': 75, 'medium': 150, 'hard': 225, 'deadly': 400}, // Level 3
      {'easy': 125, 'medium': 250, 'hard': 375, 'deadly': 500}, // Level 4
      {'easy': 250, 'medium': 500, 'hard': 750, 'deadly': 1100}, // Level 5
      {'easy': 300, 'medium': 600, 'hard': 900, 'deadly': 1400}, // Level 6
      {'easy': 350, 'medium': 750, 'hard': 1100, 'deadly': 1700}, // Level 7
      {'easy': 450, 'medium': 900, 'hard': 1400, 'deadly': 2100}, // Level 8
      {'easy': 550, 'medium': 1100, 'hard': 1600, 'deadly': 2400}, // Level 9
      {'easy': 600, 'medium': 1200, 'hard': 1900, 'deadly': 2800}, // Level 10
      {'easy': 800, 'medium': 1600, 'hard': 2400, 'deadly': 3600}, // Level 11
      {'easy': 1000, 'medium': 2000, 'hard': 3000, 'deadly': 4500}, // Level 12
      {'easy': 1100, 'medium': 2200, 'hard': 3400, 'deadly': 5100}, // Level 13
      {'easy': 1250, 'medium': 2500, 'hard': 3800, 'deadly': 5700}, // Level 14
      {'easy': 1400, 'medium': 2800, 'hard': 4300, 'deadly': 6400}, // Level 15
      {'easy': 1600, 'medium': 3200, 'hard': 4800, 'deadly': 7200}, // Level 16
      {'easy': 2000, 'medium': 3900, 'hard': 5900, 'deadly': 8800}, // Level 17
      {'easy': 2100, 'medium': 4200, 'hard': 6300, 'deadly': 9500}, // Level 18
      {'easy': 2400, 'medium': 4900, 'hard': 7300, 'deadly': 10900}, // Level 19
      {'easy': 2800, 'medium': 5700, 'hard': 8500, 'deadly': 12700}, // Level 20
    ];

    int levelIndex = (characterLevel - 1).clamp(0, 19);
    return thresholds[levelIndex];
  }

  /// Determine encounter difficulty
  EncounterDifficulty determineEncounterDifficulty({
    required List<Monster> monsters,
    required List<int> characterLevels,
  }) {
    var partyThresholds = calculatePartyThresholds(characterLevels);
    int adjustedXP = calculateAdjustedXP(monsters, characterLevels.length);

    if (adjustedXP >= partyThresholds.deadlyThreshold) {
      return EncounterDifficulty.deadly;
    } else if (adjustedXP >= partyThresholds.hardThreshold) {
      return EncounterDifficulty.hard;
    } else if (adjustedXP >= partyThresholds.mediumThreshold) {
      return EncounterDifficulty.medium;
    } else if (adjustedXP >= partyThresholds.easyThreshold) {
      return EncounterDifficulty.easy;
    } else {
      return EncounterDifficulty.trivial;
    }
  }

  /// Build encounter for target difficulty
  EncounterBuildResult buildEncounter({
    required EncounterDifficulty targetDifficulty,
    required List<int> characterLevels,
    required List<Monster> availableMonsters,
    String? encounterTheme,
    String? environment,
  }) {
    var partyThresholds = calculatePartyThresholds(characterLevels);
    int targetXP;

    switch (targetDifficulty) {
      case EncounterDifficulty.trivial:
        targetXP = (partyThresholds.easyThreshold * 0.75).round();
        break;
      case EncounterDifficulty.easy:
        targetXP = partyThresholds.easyThreshold;
        break;
      case EncounterDifficulty.medium:
        targetXP = partyThresholds.mediumThreshold;
        break;
      case EncounterDifficulty.hard:
        targetXP = partyThresholds.hardThreshold;
        break;
      case EncounterDifficulty.deadly:
        targetXP = partyThresholds.deadlyThreshold;
        break;
    }

    // Simple encounter building algorithm
    List<Monster> selectedMonsters = [];
    int currentAdjustedXP = 0;

    // Try to build encounter within 20% of target
    int maxAttempts = 50;
    int attempts = 0;

    while (attempts < maxAttempts) {
      selectedMonsters.clear();

      // Randomly select monsters
      int monsterCount = _random.nextInt(6) + 1; // 1-6 monsters

      for (int i = 0; i < monsterCount; i++) {
        if (availableMonsters.isEmpty) break;

        var randomMonster = availableMonsters[_random.nextInt(availableMonsters.length)];
        selectedMonsters.add(randomMonster);
      }

      currentAdjustedXP = calculateAdjustedXP(selectedMonsters, characterLevels.length);

      // Check if within acceptable range
      if (currentAdjustedXP >= targetXP * 0.8 && currentAdjustedXP <= targetXP * 1.2) {
        break;
      }

      attempts++;
    }

    return EncounterBuildResult(
      selectedMonsters: selectedMonsters,
      adjustedXP: currentAdjustedXP,
      targetXP: targetXP,
      actualDifficulty: determineEncounterDifficulty(
        monsters: selectedMonsters,
        characterLevels: characterLevels,
      ),
      suggestions: _generateEncounterSuggestions(selectedMonsters, environment),
    );
  }

  /// Generate tactical suggestions for encounter
  List<String> _generateEncounterSuggestions(List<Monster> monsters, String? environment) {
    List<String> suggestions = [];

    if (monsters.length == 1) {
      suggestions.add('Solo monster - consider legendary actions or lair actions');
    } else if (monsters.length > 8) {
      suggestions.add('Large encounter - consider minions or simplified stat blocks');
    }

    // Environment suggestions
    if (environment != null) {
      switch (environment.toLowerCase()) {
        case 'forest':
          suggestions.add('Add difficult terrain or trees for cover');
          break;
        case 'cave':
          suggestions.add('Add darkness, low ceilings, or narrow passages');
          break;
        case 'ruins':
          suggestions.add('Add crumbling walls, pits, or magical hazards');
          break;
        case 'underwater':
          suggestions.add('Apply underwater combat rules');
          break;
      }
    }

    return suggestions;
  }

  /// Calculate daily XP budget for party
  int calculateDailyXPBudget(List<int> characterLevels) {
    var partyThresholds = calculatePartyThresholds(characterLevels);
    // Daily budget is typically 4-6 medium encounters or 1.5x deadly threshold
    return (partyThresholds.mediumThreshold * 4.5).round();
  }

  /// Suggest number of encounters for adventuring day
  AdventuringDaySuggestion suggestAdventuringDay(List<int> characterLevels) {
    var partyThresholds = calculatePartyThresholds(characterLevels);
    int dailyBudget = calculateDailyXPBudget(characterLevels);

    return AdventuringDaySuggestion(
      recommendedEasyEncounters: (dailyBudget / partyThresholds.easyThreshold).floor(),
      recommendedMediumEncounters: (dailyBudget / partyThresholds.mediumThreshold).floor(),
      recommendedHardEncounters: (dailyBudget / partyThresholds.hardThreshold).floor(),
      dailyXPBudget: dailyBudget,
      suggestedMix: 'Recommended: 2-3 medium encounters, 1 hard encounter, 1-2 easy encounters',
    );
  }

  /// Calculate effective monster CR when working together
  double calculateEffectiveCR(List<Monster> monsters) {
    int totalXP = monsters.fold(0, (sum, m) => sum + _getMonsterXP(m.challengeRating));

    // Reverse lookup CR from total XP
    for (var entry in [
      [155000.0, 30.0],
      [135000.0, 29.0],
      [120000.0, 28.0],
      [105000.0, 27.0],
      [90000.0, 26.0],
      [75000.0, 25.0],
      [62000.0, 24.0],
      [50000.0, 23.0],
      [41000.0, 22.0],
      [33000.0, 21.0],
      [25000.0, 20.0],
      [22000.0, 19.0],
      [20000.0, 18.0],
      [18000.0, 17.0],
      [15000.0, 16.0],
      [13000.0, 15.0],
      [11500.0, 14.0],
      [10000.0, 13.0],
      [8400.0, 12.0],
      [7200.0, 11.0],
      [5900.0, 10.0],
      [5000.0, 9.0],
      [3900.0, 8.0],
      [2900.0, 7.0],
      [2300.0, 6.0],
      [1800.0, 5.0],
      [1100.0, 4.0],
      [700.0, 3.0],
      [450.0, 2.0],
      [200.0, 1.0],
    ]) {
      if (totalXP >= entry[0]) {
        return entry[1];
      }
    }

    return 0.5;
  }
}

/// Encounter difficulty levels
enum EncounterDifficulty {
  trivial,
  easy,
  medium,
  hard,
  deadly,
}

/// Party XP thresholds
class PartyThresholds {
  final int easyThreshold;
  final int mediumThreshold;
  final int hardThreshold;
  final int deadlyThreshold;

  PartyThresholds({
    required this.easyThreshold,
    required this.mediumThreshold,
    required this.hardThreshold,
    required this.deadlyThreshold,
  });
}

/// Encounter build result
class EncounterBuildResult {
  final List<Monster> selectedMonsters;
  final int adjustedXP;
  final int targetXP;
  final EncounterDifficulty actualDifficulty;
  final List<String> suggestions;

  EncounterBuildResult({
    required this.selectedMonsters,
    required this.adjustedXP,
    required this.targetXP,
    required this.actualDifficulty,
    required this.suggestions,
  });
}

/// Adventuring day suggestion
class AdventuringDaySuggestion {
  final int recommendedEasyEncounters;
  final int recommendedMediumEncounters;
  final int recommendedHardEncounters;
  final int dailyXPBudget;
  final String suggestedMix;

  AdventuringDaySuggestion({
    required this.recommendedEasyEncounters,
    required this.recommendedMediumEncounters,
    required this.recommendedHardEncounters,
    required this.dailyXPBudget,
    required this.suggestedMix,
  });
}
