class Monster {
  String id;
  String name;
  String size; // "Tiny", "Small", "Medium", "Large", "Huge", "Gargantuan"
  String type; // "Beast", "Humanoid", "Undead", "Dragon", etc.
  String alignment;
  double challengeRating; // 0.125, 0.25, 0.5, 1, 2, etc.
  int experiencePoints;

  // Stats
  int armorClass;
  int hitPoints;
  String hitDice; // e.g., "2d8+2"
  int speed;

  // Ability Scores
  int strength;
  int dexterity;
  int constitution;
  int intelligence;
  int wisdom;
  int charisma;

  // Calculated modifiers
  int get strengthMod => (strength - 10) ~/ 2;
  int get dexterityMod => (dexterity - 10) ~/ 2;
  int get constitutionMod => (constitution - 10) ~/ 2;
  int get intelligenceMod => (intelligence - 10) ~/ 2;
  int get wisdomMod => (wisdom - 10) ~/ 2;
  int get charismaMod => (charisma - 10) ~/ 2;

  // Saving Throws (optional - only if proficient)
  Map<String, int>? savingThrows;

  // Skills
  Map<String, int>? skills;

  // Resistances and immunities
  List<String>? damageResistances;
  List<String>? damageImmunities;
  List<String>? damageVulnerabilities;
  List<String>? conditionImmunities;

  // Senses
  int? darkvision;
  int? blindsight;
  int? tremorsense;
  int? truesight;
  int passivePerception;

  // Languages
  List<String> languages;

  // Special Traits
  List<MonsterTrait>? traits;

  // Actions
  List<MonsterAction> actions;

  // Legendary Actions (for powerful monsters)
  int? legendaryActionsPerRound;
  List<MonsterAction>? legendaryActions;

  // Reactions
  List<MonsterAction>? reactions;

  // Lair Actions (for some bosses)
  List<MonsterAction>? lairActions;

  Monster({
    required this.id,
    required this.name,
    required this.size,
    required this.type,
    required this.alignment,
    required this.challengeRating,
    required this.experiencePoints,
    required this.armorClass,
    required this.hitPoints,
    required this.hitDice,
    required this.speed,
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
    this.darkvision,
    this.blindsight,
    this.tremorsense,
    this.truesight,
    required this.passivePerception,
    required this.languages,
    this.traits,
    required this.actions,
    this.legendaryActionsPerRound,
    this.legendaryActions,
    this.reactions,
    this.lairActions,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'size': size,
    'type': type,
    'alignment': alignment,
    'challengeRating': challengeRating,
    'experiencePoints': experiencePoints,
    'armorClass': armorClass,
    'hitPoints': hitPoints,
    'hitDice': hitDice,
    'speed': speed,
    'strength': strength,
    'dexterity': dexterity,
    'constitution': constitution,
    'intelligence': intelligence,
    'wisdom': wisdom,
    'charisma': charisma,
    'savingThrows': savingThrows,
    'skills': skills,
    'damageResistances': damageResistances,
    'damageImmunities': damageImmunities,
    'damageVulnerabilities': damageVulnerabilities,
    'conditionImmunities': conditionImmunities,
    'darkvision': darkvision,
    'blindsight': blindsight,
    'tremorsense': tremorsense,
    'truesight': truesight,
    'passivePerception': passivePerception,
    'languages': languages,
    'traits': traits?.map((t) => t.toJson()).toList(),
    'actions': actions.map((a) => a.toJson()).toList(),
    'legendaryActionsPerRound': legendaryActionsPerRound,
    'legendaryActions': legendaryActions?.map((a) => a.toJson()).toList(),
    'reactions': reactions?.map((a) => a.toJson()).toList(),
    'lairActions': lairActions?.map((a) => a.toJson()).toList(),
  };

  factory Monster.fromJson(Map<String, dynamic> json) => Monster(
    id: json['id'] as String,
    name: json['name'] as String,
    size: json['size'] as String,
    type: json['type'] as String,
    alignment: json['alignment'] as String,
    challengeRating: (json['challengeRating'] as num).toDouble(),
    experiencePoints: json['experiencePoints'] as int,
    armorClass: json['armorClass'] as int,
    hitPoints: json['hitPoints'] as int,
    hitDice: json['hitDice'] as String,
    speed: json['speed'] as int,
    strength: json['strength'] as int,
    dexterity: json['dexterity'] as int,
    constitution: json['constitution'] as int,
    intelligence: json['intelligence'] as int,
    wisdom: json['wisdom'] as int,
    charisma: json['charisma'] as int,
    savingThrows: (json['savingThrows'] as Map<String, dynamic>?)?.cast<String, int>(),
    skills: (json['skills'] as Map<String, dynamic>?)?.cast<String, int>(),
    damageResistances: (json['damageResistances'] as List<dynamic>?)?.cast<String>(),
    damageImmunities: (json['damageImmunities'] as List<dynamic>?)?.cast<String>(),
    damageVulnerabilities: (json['damageVulnerabilities'] as List<dynamic>?)?.cast<String>(),
    conditionImmunities: (json['conditionImmunities'] as List<dynamic>?)?.cast<String>(),
    darkvision: json['darkvision'] as int?,
    blindsight: json['blindsight'] as int?,
    tremorsense: json['tremorsense'] as int?,
    truesight: json['truesight'] as int?,
    passivePerception: json['passivePerception'] as int,
    languages: (json['languages'] as List<dynamic>).cast<String>(),
    traits: (json['traits'] as List<dynamic>?)
        ?.map((t) => MonsterTrait.fromJson(t as Map<String, dynamic>))
        .toList(),
    actions: (json['actions'] as List<dynamic>)
        .map((a) => MonsterAction.fromJson(a as Map<String, dynamic>))
        .toList(),
    legendaryActionsPerRound: json['legendaryActionsPerRound'] as int?,
    legendaryActions: (json['legendaryActions'] as List<dynamic>?)
        ?.map((a) => MonsterAction.fromJson(a as Map<String, dynamic>))
        .toList(),
    reactions: (json['reactions'] as List<dynamic>?)
        ?.map((a) => MonsterAction.fromJson(a as Map<String, dynamic>))
        .toList(),
    lairActions: (json['lairActions'] as List<dynamic>?)
        ?.map((a) => MonsterAction.fromJson(a as Map<String, dynamic>))
        .toList(),
  );
}

class MonsterTrait {
  String name;
  String description;

  MonsterTrait({
    required this.name,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
  };

  factory MonsterTrait.fromJson(Map<String, dynamic> json) => MonsterTrait(
    name: json['name'] as String,
    description: json['description'] as String,
  );
}

class MonsterAction {
  String name;
  String description;
  int? attackBonus; // For attack actions
  String? damage; // e.g., "1d6+2"
  String? damageType;
  String? saveDC; // For saving throw based actions
  String? saveAbility; // "Dexterity", "Wisdom", etc.
  int? uses; // Limited use actions
  String? recharge; // "5-6", "6", "Short Rest", "Long Rest"

  MonsterAction({
    required this.name,
    required this.description,
    this.attackBonus,
    this.damage,
    this.damageType,
    this.saveDC,
    this.saveAbility,
    this.uses,
    this.recharge,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'attackBonus': attackBonus,
    'damage': damage,
    'damageType': damageType,
    'saveDC': saveDC,
    'saveAbility': saveAbility,
    'uses': uses,
    'recharge': recharge,
  };

  factory MonsterAction.fromJson(Map<String, dynamic> json) => MonsterAction(
    name: json['name'] as String,
    description: json['description'] as String,
    attackBonus: json['attackBonus'] as int?,
    damage: json['damage'] as String?,
    damageType: json['damageType'] as String?,
    saveDC: json['saveDC'] as String?,
    saveAbility: json['saveAbility'] as String?,
    uses: json['uses'] as int?,
    recharge: json['recharge'] as String?,
  );
}

// Monster database
class Monsters {
  static Monster goblin() => Monster(
    id: 'goblin',
    name: 'Goblin',
    size: 'Small',
    type: 'Humanoid',
    alignment: 'Neutral Evil',
    challengeRating: 0.25,
    experiencePoints: 50,
    armorClass: 15,
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
    darkvision: 60,
    passivePerception: 9,
    languages: ['Common', 'Goblin'],
    traits: [
      MonsterTrait(
        name: 'Nimble Escape',
        description: 'The goblin can take the Disengage or Hide action as a bonus action on each of its turns.',
      ),
    ],
    actions: [
      MonsterAction(
        name: 'Scimitar',
        description: 'Melee Weapon Attack',
        attackBonus: 4,
        damage: '1d6+2',
        damageType: 'slashing',
      ),
      MonsterAction(
        name: 'Shortbow',
        description: 'Ranged Weapon Attack',
        attackBonus: 4,
        damage: '1d6+2',
        damageType: 'piercing',
      ),
    ],
  );

  static Monster orc() => Monster(
    id: 'orc',
    name: 'Orc',
    size: 'Medium',
    type: 'Humanoid',
    alignment: 'Chaotic Evil',
    challengeRating: 0.5,
    experiencePoints: 100,
    armorClass: 13,
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
    darkvision: 60,
    passivePerception: 10,
    languages: ['Common', 'Orc'],
    traits: [
      MonsterTrait(
        name: 'Aggressive',
        description: 'As a bonus action, the orc can move up to its speed toward a hostile creature it can see.',
      ),
    ],
    actions: [
      MonsterAction(
        name: 'Greataxe',
        description: 'Melee Weapon Attack',
        attackBonus: 5,
        damage: '1d12+3',
        damageType: 'slashing',
      ),
      MonsterAction(
        name: 'Javelin',
        description: 'Melee or Ranged Weapon Attack',
        attackBonus: 5,
        damage: '1d6+3',
        damageType: 'piercing',
      ),
    ],
  );

  static Monster skeleton() => Monster(
    id: 'skeleton',
    name: 'Skeleton',
    size: 'Medium',
    type: 'Undead',
    alignment: 'Lawful Evil',
    challengeRating: 0.25,
    experiencePoints: 50,
    armorClass: 13,
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
    darkvision: 60,
    passivePerception: 9,
    languages: ['Understands all languages it spoke in life but can\'t speak'],
    actions: [
      MonsterAction(
        name: 'Shortsword',
        description: 'Melee Weapon Attack',
        attackBonus: 4,
        damage: '1d6+2',
        damageType: 'piercing',
      ),
      MonsterAction(
        name: 'Shortbow',
        description: 'Ranged Weapon Attack',
        attackBonus: 4,
        damage: '1d6+2',
        damageType: 'piercing',
      ),
    ],
  );

  static Monster zombie() => Monster(
    id: 'zombie',
    name: 'Zombie',
    size: 'Medium',
    type: 'Undead',
    alignment: 'Neutral Evil',
    challengeRating: 0.25,
    experiencePoints: 50,
    armorClass: 8,
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
    darkvision: 60,
    passivePerception: 8,
    languages: ['Understands languages it spoke in life but can\'t speak'],
    traits: [
      MonsterTrait(
        name: 'Undead Fortitude',
        description: 'If damage reduces the zombie to 0 hit points, it must make a Constitution saving throw with a DC of 5 + the damage taken, unless the damage is radiant or from a critical hit. On a success, the zombie drops to 1 hit point instead.',
      ),
    ],
    actions: [
      MonsterAction(
        name: 'Slam',
        description: 'Melee Weapon Attack',
        attackBonus: 3,
        damage: '1d6+1',
        damageType: 'bludgeoning',
      ),
    ],
  );

  static Monster wolf() => Monster(
    id: 'wolf',
    name: 'Wolf',
    size: 'Medium',
    type: 'Beast',
    alignment: 'Unaligned',
    challengeRating: 0.25,
    experiencePoints: 50,
    armorClass: 13,
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
    passivePerception: 13,
    languages: [],
    traits: [
      MonsterTrait(
        name: 'Keen Hearing and Smell',
        description: 'The wolf has advantage on Wisdom (Perception) checks that rely on hearing or smell.',
      ),
      MonsterTrait(
        name: 'Pack Tactics',
        description: 'The wolf has advantage on attack rolls against a creature if at least one of the wolf\'s allies is within 5 feet of the creature and the ally isn\'t incapacitated.',
      ),
    ],
    actions: [
      MonsterAction(
        name: 'Bite',
        description: 'Melee Weapon Attack',
        attackBonus: 4,
        damage: '2d4+2',
        damageType: 'piercing',
      ),
    ],
  );

  static Monster direwolf() => Monster(
    id: 'direwolf',
    name: 'Dire Wolf',
    size: 'Large',
    type: 'Beast',
    alignment: 'Unaligned',
    challengeRating: 1,
    experiencePoints: 200,
    armorClass: 14,
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
    passivePerception: 13,
    languages: [],
    traits: [
      MonsterTrait(
        name: 'Keen Hearing and Smell',
        description: 'The wolf has advantage on Wisdom (Perception) checks that rely on hearing or smell.',
      ),
      MonsterTrait(
        name: 'Pack Tactics',
        description: 'The wolf has advantage on attack rolls against a creature if at least one of the wolf\'s allies is within 5 feet of the creature and the ally isn\'t incapacitated.',
      ),
    ],
    actions: [
      MonsterAction(
        name: 'Bite',
        description: 'Melee Weapon Attack. If the target is a creature, it must succeed on a DC 13 Strength saving throw or be knocked prone.',
        attackBonus: 5,
        damage: '2d6+3',
        damageType: 'piercing',
      ),
    ],
  );

  static Monster ogre() => Monster(
    id: 'ogre',
    name: 'Ogre',
    size: 'Large',
    type: 'Giant',
    alignment: 'Chaotic Evil',
    challengeRating: 2,
    experiencePoints: 450,
    armorClass: 11,
    hitPoints: 59,
    hitDice: '7d10+21',
    speed: 40,
    strength: 19,
    dexterity: 8,
    constitution: 16,
    intelligence: 5,
    wisdom: 7,
    charisma: 7,
    darkvision: 60,
    passivePerception: 8,
    languages: ['Common', 'Giant'],
    actions: [
      MonsterAction(
        name: 'Greatclub',
        description: 'Melee Weapon Attack',
        attackBonus: 6,
        damage: '2d8+4',
        damageType: 'bludgeoning',
      ),
      MonsterAction(
        name: 'Javelin',
        description: 'Melee or Ranged Weapon Attack',
        attackBonus: 6,
        damage: '2d6+4',
        damageType: 'piercing',
      ),
    ],
  );

  static Monster troll() => Monster(
    id: 'troll',
    name: 'Troll',
    size: 'Large',
    type: 'Giant',
    alignment: 'Chaotic Evil',
    challengeRating: 5,
    experiencePoints: 1800,
    armorClass: 15,
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
    darkvision: 60,
    passivePerception: 12,
    languages: ['Giant'],
    traits: [
      MonsterTrait(
        name: 'Keen Smell',
        description: 'The troll has advantage on Wisdom (Perception) checks that rely on smell.',
      ),
      MonsterTrait(
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
        description: 'Melee Weapon Attack',
        attackBonus: 7,
        damage: '1d6+4',
        damageType: 'piercing',
      ),
      MonsterAction(
        name: 'Claw',
        description: 'Melee Weapon Attack',
        attackBonus: 7,
        damage: '2d6+4',
        damageType: 'slashing',
      ),
    ],
  );

  static Monster youngRedDragon() => Monster(
    id: 'young_red_dragon',
    name: 'Young Red Dragon',
    size: 'Large',
    type: 'Dragon',
    alignment: 'Chaotic Evil',
    challengeRating: 10,
    experiencePoints: 5900,
    armorClass: 18,
    hitPoints: 178,
    hitDice: '17d10+85',
    speed: 40, // also has fly 80, climb 40
    strength: 23,
    dexterity: 10,
    constitution: 21,
    intelligence: 14,
    wisdom: 11,
    charisma: 19,
    savingThrows: {'Dexterity': 4, 'Constitution': 9, 'Wisdom': 4, 'Charisma': 8},
    skills: {'Perception': 8, 'Stealth': 4},
    damageImmunities: ['fire'],
    blindsight: 30,
    darkvision: 120,
    passivePerception: 18,
    languages: ['Common', 'Draconic'],
    actions: [
      MonsterAction(
        name: 'Multiattack',
        description: 'The dragon makes three attacks: one with its bite and two with its claws.',
      ),
      MonsterAction(
        name: 'Bite',
        description: 'Melee Weapon Attack',
        attackBonus: 10,
        damage: '2d10+6',
        damageType: 'piercing',
      ),
      MonsterAction(
        name: 'Claw',
        description: 'Melee Weapon Attack',
        attackBonus: 10,
        damage: '2d6+6',
        damageType: 'slashing',
      ),
      MonsterAction(
        name: 'Fire Breath',
        description: 'The dragon exhales fire in a 30-foot cone. Each creature in that area must make a DC 17 Dexterity saving throw, taking 56 (16d6) fire damage on a failed save, or half as much on a successful one.',
        recharge: '5-6',
      ),
    ],
  );

  static List<Monster> getAllMonsters() {
    return [
      goblin(),
      orc(),
      skeleton(),
      zombie(),
      wolf(),
      direwolf(),
      ogre(),
      troll(),
      youngRedDragon(),
    ];
  }

  static Monster getRandomMonsterByCR(double minCR, double maxCR) {
    List<Monster> allMonsters = getAllMonsters();
    List<Monster> filtered = allMonsters
        .where((m) => m.challengeRating >= minCR && m.challengeRating <= maxCR)
        .toList();

    if (filtered.isEmpty) return goblin(); // Default fallback

    filtered.shuffle();
    return filtered.first;
  }
}
