import 'package:flutter/material.dart';
import '../models/game_session.dart';
import '../services/permission_service.dart';

/// Center panel for narrative control - DM writes/edits the story here
class DMNarrativeCenter extends StatefulWidget {
  final GameSession session;
  final String dmPlayerId;
  final Function(Scene) onSceneUpdate;
  final Function(GameEvent) onEventAdd;

  const DMNarrativeCenter({
    Key? key,
    required this.session,
    required this.dmPlayerId,
    required this.onSceneUpdate,
    required this.onEventAdd,
  }) : super(key: key);

  @override
  State<DMNarrativeCenter> createState() => _DMNarrativeCenterState();
}

class _DMNarrativeCenterState extends State<DMNarrativeCenter> {
  final _sceneController = TextEditingController();
  final _responseController = TextEditingController();
  final _scrollController = ScrollController();

  bool _isEditingScene = false;
  String? _pendingPlayerAction;

  @override
  void initState() {
    super.initState();
    _sceneController.text = widget.session.currentScene.description;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Scene editor
          _buildSceneEditor(),

          // Event history
          Expanded(
            child: _buildEventHistory(),
          ),

          // Response area
          _buildResponseArea(),
        ],
      ),
    );
  }

  Widget _buildSceneEditor() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on, size: 20, color: Colors.blue[700]),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.session.currentScene.location,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(_isEditingScene ? Icons.check : Icons.edit),
                onPressed: _toggleSceneEdit,
                tooltip: _isEditingScene ? 'Save Scene' : 'Edit Scene',
              ),
            ],
          ),
          const SizedBox(height: 8),
          _isEditingScene
              ? TextField(
                  controller: _sceneController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'Describe the current scene...',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                )
              : Text(
                  widget.session.currentScene.description,
                  style: const TextStyle(fontSize: 14),
                ),
        ],
      ),
    );
  }

  Widget _buildEventHistory() {
    // Filter events to show (DM sees all)
    var visibleEvents = widget.session.sharedHistory;

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
    Color? iconColor;

    // Style based on event type
    switch (event.eventType) {
      case EventType.narrative:
        bgColor = Colors.white;
        icon = Icons.book;
        iconColor = Colors.blue;
        break;
      case EventType.combat:
        bgColor = Colors.red[50];
        icon = Icons.swords;
        iconColor = Colors.red;
        break;
      case EventType.skillCheck:
        bgColor = Colors.orange[50];
        icon = Icons.casino;
        iconColor = Colors.orange;
        break;
      case EventType.dmNote:
        bgColor = Colors.amber[50];
        icon = Icons.sticky_note_2;
        iconColor = Colors.amber[700];
        break;
      default:
        bgColor = Colors.grey[100];
        icon = Icons.info;
        iconColor = Colors.grey;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: bgColor,
      elevation: event.isDMSecret ? 4 : 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(icon, size: 16, color: iconColor),
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
                if (event.isDMSecret)
                  Chip(
                    label: const Text('DM ONLY', style: TextStyle(fontSize: 10)),
                    backgroundColor: Colors.amber[200],
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                const SizedBox(width: 8),
                Text(
                  _formatTimestamp(event.timestamp),
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
              ],
            ),

            // Player action
            if (event.playerAction != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.person, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        event.playerAction!,
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // DM response
            if (event.dmResponse != null) ...[
              const SizedBox(height: 8),
              Text(event.dmResponse!),
            ],

            // Description (if no DM response)
            if (event.dmResponse == null && event.playerAction == null) ...[
              const SizedBox(height: 8),
              Text(event.description),
            ],

            // Importance indicator
            if (event.importance >= 8) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.star, size: 14, color: Colors.amber[700]),
                  const SizedBox(width: 4),
                  Text(
                    'Important',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.amber[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResponseArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
        color: Colors.grey[50],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Show pending player action if any
          if (_pendingPlayerAction != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.person, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _pendingPlayerAction!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => setState(() => _pendingPlayerAction = null),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Response input
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _responseController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Write your response to the players...',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: _sendResponse,
                    icon: const Icon(Icons.send),
                    label: const Text('Send'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                    ),
                  ),
                  const SizedBox(height: 4),
                  ElevatedButton.icon(
                    onPressed: _saveAsSecret,
                    icon: const Icon(Icons.lock),
                    label: const Text('Secret'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[700],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _toggleSceneEdit() {
    if (_isEditingScene) {
      // Save scene
      var updatedScene = Scene(
        location: widget.session.currentScene.location,
        description: _sceneController.text,
        visibleNPCIds: widget.session.currentScene.visibleNPCIds,
        availableActions: widget.session.currentScene.availableActions,
      );
      widget.onSceneUpdate(updatedScene);
    }
    setState(() {
      _isEditingScene = !_isEditingScene;
    });
  }

  void _sendResponse() {
    if (_responseController.text.trim().isEmpty) return;

    var event = GameEvent(
      eventType: EventType.narrative,
      description: _responseController.text,
      playerAction: _pendingPlayerAction,
      dmResponse: _responseController.text,
      isDMSecret: false,
      importance: 6,
    );

    widget.onEventAdd(event);
    _responseController.clear();
    setState(() {
      _pendingPlayerAction = null;
    });

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
  }

  void _saveAsSecret() {
    if (_responseController.text.trim().isEmpty) return;

    var event = GameEvent(
      eventType: EventType.dmNote,
      description: _responseController.text,
      dmResponse: _responseController.text,
      isDMSecret: true,
      importance: 5,
    );

    widget.onEventAdd(event);
    _responseController.clear();
  }

  String _formatEventType(EventType type) {
    switch (type) {
      case EventType.narrative:
        return 'Narrative';
      case EventType.combat:
        return 'Combat';
      case EventType.skillCheck:
        return 'Skill Check';
      case EventType.levelUp:
        return 'Level Up';
      case EventType.loot:
        return 'Loot';
      case EventType.questUpdate:
        return 'Quest';
      case EventType.npcInteraction:
        return 'NPC';
      case EventType.exploration:
        return 'Exploration';
      case EventType.rest:
        return 'Rest';
      case EventType.dmNote:
        return 'DM Note';
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
    _sceneController.dispose();
    _responseController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
