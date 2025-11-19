import 'package:flutter/material.dart';
import '../models/game_session.dart';
import '../models/enhanced_character.dart';

/// Left panel showing party composition and player status
class DMPartyPanel extends StatelessWidget {
  final GameSession session;
  final Function(EnhancedCharacter) onCharacterTap;
  final VoidCallback onAddPlayer;

  const DMPartyPanel({
    Key? key,
    required this.session,
    required this.onCharacterTap,
    required this.onAddPlayer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.brown[700],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Party',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.person_add, color: Colors.white),
                  onPressed: onAddPlayer,
                  tooltip: 'Add Player',
                ),
              ],
            ),
          ),

          // Party members
          Expanded(
            child: session.activeCharacters.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: session.activeCharacters.length,
                    itemBuilder: (context, index) {
                      return _buildCharacterCard(
                        context,
                        session.activeCharacters[index],
                      );
                    },
                  ),
          ),

          // Quick stats
          _buildQuickStats(context),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No players yet',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: onAddPlayer,
            icon: const Icon(Icons.person_add),
            label: const Text('Add Player'),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterCard(BuildContext context, EnhancedCharacter character) {
    // Get player connection for this character
    var player = session.players.values.firstWhere(
      (p) => p.characterId == character.id,
      orElse: () => PlayerConnection(
        playerId: 'unknown',
        playerName: 'No Player',
      ),
    );

    double hpPercent = character.hpCurrent / character.hpMax;
    Color hpColor = hpPercent > 0.5
        ? Colors.green
        : hpPercent > 0.25
            ? Colors.orange
            : Colors.red;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => onCharacterTap(character),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name and status
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          character.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '${character.characterClass.name} ${character.level}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Connection indicator
                  Icon(
                    player.isConnected ? Icons.circle : Icons.circle_outlined,
                    size: 12,
                    color: player.isConnected ? Colors.green : Colors.grey,
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // HP bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('HP', style: TextStyle(fontSize: 11)),
                      Text(
                        '${character.hpCurrent}/${character.hpMax}',
                        style: const TextStyle(fontSize: 11),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: hpPercent,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(hpColor),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Quick stats
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatBubble('AC', character.armorClass.toString()),
                  _buildStatBubble('Init', '+${character.initiativeBonus}'),
                  _buildStatBubble('Speed', '${character.speed}ft'),
                ],
              ),

              // Conditions
              if (character.activeConditions.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  children: character.activeConditions
                      .map((c) => Chip(
                            label: Text(c, style: const TextStyle(fontSize: 10)),
                            backgroundColor: Colors.orange[100],
                            padding: EdgeInsets.zero,
                            visualDensity: VisualDensity.compact,
                          ))
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatBubble(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    int totalGold = 0; // Would sum from all characters
    int totalXP = session.activeCharacters.fold(0, (sum, c) => sum + c.experience);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Stats',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          _buildStatRow('Players', session.getConnectedPlayers().length.toString()),
          _buildStatRow('Characters', session.activeCharacters.length.toString()),
          _buildStatRow('Total XP', totalXP.toString()),
          _buildStatRow('Session', session.sessionNumber.toString()),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
