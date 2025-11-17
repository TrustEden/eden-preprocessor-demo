import 'tactical_map.dart';

class EnhancedCombatState {
  int currentRound;
  int currentTurnIndex;
  List<TacticalCombatant> combatants;
  List<String> combatLog;
  TacticalMap? tacticalMap; // Optional tactical grid
  Map<String, bool> hasUsedReaction; // Track reactions
  Map<String, int> movementRemaining; // Track movement

  EnhancedCombatState({
    required this.currentRound,
    required this.currentTurnIndex,
    required this.combatants,
    required this.combatLog,
    this.tacticalMap,
    Map<String, bool>? hasUsedReaction,
    Map<String, int>? movementRemaining,
  })  : hasUsedReaction = hasUsedReaction ?? {},
        movementRemaining = movementRemaining ?? {};

  TacticalCombatant get currentCombatant => combatants[currentTurnIndex];

  void startNewRound() {
    currentRound++;
    currentTurnIndex = 0;

    // Reset reactions and movement for all combatants
    for (var combatant in combatants) {
      hasUsedReaction[combatant.id] = false;
      movementRemaining[combatant.id] = combatant.speed;
      combatant.hasActed = false;
      combatant.hasBonusAction = true;
    }
  }

  void nextTurn() {
    currentTurnIndex++;
    if (currentTurnIndex >= combatants.length) {
      startNewRound();
    } else {
      String currentId = currentCombatant.id;
      hasUsedReaction[currentId] = false;
      movementRemaining[currentId] = currentCombatant.speed;
      currentCombatant.hasBonusAction = true;
    }
  }

  void moveCombatant(String combatantId, Position newPosition) {
    if (tacticalMap == null) return;

    Position? currentPos = tacticalMap!.getCombatantPosition(combatantId);
    if (currentPos == null) return;

    // Calculate movement cost
    List<Position> validMoves = tacticalMap!.getValidMoves(
      currentPos,
      movementRemaining[combatantId] ?? 0,
    );

    if (validMoves.contains(newPosition)) {
      // Check for opportunity attacks
      Map<String, Position> enemyPositions = {};
      for (var combatant in combatants) {
        if (combatant.id != combatantId && !combatant.isPlayer) {
          Position? pos = tacticalMap!.getCombatantPosition(combatant.id);
          if (pos != null) {
            enemyPositions[combatant.id] = pos;
          }
        }
      }

      var combatant = combatants.firstWhere((c) => c.id == combatantId);
      List<String> opportunityAttackers = OpportunityAttackManager.checkOpportunityAttacks(
        combatantId,
        currentPos,
        newPosition,
        enemyPositions,
        hasUsedReaction,
        combatant.hasDisengage,
      );

      if (opportunityAttackers.isNotEmpty) {
        for (var attackerId in opportunityAttackers) {
          combatLog.add('$attackerId makes an opportunity attack against $combatantId!');
          hasUsedReaction[attackerId] = true;
        }
      }

      // Calculate movement used
      int movementCost = currentPos.manhattanDistanceTo(newPosition);
      movementRemaining[combatantId] = (movementRemaining[combatantId] ?? 0) - movementCost;

      // Move the combatant
      tacticalMap!.moveCombatant(combatantId, newPosition);
      combatLog.add('$combatantId moves to position (${newPosition.x}, ${newPosition.y})');
    }
  }

  void removeDeadCombatants() {
    combatants.removeWhere((c) => c.hpCurrent <= 0);
  }

  bool isCombatOver() {
    bool playersAlive = combatants.any((c) => c.isPlayer && c.hpCurrent > 0);
    bool enemiesAlive = combatants.any((c) => !c.isPlayer && c.hpCurrent > 0);

    return !playersAlive || !enemiesAlive;
  }

  String getCombatResult() {
    bool playersAlive = combatants.any((c) => c.isPlayer && c.hpCurrent > 0);
    return playersAlive ? 'victory' : 'defeat';
  }

  Map<String, dynamic> toJson() => {
        'currentRound': currentRound,
        'currentTurnIndex': currentTurnIndex,
        'combatants': combatants.map((c) => c.toJson()).toList(),
        'combatLog': combatLog,
        'tacticalMap': tacticalMap?.toJson(),
        'hasUsedReaction': hasUsedReaction,
        'movementRemaining': movementRemaining,
      };

  factory EnhancedCombatState.fromJson(Map<String, dynamic> json) =>
      EnhancedCombatState(
        currentRound: json['currentRound'] as int,
        currentTurnIndex: json['currentTurnIndex'] as int,
        combatants: (json['combatants'] as List<dynamic>)
            .map((c) => TacticalCombatant.fromJson(c as Map<String, dynamic>))
            .toList(),
        combatLog: (json['combatLog'] as List<dynamic>).cast<String>(),
        tacticalMap: json['tacticalMap'] != null
            ? TacticalMap.fromJson(json['tacticalMap'] as Map<String, dynamic>)
            : null,
        hasUsedReaction:
            (json['hasUsedReaction'] as Map<String, dynamic>?)?.cast<String, bool>(),
        movementRemaining:
            (json['movementRemaining'] as Map<String, dynamic>?)?.cast<String, int>(),
      );
}

class TacticalCombatant {
  String id;
  String name;
  bool isPlayer;
  int initiative;
  int hpCurrent;
  int hpMax;
  int tempHp;
  int armorClass;
  int speed; // Movement speed in feet
  bool hasActed;
  bool hasBonusAction;
  bool hasDisengage; // Used Disengage action
  List<String> conditions; // "prone", "stunned", "paralyzed", etc.

  // Resistances and immunities
  List<String>? damageResistances;
  List<String>? damageImmunities;
  List<String>? conditionImmunities;

  TacticalCombatant({
    required this.id,
    required this.name,
    required this.isPlayer,
    required this.initiative,
    required this.hpCurrent,
    required this.hpMax,
    this.tempHp = 0,
    required this.armorClass,
    required this.speed,
    this.hasActed = false,
    this.hasBonusAction = true,
    this.hasDisengage = false,
    List<String>? conditions,
    this.damageResistances,
    this.damageImmunities,
    this.conditionImmunities,
  }) : conditions = conditions ?? [];

  void takeDamage(int damage, String damageType) {
    // Apply resistances/immunities
    if (damageImmunities?.contains(damageType) == true) {
      return; // No damage
    }

    if (damageResistances?.contains(damageType) == true) {
      damage = damage ~/ 2; // Half damage
    }

    // Apply to temp HP first
    if (tempHp > 0) {
      if (tempHp >= damage) {
        tempHp -= damage;
        return;
      } else {
        damage -= tempHp;
        tempHp = 0;
      }
    }

    // Apply remaining damage to HP
    hpCurrent -= damage;
    if (hpCurrent < 0) hpCurrent = 0;
  }

  void heal(int amount) {
    hpCurrent += amount;
    if (hpCurrent > hpMax) hpCurrent = hpMax;
  }

  void addCondition(String condition) {
    if (conditionImmunities?.contains(condition) == true) {
      return; // Immune to this condition
    }

    if (!conditions.contains(condition)) {
      conditions.add(condition);
    }
  }

  void removeCondition(String condition) {
    conditions.remove(condition);
  }

  bool hasCondition(String condition) {
    return conditions.contains(condition);
  }

  bool isIncapacitated() {
    return hasCondition('incapacitated') ||
        hasCondition('paralyzed') ||
        hasCondition('stunned') ||
        hasCondition('unconscious');
  }

  bool canTakeActions() {
    return !isIncapacitated();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'isPlayer': isPlayer,
        'initiative': initiative,
        'hpCurrent': hpCurrent,
        'hpMax': hpMax,
        'tempHp': tempHp,
        'armorClass': armorClass,
        'speed': speed,
        'hasActed': hasActed,
        'hasBonusAction': hasBonusAction,
        'hasDisengage': hasDisengage,
        'conditions': conditions,
        'damageResistances': damageResistances,
        'damageImmunities': damageImmunities,
        'conditionImmunities': conditionImmunities,
      };

  factory TacticalCombatant.fromJson(Map<String, dynamic> json) =>
      TacticalCombatant(
        id: json['id'] as String,
        name: json['name'] as String,
        isPlayer: json['isPlayer'] as bool,
        initiative: json['initiative'] as int,
        hpCurrent: json['hpCurrent'] as int,
        hpMax: json['hpMax'] as int,
        tempHp: json['tempHp'] as int? ?? 0,
        armorClass: json['armorClass'] as int,
        speed: json['speed'] as int,
        hasActed: json['hasActed'] as bool? ?? false,
        hasBonusAction: json['hasBonusAction'] as bool? ?? true,
        hasDisengage: json['hasDisengage'] as bool? ?? false,
        conditions: (json['conditions'] as List<dynamic>?)?.cast<String>(),
        damageResistances:
            (json['damageResistances'] as List<dynamic>?)?.cast<String>(),
        damageImmunities:
            (json['damageImmunities'] as List<dynamic>?)?.cast<String>(),
        conditionImmunities:
            (json['conditionImmunities'] as List<dynamic>?)?.cast<String>(),
      );
}

// Condition effects helper
class ConditionEffects {
  static bool hasAdvantageOnAttack(TacticalCombatant attacker, TacticalCombatant target) {
    // Attacker advantages
    if (attacker.hasCondition('invisible')) return true;

    // Target disadvantages (give attacker advantage)
    if (target.hasCondition('prone') ||
        target.hasCondition('paralyzed') ||
        target.hasCondition('stunned') ||
        target.hasCondition('unconscious')) {
      return true;
    }

    return false;
  }

  static bool hasDisadvantageOnAttack(TacticalCombatant attacker, TacticalCombatant target) {
    // Attacker disadvantages
    if (attacker.hasCondition('blinded') ||
        attacker.hasCondition('poisoned') ||
        attacker.hasCondition('frightened') ||
        attacker.hasCondition('restrained')) {
      return true;
    }

    // Target advantages (give attacker disadvantage)
    if (target.hasCondition('invisible')) return true;

    return false;
  }

  static bool autoFailsSave(TacticalCombatant combatant, String saveType) {
    if (combatant.hasCondition('paralyzed') ||
        combatant.hasCondition('stunned')) {
      return saveType == 'Strength' || saveType == 'Dexterity';
    }
    return false;
  }

  static bool canMove(TacticalCombatant combatant) {
    return !combatant.hasCondition('paralyzed') &&
        !combatant.hasCondition('stunned') &&
        !combatant.hasCondition('unconscious') &&
        !combatant.hasCondition('grappled') &&
        !combatant.hasCondition('restrained');
  }

  static int getSpeedModifier(TacticalCombatant combatant) {
    if (combatant.hasCondition('prone')) return -1; // Half speed to stand up
    return 0;
  }
}
