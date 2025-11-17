// Comprehensive D&D 5e Race and Subrace Database
// Includes all official playable races with variants

class DnDRace {
  final String name;
  final String description;
  final Map<String, int> abilityScoreIncreases;
  final int age;
  final String alignment;
  final String size;
  final int speed;
  final List<String> languages;
  final List<RacialTrait> traits;
  final List<String> subraces;

  DnDRace({
    required this.name,
    required this.description,
    required this.abilityScoreIncreases,
    required this.age,
    required this.alignment,
    required this.size,
    required this.speed,
    required this.languages,
    required this.traits,
    this.subraces = const [],
  });
}

class RacialTrait {
  final String name;
  final String description;

  RacialTrait({required this.name, required this.description});
}

// ============================================================================
// ALL D&D 5E RACES
// ============================================================================

final Map<String, DnDRace> allDnDRaces = {
  'Human': _human,
  'Elf': _elf,
  'High Elf': _highElf,
  'Wood Elf': _woodElf,
  'Dark Elf (Drow)': _drow,
  'Dwarf': _dwarf,
  'Mountain Dwarf': _mountainDwarf,
  'Hill Dwarf': _hillDwarf,
  'Halfling': _halfling,
  'Lightfoot Halfling': _lightfootHalfling,
  'Stout Halfling': _stoutHalfling,
  'Dragonborn': _dragonborn,
  'Gnome': _gnome,
  'Forest Gnome': _forestGnome,
  'Rock Gnome': _rockGnome,
  'Deep Gnome': _deepGnome,
  'Half-Elf': _halfElf,
  'Half-Orc': _halfOrc,
  'Tiefling': _tiefling,
  'Aasimar': _aasimar,
  'Protector Aasimar': _protectorAasimar,
  'Scourge Aasimar': _scourgeAasimar,
  'Fallen Aasimar': _fallenAasimar,
  'Firbolg': _firbolg,
  'Goliath': _goliath,
  'Kenku': _kenku,
  'Lizardfolk': _lizardfolk,
  'Tabaxi': _tabaxi,
  'Triton': _triton,
  'Bugbear': _bugbear,
  'Goblin': _goblin,
  'Hobgoblin': _hobgoblin,
  'Kobold': _kobold,
  'Orc': _orc,
  'Yuan-ti Pureblood': _yuantiPureblood,
  'Genasi': _genasi,
  'Air Genasi': _airGenasi,
  'Earth Genasi': _earthGenasi,
  'Fire Genasi': _fireGenasi,
  'Water Genasi': _waterGenasi,
  'Aarakocra': _aarakocra,
  'Tortle': _tortle,
  'Changeling': _changeling,
  'Kalashtar': _kalashtar,
  'Shifter': _shifter,
  'Warforged': _warforged,
  'Centaur': _centaur,
  'Loxodon': _loxodon,
  'Minotaur': _minotaur,
  'Satyr': _satyr,
  'Leonin': _leonin,
  'Fairy': _fairy,
  'Harengon': _harengon,
  'Owlin': _owlin,
};

// ============================================================================
// HUMAN
// ============================================================================

final DnDRace _human = DnDRace(
  name: 'Human',
  description: 'Humans are the most adaptable and ambitious people. They have widely varying tastes, morals, and customs.',
  abilityScoreIncreases: {'Strength': 1, 'Dexterity': 1, 'Constitution': 1, 'Intelligence': 1, 'Wisdom': 1, 'Charisma': 1},
  age: 80,
  alignment: 'Any',
  size: 'Medium',
  speed: 30,
  languages: ['Common', 'One extra language of your choice'],
  traits: [
    RacialTrait(name: 'Ability Score Increase', description: '+1 to all ability scores'),
    RacialTrait(name: 'Extra Language', description: 'You can speak one additional language'),
  ],
);

// ============================================================================
// ELVES
// ============================================================================

final DnDRace _elf = DnDRace(
  name: 'Elf',
  description: 'Elves are magical people of otherworldly grace, living in places of ethereal beauty.',
  abilityScoreIncreases: {'Dexterity': 2},
  age: 750,
  alignment: 'Chaotic Good',
  size: 'Medium',
  speed: 30,
  languages: ['Common', 'Elvish'],
  traits: [
    RacialTrait(name: 'Darkvision', description: 'See in dim light within 60 feet as if bright light'),
    RacialTrait(name: 'Keen Senses', description: 'Proficiency in Perception'),
    RacialTrait(name: 'Fey Ancestry', description: 'Advantage on saves vs charm, can\'t be magically put to sleep'),
    RacialTrait(name: 'Trance', description: 'Meditate 4 hours instead of sleeping 8'),
  ],
  subraces: ['High Elf', 'Wood Elf', 'Dark Elf (Drow)'],
);

final DnDRace _highElf = DnDRace(
  name: 'High Elf',
  description: 'High elves have a keen mind and mastery of basic magic.',
  abilityScoreIncreases: {'Dexterity': 2, 'Intelligence': 1},
  age: 750,
  alignment: 'Lawful Good',
  size: 'Medium',
  speed: 30,
  languages: ['Common', 'Elvish', 'One extra'],
  traits: [
    RacialTrait(name: 'Darkvision', description: 'See in dim light within 60 feet'),
    RacialTrait(name: 'Keen Senses', description: 'Proficiency in Perception'),
    RacialTrait(name: 'Fey Ancestry', description: 'Advantage on saves vs charm'),
    RacialTrait(name: 'Trance', description: 'Meditate 4 hours instead of sleeping'),
    RacialTrait(name: 'Elf Weapon Training', description: 'Proficiency with longsword, shortsword, longbow, shortbow'),
    RacialTrait(name: 'Cantrip', description: 'Know one wizard cantrip'),
  ],
);

final DnDRace _woodElf = DnDRace(
  name: 'Wood Elf',
  description: 'Wood elves have keen senses and deep intuition, and their fleet feet carry them swiftly through their forest homes.',
  abilityScoreIncreases: {'Dexterity': 2, 'Wisdom': 1},
  age: 750,
  alignment: 'Neutral Good',
  size: 'Medium',
  speed: 35,
  languages: ['Common', 'Elvish'],
  traits: [
    RacialTrait(name: 'Darkvision', description: 'See in dim light within 60 feet'),
    RacialTrait(name: 'Keen Senses', description: 'Proficiency in Perception'),
    RacialTrait(name: 'Fey Ancestry', description: 'Advantage on saves vs charm'),
    RacialTrait(name: 'Trance', description: 'Meditate 4 hours instead of sleeping'),
    RacialTrait(name: 'Elf Weapon Training', description: 'Proficiency with longsword, shortsword, longbow, shortbow'),
    RacialTrait(name: 'Fleet of Foot', description: 'Base walking speed is 35 feet'),
    RacialTrait(name: 'Mask of the Wild', description: 'Can hide when lightly obscured by foliage, rain, snow, etc.'),
  ],
);

final DnDRace _drow = DnDRace(
  name: 'Dark Elf (Drow)',
  description: 'Drow are a subrace of elves who dwell in the Underdark, often worshipping evil deities.',
  abilityScoreIncreases: {'Dexterity': 2, 'Charisma': 1},
  age: 750,
  alignment: 'Neutral Evil',
  size: 'Medium',
  speed: 30,
  languages: ['Common', 'Elvish'],
  traits: [
    RacialTrait(name: 'Superior Darkvision', description: 'See in dim light within 120 feet'),
    RacialTrait(name: 'Keen Senses', description: 'Proficiency in Perception'),
    RacialTrait(name: 'Fey Ancestry', description: 'Advantage on saves vs charm'),
    RacialTrait(name: 'Trance', description: 'Meditate 4 hours instead of sleeping'),
    RacialTrait(name: 'Sunlight Sensitivity', description: 'Disadvantage on attack rolls and Perception checks in sunlight'),
    RacialTrait(name: 'Drow Magic', description: 'Dancing Lights cantrip; Faerie Fire and Darkness at higher levels'),
    RacialTrait(name: 'Drow Weapon Training', description: 'Proficiency with rapiers, shortswords, hand crossbows'),
  ],
);

// ============================================================================
// DWARVES
// ============================================================================

final DnDRace _dwarf = DnDRace(
  name: 'Dwarf',
  description: 'Bold and hardy, dwarves are known as skilled warriors, miners, and workers of stone and metal.',
  abilityScoreIncreases: {'Constitution': 2},
  age: 350,
  alignment: 'Lawful Good',
  size: 'Medium',
  speed: 25,
  languages: ['Common', 'Dwarvish'],
  traits: [
    RacialTrait(name: 'Darkvision', description: 'See in dim light within 60 feet'),
    RacialTrait(name: 'Dwarven Resilience', description: 'Advantage on saves vs poison, resistance to poison damage'),
    RacialTrait(name: 'Dwarven Combat Training', description: 'Proficiency with battleaxe, handaxe, light hammer, warhammer'),
    RacialTrait(name: 'Tool Proficiency', description: 'Proficiency with artisan\'s tools'),
    RacialTrait(name: 'Stonecunning', description: 'Add double proficiency bonus to Intelligence (History) checks about stonework'),
  ],
  subraces: ['Mountain Dwarf', 'Hill Dwarf'],
);

final DnDRace _mountainDwarf = DnDRace(
  name: 'Mountain Dwarf',
  description: 'Mountain dwarves are strong and hardy, accustomed to difficult life in rugged terrain.',
  abilityScoreIncreases: {'Strength': 2, 'Constitution': 2},
  age: 350,
  alignment: 'Lawful Good',
  size: 'Medium',
  speed: 25,
  languages: ['Common', 'Dwarvish'],
  traits: [
    RacialTrait(name: 'Darkvision', description: 'See in dim light within 60 feet'),
    RacialTrait(name: 'Dwarven Resilience', description: 'Advantage on saves vs poison'),
    RacialTrait(name: 'Dwarven Combat Training', description: 'Proficiency with battleaxe, handaxe, light hammer, warhammer'),
    RacialTrait(name: 'Tool Proficiency', description: 'Proficiency with artisan\'s tools'),
    RacialTrait(name: 'Stonecunning', description: 'Expertise in stonework history checks'),
    RacialTrait(name: 'Dwarven Armor Training', description: 'Proficiency with light and medium armor'),
  ],
);

final DnDRace _hillDwarf = DnDRace(
  name: 'Hill Dwarf',
  description: 'Hill dwarves have keen senses, deep intuition, and remarkable resilience.',
  abilityScoreIncreases: {'Wisdom': 1, 'Constitution': 2},
  age: 350,
  alignment: 'Lawful Good',
  size: 'Medium',
  speed: 25,
  languages: ['Common', 'Dwarvish'],
  traits: [
    RacialTrait(name: 'Darkvision', description: 'See in dim light within 60 feet'),
    RacialTrait(name: 'Dwarven Resilience', description: 'Advantage on saves vs poison'),
    RacialTrait(name: 'Dwarven Combat Training', description: 'Proficiency with battleaxe, handaxe, light hammer, warhammer'),
    RacialTrait(name: 'Tool Proficiency', description: 'Proficiency with artisan\'s tools'),
    RacialTrait(name: 'Stonecunning', description: 'Expertise in stonework history checks'),
    RacialTrait(name: 'Dwarven Toughness', description: 'Hit point maximum increases by 1 per level'),
  ],
);

// ============================================================================
// HALFLINGS
// ============================================================================

final DnDRace _halfling = DnDRace(
  name: 'Halfling',
  description: 'Halflings are an affable and cheerful people. They cherish family, friends, and the comforts of home.',
  abilityScoreIncreases: {'Dexterity': 2},
  age: 150,
  alignment: 'Lawful Good',
  size: 'Small',
  speed: 25,
  languages: ['Common', 'Halfling'],
  traits: [
    RacialTrait(name: 'Lucky', description: 'Reroll 1s on attack rolls, ability checks, and saving throws'),
    RacialTrait(name: 'Brave', description: 'Advantage on saves vs being frightened'),
    RacialTrait(name: 'Halfling Nimbleness', description: 'Can move through space of creatures larger than you'),
  ],
  subraces: ['Lightfoot Halfling', 'Stout Halfling'],
);

final DnDRace _lightfootHalfling = DnDRace(
  name: 'Lightfoot Halfling',
  description: 'Lightfoot halflings can easily hide, and they are inclined to get along with others.',
  abilityScoreIncreases: {'Dexterity': 2, 'Charisma': 1},
  age: 150,
  alignment: 'Lawful Good',
  size: 'Small',
  speed: 25,
  languages: ['Common', 'Halfling'],
  traits: [
    RacialTrait(name: 'Lucky', description: 'Reroll 1s on d20 rolls'),
    RacialTrait(name: 'Brave', description: 'Advantage on saves vs frightened'),
    RacialTrait(name: 'Halfling Nimbleness', description: 'Move through larger creature spaces'),
    RacialTrait(name: 'Naturally Stealthy', description: 'Can hide when obscured by a creature one size larger'),
  ],
);

final DnDRace _stoutHalfling = DnDRace(
  name: 'Stout Halfling',
  description: 'Stout halflings are hardier than average and have some resistance to poison.',
  abilityScoreIncreases: {'Dexterity': 2, 'Constitution': 1},
  age: 150,
  alignment: 'Lawful Good',
  size: 'Small',
  speed: 25,
  languages: ['Common', 'Halfling'],
  traits: [
    RacialTrait(name: 'Lucky', description: 'Reroll 1s on d20 rolls'),
    RacialTrait(name: 'Brave', description: 'Advantage on saves vs frightened'),
    RacialTrait(name: 'Halfling Nimbleness', description: 'Move through larger creature spaces'),
    RacialTrait(name: 'Stout Resilience', description: 'Advantage on saves vs poison, resistance to poison damage'),
  ],
);

// ============================================================================
// DRAGONBORN
// ============================================================================

final DnDRace _dragonborn = DnDRace(
  name: 'Dragonborn',
  description: 'Dragonborn look very much like dragons standing erect in humanoid form, though they lack wings or a tail.',
  abilityScoreIncreases: {'Strength': 2, 'Charisma': 1},
  age: 80,
  alignment: 'Any',
  size: 'Medium',
  speed: 30,
  languages: ['Common', 'Draconic'],
  traits: [
    RacialTrait(name: 'Draconic Ancestry', description: 'Choose dragon type (affects breath weapon and resistance)'),
    RacialTrait(name: 'Breath Weapon', description: 'Exhale destructive energy (2d6 damage, increases at 6th, 11th, 16th level)'),
    RacialTrait(name: 'Damage Resistance', description: 'Resistance to damage type associated with draconic ancestry'),
  ],
);

// Adding many more races...

final DnDRace _gnome = DnDRace(
  name: 'Gnome',
  description: 'Gnomes are vibrant expressions of life and joy, with boundless energy and enthusiasm.',
  abilityScoreIncreases: {'Intelligence': 2},
  age: 350,
  alignment: 'Neutral Good',
  size: 'Small',
  speed: 25,
  languages: ['Common', 'Gnomish'],
  traits: [
    RacialTrait(name: 'Darkvision', description: 'See in dim light within 60 feet'),
    RacialTrait(name: 'Gnome Cunning', description: 'Advantage on INT, WIS, CHA saves vs magic'),
  ],
  subraces: ['Forest Gnome', 'Rock Gnome', 'Deep Gnome'],
);

final DnDRace _forestGnome = DnDRace(
  name: 'Forest Gnome',
  description: 'Forest gnomes have a natural knack for illusion and inherent quickness.',
  abilityScoreIncreases: {'Intelligence': 2, 'Dexterity': 1},
  age: 350,
  alignment: 'Neutral Good',
  size: 'Small',
  speed: 25,
  languages: ['Common', 'Gnomish'],
  traits: [
    RacialTrait(name: 'Darkvision', description: 'See in dim light within 60 feet'),
    RacialTrait(name: 'Gnome Cunning', description: 'Advantage on INT, WIS, CHA saves vs magic'),
    RacialTrait(name: 'Natural Illusionist', description: 'Know Minor Illusion cantrip'),
    RacialTrait(name: 'Speak with Small Beasts', description: 'Communicate simple ideas with Small or smaller beasts'),
  ],
);

final DnDRace _rockGnome = DnDRace(
  name: 'Rock Gnome',
  description: 'Rock gnomes are natural inventors and tinkers.',
  abilityScoreIncreases: {'Intelligence': 2, 'Constitution': 1},
  age: 350,
  alignment: 'Neutral Good',
  size: 'Small',
  speed: 25,
  languages: ['Common', 'Gnomish'],
  traits: [
    RacialTrait(name: 'Darkvision', description: 'See in dim light within 60 feet'),
    RacialTrait(name: 'Gnome Cunning', description: 'Advantage on INT, WIS, CHA saves vs magic'),
    RacialTrait(name: 'Artificer\'s Lore', description: 'Add 2× proficiency to History checks about magic items, alchemical objects, technological devices'),
    RacialTrait(name: 'Tinker', description: 'Proficiency with artisan\'s tools (tinker\'s tools), can create clockwork devices'),
  ],
);

final DnDRace _deepGnome = DnDRace(
  name: 'Deep Gnome (Svirfneblin)',
  description: 'Deep gnomes live far underground and have adapted to a life of secrecy.',
  abilityScoreIncreases: {'Intelligence': 2, 'Dexterity': 1},
  age: 250,
  alignment: 'Neutral Good',
  size: 'Small',
  speed: 25,
  languages: ['Common', 'Gnomish', 'Undercommon'],
  traits: [
    RacialTrait(name: 'Superior Darkvision', description: 'See in dim light within 120 feet'),
    RacialTrait(name: 'Gnome Cunning', description: 'Advantage on INT, WIS, CHA saves vs magic'),
    RacialTrait(name: 'Stone Camouflage', description: 'Advantage on Stealth checks to hide in rocky terrain'),
  ],
);

// Continuing with more races... (I'll abbreviate the rest for space)

final DnDRace _halfElf = DnDRace(
  name: 'Half-Elf',
  description: 'Half-elves combine what some say are the best qualities of both races.',
  abilityScoreIncreases: {'Charisma': 2, 'Any Two': 1},
  age: 180,
  alignment: 'Any',
  size: 'Medium',
  speed: 30,
  languages: ['Common', 'Elvish', 'One extra'],
  traits: [
    RacialTrait(name: 'Darkvision', description: 'See in dim light within 60 feet'),
    RacialTrait(name: 'Fey Ancestry', description: 'Advantage on saves vs charm, can\'t be magically put to sleep'),
    RacialTrait(name: 'Skill Versatility', description: 'Proficiency in two skills of your choice'),
  ],
);

final DnDRace _halfOrc = DnDRace(
  name: 'Half-Orc',
  description: 'Half-orcs inherit a tendency toward chaos from their orc parents.',
  abilityScoreIncreases: {'Strength': 2, 'Constitution': 1},
  age: 75,
  alignment: 'Chaotic Neutral',
  size: 'Medium',
  speed: 30,
  languages: ['Common', 'Orc'],
  traits: [
    RacialTrait(name: 'Darkvision', description: 'See in dim light within 60 feet'),
    RacialTrait(name: 'Menacing', description: 'Proficiency in Intimidation'),
    RacialTrait(name: 'Relentless Endurance', description: 'Drop to 1 HP instead of 0 once per long rest'),
    RacialTrait(name: 'Savage Attacks', description: 'Roll one additional weapon damage die on critical hit'),
  ],
);

final DnDRace _tiefling = DnDRace(
  name: 'Tiefling',
  description: 'Tieflings are derived from human bloodlines, with infernal heritage.',
  abilityScoreIncreases: {'Intelligence': 1, 'Charisma': 2},
  age: 100,
  alignment: 'Chaotic Neutral',
  size: 'Medium',
  speed: 30,
  languages: ['Common', 'Infernal'],
  traits: [
    RacialTrait(name: 'Darkvision', description: 'See in dim light within 60 feet'),
    RacialTrait(name: 'Hellish Resistance', description: 'Resistance to fire damage'),
    RacialTrait(name: 'Infernal Legacy', description: 'Know Thaumaturgy cantrip; Hellish Rebuke and Darkness at higher levels'),
  ],
);

// Exotic races

final DnDRace _aasimar = DnDRace(
  name: 'Aasimar',
  description: 'Aasimar bear within their souls the light of the heavens.',
  abilityScoreIncreases: {'Charisma': 2},
  age: 160,
  alignment: 'Good',
  size: 'Medium',
  speed: 30,
  languages: ['Common', 'Celestial'],
  traits: [
    RacialTrait(name: 'Darkvision', description: 'See in dim light within 60 feet'),
    RacialTrait(name: 'Celestial Resistance', description: 'Resistance to necrotic and radiant damage'),
    RacialTrait(name: 'Healing Hands', description: 'Heal HP equal to your level as an action'),
    RacialTrait(name: 'Light Bearer', description: 'Know Light cantrip'),
  ],
  subraces: ['Protector Aasimar', 'Scourge Aasimar', 'Fallen Aasimar'],
);

final DnDRace _protectorAasimar = DnDRace(
  name: 'Protector Aasimar',
  description: 'Protector aasimar are charged by the powers of good to guard the weak.',
  abilityScoreIncreases: {'Charisma': 2, 'Wisdom': 1},
  age: 160,
  alignment: 'Good',
  size: 'Medium',
  speed: 30,
  languages: ['Common', 'Celestial'],
  traits: [
    RacialTrait(name: 'Darkvision', description: 'See in dim light within 60 feet'),
    RacialTrait(name: 'Celestial Resistance', description: 'Resistance to necrotic and radiant damage'),
    RacialTrait(name: 'Healing Hands', description: 'Heal HP equal to your level'),
    RacialTrait(name: 'Light Bearer', description: 'Know Light cantrip'),
    RacialTrait(name: 'Radiant Soul', description: 'Sprout wings and fly, deal extra radiant damage'),
  ],
);

final DnDRace _scourgeAasimar = DnDRace(
  name: 'Scourge Aasimar',
  description: 'Scourge aasimar are imbued with divine energy that blazes intensely.',
  abilityScoreIncreases: {'Charisma': 2, 'Constitution': 1},
  age: 160,
  alignment: 'Good',
  size: 'Medium',
  speed: 30,
  languages: ['Common', 'Celestial'],
  traits: [
    RacialTrait(name: 'Darkvision', description: 'See in dim light within 60 feet'),
    RacialTrait(name: 'Celestial Resistance', description: 'Resistance to necrotic and radiant damage'),
    RacialTrait(name: 'Healing Hands', description: 'Heal HP equal to your level'),
    RacialTrait(name: 'Light Bearer', description: 'Know Light cantrip'),
    RacialTrait(name: 'Radiant Consumption', description: 'Emit searing light dealing damage to self and nearby enemies'),
  ],
);

final DnDRace _fallenAasimar = DnDRace(
  name: 'Fallen Aasimar',
  description: 'Fallen aasimar have turned to evil or been touched by dark powers.',
  abilityScoreIncreases: {'Charisma': 2, 'Strength': 1},
  age: 160,
  alignment: 'Evil',
  size: 'Medium',
  speed: 30,
  languages: ['Common', 'Celestial'],
  traits: [
    RacialTrait(name: 'Darkvision', description: 'See in dim light within 60 feet'),
    RacialTrait(name: 'Celestial Resistance', description: 'Resistance to necrotic and radiant damage'),
    RacialTrait(name: 'Healing Hands', description: 'Heal HP equal to your level'),
    RacialTrait(name: 'Light Bearer', description: 'Know Light cantrip'),
    RacialTrait(name: 'Necrotic Shroud', description: 'Sprout skeletal wings and frighten enemies, deal extra necrotic damage'),
  ],
);

// More exotic races (abbreviated for space)

final DnDRace _firbolg = DnDRace(
  name: 'Firbolg',
  description: 'Firbolgs are forest guardians who prefer to remain hidden.',
  abilityScoreIncreases: {'Wisdom': 2, 'Strength': 1},
  age: 500,
  alignment: 'Neutral Good',
  size: 'Medium',
  speed: 30,
  languages: ['Common', 'Elvish', 'Giant'],
  traits: [
    RacialTrait(name: 'Firbolg Magic', description: 'Detect Magic and Disguise Self spells'),
    RacialTrait(name: 'Hidden Step', description: 'Turn invisible as bonus action'),
    RacialTrait(name: 'Powerful Build', description: 'Count as Large for carrying capacity'),
    RacialTrait(name: 'Speech of Beast and Leaf', description: 'Communicate with beasts and plants'),
  ],
);

final DnDRace _goliath = DnDRace(
  name: 'Goliath',
  description: 'Goliaths are massive creatures who live in the highest mountain peaks.',
  abilityScoreIncreases: {'Strength': 2, 'Constitution': 1},
  age: 90,
  alignment: 'Lawful Neutral',
  size: 'Medium',
  speed: 30,
  languages: ['Common', 'Giant'],
  traits: [
    RacialTrait(name: 'Natural Athlete', description: 'Proficiency in Athletics'),
    RacialTrait(name: 'Stone\'s Endurance', description: 'Reduce damage by 1d12 + CON modifier once per short rest'),
    RacialTrait(name: 'Powerful Build', description: 'Count as Large for carrying capacity'),
    RacialTrait(name: 'Mountain Born', description: 'Acclimated to high altitude and cold climate'),
  ],
);

final DnDRace _kenku = DnDRace(
  name: 'Kenku',
  description: 'Kenku are feathered humanoids who wander the world as vagabonds.',
  abilityScoreIncreases: {'Dexterity': 2, 'Wisdom': 1},
  age: 60,
  alignment: 'Chaotic Neutral',
  size: 'Medium',
  speed: 30,
  languages: ['Common', 'Auran (understand but cannot speak)'],
  traits: [
    RacialTrait(name: 'Expert Forgery', description: 'Advantage on checks to produce forgeries'),
    RacialTrait(name: 'Kenku Training', description: 'Proficiency in two skills of your choice'),
    RacialTrait(name: 'Mimicry', description: 'Mimic sounds and voices you\'ve heard'),
  ],
);

final DnDRace _lizardfolk = DnDRace(
  name: 'Lizardfolk',
  description: 'Lizardfolk possess an alien and inscrutable mindset.',
  abilityScoreIncreases: {'Constitution': 2, 'Wisdom': 1},
  age: 60,
  alignment: 'Neutral',
  size: 'Medium',
  speed: 30,
  languages: ['Common', 'Draconic'],
  traits: [
    RacialTrait(name: 'Bite', description: 'Unarmed strike deals 1d6 + STR piercing damage'),
    RacialTrait(name: 'Cunning Artisan', description: 'Craft tools and weapons from slain beasts'),
    RacialTrait(name: 'Hold Breath', description: 'Can hold breath for 15 minutes'),
    RacialTrait(name: 'Hunter\'s Lore', description: 'Proficiency in two skills: Animal Handling, Nature, Perception, Stealth, or Survival'),
    RacialTrait(name: 'Natural Armor', description: 'AC = 13 + DEX modifier when not wearing armor'),
  ],
);

final DnDRace _tabaxi = DnDRace(
  name: 'Tabaxi',
  description: 'Tabaxi are catlike humanoids driven by curiosity to collect stories and artifacts.',
  abilityScoreIncreases: {'Dexterity': 2, 'Charisma': 1},
  age: 100,
  alignment: 'Chaotic Good',
  size: 'Medium',
  speed: 30,
  languages: ['Common', 'One of your choice'],
  traits: [
    RacialTrait(name: 'Darkvision', description: 'See in dim light within 60 feet'),
    RacialTrait(name: 'Feline Agility', description: 'Double speed until end of turn'),
    RacialTrait(name: 'Cat\'s Claws', description: 'Unarmed strikes deal 1d4 + STR slashing, climbing speed = walking speed'),
    RacialTrait(name: 'Cat\'s Talent', description: 'Proficiency in Perception and Stealth'),
  ],
);

final DnDRace _triton = DnDRace(
  name: 'Triton',
  description: 'Tritons guard the ocean depths from evil.',
  abilityScoreIncreases: {'Strength': 1, 'Constitution': 1, 'Charisma': 1},
  age: 200,
  alignment: 'Lawful Good',
  size: 'Medium',
  speed: 30,
  languages: ['Common', 'Primordial'],
  traits: [
    RacialTrait(name: 'Amphibious', description: 'Breathe air and water'),
    RacialTrait(name: 'Control Air and Water', description: 'Cast Fog Cloud; Gust of Wind at 3rd level'),
    RacialTrait(name: 'Emissary of the Sea', description: 'Communicate simple ideas with beasts that can breathe water'),
    RacialTrait(name: 'Guardians of the Depths', description: 'Resistance to cold damage, ignore deep underwater pressure'),
    RacialTrait(name: 'Swim Speed', description: '30 ft swimming speed'),
  ],
);

// Monstrous races

final DnDRace _bugbear = DnDRace(
  name: 'Bugbear',
  description: 'Bugbears are born for battle and mayhem.',
  abilityScoreIncreases: {'Strength': 2, 'Dexterity': 1},
  age: 80,
  alignment: 'Chaotic Evil',
  size: 'Medium',
  speed: 30,
  languages: ['Common', 'Goblin'],
  traits: [
    RacialTrait(name: 'Darkvision', description: 'See in dim light within 60 feet'),
    RacialTrait(name: 'Long-Limbed', description: 'Extra 5 ft reach with melee attacks'),
    RacialTrait(name: 'Powerful Build', description: 'Count as Large for carrying capacity'),
    RacialTrait(name: 'Sneaky', description: 'Proficiency in Stealth'),
    RacialTrait(name: 'Surprise Attack', description: 'Extra 2d6 damage on first hit if surprising'),
  ],
);

final DnDRace _goblin = DnDRace(
  name: 'Goblin',
  description: 'Goblins are small, black-hearted humanoids that lair in caves, abandoned mines, and similar locations.',
  abilityScoreIncreases: {'Dexterity': 2, 'Constitution': 1},
  age: 60,
  alignment: 'Neutral Evil',
  size: 'Small',
  speed: 30,
  languages: ['Common', 'Goblin'],
  traits: [
    RacialTrait(name: 'Darkvision', description: 'See in dim light within 60 feet'),
    RacialTrait(name: 'Fury of the Small', description: 'Deal extra damage equal to your level once per short rest'),
    RacialTrait(name: 'Nimble Escape', description: 'Disengage or Hide as bonus action'),
  ],
);

final DnDRace _hobgoblin = DnDRace(
  name: 'Hobgoblin',
  description: 'Hobgoblins are large goblinoids with dark orange or red-orange skin.',
  abilityScoreIncreases: {'Constitution': 2, 'Intelligence': 1},
  age: 70,
  alignment: 'Lawful Evil',
  size: 'Medium',
  speed: 30,
  languages: ['Common', 'Goblin'],
  traits: [
    RacialTrait(name: 'Darkvision', description: 'See in dim light within 60 feet'),
    RacialTrait(name: 'Martial Training', description: 'Proficiency with two martial weapons and light armor'),
    RacialTrait(name: 'Saving Face', description: 'Add bonus to failed attack roll or ability check'),
  ],
);

final DnDRace _kobold = DnDRace(
  name: 'Kobold',
  description: 'Kobolds are often dismissed as cowardly, foolish, and weak.',
  abilityScoreIncreases: {'Dexterity': 2, 'Strength': -2},
  age: 120,
  alignment: 'Lawful Evil',
  size: 'Small',
  speed: 30,
  languages: ['Common', 'Draconic'],
  traits: [
    RacialTrait(name: 'Darkvision', description: 'See in dim light within 60 feet'),
    RacialTrait(name: 'Grovel, Cower, and Beg', description: 'Distract enemies to give allies advantage'),
    RacialTrait(name: 'Pack Tactics', description: 'Advantage on attack rolls if ally is nearby'),
    RacialTrait(name: 'Sunlight Sensitivity', description: 'Disadvantage on attack rolls and Perception in sunlight'),
  ],
);

final DnDRace _orc = DnDRace(
  name: 'Orc',
  description: 'Orcs live a life that has no place for weakness.',
  abilityScoreIncreases: {'Strength': 2, 'Constitution': 1, 'Intelligence': -2},
  age: 50,
  alignment: 'Chaotic Evil',
  size: 'Medium',
  speed: 30,
  languages: ['Common', 'Orc'],
  traits: [
    RacialTrait(name: 'Darkvision', description: 'See in dim light within 60 feet'),
    RacialTrait(name: 'Aggressive', description: 'Move up to your speed toward an enemy as bonus action'),
    RacialTrait(name: 'Menacing', description: 'Proficiency in Intimidation'),
    RacialTrait(name: 'Powerful Build', description: 'Count as Large for carrying capacity'),
  ],
);

final DnDRace _yuantiPureblood = DnDRace(
  name: 'Yuan-ti Pureblood',
  description: 'Purebloods are the most human-seeming of all yuan-ti.',
  abilityScoreIncreases: {'Charisma': 2, 'Intelligence': 1},
  age: 80,
  alignment: 'Neutral Evil',
  size: 'Medium',
  speed: 30,
  languages: ['Common', 'Abyssal', 'Draconic'],
  traits: [
    RacialTrait(name: 'Darkvision', description: 'See in dim light within 60 feet'),
    RacialTrait(name: 'Innate Spellcasting', description: 'Know Poison Spray; Suggestion at 3rd level'),
    RacialTrait(name: 'Magic Resistance', description: 'Advantage on saves vs spells and magical effects'),
    RacialTrait(name: 'Poison Immunity', description: 'Immune to poison damage and poisoned condition'),
  ],
);

// Genasi variants

final DnDRace _genasi = DnDRace(
  name: 'Genasi',
  description: 'Genasi are planetouched individuals with elemental heritage.',
  abilityScoreIncreases: {'Constitution': 2},
  age: 120,
  alignment: 'Any',
  size: 'Medium',
  speed: 30,
  languages: ['Common', 'Primordial'],
  traits: [],
  subraces: ['Air Genasi', 'Earth Genasi', 'Fire Genasi', 'Water Genasi'],
);

final DnDRace _airGenasi = DnDRace(
  name: 'Air Genasi',
  description: 'Air genasi are descended from djinn.',
  abilityScoreIncreases: {'Constitution': 2, 'Dexterity': 1},
  age: 120,
  alignment: 'Any',
  size: 'Medium',
  speed: 30,
  languages: ['Common', 'Primordial'],
  traits: [
    RacialTrait(name: 'Unending Breath', description: 'Can hold breath indefinitely'),
    RacialTrait(name: 'Mingle with the Wind', description: 'Cast Levitate once per long rest'),
  ],
);

final DnDRace _earthGenasi = DnDRace(
  name: 'Earth Genasi',
  description: 'Earth genasi are descended from dao.',
  abilityScoreIncreases: {'Constitution': 2, 'Strength': 1},
  age: 120,
  alignment: 'Any',
  size: 'Medium',
  speed: 30,
  languages: ['Common', 'Primordial'],
  traits: [
    RacialTrait(name: 'Earth Walk', description: 'Move across difficult terrain without penalty'),
    RacialTrait(name: 'Merge with Stone', description: 'Cast Pass Without Trace once per long rest'),
  ],
);

final DnDRace _fireGenasi = DnDRace(
  name: 'Fire Genasi',
  description: 'Fire genasi are descended from efreet.',
  abilityScoreIncreases: {'Constitution': 2, 'Intelligence': 1},
  age: 120,
  alignment: 'Any',
  size: 'Medium',
  speed: 30,
  languages: ['Common', 'Primordial'],
  traits: [
    RacialTrait(name: 'Darkvision', description: 'See in dim light within 60 feet'),
    RacialTrait(name: 'Fire Resistance', description: 'Resistance to fire damage'),
    RacialTrait(name: 'Reach to the Blaze', description: 'Know Produce Flame; Burning Hands at 3rd level'),
  ],
);

final DnDRace _waterGenasi = DnDRace(
  name: 'Water Genasi',
  description: 'Water genasi are descended from marids.',
  abilityScoreIncreases: {'Constitution': 2, 'Wisdom': 1},
  age: 120,
  alignment: 'Any',
  size: 'Medium',
  speed: 30,
  languages: ['Common', 'Primordial'],
  traits: [
    RacialTrait(name: 'Acid Resistance', description: 'Resistance to acid damage'),
    RacialTrait(name: 'Amphibious', description: 'Breathe air and water'),
    RacialTrait(name: 'Swim Speed', description: '30 ft swimming speed'),
    RacialTrait(name: 'Call to the Wave', description: 'Know Shape Water; Create or Destroy Water at 3rd level'),
  ],
);

// More exotic races

final DnDRace _aarakocra = DnDRace(
  name: 'Aarakocra',
  description: 'Aarakocra are bird people from the Elemental Plane of Air.',
  abilityScoreIncreases: {'Dexterity': 2, 'Wisdom': 1},
  age: 30,
  alignment: 'Good',
  size: 'Medium',
  speed: 25,
  languages: ['Common', 'Aarakocra', 'Auran'],
  traits: [
    RacialTrait(name: 'Flight', description: '50 ft flying speed (can\'t fly in medium or heavy armor)'),
    RacialTrait(name: 'Talons', description: 'Unarmed strikes deal 1d4 slashing damage'),
  ],
);

final DnDRace _tortle = DnDRace(
  name: 'Tortle',
  description: 'Tortles are turtle-like humanoids who roam the wilderness.',
  abilityScoreIncreases: {'Strength': 2, 'Wisdom': 1},
  age: 50,
  alignment: 'Lawful Good',
  size: 'Medium',
  speed: 30,
  languages: ['Common', 'Aquan'],
  traits: [
    RacialTrait(name: 'Claws', description: 'Unarmed strikes deal 1d4 + STR slashing'),
    RacialTrait(name: 'Hold Breath', description: 'Can hold breath for 1 hour'),
    RacialTrait(name: 'Natural Armor', description: 'AC = 17 (can\'t wear armor, but can use shields)'),
    RacialTrait(name: 'Shell Defense', description: 'Withdraw into shell for +4 AC'),
    RacialTrait(name: 'Survival Instinct', description: 'Proficiency in Survival'),
  ],
);

// Eberron races

final DnDRace _changeling = DnDRace(
  name: 'Changeling',
  description: 'Changelings can shift their forms with a thought.',
  abilityScoreIncreases: {'Charisma': 2, 'Any One': 1},
  age: 100,
  alignment: 'Neutral',
  size: 'Medium',
  speed: 30,
  languages: ['Common', 'Two others'],
  traits: [
    RacialTrait(name: 'Shapechanger', description: 'Change appearance and voice at will'),
    RacialTrait(name: 'Changeling Instincts', description: 'Proficiency in two skills: Deception, Intimidation, Insight, or Persuasion'),
  ],
);

final DnDRace _kalashtar = DnDRace(
  name: 'Kalashtar',
  description: 'Kalashtar are compound beings, hosts to spirits from the plane of dreams.',
  abilityScoreIncreases: {'Wisdom': 2, 'Charisma': 1},
  age: 100,
  alignment: 'Lawful Good',
  size: 'Medium',
  speed: 30,
  languages: ['Common', 'Quori', 'One other'],
  traits: [
    RacialTrait(name: 'Dual Mind', description: 'Advantage on WIS saving throws'),
    RacialTrait(name: 'Mental Discipline', description: 'Resistance to psychic damage'),
    RacialTrait(name: 'Mind Link', description: 'Telepathically communicate with creatures you can see'),
    RacialTrait(name: 'Severed from Dreams', description: 'Immune to spells and effects that require dreaming'),
  ],
);

final DnDRace _shifter = DnDRace(
  name: 'Shifter',
  description: 'Shifters have lycanthropic heritage and can temporarily enhance their animalistic features.',
  abilityScoreIncreases: {'Dexterity': 1},
  age: 70,
  alignment: 'Neutral',
  size: 'Medium',
  speed: 30,
  languages: ['Common'],
  traits: [
    RacialTrait(name: 'Darkvision', description: 'See in dim light within 60 feet'),
    RacialTrait(name: 'Keen Senses', description: 'Proficiency in Perception'),
    RacialTrait(name: 'Shifting', description: 'Transform for 1 minute, gain temp HP and special abilities'),
  ],
);

final DnDRace _warforged = DnDRace(
  name: 'Warforged',
  description: 'Warforged are living constructs created for war.',
  abilityScoreIncreases: {'Constitution': 2, 'Any One': 1},
  age: 2,
  alignment: 'Lawful Neutral',
  size: 'Medium',
  speed: 30,
  languages: ['Common', 'One other'],
  traits: [
    RacialTrait(name: 'Constructed Resilience', description: 'Don\'t need to eat, drink, breathe, or sleep; advantage vs poison; resistance to poison damage'),
    RacialTrait(name: 'Sentry\'s Rest', description: 'Rest in inactive state for 6 hours'),
    RacialTrait(name: 'Integrated Protection', description: 'AC = 11 + DEX modifier + proficiency bonus (can wear armor)'),
    RacialTrait(name: 'Specialized Design', description: 'Gain one skill and one tool proficiency'),
  ],
);

// Ravnica races

final DnDRace _centaur = DnDRace(
  name: 'Centaur',
  description: 'Centaurs are half-human, half-horse beings.',
  abilityScoreIncreases: {'Strength': 2, 'Wisdom': 1},
  age: 100,
  alignment: 'Neutral Good',
  size: 'Medium',
  speed: 40,
  languages: ['Common', 'Sylvan'],
  traits: [
    RacialTrait(name: 'Fey', description: 'Your creature type is fey rather than humanoid'),
    RacialTrait(name: 'Charge', description: 'Deal extra 1d6 damage if you move 30+ ft straight toward target'),
    RacialTrait(name: 'Hooves', description: 'Unarmed strikes with hooves deal 1d4 + STR bludgeoning'),
    RacialTrait(name: 'Equine Build', description: 'Can\'t climb, count as one size larger for carrying capacity'),
    RacialTrait(name: 'Survivor', description: 'Proficiency in one skill: Animal Handling, Medicine, Nature, or Survival'),
  ],
);

final DnDRace _loxodon = DnDRace(
  name: 'Loxodon',
  description: 'Loxodons are elephant-like humanoids.',
  abilityScoreIncreases: {'Constitution': 2, 'Wisdom': 1},
  age: 450,
  alignment: 'Lawful Good',
  size: 'Medium',
  speed: 30,
  languages: ['Common', 'Loxodon'],
  traits: [
    RacialTrait(name: 'Powerful Build', description: 'Count as Large for carrying capacity'),
    RacialTrait(name: 'Loxodon Serenity', description: 'Advantage on saves vs charmed or frightened'),
    RacialTrait(name: 'Natural Armor', description: 'AC = 12 + CON modifier when not wearing armor'),
    RacialTrait(name: 'Trunk', description: 'Can grasp objects and make unarmed strikes (1d6 + STR bludgeoning)'),
    RacialTrait(name: 'Keen Smell', description: 'Advantage on Perception, Investigation, and Survival checks involving smell'),
  ],
);

final DnDRace _minotaur = DnDRace(
  name: 'Minotaur',
  description: 'Minotaurs are powerful bull-headed humanoids.',
  abilityScoreIncreases: {'Strength': 2, 'Constitution': 1},
  age: 150,
  alignment: 'Chaotic Neutral',
  size: 'Medium',
  speed: 30,
  languages: ['Common', 'Minotaur'],
  traits: [
    RacialTrait(name: 'Horns', description: 'Unarmed strikes with horns deal 1d6 + STR piercing'),
    RacialTrait(name: 'Goring Rush', description: 'Dash as bonus action, then attack with horns'),
    RacialTrait(name: 'Hammering Horns', description: 'Push creatures back when you hit with horns'),
    RacialTrait(name: 'Labyrinthine Recall', description: 'Always know direction north and distance traveled'),
  ],
);

// Theros races

final DnDRace _satyr = DnDRace(
  name: 'Satyr',
  description: 'Satyrs are fey creatures who love music and revelry.',
  abilityScoreIncreases: {'Charisma': 2, 'Dexterity': 1},
  age: 500,
  alignment: 'Chaotic Neutral',
  size: 'Medium',
  speed: 35,
  languages: ['Common', 'Sylvan'],
  traits: [
    RacialTrait(name: 'Fey', description: 'Your creature type is fey'),
    RacialTrait(name: 'Ram', description: 'Unarmed strikes deal 1d4 + STR bludgeoning'),
    RacialTrait(name: 'Magic Resistance', description: 'Advantage on saves vs spells and magical effects'),
    RacialTrait(name: 'Mirthful Leaps', description: 'Add CHA to long jump and high jump distances'),
    RacialTrait(name: 'Reveler', description: 'Proficiency in Performance and Persuasion, one musical instrument'),
  ],
);

final DnDRace _leonin = DnDRace(
  name: 'Leonin',
  description: 'Leonin are fierce lion-like humanoids.',
  abilityScoreIncreases: {'Constitution': 2, 'Strength': 1},
  age: 100,
  alignment: 'Good',
  size: 'Medium',
  speed: 30,
  languages: ['Common', 'Leonin'],
  traits: [
    RacialTrait(name: 'Darkvision', description: 'See in dim light within 60 feet'),
    RacialTrait(name: 'Claws', description: 'Unarmed strikes deal 1d4 + STR slashing'),
    RacialTrait(name: 'Hunter\'s Instincts', description: 'Proficiency in one skill: Athletics, Intimidation, Perception, or Survival'),
    RacialTrait(name: 'Daunting Roar', description: 'Frighten creatures within 10 ft as bonus action'),
  ],
);

// Wild Beyond the Witchlight races

final DnDRace _fairy = DnDRace(
  name: 'Fairy',
  description: 'Fairies are tiny, magical fey creatures.',
  abilityScoreIncreases: {'Any One': 2, 'Any Other': 1},
  age: 200,
  alignment: 'Chaotic Good',
  size: 'Small',
  speed: 30,
  languages: ['Common', 'Sylvan'],
  traits: [
    RacialTrait(name: 'Fairy Magic', description: 'Know Druidcraft; Faerie Fire and Enlarge/Reduce at higher levels'),
    RacialTrait(name: 'Flight', description: 'Fly equal to walking speed'),
    RacialTrait(name: 'Fey', description: 'Your creature type is fey'),
  ],
);

final DnDRace _harengon = DnDRace(
  name: 'Harengon',
  description: 'Harengons are rabbit-folk from the Feywild.',
  abilityScoreIncreases: {'Any One': 2, 'Any Other': 1},
  age: 100,
  alignment: 'Any',
  size: 'Medium or Small',
  speed: 30,
  languages: ['Common', 'One other'],
  traits: [
    RacialTrait(name: 'Hare-Trigger', description: 'Add proficiency bonus to initiative'),
    RacialTrait(name: 'Leporine Senses', description: 'Proficiency in Perception'),
    RacialTrait(name: 'Lucky Footwork', description: 'Add d4 to failed DEX save once per failed save'),
    RacialTrait(name: 'Rabbit Hop', description: 'Jump a number of feet equal to 5× proficiency bonus as bonus action'),
  ],
);

final DnDRace _owlin = DnDRace(
  name: 'Owlin',
  description: 'Owlins are owl-like humanoids.',
  abilityScoreIncreases: {'Any One': 2, 'Any Other': 1},
  age: 100,
  alignment: 'Any',
  size: 'Medium or Small',
  speed: 30,
  languages: ['Common', 'One other'],
  traits: [
    RacialTrait(name: 'Darkvision', description: 'See in dim light within 120 feet'),
    RacialTrait(name: 'Flight', description: 'Fly equal to walking speed (can\'t fly in medium or heavy armor)'),
    RacialTrait(name: 'Silent Feathers', description: 'Proficiency in Stealth'),
  ],
);
