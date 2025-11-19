import 'package:flutter/material.dart';
import 'package:eden_preprocessor_demo/models/character_development.dart';

/// Widget for displaying character arcs, personal quests, and growth tracking
class CharacterDevelopmentPanel extends StatefulWidget {
  final List<PersonalQuest> personalQuests;
  final List<CharacterArc> characterArcs;
  final List<GrowthMilestone> growthMilestones;
  final Function(String questId, String objectiveId) onCompleteQuestObjective;
  final Function(String arcId) onAdvanceArcStage;
  final String characterId;

  const CharacterDevelopmentPanel({
    Key? key,
    required this.personalQuests,
    required this.characterArcs,
    required this.growthMilestones,
    required this.onCompleteQuestObjective,
    required this.onAdvanceArcStage,
    required this.characterId,
  }) : super(key: key);

  @override
  State<CharacterDevelopmentPanel> createState() => _CharacterDevelopmentPanelState();
}

class _CharacterDevelopmentPanelState extends State<CharacterDevelopmentPanel> with SingleTickerProviderStateMixin {
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
    var activePersonalQuests = widget.personalQuests
        .where((q) =>
            q.characterId == widget.characterId &&
            (q.questStatus == PersonalQuestStatus.active ||
                q.questStatus == PersonalQuestStatus.progressing))
        .toList();

    var activeCharacterArcs = widget.characterArcs
        .where((a) => a.characterId == widget.characterId)
        .toList();

    var recentGrowthMilestones = widget.growthMilestones
        .where((m) => m.characterId == widget.characterId)
        .toList()
      ..sort((a, b) => b.achievedDate.compareTo(a.achievedDate));

    return Card(
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(Icons.auto_stories, size: 24),
                SizedBox(width: 8),
                Text(
                  'Character Development',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
          ),

          // Tabs
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(
                icon: Icon(Icons.assignment),
                text: 'Personal Quests (${activePersonalQuests.length})',
              ),
              Tab(
                icon: Icon(Icons.trending_up),
                text: 'Character Arcs (${activeCharacterArcs.length})',
              ),
              Tab(
                icon: Icon(Icons.military_tech),
                text: 'Growth',
              ),
            ],
          ),

          // Tab views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPersonalQuestsTab(activePersonalQuests),
                _buildCharacterArcsTab(activeCharacterArcs),
                _buildGrowthTab(recentGrowthMilestones),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalQuestsTab(List<PersonalQuest> activePersonalQuests) {
    if (activePersonalQuests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No active personal quests', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: activePersonalQuests.length,
      itemBuilder: (context, index) {
        var personalQuest = activePersonalQuests[index];
        return _buildPersonalQuestCard(personalQuest);
      },
    );
  }

  Widget _buildPersonalQuestCard(PersonalQuest personalQuest) {
    Color typeColor = _getQuestTypeColor(personalQuest.questType);

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: typeColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(_getQuestTypeIcon(personalQuest.questType), color: typeColor),
        ),
        title: Text(
          personalQuest.questName,
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
                    personalQuest.questType.name.toUpperCase(),
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                  backgroundColor: typeColor,
                  padding: EdgeInsets.zero,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: LinearProgressIndicator(
                    value: personalQuest.progressPercentage / 100,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(typeColor),
                  ),
                ),
                SizedBox(width: 8),
                Text('${personalQuest.progressPercentage}%'),
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
                // Motivation
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Motivation:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      SizedBox(height: 4),
                      Text(
                        personalQuest.motivation,
                        style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),

                // Objectives
                Text(
                  'Objectives:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                ...personalQuest.questObjectives.map((objective) {
                  bool isCompleted = personalQuest.completedObjectives.contains(objective.objectiveId);
                  return CheckboxListTile(
                    dense: true,
                    value: isCompleted,
                    title: Text(
                      objective.description,
                      style: TextStyle(
                        decoration: isCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    subtitle: objective.isOptional ? Text('Optional', style: TextStyle(fontSize: 10)) : null,
                    onChanged: isCompleted
                        ? null
                        : (value) {
                            if (value == true) {
                              widget.onCompleteQuestObjective(
                                personalQuest.questId,
                                objective.objectiveId,
                              );
                            }
                          },
                  );
                }).toList(),
                SizedBox(height: 12),

                // Time limit
                if (personalQuest.daysRemaining != null) ...[
                  Row(
                    children: [
                      Icon(
                        Icons.timer,
                        size: 16,
                        color: personalQuest.daysRemaining! < 10 ? Colors.red : Colors.orange,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '${personalQuest.daysRemaining} days remaining',
                        style: TextStyle(
                          color: personalQuest.daysRemaining! < 10 ? Colors.red : Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                ],

                // Milestones
                if (personalQuest.questMilestones.isNotEmpty) ...[
                  Text(
                    'Milestones:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  ...personalQuest.questMilestones.map((milestone) {
                    bool reached = personalQuest.reachedMilestones.contains(milestone.milestoneId);
                    return ListTile(
                      dense: true,
                      leading: Icon(
                        reached ? Icons.check_circle : Icons.radio_button_unchecked,
                        color: reached ? Colors.green : Colors.grey,
                        size: 20,
                      ),
                      title: Text(milestone.milestoneName),
                      subtitle: Text(milestone.description, style: TextStyle(fontSize: 10)),
                    );
                  }).toList(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterArcsTab(List<CharacterArc> activeCharacterArcs) {
    if (activeCharacterArcs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.auto_graph, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No character arcs', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: activeCharacterArcs.length,
      itemBuilder: (context, index) {
        var characterArc = activeCharacterArcs[index];
        return _buildCharacterArcCard(characterArc);
      },
    );
  }

  Widget _buildCharacterArcCard(CharacterArc characterArc) {
    Color arcColor = _getArcTypeColor(characterArc.arcType);

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: Icon(Icons.auto_graph, color: arcColor),
        title: Text(
          characterArc.arcName,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Chip(
              label: Text(
                characterArc.arcType.name.toUpperCase(),
                style: TextStyle(fontSize: 10, color: Colors.white),
              ),
              backgroundColor: arcColor,
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
                // Thematic focus
                Text(
                  characterArc.thematicFocus,
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
                SizedBox(height: 12),

                // Transformation meter
                Text(
                  'Character Transformation',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: characterArc.transformationLevel / 100,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(arcColor),
                        minHeight: 10,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '${characterArc.transformationLevel}%',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 12),

                // Current stage
                Text(
                  'Current Stage: ${characterArc.currentStage.name}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),

                // Key moments
                if (characterArc.keyMoments.isNotEmpty) ...[
                  Text(
                    'Key Moments:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  ...characterArc.keyMoments.reversed.take(3).map((moment) {
                    return ListTile(
                      dense: true,
                      leading: Icon(_getMomentIcon(moment.momentType), size: 16),
                      title: Text(moment.momentName),
                      subtitle: Text(moment.description, style: TextStyle(fontSize: 10)),
                      trailing: Text(
                        '+${moment.transformationImpact}',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                    );
                  }).toList(),
                  SizedBox(height: 12),
                ],

                // Advance stage button
                ElevatedButton.icon(
                  icon: Icon(Icons.arrow_forward, size: 16),
                  label: Text('Advance Stage'),
                  onPressed: () => widget.onAdvanceArcStage(characterArc.arcId),
                  style: ElevatedButton.styleFrom(backgroundColor: arcColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrowthTab(List<GrowthMilestone> recentGrowthMilestones) {
    if (recentGrowthMilestones.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.trending_up, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No growth milestones yet', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: recentGrowthMilestones.take(10).length,
      itemBuilder: (context, index) {
        var growthMilestone = recentGrowthMilestones[index];
        return _buildGrowthMilestoneCard(growthMilestone);
      },
    );
  }

  Widget _buildGrowthMilestoneCard(GrowthMilestone growthMilestone) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.amber,
          child: Text(
            '${growthMilestone.characterLevel}',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        title: Text(
          growthMilestone.milestoneName,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (growthMilestone.narrativeSignificance != null) ...[
              SizedBox(height: 4),
              Text(
                growthMilestone.narrativeSignificance!,
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
              ),
            ],
            if (growthMilestone.newAbilities.isNotEmpty) ...[
              SizedBox(height: 4),
              Text(
                'New Abilities: ${growthMilestone.newAbilities.join(', ')}',
                style: TextStyle(fontSize: 11),
              ),
            ],
            SizedBox(height: 4),
            Text(
              'Day ${growthMilestone.sessionDay}',
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Color _getQuestTypeColor(PersonalQuestType questType) {
    switch (questType) {
      case PersonalQuestType.revenge:
        return Colors.red;
      case PersonalQuestType.redemption:
        return Colors.blue;
      case PersonalQuestType.discovery:
        return Colors.purple;
      case PersonalQuestType.mastery:
        return Colors.orange;
      case PersonalQuestType.protection:
        return Colors.green;
      case PersonalQuestType.ambition:
        return Colors.amber;
      case PersonalQuestType.mystery:
        return Colors.indigo;
      case PersonalQuestType.duty:
        return Colors.brown;
      case PersonalQuestType.custom:
        return Colors.grey;
    }
  }

  Color _getArcTypeColor(ArcType arcType) {
    switch (arcType) {
      case ArcType.transformation:
        return Colors.purple;
      case ArcType.testing:
        return Colors.orange;
      case ArcType.growth:
        return Colors.green;
      case ArcType.corruption:
        return Colors.red;
      case ArcType.redemption:
        return Colors.blue;
      case ArcType.fall:
        return Colors.black;
    }
  }

  IconData _getQuestTypeIcon(PersonalQuestType questType) {
    switch (questType) {
      case PersonalQuestType.revenge:
        return Icons.gavel;
      case PersonalQuestType.redemption:
        return Icons.brightness_high;
      case PersonalQuestType.discovery:
        return Icons.search;
      case PersonalQuestType.mastery:
        return Icons.military_tech;
      case PersonalQuestType.protection:
        return Icons.shield;
      case PersonalQuestType.ambition:
        return Icons.trending_up;
      case PersonalQuestType.mystery:
        return Icons.help_outline;
      case PersonalQuestType.duty:
        return Icons.flag;
      case PersonalQuestType.custom:
        return Icons.star;
    }
  }

  IconData _getMomentIcon(MomentType momentType) {
    switch (momentType) {
      case MomentType.decision:
        return Icons.alt_route;
      case MomentType.revelation:
        return Icons.wb_incandescent;
      case MomentType.loss:
        return Icons.heart_broken;
      case MomentType.triumph:
        return Icons.emoji_events;
      case MomentType.betrayal:
        return Icons.person_off;
      case MomentType.sacrifice:
        return Icons.volunteer_activism;
    }
  }
}
