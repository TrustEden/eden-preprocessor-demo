class Item {
  String id;
  String name;
  String type; // "weapon", "armor", "consumable", "misc"
  int weight;
  int value; // in gold pieces

  // Weapon properties
  String? damageDice; // "1d8", "2d6", etc.
  String? damageType; // "slashing", "piercing", "bludgeoning"
  List<String>? weaponProperties; // "versatile", "two-handed", etc.

  // Armor properties
  int? armorBonus;
  String? armorType; // "light", "medium", "heavy", "shield"

  // Consumable properties
  String? effect; // "heal_2d4+2", etc.
  int? quantity;

  bool equipped;

  Item({
    required this.id,
    required this.name,
    required this.type,
    required this.weight,
    required this.value,
    this.damageDice,
    this.damageType,
    this.weaponProperties,
    this.armorBonus,
    this.armorType,
    this.effect,
    this.quantity,
    this.equipped = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type,
    'weight': weight,
    'value': value,
    'damageDice': damageDice,
    'damageType': damageType,
    'weaponProperties': weaponProperties,
    'armorBonus': armorBonus,
    'armorType': armorType,
    'effect': effect,
    'quantity': quantity,
    'equipped': equipped,
  };

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json['id'] as String,
    name: json['name'] as String,
    type: json['type'] as String,
    weight: json['weight'] as int,
    value: json['value'] as int,
    damageDice: json['damageDice'] as String?,
    damageType: json['damageType'] as String?,
    weaponProperties: (json['weaponProperties'] as List<dynamic>?)?.cast<String>(),
    armorBonus: json['armorBonus'] as int?,
    armorType: json['armorType'] as String?,
    effect: json['effect'] as String?,
    quantity: json['quantity'] as int?,
    equipped: json['equipped'] as bool? ?? false,
  );
}
