import 'dart:math';
import 'item.dart';
import 'spell.dart';
import 'race.dart';
import 'character_class.dart';
import 'feat.dart';
import 'background.dart';

/// Enhanced Character model supporting all D&D 5e features
class EnhancedCharacter {
  String id;
  String name;

  // Core Identity
  Race race;
  CharacterClass characterClass;
  String? subclass; // Chosen at appropriate level
  Background? background;
  List<Feat> feats;

  // Level and Experience
  int level;
  int experience;

  // Ability Scores (base scores before racial modifiers)
  int baseStrength;
  int baseDexterity;
  int baseConstitution;
  int baseIntelligence;
  int baseWisdom;
  int baseCharisma;

  // Calculated ability scores (after racial bonuses and ASIs)
  int get strength => _calculateAbilityScore('Strength');
  int get dexterity => _calculateAbilityScore('Dexterity');
  int get constitution => _calculateAbilityScore('Constitution');
  int get intelligence => _calculateAbilityScore('Intelligence');
  int get wisdom => _calculateAbilityScore('Wisdom');
  int get charisma => _calculateAbilityScore('Charisma');

  // Ability Score Improvements from leveling
  Map<String, int> asiIncreases;

  // Combat Stats
  int hpCurrent;
  int hpMax;
  int tempHp; // Temporary HP
  int armorClass;
  int proficiencyBonus;

  // Hit Dice
  int hitDiceRemaining;
  int get hitDiceMax => level;

  // Equipment
  List<Item> inventory;
  Item? equippedWeapon;
  Item? equippedArmor;
  Item? equippedShield;

  // Skills - now dynamic based on class and background
  Map<String, bool> skillProficiencies;
  Map<String, bool> skillExpertise; // For rogues and bards

  // Saving Throw Proficiencies
  Set<String> savingThrowProficiencies;

  // Spellcasting (for spellcasters)
  SpellSlots? spellSlots;
  List<Spell> knownSpells; // For classes that know spells
  List<Spell> preparedSpells; // For classes that prepare spells
  List<Spell> cantrips;
  ConcentrationManager? concentrationManager;

  // Class Resources
  Map<String, int> classResources; // e.g., "ki_points", "sorcery_points", "rage_uses"
  Map<String, int> maxClassResources;

  // Class-specific features
  Map<String, bool> classFeatures; // Track which features are unlocked

  // Fighter-specific (kept for backwards compatibility)
  int? secondWindUses;
  int? actionSurgeUses;
  String? fightingStyle;

  // Rogue-specific
  int? sneakAttackDice;

  // Barbarian-specific
  int? rageUses;
  int? rageDamageBonus;
  bool? isRaging;

  // Monk-specific
  int? kiPoints;
  int? maxKiPoints;
  int? martialArtsDie;

  // Bard-specific
  int? bardicInspirationDie;
  int? bardicInspirationUses;

  // Paladin-specific
  int? layOnHandsPool;

  // Conditions and status effects
  List<String> activeConditions;

  // Movement
  int speed;

  // Personality (from background)
  String? personalityTrait1;
  String? personalityTrait2;
  String? ideal;
  String? bond;
  String? flaw;

  EnhancedCharacter({
    required this.id,
    required this.name,
    required this.race,
    required this.characterClass,
    this.subclass,
    this.background,
    List<Feat>? feats,
    required this.level,
    required this.experience,
    required this.baseStrength,
    required this.baseDexterity,
    required this.baseConstitution,
    required this.baseIntelligence,
    required this.baseWisdom,
    required this.baseCharisma,
    Map<String, int>? asiIncreases,
    required this.hpCurrent,
    required this.hpMax,
    this.tempHp = 0,
    required this.armorClass,
    required this.proficiencyBonus,
    required this.hitDiceRemaining,
    List<Item>? inventory,
    this.equippedWeapon,
    this.equippedArmor,
    this.equippedShield,
    Map<String, bool>? skillProficiencies,
    Map<String, bool>? skillExpertise,
    Set<String>? savingThrowProficiencies,
    this.spellSlots,
    List<Spell>? knownSpells,
    List<Spell>? preparedSpells,
    List<Spell>? cantrips,
    this.concentrationManager,
    Map<String, int>? classResources,
    Map<String, int>? maxClassResources,
    Map<String, bool>? classFeatures,
    this.secondWindUses,
    this.actionSurgeUses,
    this.fightingStyle,
    this.sneakAttackDice,
    this.rageUses,
    this.rageDamageBonus,
    this.isRaging,
    this.kiPoints,
    this.maxKiPoints,
    this.martialArtsDie,
    this.bardicInspirationDie,
    this.bardicInspirationUses,
    this.layOnHandsPool,
    List<String>? activeConditions,
    int? speed,
    this.personalityTrait1,
    this.personalityTrait2,
    this.ideal,
    this.bond,
    this.flaw,
  })  : feats = feats ?? [],
        asiIncreases = asiIncreases ?? {},
        inventory = inventory ?? [],
        skillProficiencies = skillProficiencies ?? {},
        skillExpertise = skillExpertise ?? {},
        savingThrowProficiencies = savingThrowProficiencies ?? {},
        knownSpells = knownSpells ?? [],
        preparedSpells = preparedSpells ?? [],
        cantrips = cantrips ?? [],
        classResources = classResources ?? {},
        maxClassResources = maxClassResources ?? {},
        classFeatures = classFeatures ?? {},
        activeConditions = activeConditions ?? [],
        speed = speed ?? race.speed;

  // Calculated properties
  int get strengthModifier => (strength - 10) ~/ 2;
  int get dexterityModifier => (dexterity - 10) ~/ 2;
  int get constitutionModifier => (constitution - 10) ~/ 2;
  int get intelligenceModifier => (intelligence - 10) ~/ 2;
  int get wisdomModifier => (wisdom - 10) ~/ 2;
  int get charismaModifier => (charisma - 10) ~/ 2;

  int get initiativeBonus => dexterityModifier + (feats.any((f) => f.id == 'alert') ? 5 : 0);

  int _calculateAbilityScore(String ability) {
    int base = 0;
    switch (ability) {
      case 'Strength':
        base = baseStrength;
        break;
      case 'Dexterity':
        base = baseDexterity;
        break;
      case 'Constitution':
        base = baseConstitution;
        break;
      case 'Intelligence':
        base = baseIntelligence;
        break;
      case 'Wisdom':
        base = baseWisdom;
        break;
      case 'Charisma':
        base = baseCharisma;
        break;
    }

    // Add racial bonuses
    int racial = race.abilityIncreases[ability] ?? 0;

    // Add ASI increases
    int asi = asiIncreases[ability] ?? 0;

    // Add feat bonuses
    int featBonus = 0;
    for (var feat in feats) {
      if (feat.abilityIncreases != null) {
        featBonus += feat.abilityIncreases![ability] ?? 0;
      }
    }

    int total = base + racial + asi + featBonus;

    // Cap at 20 (30 for barbarians at level 20)
    int maxScore = (characterClass.id == 'barbarian' && level >= 20 &&
                    (ability == 'Strength' || ability == 'Constitution')) ? 24 : 20;

    return total.clamp(1, maxScore);
  }

  int getSkillModifier(String skill) {
    int baseModifier = 0;
    bool proficient = skillProficiencies[skill] ?? false;
    bool expertise = skillExpertise[skill] ?? false;

    switch (skill.toLowerCase()) {
      case 'athletics':
        baseModifier = strengthModifier;
        break;
      case 'acrobatics':
      case 'sleight of hand':
      case 'stealth':
        baseModifier = dexterityModifier;
        break;
      case 'arcana':
      case 'history':
      case 'investigation':
      case 'nature':
      case 'religion':
        baseModifier = intelligenceModifier;
        break;
      case 'animal handling':
      case 'insight':
      case 'medicine':
      case 'perception':
      case 'survival':
        baseModifier = wisdomModifier;
        break;
      case 'deception':
      case 'intimidation':
      case 'performance':
      case 'persuasion':
        baseModifier = charismaModifier;
        break;
    }

    if (expertise) {
      return baseModifier + (proficiencyBonus * 2);
    } else if (proficient) {
      return baseModifier + proficiencyBonus;
    } else if (characterClass.id == 'bard' && level >= 2) {
      // Jack of All Trades
      return baseModifier + (proficiencyBonus ~/ 2);
    }

    return baseModifier;
  }

  int getSavingThrowModifier(String ability) {
    int abilityMod = 0;
    switch (ability) {
      case 'Strength':
        abilityMod = strengthModifier;
        break;
      case 'Dexterity':
        abilityMod = dexterityModifier;
        break;
      case 'Constitution':
        abilityMod = constitutionModifier;
        break;
      case 'Intelligence':
        abilityMod = intelligenceModifier;
        break;
      case 'Wisdom':
        abilityMod = wisdomModifier;
        break;
      case 'Charisma':
        abilityMod = charismaModifier;
        break;
    }

    bool proficient = savingThrowProficiencies.contains(ability);
    return abilityMod + (proficient ? proficiencyBonus : 0);
  }

  int getAttackBonus({bool isMelee = true, bool isFinesse = false}) {
    int abilityMod = isMelee ? strengthModifier : dexterityModifier;

    if (isFinesse) {
      abilityMod = max(strengthModifier, dexterityModifier);
    }

    return abilityMod + proficiencyBonus;
  }

  int getSpellSaveDC() {
    String? spellcastingAbility = characterClass.spellcastingAbility;
    if (spellcastingAbility == null) return 0;

    int abilityMod = 0;
    switch (spellcastingAbility) {
      case 'Intelligence':
        abilityMod = intelligenceModifier;
        break;
      case 'Wisdom':
        abilityMod = wisdomModifier;
        break;
      case 'Charisma':
        abilityMod = charismaModifier;
        break;
    }

    return 8 + proficiencyBonus + abilityMod;
  }

  int getSpellAttackBonus() {
    String? spellcastingAbility = characterClass.spellcastingAbility;
    if (spellcastingAbility == null) return 0;

    int abilityMod = 0;
    switch (spellcastingAbility) {
      case 'Intelligence':
        abilityMod = intelligenceModifier;
        break;
      case 'Wisdom':
        abilityMod = wisdomModifier;
        break;
      case 'Charisma':
        abilityMod = charismaModifier;
        break;
    }

    return proficiencyBonus + abilityMod;
  }

  void recalculateArmorClass() {
    int ac = 10; // Base AC

    if (equippedArmor != null) {
      ac = equippedArmor!.armorBonus ?? 10;

      // Light armor adds full dex mod
      if (equippedArmor!.armorType == 'light') {
        ac += dexterityModifier;
      }
      // Medium armor adds max +2 dex mod
      else if (equippedArmor!.armorType == 'medium') {
        ac += min(dexterityModifier, 2);
      }
      // Heavy armor doesn't add dex mod
    } else {
      // Unarmored Defense
      if (characterClass.id == 'barbarian') {
        // Barbarian: 10 + Dex + Con
        ac = 10 + dexterityModifier + constitutionModifier;
      } else if (characterClass.id == 'monk') {
        // Monk: 10 + Dex + Wis
        ac = 10 + dexterityModifier + wisdomModifier;
      } else if (race.id == 'mountain_dwarf') {
        // Dwarven armor training gives medium armor prof
        ac = 10 + dexterityModifier;
      } else {
        // No armor - use 10 + dex mod
        ac = 10 + dexterityModifier;
      }
    }

    // Add shield bonus
    if (equippedShield != null) {
      ac += equippedShield!.armorBonus ?? 0;
    }

    // Apply Defense fighting style bonus
    if (fightingStyle == 'Defense' && equippedArmor != null) {
      ac += 1;
    }

    // Dual Wielder feat
    if (feats.any((f) => f.id == 'dual_wielder') && equippedWeapon != null && equippedShield == null) {
      ac += 1;
    }

    armorClass = ac;
  }

  void levelUp() {
    level++;

    // Increase HP
    int hpGain = (characterClass.hitDie ~/ 2) + 1 + constitutionModifier;

    // Hill Dwarf bonus
    if (race.id == 'hill_dwarf') {
      hpGain += 1;
    }

    // Toughness feat
    if (feats.any((f) => f.id == 'toughness')) {
      hpGain += 2;
    }

    hpMax += hpGain;
    hpCurrent = hpMax;

    // Update proficiency bonus
    proficiencyBonus = 2 + ((level - 1) ~/ 4);

    // Restore hit dice
    hitDiceRemaining = level;

    // Update spell slots for spellcasters
    if (characterClass.isSpellcaster) {
      spellSlots = SpellSlots.forClass(characterClass.id, level);
    }

    // Update class resources
    _updateClassResources();

    // ASI at levels 4, 8, 12, 16, 19 (fighters get extras at 6, 14)
    bool isASILevel = false;
    if ([4, 8, 12, 16, 19].contains(level)) {
      isASILevel = true;
    }
    if (characterClass.id == 'fighter' && [6, 14].contains(level)) {
      isASILevel = true;
    }
    if (characterClass.id == 'rogue' && [10].contains(level)) {
      isASILevel = true;
    }

    // Note: ASI increases and feat selection would be handled in UI
  }

  void _updateClassResources() {
    switch (characterClass.id) {
      case 'fighter':
        secondWindUses = 1;
        actionSurgeUses = level >= 17 ? 2 : (level >= 2 ? 1 : 0);
        break;

      case 'rogue':
        sneakAttackDice = (level + 1) ~/ 2;
        break;

      case 'barbarian':
        if (level >= 20) rageUses = 999; // Unlimited
        else if (level >= 17) rageUses = 6;
        else if (level >= 12) rageUses = 5;
        else if (level >= 6) rageUses = 4;
        else if (level >= 3) rageUses = 3;
        else rageUses = 2;

        rageDamageBonus = level >= 16 ? 4 : (level >= 9 ? 3 : 2);
        break;

      case 'monk':
        maxKiPoints = level;
        kiPoints = level;

        if (level >= 17) martialArtsDie = 10;
        else if (level >= 11) martialArtsDie = 8;
        else if (level >= 5) martialArtsDie = 6;
        else martialArtsDie = 4;
        break;

      case 'bard':
        if (level >= 15) bardicInspirationDie = 12;
        else if (level >= 10) bardicInspirationDie = 10;
        else if (level >= 5) bardicInspirationDie = 8;
        else bardicInspirationDie = 6;

        bardicInspirationUses = charismaModifier;
        break;

      case 'paladin':
        layOnHandsPool = level * 5;
        break;

      case 'sorcerer':
        classResources['sorcery_points'] = level;
        maxClassResources['sorcery_points'] = level;
        break;

      case 'warlock':
        // Warlock spell slots are different (handled in SpellSlots class)
        // Invocations increase with level
        int invocations = 0;
        if (level >= 18) invocations = 8;
        else if (level >= 15) invocations = 7;
        else if (level >= 12) invocations = 6;
        else if (level >= 9) invocations = 5;
        else if (level >= 7) invocations = 4;
        else if (level >= 5) invocations = 3;
        else if (level >= 2) invocations = 2;

        classResources['invocations_known'] = invocations;
        break;
    }
  }

  void shortRest() {
    // Recover some hit dice (up to half max, minimum 1)
    int maxRecovery = max(1, level ~/ 2);
    // In a real implementation, player would choose how many to spend

    // Class-specific short rest benefits
    switch (characterClass.id) {
      case 'fighter':
        secondWindUses = 1;
        actionSurgeUses = level >= 17 ? 2 : 1;
        break;

      case 'warlock':
        spellSlots?.shortRest(characterClass.id);
        break;

      case 'monk':
        kiPoints = maxKiPoints;
        break;

      case 'bard':
        if (level >= 5) {
          bardicInspirationUses = charismaModifier;
        }
        break;
    }
  }

  void longRest() {
    // Restore HP
    hpCurrent = hpMax;
    tempHp = 0;

    // Restore hit dice (half of maximum, minimum 1)
    hitDiceRemaining = min(level, hitDiceRemaining + max(1, level ~/ 2));

    // Restore spell slots
    spellSlots?.longRest();

    // Break concentration
    concentrationManager?.breakConcentration();

    // Restore all class resources
    switch (characterClass.id) {
      case 'fighter':
        secondWindUses = 1;
        actionSurgeUses = level >= 17 ? 2 : 1;
        break;

      case 'barbarian':
        isRaging = false;
        if (level >= 20) rageUses = 999;
        else if (level >= 17) rageUses = 6;
        else if (level >= 12) rageUses = 5;
        else if (level >= 6) rageUses = 4;
        else if (level >= 3) rageUses = 3;
        else rageUses = 2;
        break;

      case 'monk':
        kiPoints = maxKiPoints;
        break;

      case 'bard':
        bardicInspirationUses = charismaModifier;
        break;

      case 'paladin':
        layOnHandsPool = level * 5;
        break;

      case 'sorcerer':
        classResources['sorcery_points'] = level;
        break;
    }

    // Clear most conditions
    activeConditions.removeWhere((c) => c != 'exhaustion'); // Exhaustion persists
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'race': race.toJson(),
    'characterClass': characterClass.toJson(),
    'subclass': subclass,
    'background': background?.toJson(),
    'feats': feats.map((f) => f.toJson()).toList(),
    'level': level,
    'experience': experience,
    'baseStrength': baseStrength,
    'baseDexterity': baseDexterity,
    'baseConstitution': baseConstitution,
    'baseIntelligence': baseIntelligence,
    'baseWisdom': baseWisdom,
    'baseCharisma': baseCharisma,
    'asiIncreases': asiIncreases,
    'hpCurrent': hpCurrent,
    'hpMax': hpMax,
    'tempHp': tempHp,
    'armorClass': armorClass,
    'proficiencyBonus': proficiencyBonus,
    'hitDiceRemaining': hitDiceRemaining,
    'inventory': inventory.map((i) => i.toJson()).toList(),
    'equippedWeapon': equippedWeapon?.toJson(),
    'equippedArmor': equippedArmor?.toJson(),
    'equippedShield': equippedShield?.toJson(),
    'skillProficiencies': skillProficiencies,
    'skillExpertise': skillExpertise,
    'savingThrowProficiencies': savingThrowProficiencies.toList(),
    'spellSlots': spellSlots?.toJson(),
    'knownSpells': knownSpells.map((s) => s.toJson()).toList(),
    'preparedSpells': preparedSpells.map((s) => s.toJson()).toList(),
    'cantrips': cantrips.map((s) => s.toJson()).toList(),
    'concentrationManager': concentrationManager?.toJson(),
    'classResources': classResources,
    'maxClassResources': maxClassResources,
    'classFeatures': classFeatures,
    'secondWindUses': secondWindUses,
    'actionSurgeUses': actionSurgeUses,
    'fightingStyle': fightingStyle,
    'sneakAttackDice': sneakAttackDice,
    'rageUses': rageUses,
    'rageDamageBonus': rageDamageBonus,
    'isRaging': isRaging,
    'kiPoints': kiPoints,
    'maxKiPoints': maxKiPoints,
    'martialArtsDie': martialArtsDie,
    'bardicInspirationDie': bardicInspirationDie,
    'bardicInspirationUses': bardicInspirationUses,
    'layOnHandsPool': layOnHandsPool,
    'activeConditions': activeConditions,
    'speed': speed,
    'personalityTrait1': personalityTrait1,
    'personalityTrait2': personalityTrait2,
    'ideal': ideal,
    'bond': bond,
    'flaw': flaw,
  };

  factory EnhancedCharacter.fromJson(Map<String, dynamic> json) {
    var char = EnhancedCharacter(
      id: json['id'] as String,
      name: json['name'] as String,
      race: Race.fromJson(json['race'] as Map<String, dynamic>),
      characterClass: CharacterClass.fromJson(json['characterClass'] as Map<String, dynamic>),
      subclass: json['subclass'] as String?,
      background: json['background'] != null
          ? Background.fromJson(json['background'] as Map<String, dynamic>)
          : null,
      feats: (json['feats'] as List<dynamic>?)
          ?.map((f) => Feat.fromJson(f as Map<String, dynamic>))
          .toList(),
      level: json['level'] as int,
      experience: json['experience'] as int,
      baseStrength: json['baseStrength'] as int,
      baseDexterity: json['baseDexterity'] as int,
      baseConstitution: json['baseConstitution'] as int,
      baseIntelligence: json['baseIntelligence'] as int,
      baseWisdom: json['baseWisdom'] as int,
      baseCharisma: json['baseCharisma'] as int,
      asiIncreases: (json['asiIncreases'] as Map<String, dynamic>?)?.cast<String, int>(),
      hpCurrent: json['hpCurrent'] as int,
      hpMax: json['hpMax'] as int,
      tempHp: json['tempHp'] as int? ?? 0,
      armorClass: json['armorClass'] as int,
      proficiencyBonus: json['proficiencyBonus'] as int,
      hitDiceRemaining: json['hitDiceRemaining'] as int,
      inventory: (json['inventory'] as List<dynamic>?)
          ?.map((i) => Item.fromJson(i as Map<String, dynamic>))
          .toList(),
      equippedWeapon: json['equippedWeapon'] != null
          ? Item.fromJson(json['equippedWeapon'] as Map<String, dynamic>)
          : null,
      equippedArmor: json['equippedArmor'] != null
          ? Item.fromJson(json['equippedArmor'] as Map<String, dynamic>)
          : null,
      equippedShield: json['equippedShield'] != null
          ? Item.fromJson(json['equippedShield'] as Map<String, dynamic>)
          : null,
      skillProficiencies: (json['skillProficiencies'] as Map<String, dynamic>?)?.cast<String, bool>(),
      skillExpertise: (json['skillExpertise'] as Map<String, dynamic>?)?.cast<String, bool>(),
      savingThrowProficiencies: (json['savingThrowProficiencies'] as List<dynamic>?)?.cast<String>().toSet(),
      spellSlots: json['spellSlots'] != null
          ? SpellSlots.fromJson(json['spellSlots'] as Map<String, dynamic>)
          : null,
      knownSpells: (json['knownSpells'] as List<dynamic>?)
          ?.map((s) => Spell.fromJson(s as Map<String, dynamic>))
          .toList(),
      preparedSpells: (json['preparedSpells'] as List<dynamic>?)
          ?.map((s) => Spell.fromJson(s as Map<String, dynamic>))
          .toList(),
      cantrips: (json['cantrips'] as List<dynamic>?)
          ?.map((s) => Spell.fromJson(s as Map<String, dynamic>))
          .toList(),
      concentrationManager: json['concentrationManager'] != null
          ? ConcentrationManager.fromJson(json['concentrationManager'] as Map<String, dynamic>)
          : null,
      classResources: (json['classResources'] as Map<String, dynamic>?)?.cast<String, int>(),
      maxClassResources: (json['maxClassResources'] as Map<String, dynamic>?)?.cast<String, int>(),
      classFeatures: (json['classFeatures'] as Map<String, dynamic>?)?.cast<String, bool>(),
      secondWindUses: json['secondWindUses'] as int?,
      actionSurgeUses: json['actionSurgeUses'] as int?,
      fightingStyle: json['fightingStyle'] as String?,
      sneakAttackDice: json['sneakAttackDice'] as int?,
      rageUses: json['rageUses'] as int?,
      rageDamageBonus: json['rageDamageBonus'] as int?,
      isRaging: json['isRaging'] as bool?,
      kiPoints: json['kiPoints'] as int?,
      maxKiPoints: json['maxKiPoints'] as int?,
      martialArtsDie: json['martialArtsDie'] as int?,
      bardicInspirationDie: json['bardicInspirationDie'] as int?,
      bardicInspirationUses: json['bardicInspirationUses'] as int?,
      layOnHandsPool: json['layOnHandsPool'] as int?,
      activeConditions: (json['activeConditions'] as List<dynamic>?)?.cast<String>(),
      speed: json['speed'] as int?,
      personalityTrait1: json['personalityTrait1'] as String?,
      personalityTrait2: json['personalityTrait2'] as String?,
      ideal: json['ideal'] as String?,
      bond: json['bond'] as String?,
      flaw: json['flaw'] as String?,
    );
    return char;
  }
}
