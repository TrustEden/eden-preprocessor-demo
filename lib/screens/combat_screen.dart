import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../models/combat_state.dart';
import '../services/combat_service.dart';
import '../services/claude_service.dart';
import '../services/database_service.dart';
import '../services/experience_service.dart';

class CombatScreen extends StatefulWidget {
  final GameState gameState;
  final List<Enemy> enemies;
  final ClaudeService claudeService;

  const CombatScreen({
    Key? key,
    required this.gameState,
    required this.enemies,
    required this.claudeService,
  }) : super(key: key);

  @override
  _CombatScreenState createState() => _CombatScreenState();
}

class _CombatScreenState extends State<CombatScreen> {
  final CombatService _combat = CombatService();
  final DatabaseService _db = DatabaseService();
  final ExperienceService _xp = ExperienceService();

  late CombatState _combatState;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _combatState = _combat.startCombat(widget.gameState.character, widget.enemies);
    widget.gameState.activeCombat = _combatState;

    // If first turn is enemy, process it
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!_combatState.currentCombatant.isPlayer) {
        _processEnemyTurn();
      }
    });
  }

  Future<void> _performAttack() async {
    if (_isProcessing) return;

    setState(() => _isProcessing = true);

    try {
      var currentCombatant = _combatState.currentCombatant;
      if (!currentCombatant.isPlayer) return;

      // Find first alive enemy
      var target = _combatState.combatants.firstWhere(
        (c) => !c.isPlayer && c.hpCurrent > 0,
      );

      // Perform attack
      var result = _combat.performAttack(
        attacker: widget.gameState.character,
        target: target,
      );

      // Add to combat log
      if (result.hit) {
        _combat.addCombatLog(
          _combatState,
          '${currentCombatant.name} attacks ${target.name}: rolled ${result.attackTotal} vs AC ${target.armorClass} - HIT!',
        );
        _combat.applyDamage(target, result.damage);
        _combat.addCombatLog(
          _combatState,
          '  ${target.name} takes ${result.damage} damage${result.critical ? " (CRITICAL!)" : ""}!',
        );

        if (target.hpCurrent <= 0) {
          _combat.addCombatLog(_combatState, '  ${target.name} is defeated!');
        }
      } else {
        _combat.addCombatLog(
          _combatState,
          '${currentCombatant.name} attacks ${target.name}: rolled ${result.attackTotal} vs AC ${target.armorClass} - MISS!',
        );
      }

      // Update character HP (in case it changed)
      var playerCombatant = _combatState.combatants.firstWhere((c) => c.isPlayer);
      widget.gameState.character.hpCurrent = playerCombatant.hpCurrent;

      // Check if combat is over
      if (_combat.isCombatOver(_combatState)) {
        await _endCombat();
        return;
      }

      // Next turn
      _combat.nextTurn(_combatState);

      // Save state
      await _db.saveGameState(widget.gameState);

      setState(() {});

      // If next turn is enemy, process it
      if (!_combatState.currentCombatant.isPlayer) {
        await Future.delayed(const Duration(milliseconds: 500));
        await _processEnemyTurn();
      }
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  Future<void> _processEnemyTurn() async {
    if (_combat.isCombatOver(_combatState)) {
      await _endCombat();
      return;
    }

    setState(() => _isProcessing = true);

    try {
      var currentCombatant = _combatState.currentCombatant;
      var enemy = widget.enemies.firstWhere((e) => e.id == currentCombatant.id);
      var playerCombatant = _combatState.combatants.firstWhere((c) => c.isPlayer);

      // Get enemy action from Claude (simplified for MVP - always attack)
      String action = 'ATTACK';

      if (action == 'ATTACK') {
        var result = _combat.performEnemyAttack(
          enemy: enemy,
          target: playerCombatant,
        );

        if (result.hit) {
          _combat.addCombatLog(
            _combatState,
            '${currentCombatant.name} attacks you: rolled ${result.attackTotal} vs AC ${playerCombatant.armorClass} - HIT!',
          );
          _combat.applyDamage(playerCombatant, result.damage);
          _combat.addCombatLog(
            _combatState,
            '  You take ${result.damage} damage${result.critical ? " (CRITICAL!)" : ""}!',
          );

          // Update character HP
          widget.gameState.character.hpCurrent = playerCombatant.hpCurrent;

          if (playerCombatant.hpCurrent <= 0) {
            _combat.addCombatLog(_combatState, '  You have been defeated!');
          }
        } else {
          _combat.addCombatLog(
            _combatState,
            '${currentCombatant.name} attacks you: rolled ${result.attackTotal} vs AC ${playerCombatant.armorClass} - MISS!',
          );
        }
      }

      // Check if combat is over
      if (_combat.isCombatOver(_combatState)) {
        await _endCombat();
        return;
      }

      // Next turn
      _combat.nextTurn(_combatState);

      // Save state
      await _db.saveGameState(widget.gameState);

      setState(() {});

      // If next turn is also enemy, continue
      if (!_combatState.currentCombatant.isPlayer) {
        await Future.delayed(const Duration(milliseconds: 1000));
        await _processEnemyTurn();
      }
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  Future<void> _endCombat() async {
    String result = _combat.getCombatResult(_combatState);
    bool victory = result == "Victory!";

    // Award XP if victory
    if (victory) {
      int xpReward = widget.enemies.length * 50; // Simple XP calculation
      var messages = _xp.awardXP(widget.gameState.character, xpReward);

      widget.gameState.narrativeHistory.add(GameEvent(
        eventType: 'combat',
        description: 'Combat ended - $result - Gained $xpReward XP',
      ));

      for (var msg in messages) {
        widget.gameState.narrativeHistory.add(GameEvent(
          eventType: 'level_up',
          description: msg,
        ));
      }
    } else {
      widget.gameState.narrativeHistory.add(GameEvent(
        eventType: 'combat',
        description: 'Combat ended - $result',
      ));
    }

    // Clear combat state
    widget.gameState.activeCombat = null;
    await _db.saveGameState(widget.gameState);

    if (!mounted) return;

    // Show result dialog
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(result),
        content: Text(
          victory
              ? 'You have defeated your enemies!'
              : 'You have been defeated!',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Return to main game screen
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var currentCombatant = _combatState.currentCombatant;
    bool isPlayerTurn = currentCombatant.isPlayer;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Combat'),
        backgroundColor: Colors.red[700],
        automaticallyImplyLeading: false,
      ),
      body: Row(
        children: [
          // Combat log area
          Expanded(
            flex: 2,
            child: Column(
              children: [
                // Combat log
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: ListView.builder(
                      itemCount: _combatState.combatLog.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(_combatState.combatLog[index]),
                        );
                      },
                    ),
                  ),
                ),

                // Action buttons
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.grey[300]!)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: isPlayerTurn && !_isProcessing
                              ? _performAttack
                              : null,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                            backgroundColor: Colors.red[700],
                          ),
                          child: const Text('Attack'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Initiative tracker sidebar
          Container(
            width: 300,
            decoration: BoxDecoration(
              border: Border(left: BorderSide(color: Colors.grey[300]!)),
              color: Colors.grey[50],
            ),
            child: _buildInitiativeTracker(),
          ),
        ],
      ),
    );
  }

  Widget _buildInitiativeTracker() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Round ${_combatState.currentRound}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          const Text(
            'Initiative Order:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...List.generate(_combatState.combatants.length, (index) {
            var combatant = _combatState.combatants[index];
            bool isCurrent = index == _combatState.currentTurnIndex;

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isCurrent ? Colors.yellow[100] : Colors.white,
                border: Border.all(
                  color: isCurrent ? Colors.orange : Colors.grey[300]!,
                  width: isCurrent ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        combatant.name,
                        style: TextStyle(
                          fontWeight:
                              isCurrent ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      Text('Init: ${combatant.initiative}'),
                    ],
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: combatant.hpCurrent / combatant.hpMax,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      combatant.hpCurrent > combatant.hpMax / 2
                          ? Colors.green
                          : combatant.hpCurrent > combatant.hpMax / 4
                              ? Colors.orange
                              : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'HP: ${combatant.hpCurrent}/${combatant.hpMax}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
