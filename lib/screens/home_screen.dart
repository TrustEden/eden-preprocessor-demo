import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/game_state.dart';
import 'character_creation_screen.dart';
import 'main_game_screen.dart';
import 'session_lobby_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseService _db = DatabaseService();
  List<Map<String, dynamic>> _campaigns = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCampaigns();
  }

  Future<void> _loadCampaigns() async {
    setState(() => _isLoading = true);
    try {
      var campaigns = await _db.listCampaigns();
      setState(() {
        _campaigns = campaigns;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading campaigns: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadCampaign(String campaignId) async {
    try {
      var gameState = await _db.loadGameState(campaignId);
      if (gameState != null && mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MainGameScreen(gameState: gameState),
          ),
        ).then((_) => _loadCampaigns()); // Refresh list when returning
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading campaign: $e')),
      );
    }
  }

  void _newCampaign() {
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => const CharacterCreationScreen(),
      ),
    )
        .then((_) => _loadCampaigns()); // Refresh list when returning
  }

  void _goToSessionLobby() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SessionLobbyScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Dungeon Master'),
        backgroundColor: Colors.brown[700],
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Welcome, Adventurer!',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Your AI-powered D&D 5e adventure awaits',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _newCampaign,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(20),
                  backgroundColor: Colors.brown[700],
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'New Campaign (Solo)',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _goToSessionLobby,
                icon: const Icon(Icons.people),
                label: const Text(
                  'Multiplayer Session Lobby',
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(20),
                  backgroundColor: Colors.purple[700],
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              const Text(
                'Saved Campaigns',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _campaigns.isEmpty
                        ? Center(
                            child: Text(
                              'No saved campaigns.\nStart a new adventure!',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[600]),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : ListView.builder(
                            itemCount: _campaigns.length,
                            itemBuilder: (context, index) {
                              var campaign = _campaigns[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: ListTile(
                                  leading: const Icon(Icons.book,
                                      color: Colors.brown),
                                  title:
                                      Text(campaign['campaign_name'] as String),
                                  subtitle: Text(
                                    'Last played: ${_formatDate(campaign['last_saved'] as String)}',
                                  ),
                                  trailing: const Icon(Icons.arrow_forward),
                                  onTap: () => _loadCampaign(
                                      campaign['campaign_id'] as String),
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
      var date = DateTime.parse(isoDate);
      var now = DateTime.now();
      var diff = now.difference(date);

      if (diff.inDays == 0) {
        return 'Today';
      } else if (diff.inDays == 1) {
        return 'Yesterday';
      } else if (diff.inDays < 7) {
        return '${diff.inDays} days ago';
      } else {
        return '${date.month}/${date.day}/${date.year}';
      }
    } catch (e) {
      return 'Unknown';
    }
  }
}
