import 'dart:math';
import 'package:flutter/material.dart';

enum DiceType {
  d4(4, '🔺', Colors.green),
  d6(6, '🎲', Colors.blue),
  d8(8, '🔷', Colors.purple),
  d10(10, '🔟', Colors.orange),
  d12(12, '🌟', Colors.pink),
  d20(20, '⭐', Colors.red);

  final int sides;
  final String emoji;
  final Color color;

  const DiceType(this.sides, this.emoji, this.color);
}

class DiceRollResult {
  final DiceType diceType;
  final List<int> rolls;
  final int modifier;
  final int total;
  final bool isCritical;
  final bool isCriticalFail;

  DiceRollResult({
    required this.diceType,
    required this.rolls,
    required this.modifier,
  })  : total = rolls.fold(0, (sum, roll) => sum + roll) + modifier,
        isCritical = rolls.length == 1 && rolls[0] == diceType.sides,
        isCriticalFail = rolls.length == 1 && rolls[0] == 1;

  String get formula => '${rolls.length}d${diceType.sides}${modifier >= 0 ? '+' : ''}${modifier != 0 ? modifier : ''}';
}

class DiceRollerWidget extends StatefulWidget {
  final Function(DiceRollResult)? onRollComplete;

  const DiceRollerWidget({
    Key? key,
    this.onRollComplete,
  }) : super(key: key);

  @override
  State<DiceRollerWidget> createState() => _DiceRollerWidgetState();
}

class _DiceRollerWidgetState extends State<DiceRollerWidget>
    with TickerProviderStateMixin {
  final Random _rng = Random();

  DiceType _selectedDice = DiceType.d20;
  int _numberOfDice = 1;
  int _modifier = 0;

  DiceRollResult? _lastResult;
  bool _isRolling = false;

  late AnimationController _shakeController;
  late AnimationController _resultController;
  late Animation<double> _shakeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _resultController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _shakeAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _resultController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _resultController.dispose();
    super.dispose();
  }

  Future<void> _rollDice() async {
    if (_isRolling) return;

    setState(() {
      _isRolling = true;
      _lastResult = null;
    });

    // Shake animation
    _shakeController.forward(from: 0);

    await Future.delayed(const Duration(milliseconds: 500));

    // Generate results
    List<int> rolls = List.generate(
      _numberOfDice,
      (_) => _rng.nextInt(_selectedDice.sides) + 1,
    );

    final result = DiceRollResult(
      diceType: _selectedDice,
      rolls: rolls,
      modifier: _modifier,
    );

    setState(() {
      _lastResult = result;
      _isRolling = false;
    });

    // Result pop-in animation
    _resultController.forward(from: 0);

    widget.onRollComplete?.call(result);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDiceSelector(),
        const SizedBox(height: 24),
        _buildQuantityAndModifier(),
        const SizedBox(height: 24),
        _buildRollButton(),
        const SizedBox(height: 24),
        _buildResult(),
      ],
    );
  }

  Widget _buildDiceSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Dice Type',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: DiceType.values.map((dice) {
                bool isSelected = dice == _selectedDice;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDice = dice;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? dice.color.withOpacity(0.2)
                          : Colors.grey.shade100,
                      border: Border.all(
                        color: isSelected ? dice.color : Colors.grey.shade300,
                        width: isSelected ? 3 : 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          dice.emoji,
                          style: const TextStyle(fontSize: 32),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'd${dice.sides}',
                          style: TextStyle(
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? dice.color : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityAndModifier() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Number of Dice'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: _numberOfDice > 1
                            ? () => setState(() => _numberOfDice--)
                            : null,
                      ),
                      Text(
                        '$_numberOfDice',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: _numberOfDice < 20
                            ? () => setState(() => _numberOfDice++)
                            : null,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Modifier'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: _modifier > -10
                            ? () => setState(() => _modifier--)
                            : null,
                      ),
                      Text(
                        _modifier >= 0 ? '+$_modifier' : '$_modifier',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: _modifier < 20
                            ? () => setState(() => _modifier++)
                            : null,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRollButton() {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shakeAnimation.value * sin(_shakeController.value * 2 * pi * 5), 0),
          child: child,
        );
      },
      child: ElevatedButton.icon(
        onPressed: _isRolling ? null : _rollDice,
        icon: Text(
          _selectedDice.emoji,
          style: const TextStyle(fontSize: 32),
        ),
        label: Text(
          _isRolling ? 'Rolling...' : 'ROLL DICE',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          backgroundColor: _selectedDice.color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildResult() {
    if (_lastResult == null) {
      return const SizedBox.shrink();
    }

    Color resultColor;
    if (_lastResult!.isCritical) {
      resultColor = Colors.green;
    } else if (_lastResult!.isCriticalFail) {
      resultColor = Colors.red;
    } else {
      resultColor = _selectedDice.color;
    }

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Card(
        elevation: 8,
        color: resultColor.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: resultColor, width: 3),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              if (_lastResult!.isCritical)
                const Text(
                  '🎉 CRITICAL SUCCESS! 🎉',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                )
              else if (_lastResult!.isCriticalFail)
                const Text(
                  '💥 CRITICAL FAIL! 💥',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                _lastResult!.formula,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _lastResult!.rolls.map((roll) {
                  bool isMax = roll == _selectedDice.sides;
                  bool isMin = roll == 1;

                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isMax
                          ? Colors.green.withOpacity(0.2)
                          : isMin
                              ? Colors.red.withOpacity(0.2)
                              : Colors.grey.shade200,
                      border: Border.all(
                        color: isMax
                            ? Colors.green
                            : isMin
                                ? Colors.red
                                : Colors.grey.shade400,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$roll',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isMax
                            ? Colors.green.shade700
                            : isMin
                                ? Colors.red.shade700
                                : Colors.black,
                      ),
                    ),
                  );
                }).toList(),
              ),
              if (_lastResult!.modifier != 0) ...[
                const SizedBox(height: 16),
                Text(
                  'Modifier: ${_lastResult!.modifier >= 0 ? '+' : ''}${_lastResult!.modifier}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'TOTAL: ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${_lastResult!.total}',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: resultColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Quick roll buttons for common d20 checks
class QuickRollBar extends StatelessWidget {
  final Function(DiceRollResult) onRoll;
  final int modifier;

  const QuickRollBar({
    Key? key,
    required this.onRoll,
    this.modifier = 0,
  }) : super(key: key);

  void _quickRoll(DiceType dice, int count, int mod) {
    final rng = Random();
    final rolls = List.generate(count, (_) => rng.nextInt(dice.sides) + 1);

    final result = DiceRollResult(
      diceType: dice,
      rolls: rolls,
      modifier: mod,
    );

    onRoll(result);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildQuickButton(
          context,
          'D20',
          () => _quickRoll(DiceType.d20, 1, modifier),
          DiceType.d20.color,
        ),
        _buildQuickButton(
          context,
          'Advantage',
          () => _quickRoll(DiceType.d20, 2, modifier),
          Colors.green,
        ),
        _buildQuickButton(
          context,
          'Disadvantage',
          () => _quickRoll(DiceType.d20, 2, modifier),
          Colors.orange,
        ),
      ],
    );
  }

  Widget _buildQuickButton(
    BuildContext context,
    String label,
    VoidCallback onPressed,
    Color color,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: Text(label),
    );
  }
}
