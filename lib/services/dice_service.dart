import 'dart:math';

class DiceService {
  final Random _random = Random();

  int roll(int numDice, int dieSize, {int modifier = 0}) {
    int total = modifier;
    for (int i = 0; i < numDice; i++) {
      total += _random.nextInt(dieSize) + 1;
    }
    return total;
  }

  DiceResult rollD20(
      {int modifier = 0, bool advantage = false, bool disadvantage = false}) {
    if (advantage && disadvantage) {
      // Cancel out
      advantage = false;
      disadvantage = false;
    }

    int roll1 = _random.nextInt(20) + 1;
    int roll2 = advantage || disadvantage ? _random.nextInt(20) + 1 : roll1;

    int finalRoll = roll1;
    if (advantage) finalRoll = max(roll1, roll2);
    if (disadvantage) finalRoll = min(roll1, roll2);

    return DiceResult(
      dieRoll: finalRoll,
      modifier: modifier,
      total: finalRoll + modifier,
      advantage: advantage,
      disadvantage: disadvantage,
      criticalSuccess: finalRoll == 20,
      criticalFailure: finalRoll == 1,
      roll2: roll2 != roll1 ? roll2 : null,
    );
  }

  List<int> rollMultiple(int numDice, int dieSize) {
    return List.generate(numDice, (_) => _random.nextInt(dieSize) + 1);
  }

  /// Parse damage dice string like "1d8", "2d6+3", "1d4-1"
  int rollDamage(String diceString) {
    // Parse strings like "1d8+2" or "2d6"
    final regex = RegExp(r'(\d+)d(\d+)([+-]\d+)?');
    final match = regex.firstMatch(diceString);

    if (match == null) {
      return 0;
    }

    int numDice = int.parse(match.group(1)!);
    int dieSize = int.parse(match.group(2)!);
    int modifier = 0;

    if (match.group(3) != null) {
      modifier = int.parse(match.group(3)!);
    }

    return roll(numDice, dieSize, modifier: modifier);
  }
}

class DiceResult {
  final int dieRoll;
  final int modifier;
  final int total;
  final bool advantage;
  final bool disadvantage;
  final bool criticalSuccess;
  final bool criticalFailure;
  final int? roll2; // Second roll if advantage/disadvantage

  DiceResult({
    required this.dieRoll,
    required this.modifier,
    required this.total,
    this.advantage = false,
    this.disadvantage = false,
    this.criticalSuccess = false,
    this.criticalFailure = false,
    this.roll2,
  });

  String get description {
    String result = 'Rolled $dieRoll';
    if (roll2 != null) {
      result += ' and $roll2';
      if (advantage) result += ' (advantage)';
      if (disadvantage) result += ' (disadvantage)';
    }
    if (modifier != 0) {
      result += ' ${modifier >= 0 ? '+' : ''}$modifier';
    }
    result += ' = $total';
    if (criticalSuccess) result += ' CRITICAL SUCCESS!';
    if (criticalFailure) result += ' CRITICAL FAILURE!';
    return result;
  }
}
