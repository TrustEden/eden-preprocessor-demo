class CharacterClass {
  String id;
  String name;
  String description;

  // Core attributes
  int hitDie; // d6, d8, d10, d12
  String primaryAbility;
  List<String> savingThrowProficiencies;

  // Starting proficiencies
  List<String> armorProficiencies;
  List<String> weaponProficiencies;
  List<String> toolProficiencies;
  int skillChoices; // Number of skills to choose
  List<String> skillOptions; // Skills available to choose from

  // Spellcasting
  bool isSpellcaster;
  String? spellcastingAbility;
  bool? preparesSpells; // true if prepares spells (Wizard, Cleric), false if knows spells (Sorcerer, Bard)

  // Class features by level
  Map<int, List<ClassFeature>> featuresByLevel;

  // Subclasses
  int subclassLevel; // Level when subclass is chosen (usually 3, sometimes 1 or 2)
  List<String> subclassOptions;

  CharacterClass({
    required this.id,
    required this.name,
    required this.description,
    required this.hitDie,
    required this.primaryAbility,
    required this.savingThrowProficiencies,
    required this.armorProficiencies,
    required this.weaponProficiencies,
    required this.toolProficiencies,
    required this.skillChoices,
    required this.skillOptions,
    required this.isSpellcaster,
    this.spellcastingAbility,
    this.preparesSpells,
    required this.featuresByLevel,
    required this.subclassLevel,
    required this.subclassOptions,
  });

  List<ClassFeature> getFeaturesAtLevel(int level) {
    return featuresByLevel[level] ?? [];
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'hitDie': hitDie,
    'primaryAbility': primaryAbility,
    'savingThrowProficiencies': savingThrowProficiencies,
    'armorProficiencies': armorProficiencies,
    'weaponProficiencies': weaponProficiencies,
    'toolProficiencies': toolProficiencies,
    'skillChoices': skillChoices,
    'skillOptions': skillOptions,
    'isSpellcaster': isSpellcaster,
    'spellcastingAbility': spellcastingAbility,
    'preparesSpells': preparesSpells,
    'featuresByLevel': featuresByLevel.map(
      (level, features) => MapEntry(
        level.toString(),
        features.map((f) => f.toJson()).toList(),
      ),
    ),
    'subclassLevel': subclassLevel,
    'subclassOptions': subclassOptions,
  };

  factory CharacterClass.fromJson(Map<String, dynamic> json) => CharacterClass(
    id: json['id'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
    hitDie: json['hitDie'] as int,
    primaryAbility: json['primaryAbility'] as String,
    savingThrowProficiencies: (json['savingThrowProficiencies'] as List<dynamic>).cast<String>(),
    armorProficiencies: (json['armorProficiencies'] as List<dynamic>).cast<String>(),
    weaponProficiencies: (json['weaponProficiencies'] as List<dynamic>).cast<String>(),
    toolProficiencies: (json['toolProficiencies'] as List<dynamic>).cast<String>(),
    skillChoices: json['skillChoices'] as int,
    skillOptions: (json['skillOptions'] as List<dynamic>).cast<String>(),
    isSpellcaster: json['isSpellcaster'] as bool,
    spellcastingAbility: json['spellcastingAbility'] as String?,
    preparesSpells: json['preparesSpells'] as bool?,
    featuresByLevel: (json['featuresByLevel'] as Map<String, dynamic>).map(
      (level, features) => MapEntry(
        int.parse(level),
        (features as List<dynamic>)
            .map((f) => ClassFeature.fromJson(f as Map<String, dynamic>))
            .toList(),
      ),
    ),
    subclassLevel: json['subclassLevel'] as int,
    subclassOptions: (json['subclassOptions'] as List<dynamic>).cast<String>(),
  );
}

class ClassFeature {
  String name;
  String description;
  String? effect; // For programmatic effects
  int? usesPerRest; // For limited use features
  String? restType; // "short" or "long"

  ClassFeature({
    required this.name,
    required this.description,
    this.effect,
    this.usesPerRest,
    this.restType,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'effect': effect,
    'usesPerRest': usesPerRest,
    'restType': restType,
  };

  factory ClassFeature.fromJson(Map<String, dynamic> json) => ClassFeature(
    name: json['name'] as String,
    description: json['description'] as String,
    effect: json['effect'] as String?,
    usesPerRest: json['usesPerRest'] as int?,
    restType: json['restType'] as String?,
  );
}

// Predefined classes
class CharacterClasses {
  static CharacterClass fighter() {
    return CharacterClass(
      id: 'fighter',
      name: 'Fighter',
      description: 'A master of martial combat, skilled with a variety of weapons and armor.',
      hitDie: 10,
      primaryAbility: 'Strength or Dexterity',
      savingThrowProficiencies: ['Strength', 'Constitution'],
      armorProficiencies: ['All armor', 'Shields'],
      weaponProficiencies: ['Simple weapons', 'Martial weapons'],
      toolProficiencies: [],
      skillChoices: 2,
      skillOptions: ['Acrobatics', 'Animal Handling', 'Athletics', 'History', 'Insight', 'Intimidation', 'Perception', 'Survival'],
      isSpellcaster: false,
      featuresByLevel: {
        1: [
          ClassFeature(name: 'Fighting Style', description: 'Choose a fighting style: Archery, Defense, Dueling, Great Weapon Fighting, Protection, or Two-Weapon Fighting.'),
          ClassFeature(name: 'Second Wind', description: 'You can use a bonus action to regain HP equal to 1d10 + your fighter level. Once you use this feature, you must finish a short or long rest before you can use it again.', usesPerRest: 1, restType: 'short'),
        ],
        2: [
          ClassFeature(name: 'Action Surge', description: 'You can take one additional action on your turn. You must finish a short or long rest before you can use it again.', usesPerRest: 1, restType: 'short'),
        ],
        3: [
          ClassFeature(name: 'Martial Archetype', description: 'Choose a martial archetype: Champion, Battle Master, or Eldritch Knight.'),
        ],
        4: [
          ClassFeature(name: 'Ability Score Improvement', description: 'Increase one ability score by 2, or two ability scores by 1, or take a feat.'),
        ],
        5: [
          ClassFeature(name: 'Extra Attack', description: 'You can attack twice, instead of once, whenever you take the Attack action on your turn.'),
        ],
        6: [
          ClassFeature(name: 'Ability Score Improvement', description: 'Increase one ability score by 2, or two ability scores by 1, or take a feat.'),
        ],
        7: [
          ClassFeature(name: 'Martial Archetype Feature', description: 'Gain a feature from your chosen archetype.'),
        ],
        8: [
          ClassFeature(name: 'Ability Score Improvement', description: 'Increase one ability score by 2, or two ability scores by 1, or take a feat.'),
        ],
        9: [
          ClassFeature(name: 'Indomitable', description: 'You can reroll a saving throw that you fail. You must finish a long rest before you can use this feature again.', usesPerRest: 1, restType: 'long'),
        ],
        10: [
          ClassFeature(name: 'Martial Archetype Feature', description: 'Gain a feature from your chosen archetype.'),
        ],
        11: [
          ClassFeature(name: 'Extra Attack (2)', description: 'You can attack three times whenever you take the Attack action on your turn.'),
        ],
        12: [
          ClassFeature(name: 'Ability Score Improvement', description: 'Increase one ability score by 2, or two ability scores by 1, or take a feat.'),
        ],
        13: [
          ClassFeature(name: 'Indomitable (2 uses)', description: 'You can use Indomitable twice between long rests.', usesPerRest: 2, restType: 'long'),
        ],
        14: [
          ClassFeature(name: 'Ability Score Improvement', description: 'Increase one ability score by 2, or two ability scores by 1, or take a feat.'),
        ],
        15: [
          ClassFeature(name: 'Martial Archetype Feature', description: 'Gain a feature from your chosen archetype.'),
        ],
        16: [
          ClassFeature(name: 'Ability Score Improvement', description: 'Increase one ability score by 2, or two ability scores by 1, or take a feat.'),
        ],
        17: [
          ClassFeature(name: 'Action Surge (2 uses)', description: 'You can use Action Surge twice before a rest.', usesPerRest: 2, restType: 'short'),
          ClassFeature(name: 'Indomitable (3 uses)', description: 'You can use Indomitable three times between long rests.', usesPerRest: 3, restType: 'long'),
        ],
        18: [
          ClassFeature(name: 'Martial Archetype Feature', description: 'Gain a feature from your chosen archetype.'),
        ],
        19: [
          ClassFeature(name: 'Ability Score Improvement', description: 'Increase one ability score by 2, or two ability scores by 1, or take a feat.'),
        ],
        20: [
          ClassFeature(name: 'Extra Attack (3)', description: 'You can attack four times whenever you take the Attack action on your turn.'),
        ],
      },
      subclassLevel: 3,
      subclassOptions: ['Champion', 'Battle Master', 'Eldritch Knight'],
    );
  }

  static CharacterClass wizard() {
    return CharacterClass(
      id: 'wizard',
      name: 'Wizard',
      description: 'A scholarly magic-user capable of manipulating the structures of reality.',
      hitDie: 6,
      primaryAbility: 'Intelligence',
      savingThrowProficiencies: ['Intelligence', 'Wisdom'],
      armorProficiencies: [],
      weaponProficiencies: ['Daggers', 'Darts', 'Slings', 'Quarterstaffs', 'Light crossbows'],
      toolProficiencies: [],
      skillChoices: 2,
      skillOptions: ['Arcana', 'History', 'Insight', 'Investigation', 'Medicine', 'Religion'],
      isSpellcaster: true,
      spellcastingAbility: 'Intelligence',
      preparesSpells: true,
      featuresByLevel: {
        1: [
          ClassFeature(name: 'Spellcasting', description: 'You can cast wizard spells. Intelligence is your spellcasting ability.'),
          ClassFeature(name: 'Arcane Recovery', description: 'Once per day when you finish a short rest, you can recover spell slots with a combined level equal to or less than half your wizard level (rounded up).', usesPerRest: 1, restType: 'long'),
        ],
        2: [
          ClassFeature(name: 'Arcane Tradition', description: 'Choose an arcane tradition: School of Evocation, School of Abjuration, etc.'),
        ],
        3: [],
        4: [
          ClassFeature(name: 'Ability Score Improvement', description: 'Increase one ability score by 2, or two ability scores by 1, or take a feat.'),
        ],
        5: [],
        6: [
          ClassFeature(name: 'Arcane Tradition Feature', description: 'Gain a feature from your chosen tradition.'),
        ],
        7: [],
        8: [
          ClassFeature(name: 'Ability Score Improvement', description: 'Increase one ability score by 2, or two ability scores by 1, or take a feat.'),
        ],
        9: [],
        10: [
          ClassFeature(name: 'Arcane Tradition Feature', description: 'Gain a feature from your chosen tradition.'),
        ],
        11: [],
        12: [
          ClassFeature(name: 'Ability Score Improvement', description: 'Increase one ability score by 2, or two ability scores by 1, or take a feat.'),
        ],
        13: [],
        14: [
          ClassFeature(name: 'Arcane Tradition Feature', description: 'Gain a feature from your chosen tradition.'),
        ],
        15: [],
        16: [
          ClassFeature(name: 'Ability Score Improvement', description: 'Increase one ability score by 2, or two ability scores by 1, or take a feat.'),
        ],
        17: [],
        18: [
          ClassFeature(name: 'Spell Mastery', description: 'Choose a 1st-level and 2nd-level wizard spell. You can cast them at will.'),
        ],
        19: [
          ClassFeature(name: 'Ability Score Improvement', description: 'Increase one ability score by 2, or two ability scores by 1, or take a feat.'),
        ],
        20: [
          ClassFeature(name: 'Signature Spells', description: 'Choose two 3rd-level wizard spells. You always have them prepared and can cast each once without expending a spell slot. You regain this ability after a short or long rest.'),
        ],
      },
      subclassLevel: 2,
      subclassOptions: ['School of Evocation', 'School of Abjuration', 'School of Conjuration', 'School of Divination', 'School of Enchantment', 'School of Illusion', 'School of Necromancy', 'School of Transmutation'],
    );
  }

  static CharacterClass cleric() {
    return CharacterClass(
      id: 'cleric',
      name: 'Cleric',
      description: 'A priestly champion who wields divine magic in service of a higher power.',
      hitDie: 8,
      primaryAbility: 'Wisdom',
      savingThrowProficiencies: ['Wisdom', 'Charisma'],
      armorProficiencies: ['Light armor', 'Medium armor', 'Shields'],
      weaponProficiencies: ['Simple weapons'],
      toolProficiencies: [],
      skillChoices: 2,
      skillOptions: ['History', 'Insight', 'Medicine', 'Persuasion', 'Religion'],
      isSpellcaster: true,
      spellcastingAbility: 'Wisdom',
      preparesSpells: true,
      featuresByLevel: {
        1: [
          ClassFeature(name: 'Spellcasting', description: 'You can cast cleric spells. Wisdom is your spellcasting ability.'),
          ClassFeature(name: 'Divine Domain', description: 'Choose a divine domain: Life, Light, Knowledge, Nature, Tempest, Trickery, or War.'),
        ],
        2: [
          ClassFeature(name: 'Channel Divinity', description: 'You can channel divine energy. You regain uses after a short or long rest.', usesPerRest: 1, restType: 'short'),
          ClassFeature(name: 'Divine Domain Feature', description: 'Gain a Channel Divinity option from your domain.'),
        ],
        3: [],
        4: [
          ClassFeature(name: 'Ability Score Improvement', description: 'Increase one ability score by 2, or two ability scores by 1, or take a feat.'),
        ],
        5: [
          ClassFeature(name: 'Destroy Undead (CR 1/2)', description: 'When an undead fails its saving throw against your Turn Undead, it is instantly destroyed if its CR is 1/2 or lower.'),
        ],
        6: [
          ClassFeature(name: 'Channel Divinity (2/rest)', description: 'You can use Channel Divinity twice between rests.', usesPerRest: 2, restType: 'short'),
          ClassFeature(name: 'Divine Domain Feature', description: 'Gain a feature from your chosen domain.'),
        ],
        7: [],
        8: [
          ClassFeature(name: 'Ability Score Improvement', description: 'Increase one ability score by 2, or two ability scores by 1, or take a feat.'),
          ClassFeature(name: 'Destroy Undead (CR 1)', description: 'Destroy undead of CR 1 or lower.'),
          ClassFeature(name: 'Divine Domain Feature', description: 'Gain a feature from your chosen domain.'),
        ],
        9: [],
        10: [
          ClassFeature(name: 'Divine Intervention', description: 'You can call on your deity for aid. Roll percentile dice - if you roll equal to or less than your cleric level, your deity intervenes.', usesPerRest: 1, restType: 'long'),
        ],
        11: [
          ClassFeature(name: 'Destroy Undead (CR 2)', description: 'Destroy undead of CR 2 or lower.'),
        ],
        12: [
          ClassFeature(name: 'Ability Score Improvement', description: 'Increase one ability score by 2, or two ability scores by 1, or take a feat.'),
        ],
        13: [],
        14: [
          ClassFeature(name: 'Destroy Undead (CR 3)', description: 'Destroy undead of CR 3 or lower.'),
        ],
        15: [],
        16: [
          ClassFeature(name: 'Ability Score Improvement', description: 'Increase one ability score by 2, or two ability scores by 1, or take a feat.'),
        ],
        17: [
          ClassFeature(name: 'Destroy Undead (CR 4)', description: 'Destroy undead of CR 4 or lower.'),
          ClassFeature(name: 'Divine Domain Feature', description: 'Gain a feature from your chosen domain.'),
        ],
        18: [
          ClassFeature(name: 'Channel Divinity (3/rest)', description: 'You can use Channel Divinity three times between rests.', usesPerRest: 3, restType: 'short'),
        ],
        19: [
          ClassFeature(name: 'Ability Score Improvement', description: 'Increase one ability score by 2, or two ability scores by 1, or take a feat.'),
        ],
        20: [
          ClassFeature(name: 'Divine Intervention Improvement', description: 'Your Divine Intervention automatically succeeds.'),
        ],
      },
      subclassLevel: 1,
      subclassOptions: ['Life Domain', 'Light Domain', 'Knowledge Domain', 'Nature Domain', 'Tempest Domain', 'Trickery Domain', 'War Domain'],
    );
  }

  static CharacterClass rogue() {
    return CharacterClass(
      id: 'rogue',
      name: 'Rogue',
      description: 'A scoundrel who uses stealth and trickery to overcome obstacles and enemies.',
      hitDie: 8,
      primaryAbility: 'Dexterity',
      savingThrowProficiencies: ['Dexterity', 'Intelligence'],
      armorProficiencies: ['Light armor'],
      weaponProficiencies: ['Simple weapons', 'Hand crossbows', 'Longswords', 'Rapiers', 'Shortswords'],
      toolProficiencies: ['Thieves\' tools'],
      skillChoices: 4,
      skillOptions: ['Acrobatics', 'Athletics', 'Deception', 'Insight', 'Intimidation', 'Investigation', 'Perception', 'Performance', 'Persuasion', 'Sleight of Hand', 'Stealth'],
      isSpellcaster: false,
      featuresByLevel: {
        1: [
          ClassFeature(name: 'Expertise', description: 'Choose two of your skill proficiencies. Your proficiency bonus is doubled for those skills.'),
          ClassFeature(name: 'Sneak Attack', description: 'Once per turn, you can deal an extra 1d6 damage to one creature you hit with an attack if you have advantage. Damage increases as you level up.'),
          ClassFeature(name: 'Thieves\' Cant', description: 'You know a secret mix of dialect, jargon, and code for sending hidden messages.'),
        ],
        2: [
          ClassFeature(name: 'Cunning Action', description: 'You can take a bonus action on each of your turns to Dash, Disengage, or Hide.'),
        ],
        3: [
          ClassFeature(name: 'Roguish Archetype', description: 'Choose an archetype: Thief, Assassin, or Arcane Trickster.'),
          ClassFeature(name: 'Sneak Attack (2d6)', description: 'Your Sneak Attack damage increases to 2d6.'),
        ],
        4: [
          ClassFeature(name: 'Ability Score Improvement', description: 'Increase one ability score by 2, or two ability scores by 1, or take a feat.'),
        ],
        5: [
          ClassFeature(name: 'Uncanny Dodge', description: 'When an attacker you can see hits you with an attack, you can use your reaction to halve the attack\'s damage.'),
          ClassFeature(name: 'Sneak Attack (3d6)', description: 'Your Sneak Attack damage increases to 3d6.'),
        ],
        6: [
          ClassFeature(name: 'Expertise', description: 'Choose two more skill proficiencies to gain expertise in.'),
        ],
        7: [
          ClassFeature(name: 'Evasion', description: 'When you are subjected to an effect that allows a Dexterity saving throw to take half damage, you take no damage on success and half on failure.'),
          ClassFeature(name: 'Sneak Attack (4d6)', description: 'Your Sneak Attack damage increases to 4d6.'),
        ],
        8: [
          ClassFeature(name: 'Ability Score Improvement', description: 'Increase one ability score by 2, or two ability scores by 1, or take a feat.'),
        ],
        9: [
          ClassFeature(name: 'Roguish Archetype Feature', description: 'Gain a feature from your chosen archetype.'),
          ClassFeature(name: 'Sneak Attack (5d6)', description: 'Your Sneak Attack damage increases to 5d6.'),
        ],
        10: [
          ClassFeature(name: 'Ability Score Improvement', description: 'Increase one ability score by 2, or two ability scores by 1, or take a feat.'),
        ],
        11: [
          ClassFeature(name: 'Reliable Talent', description: 'Whenever you make an ability check using a skill you\'re proficient in, you can treat a roll of 9 or lower as a 10.'),
          ClassFeature(name: 'Sneak Attack (6d6)', description: 'Your Sneak Attack damage increases to 6d6.'),
        ],
        12: [
          ClassFeature(name: 'Ability Score Improvement', description: 'Increase one ability score by 2, or two ability scores by 1, or take a feat.'),
        ],
        13: [
          ClassFeature(name: 'Roguish Archetype Feature', description: 'Gain a feature from your chosen archetype.'),
          ClassFeature(name: 'Sneak Attack (7d6)', description: 'Your Sneak Attack damage increases to 7d6.'),
        ],
        14: [
          ClassFeature(name: 'Blindsense', description: 'You can sense invisible or hidden creatures within 10 feet.'),
        ],
        15: [
          ClassFeature(name: 'Slippery Mind', description: 'You gain proficiency in Wisdom saving throws.'),
          ClassFeature(name: 'Sneak Attack (8d6)', description: 'Your Sneak Attack damage increases to 8d6.'),
        ],
        16: [
          ClassFeature(name: 'Ability Score Improvement', description: 'Increase one ability score by 2, or two ability scores by 1, or take a feat.'),
        ],
        17: [
          ClassFeature(name: 'Roguish Archetype Feature', description: 'Gain a feature from your chosen archetype.'),
          ClassFeature(name: 'Sneak Attack (9d6)', description: 'Your Sneak Attack damage increases to 9d6.'),
        ],
        18: [
          ClassFeature(name: 'Elusive', description: 'No attack roll has advantage against you while you aren\'t incapacitated.'),
        ],
        19: [
          ClassFeature(name: 'Ability Score Improvement', description: 'Increase one ability score by 2, or two ability scores by 1, or take a feat.'),
          ClassFeature(name: 'Sneak Attack (10d6)', description: 'Your Sneak Attack damage increases to 10d6.'),
        ],
        20: [
          ClassFeature(name: 'Stroke of Luck', description: 'If you miss with an attack, you can turn the miss into a hit. Alternatively, if you fail an ability check, you can treat the roll as a 20. Once used, must finish short or long rest.', usesPerRest: 1, restType: 'short'),
        ],
      },
      subclassLevel: 3,
      subclassOptions: ['Thief', 'Assassin', 'Arcane Trickster'],
    );
  }

  // Abbreviated versions for remaining classes to save space
  // In production, these would be fully fleshed out

  static CharacterClass barbarian() {
    return CharacterClass(
      id: 'barbarian',
      name: 'Barbarian',
      description: 'A fierce warrior of primitive background who can enter a battle rage.',
      hitDie: 12,
      primaryAbility: 'Strength',
      savingThrowProficiencies: ['Strength', 'Constitution'],
      armorProficiencies: ['Light armor', 'Medium armor', 'Shields'],
      weaponProficiencies: ['Simple weapons', 'Martial weapons'],
      toolProficiencies: [],
      skillChoices: 2,
      skillOptions: ['Animal Handling', 'Athletics', 'Intimidation', 'Nature', 'Perception', 'Survival'],
      isSpellcaster: false,
      featuresByLevel: {
        1: [
          ClassFeature(name: 'Rage', description: 'You can enter a rage as a bonus action. While raging, you gain bonus damage, resistance to physical damage, and advantage on Strength checks and saves.', usesPerRest: 2, restType: 'long'),
          ClassFeature(name: 'Unarmored Defense', description: 'While not wearing armor, your AC equals 10 + Dexterity modifier + Constitution modifier.'),
        ],
        2: [
          ClassFeature(name: 'Reckless Attack', description: 'When you make your first attack on your turn, you can gain advantage on melee weapon attacks, but attacks against you have advantage until your next turn.'),
          ClassFeature(name: 'Danger Sense', description: 'You have advantage on Dexterity saving throws against effects you can see.'),
        ],
        3: [
          ClassFeature(name: 'Primal Path', description: 'Choose a primal path: Path of the Berserker or Path of the Totem Warrior.'),
          ClassFeature(name: 'Rage (3 uses)', description: 'You can rage 3 times per long rest.', usesPerRest: 3, restType: 'long'),
        ],
        5: [
          ClassFeature(name: 'Extra Attack', description: 'You can attack twice when you take the Attack action.'),
          ClassFeature(name: 'Fast Movement', description: 'Your speed increases by 10 feet while you aren\'t wearing heavy armor.'),
        ],
        7: [
          ClassFeature(name: 'Feral Instinct', description: 'You have advantage on initiative rolls. If surprised, you can act normally on your first turn if you rage.'),
        ],
        9: [
          ClassFeature(name: 'Brutal Critical (1 die)', description: 'You can roll one additional weapon damage die when determining critical hit damage.'),
        ],
        11: [
          ClassFeature(name: 'Relentless Rage', description: 'If you drop to 0 HP while raging, you can make a DC 10 Constitution save to stay at 1 HP. DC increases by 5 for each use.'),
        ],
        15: [
          ClassFeature(name: 'Persistent Rage', description: 'Your rage only ends early if you fall unconscious or choose to end it.'),
        ],
        18: [
          ClassFeature(name: 'Indomitable Might', description: 'If your Strength check total is less than your Strength score, you can use your Strength score instead.'),
        ],
        20: [
          ClassFeature(name: 'Primal Champion', description: 'Your Strength and Constitution scores increase by 4, to a maximum of 24.'),
        ],
      },
      subclassLevel: 3,
      subclassOptions: ['Path of the Berserker', 'Path of the Totem Warrior'],
    );
  }

  static CharacterClass bard() {
    return CharacterClass(
      id: 'bard',
      name: 'Bard',
      description: 'An inspiring magician whose power echoes the music of creation.',
      hitDie: 8,
      primaryAbility: 'Charisma',
      savingThrowProficiencies: ['Dexterity', 'Charisma'],
      armorProficiencies: ['Light armor'],
      weaponProficiencies: ['Simple weapons', 'Hand crossbows', 'Longswords', 'Rapiers', 'Shortswords'],
      toolProficiencies: ['Three musical instruments of your choice'],
      skillChoices: 3,
      skillOptions: ['Any'],
      isSpellcaster: true,
      spellcastingAbility: 'Charisma',
      preparesSpells: false,
      featuresByLevel: {
        1: [
          ClassFeature(name: 'Spellcasting', description: 'You can cast bard spells. Charisma is your spellcasting ability.'),
          ClassFeature(name: 'Bardic Inspiration (d6)', description: 'As a bonus action, give an ally a d6 they can add to an ability check, attack, or save. You have Charisma modifier uses per long rest.'),
        ],
        2: [
          ClassFeature(name: 'Jack of All Trades', description: 'Add half your proficiency bonus to any ability check you make that doesn\'t already use proficiency.'),
          ClassFeature(name: 'Song of Rest (d6)', description: 'During a short rest, allies who spend Hit Dice to regain HP gain an extra 1d6.'),
        ],
        3: [
          ClassFeature(name: 'Bard College', description: 'Choose a bard college: College of Lore or College of Valor.'),
          ClassFeature(name: 'Expertise', description: 'Choose two skill proficiencies. Your proficiency bonus is doubled for those skills.'),
        ],
        5: [
          ClassFeature(name: 'Bardic Inspiration (d8)', description: 'Your Bardic Inspiration die becomes a d8.'),
          ClassFeature(name: 'Font of Inspiration', description: 'You regain all uses of Bardic Inspiration after a short or long rest.'),
        ],
        6: [
          ClassFeature(name: 'Countercharm', description: 'As an action, grant allies within 30 feet advantage on saves vs. being frightened or charmed.'),
          ClassFeature(name: 'Bard College Feature', description: 'Gain a feature from your chosen college.'),
        ],
        10: [
          ClassFeature(name: 'Bardic Inspiration (d10)', description: 'Your Bardic Inspiration die becomes a d10.'),
          ClassFeature(name: 'Expertise', description: 'Choose two more skill proficiencies to gain expertise in.'),
          ClassFeature(name: 'Magical Secrets', description: 'Choose two spells from any class. They count as bard spells for you.'),
        ],
        14: [
          ClassFeature(name: 'Bard College Feature', description: 'Gain a feature from your chosen college.'),
        ],
        15: [
          ClassFeature(name: 'Bardic Inspiration (d12)', description: 'Your Bardic Inspiration die becomes a d12.'),
        ],
        18: [
          ClassFeature(name: 'Magical Secrets', description: 'Choose two more spells from any class.'),
        ],
        20: [
          ClassFeature(name: 'Superior Inspiration', description: 'When you roll initiative and have no uses of Bardic Inspiration left, you regain one use.'),
        ],
      },
      subclassLevel: 3,
      subclassOptions: ['College of Lore', 'College of Valor'],
    );
  }

  static CharacterClass druid() {
    return CharacterClass(
      id: 'druid',
      name: 'Druid',
      description: 'A priest of the Old Faith, wielding the powers of nature.',
      hitDie: 8,
      primaryAbility: 'Wisdom',
      savingThrowProficiencies: ['Intelligence', 'Wisdom'],
      armorProficiencies: ['Light armor (non-metal)', 'Medium armor (non-metal)', 'Shields (non-metal)'],
      weaponProficiencies: ['Clubs', 'Daggers', 'Darts', 'Javelins', 'Maces', 'Quarterstaffs', 'Scimitars', 'Sickles', 'Slings', 'Spears'],
      toolProficiencies: ['Herbalism kit'],
      skillChoices: 2,
      skillOptions: ['Arcana', 'Animal Handling', 'Insight', 'Medicine', 'Nature', 'Perception', 'Religion', 'Survival'],
      isSpellcaster: true,
      spellcastingAbility: 'Wisdom',
      preparesSpells: true,
      featuresByLevel: {
        1: [
          ClassFeature(name: 'Spellcasting', description: 'You can cast druid spells. Wisdom is your spellcasting ability.'),
          ClassFeature(name: 'Druidic', description: 'You know Druidic, the secret language of druids.'),
        ],
        2: [
          ClassFeature(name: 'Wild Shape', description: 'You can use your action to transform into a beast you\'ve seen. You can use this twice per short or long rest.', usesPerRest: 2, restType: 'short'),
          ClassFeature(name: 'Druid Circle', description: 'Choose a druid circle: Circle of the Land or Circle of the Moon.'),
        ],
        18: [
          ClassFeature(name: 'Timeless Body', description: 'For every 10 years that pass, your body ages only 1 year.'),
          ClassFeature(name: 'Beast Spells', description: 'You can cast spells in Wild Shape form.'),
        ],
        20: [
          ClassFeature(name: 'Archdruid', description: 'You can use Wild Shape an unlimited number of times. You ignore verbal and somatic components of druid spells, and material components without cost.'),
        ],
      },
      subclassLevel: 2,
      subclassOptions: ['Circle of the Land', 'Circle of the Moon'],
    );
  }

  static CharacterClass monk() {
    return CharacterClass(
      id: 'monk',
      name: 'Monk',
      description: 'A master of martial arts, harnessing the power of the body in pursuit of physical and spiritual perfection.',
      hitDie: 8,
      primaryAbility: 'Dexterity and Wisdom',
      savingThrowProficiencies: ['Strength', 'Dexterity'],
      armorProficiencies: [],
      weaponProficiencies: ['Simple weapons', 'Shortswords'],
      toolProficiencies: ['Choose one artisan\'s tool or musical instrument'],
      skillChoices: 2,
      skillOptions: ['Acrobatics', 'Athletics', 'History', 'Insight', 'Religion', 'Stealth'],
      isSpellcaster: false,
      featuresByLevel: {
        1: [
          ClassFeature(name: 'Unarmored Defense', description: 'While not wearing armor or wielding a shield, AC = 10 + Dex mod + Wis mod.'),
          ClassFeature(name: 'Martial Arts', description: 'You can use Dexterity instead of Strength for attack/damage rolls with monk weapons and unarmed strikes. You can roll a d4 for damage (increases at higher levels). When you attack with unarmed strike or monk weapon, you can make one unarmed strike as a bonus action.'),
        ],
        2: [
          ClassFeature(name: 'Ki', description: 'You have 2 ki points. You can spend ki to use Flurry of Blows, Patient Defense, or Step of the Wind.'),
          ClassFeature(name: 'Unarmored Movement', description: 'Your speed increases by 10 feet while not wearing armor or wielding a shield.'),
        ],
        3: [
          ClassFeature(name: 'Monastic Tradition', description: 'Choose a tradition: Way of the Open Hand, Way of Shadow, Way of the Four Elements.'),
          ClassFeature(name: 'Deflect Missiles', description: 'You can use your reaction to deflect or catch a missile when hit by a ranged weapon attack.'),
        ],
        5: [
          ClassFeature(name: 'Extra Attack', description: 'You can attack twice when you take the Attack action.'),
          ClassFeature(name: 'Stunning Strike', description: 'When you hit with a melee weapon attack, you can spend 1 ki point to attempt to stun the target.'),
        ],
        6: [
          ClassFeature(name: 'Ki-Empowered Strikes', description: 'Your unarmed strikes count as magical for overcoming resistance.'),
          ClassFeature(name: 'Monastic Tradition Feature', description: 'Gain a feature from your chosen tradition.'),
        ],
        14: [
          ClassFeature(name: 'Diamond Soul', description: 'You gain proficiency in all saving throws. You can spend 1 ki point to reroll a failed save.'),
        ],
        18: [
          ClassFeature(name: 'Empty Body', description: 'You can spend 4 ki points to become invisible for 1 minute. You have resistance to all damage except force damage.'),
        ],
        20: [
          ClassFeature(name: 'Perfect Self', description: 'When you roll initiative and have no ki points remaining, you regain 4 ki points.'),
        ],
      },
      subclassLevel: 3,
      subclassOptions: ['Way of the Open Hand', 'Way of Shadow', 'Way of the Four Elements'],
    );
  }

  static CharacterClass paladin() {
    return CharacterClass(
      id: 'paladin',
      name: 'Paladin',
      description: 'A holy warrior bound to a sacred oath.',
      hitDie: 10,
      primaryAbility: 'Strength and Charisma',
      savingThrowProficiencies: ['Wisdom', 'Charisma'],
      armorProficiencies: ['All armor', 'Shields'],
      weaponProficiencies: ['Simple weapons', 'Martial weapons'],
      toolProficiencies: [],
      skillChoices: 2,
      skillOptions: ['Athletics', 'Insight', 'Intimidation', 'Medicine', 'Persuasion', 'Religion'],
      isSpellcaster: true,
      spellcastingAbility: 'Charisma',
      preparesSpells: true,
      featuresByLevel: {
        1: [
          ClassFeature(name: 'Divine Sense', description: 'You can detect the presence of celestials, fiends, or undead within 60 feet. You can use this feature a number of times equal to 1 + Charisma modifier.'),
          ClassFeature(name: 'Lay on Hands', description: 'You have a pool of healing power equal to paladin level x 5. As an action, you can restore HP or cure diseases/poisons.'),
        ],
        2: [
          ClassFeature(name: 'Fighting Style', description: 'Choose a fighting style: Defense, Dueling, Great Weapon Fighting, or Protection.'),
          ClassFeature(name: 'Spellcasting', description: 'You can cast paladin spells starting at 2nd level. Charisma is your spellcasting ability.'),
          ClassFeature(name: 'Divine Smite', description: 'When you hit with a melee weapon attack, you can expend a spell slot to deal extra radiant damage.'),
        ],
        3: [
          ClassFeature(name: 'Divine Health', description: 'You are immune to disease.'),
          ClassFeature(name: 'Sacred Oath', description: 'Choose an oath: Oath of Devotion, Oath of the Ancients, or Oath of Vengeance.'),
        ],
        5: [
          ClassFeature(name: 'Extra Attack', description: 'You can attack twice when you take the Attack action.'),
        ],
        6: [
          ClassFeature(name: 'Aura of Protection', description: 'You and friendly creatures within 10 feet gain a bonus to all saving throws equal to your Charisma modifier.'),
        ],
        10: [
          ClassFeature(name: 'Aura of Courage', description: 'You and friendly creatures within 10 feet can\'t be frightened while you are conscious.'),
        ],
        11: [
          ClassFeature(name: 'Improved Divine Smite', description: 'All your melee weapon attacks deal an extra 1d8 radiant damage.'),
        ],
        14: [
          ClassFeature(name: 'Cleansing Touch', description: 'You can end spells on yourself or others by touch. You can use this Charisma modifier times per long rest.'),
        ],
        18: [
          ClassFeature(name: 'Aura Improvements', description: 'Your auras extend to 30 feet.'),
        ],
        20: [
          ClassFeature(name: 'Sacred Oath Feature', description: 'Gain your oath\'s capstone feature.'),
        ],
      },
      subclassLevel: 3,
      subclassOptions: ['Oath of Devotion', 'Oath of the Ancients', 'Oath of Vengeance'],
    );
  }

  static CharacterClass ranger() {
    return CharacterClass(
      id: 'ranger',
      name: 'Ranger',
      description: 'A warrior who uses martial prowess and nature magic to combat threats on the edges of civilization.',
      hitDie: 10,
      primaryAbility: 'Dexterity and Wisdom',
      savingThrowProficiencies: ['Strength', 'Dexterity'],
      armorProficiencies: ['Light armor', 'Medium armor', 'Shields'],
      weaponProficiencies: ['Simple weapons', 'Martial weapons'],
      toolProficiencies: [],
      skillChoices: 3,
      skillOptions: ['Animal Handling', 'Athletics', 'Insight', 'Investigation', 'Nature', 'Perception', 'Stealth', 'Survival'],
      isSpellcaster: true,
      spellcastingAbility: 'Wisdom',
      preparesSpells: false,
      featuresByLevel: {
        1: [
          ClassFeature(name: 'Favored Enemy', description: 'You have advantage on Wisdom (Survival) checks to track your favored enemies and Intelligence checks to recall information about them.'),
          ClassFeature(name: 'Natural Explorer', description: 'You are particularly familiar with one type of natural environment and have advantages when traveling there.'),
        ],
        2: [
          ClassFeature(name: 'Fighting Style', description: 'Choose a fighting style: Archery, Defense, Dueling, or Two-Weapon Fighting.'),
          ClassFeature(name: 'Spellcasting', description: 'You can cast ranger spells. Wisdom is your spellcasting ability.'),
        ],
        3: [
          ClassFeature(name: 'Ranger Archetype', description: 'Choose an archetype: Hunter or Beast Master.'),
          ClassFeature(name: 'Primeval Awareness', description: 'You can use your action and expend a spell slot to sense certain creature types within 1 mile (or 6 miles if favored terrain).'),
        ],
        5: [
          ClassFeature(name: 'Extra Attack', description: 'You can attack twice when you take the Attack action.'),
        ],
        8: [
          ClassFeature(name: 'Land\'s Stride', description: 'Moving through nonmagical difficult terrain costs no extra movement. You can pass through plants without being slowed or taking damage, and have advantage on saves vs. plants that impede movement.'),
        ],
        10: [
          ClassFeature(name: 'Hide in Plain Sight', description: 'You can spend 1 minute creating camouflage for yourself, gaining +10 to Stealth while remaining still.'),
        ],
        14: [
          ClassFeature(name: 'Vanish', description: 'You can use Hide as a bonus action, and you can\'t be tracked by nonmagical means unless you choose to leave a trail.'),
        ],
        18: [
          ClassFeature(name: 'Feral Senses', description: 'You gain blindsight out to 30 feet. You can detect invisible creatures that aren\'t hidden.'),
        ],
        20: [
          ClassFeature(name: 'Foe Slayer', description: 'Once on each of your turns, you can add Wisdom modifier to attack or damage roll against one of your favored enemies.'),
        ],
      },
      subclassLevel: 3,
      subclassOptions: ['Hunter', 'Beast Master'],
    );
  }

  static CharacterClass sorcerer() {
    return CharacterClass(
      id: 'sorcerer',
      name: 'Sorcerer',
      description: 'A spellcaster who draws on inherent magic from a gift or bloodline.',
      hitDie: 6,
      primaryAbility: 'Charisma',
      savingThrowProficiencies: ['Constitution', 'Charisma'],
      armorProficiencies: [],
      weaponProficiencies: ['Daggers', 'Darts', 'Slings', 'Quarterstaffs', 'Light crossbows'],
      toolProficiencies: [],
      skillChoices: 2,
      skillOptions: ['Arcana', 'Deception', 'Insight', 'Intimidation', 'Persuasion', 'Religion'],
      isSpellcaster: true,
      spellcastingAbility: 'Charisma',
      preparesSpells: false,
      featuresByLevel: {
        1: [
          ClassFeature(name: 'Spellcasting', description: 'You can cast sorcerer spells. Charisma is your spellcasting ability.'),
          ClassFeature(name: 'Sorcerous Origin', description: 'Choose your origin: Draconic Bloodline or Wild Magic.'),
        ],
        2: [
          ClassFeature(name: 'Font of Magic', description: 'You have 2 sorcery points. You can convert sorcery points to spell slots and vice versa.'),
        ],
        3: [
          ClassFeature(name: 'Metamagic', description: 'You gain the ability to twist spells. Choose two Metamagic options: Careful Spell, Distant Spell, Empowered Spell, Extended Spell, Heightened Spell, Quickened Spell, Subtle Spell, or Twinned Spell.'),
        ],
        10: [
          ClassFeature(name: 'Metamagic', description: 'You learn an additional Metamagic option.'),
        ],
        17: [
          ClassFeature(name: 'Metamagic', description: 'You learn an additional Metamagic option.'),
        ],
        20: [
          ClassFeature(name: 'Sorcerous Restoration', description: 'You regain 4 expended sorcery points whenever you finish a short rest.'),
        ],
      },
      subclassLevel: 1,
      subclassOptions: ['Draconic Bloodline', 'Wild Magic'],
    );
  }

  static CharacterClass warlock() {
    return CharacterClass(
      id: 'warlock',
      name: 'Warlock',
      description: 'A wielder of magic derived from a bargain with an extraplanar entity.',
      hitDie: 8,
      primaryAbility: 'Charisma',
      savingThrowProficiencies: ['Wisdom', 'Charisma'],
      armorProficiencies: ['Light armor'],
      weaponProficiencies: ['Simple weapons'],
      toolProficiencies: [],
      skillChoices: 2,
      skillOptions: ['Arcana', 'Deception', 'History', 'Intimidation', 'Investigation', 'Nature', 'Religion'],
      isSpellcaster: true,
      spellcastingAbility: 'Charisma',
      preparesSpells: false,
      featuresByLevel: {
        1: [
          ClassFeature(name: 'Otherworldly Patron', description: 'Choose a patron: The Archfey, The Fiend, or The Great Old One.'),
          ClassFeature(name: 'Pact Magic', description: 'You can cast warlock spells using Charisma. Your spell slots recharge on a short rest.'),
        ],
        2: [
          ClassFeature(name: 'Eldritch Invocations', description: 'You gain two eldritch invocations of your choice. You learn more at higher levels.'),
        ],
        3: [
          ClassFeature(name: 'Pact Boon', description: 'Choose a pact boon: Pact of the Chain, Pact of the Blade, or Pact of the Tome.'),
        ],
        11: [
          ClassFeature(name: 'Mystic Arcanum (6th level)', description: 'Choose one 6th-level spell. You can cast it once per long rest without using a spell slot.'),
        ],
        13: [
          ClassFeature(name: 'Mystic Arcanum (7th level)', description: 'Choose one 7th-level spell. You can cast it once per long rest.'),
        ],
        15: [
          ClassFeature(name: 'Mystic Arcanum (8th level)', description: 'Choose one 8th-level spell. You can cast it once per long rest.'),
        ],
        17: [
          ClassFeature(name: 'Mystic Arcanum (9th level)', description: 'Choose one 9th-level spell. You can cast it once per long rest.'),
        ],
        20: [
          ClassFeature(name: 'Eldritch Master', description: 'You can spend 1 minute entreating your patron to regain all expended spell slots. Once used, must finish long rest.', usesPerRest: 1, restType: 'long'),
        ],
      },
      subclassLevel: 1,
      subclassOptions: ['The Archfey', 'The Fiend', 'The Great Old One'],
    );
  }

  static List<CharacterClass> getAllClasses() {
    return [
      barbarian(),
      bard(),
      cleric(),
      druid(),
      fighter(),
      monk(),
      paladin(),
      ranger(),
      rogue(),
      sorcerer(),
      warlock(),
      wizard(),
    ];
  }
}
