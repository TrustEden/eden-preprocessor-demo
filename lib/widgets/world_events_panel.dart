import 'package:flutter/material.dart';
import 'package:eden_preprocessor_demo/models/world_events.dart';

/// Widget for displaying and managing world events and faction conflicts
class WorldEventsPanel extends StatefulWidget {
  final List<WorldEvent> activeWorldEvents;
  final List<WorldEvent> upcomingWorldEvents;
  final List<FactionConflict> activeFactionConflicts;
  final Function(String eventId) onTriggerWorldEvent;
  final Function(String eventId, List<EventConsequence> consequences) onConcludeWorldEvent;
  final Function(String conflictId, int amount) onEscalateConflict;
  final Function(String conflictId, int amount) onDeEscalateConflict;
  final int currentGameDay;

  const WorldEventsPanel({
    Key? key,
    required this.activeWorldEvents,
    required this.upcomingWorldEvents,
    required this.activeFactionConflicts,
    required this.onTriggerWorldEvent,
    required this.onConcludeWorldEvent,
    required this.onEscalateConflict,
    required this.onDeEscalateConflict,
    required this.currentGameDay,
  }) : super(key: key);

  @override
  State<WorldEventsPanel> createState() => _WorldEventsPanelState();
}

class _WorldEventsPanelState extends State<WorldEventsPanel> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(Icons.public, size: 24),
                SizedBox(width: 8),
                Text(
                  'World Events & Conflicts',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Spacer(),
                Chip(
                  label: Text('Day ${widget.currentGameDay}'),
                  backgroundColor: Colors.blue[100],
                ),
              ],
            ),
          ),

          // Tabs
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(
                icon: Icon(Icons.notifications_active),
                text: 'Active (${widget.activeWorldEvents.length})',
              ),
              Tab(
                icon: Icon(Icons.schedule),
                text: 'Upcoming (${widget.upcomingWorldEvents.length})',
              ),
              Tab(
                icon: Icon(Icons.warning),
                text: 'Conflicts (${widget.activeFactionConflicts.length})',
              ),
            ],
          ),

          // Tab views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildActiveEventsTab(),
                _buildUpcomingEventsTab(),
                _buildConflictsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveEventsTab() {
    if (widget.activeWorldEvents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No active world events', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: widget.activeWorldEvents.length,
      itemBuilder: (context, index) {
        var worldEvent = widget.activeWorldEvents[index];
        return _buildActiveEventCard(worldEvent);
      },
    );
  }

  Widget _buildActiveEventCard(WorldEvent worldEvent) {
    Color scaleColor = _getEventScaleColor(worldEvent.eventScale);
    int daysSinceStart = worldEvent.startedDay != null
        ? widget.currentGameDay - worldEvent.startedDay!
        : 0;

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: scaleColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getEventTypeIcon(worldEvent.eventType),
            color: scaleColor,
          ),
        ),
        title: Text(
          worldEvent.eventName,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Row(
              children: [
                Chip(
                  label: Text(
                    worldEvent.eventScale.name.toUpperCase(),
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                  backgroundColor: scaleColor,
                  padding: EdgeInsets.zero,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                SizedBox(width: 8),
                Text('Day $daysSinceStart'),
                if (worldEvent.durationDays != null) ...[
                  Text(' / ${worldEvent.durationDays} days'),
                ],
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
                // Description
                Text(
                  worldEvent.description,
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
                SizedBox(height: 12),

                // Affected areas
                if (worldEvent.affectedLocations.isNotEmpty) ...[
                  Text(
                    'Affected Locations:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Wrap(
                    spacing: 4,
                    children: worldEvent.affectedLocations.map((location) {
                      return Chip(
                        label: Text(location, style: TextStyle(fontSize: 12)),
                        visualDensity: VisualDensity.compact,
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 8),
                ],

                // Narrative updates
                if (worldEvent.narrativeUpdates.isNotEmpty) ...[
                  Text(
                    'Latest Update:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      worldEvent.narrativeUpdates.last,
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  SizedBox(height: 12),
                ],

                // Player awareness
                Row(
                  children: [
                    Icon(
                      worldEvent.playerAware ? Icons.visibility : Icons.visibility_off,
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      worldEvent.playerAware ? 'Players are aware' : 'Hidden from players',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                SizedBox(height: 12),

                // Action buttons
                Row(
                  children: [
                    if (worldEvent.canPlayerIntervene)
                      OutlinedButton.icon(
                        icon: Icon(Icons.add, size: 16),
                        label: Text('Add Update'),
                        onPressed: () => _showAddUpdateDialog(context, worldEvent),
                      ),
                    SizedBox(width: 8),
                    ElevatedButton.icon(
                      icon: Icon(Icons.check, size: 16),
                      label: Text('Conclude Event'),
                      onPressed: () => _showConcludeEventDialog(context, worldEvent),
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

  Widget _buildUpcomingEventsTab() {
    if (widget.upcomingWorldEvents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_available, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No upcoming events', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: widget.upcomingWorldEvents.length,
      itemBuilder: (context, index) {
        var worldEvent = widget.upcomingWorldEvents[index];
        return _buildUpcomingEventCard(worldEvent);
      },
    );
  }

  Widget _buildUpcomingEventCard(WorldEvent worldEvent) {
    bool canTriggerNow = worldEvent.scheduledDay == null ||
        widget.currentGameDay >= worldEvent.scheduledDay!;

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(_getEventTypeIcon(worldEvent.eventType)),
        title: Text(worldEvent.eventName),
        subtitle: Text(
          worldEvent.scheduledDay != null
              ? 'Scheduled for Day ${worldEvent.scheduledDay}'
              : 'Manual trigger only',
        ),
        trailing: ElevatedButton(
          onPressed: canTriggerNow
              ? () => widget.onTriggerWorldEvent(worldEvent.eventId)
              : null,
          child: Text('Trigger'),
        ),
      ),
    );
  }

  Widget _buildConflictsTab() {
    if (widget.activeFactionConflicts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.handshake, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No active conflicts', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: widget.activeFactionConflicts.length,
      itemBuilder: (context, index) {
        var factionConflict = widget.activeFactionConflicts[index];
        return _buildConflictCard(factionConflict);
      },
    );
  }

  Widget _buildConflictCard(FactionConflict factionConflict) {
    Color statusColor = _getConflictStatusColor(factionConflict.conflictStatus);

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: Icon(Icons.groups, color: statusColor),
        title: Text(
          factionConflict.conflictName,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Chip(
              label: Text(
                factionConflict.conflictStatus.name.toUpperCase(),
                style: TextStyle(fontSize: 10, color: Colors.white),
              ),
              backgroundColor: statusColor,
              padding: EdgeInsets.zero,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Factions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          factionConflict.faction1Id,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        if (factionConflict.winningFactionId == factionConflict.faction1Id)
                          Icon(Icons.arrow_upward, color: Colors.green, size: 16),
                      ],
                    ),
                    Icon(Icons.compare_arrows, size: 24),
                    Column(
                      children: [
                        Text(
                          factionConflict.faction2Id,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        if (factionConflict.winningFactionId == factionConflict.faction2Id)
                          Icon(Icons.arrow_upward, color: Colors.green, size: 16),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // Intensity meter
                Text(
                  'Conflict Intensity',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: factionConflict.conflictIntensity / 100,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getIntensityColor(factionConflict.conflictIntensity),
                        ),
                        minHeight: 10,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '${factionConflict.conflictIntensity}/100',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // Player involvement
                if (factionConflict.playerAlignedFaction != null) ...[
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.person, size: 16),
                        SizedBox(width: 4),
                        Text(
                          'Players support: ${factionConflict.playerAlignedFaction}',
                          style: TextStyle(fontSize: 12),
                        ),
                        Spacer(),
                        Text(
                          'Influence: ${factionConflict.playerInfluence}%',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),
                ],

                // Action buttons
                Row(
                  children: [
                    ElevatedButton.icon(
                      icon: Icon(Icons.trending_up, size: 16),
                      label: Text('Escalate'),
                      onPressed: () {
                        widget.onEscalateConflict(factionConflict.conflictId, 10);
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton.icon(
                      icon: Icon(Icons.trending_down, size: 16),
                      label: Text('De-escalate'),
                      onPressed: () {
                        widget.onDeEscalateConflict(factionConflict.conflictId, 10);
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
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

  Color _getEventScaleColor(EventScale eventScale) {
    switch (eventScale) {
      case EventScale.personal:
        return Colors.blue;
      case EventScale.local:
        return Colors.green;
      case EventScale.regional:
        return Colors.orange;
      case EventScale.national:
        return Colors.deepOrange;
      case EventScale.continental:
        return Colors.red;
      case EventScale.global:
        return Colors.purple;
    }
  }

  Color _getConflictStatusColor(ConflictStatus conflictStatus) {
    switch (conflictStatus) {
      case ConflictStatus.brewing:
        return Colors.orange;
      case ConflictStatus.skirmishing:
        return Colors.deepOrange;
      case ConflictStatus.openWar:
        return Colors.red;
      case ConflictStatus.stalemate:
        return Colors.grey;
      case ConflictStatus.resolved:
        return Colors.green;
    }
  }

  Color _getIntensityColor(int conflictIntensity) {
    if (conflictIntensity >= 75) return Colors.red;
    if (conflictIntensity >= 50) return Colors.orange;
    if (conflictIntensity >= 25) return Colors.yellow;
    return Colors.green;
  }

  IconData _getEventTypeIcon(WorldEventType eventType) {
    switch (eventType) {
      case WorldEventType.seasonal:
        return Icons.wb_sunny;
      case WorldEventType.political:
        return Icons.account_balance;
      case WorldEventType.economic:
        return Icons.trending_up;
      case WorldEventType.natural:
        return Icons.nature;
      case WorldEventType.faction:
        return Icons.groups;
      case WorldEventType.quest:
        return Icons.assignment;
      case WorldEventType.playerDriven:
        return Icons.person;
      case WorldEventType.random:
        return Icons.casino;
      case WorldEventType.custom:
        return Icons.star;
    }
  }

  void _showAddUpdateDialog(BuildContext context, WorldEvent worldEvent) {
    String narrativeUpdate = '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Narrative Update'),
        content: TextField(
          decoration: InputDecoration(
            labelText: 'Update',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          onChanged: (value) => narrativeUpdate = value,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (narrativeUpdate.isNotEmpty) {
                // Add update logic here
                Navigator.pop(context);
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showConcludeEventDialog(BuildContext context, WorldEvent worldEvent) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Conclude Event'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Select consequences for this event:'),
            SizedBox(height: 16),
            ...worldEvent.possibleConsequences.map((consequence) {
              return CheckboxListTile(
                title: Text(consequence.description),
                value: false,
                onChanged: (value) {},
              );
            }).toList(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              widget.onConcludeWorldEvent(worldEvent.eventId, []);
              Navigator.pop(context);
            },
            child: Text('Conclude'),
          ),
        ],
      ),
    );
  }
}
