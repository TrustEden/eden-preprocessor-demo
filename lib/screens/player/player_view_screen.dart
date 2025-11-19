import 'package:flutter/material.dart';
import '../../models/game_session.dart';
import '../../models/enhanced_character.dart';
import '../../services/session_service.dart';
import '../../services/permission_service.dart';
import '../character_sheet_screen.dart';

/// Player view screen - shows only what the player is allowed to see
/// No DM secrets, no hidden information
class PlayerViewScreen extends StatefulWidget {
  final GameSession session;
  final String playerId;

  const PlayerViewScreen({
    Key? key,
    required this.session,
    required this.playerId,
  }) : super(key: key);

  @override
  State<PlayerViewScreen> createState() => _PlayerViewScreenState();
}

class _PlayerViewScreenState extends State<PlayerViewScreen> {
  final SessionService _sessionService = SessionService();
  final PermissionService _permissions = PermissionService();
  final _actionController = TextEditingController();
  final _scrollController = ScrollController();

  late GameSession _session;
  EnhancedCharacter? _myCharacter;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _session = widget.session;
    _loadMyCharacter();

    // Listen to session updates
    _sessionService.sessionUpdates.listen((session) {
      if (mounted) {
        setState(() {
          _session = session;
          _loadMyCharacter();
        });
      }
    });
  }

  void _loadMyCharacter() {
    _myCharacter = _session.getCharacterForPlayer(widget.playerId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Row(
        children: [
          // Main narrative area
          Expanded(
            child: Column(
              children: [
                // Current scene
                _buildSceneDisplay(),

                // Event history
                Expanded(
                  child: _buildEventHistory(),
                ),

                // Action input
                _buildActionInput(),
              ],
            ),
          ),

          // Character sidebar
          SizedBox(
            width: 300,
            child: _buildCharacterSidebar(),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    var connection = _session.players[widget.playerId];

    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_session.campaignName),
          if (connection != null)
            Text(
              connection.playerName,
              style: const TextStyle(fontSize: 12),
            ),
        ],
      ),
      backgroundColor: Colors.blue[700],
      actions: [
        // View character sheet
        if (_myCharacter != null)
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: _showCharacterSheet,
            tooltip: 'Character Sheet',
          ),

        // Party view
        IconButton(
          icon: const Icon(Icons.people),
          onPressed: _showPartyView,
          tooltip: 'View Party',
        ),

        // Help
        IconButton(
          icon: const Icon(Icons.help),
          onPressed: _showHelp,
          tooltip: 'Help',
        ),
      ],
    );
  }

  Widget _buildSceneDisplay() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.blue[700]),
              const SizedBox(width: 8),
              Text(
                _session.currentScene.location,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _session.currentScene.description,
            style: const TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _buildEventHistory() {
    // Get only events the player can see
    var visibleEvents = _permissions.getVisibleEvents(
      widget.playerId,
      _session.sharedHistory,
      _session,
    );

    if (visibleEvents.isEmpty) {
      return const Center(
        child: Text('No events yet. The adventure begins...'),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: visibleEvents.length,
      itemBuilder: (context, index) {
        var event = visibleEvents[index];
        return _buildEventCard(event);
      },
    );
  }

  Widget _buildEventCard(GameEvent event) {
    Color? bgColor;
    IconData? icon;

    switch (event.eventType) {
      case EventType.narrative:
        bgColor = Colors.white;
        icon = Icons.auto_stories;
        break;
      case EventType.combat:
        bgColor = Colors.red[50];
        icon = Icons.swords;
        break;
      case EventType.skillCheck:
        bgColor = Colors.orange[50];
        icon = Icons.casino;
        break;
      case EventType.levelUp:
        bgColor = Colors.amber[50];
        icon = Icons.star;
        break;
      case EventType.loot:
        bgColor = Colors.green[50];
        icon = Icons.diamond;
        break;
      default:
        bgColor = Colors.grey[50];
        icon = Icons.info;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: bgColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon and type
            Row(
              children: [
                Icon(icon, size: 18, color: Colors.grey[700]),
                const SizedBox(width: 8),
                Text(
                  _formatEventType(event.eventType),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  _formatTimestamp(event.timestamp),
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Content
            if (event.dmResponse != null)
              Text(
                event.dmResponse!,
                style: const TextStyle(fontSize: 15),
              )
            else
              Text(
                event.description,
                style: const TextStyle(fontSize: 15),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
        color: Colors.white,
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
              enabled: !_isSubmitting,
              onSubmitted: (_) => _submitAction(),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: _isSubmitting ? null : _submitAction,
            icon: _isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.send),
            label: const Text('Act'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(20),
              backgroundColor: Colors.blue[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterSidebar() {
    if (_myCharacter == null) {
      return Container(
        color: Colors.grey[100],
        child: const Center(
          child: Text('No character assigned'),
        ),
      );
    }

    var char = _myCharacter!;

    return Container(
      color: Colors.grey[100],
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Character name
            Text(
              char.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('${char.characterClass.name} ${char.level}'),
            Text(char.race.name),

            const Divider(height: 24),

            // HP
            const Text('Hit Points', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: char.hpCurrent / char.hpMax,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                char.hpCurrent > char.hpMax / 2 ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 4),
            Text('${char.hpCurrent} / ${char.hpMax}'),

            const Divider(height: 24),

            // Quick stats
            _statRow('AC', char.armorClass.toString()),
            _statRow('Speed', '${char.speed} ft'),
            _statRow('Initiative', '+${char.initiativeBonus}'),
            _statRow('Proficiency', '+${char.proficiencyBonus}'),

            const Divider(height: 24),

            // Ability scores
            const Text('Abilities', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _abilityRow('STR', char.strength, char.strengthModifier),
            _abilityRow('DEX', char.dexterity, char.dexterityModifier),
            _abilityRow('CON', char.constitution, char.constitutionModifier),
            _abilityRow('INT', char.intelligence, char.intelligenceModifier),
            _abilityRow('WIS', char.wisdom, char.wisdomModifier),
            _abilityRow('CHA', char.charisma, char.charismaModifier),

            const Divider(height: 24),

            // View full character sheet button
            ElevatedButton.icon(
              onPressed: _showCharacterSheet,
              icon: const Icon(Icons.description),
              label: const Text('Full Character Sheet'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 44),
              ),
            ),
          ],
        ),
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
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$ability'),
          Row(
            children: [
              Text('$score  '),
              Text(
                modStr,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _submitAction() async {
    if (_actionController.text.trim().isEmpty) return;

    setState(() => _isSubmitting = true);

    try {
      // Create an event for the player's action
      var event = GameEvent(
        eventType: EventType.narrative,
        description: _actionController.text,
        playerAction: _actionController.text,
        importance: 6,
      );

      await _sessionService.addEvent(event);

      _actionController.clear();

      // Scroll to bottom
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  void _showCharacterSheet() {
    if (_myCharacter == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CharacterSheetScreen(character: _myCharacter!),
      ),
    );
  }

  void _showPartyView() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Party'),
        content: SizedBox(
          width: 400,
          height: 400,
          child: ListView.builder(
            itemCount: _session.activeCharacters.length,
            itemBuilder: (context, index) {
              var char = _session.activeCharacters[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text(char.name.substring(0, 1)),
                ),
                title: Text(char.name),
                subtitle: Text('${char.characterClass.name} ${char.level}'),
                trailing: Text('HP: ${char.hpCurrent}/${char.hpMax}'),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showHelp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Player View Help'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('How to Play:', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('1. Read the current scene at the top'),
              Text('2. Review recent events in the center'),
              Text('3. Type your action in the text box'),
              Text('4. Click "Act" or press Enter'),
              Text('5. Wait for the DM to respond'),
              SizedBox(height: 16),
              Text('Sidebar:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('• View your character stats'),
              Text('• Check HP and abilities'),
              Text('• Open full character sheet'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  String _formatEventType(EventType type) {
    switch (type) {
      case EventType.narrative:
        return 'Story';
      case EventType.combat:
        return 'Combat';
      case EventType.skillCheck:
        return 'Check';
      case EventType.levelUp:
        return 'Level Up!';
      case EventType.loot:
        return 'Treasure';
      case EventType.questUpdate:
        return 'Quest';
      case EventType.npcInteraction:
        return 'NPC';
      case EventType.exploration:
        return 'Discovery';
      case EventType.rest:
        return 'Rest';
      case EventType.dmNote:
        return 'Note';
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  void dispose() {
    _actionController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
