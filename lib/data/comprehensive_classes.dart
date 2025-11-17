// Comprehensive D&D 5e Class Database
// Includes all 13 official classes with complete progression tables

class DnDClass {
  final String name;
  final String description;
  final int hitDie;
  final List<String> primaryAbilities;
  final List<String> savingThrowProficiencies;
  final List<String> armorProficiencies;
  final List<String> weaponProficiencies;
  final List<String> toolProficiencies;
  final List<String> skillChoices;
  final int skillChoiceCount;
  final Map<int, ClassFeature> features; // Level -> Features
  final bool isSpellcaster;
  final String? spellcastingAbility;
  final Map<int, SpellSlots>? spellSlotsPerLevel;
  final List<String> subclasses;

  DnDClass({
    required this.name,
    required this.description,
    required this.hitDie,
    required this.primaryAbilities,
    required this.savingThrowProficiencies,
    required this.armorProficiencies,
    required this.weaponProficiencies,
    required this.toolProficiencies,
    required this.skillChoices,
    required this.skillChoiceCount,
    required this.features,
    required this.isSpellcaster,
    this.spellcastingAbility,
    this.spellSlotsPerLevel,
    required this.subclasses,
  });
}

class ClassFeature {
  final String name;
  final String description;
  final int level;

  ClassFeature({
    required this.name,
    required this.description,
    required this.level,
  });
}

class SpellSlots {
  final int level1;
  final int level2;
  final int level3;
  final int level4;
  final int level5;
  final int level6;
  final int level7;
  final int level8;
  final int level9;

  SpellSlots({
    this.level1 = 0,
    this.level2 = 0,
    this.level3 = 0,
    this.level4 = 0,
    this.level5 = 0,
    this.level6 = 0,
    this.level7 = 0,
    this.level8 = 0,
    this.level9 = 0,
  });
}

// ============================================================================
// ALL 13 D&D 5E CLASSES
// ============================================================================

final Map<String, DnDClass> allDnDClasses = {
  'Artificer': _artificer,
  'Barbarian': _barbarian,
  'Bard': _bard,
  'Cleric': _cleric,
  'Druid': _druid,
  'Fighter': _fighter,
  'Monk': _monk,
  'Paladin': _paladin,
  'Ranger': _ranger,
  'Rogue': _rogue,
  'Sorcerer': _sorcerer,
  'Warlock': _warlock,
  'Wizard': _wizard,
};

// ============================================================================
// ARTIFICER
// ============================================================================

final DnDClass _artificer = DnDClass(
  name: 'Artificer',
  description: 'Masters of invention, artificers use ingenuity and magic to unlock extraordinary capabilities in objects. They see magic as a complex system waiting to be decoded and controlled.',
  hitDie: 8,
  primaryAbilities: ['Intelligence'],
  savingThrowProficiencies: ['Constitution', 'Intelligence'],
  armorProficiencies: ['Light armor', 'Medium armor', 'Shields'],
  weaponProficiencies: ['Simple weapons'],
  toolProficiencies: ['Thieves\' tools', 'Tinker\'s tools', 'One type of artisan\'s tools'],
  skillChoices: ['Arcana', 'History', 'Investigation', 'Medicine', 'Nature', 'Perception', 'Sleight of Hand'],
  skillChoiceCount: 2,
  isSpellcaster: true,
  spellcastingAbility: 'Intelligence',
  spellSlotsPerLevel: _artificerSpellSlots,
  features: {
    1: ClassFeature(name: 'Magical Tinkering, Spellcasting', description: 'You can create tiny magical effects and cast artificer spells', level: 1),
    2: ClassFeature(name: 'Infuse Item', description: 'Imbue mundane items with magical infusions', level: 2),
    3: ClassFeature(name: 'Artificer Specialist', description: 'Choose a specialization: Alchemist, Armorer, Artillerist, or Battle Smith', level: 3),
    4: ClassFeature(name: 'Ability Score Improvement', description: '+2 to one ability or +1 to two abilities', level: 4),
    5: ClassFeature(name: 'Artificer Specialist Feature', description: 'Gain a feature from your specialization', level: 5),
    6: ClassFeature(name: 'Tool Expertise', description: 'Double proficiency bonus for tool checks', level: 6),
    7: ClassFeature(name: 'Flash of Genius', description: 'Add INT modifier to ability checks or saving throws', level: 7),
    8: ClassFeature(name: 'Ability Score Improvement', description: '+2 to one ability or +1 to two abilities', level: 8),
    9: ClassFeature(name: 'Artificer Specialist Feature', description: 'Gain a feature from your specialization', level: 9),
    10: ClassFeature(name: 'Magic Item Adept', description: 'Craft common and uncommon magic items faster', level: 10),
    11: ClassFeature(name: 'Spell-Storing Item', description: 'Store a spell in an object for others to use', level: 11),
    12: ClassFeature(name: 'Ability Score Improvement', description: '+2 to one ability or +1 to two abilities', level: 12),
    14: ClassFeature(name: 'Magic Item Savant', description: 'Ignore class, race, and level requirements on magic items', level: 14),
    15: ClassFeature(name: 'Artificer Specialist Feature', description: 'Gain a feature from your specialization', level: 15),
    16: ClassFeature(name: 'Ability Score Improvement', description: '+2 to one ability or +1 to two abilities', level: 16),
    18: ClassFeature(name: 'Magic Item Master', description: 'Attune to up to 6 magic items', level: 18),
    19: ClassFeature(name: 'Ability Score Improvement', description: '+2 to one ability or +1 to two abilities', level: 19),
    20: ClassFeature(name: 'Soul of Artifice', description: '+1 to all saving throws per magic item attuned, cheat death', level: 20),
  },
  subclasses: ['Alchemist', 'Armorer', 'Artillerist', 'Battle Smith'],
);

final Map<int, SpellSlots> _artificerSpellSlots = {
  1: SpellSlots(level1: 2),
  2: SpellSlots(level1: 2),
  3: SpellSlots(level1: 3),
  4: SpellSlots(level1: 3),
  5: SpellSlots(level1: 4, level2: 2),
  6: SpellSlots(level1: 4, level2: 2),
  7: SpellSlots(level1: 4, level2: 3),
  8: SpellSlots(level1: 4, level2: 3),
  9: SpellSlots(level1: 4, level2: 3, level3: 2),
  10: SpellSlots(level1: 4, level2: 3, level3: 2),
  11: SpellSlots(level1: 4, level2: 3, level3: 3),
  12: SpellSlots(level1: 4, level2: 3, level3: 3),
  13: SpellSlots(level1: 4, level2: 3, level3: 3, level4: 1),
  14: SpellSlots(level1: 4, level2: 3, level3: 3, level4: 1),
  15: SpellSlots(level1: 4, level2: 3, level3: 3, level4: 2),
  16: SpellSlots(level1: 4, level2: 3, level3: 3, level4: 2),
  17: SpellSlots(level1: 4, level2: 3, level3: 3, level4: 3, level5: 1),
  18: SpellSlots(level1: 4, level2: 3, level3: 3, level4: 3, level5: 1),
  19: SpellSlots(level1: 4, level2: 3, level3: 3, level4: 3, level5: 2),
  20: SpellSlots(level1: 4, level2: 3, level3: 3, level4: 3, level5: 2),
};

// ============================================================================
// BARBARIAN
// ============================================================================

final DnDClass _barbarian = DnDClass(
  name: 'Barbarian',
  description: 'A fierce warrior of primitive background who can enter a battle rage. Raw power and primal fury.',
  hitDie: 12,
  primaryAbilities: ['Strength'],
  savingThrowProficiencies: ['Strength', 'Constitution'],
  armorProficiencies: ['Light armor', 'Medium armor', 'Shields'],
  weaponProficiencies: ['Simple weapons', 'Martial weapons'],
  toolProficiencies: [],
  skillChoices: ['Animal Handling', 'Athletics', 'Intimidation', 'Nature', 'Perception', 'Survival'],
  skillChoiceCount: 2,
  isSpellcaster: false,
  features: {
    1: ClassFeature(name: 'Rage, Unarmored Defense', description: 'Enter rage for bonus damage and resistance. AC = 10 + DEX + CON', level: 1),
    2: ClassFeature(name: 'Reckless Attack, Danger Sense', description: 'Attack with advantage but enemies have advantage. Advantage on DEX saves vs seen effects', level: 2),
    3: ClassFeature(name: 'Primal Path', description: 'Choose Path of the Berserker, Totem Warrior, or other primal paths', level: 3),
    4: ClassFeature(name: 'Ability Score Improvement', description: '+2 to one ability or +1 to two abilities', level: 4),
    5: ClassFeature(name: 'Extra Attack, Fast Movement', description: 'Attack twice per action, +10 ft speed', level: 5),
    6: ClassFeature(name: 'Path Feature', description: 'Gain a feature from your primal path', level: 6),
    7: ClassFeature(name: 'Feral Instinct', description: 'Advantage on initiative, can\'t be surprised while raging', level: 7),
    8: ClassFeature(name: 'Ability Score Improvement', description: '+2 to one ability or +1 to two abilities', level: 8),
    9: ClassFeature(name: 'Brutal Critical (1 die)', description: 'Roll one additional weapon damage die on critical hit', level: 9),
    10: ClassFeature(name: 'Path Feature', description: 'Gain a feature from your primal path', level: 10),
    11: ClassFeature(name: 'Relentless Rage', description: 'Drop to 1 HP instead of 0 while raging (DC 10 CON save)', level: 11),
    12: ClassFeature(name: 'Ability Score Improvement', description: '+2 to one ability or +1 to two abilities', level: 12),
    13: ClassFeature(name: 'Brutal Critical (2 dice)', description: 'Roll two additional weapon damage dice on critical hit', level: 13),
    14: ClassFeature(name: 'Path Feature', description: 'Gain a feature from your primal path', level: 14),
    15: ClassFeature(name: 'Persistent Rage', description: 'Rage only ends if you fall unconscious or choose to end it', level: 15),
    16: ClassFeature(name: 'Ability Score Improvement', description: '+2 to one ability or +1 to two abilities', level: 16),
    17: ClassFeature(name: 'Brutal Critical (3 dice)', description: 'Roll three additional weapon damage dice on critical hit', level: 17),
    18: ClassFeature(name: 'Indomitable Might', description: 'STR checks less than STR score use STR score instead', level: 18),
    19: ClassFeature(name: 'Ability Score Improvement', description: '+2 to one ability or +1 to two abilities', level: 19),
    20: ClassFeature(name: 'Primal Champion', description: 'STR and CON increase by 4, maximum of 24', level: 20),
  },
  subclasses: ['Path of the Berserker', 'Path of the Totem Warrior', 'Path of the Ancestral Guardian', 'Path of the Storm Herald', 'Path of the Zealot', 'Path of the Beast', 'Path of Wild Magic'],
);

// ============================================================================
// BARD
// ============================================================================

final DnDClass _bard = DnDClass(
  name: 'Bard',
  description: 'An inspiring magician whose power echoes the music of creation. Masters of song, speech, and magic.',
  hitDie: 8,
  primaryAbilities: ['Charisma'],
  savingThrowProficiencies: ['Dexterity', 'Charisma'],
  armorProficiencies: ['Light armor'],
  weaponProficiencies: ['Simple weapons', 'Hand crossbows', 'Longswords', 'Rapiers', 'Shortswords'],
  toolProficiencies: ['Three musical instruments of your choice'],
  skillChoices: ['Any three skills'],
  skillChoiceCount: 3,
  isSpellcaster: true,
  spellcastingAbility: 'Charisma',
  spellSlotsPerLevel: _fullCasterSpellSlots,
  features: {
    1: ClassFeature(name: 'Spellcasting, Bardic Inspiration (d6)', description: 'Cast bard spells, inspire allies with bonus dice', level: 1),
    2: ClassFeature(name: 'Jack of All Trades, Song of Rest (d6)', description: 'Add half proficiency to non-proficient checks, heal during short rest', level: 2),
    3: ClassFeature(name: 'Bard College, Expertise', description: 'Choose college, double proficiency bonus on two skills', level: 3),
    4: ClassFeature(name: 'Ability Score Improvement', description: '+2 to one ability or +1 to two abilities', level: 4),
    5: ClassFeature(name: 'Bardic Inspiration (d8), Font of Inspiration', description: 'Larger inspiration die, regain uses on short rest', level: 5),
    6: ClassFeature(name: 'Countercharm, College Feature', description: 'Advantage vs charm and frighten, gain college feature', level: 6),
    8: ClassFeature(name: 'Ability Score Improvement', description: '+2 to one ability or +1 to two abilities', level: 8),
    9: ClassFeature(name: 'Song of Rest (d8)', description: 'Better short rest healing', level: 9),
    10: ClassFeature(name: 'Bardic Inspiration (d10), Expertise, Magical Secrets', description: 'Larger die, more expertise, learn any 2 spells', level: 10),
    12: ClassFeature(name: 'Ability Score Improvement', description: '+2 to one ability or +1 to two abilities', level: 12),
    13: ClassFeature(name: 'Song of Rest (d10)', description: 'Better short rest healing', level: 13),
    14: ClassFeature(name: 'Magical Secrets, College Feature', description: 'Learn any 2 spells, gain college feature', level: 14),
    15: ClassFeature(name: 'Bardic Inspiration (d12)', description: 'Largest inspiration die', level: 15),
    16: ClassFeature(name: 'Ability Score Improvement', description: '+2 to one ability or +1 to two abilities', level: 16),
    17: ClassFeature(name: 'Song of Rest (d12)', description: 'Best short rest healing', level: 17),
    18: ClassFeature(name: 'Magical Secrets', description: 'Learn any 2 spells', level: 18),
    19: ClassFeature(name: 'Ability Score Improvement', description: '+2 to one ability or +1 to two abilities', level: 19),
    20: ClassFeature(name: 'Superior Inspiration', description: 'Regain inspiration at start of turn if none remain', level: 20),
  },
  subclasses: ['College of Lore', 'College of Valor', 'College of Glamour', 'College of Swords', 'College of Whispers', 'College of Eloquence', 'College of Creation', 'College of Spirits'],
);

// ============================================================================
// CLERIC
// ============================================================================

final DnDClass _cleric = DnDClass(
  name: 'Cleric',
  description: 'A priestly champion who wields divine magic in service of a higher power. Healers and warriors of faith.',
  hitDie: 8,
  primaryAbilities: ['Wisdom'],
  savingThrowProficiencies: ['Wisdom', 'Charisma'],
  armorProficiencies: ['Light armor', 'Medium armor', 'Shields'],
  weaponProficiencies: ['Simple weapons'],
  toolProficiencies: [],
  skillChoices: ['History', 'Insight', 'Medicine', 'Persuasion', 'Religion'],
  skillChoiceCount: 2,
  isSpellcaster: true,
  spellcastingAbility: 'Wisdom',
  spellSlotsPerLevel: _fullCasterSpellSlots,
  features: {
    1: ClassFeature(name: 'Spellcasting, Divine Domain', description: 'Cast cleric spells, choose a divine domain', level: 1),
    2: ClassFeature(name: 'Channel Divinity (1/rest), Divine Domain Feature', description: 'Channel divine energy, gain domain feature', level: 2),
    4: ClassFeature(name: 'Ability Score Improvement', description: '+2 to one ability or +1 to two abilities', level: 4),
    5: ClassFeature(name: 'Destroy Undead (CR 1/2)', description: 'Instantly destroy low CR undead', level: 5),
    6: ClassFeature(name: 'Channel Divinity (2/rest), Domain Feature', description: 'More channel uses, gain domain feature', level: 6),
    8: ClassFeature(name: 'Ability Score Improvement, Destroy Undead (CR 1), Domain Feature', description: 'ASI, better undead destruction, domain feature', level: 8),
    10: ClassFeature(name: 'Divine Intervention', description: 'Call upon deity for help (low chance of success)', level: 10),
    11: ClassFeature(name: 'Destroy Undead (CR 2)', description: 'Destroy more powerful undead', level: 11),
    12: ClassFeature(name: 'Ability Score Improvement', description: '+2 to one ability or +1 to two abilities', level: 12),
    14: ClassFeature(name: 'Destroy Undead (CR 3)', description: 'Destroy even more powerful undead', level: 14),
    16: ClassFeature(name: 'Ability Score Improvement', description: '+2 to one ability or +1 to two abilities', level: 16),
    17: ClassFeature(name: 'Destroy Undead (CR 4), Domain Feature', description: 'Destroy very powerful undead, gain domain feature', level: 17),
    18: ClassFeature(name: 'Channel Divinity (3/rest)', description: 'Even more channel uses', level: 18),
    19: ClassFeature(name: 'Ability Score Improvement', description: '+2 to one ability or +1 to two abilities', level: 19),
    20: ClassFeature(name: 'Divine Intervention Improvement', description: 'Divine intervention automatically succeeds', level: 20),
  },
  subclasses: ['Life Domain', 'Light Domain', 'Knowledge Domain', 'Nature Domain', 'Tempest Domain', 'Trickery Domain', 'War Domain', 'Death Domain', 'Forge Domain', 'Grave Domain', 'Order Domain', 'Peace Domain', 'Twilight Domain'],
);

// ============================================================================
// DRUID
// ============================================================================

final DnDClass _druid = DnDClass(
  name: 'Druid',
  description: 'A priest of nature, wielding divine magic and able to take animal forms. Guardians of the wilderness.',
  hitDie: 8,
  primaryAbilities: ['Wisdom'],
  savingThrowProficiencies: ['Intelligence', 'Wisdom'],
  armorProficiencies: ['Light armor (non-metal)', 'Medium armor (non-metal)', 'Shields (non-metal)'],
  weaponProficiencies: ['Clubs', 'Daggers', 'Darts', 'Javelins', 'Maces', 'Quarterstaffs', 'Scimitars', 'Sickles', 'Slings', 'Spears'],
  toolProficiencies: ['Herbalism kit'],
  skillChoices: ['Arcana', 'Animal Handling', 'Insight', 'Medicine', 'Nature', 'Perception', 'Religion', 'Survival'],
  skillChoiceCount: 2,
  isSpellcaster: true,
  spellcastingAbility: 'Wisdom',
  spellSlotsPerLevel: _fullCasterSpellSlots,
  features: {
    1: ClassFeature(name: 'Druidic, Spellcasting', description: 'Know secret druid language, cast druid spells', level: 1),
    2: ClassFeature(name: 'Wild Shape, Druid Circle', description: 'Transform into beasts, choose druid circle', level: 2),
    4: ClassFeature(name: 'Wild Shape Improvement, Ability Score Improvement', description: 'CR 1/2 beasts, swimming, ASI', level: 4),
    6: ClassFeature(name: 'Druid Circle Feature', description: 'Gain a feature from your circle', level: 6),
    8: ClassFeature(name: 'Wild Shape Improvement, Ability Score Improvement', description: 'CR 1 beasts, flying, ASI', level: 8),
    10: ClassFeature(name: 'Druid Circle Feature', description: 'Gain a feature from your circle', level: 10),
    12: ClassFeature(name: 'Ability Score Improvement', description: '+2 to one ability or +1 to two abilities', level: 12),
    14: ClassFeature(name: 'Druid Circle Feature', description: 'Gain a feature from your circle', level: 14),
    16: ClassFeature(name: 'Ability Score Improvement', description: '+2 to one ability or +1 to two abilities', level: 16),
    18: ClassFeature(name: 'Timeless Body, Beast Spells', description: 'Age 1 year per 10, cast spells while wild shaped', level: 18),
    19: ClassFeature(name: 'Ability Score Improvement', description: '+2 to one ability or +1 to two abilities', level: 19),
    20: ClassFeature(name: 'Archdruid', description: 'Unlimited wild shape, ignore verbal/somatic components', level: 20),
  },
  subclasses: ['Circle of the Land', 'Circle of the Moon', 'Circle of Dreams', 'Circle of the Shepherd', 'Circle of Spores', 'Circle of Stars', 'Circle of Wildfire'],
);

// ============================================================================
// FIGHTER
// ============================================================================

final DnDClass _fighter = DnDClass(
  name: 'Fighter',
  description: 'A master of martial combat, skilled with weapons and armor. The ultimate weapon specialist.',
  hitDie: 10,
  primaryAbilities: ['Strength', 'Dexterity'],
  savingThrowProficiencies: ['Strength', 'Constitution'],
  armorProficiencies: ['All armor', 'Shields'],
  weaponProficiencies: ['Simple weapons', 'Martial weapons'],
  toolProficiencies: [],
  skillChoices: ['Acrobatics', 'Animal Handling', 'Athletics', 'History', 'Insight', 'Intimidation', 'Perception', 'Survival'],
  skillChoiceCount: 2,
  isSpellcaster: false,
  features: {
    1: ClassFeature(name: 'Fighting Style, Second Wind', description: 'Choose combat style, heal as bonus action', level: 1),
    2: ClassFeature(name: 'Action Surge (1 use)', description: 'Take an additional action on your turn', level: 2),
    3: ClassFeature(name: 'Martial Archetype', description: 'Choose Champion, Battle Master, Eldritch Knight, or other archetype', level: 3),
    4: ClassFeature(name: 'Ability Score Improvement', description: '+2 to one ability or +1 to two abilities', level: 4),
    5: ClassFeature(name: 'Extra Attack', description: 'Attack twice whenever you take the Attack action', level: 5),
    6: ClassFeature(name: 'Ability Score Improvement', description: '+2 to one ability or +1 to two abilities', level: 6),
    7: ClassFeature(name: 'Martial Archetype Feature', description: 'Gain a feature from your archetype', level: 7),
    8: ClassFeature(name: 'Ability Score Improvement', description: '+2 to one ability or +1 to two abilities', level: 8),
    9: ClassFeature(name: 'Indomitable (1 use)', description: 'Reroll a failed saving throw', level: 9),
    10: ClassFeature(name: 'Martial Archetype Feature', description: 'Gain a feature from your archetype', level: 10),
    11: ClassFeature(name: 'Extra Attack (2)', description: 'Attack three times with the Attack action', level: 11),
    12: ClassFeature(name: 'Ability Score Improvement', description: '+2 to one ability or +1 to two abilities', level: 12),
    13: ClassFeature(name: 'Indomitable (2 uses)', description: 'Reroll two failed saving throws per rest', level: 13),
    14: ClassFeature(name: 'Ability Score Improvement', description: '+2 to one ability or +1 to two abilities', level: 14),
    15: ClassFeature(name: 'Martial Archetype Feature', description: 'Gain a feature from your archetype', level: 15),
    16: ClassFeature(name: 'Ability Score Improvement', description: '+2 to one ability or +1 to two abilities', level: 16),
    17: ClassFeature(name: 'Action Surge (2 uses), Indomitable (3 uses)', description: 'More action surges and indomitable uses', level: 17),
    18: ClassFeature(name: 'Martial Archetype Feature', description: 'Gain a feature from your archetype', level: 18),
    19: ClassFeature(name: 'Ability Score Improvement', description: '+2 to one ability or +1 to two abilities', level: 19),
    20: ClassFeature(name: 'Extra Attack (3)', description: 'Attack four times with the Attack action', level: 20),
  },
  subclasses: ['Champion', 'Battle Master', 'Eldritch Knight', 'Arcane Archer', 'Cavalier', 'Samurai', 'Echo Knight', 'Psi Warrior', 'Rune Knight'],
);

// ============================================================================
// MONK
// ============================================================================

final DnDClass _monk = DnDClass(
  name: 'Monk',
  description: 'A master of martial arts, channeling the power of the body in pursuit of perfection. Unarmed combat specialist.',
  hitDie: 8,
  primaryAbilities: ['Dexterity', 'Wisdom'],
  savingThrowProficiencies: ['Strength', 'Dexterity'],
  armorProficiencies: [],
  weaponProficiencies: ['Simple weapons', 'Shortswords'],
  toolProficiencies: ['One type of artisan\'s tools or one musical instrument'],
  skillChoices: ['Acrobatics', 'Athletics', 'History', 'Insight', 'Religion', 'Stealth'],
  skillChoiceCount: 2,
  isSpellcaster: false,
  features: {
    1: ClassFeature(name: 'Unarmored Defense, Martial Arts', description: 'AC = 10 + DEX + WIS, unarmed strikes use d4 + DEX', level: 1),
    2: ClassFeature(name: 'Ki, Unarmored Movement', description: 'Gain ki points for special abilities, +10 ft speed', level: 2),
    3: ClassFeature(name: 'Monastic Tradition, Deflect Missiles', description: 'Choose tradition, catch and redirect projectiles', level: 3),
    4: ClassFeature(name: 'Ability Score Improvement, Slow Fall', description: 'ASI, reduce fall damage by 5× monk level', level: 4),
    5: ClassFeature(name: 'Extra Attack, Stunning Strike', description: 'Attack twice, stun enemies with ki', level: 5),
    6: ClassFeature(name: 'Ki-Empowered Strikes, Monastic Tradition Feature', description: 'Unarmed strikes count as magical, gain tradition feature', level: 6),
    7: ClassFeature(name: 'Evasion, Stillness of Mind', description: 'Take no damage on DEX save success, end charm/frighten', level: 7),
    8: ClassFeature(name: 'Ability Score Improvement', description: '+2 to one ability or +1 to two abilities', level: 8),
    9: ClassFeature(name: 'Unarmored Movement Improvement', description: 'Run on walls and water', level: 9),
    10: ClassFeature(name: 'Purity of Body', description: 'Immune to disease and poison', level: 10),
    11: ClassFeature(name: 'Monastic Tradition Feature', description: 'Gain a feature from your tradition', level: 11),
    12: ClassFeature(name: 'Ability Score Improvement', description: '+2 to one ability or +1 to two abilities', level: 12),
    13: ClassFeature(name: 'Tongue of the Sun and Moon', description: 'Understand all spoken languages', level: 13),
    14: ClassFeature(name: 'Diamond Soul', description: 'Proficient in all saving throws, reroll with ki', level: 14),
    15: ClassFeature(name: 'Timeless Body', description: 'No aging penalties', level: 15),
    16: ClassFeature(name: 'Ability Score Improvement', description: '+2 to one ability or +1 to two abilities', level: 16),
    17: ClassFeature(name: 'Monastic Tradition Feature', description: 'Gain a feature from your tradition', level: 17),
    18: ClassFeature(name: 'Empty Body', description: 'Become invisible and resistant to damage', level: 18),
    19: ClassFeature(name: 'Ability Score Improvement', description: '+2 to one ability or +1 to two abilities', level: 19),
    20: ClassFeature(name: 'Perfect Self', description: 'Regain 4 ki at start of turn if none remain', level: 20),
  },
  subclasses: ['Way of the Open Hand', 'Way of Shadow', 'Way of the Four Elements', 'Way of the Long Death', 'Way of the Sun Soul', 'Way of the Drunken Master', 'Way of the Kensei', 'Way of Mercy', 'Way of the Astral Self'],
);

// ============================================================================
// PALADIN
// ============================================================================

final DnDClass _paladin = DnDClass(
  name: 'Paladin',
  description: 'A holy warrior bound to a sacred oath. Divine magic and martial prowess combined.',
  hitDie: 10,
  primaryAbilities: ['Strength', 'Charisma'],
  savingThrowProficiencies: ['Wisdom', 'Charisma'],
  armorProficiencies: ['All armor', 'Shields'],
  weaponProficiencies: ['Simple weapons', 'Martial weapons'],
  toolProficiencies: [],
  skillChoices: ['Athletics', 'Insight', 'Intimidation', 'Medicine', 'Persuasion', 'Religion'],
  skillChoiceCount: 2,
  isSpellcaster: true,
  spellcastingAbility: 'Charisma',
  spellSlotsPerLevel: _halfCasterSpellSlots,
  features: {
    1: ClassFeature(name: 'Divine Sense, Lay on Hands', description: 'Detect celestials/fiends/undead, heal with touch', level: 1),
    2: ClassFeature(name: 'Fighting Style, Spellcasting, Divine Smite', description: 'Choose style, cast spells, expend spell slots for radiant damage', level: 2),
    3: ClassFeature(name: 'Divine Health, Sacred Oath', description: 'Immune to disease, choose oath', level: 3),
    4: ClassFeature(name: 'Ability Score Improvement', description: '+2 to one ability or +1 to two abilities', level: 4),
    5: ClassFeature(name: 'Extra Attack', description: 'Attack twice with the Attack action', level: 5),
    6: ClassFeature(name: 'Aura of Protection', description: 'You and allies within 10 ft add CHA to saves', level: 6),
    7: ClassFeature(name: 'Sacred Oath Feature', description: 'Gain a feature from your oath', level: 7),
    8: ClassFeature(name: 'Ability Score Improvement', description: '+2 to one ability or +1 to two abilities', level: 8),
    10: ClassFeature(name: 'Aura of Courage', description: 'You and allies within 10 ft can\'t be frightened', level: 10),
    11: ClassFeature(name: 'Improved Divine Smite', description: 'All melee attacks deal +1d8 radiant damage', level: 11),
    12: ClassFeature(name: 'Ability Score Improvement', description: '+2 to one ability or +1 to two abilities', level: 12),
    14: ClassFeature(name: 'Cleansing Touch', description: 'End spells on yourself or others with touch', level: 14),
    15: ClassFeature(name: 'Sacred Oath Feature', description: 'Gain a feature from your oath', level: 15),
    16: ClassFeature(name: 'Ability Score Improvement', description: '+2 to one ability or +1 to two abilities', level: 16),
    18: ClassFeature(name: 'Aura Improvements', description: 'Auras extend to 30 ft', level: 18),
    19: ClassFeature(name: 'Ability Score Improvement', description: '+2 to one ability or +1 to two abilities', level: 19),
    20: ClassFeature(name: 'Sacred Oath Feature', description: 'Gain capstone feature from your oath', level: 20),
  },
  subclasses: ['Oath of Devotion', 'Oath of the Ancients', 'Oath of Vengeance', 'Oath of Conquest', 'Oath of Redemption', 'Oath of Glory', 'Oath of the Watchers', 'Oathbreaker'],
);

// ============================================================================
// RANGER
// ============================================================================

final DnDClass _ranger = DnDClass(
  name: 'Ranger',
  description: 'A warrior who combats threats on the edge of civilization. Master tracker and wilderness expert.',
  hitDie: 10,
  primaryAbilities: ['Dexterity', 'Wisdom'],
  savingThrowProficiencies: ['Strength', 'Dexterity'],
  armorProficiencies: ['Light armor', 'Medium armor', 'Shields'],
  weaponProficiencies: ['Simple weapons', 'Martial weapons'],
  toolProficiencies: [],
  skillChoices: ['Animal Handling', 'Athletics', 'Insight', 'Investigation', 'Nature', 'Perception', 'Stealth', 'Survival'],
  skillChoiceCount: 3,
  isSpellcaster: true,
  spellcastingAbility: 'Wisdom',
  spellSlotsPerLevel: _halfCasterSpellSlots,
  features: {
    1: ClassFeature(name: 'Favored Enemy, Natural Explorer', description: 'Bonus vs certain creatures, expertise in certain terrains', level: 1),
    2: ClassFeature(name: 'Fighting Style, Spellcasting', description: 'Choose combat style, cast ranger spells', level: 2),
    3: ClassFeature(name: 'Ranger Archetype, Primeval Awareness', description: 'Choose archetype, detect creature types', level: 3),
    4: ClassFeature(name: 'Ability Score Improvement', description: '+2 to one ability or +1 to two abilities', level: 4),
    5: ClassFeature(name: 'Extra Attack', description: 'Attack twice with the Attack action', level: 5),
    6: ClassFeature(name: 'Favored Enemy and Natural Explorer Improvements', description: 'Additional favored enemy and terrain', level: 6),
    7: ClassFeature(name: 'Ranger Archetype Feature', description: 'Gain a feature from your archetype', level: 7),
    8: ClassFeature(name: 'Ability Score Improvement, Land\'s Stride', description: 'ASI, move through difficult terrain and plants', level: 8),
    10: ClassFeature(name: 'Natural Explorer Improvement, Hide in Plain Sight', description: 'Additional terrain, camouflage yourself', level: 10),
    11: ClassFeature(name: 'Ranger Archetype Feature', description: 'Gain a feature from your archetype', level: 11),
    12: ClassFeature(name: 'Ability Score Improvement', description: '+2 to one ability or +1 to two abilities', level: 12),
    14: ClassFeature(name: 'Favored Enemy Improvement, Vanish', description: 'Additional favored enemy, can\'t be tracked and can hide as bonus action', level: 14),
    15: ClassFeature(name: 'Ranger Archetype Feature', description: 'Gain a feature from your archetype', level: 15),
    16: ClassFeature(name: 'Ability Score Improvement', description: '+2 to one ability or +1 to two abilities', level: 16),
    18: ClassFeature(name: 'Feral Senses', description: 'Fight invisible creatures normally', level: 18),
    19: ClassFeature(name: 'Ability Score Improvement', description: '+2 to one ability or +1 to two abilities', level: 19),
    20: ClassFeature(name: 'Foe Slayer', description: 'Add WIS to attack or damage vs favored enemy once per turn', level: 20),
  },
  subclasses: ['Hunter', 'Beast Master', 'Gloom Stalker', 'Horizon Walker', 'Monster Slayer', 'Fey Wanderer', 'Swarmkeeper', 'Drakewarden'],
);

// ============================================================================
// ROGUE
// ============================================================================

final DnDClass _rogue = DnDClass(
  name: 'Rogue',
  description: 'A scoundrel who uses stealth and trickery to overcome obstacles. Master of skills and precision.',
  hitDie: 8,
  primaryAbilities: ['Dexterity'],
  savingThrowProficiencies: ['Dexterity', 'Intelligence'],
  armorProficiencies: ['Light armor'],
  weaponProficiencies: ['Simple weapons', 'Hand crossbows', 'Longswords', 'Rapiers', 'Shortswords'],
  toolProficiencies: ['Thieves\' tools'],
  skillChoices: ['Acrobatics', 'Athletics', 'Deception', 'Insight', 'Intimidation', 'Investigation', 'Perception', 'Performance', 'Persuasion', 'Sleight of Hand', 'Stealth'],
  skillChoiceCount: 4,
  isSpellcaster: false,
  features: {
    1: ClassFeature(name: 'Expertise, Sneak Attack (1d6), Thieves\' Cant', description: 'Double proficiency on two skills, bonus damage, secret language', level: 1),
    2: ClassFeature(name: 'Cunning Action', description: 'Dash, Disengage, or Hide as bonus action', level: 2),
    3: ClassFeature(name: 'Roguish Archetype, Sneak Attack (2d6)', description: 'Choose archetype, better sneak attack', level: 3),
    4: ClassFeature(name: 'Ability Score Improvement', description: '+2 to one ability or +1 to two abilities', level: 4),
    5: ClassFeature(name: 'Uncanny Dodge, Sneak Attack (3d6)', description: 'Halve damage from an attack, better sneak attack', level: 5),
    6: ClassFeature(name: 'Expertise', description: 'Double proficiency on two more skills', level: 6),
    7: ClassFeature(name: 'Evasion, Sneak Attack (4d6)', description: 'Take no damage on DEX save success, better sneak attack', level: 7),
    8: ClassFeature(name: 'Ability Score Improvement', description: '+2 to one ability or +1 to two abilities', level: 8),
    9: ClassFeature(name: 'Roguish Archetype Feature, Sneak Attack (5d6)', description: 'Gain archetype feature, better sneak attack', level: 9),
    10: ClassFeature(name: 'Ability Score Improvement', description: '+2 to one ability or +1 to two abilities', level: 10),
    11: ClassFeature(name: 'Reliable Talent, Sneak Attack (6d6)', description: 'Minimum 10 on skill checks with proficiency, better sneak attack', level: 11),
    12: ClassFeature(name: 'Ability Score Improvement', description: '+2 to one ability or +1 to two abilities', level: 12),
    13: ClassFeature(name: 'Roguish Archetype Feature, Sneak Attack (7d6)', description: 'Gain archetype feature, better sneak attack', level: 13),
    14: ClassFeature(name: 'Blindsense', description: 'Sense invisible and hidden creatures within 10 ft', level: 14),
    15: ClassFeature(name: 'Slippery Mind, Sneak Attack (8d6)', description: 'Proficient in WIS saves, better sneak attack', level: 15),
    16: ClassFeature(name: 'Ability Score Improvement', description: '+2 to one ability or +1 to two abilities', level: 16),
    17: ClassFeature(name: 'Roguish Archetype Feature, Sneak Attack (9d6)', description: 'Gain archetype feature, better sneak attack', level: 17),
    18: ClassFeature(name: 'Elusive', description: 'Attackers can\'t have advantage against you', level: 18),
    19: ClassFeature(name: 'Ability Score Improvement, Sneak Attack (10d6)', description: 'ASI, better sneak attack', level: 19),
    20: ClassFeature(name: 'Stroke of Luck', description: 'Turn a miss into a hit or fail into success', level: 20),
  },
  subclasses: ['Thief', 'Assassin', 'Arcane Trickster', 'Inquisitive', 'Mastermind', 'Scout', 'Swashbuckler', 'Phantom', 'Soulknife'],
);

// ============================================================================
// SORCERER
// ============================================================================

final DnDClass _sorcerer = DnDClass(
  name: 'Sorcerer',
  description: 'A spellcaster who draws on inherent magic from a gift or bloodline. Raw magical power.',
  hitDie: 6,
  primaryAbilities: ['Charisma'],
  savingThrowProficiencies: ['Constitution', 'Charisma'],
  armorProficiencies: [],
  weaponProficiencies: ['Daggers', 'Darts', 'Slings', 'Quarterstaffs', 'Light crossbows'],
  toolProficiencies: [],
  skillChoices: ['Arcana', 'Deception', 'Insight', 'Intimidation', 'Persuasion', 'Religion'],
  skillChoiceCount: 2,
  isSpellcaster: true,
  spellcastingAbility: 'Charisma',
  spellSlotsPerLevel: _fullCasterSpellSlots,
  features: {
    1: ClassFeature(name: 'Spellcasting, Sorcerous Origin', description: 'Cast sorcerer spells, choose magical origin', level: 1),
    2: ClassFeature(name: 'Font of Magic', description: 'Gain sorcery points to fuel metamagic', level: 2),
    3: ClassFeature(name: 'Metamagic', description: 'Modify spells with sorcery points (2 options)', level: 3),
    4: ClassFeature(name: 'Ability Score Improvement', description: '+2 to one ability or +1 to two abilities', level: 4),
    6: ClassFeature(name: 'Sorcerous Origin Feature', description: 'Gain a feature from your origin', level: 6),
    8: ClassFeature(name: 'Ability Score Improvement', description: '+2 to one ability or +1 to two abilities', level: 8),
    10: ClassFeature(name: 'Metamagic', description: 'Learn a third metamagic option', level: 10),
    12: ClassFeature(name: 'Ability Score Improvement', description: '+2 to one ability or +1 to two abilities', level: 12),
    14: ClassFeature(name: 'Sorcerous Origin Feature', description: 'Gain a feature from your origin', level: 14),
    16: ClassFeature(name: 'Ability Score Improvement', description: '+2 to one ability or +1 to two abilities', level: 16),
    17: ClassFeature(name: 'Metamagic', description: 'Learn a fourth metamagic option', level: 17),
    18: ClassFeature(name: 'Sorcerous Origin Feature', description: 'Gain a feature from your origin', level: 18),
    19: ClassFeature(name: 'Ability Score Improvement', description: '+2 to one ability or +1 to two abilities', level: 19),
    20: ClassFeature(name: 'Sorcerous Restoration', description: 'Regain 4 sorcery points on short rest', level: 20),
  },
  subclasses: ['Draconic Bloodline', 'Wild Magic', 'Storm Sorcery', 'Divine Soul', 'Shadow Magic', 'Aberrant Mind', 'Clockwork Soul'],
);

// ============================================================================
// WARLOCK
// ============================================================================

final DnDClass _warlock = DnDClass(
  name: 'Warlock',
  description: 'A wielder of magic derived from a bargain with an otherworldly entity. Pact-bound spellcaster.',
  hitDie: 8,
  primaryAbilities: ['Charisma'],
  savingThrowProficiencies: ['Wisdom', 'Charisma'],
  armorProficiencies: ['Light armor'],
  weaponProficiencies: ['Simple weapons'],
  toolProficiencies: [],
  skillChoices: ['Arcana', 'Deception', 'History', 'Intimidation', 'Investigation', 'Nature', 'Religion'],
  skillChoiceCount: 2,
  isSpellcaster: true,
  spellcastingAbility: 'Charisma',
  spellSlotsPerLevel: _warlockSpellSlots,
  features: {
    1: ClassFeature(name: 'Otherworldly Patron, Pact Magic', description: 'Choose patron, cast warlock spells with unique slot system', level: 1),
    2: ClassFeature(name: 'Eldritch Invocations', description: 'Learn 2 invocations for special abilities', level: 2),
    3: ClassFeature(name: 'Pact Boon', description: 'Choose Pact of the Chain, Blade, or Tome', level: 3),
    4: ClassFeature(name: 'Ability Score Improvement', description: '+2 to one ability or +1 to two abilities', level: 4),
    5: ClassFeature(name: 'Eldritch Invocations', description: 'Know 3 invocations total', level: 5),
    6: ClassFeature(name: 'Otherworldly Patron Feature', description: 'Gain a feature from your patron', level: 6),
    7: ClassFeature(name: 'Eldritch Invocations', description: 'Know 4 invocations total', level: 7),
    8: ClassFeature(name: 'Ability Score Improvement', description: '+2 to one ability or +1 to two abilities', level: 8),
    9: ClassFeature(name: 'Eldritch Invocations', description: 'Know 5 invocations total', level: 9),
    10: ClassFeature(name: 'Otherworldly Patron Feature', description: 'Gain a feature from your patron', level: 10),
    11: ClassFeature(name: 'Mystic Arcanum (6th level)', description: 'Learn one 6th-level spell', level: 11),
    12: ClassFeature(name: 'Ability Score Improvement, Eldritch Invocations', description: 'ASI, know 6 invocations total', level: 12),
    13: ClassFeature(name: 'Mystic Arcanum (7th level)', description: 'Learn one 7th-level spell', level: 13),
    14: ClassFeature(name: 'Otherworldly Patron Feature', description: 'Gain a feature from your patron', level: 14),
    15: ClassFeature(name: 'Mystic Arcanum (8th level), Eldritch Invocations', description: 'Learn one 8th-level spell, know 7 invocations total', level: 15),
    16: ClassFeature(name: 'Ability Score Improvement', description: '+2 to one ability or +1 to two abilities', level: 16),
    17: ClassFeature(name: 'Mystic Arcanum (9th level)', description: 'Learn one 9th-level spell', level: 17),
    18: ClassFeature(name: 'Eldritch Invocations', description: 'Know 8 invocations total', level: 18),
    19: ClassFeature(name: 'Ability Score Improvement', description: '+2 to one ability or +1 to two abilities', level: 19),
    20: ClassFeature(name: 'Eldritch Master', description: 'Regain all spell slots on short rest once per day', level: 20),
  },
  subclasses: ['The Archfey', 'The Fiend', 'The Great Old One', 'The Celestial', 'The Hexblade', 'The Fathomless', 'The Genie', 'The Undead'],
);

// ============================================================================
// WIZARD
// ============================================================================

final DnDClass _wizard = DnDClass(
  name: 'Wizard',
  description: 'A scholarly magic-user capable of manipulating reality. The ultimate spellbook scholar.',
  hitDie: 6,
  primaryAbilities: ['Intelligence'],
  savingThrowProficiencies: ['Intelligence', 'Wisdom'],
  armorProficiencies: [],
  weaponProficiencies: ['Daggers', 'Darts', 'Slings', 'Quarterstaffs', 'Light crossbows'],
  toolProficiencies: [],
  skillChoices: ['Arcana', 'History', 'Insight', 'Investigation', 'Medicine', 'Religion'],
  skillChoiceCount: 2,
  isSpellcaster: true,
  spellcastingAbility: 'Intelligence',
  spellSlotsPerLevel: _fullCasterSpellSlots,
  features: {
    1: ClassFeature(name: 'Spellcasting, Arcane Recovery', description: 'Cast wizard spells from spellbook, recover spell slots on short rest', level: 1),
    2: ClassFeature(name: 'Arcane Tradition', description: 'Choose school of magic specialization', level: 2),
    4: ClassFeature(name: 'Ability Score Improvement', description: '+2 to one ability or +1 to two abilities', level: 4),
    6: ClassFeature(name: 'Arcane Tradition Feature', description: 'Gain a feature from your school', level: 6),
    8: ClassFeature(name: 'Ability Score Improvement', description: '+2 to one ability or +1 to two abilities', level: 8),
    10: ClassFeature(name: 'Arcane Tradition Feature', description: 'Gain a feature from your school', level: 10),
    12: ClassFeature(name: 'Ability Score Improvement', description: '+2 to one ability or +1 to two abilities', level: 12),
    14: ClassFeature(name: 'Arcane Tradition Feature', description: 'Gain a feature from your school', level: 14),
    16: ClassFeature(name: 'Ability Score Improvement', description: '+2 to one ability or +1 to two abilities', level: 16),
    18: ClassFeature(name: 'Spell Mastery', description: 'Cast one 1st and one 2nd level spell at will', level: 18),
    19: ClassFeature(name: 'Ability Score Improvement', description: '+2 to one ability or +1 to two abilities', level: 19),
    20: ClassFeature(name: 'Signature Spells', description: 'Cast two 3rd-level spells once per short rest without slots', level: 20),
  },
  subclasses: ['School of Abjuration', 'School of Conjuration', 'School of Divination', 'School of Enchantment', 'School of Evocation', 'School of Illusion', 'School of Necromancy', 'School of Transmutation', 'Bladesinging', 'War Magic', 'Order of Scribes'],
);

// ============================================================================
// SPELL SLOT TABLES
// ============================================================================

final Map<int, SpellSlots> _fullCasterSpellSlots = {
  1: SpellSlots(level1: 2),
  2: SpellSlots(level1: 3),
  3: SpellSlots(level1: 4, level2: 2),
  4: SpellSlots(level1: 4, level2: 3),
  5: SpellSlots(level1: 4, level2: 3, level3: 2),
  6: SpellSlots(level1: 4, level2: 3, level3: 3),
  7: SpellSlots(level1: 4, level2: 3, level3: 3, level4: 1),
  8: SpellSlots(level1: 4, level2: 3, level3: 3, level4: 2),
  9: SpellSlots(level1: 4, level2: 3, level3: 3, level4: 3, level5: 1),
  10: SpellSlots(level1: 4, level2: 3, level3: 3, level4: 3, level5: 2),
  11: SpellSlots(level1: 4, level2: 3, level3: 3, level4: 3, level5: 2, level6: 1),
  12: SpellSlots(level1: 4, level2: 3, level3: 3, level4: 3, level5: 2, level6: 1),
  13: SpellSlots(level1: 4, level2: 3, level3: 3, level4: 3, level5: 2, level6: 1, level7: 1),
  14: SpellSlots(level1: 4, level2: 3, level3: 3, level4: 3, level5: 2, level6: 1, level7: 1),
  15: SpellSlots(level1: 4, level2: 3, level3: 3, level4: 3, level5: 2, level6: 1, level7: 1, level8: 1),
  16: SpellSlots(level1: 4, level2: 3, level3: 3, level4: 3, level5: 2, level6: 1, level7: 1, level8: 1),
  17: SpellSlots(level1: 4, level2: 3, level3: 3, level4: 3, level5: 2, level6: 1, level7: 1, level8: 1, level9: 1),
  18: SpellSlots(level1: 4, level2: 3, level3: 3, level4: 3, level5: 3, level6: 1, level7: 1, level8: 1, level9: 1),
  19: SpellSlots(level1: 4, level2: 3, level3: 3, level4: 3, level5: 3, level6: 2, level7: 1, level8: 1, level9: 1),
  20: SpellSlots(level1: 4, level2: 3, level3: 3, level4: 3, level5: 3, level6: 2, level7: 2, level8: 1, level9: 1),
};

final Map<int, SpellSlots> _halfCasterSpellSlots = {
  1: SpellSlots(),
  2: SpellSlots(level1: 2),
  3: SpellSlots(level1: 3),
  4: SpellSlots(level1: 3),
  5: SpellSlots(level1: 4, level2: 2),
  6: SpellSlots(level1: 4, level2: 2),
  7: SpellSlots(level1: 4, level2: 3),
  8: SpellSlots(level1: 4, level2: 3),
  9: SpellSlots(level1: 4, level2: 3, level3: 2),
  10: SpellSlots(level1: 4, level2: 3, level3: 2),
  11: SpellSlots(level1: 4, level2: 3, level3: 3),
  12: SpellSlots(level1: 4, level2: 3, level3: 3),
  13: SpellSlots(level1: 4, level2: 3, level3: 3, level4: 1),
  14: SpellSlots(level1: 4, level2: 3, level3: 3, level4: 1),
  15: SpellSlots(level1: 4, level2: 3, level3: 3, level4: 2),
  16: SpellSlots(level1: 4, level2: 3, level3: 3, level4: 2),
  17: SpellSlots(level1: 4, level2: 3, level3: 3, level4: 3, level5: 1),
  18: SpellSlots(level1: 4, level2: 3, level3: 3, level4: 3, level5: 1),
  19: SpellSlots(level1: 4, level2: 3, level3: 3, level4: 3, level5: 2),
  20: SpellSlots(level1: 4, level2: 3, level3: 3, level4: 3, level5: 2),
};

final Map<int, SpellSlots> _warlockSpellSlots = {
  1: SpellSlots(level1: 1),
  2: SpellSlots(level1: 2),
  3: SpellSlots(level2: 2),
  4: SpellSlots(level2: 2),
  5: SpellSlots(level3: 2),
  6: SpellSlots(level3: 2),
  7: SpellSlots(level4: 2),
  8: SpellSlots(level4: 2),
  9: SpellSlots(level5: 2),
  10: SpellSlots(level5: 2),
  11: SpellSlots(level5: 3),
  12: SpellSlots(level5: 3),
  13: SpellSlots(level5: 3),
  14: SpellSlots(level5: 3),
  15: SpellSlots(level5: 3),
  16: SpellSlots(level5: 3),
  17: SpellSlots(level5: 4),
  18: SpellSlots(level5: 4),
  19: SpellSlots(level5: 4),
  20: SpellSlots(level5: 4),
};
