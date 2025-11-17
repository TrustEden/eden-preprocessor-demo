import '../models/character.dart';

class ExperienceService {
  static const Map<int, int> XP_THRESHOLDS = {
    1: 0,
    2: 300,
    3: 900,
    4: 2700,
    5: 6500,
  };

  List<String> awardXP(Character character, int xp) {
    List<String> messages = [];

    character.experience += xp;
    messages.add('Gained $xp XP! (Total: ${character.experience})');

    int currentLevel = character.level;
    int newLevel = _getLevel(character.experience);

    if (newLevel > currentLevel && newLevel <= 5) {
      var levelUpMessages = _levelUp(character, newLevel);
      messages.addAll(levelUpMessages);
    }

    return messages;
  }

  int _getLevel(int xp) {
    for (int level = 5; level >= 1; level--) {
      if (xp >= XP_THRESHOLDS[level]!) {
        return level;
      }
    }
    return 1;
  }

  List<String> _levelUp(Character character, int newLevel) {
    List<String> messages = [];
    messages.add('🎉 LEVEL UP! You are now level $newLevel!');

    character.level = newLevel;

    // Roll HP increase (or take average)
    int hpIncrease =
        6 + character.constitutionModifier; // d10 average is 5.5, round to 6
    character.hpMax += hpIncrease;
    character.hpCurrent = character.hpMax; // Full heal on level up
    messages.add('HP increased by $hpIncrease! (Max HP: ${character.hpMax})');

    // Update proficiency bonus
    int oldBonus = character.proficiencyBonus;
    character.proficiencyBonus = 2 + ((newLevel - 1) ~/ 4);
    if (character.proficiencyBonus > oldBonus) {
      messages.add('Proficiency bonus increased to +${character.proficiencyBonus}!');
    }

    // Grant class features
    if (newLevel == 2) {
      character.actionSurgeUses = 1; // Gain Action Surge
      messages.add('New Feature: Action Surge (1 use per rest)');
    }
    if (newLevel == 3) {
      messages.add('New Feature: Martial Archetype (Fighter subclass)');
      // Fighter gets to choose subclass, but we'll skip that for MVP
    }
    if (newLevel == 4) {
      // Ability Score Improvement - auto-increase Strength for simplicity
      character.strength += 2;
      messages.add('Ability Score Improvement: Strength increased to ${character.strength}!');
      character.recalculateArmorClass();
    }
    if (newLevel == 5) {
      messages.add('New Feature: Extra Attack (attack twice per turn)');
    }

    return messages;
  }

  int getXPToNextLevel(Character character) {
    if (character.level >= 5) {
      return 0; // Max level for MVP
    }
    int nextLevel = character.level + 1;
    return XP_THRESHOLDS[nextLevel]! - character.experience;
  }
}
