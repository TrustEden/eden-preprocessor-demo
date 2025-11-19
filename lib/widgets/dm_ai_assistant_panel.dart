import 'package:flutter/material.dart';
import '../models/game_session.dart';
import '../services/ai_assistant_service.dart';

/// Right panel showing AI suggestions and quick actions
class DMAIAssistantPanel extends StatefulWidget {
  final GameSession session;
  final Function(NarrativeSuggestion) onSuggestionSelect;
  final Function(String) onQuickAction;

  const DMAIAssistantPanel({
    Key? key,
    required this.session,
    required this.onSuggestionSelect,
    required this.onQuickAction,
  }) : super(key: key);

  @override
  State<DMAIAssistantPanel> createState() => _DMAIAssistantPanelState();
}

class _DMAIAssistantPanelState extends State<DMAIAssistantPanel> {
  final AIAssistantService _aiService = AIAssistantService();
  final _actionController = TextEditingController();

  List<NarrativeSuggestion>? _currentSuggestions;
  bool _isGenerating = false;
  String? _lastPlayerAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.purple[700],
            child: const Row(
              children: [
                Icon(Icons.auto_awesome, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'AI Assistant',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Action input
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Get AI Suggestions',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _actionController,
                  decoration: const InputDecoration(
                    hintText: 'Player action...',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: _isGenerating ? null : _generateSuggestions,
                  icon: _isGenerating
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.psychology),
                  label: Text(_isGenerating ? 'Generating...' : 'Generate'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple[600],
                    minimumSize: const Size(double.infinity, 40),
                  ),
                ),
              ],
            ),
          ),

          // Suggestions
          Expanded(
            child: _currentSuggestions == null
                ? _buildEmptyState()
                : _buildSuggestionsList(),
          ),

          // Quick actions
          _buildQuickActions(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lightbulb_outline, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Enter a player action\nto get AI suggestions',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionsList() {
    if (_currentSuggestions == null || _currentSuggestions!.isEmpty) {
      return const Center(child: Text('No suggestions generated'));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _currentSuggestions!.length,
      itemBuilder: (context, index) {
        return _buildSuggestionCard(_currentSuggestions![index], index + 1);
      },
    );
  }

  Widget _buildSuggestionCard(NarrativeSuggestion suggestion, int number) {
    Color styleColor = _getStyleColor(suggestion.style);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with style and confidence
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: styleColor.withOpacity(0.1),
              border: Border(
                bottom: BorderSide(color: styleColor.withOpacity(0.3)),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: styleColor,
                  child: Text(
                    '$number',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatStyle(suggestion.style),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: styleColor,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 2),
                      LinearProgressIndicator(
                        value: suggestion.confidenceScore,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(styleColor),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Confidence: ${(suggestion.confidenceScore * 100).toInt()}%',
                        style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Narrative content
          Padding(
            padding: const EdgeInsets.all(12),
            child: SelectableText(
              suggestion.narrative,
              style: const TextStyle(fontSize: 13),
            ),
          ),

          // Consequences
          if (suggestion.predictions.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ExpansionTile(
                title: const Text(
                  'Potential Consequences',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                tilePadding: EdgeInsets.zero,
                childrenPadding: const EdgeInsets.only(bottom: 8),
                children: suggestion.predictions
                    .map((pred) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.arrow_right, size: 16, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  pred.description,
                                  style: TextStyle(fontSize: 11, color: Colors.grey[700]),
                                ),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],

          // Actions
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _useSuggestion(suggestion),
                    icon: const Icon(Icons.check, size: 16),
                    label: const Text('Use This'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: styleColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () => _editSuggestion(suggestion),
                  child: const Icon(Icons.edit, size: 16),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
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
            'Quick Actions',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 12),
          _buildQuickActionButton(
            'Random Encounter',
            Icons.casino,
            Colors.red,
            'random_encounter',
          ),
          const SizedBox(height: 8),
          _buildQuickActionButton(
            'Generate NPC',
            Icons.person_add,
            Colors.blue,
            'generate_npc',
          ),
          const SizedBox(height: 8),
          _buildQuickActionButton(
            'Roll Hidden Check',
            Icons.visibility_off,
            Colors.orange,
            'roll_hidden',
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
    String label,
    IconData icon,
    Color color,
    String action,
  ) {
    return OutlinedButton.icon(
      onPressed: () => widget.onQuickAction(action),
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 40),
        foregroundColor: color,
        side: BorderSide(color: color),
      ),
    );
  }

  Future<void> _generateSuggestions() async {
    if (_actionController.text.trim().isEmpty) return;

    setState(() {
      _isGenerating = true;
      _lastPlayerAction = _actionController.text;
    });

    try {
      var suggestions = await _aiService.generateNarrativeSuggestions(
        playerAction: _actionController.text,
        session: widget.session,
      );

      setState(() {
        _currentSuggestions = suggestions;
        _isGenerating = false;
      });
    } catch (e) {
      setState(() {
        _isGenerating = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating suggestions: ${e.toString()}')),
        );
      }
    }
  }

  void _useSuggestion(NarrativeSuggestion suggestion) {
    widget.onSuggestionSelect(suggestion);
    setState(() {
      _currentSuggestions = null;
      _actionController.clear();
    });
  }

  void _editSuggestion(NarrativeSuggestion suggestion) {
    // Copy suggestion to clipboard or open in editor
    // For now, just show a dialog
    showDialog(
      context: context,
      builder: (context) {
        final editController = TextEditingController(text: suggestion.narrative);
        return AlertDialog(
          title: const Text('Edit Suggestion'),
          content: TextField(
            controller: editController,
            maxLines: 10,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                var edited = NarrativeSuggestion(
                  narrative: editController.text,
                  style: suggestion.style,
                  confidenceScore: suggestion.confidenceScore,
                  predictions: suggestion.predictions,
                );
                _useSuggestion(edited);
                Navigator.pop(context);
              },
              child: const Text('Use Edited'),
            ),
          ],
        );
      },
    );
  }

  Color _getStyleColor(SuggestionStyle style) {
    switch (style) {
      case SuggestionStyle.dramatic:
        return Colors.red[700]!;
      case SuggestionStyle.comedic:
        return Colors.orange[700]!;
      case SuggestionStyle.mysterious:
        return Colors.purple[700]!;
      case SuggestionStyle.action:
        return Colors.red[600]!;
      case SuggestionStyle.social:
        return Colors.blue[600]!;
      case SuggestionStyle.balanced:
        return Colors.green[700]!;
      case SuggestionStyle.error:
        return Colors.grey[700]!;
    }
  }

  String _formatStyle(SuggestionStyle style) {
    switch (style) {
      case SuggestionStyle.dramatic:
        return 'Dramatic';
      case SuggestionStyle.comedic:
        return 'Comedic';
      case SuggestionStyle.mysterious:
        return 'Mysterious';
      case SuggestionStyle.action:
        return 'Action-Packed';
      case SuggestionStyle.social:
        return 'Social/RP';
      case SuggestionStyle.balanced:
        return 'Balanced';
      case SuggestionStyle.error:
        return 'Error';
    }
  }

  @override
  void dispose() {
    _actionController.dispose();
    super.dispose();
  }
}
