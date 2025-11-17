import 'dart:math';
import '../models/enhanced_character.dart';
import '../models/character_class.dart';
import '../models/spell.dart';
import '../models/feat.dart';

class LevelUpResult {
  int newLevel;
  int hitPointsGained;
  List<ClassFeature> newFeatures;
  bool canChooseFeat;
  bool canIncreaseAbilityScores;
  SpellSlots? newSpellSlots;
  List<String> newProficiencies;
  Map<String, int> resourcesGained; // ki_points, sorcery_points, etc.

  LevelUpResult({
    required this.newLevel,
    required this.hitPointsGained,
    List<ClassFeature>? newFeatures,
    this.canChooseFeat = false,
    this.canIncreaseAbilityScores = false,
    this.newSpellSlots,
    List<String>? newProficiencies,
    Map<String, int>? resourcesGained,
  })  : newFeatures = newFeatures ?? [],
        newProficiencies = newProficiencies ?? [],
        resourcesGained = resourcesGained ?? {};
}

class CharacterAdvancement {
  static final Random _rng = Random();

  /// Experience thresholds for each level (D&D 5e standard)
  static final Map<int, int> experienceThresholds = {
    1: 0,
    2: 300,
    3: 900,
    4: 2700,
    5: 6500,
    6: 14000,
    7: 23000,
    8: 34000,
    9: 48000,
    10: 64000,
    11: 85000,
    12: 100000,
    13: 120000,
    14: 140000,
    15: 165000,
    16: 195000,
    17: 225000,
    18: 265000,
    19: 305000,
    20: 355000,
  };

  /// Calculate proficiency bonus for a given level
  static int getProficiencyBonus(int level) {
    if (level <= 4) return 2;
    if (level <= 8) return 3;
    if (level <= 12) return 4;
    if (level <= 16) return 5;
    return 6;
  }

  /// Check if character can level up
  static bool canLevelUp(EnhancedCharacter character, int totalExperience) {
    int nextLevel = character.level + 1;
    if (nextLevel > 20) return false;

    return totalExperience >= experienceThresholds[nextLevel]!;
  }

  /// Perform level up
  static LevelUpResult levelUp(
    EnhancedCharacter character, {
    bool maximizeHP = false,
  }) {
    int newLevel = character.level + 1;
    if (newLevel > 20) {
      throw Exception('Cannot level beyond 20');
    }

    // Calculate HP gain
    int hitDie = character.characterClass.hitDie;
    int conMod = _getAbilityModifier(character.constitution);
    int hpGain;

    if (newLevel == 1) {
      hpGain = hitDie + conMod;
    } else {
      if (maximizeHP) {
        hpGain = ((hitDie / 2).ceil() + 1) + conMod;
      } else {
        hpGain = _rng.nextInt(hitDie) + 1 + conMod;
      }
    }

    // Ensure minimum 1 HP gain
    if (hpGain < 1) hpGain = 1;

    // Get new class features
    List<ClassFeature> newFeatures =
        character.characterClass.featuresByLevel[newLevel] ?? [];

    // Check for ASI/Feat
    bool canChooseASI = _isASILevel(newLevel, character.characterClass.id);

    // Update spell slots
    SpellSlots? newSlots;
    if (character.spellSlots != null) {
      newSlots = SpellSlots.forClass(character.characterClass.id, newLevel);
    }

    // Update class resources
    Map<String, int> resourcesGained = _calculateNewResources(
      character.characterClass.id,
      newLevel,
    );

    // Update new proficiencies
    List<String> newProfs = _getNewProficiencies(character, newLevel);

    // Apply level up
    character.level = newLevel;
    character.hitPointsMax += hpGain;
    character.hitPointsCurrent += hpGain;

    if (newSlots != null) {
      character.spellSlots = newSlots;
    }

    // Update class resources
    for (var entry in resourcesGained.entries) {
      character.classResources[entry.key] = entry.value;
    }

    return LevelUpResult(
      newLevel: newLevel,
      hitPointsGained: hpGain,
      newFeatures: newFeatures,
      canChooseFeat: canChooseASI,
      canIncreaseAbilityScores: canChooseASI,
      newSpellSlots: newSlots,
      newProficiencies: newProfs,
      resourcesGained: resourcesGained,
    );
  }

  /// Apply Ability Score Increase
  static void applyAbilityScoreIncrease(
    EnhancedCharacter character,
    String ability1,
    int increase1, {
    String? ability2,
    int? increase2,
  }) {
    // Max ability score is 20 (without magic items)
    _increaseAbility(character, ability1, increase1);
    if (ability2 != null && increase2 != null) {
      _increaseAbility(character, ability2, increase2);
    }
  }

  static void _increaseAbility(
    EnhancedCharacter character,
    String ability,
    int increase,
  ) {
    switch (ability.toLowerCase()) {
      case 'strength':
        character.strength = min(20, character.strength + increase);
        break;
      case 'dexterity':
        character.dexterity = min(20, character.dexterity + increase);
        break;
      case 'constitution':
        character.constitution = min(20, character.constitution + increase);
        // Recalculate HP when constitution increases
        int conBonus = _getAbilityModifier(character.constitution);
        character.hitPointsMax += conBonus * character.level;
        character.hitPointsCurrent += conBonus * character.level;
        break;
      case 'intelligence':
        character.intelligence = min(20, character.intelligence + increase);
        break;
      case 'wisdom':
        character.wisdom = min(20, character.wisdom + increase);
        break;
      case 'charisma':
        character.charisma = min(20, character.charisma + increase);
        break;
    }
  }

  /// Apply feat selection
  static void applyFeat(EnhancedCharacter character, Feat feat) {
    character.feats.add(feat);

    // Apply feat's ability score increases if any
    // (Some feats like Resilient give +1 to an ability)
  }

  /// Learn new spell
  static void learnSpell(EnhancedCharacter character, Spell spell) {
    if (!character.knownSpells.any((s) => s.id == spell.id)) {
      character.knownSpells.add(spell);
    }
  }

  /// Prepare spell
  static void prepareSpell(EnhancedCharacter character, Spell spell) {
    if (!character.preparedSpells.any((s) => s.id == spell.id)) {
      // Check if character has spell slots for this spell level
      if (character.spellSlots != null) {
        character.preparedSpells.add(spell);
      }
    }
  }

  /// Calculate max prepared spells
  static int getMaxPreparedSpells(EnhancedCharacter character) {
    String classId = character.characterClass.id;

    // Different classes have different rules
    if (classId == 'wizard' || classId == 'cleric' || classId == 'druid') {
      int spellcastingMod = _getSpellcastingModifier(character);
      return max(1, character.level + spellcastingMod);
    } else if (classId == 'paladin' || classId == 'ranger') {
      int spellcastingMod = _getSpellcastingModifier(character);
      return max(1, (character.level ~/ 2) + spellcastingMod);
    }

    // Bard, Sorcerer, Warlock know spells, don't prepare
    return 0;
  }

  /// Get spellcasting ability modifier
  static int _getSpellcastingModifier(EnhancedCharacter character) {
    String primaryAbility = character.characterClass.primaryAbility;

    switch (primaryAbility.toLowerCase()) {
      case 'intelligence':
        return _getAbilityModifier(character.intelligence);
      case 'wisdom':
        return _getAbilityModifier(character.wisdom);
      case 'charisma':
        return _getAbilityModifier(character.charisma);
      default:
        return 0;
    }
  }

  /// Multiclass validation
  static bool canMulticlass(
    EnhancedCharacter character,
    CharacterClass newClass,
  ) {
    // Check ability score prerequisites
    Map<String, int> prerequisites = _getMulticlassPrerequisites(newClass.id);

    for (var entry in prerequisites.entries) {
      int abilityScore = _getCharacterAbility(character, entry.key);
      if (abilityScore < entry.value) {
        return false;
      }
    }

    return true;
  }

  static Map<String, int> _getMulticlassPrerequisites(String classId) {
    switch (classId) {
      case 'barbarian':
        return {'strength': 13};
      case 'bard':
        return {'charisma': 13};
      case 'cleric':
        return {'wisdom': 13};
      case 'druid':
        return {'wisdom': 13};
      case 'fighter':
        return {'strength': 13}; // or dexterity 13
      case 'monk':
        return {'dexterity': 13, 'wisdom': 13};
      case 'paladin':
        return {'strength': 13, 'charisma': 13};
      case 'ranger':
        return {'dexterity': 13, 'wisdom': 13};
      case 'rogue':
        return {'dexterity': 13};
      case 'sorcerer':
        return {'charisma': 13};
      case 'warlock':
        return {'charisma': 13};
      case 'wizard':
        return {'intelligence': 13};
      default:
        return {};
    }
  }

  static int _getCharacterAbility(EnhancedCharacter character, String ability) {
    switch (ability.toLowerCase()) {
      case 'strength':
        return character.strength;
      case 'dexterity':
        return character.dexterity;
      case 'constitution':
        return character.constitution;
      case 'intelligence':
        return character.intelligence;
      case 'wisdom':
        return character.wisdom;
      case 'charisma':
        return character.charisma;
      default:
        return 0;
    }
  }

  // ==================== HELPER METHODS ====================

  static int _getAbilityModifier(int abilityScore) {
    return (abilityScore - 10) ~/ 2;
  }

  static bool _isASILevel(int level, String classId) {
    // Fighters get extra ASIs
    if (classId == 'fighter') {
      return [4, 6, 8, 12, 14, 16, 19].contains(level);
    }

    // Rogues get extra ASI at 10
    if (classId == 'rogue') {
      return [4, 8, 10, 12, 16, 19].contains(level);
    }

    // Standard ASI levels
    return [4, 8, 12, 16, 19].contains(level);
  }

  static Map<String, int> _calculateNewResources(String classId, int level) {
    Map<String, int> resources = {};

    switch (classId) {
      case 'barbarian':
        resources['rage_uses'] = _getRageUses(level);
        break;
      case 'monk':
        resources['ki_points'] = level;
        break;
      case 'sorcerer':
        resources['sorcery_points'] = level;
        break;
      case 'warlock':
        // Warlock spell slots work differently
        resources['invocations'] = _getWarlockInvocations(level);
        break;
      case 'fighter':
        if (level >= 2) {
          resources['action_surge'] = level >= 17 ? 2 : 1;
        }
        if (level >= 9) {
          resources['indomitable'] = level >= 17 ? 3 : (level >= 13 ? 2 : 1);
        }
        break;
    }

    return resources;
  }

  static int _getRageUses(int level) {
    if (level < 3) return 2;
    if (level < 6) return 3;
    if (level < 12) return 4;
    if (level < 17) return 5;
    if (level < 20) return 6;
    return 999; // Unlimited at level 20
  }

  static int _getWarlockInvocations(int level) {
    if (level < 2) return 0;
    if (level < 5) return 2;
    if (level < 7) return 3;
    if (level < 9) return 4;
    if (level < 12) return 5;
    if (level < 15) return 6;
    if (level < 18) return 7;
    return 8;
  }

  static List<String> _getNewProficiencies(
    EnhancedCharacter character,
    int level,
  ) {
    List<String> newProfs = [];

    // Check class features for new proficiencies
    var features = character.characterClass.featuresByLevel[level] ?? [];
    for (var feature in features) {
      if (feature.name.toLowerCase().contains('proficiency')) {
        newProfs.add(feature.name);
      }
    }

    return newProfs;
  }

  /// Calculate challenge rating for character
  static double calculateChallengeRating(EnhancedCharacter character) {
    // Rough approximation: CR = level / 4
    return character.level / 4;
  }

  /// Get experience needed for next level
  static int getExperienceForNextLevel(int currentLevel) {
    if (currentLevel >= 20) return 0;
    return experienceThresholds[currentLevel + 1]! -
        experienceThresholds[currentLevel]!;
  }
}
