import 'package:flutter/material.dart';
import 'package:eden_preprocessor_demo/models/relationship_system.dart';

/// Widget for displaying and managing NPC relationships
class RelationshipTrackingPanel extends StatefulWidget {
  final Map<String, NPCRelationship> npcRelationships;
  final Function(String npcId, String characterId, RelationshipEventType, int attitudeChange, String description) onAddRelationshipEvent;
  final String currentCharacterId;

  const RelationshipTrackingPanel({
    Key? key,
    required this.npcRelationships,
    required this.onAddRelationshipEvent,
    required this.currentCharacterId,
  }) : super(key: key);

  @override
  State<RelationshipTrackingPanel> createState() => _RelationshipTrackingPanelState();
}

class _RelationshipTrackingPanelState extends State<RelationshipTrackingPanel> {
  String _selectedCharacterId = '';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _selectedCharacterId = widget.currentCharacterId;
  }

  List<NPCRelationship> _getFilteredRelationships() {
    var relationships = widget.npcRelationships.values
        .where((r) => r.characterId == _selectedCharacterId)
        .toList();

    if (_searchQuery.isNotEmpty) {
      relationships = relationships
          .where((r) => r.npcName.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    // Sort by attitude (highest first)
    relationships.sort((a, b) => b.currentAttitude.compareTo(a.currentAttitude));
    return relationships;
  }

  @override
  Widget build(BuildContext context) {
    var filteredRelationships = _getFilteredRelationships();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.people, size: 24),
                SizedBox(width: 8),
                Text(
                  'NPC Relationships',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => _showAddRelationshipDialog(context),
                  tooltip: 'Add new NPC relationship',
                ),
              ],
            ),
            SizedBox(height: 16),

            // Search bar
            TextField(
              decoration: InputDecoration(
                labelText: 'Search NPCs',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            SizedBox(height: 16),

            // Relationships list
            Expanded(
              child: filteredRelationships.isEmpty
                  ? Center(
                      child: Text('No NPC relationships yet'),
                    )
                  : ListView.builder(
                      itemCount: filteredRelationships.length,
                      itemBuilder: (context, index) {
                        var npcRelationship = filteredRelationships[index];
                        return _buildRelationshipCard(npcRelationship);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRelationshipCard(NPCRelationship npcRelationship) {
    Color tierColor = _getTierColor(npcRelationship.currentTier);

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: tierColor,
          child: Text(
            npcRelationship.npcName[0].toUpperCase(),
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Row(
          children: [
            Text(
              npcRelationship.npcName,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 8),
            if (npcRelationship.isInLove)
              Icon(Icons.favorite, color: Colors.pink, size: 16),
            if (npcRelationship.isBetrayed)
              Icon(Icons.heart_broken, color: Colors.red, size: 16),
            if (npcRelationship.isRival)
              Icon(Icons.flash_on, color: Colors.orange, size: 16),
            if (npcRelationship.isMerchant)
              Icon(Icons.store, color: Colors.green, size: 16),
            if (npcRelationship.isQuestGiver)
              Icon(Icons.assignment, color: Colors.blue, size: 16),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Row(
              children: [
                Chip(
                  label: Text(
                    npcRelationship.currentTier.displayName,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  backgroundColor: tierColor,
                  padding: EdgeInsets.zero,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: LinearProgressIndicator(
                    value: (npcRelationship.currentAttitude + 100) / 200,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(tierColor),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  '${npcRelationship.currentAttitude}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Merchant pricing
                if (npcRelationship.isMerchant) ...[
                  Row(
                    children: [
                      Icon(Icons.attach_money, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'Price Modifier: ${(npcRelationship.getMerchantPriceModifier() * 100).round()}%',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                ],

                // Stats
                Text(
                  'Interactions: ${npcRelationship.totalInteractions}',
                  style: TextStyle(fontSize: 12),
                ),
                if (npcRelationship.lastInteractionDate != null)
                  Text(
                    'Last seen: ${_formatDate(npcRelationship.lastInteractionDate!)}',
                    style: TextStyle(fontSize: 12),
                  ),
                SizedBox(height: 12),

                // Memorable events
                if (npcRelationship.getMemorableEvents().isNotEmpty) ...[
                  Text(
                    'Memorable Events:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  ...npcRelationship.getMemorableEvents().map((event) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 8.0, bottom: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.star, size: 12, color: Colors.amber),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              event.description,
                              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  SizedBox(height: 12),
                ],

                // Memorable quotes
                if (npcRelationship.memorableQuotes.isNotEmpty) ...[
                  Text(
                    'Memorable Quotes:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  ...npcRelationship.memorableQuotes.take(3).map((quote) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 8.0, bottom: 4),
                      child: Text(
                        '"$quote"',
                        style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                      ),
                    );
                  }).toList(),
                  SizedBox(height: 12),
                ],

                // Action buttons
                Row(
                  children: [
                    ElevatedButton.icon(
                      icon: Icon(Icons.add, size: 16),
                      label: Text('Add Event'),
                      onPressed: () => _showAddEventDialog(context, npcRelationship),
                    ),
                    SizedBox(width: 8),
                    OutlinedButton.icon(
                      icon: Icon(Icons.history, size: 16),
                      label: Text('View History'),
                      onPressed: () => _showHistoryDialog(context, npcRelationship),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getTierColor(RelationshipTier tier) {
    switch (tier) {
      case RelationshipTier.devoted:
        return Colors.purple;
      case RelationshipTier.trusted:
        return Colors.blue;
      case RelationshipTier.friendly:
        return Colors.green;
      case RelationshipTier.neutral:
        return Colors.grey;
      case RelationshipTier.unfriendly:
        return Colors.orange;
      case RelationshipTier.hostile:
        return Colors.deepOrange;
      case RelationshipTier.enemy:
        return Colors.red;
      case RelationshipTier.nemesis:
        return Colors.black;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  void _showAddRelationshipDialog(BuildContext context) {
    // Implementation for adding new NPC relationship
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add NPC Relationship'),
        content: Text('This would show a form to create a new NPC relationship'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Create new relationship
              Navigator.pop(context);
            },
            child: Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showAddEventDialog(BuildContext context, NPCRelationship npcRelationship) {
    RelationshipEventType selectedEventType = RelationshipEventType.custom;
    int attitudeChange = 0;
    String description = '';
    bool isMemorableEvent = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Add Relationship Event'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<RelationshipEventType>(
                  value: selectedEventType,
                  decoration: InputDecoration(labelText: 'Event Type'),
                  items: RelationshipEventType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() {
                        selectedEventType = value;
                      });
                    }
                  },
                ),
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  onChanged: (value) => description = value,
                ),
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Attitude Change',
                    border: OutlineInputBorder(),
                    helperText: 'Positive for improvement, negative for deterioration',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => attitudeChange = int.tryParse(value) ?? 0,
                ),
                SizedBox(height: 16),
                CheckboxListTile(
                  title: Text('Memorable Event'),
                  subtitle: Text('NPC will reference this in future dialogue'),
                  value: isMemorableEvent,
                  onChanged: (value) {
                    setDialogState(() {
                      isMemorableEvent = value ?? false;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (description.isNotEmpty) {
                  widget.onAddRelationshipEvent(
                    npcRelationship.npcId,
                    npcRelationship.characterId,
                    selectedEventType,
                    attitudeChange,
                    description,
                  );
                  Navigator.pop(context);
                }
              },
              child: Text('Add Event'),
            ),
          ],
        ),
      ),
    );
  }

  void _showHistoryDialog(BuildContext context, NPCRelationship npcRelationship) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${npcRelationship.npcName} - Relationship History'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: npcRelationship.relationshipHistory.length,
            itemBuilder: (context, index) {
              var event = npcRelationship.relationshipHistory.reversed.toList()[index];
              return ListTile(
                leading: Icon(
                  event.attitudeChange >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                  color: event.attitudeChange >= 0 ? Colors.green : Colors.red,
                ),
                title: Text(event.description),
                subtitle: Text(
                  '${event.eventType.name} • Day ${event.sessionDay}',
                  style: TextStyle(fontSize: 12),
                ),
                trailing: Text(
                  '${event.attitudeChange > 0 ? '+' : ''}${event.attitudeChange}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: event.attitudeChange >= 0 ? Colors.green : Colors.red,
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}
