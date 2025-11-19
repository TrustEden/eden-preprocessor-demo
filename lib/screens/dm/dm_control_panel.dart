import 'package:flutter/material.dart';
import '../../models/game_session.dart';
import '../../models/enhanced_character.dart';
import '../../services/session_service.dart';
import '../../services/ai_assistant_service.dart';
import '../../services/permission_service.dart';
import '../../widgets/dm_party_panel.dart';
import '../../widgets/dm_narrative_center.dart';
import '../../widgets/dm_ai_assistant_panel.dart';

/// Main DM Control Panel - the central hub for running the game
class DMControlPanel extends StatefulWidget {
  final GameSession session;
  final String dmPlayerId;

  const DMControlPanel({
    Key? key,
    required this.session,
    required this.dmPlayerId,
  }) : super(key: key);

  @override
  State<DMControlPanel> createState() => _DMControlPanelState();
}

class _DMControlPanelState extends State<DMControlPanel> {
  final SessionService _sessionService = SessionService();
  final AIAssistantService _aiService = AIAssistantService();
  final PermissionService _permissions = PermissionService();

  late GameSession _session;
  bool _autoSaveEnabled = true;
  DateTime? _lastSaved;

  @override
  void initState() {
    super.initState();
    _session = widget.session;

    // Listen to session updates
    _sessionService.sessionUpdates.listen((session) {
      if (mounted) {
        setState(() {
          _session = session;
        });
      }
    });

    // Auto-save every 2 minutes
    if (_autoSaveEnabled) {
      Future.delayed(const Duration(minutes: 2), _autoSave);
    }
  }

  Future<void> _autoSave() async {
    if (!_autoSaveEnabled || !mounted) return;

    await _sessionService.saveCurrentSession();
    setState(() {
      _lastSaved = DateTime.now();
    });

    // Schedule next auto-save
    Future.delayed(const Duration(minutes: 2), _autoSave);
  }

  Future<void> _manualSave() async {
    await _sessionService.saveCurrentSession();
    setState(() {
      _lastSaved = DateTime.now();
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Session saved')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Row(
        children: [
          // Left: Party Panel (20%)
          SizedBox(
            width: 300,
            child: DMPartyPanel(
              session: _session,
              onCharacterTap: _showCharacterDetails,
              onAddPlayer: _showAddPlayerDialog,
            ),
          ),

          // Center: Narrative Center (50%)
          Expanded(
            flex: 3,
            child: DMNarrativeCenter(
              session: _session,
              dmPlayerId: widget.dmPlayerId,
              onSceneUpdate: _updateScene,
              onEventAdd: _addEvent,
            ),
          ),

          // Right: AI Assistant Panel (30%)
          SizedBox(
            width: 400,
            child: DMAIAssistantPanel(
              session: _session,
              onSuggestionSelect: _useSuggestion,
              onQuickAction: _performQuickAction,
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActions(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_session.campaignName),
          Text(
            'Session ${_session.sessionNumber}',
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
      backgroundColor: Colors.brown[800],
      actions: [
        // Session time
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Center(
            child: Text(
              'Day ${_session.gameTimeDays}',
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ),

        // Players online indicator
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Center(
            child: Row(
              children: [
                Icon(
                  Icons.people,
                  size: 20,
                  color: Colors.green[300],
                ),
                const SizedBox(width: 4),
                Text(
                  '${_session.getConnectedPlayers().length}',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ),

        // Save indicator
        if (_lastSaved != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Center(
              child: Tooltip(
                message: 'Last saved: ${_formatTime(_lastSaved!)}',
                child: Icon(
                  Icons.check_circle,
                  size: 20,
                  color: Colors.green[300],
                ),
              ),
            ),
          ),

        // Save button
        IconButton(
          icon: const Icon(Icons.save),
          onPressed: _manualSave,
          tooltip: 'Save Session',
        ),

        // Settings
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: _showSettings,
          tooltip: 'Settings',
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

  Widget _buildFloatingActions() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Start combat
        FloatingActionButton.extended(
          onPressed: _startCombat,
          icon: const Icon(Icons.swords),
          label: const Text('Start Combat'),
          backgroundColor: Colors.red[700],
          heroTag: 'combat',
        ),
        const SizedBox(height: 8),

        // Advance time
        FloatingActionButton.extended(
          onPressed: _advanceTime,
          icon: const Icon(Icons.access_time),
          label: const Text('Advance Time'),
          backgroundColor: Colors.blue[700],
          heroTag: 'time',
        ),
        const SizedBox(height: 8),

        // Add note
        FloatingActionButton(
          onPressed: _addDMNote,
          child: const Icon(Icons.note_add),
          backgroundColor: Colors.amber[700],
          tooltip: 'Add DM Note',
          heroTag: 'note',
        ),
      ],
    );
  }

  void _showCharacterDetails(EnhancedCharacter character) {
    // Show character sheet in dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(character.name),
        content: SizedBox(
          width: 600,
          height: 500,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${character.characterClass.name} ${character.level}'),
                Text('${character.race.name}'),
                const Divider(),
                Text('HP: ${character.hpCurrent}/${character.hpMax}'),
                Text('AC: ${character.armorClass}'),
                // Add more character details as needed
              ],
            ),
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

  void _showAddPlayerDialog() {
    // Dialog to add new player
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Player'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Player Name',
            hintText: 'Enter player name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                await _sessionService.addPlayer(
                  playerId: DateTime.now().millisecondsSinceEpoch.toString(),
                  playerName: nameController.text,
                  role: SessionRole.player,
                );
                if (context.mounted) {
                  Navigator.pop(context);
                }
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _updateScene(Scene scene) async {
    await _sessionService.updateScene(
      requesterId: widget.dmPlayerId,
      location: scene.location,
      description: scene.description,
      visibleNPCIds: scene.visibleNPCIds,
      availableActions: scene.availableActions,
    );
  }

  Future<void> _addEvent(GameEvent event) async {
    await _sessionService.addEvent(event);
  }

  void _useSuggestion(NarrativeSuggestion suggestion) {
    // Use AI suggestion to create event
    _addEvent(
      GameEvent(
        eventType: EventType.narrative,
        description: suggestion.narrative,
        dmResponse: suggestion.narrative,
        importance: 7,
      ),
    );
  }

  Future<void> _performQuickAction(String action) async {
    // Handle quick actions from AI panel
    switch (action) {
      case 'random_encounter':
        _showMessage('Generating random encounter...');
        break;
      case 'generate_npc':
        _showMessage('Generating NPC...');
        break;
      case 'roll_hidden':
        _showMessage('Rolling hidden check...');
        break;
    }
  }

  void _startCombat() {
    // Navigate to combat screen or show combat dialog
    _showMessage('Combat system integration coming soon');
  }

  void _advanceTime() {
    showDialog(
      context: context,
      builder: (context) {
        int days = 1;
        return AlertDialog(
          title: const Text('Advance Time'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('How many days should pass?'),
                  Slider(
                    value: days.toDouble(),
                    min: 1,
                    max: 30,
                    divisions: 29,
                    label: '$days day${days > 1 ? "s" : ""}',
                    onChanged: (value) {
                      setState(() {
                        days = value.toInt();
                      });
                    },
                  ),
                  Text('$days day${days > 1 ? "s" : ""}'),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await _sessionService.advanceTime(
                  requesterId: widget.dmPlayerId,
                  days: days,
                );
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text('Advance'),
            ),
          ],
        );
      },
    );
  }

  void _addDMNote() {
    final noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add DM Note'),
        content: TextField(
          controller: noteController,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: 'Enter note (only you can see this)',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (noteController.text.isNotEmpty) {
                await _sessionService.addDMNote(
                  requesterId: widget.dmPlayerId,
                  note: noteController.text,
                );
                if (context.mounted) {
                  Navigator.pop(context);
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showSettings() {
    // Navigate to settings screen
    _showMessage('Settings panel coming soon');
  }

  void _showHelp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('DM Control Panel Help'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Left Panel: Party Management',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text('• View character stats'),
              Text('• Add/remove players'),
              Text('• Monitor party health'),
              SizedBox(height: 16),
              Text('Center Panel: Narrative Control',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text('• Edit current scene'),
              Text('• View event history'),
              Text('• Send narratives to players'),
              SizedBox(height: 16),
              Text('Right Panel: AI Assistant',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text('• Get AI-generated suggestions'),
              Text('• Quick actions'),
              Text('• Campaign insights'),
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

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  void dispose() {
    super.dispose();
  }
}
