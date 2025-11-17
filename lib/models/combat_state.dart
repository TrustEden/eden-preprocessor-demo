class CombatState {
  int currentRound;
  int currentTurnIndex;
  List<Combatant> combatants;
  List<String> combatLog;

  CombatState({
    required this.currentRound,
    required this.currentTurnIndex,
    required this.combatants,
    required this.combatLog,
  });

  Combatant get currentCombatant => combatants[currentTurnIndex];

  Map<String, dynamic> toJson() => {
    'currentRound': currentRound,
    'currentTurnIndex': currentTurnIndex,
    'combatants': combatants.map((c) => c.toJson()).toList(),
    'combatLog': combatLog,
  };

  factory CombatState.fromJson(Map<String, dynamic> json) => CombatState(
    currentRound: json['currentRound'] as int,
    currentTurnIndex: json['currentTurnIndex'] as int,
    combatants: (json['combatants'] as List<dynamic>)
        .map((c) => Combatant.fromJson(c as Map<String, dynamic>))
        .toList(),
    combatLog: (json['combatLog'] as List<dynamic>).cast<String>(),
  );
}

class Combatant {
  String id;
  String name;
  bool isPlayer;
  int initiative;
  int hpCurrent;
  int hpMax;
  int armorClass;
  bool hasActed;
  List<String> conditions; // "prone", "stunned", etc.

  Combatant({
    required this.id,
    required this.name,
    required this.isPlayer,
    required this.initiative,
    required this.hpCurrent,
    required this.hpMax,
    required this.armorClass,
    this.hasActed = false,
    List<String>? conditions,
  }) : conditions = conditions ?? [];

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'isPlayer': isPlayer,
    'initiative': initiative,
    'hpCurrent': hpCurrent,
    'hpMax': hpMax,
    'armorClass': armorClass,
    'hasActed': hasActed,
    'conditions': conditions,
  };

  factory Combatant.fromJson(Map<String, dynamic> json) => Combatant(
    id: json['id'] as String,
    name: json['name'] as String,
    isPlayer: json['isPlayer'] as bool,
    initiative: json['initiative'] as int,
    hpCurrent: json['hpCurrent'] as int,
    hpMax: json['hpMax'] as int,
    armorClass: json['armorClass'] as int,
    hasActed: json['hasActed'] as bool? ?? false,
    conditions: (json['conditions'] as List<dynamic>?)?.cast<String>(),
  );
}

class Enemy {
  String id;
  String name;
  int hp;
  int ac;
  int initiativeBonus;
  int attackBonus;
  String attackDamage; // e.g., "1d6+2"

  Enemy({
    required this.id,
    required this.name,
    required this.hp,
    required this.ac,
    required this.initiativeBonus,
    required this.attackBonus,
    required this.attackDamage,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'hp': hp,
    'ac': ac,
    'initiativeBonus': initiativeBonus,
    'attackBonus': attackBonus,
    'attackDamage': attackDamage,
  };

  factory Enemy.fromJson(Map<String, dynamic> json) => Enemy(
    id: json['id'] as String,
    name: json['name'] as String,
    hp: json['hp'] as int,
    ac: json['ac'] as int,
    initiativeBonus: json['initiativeBonus'] as int,
    attackBonus: json['attackBonus'] as int,
    attackDamage: json['attackDamage'] as String,
  );
}

class AttackResult {
  final bool hit;
  final int attackRoll;
  final int attackTotal;
  final int damage;
  final bool critical;

  AttackResult({
    required this.hit,
    required this.attackRoll,
    required this.attackTotal,
    required this.damage,
    required this.critical,
  });
}
