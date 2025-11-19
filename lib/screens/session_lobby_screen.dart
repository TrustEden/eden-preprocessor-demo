import 'package:flutter/material.dart';
import 'package:eden_preprocessor_demo/services/session_service.dart';
import 'package:eden_preprocessor_demo/services/database_service.dart';
import 'package:eden_preprocessor_demo/models/game_session.dart';
import 'package:eden_preprocessor_demo/models/enhanced_character.dart';
import 'package:eden_preprocessor_demo/screens/dm/enhanced_dm_control_panel.dart';
import 'package:eden_preprocessor_demo/screens/player/player_view_screen.dart';
import 'package:uuid/uuid.dart';

/// Session Lobby - Create or join multiplayer D&D sessions
class SessionLobbyScreen extends StatefulWidget {
  const SessionLobbyScreen({Key? key}) : super(key: key);

  @override
  State<SessionLobbyScreen> createState() => _SessionLobbyScreenState();
}

class _SessionLobbyScreenState extends State<SessionLobbyScreen> {
  final SessionService _sessionService = SessionService();
  final DatabaseService _db = DatabaseService();
  final Uuid _uuid = const Uuid();

  List<Map<String, dynamic>> _activeSessions = [];
  bool _isLoading = true;
  String? _currentPlayerId;
  String? _currentPlayerName;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
    _loadActiveSessions();
  }

  Future<void> _initializePlayer() async {
    // Get or create player ID (in a real app, this would come from authentication)
    _currentPlayerId = _uuid.v4();
    _currentPlayerName = 'Player'; // Placeholder
  }

  Future<void> _loadActiveSessions() async {
    setState(() => _isLoading = true);
    try {
      // Load sessions from database
      var sessions = await _db.listGameSessions();
      setState(() {
        _activeSessions = sessions;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading sessions: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _createNewSession() async {
    // Show dialog to get campaign details
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => _CreateSessionDialog(),
    );

    if (result == null) return;

    try {
      // Create new session
      final session = await _sessionService.createSession(
        campaignName: result['campaignName']!,
        dmPlayerId: _currentPlayerId!,
        dmPlayerName: result['dmName']!,
      );

      if (!mounted) return;

      // Navigate to DM Control Panel
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => EnhancedDMControlPanel(
            gameSession: session,
            dmPlayerId: _currentPlayerId!,
          ),
        ),
      ).then((_) => _loadActiveSessions());
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating session: $e')),
      );
    }
  }

  Future<void> _joinSession(String sessionId) async {
    try {
      // Load the session
      final session = await _sessionService.loadSession(sessionId);
      if (session == null) {
        throw Exception('Session not found');
      }

      // Show dialog to get player details
      final result = await showDialog<Map<String, String>>(
        context: context,
        builder: (context) => _JoinSessionDialog(campaignName: session.campaignName),
      );

      if (result == null) return;

      // Create a basic character for the player
      final character = EnhancedCharacter(
        id: _uuid.v4(),
        name: result['characterName']!,
        race: result['race'] ?? 'Human',
        characterClass: result['class'] ?? 'Fighter',
        level: 1,
        currentHP: 10,
        maxHP: 10,
        armorClass: 10,
        abilities: {
          'strength': 10,
          'dexterity': 10,
          'constitution': 10,
          'intelligence': 10,
          'wisdom': 10,
          'charisma': 10,
        },
        inventory: [],
        skillProficiencies: [],
        conditions: [],
      );

      // Add player to session
      await _sessionService.addPlayer(
        playerId: _currentPlayerId!,
        playerName: result['playerName']!,
        character: character,
        role: SessionRole.player,
      );

      if (!mounted) return;

      // Navigate to Player View
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PlayerViewScreen(
            gameSession: session,
            playerId: _currentPlayerId!,
          ),
        ),
      ).then((_) => _loadActiveSessions());
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error joining session: $e')),
      );
    }
  }

  Future<void> _resumeAsDM(String sessionId) async {
    try {
      final session = await _sessionService.loadSession(sessionId);
      if (session == null) {
        throw Exception('Session not found');
      }

      if (!mounted) return;

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => EnhancedDMControlPanel(
            gameSession: session,
            dmPlayerId: session.dmPlayerId,
          ),
        ),
      ).then((_) => _loadActiveSessions());
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error resuming session: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Session Lobby'),
        backgroundColor: Colors.brown[700],
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1000),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'AI-Assisted DM Control Center',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Create a session as DM or join as a player',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Create Session Button
              ElevatedButton.icon(
                onPressed: _createNewSession,
                icon: const Icon(Icons.add_circle),
                label: const Text('Create New Session (DM)'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(20),
                  backgroundColor: Colors.brown[700],
                  foregroundColor: Colors.white,
                ),
              ),

              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),

              // Active Sessions List
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Active Sessions',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: _loadActiveSessions,
                    tooltip: 'Refresh',
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _activeSessions.isEmpty
                        ? Center(
                            child: Text(
                              'No active sessions.\nCreate a new session to get started!',
                              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : ListView.builder(
                            itemCount: _activeSessions.length,
                            itemBuilder: (context, index) {
                              final session = _activeSessions[index];
                              final sessionId = session['session_id'] as String;
                              final campaignName = session['campaign_name'] as String;
                              final dmPlayerId = session['dm_player_id'] as String;
                              final playerCount = session['player_count'] as int? ?? 0;
                              final lastSaved = session['last_saved'] as String?;

                              final isDM = dmPlayerId == _currentPlayerId;

                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: isDM ? Colors.purple : Colors.blue,
                                    child: Icon(
                                      isDM ? Icons.shield : Icons.group,
                                      color: Colors.white,
                                    ),
                                  ),
                                  title: Text(
                                    campaignName,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('$playerCount player${playerCount != 1 ? 's' : ''} connected'),
                                      if (lastSaved != null)
                                        Text(
                                          'Last active: ${_formatDate(lastSaved)}',
                                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                        ),
                                    ],
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (isDM)
                                        Chip(
                                          label: const Text('DM', style: TextStyle(fontSize: 12)),
                                          backgroundColor: Colors.purple[100],
                                        ),
                                      const SizedBox(width: 8),
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          if (isDM) {
                                            _resumeAsDM(sessionId);
                                          } else {
                                            _joinSession(sessionId);
                                          }
                                        },
                                        icon: Icon(isDM ? Icons.play_arrow : Icons.login),
                                        label: Text(isDM ? 'Resume' : 'Join'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: isDM ? Colors.purple[700] : Colors.blue[700],
                                          foregroundColor: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  isThreeLine: lastSaved != null,
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inMinutes < 1) return 'just now';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      if (diff.inDays < 7) return '${diff.inDays}d ago';
      return '${date.month}/${date.day}/${date.year}';
    } catch (e) {
      return 'Unknown';
    }
  }
}

/// Dialog for creating a new session
class _CreateSessionDialog extends StatefulWidget {
  @override
  State<_CreateSessionDialog> createState() => _CreateSessionDialogState();
}

class _CreateSessionDialogState extends State<_CreateSessionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _campaignNameController = TextEditingController();
  final _dmNameController = TextEditingController();

  @override
  void dispose() {
    _campaignNameController.dispose();
    _dmNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create New Session'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _campaignNameController,
              decoration: const InputDecoration(
                labelText: 'Campaign Name',
                hintText: 'The Lost Mines of Phandelver',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a campaign name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _dmNameController,
              decoration: const InputDecoration(
                labelText: 'Your DM Name',
                hintText: 'Dungeon Master',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.of(context).pop({
                'campaignName': _campaignNameController.text,
                'dmName': _dmNameController.text,
              });
            }
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}

/// Dialog for joining an existing session
class _JoinSessionDialog extends StatefulWidget {
  final String campaignName;

  const _JoinSessionDialog({required this.campaignName});

  @override
  State<_JoinSessionDialog> createState() => _JoinSessionDialogState();
}

class _JoinSessionDialogState extends State<_JoinSessionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _playerNameController = TextEditingController();
  final _characterNameController = TextEditingController();
  String _selectedRace = 'Human';
  String _selectedClass = 'Fighter';

  final List<String> _races = ['Human', 'Elf', 'Dwarf', 'Halfling', 'Dragonborn', 'Gnome', 'Half-Elf', 'Half-Orc', 'Tiefling'];
  final List<String> _classes = ['Barbarian', 'Bard', 'Cleric', 'Druid', 'Fighter', 'Monk', 'Paladin', 'Ranger', 'Rogue', 'Sorcerer', 'Warlock', 'Wizard'];

  @override
  void dispose() {
    _playerNameController.dispose();
    _characterNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Join: ${widget.campaignName}'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _playerNameController,
                decoration: const InputDecoration(
                  labelText: 'Your Player Name',
                  hintText: 'John',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _characterNameController,
                decoration: const InputDecoration(
                  labelText: 'Character Name',
                  hintText: 'Aragorn',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a character name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedRace,
                decoration: const InputDecoration(labelText: 'Race'),
                items: _races.map((race) {
                  return DropdownMenuItem(value: race, child: Text(race));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRace = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedClass,
                decoration: const InputDecoration(labelText: 'Class'),
                items: _classes.map((charClass) {
                  return DropdownMenuItem(value: charClass, child: Text(charClass));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedClass = value!;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.of(context).pop({
                'playerName': _playerNameController.text,
                'characterName': _characterNameController.text,
                'race': _selectedRace,
                'class': _selectedClass,
              });
            }
          },
          child: const Text('Join'),
        ),
      ],
    );
  }
}
