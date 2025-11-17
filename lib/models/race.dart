class Race {
  String id;
  String name;
  String subrace; // e.g., "High Elf", "Hill Dwarf", "Lightfoot Halfling"

  // Ability score increases
  Map<String, int> abilityIncreases; // e.g., {"Dexterity": 2, "Intelligence": 1}

  // Basic traits
  int speed;
  String size; // "Small" or "Medium"
  List<String> languages;

  // Special traits
  List<RacialTrait> traits;

  // Darkvision
  int? darkvisionRange; // in feet (usually 60)

  Race({
    required this.id,
    required this.name,
    required this.subrace,
    required this.abilityIncreases,
    required this.speed,
    required this.size,
    required this.languages,
    required this.traits,
    this.darkvisionRange,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'subrace': subrace,
    'abilityIncreases': abilityIncreases,
    'speed': speed,
    'size': size,
    'languages': languages,
    'traits': traits.map((t) => t.toJson()).toList(),
    'darkvisionRange': darkvisionRange,
  };

  factory Race.fromJson(Map<String, dynamic> json) => Race(
    id: json['id'] as String,
    name: json['name'] as String,
    subrace: json['subrace'] as String,
    abilityIncreases: (json['abilityIncreases'] as Map<String, dynamic>).cast<String, int>(),
    speed: json['speed'] as int,
    size: json['size'] as String,
    languages: (json['languages'] as List<dynamic>).cast<String>(),
    traits: (json['traits'] as List<dynamic>)
        .map((t) => RacialTrait.fromJson(t as Map<String, dynamic>))
        .toList(),
    darkvisionRange: json['darkvisionRange'] as int?,
  );
}

class RacialTrait {
  String name;
  String description;
  String? effect; // "advantage_on_saves_vs_charm", "resistance_poison", etc.

  RacialTrait({
    required this.name,
    required this.description,
    this.effect,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'effect': effect,
  };

  factory RacialTrait.fromJson(Map<String, dynamic> json) => RacialTrait(
    name: json['name'] as String,
    description: json['description'] as String,
    effect: json['effect'] as String?,
  );
}

// Predefined races
class Races {
  static Race human() => Race(
    id: 'human',
    name: 'Human',
    subrace: 'Standard',
    abilityIncreases: {
      'Strength': 1,
      'Dexterity': 1,
      'Constitution': 1,
      'Intelligence': 1,
      'Wisdom': 1,
      'Charisma': 1,
    },
    speed: 30,
    size: 'Medium',
    languages: ['Common', 'One extra language'],
    traits: [],
  );

  static Race variantHuman() => Race(
    id: 'human_variant',
    name: 'Human',
    subrace: 'Variant',
    abilityIncreases: {
      'Any1': 1,
      'Any2': 1,
    },
    speed: 30,
    size: 'Medium',
    languages: ['Common', 'One extra language'],
    traits: [
      RacialTrait(
        name: 'Skills',
        description: 'You gain proficiency in one skill of your choice.',
      ),
      RacialTrait(
        name: 'Feat',
        description: 'You gain one feat of your choice.',
      ),
    ],
  );

  static Race highElf() => Race(
    id: 'high_elf',
    name: 'Elf',
    subrace: 'High Elf',
    abilityIncreases: {
      'Dexterity': 2,
      'Intelligence': 1,
    },
    speed: 30,
    size: 'Medium',
    languages: ['Common', 'Elvish'],
    darkvisionRange: 60,
    traits: [
      RacialTrait(
        name: 'Fey Ancestry',
        description: 'You have advantage on saving throws against being charmed, and magic can\'t put you to sleep.',
        effect: 'advantage_saves_charm_sleep',
      ),
      RacialTrait(
        name: 'Trance',
        description: 'Elves don\'t need to sleep. Instead, they meditate deeply for 4 hours a day.',
      ),
      RacialTrait(
        name: 'Keen Senses',
        description: 'You have proficiency in the Perception skill.',
        effect: 'proficiency_perception',
      ),
      RacialTrait(
        name: 'Elf Weapon Training',
        description: 'You have proficiency with longsword, shortsword, shortbow, and longbow.',
      ),
      RacialTrait(
        name: 'Cantrip',
        description: 'You know one cantrip of your choice from the wizard spell list. Intelligence is your spellcasting ability for it.',
      ),
    ],
  );

  static Race woodElf() => Race(
    id: 'wood_elf',
    name: 'Elf',
    subrace: 'Wood Elf',
    abilityIncreases: {
      'Dexterity': 2,
      'Wisdom': 1,
    },
    speed: 35,
    size: 'Medium',
    languages: ['Common', 'Elvish'],
    darkvisionRange: 60,
    traits: [
      RacialTrait(
        name: 'Fey Ancestry',
        description: 'You have advantage on saving throws against being charmed, and magic can\'t put you to sleep.',
        effect: 'advantage_saves_charm_sleep',
      ),
      RacialTrait(
        name: 'Trance',
        description: 'Elves don\'t need to sleep. Instead, they meditate deeply for 4 hours a day.',
      ),
      RacialTrait(
        name: 'Keen Senses',
        description: 'You have proficiency in the Perception skill.',
        effect: 'proficiency_perception',
      ),
      RacialTrait(
        name: 'Elf Weapon Training',
        description: 'You have proficiency with longsword, shortsword, shortbow, and longbow.',
      ),
      RacialTrait(
        name: 'Fleet of Foot',
        description: 'Your base walking speed increases to 35 feet.',
      ),
      RacialTrait(
        name: 'Mask of the Wild',
        description: 'You can attempt to hide even when you are only lightly obscured by foliage, heavy rain, falling snow, mist, and other natural phenomena.',
      ),
    ],
  );

  static Race mountainDwarf() => Race(
    id: 'mountain_dwarf',
    name: 'Dwarf',
    subrace: 'Mountain Dwarf',
    abilityIncreases: {
      'Constitution': 2,
      'Strength': 2,
    },
    speed: 25,
    size: 'Medium',
    languages: ['Common', 'Dwarvish'],
    darkvisionRange: 60,
    traits: [
      RacialTrait(
        name: 'Dwarven Resilience',
        description: 'You have advantage on saving throws against poison, and you have resistance against poison damage.',
        effect: 'advantage_saves_poison_resistance_poison',
      ),
      RacialTrait(
        name: 'Dwarven Combat Training',
        description: 'You have proficiency with the battleaxe, handaxe, light hammer, and warhammer.',
      ),
      RacialTrait(
        name: 'Tool Proficiency',
        description: 'You gain proficiency with artisan\'s tools of your choice: smith\'s tools, brewer\'s supplies, or mason\'s tools.',
      ),
      RacialTrait(
        name: 'Stonecunning',
        description: 'Whenever you make an Intelligence (History) check related to the origin of stonework, you are considered proficient and add double your proficiency bonus.',
      ),
      RacialTrait(
        name: 'Dwarven Armor Training',
        description: 'You have proficiency with light and medium armor.',
      ),
    ],
  );

  static Race hillDwarf() => Race(
    id: 'hill_dwarf',
    name: 'Dwarf',
    subrace: 'Hill Dwarf',
    abilityIncreases: {
      'Constitution': 2,
      'Wisdom': 1,
    },
    speed: 25,
    size: 'Medium',
    languages: ['Common', 'Dwarvish'],
    darkvisionRange: 60,
    traits: [
      RacialTrait(
        name: 'Dwarven Resilience',
        description: 'You have advantage on saving throws against poison, and you have resistance against poison damage.',
        effect: 'advantage_saves_poison_resistance_poison',
      ),
      RacialTrait(
        name: 'Dwarven Combat Training',
        description: 'You have proficiency with the battleaxe, handaxe, light hammer, and warhammer.',
      ),
      RacialTrait(
        name: 'Tool Proficiency',
        description: 'You gain proficiency with artisan\'s tools of your choice: smith\'s tools, brewer\'s supplies, or mason\'s tools.',
      ),
      RacialTrait(
        name: 'Stonecunning',
        description: 'Whenever you make an Intelligence (History) check related to the origin of stonework, you are considered proficient and add double your proficiency bonus.',
      ),
      RacialTrait(
        name: 'Dwarven Toughness',
        description: 'Your hit point maximum increases by 1, and it increases by 1 every time you gain a level.',
        effect: 'bonus_hp_per_level',
      ),
    ],
  );

  static Race lightfootHalfling() => Race(
    id: 'lightfoot_halfling',
    name: 'Halfling',
    subrace: 'Lightfoot',
    abilityIncreases: {
      'Dexterity': 2,
      'Charisma': 1,
    },
    speed: 25,
    size: 'Small',
    languages: ['Common', 'Halfling'],
    traits: [
      RacialTrait(
        name: 'Lucky',
        description: 'When you roll a 1 on an attack roll, ability check, or saving throw, you can reroll the die and must use the new roll.',
        effect: 'reroll_ones',
      ),
      RacialTrait(
        name: 'Brave',
        description: 'You have advantage on saving throws against being frightened.',
        effect: 'advantage_saves_frightened',
      ),
      RacialTrait(
        name: 'Halfling Nimbleness',
        description: 'You can move through the space of any creature that is of a size larger than yours.',
      ),
      RacialTrait(
        name: 'Naturally Stealthy',
        description: 'You can attempt to hide even when you are obscured only by a creature that is at least one size larger than you.',
      ),
    ],
  );

  static Race stoutHalfling() => Race(
    id: 'stout_halfling',
    name: 'Halfling',
    subrace: 'Stout',
    abilityIncreases: {
      'Dexterity': 2,
      'Constitution': 1,
    },
    speed: 25,
    size: 'Small',
    languages: ['Common', 'Halfling'],
    traits: [
      RacialTrait(
        name: 'Lucky',
        description: 'When you roll a 1 on an attack roll, ability check, or saving throw, you can reroll the die and must use the new roll.',
        effect: 'reroll_ones',
      ),
      RacialTrait(
        name: 'Brave',
        description: 'You have advantage on saving throws against being frightened.',
        effect: 'advantage_saves_frightened',
      ),
      RacialTrait(
        name: 'Halfling Nimbleness',
        description: 'You can move through the space of any creature that is of a size larger than yours.',
      ),
      RacialTrait(
        name: 'Stout Resilience',
        description: 'You have advantage on saving throws against poison, and you have resistance against poison damage.',
        effect: 'advantage_saves_poison_resistance_poison',
      ),
    ],
  );

  static Race dragonborn() => Race(
    id: 'dragonborn',
    name: 'Dragonborn',
    subrace: 'Gold Dragon Ancestry',
    abilityIncreases: {
      'Strength': 2,
      'Charisma': 1,
    },
    speed: 30,
    size: 'Medium',
    languages: ['Common', 'Draconic'],
    traits: [
      RacialTrait(
        name: 'Draconic Ancestry',
        description: 'You have draconic ancestry. Choose one type of dragon from the Draconic Ancestry table. Your breath weapon and damage resistance are determined by the dragon type.',
      ),
      RacialTrait(
        name: 'Breath Weapon',
        description: 'You can use your action to exhale destructive energy. Your draconic ancestry determines the size, shape, and damage type of the exhalation. Each creature in the area must make a saving throw (DC = 8 + Con mod + proficiency). On failed save, takes 2d6 damage, half on success. Damage increases at levels 6 (3d6), 11 (4d6), 16 (5d6). Usable once per short/long rest.',
        effect: 'breath_weapon',
      ),
      RacialTrait(
        name: 'Damage Resistance',
        description: 'You have resistance to the damage type associated with your draconic ancestry.',
        effect: 'resistance_fire', // varies by ancestry
      ),
    ],
  );

  static Race tiefling() => Race(
    id: 'tiefling',
    name: 'Tiefling',
    subrace: 'Standard',
    abilityIncreases: {
      'Charisma': 2,
      'Intelligence': 1,
    },
    speed: 30,
    size: 'Medium',
    languages: ['Common', 'Infernal'],
    darkvisionRange: 60,
    traits: [
      RacialTrait(
        name: 'Hellish Resistance',
        description: 'You have resistance to fire damage.',
        effect: 'resistance_fire',
      ),
      RacialTrait(
        name: 'Infernal Legacy',
        description: 'You know the thaumaturgy cantrip. At 3rd level, you can cast hellish rebuke once per long rest. At 5th level, you can cast darkness once per long rest. Charisma is your spellcasting ability for these spells.',
        effect: 'infernal_legacy',
      ),
    ],
  );

  static Race halfElf() => Race(
    id: 'half_elf',
    name: 'Half-Elf',
    subrace: 'Standard',
    abilityIncreases: {
      'Charisma': 2,
      'Any1': 1,
      'Any2': 1,
    },
    speed: 30,
    size: 'Medium',
    languages: ['Common', 'Elvish', 'One extra language'],
    darkvisionRange: 60,
    traits: [
      RacialTrait(
        name: 'Fey Ancestry',
        description: 'You have advantage on saving throws against being charmed, and magic can\'t put you to sleep.',
        effect: 'advantage_saves_charm_sleep',
      ),
      RacialTrait(
        name: 'Skill Versatility',
        description: 'You gain proficiency in two skills of your choice.',
        effect: 'skill_versatility',
      ),
    ],
  );

  static Race halfOrc() => Race(
    id: 'half_orc',
    name: 'Half-Orc',
    subrace: 'Standard',
    abilityIncreases: {
      'Strength': 2,
      'Constitution': 1,
    },
    speed: 30,
    size: 'Medium',
    languages: ['Common', 'Orc'],
    darkvisionRange: 60,
    traits: [
      RacialTrait(
        name: 'Relentless Endurance',
        description: 'When you are reduced to 0 hit points but not killed outright, you can drop to 1 hit point instead. You can\'t use this feature again until you finish a long rest.',
        effect: 'relentless_endurance',
      ),
      RacialTrait(
        name: 'Savage Attacks',
        description: 'When you score a critical hit with a melee weapon attack, you can roll one of the weapon\'s damage dice one additional time and add it to the extra damage of the critical hit.',
        effect: 'savage_attacks',
      ),
      RacialTrait(
        name: 'Menacing',
        description: 'You gain proficiency in the Intimidation skill.',
        effect: 'proficiency_intimidation',
      ),
    ],
  );

  static Race gnome() => Race(
    id: 'rock_gnome',
    name: 'Gnome',
    subrace: 'Rock Gnome',
    abilityIncreases: {
      'Intelligence': 2,
      'Constitution': 1,
    },
    speed: 25,
    size: 'Small',
    languages: ['Common', 'Gnomish'],
    darkvisionRange: 60,
    traits: [
      RacialTrait(
        name: 'Gnome Cunning',
        description: 'You have advantage on all Intelligence, Wisdom, and Charisma saving throws against magic.',
        effect: 'advantage_saves_magic',
      ),
      RacialTrait(
        name: 'Artificer\'s Lore',
        description: 'Whenever you make an Intelligence (History) check related to magic items, alchemical objects, or technological devices, you can add twice your proficiency bonus.',
      ),
      RacialTrait(
        name: 'Tinker',
        description: 'You have proficiency with artisan\'s tools (tinker\'s tools). You can spend 1 hour and 10 gp to construct a Tiny clockwork device (AC 5, 1 hp).',
      ),
    ],
  );

  static List<Race> getAllRaces() {
    return [
      human(),
      variantHuman(),
      highElf(),
      woodElf(),
      mountainDwarf(),
      hillDwarf(),
      lightfootHalfling(),
      stoutHalfling(),
      dragonborn(),
      tiefling(),
      halfElf(),
      halfOrc(),
      gnome(),
    ];
  }
}
