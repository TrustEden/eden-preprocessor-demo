import '../models/monster.dart';

/// Comprehensive D&D 5e Monster Database - 50+ Creatures
class ExpandedMonsterDatabase {
  // ==================== CR 0 - CR 1/4 ====================

  static Monster rat() => Monster(
    id: 'rat', name: 'Rat', size: 'Tiny', type: 'Beast', alignment: 'Unaligned',
    challengeRating: 0, experiencePoints: 10,
    armorClass: 10, hitPoints: 1, hitDice: '1d4-1', speed: 20,
    strength: 2, dexterity: 11, constitution: 9, intelligence: 2, wisdom: 10, charisma: 4,
    darkvision: 30, passivePerception: 10, languages: [],
    traits: [MonsterTrait(name: 'Keen Smell', description: 'Advantage on Wisdom (Perception) checks that rely on smell.')],
    actions: [MonsterAction(name: 'Bite', description: 'Melee Weapon Attack', attackBonus: 0, damage: '1', damageType: 'piercing')],
  );

  static Monster cat() => Monster(
    id: 'cat', name: 'Cat', size: 'Tiny', type: 'Beast', alignment: 'Unaligned',
    challengeRating: 0, experiencePoints: 10,
    armorClass: 12, hitPoints: 2, hitDice: '1d4', speed: 40,
    strength: 3, dexterity: 15, constitution: 10, intelligence: 3, wisdom: 12, charisma: 7,
    passivePerception: 13, languages: [],
    traits: [MonsterTrait(name: 'Keen Smell', description: 'Advantage on Wisdom (Perception) checks that rely on smell.')],
    actions: [MonsterAction(name: 'Claws', description: 'Melee Weapon Attack', attackBonus: 0, damage: '1', damageType: 'slashing')],
  );

  static Monster goblin() => Monster(
    id: 'goblin', name: 'Goblin', size: 'Small', type: 'Humanoid', alignment: 'Neutral Evil',
    challengeRating: 0.25, experiencePoints: 50,
    armorClass: 15, hitPoints: 7, hitDice: '2d6', speed: 30,
    strength: 8, dexterity: 14, constitution: 10, intelligence: 10, wisdom: 8, charisma: 8,
    skills: {'Stealth': 6}, darkvision: 60, passivePerception: 9, languages: ['Common', 'Goblin'],
    traits: [MonsterTrait(name: 'Nimble Escape', description: 'Can Disengage or Hide as bonus action.')],
    actions: [
      MonsterAction(name: 'Scimitar', description: 'Melee Weapon Attack', attackBonus: 4, damage: '1d6+2', damageType: 'slashing'),
      MonsterAction(name: 'Shortbow', description: 'Ranged Weapon Attack', attackBonus: 4, damage: '1d6+2', damageType: 'piercing'),
    ],
  );

  static Monster kobold() => Monster(
    id: 'kobold', name: 'Kobold', size: 'Small', type: 'Humanoid', alignment: 'Lawful Evil',
    challengeRating: 0.125, experiencePoints: 25,
    armorClass: 12, hitPoints: 5, hitDice: '2d6-2', speed: 30,
    strength: 7, dexterity: 15, constitution: 9, intelligence: 8, wisdom: 7, charisma: 8,
    darkvision: 60, passivePerception: 8, languages: ['Common', 'Draconic'],
    traits: [
      MonsterTrait(name: 'Sunlight Sensitivity', description: 'Disadvantage on attacks and Perception in sunlight.'),
      MonsterTrait(name: 'Pack Tactics', description: 'Advantage on attacks if ally within 5 feet of target.'),
    ],
    actions: [
      MonsterAction(name: 'Dagger', description: 'Melee Weapon Attack', attackBonus: 4, damage: '1d4+2', damageType: 'piercing'),
      MonsterAction(name: 'Sling', description: 'Ranged Weapon Attack', attackBonus: 4, damage: '1d4+2', damageType: 'bludgeoning'),
    ],
  );

  static Monster skeleton() => Monster(
    id: 'skeleton', name: 'Skeleton', size: 'Medium', type: 'Undead', alignment: 'Lawful Evil',
    challengeRating: 0.25, experiencePoints: 50,
    armorClass: 13, hitPoints: 13, hitDice: '2d8+4', speed: 30,
    strength: 10, dexterity: 14, constitution: 15, intelligence: 6, wisdom: 8, charisma: 5,
    damageVulnerabilities: ['bludgeoning'], damageImmunities: ['poison'],
    conditionImmunities: ['exhaustion', 'poisoned'],
    darkvision: 60, passivePerception: 9, languages: ['Understands all it spoke in life but can\'t speak'],
    actions: [
      MonsterAction(name: 'Shortsword', description: 'Melee Weapon Attack', attackBonus: 4, damage: '1d6+2', damageType: 'piercing'),
      MonsterAction(name: 'Shortbow', description: 'Ranged Weapon Attack', attackBonus: 4, damage: '1d6+2', damageType: 'piercing'),
    ],
  );

  static Monster zombie() => Monster(
    id: 'zombie', name: 'Zombie', size: 'Medium', type: 'Undead', alignment: 'Neutral Evil',
    challengeRating: 0.25, experiencePoints: 50,
    armorClass: 8, hitPoints: 22, hitDice: '3d8+9', speed: 20,
    strength: 13, dexterity: 6, constitution: 16, intelligence: 3, wisdom: 6, charisma: 5,
    savingThrows: {'Wisdom': 0}, damageImmunities: ['poison'], conditionImmunities: ['poisoned'],
    darkvision: 60, passivePerception: 8, languages: ['Understands languages it spoke in life but can\'t speak'],
    traits: [MonsterTrait(name: 'Undead Fortitude', description: 'If damage reduces to 0 HP, make Constitution save (DC 5 + damage) or drop to 1 HP instead.')],
    actions: [MonsterAction(name: 'Slam', description: 'Melee Weapon Attack', attackBonus: 3, damage: '1d6+1', damageType: 'bludgeoning')],
  );

  static Monster giantRat() => Monster(
    id: 'giant_rat', name: 'Giant Rat', size: 'Small', type: 'Beast', alignment: 'Unaligned',
    challengeRating: 0.125, experiencePoints: 25,
    armorClass: 12, hitPoints: 7, hitDice: '2d6', speed: 30,
    strength: 7, dexterity: 15, constitution: 11, intelligence: 2, wisdom: 10, charisma: 4,
    darkvision: 60, passivePerception: 10, languages: [],
    traits: [MonsterTrait(name: 'Keen Smell', description: 'Advantage on Wisdom (Perception) checks that rely on smell.')],
    actions: [MonsterAction(name: 'Bite', description: 'Melee Weapon Attack', attackBonus: 4, damage: '1d4+2', damageType: 'piercing')],
  );

  static Monster bat() => Monster(
    id: 'bat', name: 'Bat', size: 'Tiny', type: 'Beast', alignment: 'Unaligned',
    challengeRating: 0, experiencePoints: 10,
    armorClass: 12, hitPoints: 1, hitDice: '1d4-1', speed: 5,
    strength: 2, dexterity: 15, constitution: 8, intelligence: 2, wisdom: 12, charisma: 4,
    blindsight: 60, passivePerception: 11, languages: [],
    traits: [MonsterTrait(name: 'Echolocation', description: 'Can\'t use blindsight while deafened.'), MonsterTrait(name: 'Keen Hearing', description: 'Advantage on Wisdom (Perception) checks that rely on hearing.')],
    actions: [MonsterAction(name: 'Bite', description: 'Melee Weapon Attack', attackBonus: 0, damage: '1', damageType: 'piercing')],
  );

  static Monster giantSpider() => Monster(
    id: 'giant_spider', name: 'Giant Spider', size: 'Large', type: 'Beast', alignment: 'Unaligned',
    challengeRating: 1, experiencePoints: 200,
    armorClass: 14, hitPoints: 26, hitDice: '4d10+4', speed: 30,
    strength: 14, dexterity: 16, constitution: 12, intelligence: 2, wisdom: 11, charisma: 4,
    skills: {'Stealth': 7}, blindsight: 10, darkvision: 60, passivePerception: 10, languages: [],
    traits: [MonsterTrait(name: 'Spider Climb', description: 'Can climb difficult surfaces without checks.'), MonsterTrait(name: 'Web Sense', description: 'Knows exact location of creatures in contact with web.'), MonsterTrait(name: 'Web Walker', description: 'Ignores movement restrictions from webbing.')],
    actions: [
      MonsterAction(name: 'Bite', description: 'Melee Weapon Attack. DC 11 Constitution save or take 2d8 poison (half on success).', attackBonus: 5, damage: '1d8+3', damageType: 'piercing'),
      MonsterAction(name: 'Web', description: 'Ranged Weapon Attack (30/60 ft.). DC 12 Strength check or restrained. Can break free with DC 12 Strength check or deal 10 damage to web (AC 10).', attackBonus: 5),
    ],
  );

  static Monster stirge() => Monster(
    id: 'stirge', name: 'Stirge', size: 'Tiny', type: 'Beast', alignment: 'Unaligned',
    challengeRating: 0.125, experiencePoints: 25,
    armorClass: 14, hitPoints: 2, hitDice: '1d4', speed: 10,
    strength: 4, dexterity: 16, constitution: 11, intelligence: 2, wisdom: 8, charisma: 6,
    darkvision: 60, passivePerception: 9, languages: [],
    actions: [MonsterAction(name: 'Blood Drain', description: 'Melee Weapon Attack. If hits, attaches and drains 1d4 HP at start of each stirge turn. Can detach by spending 5 feet of movement. Creature or ally within 5 feet can use action to detach it.', attackBonus: 5, damage: '1d4+3', damageType: 'piercing')],
  );

  // ==================== CR 1/2 - CR 1 ====================

  static Monster orc() => Monster(
    id: 'orc', name: 'Orc', size: 'Medium', type: 'Humanoid', alignment: 'Chaotic Evil',
    challengeRating: 0.5, experiencePoints: 100,
    armorClass: 13, hitPoints: 15, hitDice: '2d8+6', speed: 30,
    strength: 16, dexterity: 12, constitution: 16, intelligence: 7, wisdom: 11, charisma: 10,
    skills: {'Intimidation': 2}, darkvision: 60, passivePerception: 10, languages: ['Common', 'Orc'],
    traits: [MonsterTrait(name: 'Aggressive', description: 'As bonus action, move up to speed toward hostile creature.')],
    actions: [
      MonsterAction(name: 'Greataxe', description: 'Melee Weapon Attack', attackBonus: 5, damage: '1d12+3', damageType: 'slashing'),
      MonsterAction(name: 'Javelin', description: 'Melee or Ranged Weapon Attack', attackBonus: 5, damage: '1d6+3', damageType: 'piercing'),
    ],
  );

  static Monster hobgoblin() => Monster(
    id: 'hobgoblin', name: 'Hobgoblin', size: 'Medium', type: 'Humanoid', alignment: 'Lawful Evil',
    challengeRating: 0.5, experiencePoints: 100,
    armorClass: 18, hitPoints: 11, hitDice: '2d8+2', speed: 30,
    strength: 13, dexterity: 12, constitution: 12, intelligence: 10, wisdom: 10, charisma: 9,
    darkvision: 60, passivePerception: 10, languages: ['Common', 'Goblin'],
    traits: [MonsterTrait(name: 'Martial Advantage', description: 'Once per turn, deal extra 2d6 damage if ally within 5 feet of target.')],
    actions: [
      MonsterAction(name: 'Longsword', description: 'Melee Weapon Attack', attackBonus: 3, damage: '1d8+1', damageType: 'slashing'),
      MonsterAction(name: 'Longbow', description: 'Ranged Weapon Attack', attackBonus: 3, damage: '1d8+1', damageType: 'piercing'),
    ],
  );

  static Monster wolf() => Monster(
    id: 'wolf', name: 'Wolf', size: 'Medium', type: 'Beast', alignment: 'Unaligned',
    challengeRating: 0.25, experiencePoints: 50,
    armorClass: 13, hitPoints: 11, hitDice: '2d8+2', speed: 40,
    strength: 12, dexterity: 15, constitution: 12, intelligence: 3, wisdom: 12, charisma: 6,
    skills: {'Perception': 3, 'Stealth': 4}, passivePerception: 13, languages: [],
    traits: [
      MonsterTrait(name: 'Keen Hearing and Smell', description: 'Advantage on Wisdom (Perception) checks that rely on hearing or smell.'),
      MonsterTrait(name: 'Pack Tactics', description: 'Advantage on attacks if ally within 5 feet of target.'),
    ],
    actions: [MonsterAction(name: 'Bite', description: 'Melee Weapon Attack', attackBonus: 4, damage: '2d4+2', damageType: 'piercing')],
  );

  static Monster bear() => Monster(
    id: 'black_bear', name: 'Black Bear', size: 'Medium', type: 'Beast', alignment: 'Unaligned',
    challengeRating: 0.5, experiencePoints: 100,
    armorClass: 11, hitPoints: 19, hitDice: '3d8+6', speed: 40,
    strength: 15, dexterity: 10, constitution: 14, intelligence: 2, wisdom: 12, charisma: 7,
    skills: {'Perception': 3}, passivePerception: 13, languages: [],
    traits: [MonsterTrait(name: 'Keen Smell', description: 'Advantage on Wisdom (Perception) checks that rely on smell.')],
    actions: [
      MonsterAction(name: 'Bite', description: 'Melee Weapon Attack', attackBonus: 4, damage: '1d6+2', damageType: 'piercing'),
      MonsterAction(name: 'Claws', description: 'Melee Weapon Attack', attackBonus: 4, damage: '2d4+2', damageType: 'slashing'),
    ],
  );

  static Monster direwolf() => Monster(
    id: 'direwolf', name: 'Dire Wolf', size: 'Large', type: 'Beast', alignment: 'Unaligned',
    challengeRating: 1, experiencePoints: 200,
    armorClass: 14, hitPoints: 37, hitDice: '5d10+10', speed: 50,
    strength: 17, dexterity: 15, constitution: 15, intelligence: 3, wisdom: 12, charisma: 7,
    skills: {'Perception': 3, 'Stealth': 4}, passivePerception: 13, languages: [],
    traits: [
      MonsterTrait(name: 'Keen Hearing and Smell', description: 'Advantage on Wisdom (Perception) checks that rely on hearing or smell.'),
      MonsterTrait(name: 'Pack Tactics', description: 'Advantage on attacks if ally within 5 feet of target.'),
    ],
    actions: [MonsterAction(name: 'Bite', description: 'Melee Weapon Attack. DC 13 Strength save or knocked prone.', attackBonus: 5, damage: '2d6+3', damageType: 'piercing')],
  );

  static Monster bugbear() => Monster(
    id: 'bugbear', name: 'Bugbear', size: 'Medium', type: 'Humanoid', alignment: 'Chaotic Evil',
    challengeRating: 1, experiencePoints: 200,
    armorClass: 16, hitPoints: 27, hitDice: '5d8+5', speed: 30,
    strength: 15, dexterity: 14, constitution: 13, intelligence: 8, wisdom: 11, charisma: 9,
    skills: {'Stealth': 6, 'Survival': 2}, darkvision: 60, passivePerception: 10, languages: ['Common', 'Goblin'],
    traits: [
      MonsterTrait(name: 'Brute', description: 'Extra die of damage with melee weapons (included).'),
      MonsterTrait(name: 'Surprise Attack', description: 'If surprise, deal extra 2d6 damage.'),
    ],
    actions: [
      MonsterAction(name: 'Morningstar', description: 'Melee Weapon Attack', attackBonus: 4, damage: '2d8+2', damageType: 'piercing'),
      MonsterAction(name: 'Javelin', description: 'Melee or Ranged Weapon Attack', attackBonus: 4, damage: '2d6+2', damageType: 'piercing'),
    ],
  );

  static Monster ghoul() => Monster(
    id: 'ghoul', name: 'Ghoul', size: 'Medium', type: 'Undead', alignment: 'Chaotic Evil',
    challengeRating: 1, experiencePoints: 200,
    armorClass: 12, hitPoints: 22, hitDice: '5d8', speed: 30,
    strength: 13, dexterity: 15, constitution: 10, intelligence: 7, wisdom: 10, charisma: 6,
    damageImmunities: ['poison'], conditionImmunities: ['charmed', 'exhaustion', 'poisoned'],
    darkvision: 60, passivePerception: 10, languages: ['Common'],
    actions: [
      MonsterAction(name: 'Bite', description: 'Melee Weapon Attack', attackBonus: 2, damage: '2d6+2', damageType: 'piercing'),
      MonsterAction(name: 'Claws', description: 'Melee Weapon Attack. If target is creature other than elf or undead, must succeed DC 10 Constitution save or paralyzed for 1 minute. Can repeat save at end of turns.', attackBonus: 4, damage: '2d4+2', damageType: 'slashing'),
    ],
  );

  static Monster ghast() => Monster(
    id: 'ghast', name: 'Ghast', size: 'Medium', type: 'Undead', alignment: 'Chaotic Evil',
    challengeRating: 2, experiencePoints: 450,
    armorClass: 13, hitPoints: 36, hitDice: '8d8', speed: 30,
    strength: 16, dexterity: 17, constitution: 10, intelligence: 11, wisdom: 10, charisma: 8,
    damageResistances: ['necrotic'], damageImmunities: ['poison'], conditionImmunities: ['charmed', 'exhaustion', 'poisoned'],
    darkvision: 60, passivePerception: 10, languages: ['Common'],
    traits: [MonsterTrait(name: 'Stench', description: 'Creatures starting turn within 5 feet must succeed DC 10 Constitution save or poisoned until start of next turn.')],
    actions: [
      MonsterAction(name: 'Bite', description: 'Melee Weapon Attack', attackBonus: 3, damage: '2d8+3', damageType: 'piercing'),
      MonsterAction(name: 'Claws', description: 'Melee Weapon Attack. If target is creature other than undead, must succeed DC 10 Constitution save or paralyzed for 1 minute. Can repeat save at end of turns.', attackBonus: 5, damage: '2d6+3', damageType: 'slashing'),
    ],
  );

  static Monster shadow() => Monster(
    id: 'shadow', name: 'Shadow', size: 'Medium', type: 'Undead', alignment: 'Chaotic Evil',
    challengeRating: 0.5, experiencePoints: 100,
    armorClass: 12, hitPoints: 16, hitDice: '3d8+3', speed: 40,
    strength: 6, dexterity: 14, constitution: 13, intelligence: 6, wisdom: 10, charisma: 8,
    skills: {'Stealth': 4},
    damageVulnerabilities: ['radiant'], damageResistances: ['acid', 'cold', 'fire', 'lightning', 'thunder', 'nonmagical weapons'],
    damageImmunities: ['necrotic', 'poison'],
    conditionImmunities: ['exhaustion', 'frightened', 'grappled', 'paralyzed', 'petrified', 'poisoned', 'prone', 'restrained'],
    darkvision: 60, passivePerception: 10, languages: [],
    traits: [
      MonsterTrait(name: 'Amorphous', description: 'Can move through space as narrow as 1 inch without squeezing.'),
      MonsterTrait(name: 'Shadow Stealth', description: 'While in dim light or darkness, can Hide as bonus action.'),
      MonsterTrait(name: 'Sunlight Weakness', description: 'In sunlight has disadvantage on attack rolls, ability checks, and saves.'),
    ],
    actions: [MonsterAction(name: 'Strength Drain', description: 'Melee Weapon Attack. Deals 2d6+2 necrotic and Strength reduced by 1d4. Dies if reduced to 0 Strength.', attackBonus: 4, damage: '2d6+2', damageType: 'necrotic')],
  );

  static Monster specter() => Monster(
    id: 'specter', name: 'Specter', size: 'Medium', type: 'Undead', alignment: 'Chaotic Evil',
    challengeRating: 1, experiencePoints: 200,
    armorClass: 12, hitPoints: 22, hitDice: '5d8', speed: 0,
    strength: 1, dexterity: 14, constitution: 11, intelligence: 10, wisdom: 10, charisma: 11,
    damageResistances: ['acid', 'cold', 'fire', 'lightning', 'thunder', 'nonmagical weapons'],
    damageImmunities: ['necrotic', 'poison'],
    conditionImmunities: ['charmed', 'exhaustion', 'grappled', 'paralyzed', 'petrified', 'poisoned', 'prone', 'restrained', 'unconscious'],
    darkvision: 60, passivePerception: 10, languages: ['Understands all it spoke in life but can\'t speak'],
    traits: [MonsterTrait(name: 'Incorporeal Movement', description: 'Can move through creatures and objects as difficult terrain. Takes 1d10 force if ends turn in object.'), MonsterTrait(name: 'Sunlight Sensitivity', description: 'In sunlight has disadvantage on attack rolls and Perception.')],
    actions: [MonsterAction(name: 'Life Drain', description: 'Melee Spell Attack. DC 10 Constitution save or HP max reduced by amount equal to necrotic damage. Dies if reduced to 0.', attackBonus: 4, damage: '3d6', damageType: 'necrotic')],
  );

  static Monster crocodile() => Monster(
    id: 'crocodile', name: 'Crocodile', size: 'Large', type: 'Beast', alignment: 'Unaligned',
    challengeRating: 0.5, experiencePoints: 100,
    armorClass: 12, hitPoints: 19, hitDice: '3d10+3', speed: 20,
    strength: 15, dexterity: 10, constitution: 13, intelligence: 2, wisdom: 10, charisma: 5,
    skills: {'Stealth': 2}, passivePerception: 10, languages: [],
    traits: [MonsterTrait(name: 'Hold Breath', description: 'Can hold breath for 15 minutes.')],
    actions: [MonsterAction(name: 'Bite', description: 'Melee Weapon Attack. Grapples target (escape DC 12). Until grapple ends, target restrained and crocodile can\'t bite another.', attackBonus: 4, damage: '1d10+2', damageType: 'piercing')],
  );

  static Monster werewolf() => Monster(
    id: 'werewolf', name: 'Werewolf', size: 'Medium', type: 'Humanoid', alignment: 'Chaotic Evil',
    challengeRating: 3, experiencePoints: 700,
    armorClass: 12, hitPoints: 58, hitDice: '9d8+18', speed: 30,
    strength: 15, dexterity: 13, constitution: 14, intelligence: 10, wisdom: 11, charisma: 10,
    skills: {'Perception': 4, 'Stealth': 3},
    damageImmunities: ['nonmagical weapons that aren\'t silvered'],
    passivePerception: 14, languages: ['Common'],
    traits: [
      MonsterTrait(name: 'Shapechanger', description: 'Can polymorph into wolf-humanoid hybrid or into wolf, or back. Equipment not transformed. Reverts on death.'),
      MonsterTrait(name: 'Keen Hearing and Smell', description: 'Advantage on Wisdom (Perception) checks that rely on hearing or smell.'),
    ],
    actions: [
      MonsterAction(name: 'Multiattack (Humanoid or Hybrid Form Only)', description: 'Makes two attacks: one bite and one claws or spear.'),
      MonsterAction(name: 'Bite (Wolf or Hybrid Form Only)', description: 'Melee Weapon Attack. If target is humanoid, must succeed DC 12 Constitution save or cursed with werewolf lycanthropy.', attackBonus: 4, damage: '1d8+2', damageType: 'piercing'),
      MonsterAction(name: 'Claws (Hybrid Form Only)', description: 'Melee Weapon Attack', attackBonus: 4, damage: '2d4+2', damageType: 'slashing'),
    ],
  );

  static Monster gargoyle() => Monster(
    id: 'gargoyle', name: 'Gargoyle', size: 'Medium', type: 'Elemental', alignment: 'Chaotic Evil',
    challengeRating: 2, experiencePoints: 450,
    armorClass: 15, hitPoints: 52, hitDice: '7d8+21', speed: 30,
    strength: 15, dexterity: 11, constitution: 16, intelligence: 6, wisdom: 11, charisma: 7,
    damageResistances: ['nonmagical weapons that aren\'t adamantine'],
    damageImmunities: ['poison'],
    conditionImmunities: ['exhaustion', 'petrified', 'poisoned'],
    darkvision: 60, passivePerception: 10, languages: ['Terran'],
    traits: [MonsterTrait(name: 'False Appearance', description: 'While motionless, indistinguishable from inanimate statue.')],
    actions: [
      MonsterAction(name: 'Multiattack', description: 'Makes two attacks: one bite and one claws.'),
      MonsterAction(name: 'Bite', description: 'Melee Weapon Attack', attackBonus: 4, damage: '1d6+2', damageType: 'piercing'),
      MonsterAction(name: 'Claws', description: 'Melee Weapon Attack', attackBonus: 4, damage: '1d6+2', damageType: 'slashing'),
    ],
  );

  // ==================== CR 2 - CR 4 ====================

  static Monster ogre() => Monster(
    id: 'ogre', name: 'Ogre', size: 'Large', type: 'Giant', alignment: 'Chaotic Evil',
    challengeRating: 2, experiencePoints: 450,
    armorClass: 11, hitPoints: 59, hitDice: '7d10+21', speed: 40,
    strength: 19, dexterity: 8, constitution: 16, intelligence: 5, wisdom: 7, charisma: 7,
    darkvision: 60, passivePerception: 8, languages: ['Common', 'Giant'],
    actions: [
      MonsterAction(name: 'Greatclub', description: 'Melee Weapon Attack', attackBonus: 6, damage: '2d8+4', damageType: 'bludgeoning'),
      MonsterAction(name: 'Javelin', description: 'Melee or Ranged Weapon Attack', attackBonus: 6, damage: '2d6+4', damageType: 'piercing'),
    ],
  );

  static Monster ettinMonster() => Monster(
    id: 'ettin', name: 'Ettin', size: 'Large', type: 'Giant', alignment: 'Chaotic Evil',
    challengeRating: 4, experiencePoints: 1100,
    armorClass: 12, hitPoints: 85, hitDice: '10d10+30', speed: 40,
    strength: 21, dexterity: 8, constitution: 17, intelligence: 6, wisdom: 10, charisma: 8,
    skills: {'Perception': 4}, darkvision: 60, passivePerception: 14, languages: ['Giant', 'Orc'],
    traits: [
      MonsterTrait(name: 'Two Heads', description: 'Advantage on Wisdom (Perception) checks and saves vs. blinded, charmed, deafened, frightened, stunned, unconscious.'),
      MonsterTrait(name: 'Wakeful', description: 'One head stays awake while the other sleeps.'),
    ],
    actions: [
      MonsterAction(name: 'Multiattack', description: 'Makes two attacks: one battleaxe and one morningstar.'),
      MonsterAction(name: 'Battleaxe', description: 'Melee Weapon Attack', attackBonus: 7, damage: '2d8+5', damageType: 'slashing'),
      MonsterAction(name: 'Morningstar', description: 'Melee Weapon Attack', attackBonus: 7, damage: '2d8+5', damageType: 'piercing'),
    ],
  );

  static Monster owlbear() => Monster(
    id: 'owlbear', name: 'Owlbear', size: 'Large', type: 'Monstrosity', alignment: 'Unaligned',
    challengeRating: 3, experiencePoints: 700,
    armorClass: 13, hitPoints: 59, hitDice: '7d10+21', speed: 40,
    strength: 20, dexterity: 12, constitution: 17, intelligence: 3, wisdom: 12, charisma: 7,
    skills: {'Perception': 3}, darkvision: 60, passivePerception: 13, languages: [],
    traits: [MonsterTrait(name: 'Keen Sight and Smell', description: 'Advantage on Wisdom (Perception) checks that rely on sight or smell.')],
    actions: [
      MonsterAction(name: 'Multiattack', description: 'Makes two attacks: one beak and one claws.'),
      MonsterAction(name: 'Beak', description: 'Melee Weapon Attack', attackBonus: 7, damage: '1d10+5', damageType: 'piercing'),
      MonsterAction(name: 'Claws', description: 'Melee Weapon Attack', attackBonus: 7, damage: '2d8+5', damageType: 'slashing'),
    ],
  );

  static Monster minotaur() => Monster(
    id: 'minotaur', name: 'Minotaur', size: 'Large', type: 'Monstrosity', alignment: 'Chaotic Evil',
    challengeRating: 3, experiencePoints: 700,
    armorClass: 14, hitPoints: 76, hitDice: '9d10+27', speed: 40,
    strength: 18, dexterity: 11, constitution: 16, intelligence: 6, wisdom: 16, charisma: 9,
    skills: {'Perception': 7}, darkvision: 60, passivePerception: 17, languages: ['Abyssal'],
    traits: [
      MonsterTrait(name: 'Charge', description: 'If moves 10 feet straight toward target and hits with gore, target takes extra 2d8 piercing and DC 14 Strength save or pushed 10 feet and knocked prone.'),
      MonsterTrait(name: 'Labyrinthine Recall', description: 'Can perfectly recall any path it has traveled.'),
      MonsterTrait(name: 'Reckless', description: 'At start of turn, can gain advantage on melee attacks but attacks against it have advantage.'),
    ],
    actions: [
      MonsterAction(name: 'Greataxe', description: 'Melee Weapon Attack', attackBonus: 6, damage: '2d12+4', damageType: 'slashing'),
      MonsterAction(name: 'Gore', description: 'Melee Weapon Attack', attackBonus: 6, damage: '2d8+4', damageType: 'piercing'),
    ],
  );

  static Monster griffon() => Monster(
    id: 'griffon', name: 'Griffon', size: 'Large', type: 'Monstrosity', alignment: 'Unaligned',
    challengeRating: 2, experiencePoints: 450,
    armorClass: 12, hitPoints: 59, hitDice: '7d10+21', speed: 30,
    strength: 18, dexterity: 15, constitution: 16, intelligence: 2, wisdom: 13, charisma: 8,
    skills: {'Perception': 5}, darkvision: 60, passivePerception: 15, languages: [],
    traits: [MonsterTrait(name: 'Keen Sight', description: 'Advantage on Wisdom (Perception) checks that rely on sight.')],
    actions: [
      MonsterAction(name: 'Multiattack', description: 'Makes two attacks: one beak and one claws.'),
      MonsterAction(name: 'Beak', description: 'Melee Weapon Attack', attackBonus: 6, damage: '1d8+4', damageType: 'piercing'),
      MonsterAction(name: 'Claws', description: 'Melee Weapon Attack', attackBonus: 6, damage: '2d6+4', damageType: 'slashing'),
    ],
  );

  static Monster basilisk() => Monster(
    id: 'basilisk', name: 'Basilisk', size: 'Medium', type: 'Monstrosity', alignment: 'Unaligned',
    challengeRating: 3, experiencePoints: 700,
    armorClass: 15, hitPoints: 52, hitDice: '8d8+16', speed: 20,
    strength: 16, dexterity: 8, constitution: 15, intelligence: 2, wisdom: 8, charisma: 7,
    darkvision: 60, passivePerception: 9, languages: [],
    traits: [MonsterTrait(name: 'Petrifying Gaze', description: 'If creature starts turn within 30 feet and can see basilisk, must make DC 12 Constitution save. On failure, magically begins to turn to stone and is restrained. Must repeat save at end of next turn. On success, effect ends. On failure, petrified until freed by greater restoration or similar.')],
    actions: [MonsterAction(name: 'Bite', description: 'Melee Weapon Attack', attackBonus: 5, damage: '2d6+3', damageType: 'piercing')],
  );

  static Monster manticore() => Monster(
    id: 'manticore', name: 'Manticore', size: 'Large', type: 'Monstrosity', alignment: 'Lawful Evil',
    challengeRating: 3, experiencePoints: 700,
    armorClass: 14, hitPoints: 68, hitDice: '8d10+24', speed: 30,
    strength: 17, dexterity: 16, constitution: 17, intelligence: 7, wisdom: 12, charisma: 8,
    darkvision: 60, passivePerception: 11, languages: ['Common'],
    traits: [MonsterTrait(name: 'Tail Spike Regrowth', description: 'Has 24 tail spikes. Regrows all expended spikes when finishes long rest.')],
    actions: [
      MonsterAction(name: 'Multiattack', description: 'Makes three attacks: one bite and two claws, or three tail spike attacks.'),
      MonsterAction(name: 'Bite', description: 'Melee Weapon Attack', attackBonus: 5, damage: '1d8+3', damageType: 'piercing'),
      MonsterAction(name: 'Claw', description: 'Melee Weapon Attack', attackBonus: 5, damage: '1d6+3', damageType: 'slashing'),
      MonsterAction(name: 'Tail Spike', description: 'Ranged Weapon Attack (100/200 ft.)', attackBonus: 5, damage: '1d8+3', damageType: 'piercing'),
    ],
  );

  static Monster mummy() => Monster(
    id: 'mummy', name: 'Mummy', size: 'Medium', type: 'Undead', alignment: 'Lawful Evil',
    challengeRating: 3, experiencePoints: 700,
    armorClass: 11, hitPoints: 58, hitDice: '9d8+18', speed: 20,
    strength: 16, dexterity: 8, constitution: 15, intelligence: 6, wisdom: 10, charisma: 12,
    savingThrows: {'Wisdom': 2},
    damageVulnerabilities: ['fire'],
    damageResistances: ['nonmagical weapons'],
    damageImmunities: ['necrotic', 'poison'],
    conditionImmunities: ['charmed', 'exhaustion', 'frightened', 'paralyzed', 'poisoned'],
    darkvision: 60, passivePerception: 10, languages: ['Languages it knew in life'],
    actions: [
      MonsterAction(name: 'Multiattack', description: 'Can use Dreadful Glare and makes one rotting fist attack.'),
      MonsterAction(name: 'Rotting Fist', description: 'Melee Weapon Attack. If target is creature, must succeed DC 12 Constitution save or cursed with mummy rot. Cursed target can\'t regain HP and max HP decreases by 3d6 every 24 hours.', attackBonus: 5, damage: '2d6+3', damageType: 'bludgeoning'),
      MonsterAction(name: 'Dreadful Glare', description: 'Targets one creature within 60 feet. DC 11 Wisdom save or frightened until end of mummy\'s next turn. On failure by 5+ also paralyzed.'),
    ],
  );

  static Monster nightmare() => Monster(
    id: 'nightmare', name: 'Nightmare', size: 'Large', type: 'Fiend', alignment: 'Neutral Evil',
    challengeRating: 3, experiencePoints: 700,
    armorClass: 13, hitPoints: 68, hitDice: '8d10+24', speed: 60,
    strength: 18, dexterity: 15, constitution: 16, intelligence: 10, wisdom: 13, charisma: 15,
    damageImmunities: ['fire'],
    passivePerception: 11, languages: ['Understands Abyssal, Common, and Infernal but can\'t speak'],
    traits: [
      MonsterTrait(name: 'Confer Fire Resistance', description: 'Can grant fire resistance to anyone riding it.'),
      MonsterTrait(name: 'Illumination', description: 'Sheds bright light in 10 foot radius and dim light 10 feet beyond.'),
    ],
    actions: [
      MonsterAction(name: 'Hooves', description: 'Melee Weapon Attack', attackBonus: 6, damage: '2d8+4', damageType: 'bludgeoning'),
      MonsterAction(name: 'Ethereal Stride', description: 'Magically enters Ethereal Plane from Material Plane, or vice versa.'),
    ],
  );

  static Monster wyvern() => Monster(
    id: 'wyvern', name: 'Wyvern', size: 'Large', type: 'Dragon', alignment: 'Unaligned',
    challengeRating: 6, experiencePoints: 2300,
    armorClass: 13, hitPoints: 110, hitDice: '13d10+39', speed: 20,
    strength: 19, dexterity: 10, constitution: 16, intelligence: 5, wisdom: 12, charisma: 6,
    skills: {'Perception': 4}, darkvision: 60, passivePerception: 14, languages: [],
    actions: [
      MonsterAction(name: 'Multiattack', description: 'Makes two attacks: one bite and one stinger.'),
      MonsterAction(name: 'Bite', description: 'Melee Weapon Attack', attackBonus: 7, damage: '2d6+4', damageType: 'piercing'),
      MonsterAction(name: 'Claws', description: 'Melee Weapon Attack', attackBonus: 7, damage: '2d8+4', damageType: 'slashing'),
      MonsterAction(name: 'Stinger', description: 'Melee Weapon Attack. DC 15 Constitution save or take 7d6 poison (half on success).', attackBonus: 7, damage: '2d6+4', damageType: 'piercing'),
    ],
  );

  static Monster wraith() => Monster(
    id: 'wraith', name: 'Wraith', size: 'Medium', type: 'Undead', alignment: 'Neutral Evil',
    challengeRating: 5, experiencePoints: 1800,
    armorClass: 13, hitPoints: 67, hitDice: '9d8+27', speed: 0,
    strength: 6, dexterity: 16, constitution: 16, intelligence: 12, wisdom: 14, charisma: 15,
    damageResistances: ['acid', 'cold', 'fire', 'lightning', 'thunder', 'nonmagical weapons that aren\'t silvered'],
    damageImmunities: ['necrotic', 'poison'],
    conditionImmunities: ['charmed', 'exhaustion', 'grappled', 'paralyzed', 'petrified', 'poisoned', 'prone', 'restrained'],
    darkvision: 60, passivePerception: 12, languages: ['Languages it knew in life'],
    traits: [
      MonsterTrait(name: 'Incorporeal Movement', description: 'Can move through creatures and objects. Takes 1d10 force if ends turn in object.'),
      MonsterTrait(name: 'Sunlight Sensitivity', description: 'In sunlight has disadvantage on attack rolls and Perception.'),
    ],
    actions: [
      MonsterAction(name: 'Life Drain', description: 'Melee Weapon Attack. DC 14 Constitution save or HP max reduced by amount equal to necrotic damage. Target dies if reduced to 0. Reduction lasts until target finishes long rest.', attackBonus: 6, damage: '4d8+3', damageType: 'necrotic'),
      MonsterAction(name: 'Create Specter', description: 'Targets humanoid within 10 feet that died violently within last minute. Target rises as specter under wraith\'s control.'),
    ],
  );

  // ==================== CR 5 - CR 8 ====================

  static Monster troll() => Monster(
    id: 'troll', name: 'Troll', size: 'Large', type: 'Giant', alignment: 'Chaotic Evil',
    challengeRating: 5, experiencePoints: 1800,
    armorClass: 15, hitPoints: 84, hitDice: '8d10+40', speed: 30,
    strength: 18, dexterity: 13, constitution: 20, intelligence: 7, wisdom: 9, charisma: 7,
    skills: {'Perception': 2}, darkvision: 60, passivePerception: 12, languages: ['Giant'],
    traits: [
      MonsterTrait(name: 'Keen Smell', description: 'Advantage on Wisdom (Perception) checks that rely on smell.'),
      MonsterTrait(name: 'Regeneration', description: 'Regains 10 HP at start of turn. If takes acid or fire damage, doesn\'t regenerate next turn. Dies only if starts turn at 0 HP and doesn\'t regenerate.'),
    ],
    actions: [
      MonsterAction(name: 'Multiattack', description: 'Makes three attacks: one bite and two claws.'),
      MonsterAction(name: 'Bite', description: 'Melee Weapon Attack', attackBonus: 7, damage: '1d6+4', damageType: 'piercing'),
      MonsterAction(name: 'Claw', description: 'Melee Weapon Attack', attackBonus: 7, damage: '2d6+4', damageType: 'slashing'),
    ],
  );

  static Monster hillGiant() => Monster(
    id: 'hill_giant', name: 'Hill Giant', size: 'Huge', type: 'Giant', alignment: 'Chaotic Evil',
    challengeRating: 5, experiencePoints: 1800,
    armorClass: 13, hitPoints: 105, hitDice: '10d12+40', speed: 40,
    strength: 21, dexterity: 8, constitution: 19, intelligence: 5, wisdom: 9, charisma: 6,
    skills: {'Perception': 2}, passivePerception: 12, languages: ['Giant'],
    actions: [
      MonsterAction(name: 'Multiattack', description: 'Makes two greatclub attacks.'),
      MonsterAction(name: 'Greatclub', description: 'Melee Weapon Attack', attackBonus: 8, damage: '3d8+5', damageType: 'bludgeoning'),
      MonsterAction(name: 'Rock', description: 'Ranged Weapon Attack (60/240 ft.)', attackBonus: 8, damage: '3d10+5', damageType: 'bludgeoning'),
    ],
  );

  static Monster youngBlackDragon() => Monster(
    id: 'young_black_dragon', name: 'Young Black Dragon', size: 'Large', type: 'Dragon', alignment: 'Chaotic Evil',
    challengeRating: 7, experiencePoints: 2900,
    armorClass: 18, hitPoints: 127, hitDice: '15d10+45', speed: 40,
    strength: 19, dexterity: 14, constitution: 17, intelligence: 12, wisdom: 11, charisma: 15,
    savingThrows: {'Dexterity': 5, 'Constitution': 6, 'Wisdom': 3, 'Charisma': 5},
    skills: {'Perception': 6, 'Stealth': 5},
    damageImmunities: ['acid'],
    blindsight: 30, darkvision: 120, passivePerception: 16,
    languages: ['Common', 'Draconic'],
    traits: [MonsterTrait(name: 'Amphibious', description: 'Can breathe air and water.')],
    actions: [
      MonsterAction(name: 'Multiattack', description: 'Makes three attacks: one bite and two claws.'),
      MonsterAction(name: 'Bite', description: 'Melee Weapon Attack', attackBonus: 7, damage: '2d10+4', damageType: 'piercing'),
      MonsterAction(name: 'Claw', description: 'Melee Weapon Attack', attackBonus: 7, damage: '2d6+4', damageType: 'slashing'),
      MonsterAction(name: 'Acid Breath', description: '5×30 ft. line. Dexterity DC 14 save or 11d8 acid (half on success).', recharge: '5-6'),
    ],
  );

  static Monster youngRedDragon() => Monster(
    id: 'young_red_dragon', name: 'Young Red Dragon', size: 'Large', type: 'Dragon', alignment: 'Chaotic Evil',
    challengeRating: 10, experiencePoints: 5900,
    armorClass: 18, hitPoints: 178, hitDice: '17d10+85', speed: 40,
    strength: 23, dexterity: 10, constitution: 21, intelligence: 14, wisdom: 11, charisma: 19,
    savingThrows: {'Dexterity': 4, 'Constitution': 9, 'Wisdom': 4, 'Charisma': 8},
    skills: {'Perception': 8, 'Stealth': 4},
    damageImmunities: ['fire'],
    blindsight: 30, darkvision: 120, passivePerception: 18,
    languages: ['Common', 'Draconic'],
    actions: [
      MonsterAction(name: 'Multiattack', description: 'Makes three attacks: one bite and two claws.'),
      MonsterAction(name: 'Bite', description: 'Melee Weapon Attack', attackBonus: 10, damage: '2d10+6', damageType: 'piercing'),
      MonsterAction(name: 'Claw', description: 'Melee Weapon Attack', attackBonus: 10, damage: '2d6+6', damageType: 'slashing'),
      MonsterAction(name: 'Fire Breath', description: '30 ft. cone. Dexterity DC 17 save or 16d6 fire (half on success).', recharge: '5-6'),
    ],
  );

  static Monster mindFlayer() => Monster(
    id: 'mind_flayer', name: 'Mind Flayer', size: 'Medium', type: 'Aberration', alignment: 'Lawful Evil',
    challengeRating: 7, experiencePoints: 2900,
    armorClass: 15, hitPoints: 71, hitDice: '13d8+13', speed: 30,
    strength: 11, dexterity: 12, constitution: 12, intelligence: 19, wisdom: 17, charisma: 17,
    savingThrows: {'Intelligence': 7, 'Wisdom': 6, 'Charisma': 6},
    skills: {'Arcana': 7, 'Deception': 6, 'Insight': 6, 'Perception': 6, 'Persuasion': 6, 'Stealth': 4},
    darkvision: 120, passivePerception: 16, languages: ['Deep Speech', 'Undercommon', 'telepathy 120 ft.'],
    traits: [MonsterTrait(name: 'Magic Resistance', description: 'Advantage on saves vs. spells and magical effects.')],
    actions: [
      MonsterAction(name: 'Tentacles', description: 'Melee Weapon Attack. If target is Medium or smaller, it is grappled (escape DC 15) and must succeed on DC 15 Intelligence save or take 4d10 psychic and be stunned until grapple ends.', attackBonus: 7, damage: '2d10+0', damageType: 'psychic'),
      MonsterAction(name: 'Extract Brain', description: 'Melee Weapon Attack against incapacitated humanoid grappled by it. If attack hits and target has brain, deals 10d10 piercing and target dies if this reduces it to 0 HP.', attackBonus: 7, damage: '10d10', damageType: 'piercing'),
      MonsterAction(name: 'Mind Blast', description: '60 ft. cone. DC 15 Intelligence save or 4d8+4 psychic and stunned for 1 minute. Can repeat save at end of turns.', recharge: '5-6'),
    ],
  );

  static Monster chimera() => Monster(
    id: 'chimera', name: 'Chimera', size: 'Large', type: 'Monstrosity', alignment: 'Chaotic Evil',
    challengeRating: 6, experiencePoints: 2300,
    armorClass: 14, hitPoints: 114, hitDice: '12d10+48', speed: 30,
    strength: 19, dexterity: 11, constitution: 19, intelligence: 3, wisdom: 14, charisma: 10,
    skills: {'Perception': 8}, darkvision: 60, passivePerception: 18, languages: ['Understands Draconic but can\'t speak'],
    actions: [
      MonsterAction(name: 'Multiattack', description: 'Makes three attacks: one bite, one horns, one claws. Can use fire breath in place of bite or horns.'),
      MonsterAction(name: 'Bite', description: 'Melee Weapon Attack', attackBonus: 7, damage: '2d6+4', damageType: 'piercing'),
      MonsterAction(name: 'Horns', description: 'Melee Weapon Attack', attackBonus: 7, damage: '1d12+4', damageType: 'bludgeoning'),
      MonsterAction(name: 'Claws', description: 'Melee Weapon Attack', attackBonus: 7, damage: '2d6+4', damageType: 'slashing'),
      MonsterAction(name: 'Fire Breath', description: '15 ft. cone. Dexterity DC 15 save or 7d8 fire (half on success).', recharge: '5-6'),
    ],
  );

  static Monster medusa() => Monster(
    id: 'medusa', name: 'Medusa', size: 'Medium', type: 'Monstrosity', alignment: 'Lawful Evil',
    challengeRating: 6, experiencePoints: 2300,
    armorClass: 15, hitPoints: 127, hitDice: '17d8+51', speed: 30,
    strength: 10, dexterity: 15, constitution: 16, intelligence: 12, wisdom: 13, charisma: 15,
    skills: {'Deception': 5, 'Insight': 4, 'Perception': 4, 'Stealth': 5},
    darkvision: 60, passivePerception: 14, languages: ['Common'],
    traits: [MonsterTrait(name: 'Petrifying Gaze', description: 'Creature starting turn within 30 feet and can see medusa\'s eyes must make DC 14 Constitution save. On failure, begins turning to stone and restrained. Must repeat save at end of next turn. On success, effect ends. On failure, petrified.')],
    actions: [
      MonsterAction(name: 'Multiattack', description: 'Makes either three melee attacks (one snake hair and two with longsword) or two ranged attacks with longbow.'),
      MonsterAction(name: 'Snake Hair', description: 'Melee Weapon Attack. DC 14 Constitution save or take 4d6 poison.', attackBonus: 5, damage: '1d4+2', damageType: 'piercing'),
      MonsterAction(name: 'Shortsword', description: 'Melee Weapon Attack', attackBonus: 5, damage: '1d6+2', damageType: 'piercing'),
      MonsterAction(name: 'Longbow', description: 'Ranged Weapon Attack (150/600 ft.)', attackBonus: 5, damage: '1d8+2', damageType: 'piercing'),
    ],
  );

  static Monster stoneGolem() => Monster(
    id: 'stone_golem', name: 'Stone Golem', size: 'Large', type: 'Construct', alignment: 'Unaligned',
    challengeRating: 10, experiencePoints: 5900,
    armorClass: 17, hitPoints: 178, hitDice: '17d10+85', speed: 30,
    strength: 22, dexterity: 9, constitution: 20, intelligence: 3, wisdom: 11, charisma: 1,
    damageImmunities: ['poison', 'psychic', 'nonmagical weapons that aren\'t adamantine'],
    conditionImmunities: ['charmed', 'exhaustion', 'frightened', 'paralyzed', 'petrified', 'poisoned'],
    darkvision: 120, passivePerception: 10, languages: ['Understands creator\'s languages but can\'t speak'],
    traits: [
      MonsterTrait(name: 'Immutable Form', description: 'Immune to any spell or effect that would alter its form.'),
      MonsterTrait(name: 'Magic Resistance', description: 'Advantage on saves vs. spells and magical effects.'),
      MonsterTrait(name: 'Magic Weapons', description: 'Weapon attacks are magical.'),
    ],
    actions: [
      MonsterAction(name: 'Multiattack', description: 'Makes two slam attacks.'),
      MonsterAction(name: 'Slam', description: 'Melee Weapon Attack', attackBonus: 10, damage: '3d8+6', damageType: 'bludgeoning'),
      MonsterAction(name: 'Slow', description: '10 ft. radius. Wisdom DC 17 save or slowed for 1 minute. Can repeat save at end of turns.', recharge: '5-6'),
    ],
  );

  static Monster vampire() => Monster(
    id: 'vampire', name: 'Vampire', size: 'Medium', type: 'Undead', alignment: 'Lawful Evil',
    challengeRating: 13, experiencePoints: 10000,
    armorClass: 16, hitPoints: 144, hitDice: '17d8+68', speed: 30,
    strength: 18, dexterity: 18, constitution: 18, intelligence: 17, wisdom: 15, charisma: 18,
    savingThrows: {'Dexterity': 9, 'Wisdom': 7, 'Charisma': 9},
    skills: {'Perception': 7, 'Stealth': 9},
    damageResistances: ['necrotic', 'nonmagical weapons'],
    darkvision: 120, passivePerception: 17, languages: ['Languages it knew in life'],
    traits: [
      MonsterTrait(name: 'Shapechanger', description: 'Can polymorph into Tiny bat, Medium cloud of mist, or back into true form. Equipment transforms with it.'),
      MonsterTrait(name: 'Legendary Resistance (3/Day)', description: 'If fails save, can choose to succeed instead.'),
      MonsterTrait(name: 'Misty Escape', description: 'When drops to 0 HP, transforms into cloud of mist instead of falling unconscious if not in sunlight or running water.'),
      MonsterTrait(name: 'Regeneration', description: 'Regains 20 HP at start of turn if has at least 1 HP and isn\'t in sunlight or running water.'),
      MonsterTrait(name: 'Spider Climb', description: 'Can climb difficult surfaces without checks.'),
      MonsterTrait(name: 'Vampire Weaknesses', description: 'Forbiddance, Harm from Running Water, Stake to Heart, Sunlight Hypersensitivity.'),
    ],
    actions: [
      MonsterAction(name: 'Multiattack (Vampire Form Only)', description: 'Makes two attacks, only one of which can be bite.'),
      MonsterAction(name: 'Unarmed Strike (Vampire Form Only)', description: 'Melee Weapon Attack. Instead of damage, can grapple (escape DC 18).', attackBonus: 9, damage: '1d8+4', damageType: 'bludgeoning'),
      MonsterAction(name: 'Bite (Bat or Vampire Form Only)', description: 'Melee Weapon Attack against willing, grappled, incapacitated, or restrained creature. Max HP reduced by amount equal to necrotic damage. Reduction lasts until target finishes long rest. Target dies if reduced to 0.', attackBonus: 9, damage: '1d6+4', damageType: 'piercing'),
      MonsterAction(name: 'Charm', description: 'One humanoid within 30 feet. Wisdom DC 17 save or charmed by vampire.'),
    ],
    legendaryActionsPerRound: 3,
    legendaryActions: [
      MonsterAction(name: 'Move', description: 'Moves up to speed without provoking opportunity attacks.'),
      MonsterAction(name: 'Unarmed Strike', description: 'Makes one unarmed strike.'),
      MonsterAction(name: 'Bite (Costs 2 Actions)', description: 'Makes one bite attack.'),
    ],
  );

  static Monster aboleth() => Monster(
    id: 'aboleth', name: 'Aboleth', size: 'Large', type: 'Aberration', alignment: 'Lawful Evil',
    challengeRating: 10, experiencePoints: 5900,
    armorClass: 17, hitPoints: 135, hitDice: '18d10+36', speed: 10,
    strength: 21, dexterity: 9, constitution: 15, intelligence: 18, wisdom: 15, charisma: 18,
    savingThrows: {'Constitution': 6, 'Intelligence': 8, 'Wisdom': 6},
    skills: {'History': 12, 'Perception': 10},
    darkvision: 120, passivePerception: 20, languages: ['Deep Speech', 'telepathy 120 ft.'],
    traits: [
      MonsterTrait(name: 'Amphibious', description: 'Can breathe air and water.'),
      MonsterTrait(name: 'Mucous Cloud', description: 'While underwater, surrounded by mucous cloud in 5 foot radius. Creatures in cloud must make DC 14 Constitution save at start of turn or diseased for 1d4 hours. Diseased creatures can breathe only underwater.'),
      MonsterTrait(name: 'Probing Telepathy', description: 'Can read thoughts of creatures within 60 feet. Creatures can make DC 15 Wisdom save.'),
    ],
    actions: [
      MonsterAction(name: 'Multiattack', description: 'Makes three tentacle attacks.'),
      MonsterAction(name: 'Tentacle', description: 'Melee Weapon Attack. DC 14 Constitution save or diseased.', attackBonus: 9, damage: '2d6+5', damageType: 'bludgeoning'),
      MonsterAction(name: 'Tail', description: 'Melee Weapon Attack', attackBonus: 9, damage: '3d6+5', damageType: 'bludgeoning'),
      MonsterAction(name: 'Enslave', description: 'One creature within 30 feet. Wisdom DC 14 save or magically charmed until aboleth dies or on different plane.'),
    ],
    legendaryActionsPerRound: 3,
    legendaryActions: [
      MonsterAction(name: 'Detect', description: 'Makes Wisdom (Perception) check.'),
      MonsterAction(name: 'Tail Swipe', description: 'Makes one tail attack.'),
      MonsterAction(name: 'Psychic Drain (Costs 2 Actions)', description: 'One charmed creature takes 3d6 psychic.'),
    ],
  );

  // ==================== CR 9 - CR 15 ====================

  static Monster beholder() => Monster(
    id: 'beholder', name: 'Beholder', size: 'Large', type: 'Aberration', alignment: 'Lawful Evil',
    challengeRating: 13, experiencePoints: 10000,
    armorClass: 18, hitPoints: 180, hitDice: '19d10+76', speed: 0,
    strength: 10, dexterity: 14, constitution: 18, intelligence: 17, wisdom: 15, charisma: 17,
    savingThrows: {'Intelligence': 8, 'Wisdom': 7, 'Charisma': 8},
    skills: {'Perception': 12},
    conditionImmunities: ['prone'],
    darkvision: 120, passivePerception: 22, languages: ['Deep Speech', 'Undercommon'],
    traits: [
      MonsterTrait(name: 'Antimagic Cone', description: '150 ft. cone. At start of turn, decides which way cone faces. Magic in cone doesn\'t function.'),
    ],
    actions: [
      MonsterAction(name: 'Bite', description: 'Melee Weapon Attack', attackBonus: 5, damage: '4d6', damageType: 'piercing'),
      MonsterAction(name: 'Eye Rays', description: 'Shoots three random eye rays at 1-3 targets within 120 feet.'),
    ],
    legendaryActionsPerRound: 3,
    legendaryActions: [
      MonsterAction(name: 'Eye Ray', description: 'Uses one random eye ray.'),
    ],
  );

  static Monster adultRedDragon() => Monster(
    id: 'adult_red_dragon', name: 'Adult Red Dragon', size: 'Huge', type: 'Dragon', alignment: 'Chaotic Evil',
    challengeRating: 17, experiencePoints: 18000,
    armorClass: 19, hitPoints: 256, hitDice: '19d12+133', speed: 40,
    strength: 27, dexterity: 10, constitution: 25, intelligence: 16, wisdom: 13, charisma: 21,
    savingThrows: {'Dexterity': 6, 'Constitution': 13, 'Wisdom': 7, 'Charisma': 11},
    skills: {'Perception': 13, 'Stealth': 6},
    damageImmunities: ['fire'],
    blindsight: 60, darkvision: 120, passivePerception: 23,
    languages: ['Common', 'Draconic'],
    traits: [MonsterTrait(name: 'Legendary Resistance (3/Day)', description: 'If fails save, can choose to succeed instead.')],
    actions: [
      MonsterAction(name: 'Multiattack', description: 'Can use Frightful Presence. Then makes three attacks: one bite and two claws.'),
      MonsterAction(name: 'Bite', description: 'Melee Weapon Attack', attackBonus: 14, damage: '2d10+8', damageType: 'piercing'),
      MonsterAction(name: 'Claw', description: 'Melee Weapon Attack', attackBonus: 14, damage: '2d6+8', damageType: 'slashing'),
      MonsterAction(name: 'Tail', description: 'Melee Weapon Attack', attackBonus: 14, damage: '2d8+8', damageType: 'bludgeoning'),
      MonsterAction(name: 'Frightful Presence', description: '120 ft. Each creature aware of dragon must succeed DC 19 Wisdom save or frightened for 1 minute.'),
      MonsterAction(name: 'Fire Breath', description: '60 ft. cone. Dexterity DC 21 save or 18d6 fire (half on success).', recharge: '5-6'),
    ],
    legendaryActionsPerRound: 3,
    legendaryActions: [
      MonsterAction(name: 'Detect', description: 'Makes Wisdom (Perception) check.'),
      MonsterAction(name: 'Tail Attack', description: 'Makes tail attack.'),
      MonsterAction(name: 'Wing Attack (Costs 2 Actions)', description: 'Beats wings. Each within 10 ft. makes DC 22 Dexterity save or takes 2d6+8 bludgeoning and knocked prone. Can fly half speed.'),
    ],
  );

  static Monster ancientRedDragon() => Monster(
    id: 'ancient_red_dragon', name: 'Ancient Red Dragon', size: 'Gargantuan', type: 'Dragon', alignment: 'Chaotic Evil',
    challengeRating: 24, experiencePoints: 62000,
    armorClass: 22, hitPoints: 546, hitDice: '28d20+252', speed: 40,
    strength: 30, dexterity: 10, constitution: 29, intelligence: 18, wisdom: 15, charisma: 23,
    savingThrows: {'Dexterity': 7, 'Constitution': 16, 'Wisdom': 9, 'Charisma': 13},
    skills: {'Perception': 16, 'Stealth': 7},
    damageImmunities: ['fire'],
    blindsight: 60, darkvision: 120, passivePerception: 26,
    languages: ['Common', 'Draconic'],
    traits: [MonsterTrait(name: 'Legendary Resistance (3/Day)', description: 'If fails save, can choose to succeed instead.')],
    actions: [
      MonsterAction(name: 'Multiattack', description: 'Can use Frightful Presence. Then makes three attacks: one bite and two claws.'),
      MonsterAction(name: 'Bite', description: 'Melee Weapon Attack', attackBonus: 17, damage: '2d10+10', damageType: 'piercing'),
      MonsterAction(name: 'Claw', description: 'Melee Weapon Attack', attackBonus: 17, damage: '2d6+10', damageType: 'slashing'),
      MonsterAction(name: 'Tail', description: 'Melee Weapon Attack', attackBonus: 17, damage: '2d8+10', damageType: 'bludgeoning'),
      MonsterAction(name: 'Frightful Presence', description: '120 ft. Each creature aware of dragon must succeed DC 21 Wisdom save or frightened for 1 minute.'),
      MonsterAction(name: 'Fire Breath', description: '90 ft. cone. Dexterity DC 24 save or 26d6 fire (half on success).', recharge: '5-6'),
    ],
    legendaryActionsPerRound: 3,
    legendaryActions: [
      MonsterAction(name: 'Detect', description: 'Makes Wisdom (Perception) check.'),
      MonsterAction(name: 'Tail Attack', description: 'Makes tail attack.'),
      MonsterAction(name: 'Wing Attack (Costs 2 Actions)', description: 'Beats wings. Each within 15 ft. makes DC 25 Dexterity save or takes 2d6+10 bludgeoning and knocked prone. Can fly half speed.'),
    ],
  );

  static Monster archmage() => Monster(
    id: 'archmage', name: 'Archmage', size: 'Medium', type: 'Humanoid', alignment: 'Any',
    challengeRating: 12, experiencePoints: 8400,
    armorClass: 12, hitPoints: 99, hitDice: '18d8+18', speed: 30,
    strength: 10, dexterity: 14, constitution: 12, intelligence: 20, wisdom: 15, charisma: 16,
    savingThrows: {'Intelligence': 9, 'Wisdom': 6},
    skills: {'Arcana': 13, 'History': 13},
    damageResistances: ['damage from spells', 'nonmagical weapons'],
    passivePerception: 12, languages: ['Any six languages'],
    traits: [
      MonsterTrait(name: 'Magic Resistance', description: 'Advantage on saves vs. spells and magical effects.'),
      MonsterTrait(name: 'Spellcasting', description: '18th-level spellcaster. Spell save DC 17, +9 to hit. Has access to powerful wizard spells.'),
    ],
    actions: [
      MonsterAction(name: 'Dagger', description: 'Melee or Ranged Weapon Attack', attackBonus: 6, damage: '1d4+2', damageType: 'piercing'),
      MonsterAction(name: 'Spellcasting', description: 'Casts one of many high-level wizard spells.'),
    ],
  );

  static Monster lich() => Monster(
    id: 'lich', name: 'Lich', size: 'Medium', type: 'Undead', alignment: 'Any Evil',
    challengeRating: 21, experiencePoints: 33000,
    armorClass: 17, hitPoints: 135, hitDice: '18d8+54', speed: 30,
    strength: 11, dexterity: 16, constitution: 16, intelligence: 20, wisdom: 14, charisma: 16,
    savingThrows: {'Constitution': 10, 'Intelligence': 12, 'Wisdom': 9},
    skills: {'Arcana': 18, 'History': 12, 'Insight': 9, 'Perception': 9},
    damageResistances: ['cold', 'lightning', 'necrotic'],
    damageImmunities: ['poison', 'nonmagical weapons'],
    conditionImmunities: ['charmed', 'exhaustion', 'frightened', 'paralyzed', 'poisoned'],
    truesight: 120, passivePerception: 19, languages: ['Common plus up to five other languages'],
    traits: [
      MonsterTrait(name: 'Legendary Resistance (3/Day)', description: 'If fails save, can choose to succeed instead.'),
      MonsterTrait(name: 'Rejuvenation', description: 'If has phylactery, reforms in 1d10 days.'),
      MonsterTrait(name: 'Turn Resistance', description: 'Advantage on saves vs. effects that turn undead.'),
      MonsterTrait(name: 'Spellcasting', description: '18th-level spellcaster. Spell save DC 20, +12 to hit.'),
    ],
    actions: [
      MonsterAction(name: 'Paralyzing Touch', description: 'Melee Spell Attack. DC 18 Constitution save or paralyzed for 1 minute. Can repeat save at end of turns.', attackBonus: 12, damage: '3d6', damageType: 'cold'),
      MonsterAction(name: 'Frightening Gaze', description: 'One creature within 10 feet. Wisdom DC 18 save or frightened for 1 minute.'),
      MonsterAction(name: 'Disrupt Life', description: '20 ft. radius. Each living creature takes 6d6 necrotic.', recharge: '5-6'),
    ],
    legendaryActionsPerRound: 3,
    legendaryActions: [
      MonsterAction(name: 'Cantrip', description: 'Casts cantrip.'),
      MonsterAction(name: 'Paralyzing Touch (Costs 2 Actions)', description: 'Uses Paralyzing Touch.'),
      MonsterAction(name: 'Frightening Gaze (Costs 2 Actions)', description: 'Uses Frightening Gaze.'),
      MonsterAction(name: 'Disrupt Life (Costs 3 Actions)', description: 'Uses Disrupt Life if available.'),
    ],
  );

  static Monster hornedDevil() => Monster(
    id: 'horned_devil', name: 'Horned Devil', size: 'Large', type: 'Fiend', alignment: 'Lawful Evil',
    challengeRating: 11, experiencePoints: 7200,
    armorClass: 18, hitPoints: 178, hitDice: '17d10+85', speed: 20,
    strength: 22, dexterity: 17, constitution: 21, intelligence: 12, wisdom: 16, charisma: 17,
    savingThrows: {'Strength': 10, 'Dexterity': 7, 'Wisdom': 7, 'Charisma': 7},
    damageResistances: ['cold', 'nonmagical weapons that aren\'t silvered'],
    damageImmunities: ['fire', 'poison'],
    conditionImmunities: ['poisoned'],
    darkvision: 120, passivePerception: 13, languages: ['Infernal', 'telepathy 120 ft.'],
    traits: [
      MonsterTrait(name: 'Devil\'s Sight', description: 'Magical darkness doesn\'t impede darkvision.'),
      MonsterTrait(name: 'Magic Resistance', description: 'Advantage on saves vs. spells and magical effects.'),
    ],
    actions: [
      MonsterAction(name: 'Multiattack', description: 'Makes three melee attacks: two fork and one tail. Can use Hurl Flame in place of any melee attack.'),
      MonsterAction(name: 'Fork', description: 'Melee Weapon Attack', attackBonus: 10, damage: '2d8+6', damageType: 'piercing'),
      MonsterAction(name: 'Tail', description: 'Melee Weapon Attack. DC 17 Constitution save or poisoned. Poisoned target can\'t regain HP and takes 3d6 poison at start of each turn.', attackBonus: 10, damage: '1d8+6', damageType: 'piercing'),
      MonsterAction(name: 'Hurl Flame', description: 'Ranged Spell Attack (150 ft.)', attackBonus: 7, damage: '4d6', damageType: 'fire'),
    ],
  );

  static Monster pitFiend() => Monster(
    id: 'pit_fiend', name: 'Pit Fiend', size: 'Large', type: 'Fiend', alignment: 'Lawful Evil',
    challengeRating: 20, experiencePoints: 25000,
    armorClass: 19, hitPoints: 300, hitDice: '24d10+168', speed: 30,
    strength: 26, dexterity: 14, constitution: 24, intelligence: 22, wisdom: 18, charisma: 24,
    savingThrows: {'Dexterity': 8, 'Constitution': 13, 'Wisdom': 10},
    damageResistances: ['cold', 'nonmagical weapons that aren\'t silvered'],
    damageImmunities: ['fire', 'poison'],
    conditionImmunities: ['poisoned'],
    truesight: 120, passivePerception: 14, languages: ['Infernal', 'telepathy 120 ft.'],
    traits: [
      MonsterTrait(name: 'Fear Aura', description: 'Creatures starting turn within 20 feet must succeed DC 21 Wisdom save or frightened for 1 minute.'),
      MonsterTrait(name: 'Magic Resistance', description: 'Advantage on saves vs. spells and magical effects.'),
      MonsterTrait(name: 'Magic Weapons', description: 'Weapon attacks are magical.'),
      MonsterTrait(name: 'Innate Spellcasting', description: 'Can cast fireball at will, hold monster, wall of fire.'),
    ],
    actions: [
      MonsterAction(name: 'Multiattack', description: 'Makes four attacks: one bite, one claw, one mace, one tail.'),
      MonsterAction(name: 'Bite', description: 'Melee Weapon Attack', attackBonus: 14, damage: '4d6+8', damageType: 'piercing'),
      MonsterAction(name: 'Claw', description: 'Melee Weapon Attack', attackBonus: 14, damage: '2d8+8', damageType: 'slashing'),
      MonsterAction(name: 'Mace', description: 'Melee Weapon Attack', attackBonus: 14, damage: '2d6+8', damageType: 'bludgeoning'),
      MonsterAction(name: 'Tail', description: 'Melee Weapon Attack. DC 21 Constitution save or poisoned.', attackBonus: 14, damage: '3d10+8', damageType: 'bludgeoning'),
    ],
  );

  static Monster tarrasque() => Monster(
    id: 'tarrasque', name: 'Tarrasque', size: 'Gargantuan', type: 'Monstrosity', alignment: 'Unaligned',
    challengeRating: 30, experiencePoints: 155000,
    armorClass: 25, hitPoints: 676, hitDice: '33d20+330', speed: 40,
    strength: 30, dexterity: 11, constitution: 30, intelligence: 3, wisdom: 11, charisma: 11,
    savingThrows: {'Intelligence': 5, 'Wisdom': 9, 'Charisma': 9},
    damageImmunities: ['fire', 'poison', 'nonmagical weapons'],
    conditionImmunities: ['charmed', 'frightened', 'paralyzed', 'poisoned'],
    blindsight: 120, passivePerception: 10, languages: [],
    traits: [
      MonsterTrait(name: 'Legendary Resistance (3/Day)', description: 'If fails save, can choose to succeed instead.'),
      MonsterTrait(name: 'Magic Resistance', description: 'Advantage on saves vs. spells and magical effects.'),
      MonsterTrait(name: 'Reflective Carapace', description: 'Any time tarrasque is targeted by magic missile, line spell, or spell requiring ranged attack roll, roll d6. On 1-5, unaffected. On 6, unaffected and effect reflected at caster.'),
      MonsterTrait(name: 'Siege Monster', description: 'Deals double damage to objects and structures.'),
    ],
    actions: [
      MonsterAction(name: 'Multiattack', description: 'Makes five attacks: one bite, two claws, one horns, one tail. Can use Swallow instead of bite.'),
      MonsterAction(name: 'Bite', description: 'Melee Weapon Attack. If target is Medium or smaller creature, it is grappled (escape DC 20).', attackBonus: 19, damage: '4d12+10', damageType: 'piercing'),
      MonsterAction(name: 'Claw', description: 'Melee Weapon Attack', attackBonus: 19, damage: '4d8+10', damageType: 'slashing'),
      MonsterAction(name: 'Horns', description: 'Melee Weapon Attack', attackBonus: 19, damage: '4d10+10', damageType: 'piercing'),
      MonsterAction(name: 'Tail', description: 'Melee Weapon Attack. DC 20 Strength save or knocked prone.', attackBonus: 19, damage: '4d6+10', damageType: 'bludgeoning'),
      MonsterAction(name: 'Swallow', description: 'Makes one bite attack against Medium or smaller grappled creature. If hits, creature swallowed and grapple ends. Takes 16d6 acid at start of each tarrasque turn.'),
    ],
    legendaryActionsPerRound: 3,
    legendaryActions: [
      MonsterAction(name: 'Attack', description: 'Makes one claw or tail attack.'),
      MonsterAction(name: 'Move', description: 'Moves up to half speed.'),
      MonsterAction(name: 'Chomp (Costs 2 Actions)', description: 'Makes one bite attack or uses Swallow.'),
    ],
  );

  // ==================== UTILITY METHODS ====================

  static List<Monster> getAllMonsters() {
    return [
      // CR 0-1/4
      rat(), cat(), giantRat(), bat(), stirge(),
      goblin(), kobold(), skeleton(), zombie(), wolf(), giantSpider(),
      // CR 1/2-2
      orc(), hobgoblin(), bear(), shadow(), crocodile(),
      direwolf(), bugbear(), ghoul(), specter(),
      ghast(), gargoyle(), ogre(), griffon(),
      // CR 3-6
      werewolf(), owlbear(), minotaur(), basilisk(), manticore(), mummy(), nightmare(),
      troll(), hillGiant(), wraith(), wyvern(), chimera(), medusa(),
      // CR 7-13
      youngBlackDragon(), mindFlayer(), youngRedDragon(), aboleth(), stoneGolem(),
      archmage(), beholder(), vampire(),
      // CR 14-30
      adultRedDragon(), hornedDevil(), pitFiend(), lich(), ancientRedDragon(), tarrasque(),
    ];
  }

  static List<Monster> getMonstersByCR(double minCR, double maxCR) {
    return getAllMonsters()
        .where((m) => m.challengeRating >= minCR && m.challengeRating <= maxCR)
        .toList();
  }

  static Monster? getRandomMonsterByCR(double minCR, double maxCR) {
    List<Monster> filtered = getMonstersByCR(minCR, maxCR);
    if (filtered.isEmpty) return goblin(); // Fallback
    filtered.shuffle();
    return filtered.first;
  }

  static List<Monster> getMonstersByType(String type) {
    return getAllMonsters().where((m) => m.type == type).toList();
  }
}
