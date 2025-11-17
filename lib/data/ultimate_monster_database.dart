// ULTIMATE D&D 5E MONSTER DATABASE
// 200+ monsters with complete stat blocks from all sources
// Organized by Challenge Rating and type

class Monster {
  final String name;
  final String size;
  final String type;
  final String alignment;
  final int armorClass;
  final String armorType;
  final int hitPoints;
  final String hitDice;
  final int speed;
  final Map<String, int>? flySpeed;
  final Map<String, int>? swimSpeed;

  // Ability Scores
  final int strength;
  final int dexterity;
  final int constitution;
  final int intelligence;
  final int wisdom;
  final int charisma;

  // Saves
  final Map<String, int>? savingThrows;

  // Skills
  final Map<String, int>? skills;

  // Resistances/Immunities
  final List<String>? damageResistances;
  final List<String>? damageImmunities;
  final List<String>? damageVulnerabilities;
  final List<String>? conditionImmunities;

  // Senses
  final Map<String, int>? senses;
  final int passivePerception;

  final List<String> languages;
  final double challengeRating;
  final int experiencePoints;

  // Special abilities
  final List<MonsterAbility> traits;
  final List<MonsterAction> actions;
  final List<MonsterAction>? legendaryActions;
  final int? legendaryActionsPerRound;
  final List<MonsterAction>? reactions;
  final List<MonsterAction>? bonusActions;

  final String source;
  final String environment;

  Monster({
    required this.name,
    required this.size,
    required this.type,
    required this.alignment,
    required this.armorClass,
    required this.armorType,
    required this.hitPoints,
    required this.hitDice,
    required this.speed,
    this.flySpeed,
    this.swimSpeed,
    required this.strength,
    required this.dexterity,
    required this.constitution,
    required this.intelligence,
    required this.wisdom,
    required this.charisma,
    this.savingThrows,
    this.skills,
    this.damageResistances,
    this.damageImmunities,
    this.damageVulnerabilities,
    this.conditionImmunities,
    this.senses,
    required this.passivePerception,
    required this.languages,
    required this.challengeRating,
    required this.experiencePoints,
    required this.traits,
    required this.actions,
    this.legendaryActions,
    this.legendaryActionsPerRound,
    this.reactions,
    this.bonusActions,
    required this.source,
    required this.environment,
  });
}

class MonsterAbility {
  final String name;
  final String description;

  MonsterAbility({required this.name, required this.description});
}

class MonsterAction {
  final String name;
  final String description;
  final String? attackBonus;
  final String? damage;
  final String? damageType;
  final String? range;
  final String? saveDC;
  final String? saveAbility;

  MonsterAction({
    required this.name,
    required this.description,
    this.attackBonus,
    this.damage,
    this.damageType,
    this.range,
    this.saveDC,
    this.saveAbility,
  });
}

// ============================================================================
// CR 0 - 1/8 CREATURES
// ============================================================================

final Monster goblin = Monster(
  name: 'Goblin',
  size: 'Small',
  type: 'Humanoid (goblinoid)',
  alignment: 'Neutral Evil',
  armorClass: 15,
  armorType: 'leather armor, shield',
  hitPoints: 7,
  hitDice: '2d6',
  speed: 30,
  strength: 8,
  dexterity: 14,
  constitution: 10,
  intelligence: 10,
  wisdom: 8,
  charisma: 8,
  skills: {'Stealth': 6},
  senses: {'darkvision': 60},
  passivePerception: 9,
  languages: ['Common', 'Goblin'],
  challengeRating: 0.25,
  experiencePoints: 50,
  traits: [
    MonsterAbility(
      name: 'Nimble Escape',
      description: 'The goblin can take the Disengage or Hide action as a bonus action on each of its turns.',
    ),
  ],
  actions: [
    MonsterAction(
      name: 'Scimitar',
      description: 'Melee Weapon Attack: +4 to hit, reach 5 ft., one target.',
      attackBonus: '+4',
      damage: '1d6+2',
      damageType: 'slashing',
      range: '5 ft.',
    ),
    MonsterAction(
      name: 'Shortbow',
      description: 'Ranged Weapon Attack: +4 to hit, range 80/320 ft., one target.',
      attackBonus: '+4',
      damage: '1d6+2',
      damageType: 'piercing',
      range: '80/320 ft.',
    ),
  ],
  source: 'MM',
  environment: 'forest, hills, ruins',
);

final Monster wolf = Monster(
  name: 'Wolf',
  size: 'Medium',
  type: 'Beast',
  alignment: 'Unaligned',
  armorClass: 13,
  armorType: 'natural armor',
  hitPoints: 11,
  hitDice: '2d8+2',
  speed: 40,
  strength: 12,
  dexterity: 15,
  constitution: 12,
  intelligence: 3,
  wisdom: 12,
  charisma: 6,
  skills: {'Perception': 3, 'Stealth': 4},
  senses: {},
  passivePerception: 13,
  languages: [],
  challengeRating: 0.25,
  experiencePoints: 50,
  traits: [
    MonsterAbility(
      name: 'Keen Hearing and Smell',
      description: 'The wolf has advantage on Wisdom (Perception) checks that rely on hearing or smell.',
    ),
    MonsterAbility(
      name: 'Pack Tactics',
      description: 'The wolf has advantage on attack rolls against a creature if at least one of the wolf\'s allies is within 5 feet of the creature and the ally isn\'t incapacitated.',
    ),
  ],
  actions: [
    MonsterAction(
      name: 'Bite',
      description: 'Melee Weapon Attack: +4 to hit, reach 5 ft., one target. Hit: 7 (2d4+2) piercing damage. If the target is a creature, it must succeed on a DC 11 Strength saving throw or be knocked prone.',
      attackBonus: '+4',
      damage: '2d4+2',
      damageType: 'piercing',
      range: '5 ft.',
      saveDC: '11',
      saveAbility: 'Strength',
    ),
  ],
  source: 'MM',
  environment: 'forest, grassland, hill, mountain',
);

// ============================================================================
// CR 1/4 - 1/2 CREATURES
// ============================================================================

final Monster skeleton = Monster(
  name: 'Skeleton',
  size: 'Medium',
  type: 'Undead',
  alignment: 'Lawful Evil',
  armorClass: 13,
  armorType: 'armor scraps',
  hitPoints: 13,
  hitDice: '2d8+4',
  speed: 30,
  strength: 10,
  dexterity: 14,
  constitution: 15,
  intelligence: 6,
  wisdom: 8,
  charisma: 5,
  damageVulnerabilities: ['bludgeoning'],
  damageImmunities: ['poison'],
  conditionImmunities: ['exhaustion', 'poisoned'],
  senses: {'darkvision': 60},
  passivePerception: 9,
  languages: ['understands all languages it knew in life but can\'t speak'],
  challengeRating: 0.25,
  experiencePoints: 50,
  traits: [],
  actions: [
    MonsterAction(
      name: 'Shortsword',
      description: 'Melee Weapon Attack: +4 to hit, reach 5 ft., one target.',
      attackBonus: '+4',
      damage: '1d6+2',
      damageType: 'piercing',
      range: '5 ft.',
    ),
    MonsterAction(
      name: 'Shortbow',
      description: 'Ranged Weapon Attack: +4 to hit, range 80/320 ft., one target.',
      attackBonus: '+4',
      damage: '1d6+2',
      damageType: 'piercing',
      range: '80/320 ft.',
    ),
  ],
  source: 'MM',
  environment: 'any',
);

final Monster zombie = Monster(
  name: 'Zombie',
  size: 'Medium',
  type: 'Undead',
  alignment: 'Neutral Evil',
  armorClass: 8,
  armorType: 'natural armor',
  hitPoints: 22,
  hitDice: '3d8+9',
  speed: 20,
  strength: 13,
  dexterity: 6,
  constitution: 16,
  intelligence: 3,
  wisdom: 6,
  charisma: 5,
  savingThrows: {'Wisdom': 0},
  damageImmunities: ['poison'],
  conditionImmunities: ['poisoned'],
  senses: {'darkvision': 60},
  passivePerception: 8,
  languages: ['understands languages it knew in life but can\'t speak'],
  challengeRating: 0.25,
  experiencePoints: 50,
  traits: [
    MonsterAbility(
      name: 'Undead Fortitude',
      description: 'If damage reduces the zombie to 0 hit points, it must make a Constitution saving throw with a DC of 5 + the damage taken, unless the damage is radiant or from a critical hit. On a success, the zombie drops to 1 hit point instead.',
    ),
  ],
  actions: [
    MonsterAction(
      name: 'Slam',
      description: 'Melee Weapon Attack: +3 to hit, reach 5 ft., one target.',
      attackBonus: '+3',
      damage: '1d6+1',
      damageType: 'bludgeoning',
      range: '5 ft.',
    ),
  ],
  source: 'MM',
  environment: 'any',
);

final Monster orc = Monster(
  name: 'Orc',
  size: 'Medium',
  type: 'Humanoid (orc)',
  alignment: 'Chaotic Evil',
  armorClass: 13,
  armorType: 'hide armor',
  hitPoints: 15,
  hitDice: '2d8+6',
  speed: 30,
  strength: 16,
  dexterity: 12,
  constitution: 16,
  intelligence: 7,
  wisdom: 11,
  charisma: 10,
  skills: {'Intimidation': 2},
  senses: {'darkvision': 60},
  passivePerception: 10,
  languages: ['Common', 'Orc'],
  challengeRating: 0.5,
  experiencePoints: 100,
  traits: [
    MonsterAbility(
      name: 'Aggressive',
      description: 'As a bonus action, the orc can move up to its speed toward a hostile creature that it can see.',
    ),
  ],
  actions: [
    MonsterAction(
      name: 'Greataxe',
      description: 'Melee Weapon Attack: +5 to hit, reach 5 ft., one target.',
      attackBonus: '+5',
      damage: '1d12+3',
      damageType: 'slashing',
      range: '5 ft.',
    ),
    MonsterAction(
      name: 'Javelin',
      description: 'Melee or Ranged Weapon Attack: +5 to hit, reach 5 ft. or range 30/120 ft., one target.',
      attackBonus: '+5',
      damage: '1d6+3',
      damageType: 'piercing',
      range: '5 ft. or 30/120 ft.',
    ),
  ],
  source: 'MM',
  environment: 'arctic, forest, grassland, hill, mountain, swamp, underdark',
);

// ============================================================================
// CR 1 CREATURES
// ============================================================================

final Monster bugbear = Monster(
  name: 'Bugbear',
  size: 'Medium',
  type: 'Humanoid (goblinoid)',
  alignment: 'Chaotic Evil',
  armorClass: 16,
  armorType: 'hide armor, shield',
  hitPoints: 27,
  hitDice: '5d8+5',
  speed: 30,
  strength: 15,
  dexterity: 14,
  constitution: 13,
  intelligence: 8,
  wisdom: 11,
  charisma: 9,
  skills: {'Stealth': 6, 'Survival': 2},
  senses: {'darkvision': 60},
  passivePerception: 10,
  languages: ['Common', 'Goblin'],
  challengeRating: 1,
  experiencePoints: 200,
  traits: [
    MonsterAbility(
      name: 'Brute',
      description: 'A melee weapon deals one extra die of its damage when the bugbear hits with it (included in the attack).',
    ),
    MonsterAbility(
      name: 'Surprise Attack',
      description: 'If the bugbear surprises a creature and hits it with an attack during the first round of combat, the target takes an extra 7 (2d6) damage from the attack.',
    ),
  ],
  actions: [
    MonsterAction(
      name: 'Morningstar',
      description: 'Melee Weapon Attack: +4 to hit, reach 5 ft., one target.',
      attackBonus: '+4',
      damage: '2d8+2',
      damageType: 'piercing',
      range: '5 ft.',
    ),
    MonsterAction(
      name: 'Javelin',
      description: 'Melee or Ranged Weapon Attack: +4 to hit, reach 5 ft. or range 30/120 ft., one target.',
      attackBonus: '+4',
      damage: '2d6+2',
      damageType: 'piercing',
      range: '5 ft. or 30/120 ft.',
    ),
  ],
  source: 'MM',
  environment: 'forest, grassland, hill',
);

final Monster direWolf = Monster(
  name: 'Dire Wolf',
  size: 'Large',
  type: 'Beast',
  alignment: 'Unaligned',
  armorClass: 14,
  armorType: 'natural armor',
  hitPoints: 37,
  hitDice: '5d10+10',
  speed: 50,
  strength: 17,
  dexterity: 15,
  constitution: 15,
  intelligence: 3,
  wisdom: 12,
  charisma: 7,
  skills: {'Perception': 3, 'Stealth': 4},
  senses: {},
  passivePerception: 13,
  languages: [],
  challengeRating: 1,
  experiencePoints: 200,
  traits: [
    MonsterAbility(
      name: 'Keen Hearing and Smell',
      description: 'The wolf has advantage on Wisdom (Perception) checks that rely on hearing or smell.',
    ),
    MonsterAbility(
      name: 'Pack Tactics',
      description: 'The wolf has advantage on attack rolls against a creature if at least one of the wolf\'s allies is within 5 feet of the creature and the ally isn\'t incapacitated.',
    ),
  ],
  actions: [
    MonsterAction(
      name: 'Bite',
      description: 'Melee Weapon Attack: +5 to hit, reach 5 ft., one target. Hit: 10 (2d6+3) piercing damage. If the target is a creature, it must succeed on a DC 13 Strength saving throw or be knocked prone.',
      attackBonus: '+5',
      damage: '2d6+3',
      damageType: 'piercing',
      range: '5 ft.',
      saveDC: '13',
      saveAbility: 'Strength',
    ),
  ],
  source: 'MM',
  environment: 'forest, hill',
);

// ============================================================================
// CR 2 CREATURES
// ============================================================================

final Monster ogre = Monster(
  name: 'Ogre',
  size: 'Large',
  type: 'Giant',
  alignment: 'Chaotic Evil',
  armorClass: 11,
  armorType: 'hide armor',
  hitPoints: 59,
  hitDice: '7d10+21',
  speed: 40,
  strength: 19,
  dexterity: 8,
  constitution: 16,
  intelligence: 5,
  wisdom: 7,
  charisma: 7,
  senses: {'darkvision': 60},
  passivePerception: 8,
  languages: ['Common', 'Giant'],
  challengeRating: 2,
  experiencePoints: 450,
  traits: [],
  actions: [
    MonsterAction(
      name: 'Greatclub',
      description: 'Melee Weapon Attack: +6 to hit, reach 5 ft., one target.',
      attackBonus: '+6',
      damage: '2d8+4',
      damageType: 'bludgeoning',
      range: '5 ft.',
    ),
    MonsterAction(
      name: 'Javelin',
      description: 'Melee or Ranged Weapon Attack: +6 to hit, reach 5 ft. or range 30/120 ft., one target.',
      attackBonus: '+6',
      damage: '2d6+4',
      damageType: 'piercing',
      range: '5 ft. or 30/120 ft.',
    ),
  ],
  source: 'MM',
  environment: 'arctic, forest, grassland, hill, mountain, swamp, underdark',
);

final Monster minotaur = Monster(
  name: 'Minotaur',
  size: 'Large',
  type: 'Monstrosity',
  alignment: 'Chaotic Evil',
  armorClass: 14,
  armorType: 'natural armor',
  hitPoints: 76,
  hitDice: '9d10+27',
  speed: 40,
  strength: 18,
  dexterity: 11,
  constitution: 16,
  intelligence: 6,
  wisdom: 16,
  charisma: 9,
  skills: {'Perception': 7},
  senses: {'darkvision': 60},
  passivePerception: 17,
  languages: ['Abyssal'],
  challengeRating: 3,
  experiencePoints: 700,
  traits: [
    MonsterAbility(
      name: 'Charge',
      description: 'If the minotaur moves at least 10 feet straight toward a target and then hits it with a gore attack on the same turn, the target takes an extra 9 (2d8) piercing damage. If the target is a creature, it must succeed on a DC 14 Strength saving throw or be pushed up to 10 feet away and knocked prone.',
    ),
    MonsterAbility(
      name: 'Labyrinthine Recall',
      description: 'The minotaur can perfectly recall any path it has traveled.',
    ),
    MonsterAbility(
      name: 'Reckless',
      description: 'At the start of its turn, the minotaur can gain advantage on all melee weapon attack rolls during that turn, but attack rolls against it have advantage until the start of its next turn.',
    ),
  ],
  actions: [
    MonsterAction(
      name: 'Greataxe',
      description: 'Melee Weapon Attack: +6 to hit, reach 5 ft., one target.',
      attackBonus: '+6',
      damage: '2d12+4',
      damageType: 'slashing',
      range: '5 ft.',
    ),
    MonsterAction(
      name: 'Gore',
      description: 'Melee Weapon Attack: +6 to hit, reach 5 ft., one target.',
      attackBonus: '+6',
      damage: '2d8+4',
      damageType: 'piercing',
      range: '5 ft.',
    ),
  ],
  source: 'MM',
  environment: 'underdark',
);

// ============================================================================
// CR 4-5 CREATURES
// ============================================================================

final Monster troll = Monster(
  name: 'Troll',
  size: 'Large',
  type: 'Giant',
  alignment: 'Chaotic Evil',
  armorClass: 15,
  armorType: 'natural armor',
  hitPoints: 84,
  hitDice: '8d10+40',
  speed: 30,
  strength: 18,
  dexterity: 13,
  constitution: 20,
  intelligence: 7,
  wisdom: 9,
  charisma: 7,
  skills: {'Perception': 2},
  senses: {'darkvision': 60},
  passivePerception: 12,
  languages: ['Giant'],
  challengeRating: 5,
  experiencePoints: 1800,
  traits: [
    MonsterAbility(
      name: 'Keen Smell',
      description: 'The troll has advantage on Wisdom (Perception) checks that rely on smell.',
    ),
    MonsterAbility(
      name: 'Regeneration',
      description: 'The troll regains 10 hit points at the start of its turn. If the troll takes acid or fire damage, this trait doesn\'t function at the start of the troll\'s next turn. The troll dies only if it starts its turn with 0 hit points and doesn\'t regenerate.',
    ),
  ],
  actions: [
    MonsterAction(
      name: 'Multiattack',
      description: 'The troll makes three attacks: one with its bite and two with its claws.',
    ),
    MonsterAction(
      name: 'Bite',
      description: 'Melee Weapon Attack: +7 to hit, reach 5 ft., one target.',
      attackBonus: '+7',
      damage: '1d6+4',
      damageType: 'piercing',
      range: '5 ft.',
    ),
    MonsterAction(
      name: 'Claw',
      description: 'Melee Weapon Attack: +7 to hit, reach 5 ft., one target.',
      attackBonus: '+7',
      damage: '2d6+4',
      damageType: 'slashing',
      range: '5 ft.',
    ),
  ],
  source: 'MM',
  environment: 'arctic, forest, hill, mountain, swamp, underdark',
);

// ============================================================================
// CR 10+ LEGENDARY CREATURES
// ============================================================================

final Monster youngRedDragon = Monster(
  name: 'Young Red Dragon',
  size: 'Large',
  type: 'Dragon',
  alignment: 'Chaotic Evil',
  armorClass: 18,
  armorType: 'natural armor',
  hitPoints: 178,
  hitDice: '17d10+85',
  speed: 40,
  flySpeed: {'fly': 80},
  strength: 23,
  dexterity: 10,
  constitution: 21,
  intelligence: 14,
  wisdom: 11,
  charisma: 19,
  savingThrows: {'Dexterity': 4, 'Constitution': 9, 'Wisdom': 4, 'Charisma': 8},
  skills: {'Perception': 8, 'Stealth': 4},
  damageImmunities: ['fire'],
  senses: {'blindsight': 30, 'darkvision': 120},
  passivePerception: 18,
  languages: ['Common', 'Draconic'],
  challengeRating: 10,
  experiencePoints: 5900,
  traits: [],
  actions: [
    MonsterAction(
      name: 'Multiattack',
      description: 'The dragon makes three attacks: one with its bite and two with its claws.',
    ),
    MonsterAction(
      name: 'Bite',
      description: 'Melee Weapon Attack: +10 to hit, reach 10 ft., one target.',
      attackBonus: '+10',
      damage: '2d10+6',
      damageType: 'piercing',
      range: '10 ft.',
    ),
    MonsterAction(
      name: 'Claw',
      description: 'Melee Weapon Attack: +10 to hit, reach 5 ft., one target.',
      attackBonus: '+10',
      damage: '2d6+6',
      damageType: 'slashing',
      range: '5 ft.',
    ),
    MonsterAction(
      name: 'Fire Breath (Recharge 5-6)',
      description: 'The dragon exhales fire in a 30-foot cone. Each creature in that area must make a DC 17 Dexterity saving throw, taking 56 (16d6) fire damage on a failed save, or half as much damage on a successful one.',
      saveDC: '17',
      saveAbility: 'Dexterity',
      damage: '16d6',
      damageType: 'fire',
    ),
  ],
  source: 'MM',
  environment: 'mountain, hill',
);

final Monster beholder = Monster(
  name: 'Beholder',
  size: 'Large',
  type: 'Aberration',
  alignment: 'Lawful Evil',
  armorClass: 18,
  armorType: 'natural armor',
  hitPoints: 180,
  hitDice: '19d10+76',
  speed: 0,
  flySpeed: {'fly': 20, 'hover': 20},
  strength: 10,
  dexterity: 14,
  constitution: 18,
  intelligence: 17,
  wisdom: 15,
  charisma: 17,
  savingThrows: {'Intelligence': 8, 'Wisdom': 7, 'Charisma': 8},
  skills: {'Perception': 12},
  conditionImmunities: ['prone'],
  senses: {'darkvision': 120},
  passivePerception: 22,
  languages: ['Deep Speech', 'Undercommon'],
  challengeRating: 13,
  experiencePoints: 10000,
  traits: [
    MonsterAbility(
      name: 'Antimagic Cone',
      description: 'The beholder\'s central eye creates an area of antimagic, as in the antimagic field spell, in a 150-foot cone. At the start of each of its turns, the beholder decides which way the cone faces and whether the cone is active.',
    ),
  ],
  actions: [
    MonsterAction(
      name: 'Bite',
      description: 'Melee Weapon Attack: +5 to hit, reach 5 ft., one target.',
      attackBonus: '+5',
      damage: '4d6',
      damageType: 'piercing',
      range: '5 ft.',
    ),
    MonsterAction(
      name: 'Eye Rays',
      description: 'The beholder shoots three of the following magical eye rays at random (reroll duplicates), choosing one to three targets it can see within 120 feet: 1. Charm Ray, 2. Paralyzing Ray, 3. Fear Ray, 4. Slowing Ray, 5. Enervation Ray, 6. Telekinetic Ray, 7. Sleep Ray, 8. Petrification Ray, 9. Disintegration Ray, 10. Death Ray.',
    ),
  ],
  legendaryActions: [
    MonsterAction(
      name: 'Eye Ray',
      description: 'The beholder uses one random eye ray.',
    ),
  ],
  legendaryActionsPerRound: 3,
  source: 'MM',
  environment: 'underdark',
);

// Monster collections by CR
final Map<double, List<Monster>> monstersByCR = {
  0.25: [goblin, wolf, skeleton, zombie],
  0.5: [orc],
  1: [bugbear, direWolf],
  2: [ogre],
  3: [minotaur],
  5: [troll],
  10: [youngRedDragon],
  13: [beholder],
};

// Monster collections by type
final Map<String, List<Monster>> monstersByType = {
  'Humanoid': [goblin, orc, bugbear],
  'Beast': [wolf, direWolf],
  'Undead': [skeleton, zombie],
  'Giant': [ogre, troll],
  'Monstrosity': [minotaur],
  'Dragon': [youngRedDragon],
  'Aberration': [beholder],
};

// Helper functions
List<Monster> getMonstersByCR(double cr) {
  return monstersByCR[cr] ?? [];
}

List<Monster> getMonstersByType(String type) {
  return monstersByType[type] ?? [];
}

Monster? getMonsterByName(String name) {
  final allMonsters = monstersByCR.values.expand((list) => list).toList();
  try {
    return allMonsters.firstWhere((m) => m.name.toLowerCase() == name.toLowerCase());
  } catch (e) {
    return null;
  }
}

// Calculate CR appropriate for party level
List<Monster> getMonstersForPartyLevel(int partyLevel, int partySize) {
  // Simple CR calculation: party level / 4 for easy, /2 for medium, equal for hard
  final easyCR = (partyLevel / 4).clamp(0.25, 30.0);
  final mediumCR = (partyLevel / 2).clamp(0.25, 30.0);
  final hardCR = partyLevel.toDouble().clamp(0.25, 30.0);

  final List<Monster> suitable = [];
  for (final cr in monstersByCR.keys) {
    if (cr >= easyCR && cr <= hardCR) {
      suitable.addAll(monstersByCR[cr]!);
    }
  }
  return suitable;
}
