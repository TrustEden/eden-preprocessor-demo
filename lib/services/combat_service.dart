import 'dart:math';
import '../models/character.dart';
import '../models/combat_state.dart';
import 'dice_service.dart';

class CombatService {
  final DiceService _dice = DiceService();

  CombatState startCombat(Character player, List<Enemy> enemies) {
    List<Combatant> combatants = [];

    // Player initiative
    int playerInit = _dice.rollD20(modifier: player.initiativeBonus).total;
    combatants.add(Combatant(
      id: 'player',
      name: player.name,
      isPlayer: true,
      initiative: playerInit,
      hpCurrent: player.hpCurrent,
      hpMax: player.hpMax,
      armorClass: player.armorClass,
      hasActed: false,
      conditions: [],
    ));

    // Enemy initiatives
    for (var enemy in enemies) {
      int enemyInit = _dice.rollD20(modifier: enemy.initiativeBonus).total;
      combatants.add(Combatant(
        id: enemy.id,
        name: enemy.name,
        isPlayer: false,
        initiative: enemyInit,
        hpCurrent: enemy.hp,
        hpMax: enemy.hp,
        armorClass: enemy.ac,
        hasActed: false,
        conditions: [],
      ));
    }

    // Sort by initiative (highest first)
    combatants.sort((a, b) => b.initiative.compareTo(a.initiative));

    return CombatState(
      currentRound: 1,
      currentTurnIndex: 0,
      combatants: combatants,
      combatLog: [
        'Combat begins!',
        'Initiative order:',
        ...combatants.map((c) => '  ${c.name}: ${c.initiative}'),
      ],
    );
  }

  AttackResult performAttack({
    required Character attacker,
    required Combatant target,
    bool advantage = false,
    bool disadvantage = false,
  }) {
    // Attack roll
    DiceResult attackRoll = _dice.rollD20(
      modifier: attacker.getAttackBonus(),
      advantage: advantage,
      disadvantage: disadvantage,
    );

    // Check if hit
    bool hits = attackRoll.total >= target.armorClass ||
        attackRoll.criticalSuccess;
    if (attackRoll.criticalFailure) hits = false;

    if (!hits) {
      return AttackResult(
        hit: false,
        attackRoll: attackRoll.dieRoll,
        attackTotal: attackRoll.total,
        damage: 0,
        critical: false,
      );
    }

    // Roll damage
    var weapon = attacker.equippedWeapon;
    String damageDice = weapon?.damageDice ?? "1d4"; // Unarmed strike

    var diceParts = damageDice.split('d');
    int numDice = int.parse(diceParts[0]);
    int dieSize = int.parse(diceParts[1]);

    // Double dice on crit
    if (attackRoll.criticalSuccess) {
      numDice *= 2;
    }

    int damageRoll = _dice.roll(numDice, dieSize);
    int totalDamage = damageRoll + attacker.strengthModifier;

    // Apply fighting style bonuses
    if (attacker.fightingStyle == "Dueling" &&
        weapon != null &&
        !(weapon.weaponProperties?.contains("two-handed") ?? false)) {
      totalDamage += 2;
    }

    return AttackResult(
      hit: true,
      attackRoll: attackRoll.dieRoll,
      attackTotal: attackRoll.total,
      damage: max(0, totalDamage), // Minimum 0 damage
      critical: attackRoll.criticalSuccess,
    );
  }

  AttackResult performEnemyAttack({
    required Enemy enemy,
    required Combatant target,
  }) {
    // Attack roll
    DiceResult attackRoll =
        _dice.rollD20(modifier: enemy.attackBonus);

    // Check if hit
    bool hits = attackRoll.total >= target.armorClass ||
        attackRoll.criticalSuccess;
    if (attackRoll.criticalFailure) hits = false;

    if (!hits) {
      return AttackResult(
        hit: false,
        attackRoll: attackRoll.dieRoll,
        attackTotal: attackRoll.total,
        damage: 0,
        critical: false,
      );
    }

    // Roll damage
    int damageRoll = _dice.rollDamage(enemy.attackDamage);

    // Double damage on crit
    if (attackRoll.criticalSuccess) {
      damageRoll *= 2;
    }

    return AttackResult(
      hit: true,
      attackRoll: attackRoll.dieRoll,
      attackTotal: attackRoll.total,
      damage: max(0, damageRoll),
      critical: attackRoll.criticalSuccess,
    );
  }

  void applyDamage(Combatant target, int damage) {
    target.hpCurrent = max(0, target.hpCurrent - damage);
  }

  void healDamage(Combatant target, int healing) {
    target.hpCurrent = min(target.hpMax, target.hpCurrent + healing);
  }

  void nextTurn(CombatState combat) {
    // Mark current combatant as having acted
    combat.combatants[combat.currentTurnIndex].hasActed = true;

    // Move to next combatant
    combat.currentTurnIndex++;

    // If end of round, start new round
    if (combat.currentTurnIndex >= combat.combatants.length) {
      combat.currentRound++;
      combat.currentTurnIndex = 0;

      // Reset hasActed for all
      for (var combatant in combat.combatants) {
        combatant.hasActed = false;
      }

      combat.combatLog.add('--- Round ${combat.currentRound} ---');
    }
  }

  bool isCombatOver(CombatState combat) {
    bool playerAlive =
        combat.combatants.any((c) => c.isPlayer && c.hpCurrent > 0);
    bool enemiesAlive =
        combat.combatants.any((c) => !c.isPlayer && c.hpCurrent > 0);

    return !playerAlive || !enemiesAlive;
  }

  String getCombatResult(CombatState combat) {
    bool playerAlive =
        combat.combatants.any((c) => c.isPlayer && c.hpCurrent > 0);
    return playerAlive ? "Victory!" : "Defeat!";
  }

  void addCombatLog(CombatState combat, String message) {
    combat.combatLog.add(message);
  }
}
