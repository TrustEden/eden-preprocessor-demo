import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_state.dart';
import '../models/combat_state.dart';
import '../services/claude_service.dart';
import '../services/dice_service.dart';
import '../services/database_service.dart';
import '../services/experience_service.dart';
import 'combat_screen.dart';
import 'character_sheet_screen.dart';

class MainGameScreen extends StatefulWidget {
  final GameState gameState;

  const MainGameScreen({Key? key, required this.gameState}) : super(key: key);

  @override
  _MainGameScreenState createState() => _MainGameScreenState();
}

class _MainGameScreenState extends State<MainGameScreen> {
  final _actionController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isProcessing = false;

  late ClaudeService _claude;
  final DiceService _dice = DiceService();
  final DatabaseService _db = DatabaseService();
  final ExperienceService _xp = ExperienceService();

  String? _apiKey;

  @override
  void initState() {
    super.initState();
    _loadApiKey();
  }

  Future<void> _loadApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    _apiKey = prefs.getString('claude_api_key');

    if (_apiKey == null || _apiKey!.isEmpty) {
      // Show dialog to enter API key
      if (!mounted) return;
      _showApiKeyDialog();
    } else {
      _claude = ClaudeService(apiKey: _apiKey!);
    }
  }

  Future<void> _showApiKeyDialog() async {
    final controller = TextEditingController();

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Claude API Key Required'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Please enter your Claude API key to continue.'),
            const SizedBox(height: 8),
            const Text(
              'Get your API key from: console.anthropic.com',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'sk-ant-...',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('claude_api_key', controller.text);
                setState(() {
                  _apiKey = controller.text;
                  _claude = ClaudeService(apiKey: _apiKey!);
                });
                Navigator.of(context).pop();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _processAction() async {
    if (_apiKey == null) {
      _showApiKeyDialog();
      return;
    }

    String action = _actionController.text.trim();
    if (action.isEmpty) return;

    setState(() => _isProcessing = true);

    try {
      // Get DM response
      DMResponse dmResponse = await _claude.getDMResponse(
        playerAction: action,
        character: widget.gameState.character,
        gameState: widget.gameState,
      );

      // Add to history
      _addGameEvent(
        type: 'narrative',
        description: action,
        playerAction: action,
        dmResponse: dmResponse.narration,
      );

      // Handle skill check
      if (dmResponse.requiresRoll) {
        _handleSkillCheck(dmResponse.rollSkill!, dmResponse.rollDC!);
      }

      // Handle combat start
      if (dmResponse.combatStarts) {
        await _startCombat(dmResponse.enemyDescription!);
      }

      // Award XP if given
      if (dmResponse.xpAwarded != null) {
        var messages = _xp.awardXP(
            widget.gameState.character, dmResponse.xpAwarded!);
        for (var msg in messages) {
          _addGameEvent(
            type: 'level_up',
            description: msg,
          );
        }
      }

      // Save state
      await _db.saveGameState(widget.gameState);

      // Clear input
      _actionController.clear();

      // Scroll to bottom
      _scrollToBottom();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  void _handleSkillCheck(String skill, int dc) {
    int modifier = widget.gameState.character.getSkillModifier(skill);
    var result = _dice.rollD20(modifier: modifier);

    bool success = result.total >= dc;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${skill.toUpperCase()} Check'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('DC: $dc'),
            const SizedBox(height: 8),
            Text(result.description),
            const SizedBox(height: 8),
            Text(
              success ? '✅ SUCCESS!' : '❌ FAILURE!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: success ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Continue'),
          ),
        ],
      ),
    );

    _addGameEvent(
      type: 'skill_check',
      description: '$skill check: rolled ${result.total} vs DC $dc',
      metadata: {
        'skill': skill,
        'roll': result.dieRoll,
        'modifier': modifier,
        'total': result.total,
        'dc': dc,
        'success': success,
      },
    );
  }

  Future<void> _startCombat(String enemyDescription) async {
    // Generate enemies
    var enemies = await _claude.generateEnemies(
        enemyDescription, widget.gameState.character.level);

    if (!mounted) return;

    // Navigate to combat screen
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CombatScreen(
          gameState: widget.gameState,
          enemies: enemies,
          claudeService: _claude,
        ),
      ),
    );

    setState(() {}); // Refresh after combat
  }

  void _addGameEvent({
    required String type,
    required String description,
    String? playerAction,
    String? dmResponse,
    Map<String, dynamic>? metadata,
  }) {
    setState(() {
      widget.gameState.narrativeHistory.add(GameEvent(
        eventType: type,
        description: description,
        playerAction: playerAction,
        dmResponse: dmResponse,
        metadata: metadata,
      ));
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.gameState.campaignName),
        backgroundColor: Colors.brown[700],
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CharacterSheetScreen(
                    character: widget.gameState.character,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              await _db.saveGameState(widget.gameState);
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Game saved')),
              );
            },
          ),
        ],
      ),
      body: Row(
        children: [
          // Main narrative area
          Expanded(
            flex: 3,
            child: Column(
              children: [
                // Narrative history
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: widget.gameState.narrativeHistory.length,
                    itemBuilder: (context, index) {
                      var event = widget.gameState.narrativeHistory[index];
                      return _buildEventCard(event);
                    },
                  ),
                ),

                // Input area
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.grey[300]!)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _actionController,
                          decoration: const InputDecoration(
                            hintText: 'What do you do?',
                            border: OutlineInputBorder(),
                          ),
                          enabled: !_isProcessing,
                          onSubmitted: (_) => _processAction(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _isProcessing ? null : _processAction,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                          backgroundColor: Colors.brown[700],
                        ),
                        child: _isProcessing
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Go'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Character stats sidebar
          Container(
            width: 250,
            decoration: BoxDecoration(
              border: Border(left: BorderSide(color: Colors.grey[300]!)),
              color: Colors.grey[50],
            ),
            child: _buildCharacterSidebar(),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(GameEvent event) {
    if (event.eventType == 'narrative') {
      return Card(
        margin: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (event.playerAction != null) ...[
                Text(
                  'You: ${event.playerAction}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blue),
                ),
                const SizedBox(height: 8),
              ],
              if (event.dmResponse != null) Text(event.dmResponse!),
            ],
          ),
        ),
      );
    } else if (event.eventType == 'skill_check') {
      var meta = event.metadata!;
      bool success = meta['success'];
      return Card(
        margin: const EdgeInsets.only(bottom: 16),
        color: success ? Colors.green[50] : Colors.red[50],
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            '${success ? "✅" : "❌"} ${event.description}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      );
    } else if (event.eventType == 'level_up') {
      return Card(
        margin: const EdgeInsets.only(bottom: 16),
        color: Colors.amber[50],
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            event.description,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildCharacterSidebar() {
    var char = widget.gameState.character;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            char.name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text('${char.race} ${char.className} ${char.level}'),
          const Divider(),
          _statRow('HP', '${char.hpCurrent}/${char.hpMax}'),
          _statRow('AC', '${char.armorClass}'),
          _statRow('XP', '${char.experience}'),
          const Divider(),
          const Text('Ability Scores:',
              style: TextStyle(fontWeight: FontWeight.bold)),
          _abilityRow('STR', char.strength, char.strengthModifier),
          _abilityRow('DEX', char.dexterity, char.dexterityModifier),
          _abilityRow('CON', char.constitution, char.constitutionModifier),
          _abilityRow('INT', char.intelligence, char.intelligenceModifier),
          _abilityRow('WIS', char.wisdom, char.wisdomModifier),
          _abilityRow('CHA', char.charisma, char.charismaModifier),
        ],
      ),
    );
  }

  Widget _statRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  Widget _abilityRow(String ability, int score, int modifier) {
    String modStr = modifier >= 0 ? '+$modifier' : '$modifier';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$ability $score'),
          Text(modStr),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _actionController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
