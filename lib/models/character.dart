import 'dart:math';
import 'item.dart';

class Character {
  String id;
  String name;

  // Fixed for MVP
  String race; // Human only for simplicity
  String className; // "Fighter"
  int level;
  int experience;

  // Ability Scores
  int strength;
  int dexterity;
  int constitution;
  int intelligence;
  int wisdom;
  int charisma;

  // Combat Stats
  int hpCurrent;
  int hpMax;
  int armorClass;
  int initiativeBonus;
  int proficiencyBonus;

  // Fighter-specific
  int secondWindUses; // 1 per short rest
  int actionSurgeUses; // 1 per short rest at level 2
  String fightingStyle; // "Defense", "Dueling", "Great Weapon Fighting"

  // Equipment
  List<Item> inventory;
  Item? equippedWeapon;
  Item? equippedArmor;
  Item? equippedShield;

  // Skills (simplified - just the Fighter proficiencies)
  bool athleticsProficient;
  bool perceptionProficient;
  bool survivalProficient;
  bool intimidationProficient;

  Character({
    required this.id,
    required this.name,
    required this.race,
    required this.className,
    required this.level,
    required this.experience,
    required this.strength,
    required this.dexterity,
    required this.constitution,
    required this.intelligence,
    required this.wisdom,
    required this.charisma,
    required this.hpCurrent,
    required this.hpMax,
    required this.armorClass,
    required this.proficiencyBonus,
    required this.secondWindUses,
    required this.actionSurgeUses,
    required this.fightingStyle,
    List<Item>? inventory,
    this.equippedWeapon,
    this.equippedArmor,
    this.equippedShield,
    this.athleticsProficient = true,
    this.perceptionProficient = true,
    this.survivalProficient = false,
    this.intimidationProficient = false,
  }) : inventory = inventory ?? [],
       initiativeBonus = (dexterity - 10) ~/ 2;

  // Calculated properties
  int get strengthModifier => (strength - 10) ~/ 2;
  int get dexterityModifier => (dexterity - 10) ~/ 2;
  int get constitutionModifier => (constitution - 10) ~/ 2;
  int get intelligenceModifier => (intelligence - 10) ~/ 2;
  int get wisdomModifier => (wisdom - 10) ~/ 2;
  int get charismaModifier => (charisma - 10) ~/ 2;

  int getSkillModifier(String skill) {
    int baseModifier = 0;
    bool proficient = false;

    switch (skill.toLowerCase()) {
      case 'athletics':
        baseModifier = strengthModifier;
        proficient = athleticsProficient;
        break;
      case 'acrobatics':
        baseModifier = dexterityModifier;
        break;
      case 'sleight of hand':
        baseModifier = dexterityModifier;
        break;
      case 'stealth':
        baseModifier = dexterityModifier;
        break;
      case 'arcana':
        baseModifier = intelligenceModifier;
        break;
      case 'history':
        baseModifier = intelligenceModifier;
        break;
      case 'investigation':
        baseModifier = intelligenceModifier;
        break;
      case 'nature':
        baseModifier = intelligenceModifier;
        break;
      case 'religion':
        baseModifier = intelligenceModifier;
        break;
      case 'animal handling':
        baseModifier = wisdomModifier;
        break;
      case 'insight':
        baseModifier = wisdomModifier;
        break;
      case 'medicine':
        baseModifier = wisdomModifier;
        break;
      case 'perception':
        baseModifier = wisdomModifier;
        proficient = perceptionProficient;
        break;
      case 'survival':
        baseModifier = wisdomModifier;
        proficient = survivalProficient;
        break;
      case 'deception':
        baseModifier = charismaModifier;
        break;
      case 'intimidation':
        baseModifier = charismaModifier;
        proficient = intimidationProficient;
        break;
      case 'performance':
        baseModifier = charismaModifier;
        break;
      case 'persuasion':
        baseModifier = charismaModifier;
        break;
    }

    return baseModifier + (proficient ? proficiencyBonus : 0);
  }

  int getAttackBonus() {
    // Strength mod + proficiency (fighters are proficient with all weapons)
    return strengthModifier + proficiencyBonus;
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
      // Heavy armor doesn't add dex mod (already in armorBonus)
    } else {
      // No armor - use 10 + dex mod
      ac = 10 + dexterityModifier;
    }

    // Add shield bonus
    if (equippedShield != null) {
      ac += equippedShield!.armorBonus ?? 0;
    }

    // Apply Defense fighting style bonus
    if (fightingStyle == 'Defense' && equippedArmor != null) {
      ac += 1;
    }

    armorClass = ac;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'race': race,
    'className': className,
    'level': level,
    'experience': experience,
    'strength': strength,
    'dexterity': dexterity,
    'constitution': constitution,
    'intelligence': intelligence,
    'wisdom': wisdom,
    'charisma': charisma,
    'hpCurrent': hpCurrent,
    'hpMax': hpMax,
    'armorClass': armorClass,
    'initiativeBonus': initiativeBonus,
    'proficiencyBonus': proficiencyBonus,
    'secondWindUses': secondWindUses,
    'actionSurgeUses': actionSurgeUses,
    'fightingStyle': fightingStyle,
    'inventory': inventory.map((i) => i.toJson()).toList(),
    'equippedWeapon': equippedWeapon?.toJson(),
    'equippedArmor': equippedArmor?.toJson(),
    'equippedShield': equippedShield?.toJson(),
    'athleticsProficient': athleticsProficient,
    'perceptionProficient': perceptionProficient,
    'survivalProficient': survivalProficient,
    'intimidationProficient': intimidationProficient,
  };

  factory Character.fromJson(Map<String, dynamic> json) {
    var char = Character(
      id: json['id'] as String,
      name: json['name'] as String,
      race: json['race'] as String,
      className: json['className'] as String,
      level: json['level'] as int,
      experience: json['experience'] as int,
      strength: json['strength'] as int,
      dexterity: json['dexterity'] as int,
      constitution: json['constitution'] as int,
      intelligence: json['intelligence'] as int,
      wisdom: json['wisdom'] as int,
      charisma: json['charisma'] as int,
      hpCurrent: json['hpCurrent'] as int,
      hpMax: json['hpMax'] as int,
      armorClass: json['armorClass'] as int,
      proficiencyBonus: json['proficiencyBonus'] as int,
      secondWindUses: json['secondWindUses'] as int,
      actionSurgeUses: json['actionSurgeUses'] as int,
      fightingStyle: json['fightingStyle'] as String,
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
      athleticsProficient: json['athleticsProficient'] as bool? ?? true,
      perceptionProficient: json['perceptionProficient'] as bool? ?? true,
      survivalProficient: json['survivalProficient'] as bool? ?? false,
      intimidationProficient: json['intimidationProficient'] as bool? ?? false,
    );
    return char;
  }
}
