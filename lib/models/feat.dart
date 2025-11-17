class Feat {
  String id;
  String name;
  String description;
  List<String>? prerequisites; // e.g., ["Strength 13+", "Proficiency with heavy armor"]
  Map<String, int>? abilityIncreases; // e.g., {"Strength": 1}
  List<String>? newProficiencies;
  String? specialEffect; // For programmatic effects

  Feat({
    required this.id,
    required this.name,
    required this.description,
    this.prerequisites,
    this.abilityIncreases,
    this.newProficiencies,
    this.specialEffect,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'prerequisites': prerequisites,
    'abilityIncreases': abilityIncreases,
    'newProficiencies': newProficiencies,
    'specialEffect': specialEffect,
  };

  factory Feat.fromJson(Map<String, dynamic> json) => Feat(
    id: json['id'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
    prerequisites: (json['prerequisites'] as List<dynamic>?)?.cast<String>(),
    abilityIncreases: (json['abilityIncreases'] as Map<String, dynamic>?)?.cast<String, int>(),
    newProficiencies: (json['newProficiencies'] as List<dynamic>?)?.cast<String>(),
    specialEffect: json['specialEffect'] as String?,
  );
}

class Feats {
  static Feat greatWeaponMaster() => Feat(
    id: 'great_weapon_master',
    name: 'Great Weapon Master',
    description: 'You\'ve learned to put the weight of a weapon to your advantage. On your turn, when you score a critical hit or reduce a creature to 0 HP with a melee weapon, you can make one melee weapon attack as a bonus action. Before you make a melee attack with a heavy weapon, you can choose to take a -5 penalty to the attack roll. If the attack hits, you add +10 to the attack\'s damage.',
    specialEffect: 'gwm',
  );

  static Feat sharpshooter() => Feat(
    id: 'sharpshooter',
    name: 'Sharpshooter',
    description: 'You have mastered ranged weapons. Attacking at long range doesn\'t impose disadvantage. Your ranged weapon attacks ignore half and three-quarters cover. Before you make an attack with a ranged weapon, you can take a -5 penalty to the attack roll. If it hits, you add +10 to the damage.',
    specialEffect: 'sharpshooter',
  );

  static Feat warCaster() => Feat(
    id: 'war_caster',
    name: 'War Caster',
    description: 'You have advantage on Constitution saving throws to maintain concentration. You can perform somatic components even when wielding weapons or a shield. When a hostile creature provokes an opportunity attack, you can cast a spell instead of making an attack.',
    prerequisites: ['Ability to cast at least one spell'],
    specialEffect: 'war_caster',
  );

  static Feat lucky() => Feat(
    id: 'lucky',
    name: 'Lucky',
    description: 'You have 3 luck points. Whenever you make an attack roll, ability check, or saving throw, you can spend one luck point to roll an additional d20. You can use this after the original roll but before the outcome. You can also spend a luck point when an attack is made against you to roll a d20, and the attacker must use your roll. You regain expended luck points after a long rest.',
    specialEffect: 'lucky',
  );

  static Feat sentinel() => Feat(
    id: 'sentinel',
    name: 'Sentinel',
    description: 'When you hit a creature with an opportunity attack, its speed becomes 0 for the rest of the turn. Creatures provoke opportunity attacks even if they take the Disengage action. When a creature within 5 feet makes an attack against a target other than you, you can use your reaction to make a melee weapon attack against the attacking creature.',
    specialEffect: 'sentinel',
  );

  static Feat polearmMaster() => Feat(
    id: 'polearm_master',
    name: 'Polearm Master',
    description: 'When you take the Attack action with a glaive, halberd, or quarterstaff, you can use a bonus action to make a melee attack with the opposite end (1d4 bludgeoning). While wielding such weapons, you can use a reaction to make an opportunity attack when a creature enters your reach.',
    specialEffect: 'polearm_master',
  );

  static Feat alertness() => Feat(
    id: 'alert',
    name: 'Alert',
    description: 'You gain a +5 bonus to initiative. You can\'t be surprised while conscious. Other creatures don\'t gain advantage on attack rolls against you as a result of being unseen.',
    specialEffect: 'alert',
  );

  static Feat athlete() => Feat(
    id: 'athlete',
    name: 'Athlete',
    description: 'Increase your Strength or Dexterity by 1. When prone, standing up uses only 5 feet of movement. Climbing doesn\'t halve your speed. You can make a running long jump or high jump after moving only 5 feet.',
    abilityIncreases: {'Strength or Dexterity': 1},
    specialEffect: 'athlete',
  );

  static Feat dualWielder() => Feat(
    id: 'dual_wielder',
    name: 'Dual Wielder',
    description: 'You gain +1 AC while wielding a separate melee weapon in each hand. You can use two-weapon fighting even when the weapons aren\'t light. You can draw or stow two one-handed weapons when you would normally draw or stow one.',
    specialEffect: 'dual_wielder',
  );

  static Feat heavyArmorMaster() => Feat(
    id: 'heavy_armor_master',
    name: 'Heavy Armor Master',
    description: 'Increase your Strength by 1. While wearing heavy armor, you reduce bludgeoning, piercing, and slashing damage by 3.',
    prerequisites: ['Proficiency with heavy armor'],
    abilityIncreases: {'Strength': 1},
    specialEffect: 'heavy_armor_master',
  );

  static Feat mobileGun() => Feat(
    id: 'mobile',
    name: 'Mobile',
    description: 'Your speed increases by 10 feet. When you use the Dash action, difficult terrain doesn\'t cost extra movement. When you make a melee attack against a creature, you don\'t provoke opportunity attacks from that creature for the rest of the turn.',
    specialEffect: 'mobile',
  );

  static Feat resilient() => Feat(
    id: 'resilient',
    name: 'Resilient',
    description: 'Increase one ability score by 1. You gain proficiency in saving throws using the chosen ability.',
    abilityIncreases: {'Any': 1},
    specialEffect: 'resilient',
  );

  static Feat ritualCaster() => Feat(
    id: 'ritual_caster',
    name: 'Ritual Caster',
    description: 'You learn two 1st-level spells with the ritual tag from one class. You can cast these as rituals. You can add more ritual spells to your ritual book as you find them.',
    prerequisites: ['Intelligence or Wisdom 13+'],
    specialEffect: 'ritual_caster',
  );

  static Feat magicInitiate() => Feat(
    id: 'magic_initiate',
    name: 'Magic Initiate',
    description: 'Choose a class. You learn two cantrips and one 1st-level spell from that class\'s spell list. You can cast the spell once per long rest without using a spell slot.',
    specialEffect: 'magic_initiate',
  );

  static Feat toughness() => Feat(
    id: 'toughness',
    name: 'Toughness',
    description: 'Your hit point maximum increases by an amount equal to twice your level, and it increases by 2 every time you gain a level.',
    specialEffect: 'toughness',
  );

  static List<Feat> getAllFeats() {
    return [
      greatWeaponMaster(),
      sharpshooter(),
      warCaster(),
      lucky(),
      sentinel(),
      polearmMaster(),
      alertness(),
      athlete(),
      dualWielder(),
      heavyArmorMaster(),
      mobileGun(),
      resilient(),
      ritualCaster(),
      magicInitiate(),
      toughness(),
    ];
  }
}
