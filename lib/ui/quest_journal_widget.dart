import 'package:flutter/material.dart';
import '../models/quest.dart';
import '../models/party.dart';

class QuestJournalWidget extends StatefulWidget {
  final List<Quest> quests;
  final Function(Quest)? onQuestAccept;
  final Function(Quest)? onQuestAbandon;
  final Function(Quest, String)? onBranchSelect;
  final Function(Quest, String)? onObjectiveComplete;

  const QuestJournalWidget({
    Key? key,
    required this.quests,
    this.onQuestAccept,
    this.onQuestAbandon,
    this.onBranchSelect,
    this.onObjectiveComplete,
  }) : super(key: key);

  @override
  State<QuestJournalWidget> createState() => _QuestJournalWidgetState();
}

class _QuestJournalWidgetState extends State<QuestJournalWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  QuestType? _selectedType;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Quest> get _activeQuests =>
      widget.quests.where((q) => q.status == QuestStatus.active).toList();

  List<Quest> get _availableQuests =>
      widget.quests.where((q) => q.status == QuestStatus.available).toList();

  List<Quest> get _completedQuests =>
      widget.quests.where((q) => q.status == QuestStatus.completed).toList();

  List<Quest> get _failedQuests =>
      widget.quests.where((q) => q.status == QuestStatus.failed).toList();

  List<Quest> _getFilteredQuests(List<Quest> quests) {
    List<Quest> filtered = quests;

    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((q) =>
              q.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              q.description.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    if (_selectedType != null) {
      filtered = filtered.where((q) => q.type == _selectedType).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quest Journal'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              icon: const Icon(Icons.assignment),
              text: 'Active (${_activeQuests.length})',
            ),
            Tab(
              icon: const Icon(Icons.announcement),
              text: 'Available (${_availableQuests.length})',
            ),
            Tab(
              icon: const Icon(Icons.check_circle),
              text: 'Completed (${_completedQuests.length})',
            ),
            Tab(
              icon: const Icon(Icons.cancel),
              text: 'Failed (${_failedQuests.length})',
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildTypeFilter(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildQuestList(_getFilteredQuests(_activeQuests), QuestStatus.active),
                _buildQuestList(_getFilteredQuests(_availableQuests), QuestStatus.available),
                _buildQuestList(_getFilteredQuests(_completedQuests), QuestStatus.completed),
                _buildQuestList(_getFilteredQuests(_failedQuests), QuestStatus.failed),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search quests...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildTypeFilter() {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          _buildTypeChip('All', null),
          for (var type in QuestType.values) _buildTypeChip(type.name, type),
        ],
      ),
    );
  }

  Widget _buildTypeChip(String label, QuestType? type) {
    bool isSelected = _selectedType == type;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedType = type;
          });
        },
        selectedColor: _getQuestTypeColor(type),
      ),
    );
  }

  Color _getQuestTypeColor(QuestType? type) {
    if (type == null) return Colors.grey.shade300;

    switch (type) {
      case QuestType.mainStory:
        return Colors.purple.shade200;
      case QuestType.sideQuest:
        return Colors.blue.shade200;
      case QuestType.kill:
        return Colors.red.shade200;
      case QuestType.fetch:
        return Colors.orange.shade200;
      case QuestType.escort:
        return Colors.green.shade200;
      case QuestType.investigate:
        return Colors.cyan.shade200;
      case QuestType.rescue:
        return Colors.pink.shade200;
      case QuestType.bounty:
        return Colors.brown.shade200;
      case QuestType.exploration:
        return Colors.teal.shade200;
      case QuestType.crafting:
        return Colors.amber.shade200;
    }
  }

  Widget _buildQuestList(List<Quest> quests, QuestStatus status) {
    if (quests.isEmpty) {
      return _buildEmptyState(status);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: quests.length,
      itemBuilder: (context, index) {
        return _buildQuestCard(quests[index]);
      },
    );
  }

  Widget _buildEmptyState(QuestStatus status) {
    String message;
    IconData icon;

    switch (status) {
      case QuestStatus.active:
        message = 'No active quests';
        icon = Icons.assignment_outlined;
        break;
      case QuestStatus.available:
        message = 'No available quests';
        icon = Icons.announcement_outlined;
        break;
      case QuestStatus.completed:
        message = 'No completed quests yet';
        icon = Icons.check_circle_outline;
        break;
      case QuestStatus.failed:
        message = 'No failed quests';
        icon = Icons.cancel_outlined;
        break;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestCard(Quest quest) {
    Color typeColor = _getQuestTypeColor(quest.type);
    Color statusColor = _getQuestStatusColor(quest.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: statusColor, width: 2),
      ),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: typeColor,
          child: Icon(_getQuestIcon(quest.type), color: Colors.white),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                quest.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (quest.timeLimit != null)
              Chip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.timer, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '${quest.timeLimit}d',
                      style: const TextStyle(fontSize: 11),
                    ),
                  ],
                ),
                backgroundColor: Colors.orange.shade100,
                padding: EdgeInsets.zero,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              _formatQuestType(quest.type),
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 4),
            _buildProgressBar(quest),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quest.description,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                const Text(
                  'Objectives',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...quest.objectives.map((obj) => _buildObjectiveRow(quest, obj)),
                if (quest.branches.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),
                  const Text(
                    'Story Branches',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...quest.branches.map((branch) => _buildBranchCard(quest, branch)),
                ],
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                _buildRewardSection(quest),
                const SizedBox(height: 16),
                _buildActionButtons(quest),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getQuestStatusColor(QuestStatus status) {
    switch (status) {
      case QuestStatus.available:
        return Colors.blue;
      case QuestStatus.active:
        return Colors.orange;
      case QuestStatus.completed:
        return Colors.green;
      case QuestStatus.failed:
        return Colors.red;
    }
  }

  IconData _getQuestIcon(QuestType type) {
    switch (type) {
      case QuestType.mainStory:
        return Icons.auto_stories;
      case QuestType.sideQuest:
        return Icons.explore;
      case QuestType.kill:
        return Icons.dangerous;
      case QuestType.fetch:
        return Icons.shopping_bag;
      case QuestType.escort:
        return Icons.directions_walk;
      case QuestType.investigate:
        return Icons.search;
      case QuestType.rescue:
        return Icons.health_and_safety;
      case QuestType.bounty:
        return Icons.gavel;
      case QuestType.exploration:
        return Icons.map;
      case QuestType.crafting:
        return Icons.construction;
    }
  }

  String _formatQuestType(QuestType type) {
    switch (type) {
      case QuestType.mainStory:
        return 'Main Story';
      case QuestType.sideQuest:
        return 'Side Quest';
      case QuestType.kill:
        return 'Kill Quest';
      case QuestType.fetch:
        return 'Fetch Quest';
      case QuestType.escort:
        return 'Escort Quest';
      case QuestType.investigate:
        return 'Investigation';
      case QuestType.rescue:
        return 'Rescue Mission';
      case QuestType.bounty:
        return 'Bounty';
      case QuestType.exploration:
        return 'Exploration';
      case QuestType.crafting:
        return 'Crafting Quest';
    }
  }

  Widget _buildProgressBar(Quest quest) {
    int completedObjectives =
        quest.objectives.where((obj) => obj.isCompleted).length;
    int totalObjectives = quest.objectives.length;
    double progress =
        totalObjectives > 0 ? completedObjectives / totalObjectives : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey.shade300,
          valueColor: AlwaysStoppedAnimation<Color>(
            progress == 1.0 ? Colors.green : Colors.blue,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$completedObjectives/$totalObjectives objectives',
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildObjectiveRow(Quest quest, QuestObjective objective) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            objective.isCompleted
                ? Icons.check_box
                : Icons.check_box_outline_blank,
            color: objective.isCompleted ? Colors.green : Colors.grey,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  objective.description,
                  style: TextStyle(
                    decoration: objective.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    color: objective.isCompleted
                        ? Colors.grey
                        : Colors.black,
                  ),
                ),
                if (objective.targetCount != null &&
                    objective.currentCount != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: LinearProgressIndicator(
                      value: objective.currentCount! / objective.targetCount!,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                      minHeight: 6,
                    ),
                  ),
                if (objective.targetCount != null &&
                    objective.currentCount != null)
                  Text(
                    '${objective.currentCount}/${objective.targetCount}',
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
              ],
            ),
          ),
          if (!objective.isCompleted && quest.status == QuestStatus.active)
            IconButton(
              icon: const Icon(Icons.done, size: 18),
              onPressed: () {
                widget.onObjectiveComplete?.call(quest, objective.id);
                setState(() {});
              },
              tooltip: 'Complete objective',
            ),
        ],
      ),
    );
  }

  Widget _buildBranchCard(Quest quest, QuestBranch branch) {
    bool isSelected = quest.selectedBranchId == branch.id;

    return Card(
      color: isSelected ? Colors.amber.shade100 : Colors.grey.shade50,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          isSelected ? Icons.star : Icons.star_border,
          color: isSelected ? Colors.amber : Colors.grey,
        ),
        title: Text(
          branch.choiceDescription,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (branch.additionalObjectives.isNotEmpty)
              Text('${branch.additionalObjectives.length} additional objectives'),
            if (branch.bonusReward != null) const Text('Bonus reward available'),
          ],
        ),
        trailing: !isSelected && quest.status == QuestStatus.active
            ? ElevatedButton(
                onPressed: () {
                  widget.onBranchSelect?.call(quest, branch.id);
                  setState(() {});
                },
                child: const Text('Choose'),
              )
            : null,
      ),
    );
  }

  Widget _buildRewardSection(Quest quest) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Rewards',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        if (quest.mainReward.experiencePoints > 0)
          _buildRewardRow(
            Icons.military_tech,
            '${quest.mainReward.experiencePoints} XP',
            Colors.purple,
          ),
        if (quest.mainReward.goldPieces > 0)
          _buildRewardRow(
            Icons.monetization_on,
            '${quest.mainReward.goldPieces} GP',
            Colors.amber,
          ),
        if (quest.mainReward.items.isNotEmpty)
          _buildRewardRow(
            Icons.inventory_2,
            '${quest.mainReward.items.length} items',
            Colors.blue,
          ),
        if (quest.mainReward.reputationGains.isNotEmpty)
          for (var entry in quest.mainReward.reputationGains.entries)
            _buildRewardRow(
              Icons.favorite,
              '+${entry.value} ${entry.key} reputation',
              Colors.pink,
            ),
      ],
    );
  }

  Widget _buildRewardRow(IconData icon, String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }

  Widget _buildActionButtons(Quest quest) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (quest.status == QuestStatus.available)
          ElevatedButton.icon(
            onPressed: () {
              widget.onQuestAccept?.call(quest);
              setState(() {});
            },
            icon: const Icon(Icons.add_task),
            label: const Text('Accept Quest'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
        if (quest.status == QuestStatus.active)
          OutlinedButton.icon(
            onPressed: () {
              _showAbandonDialog(quest);
            },
            icon: const Icon(Icons.cancel),
            label: const Text('Abandon'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
            ),
          ),
      ],
    );
  }

  void _showAbandonDialog(Quest quest) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Abandon Quest?'),
        content: Text(
          'Are you sure you want to abandon "${quest.name}"? You may not be able to start it again.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              widget.onQuestAbandon?.call(quest);
              Navigator.pop(context);
              setState(() {});
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Abandon'),
          ),
        ],
      ),
    );
  }
}
