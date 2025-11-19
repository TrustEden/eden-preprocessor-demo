import 'package:flutter/material.dart';
import 'package:eden_preprocessor_demo/services/dm_ai_tools_service.dart';
import 'package:eden_preprocessor_demo/models/game_session.dart';

/// Widget for AI-powered DM tools: NPC generation, consistency checking, campaign analysis
class DMAIToolsPanel extends StatefulWidget {
  final DMAIToolsService dmAIToolsService;
  final GameSession gameSession;
  final Function(NPCGenerationResult) onNPCGenerated;
  final Function(List<QuestHook>) onQuestHooksGenerated;

  const DMAIToolsPanel({
    Key? key,
    required this.dmAIToolsService,
    required this.gameSession,
    required this.onNPCGenerated,
    required this.onQuestHooksGenerated,
  }) : super(key: key);

  @override
  State<DMAIToolsPanel> createState() => _DMAIToolsPanelState();
}

class _DMAIToolsPanelState extends State<DMAIToolsPanel> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isGenerating = false;
  ConsistencyReport? _lastConsistencyReport;
  CampaignAnalysis? _lastCampaignAnalysis;

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
                Icon(Icons.psychology, size: 24, color: Colors.purple),
                SizedBox(width: 8),
                Text(
                  'AI-Powered DM Tools',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
          ),

          // Tabs
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: [
              Tab(icon: Icon(Icons.person_add), text: 'NPC Generator'),
              Tab(icon: Icon(Icons.fact_check), text: 'Consistency'),
              Tab(icon: Icon(Icons.analytics), text: 'Campaign Analysis'),
              Tab(icon: Icon(Icons.assignment_add), text: 'Quest Hooks'),
            ],
          ),

          // Tab views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildNPCGeneratorTab(),
                _buildConsistencyTab(),
                _buildCampaignAnalysisTab(),
                _buildQuestHooksTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNPCGeneratorTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Generate Unique NPCs',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'AI will create a complete NPC with personality, backstory, and hooks',
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 24),

          // Quick generation buttons
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildQuickNPCButton('Merchant', Icons.store, Colors.green),
              _buildQuickNPCButton('Quest Giver', Icons.assignment, Colors.blue),
              _buildQuickNPCButton('Innkeeper', Icons.hotel, Colors.brown),
              _buildQuickNPCButton('Guard', Icons.shield, Colors.grey),
              _buildQuickNPCButton('Mysterious Stranger', Icons.question_mark, Colors.purple),
              _buildQuickNPCButton('Villain', Icons.flash_on, Colors.red),
            ],
          ),
          SizedBox(height: 24),

          // Custom generation
          ElevatedButton.icon(
            icon: Icon(Icons.settings),
            label: Text('Custom NPC Generation'),
            onPressed: () => _showCustomNPCDialog(context),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(16),
            ),
          ),

          if (_isGenerating) ...[
            SizedBox(height: 24),
            Center(child: CircularProgressIndicator()),
            SizedBox(height: 8),
            Center(
              child: Text(
                'Generating NPC...',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuickNPCButton(String npcRole, IconData icon, Color color) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 20),
      label: Text(npcRole),
      onPressed: () => _generateNPC(npcRole),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildConsistencyTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Campaign Consistency Check',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'AI will analyze your campaign for plot holes and continuity errors',
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 24),

          ElevatedButton.icon(
            icon: Icon(Icons.play_arrow),
            label: Text('Run Consistency Check'),
            onPressed: _isGenerating ? null : () => _runConsistencyCheck(),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(16),
            ),
          ),

          if (_lastConsistencyReport != null) ...[
            SizedBox(height: 24),
            _buildConsistencyReport(_lastConsistencyReport!),
          ],

          if (_isGenerating) ...[
            SizedBox(height: 24),
            Center(child: CircularProgressIndicator()),
            SizedBox(height: 8),
            Center(
              child: Text(
                'Analyzing campaign...',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildConsistencyReport(ConsistencyReport consistencyReport) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  consistencyReport.issuesFound.isEmpty ? Icons.check_circle : Icons.warning,
                  color: consistencyReport.issuesFound.isEmpty ? Colors.green : Colors.orange,
                ),
                SizedBox(width: 8),
                Text(
                  'Consistency Report',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Issues
            if (consistencyReport.issuesFound.isNotEmpty) ...[
              Text(
                'Issues Found:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              ...consistencyReport.issuesFound.map((issue) {
                return ListTile(
                  dense: true,
                  leading: Icon(Icons.error_outline, color: Colors.orange, size: 20),
                  title: Text(issue),
                );
              }).toList(),
              SizedBox(height: 16),
            ],

            // Unresolved plot threads
            if (consistencyReport.unresolvedPlotThreads.isNotEmpty) ...[
              Text(
                'Unresolved Plot Threads:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              ...consistencyReport.unresolvedPlotThreads.map((thread) {
                return ListTile(
                  dense: true,
                  leading: Icon(Icons.timeline, color: Colors.blue, size: 20),
                  title: Text(thread),
                );
              }).toList(),
              SizedBox(height: 16),
            ],

            // Suggestions
            if (consistencyReport.suggestions.isNotEmpty) ...[
              Text(
                'Suggestions:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              ...consistencyReport.suggestions.map((suggestion) {
                return ListTile(
                  dense: true,
                  leading: Icon(Icons.lightbulb_outline, color: Colors.amber, size: 20),
                  title: Text(suggestion),
                );
              }).toList(),
            ],

            if (consistencyReport.issuesFound.isEmpty &&
                consistencyReport.unresolvedPlotThreads.isEmpty) ...[
              Center(
                child: Column(
                  children: [
                    Icon(Icons.check_circle, size: 48, color: Colors.green),
                    SizedBox(height: 8),
                    Text('No issues found! Campaign is consistent.'),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCampaignAnalysisTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Campaign Analysis',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Get AI insights on your campaign momentum and next developments',
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 24),

          ElevatedButton.icon(
            icon: Icon(Icons.analytics),
            label: Text('Analyze Campaign'),
            onPressed: _isGenerating ? null : () => _analyzeCampaign(),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(16),
            ),
          ),

          if (_lastCampaignAnalysis != null) ...[
            SizedBox(height: 24),
            _buildCampaignAnalysisReport(_lastCampaignAnalysis!),
          ],

          if (_isGenerating) ...[
            SizedBox(height: 24),
            Center(child: CircularProgressIndicator()),
            SizedBox(height: 8),
            Center(
              child: Text(
                'Analyzing campaign...',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCampaignAnalysisReport(CampaignAnalysis campaignAnalysis) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Momentum meter
            Text(
              'Campaign Momentum',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: campaignAnalysis.campaignMomentum / 10,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getMomentumColor(campaignAnalysis.campaignMomentum),
                    ),
                    minHeight: 20,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  '${campaignAnalysis.campaignMomentum}/10',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 24),

            // Plot developments
            Text(
              'Suggested Plot Developments:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ...campaignAnalysis.suggestedPlotDevelopments.map((development) {
              return ListTile(
                dense: true,
                leading: Icon(Icons.auto_stories, color: Colors.blue, size: 20),
                title: Text(development),
              );
            }).toList(),
            SizedBox(height: 16),

            // Character arc opportunities
            if (campaignAnalysis.characterArcOpportunities.isNotEmpty) ...[
              Text(
                'Character Arc Opportunities:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              ...campaignAnalysis.characterArcOpportunities.map((opportunity) {
                return ListTile(
                  dense: true,
                  leading: Icon(Icons.person, color: Colors.purple, size: 20),
                  title: Text(opportunity),
                );
              }).toList(),
              SizedBox(height: 16),
            ],

            // Pacing recommendations
            if (campaignAnalysis.pacingRecommendations.isNotEmpty) ...[
              Text(
                'Pacing Recommendations:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              ...campaignAnalysis.pacingRecommendations.map((recommendation) {
                return ListTile(
                  dense: true,
                  leading: Icon(Icons.speed, color: Colors.orange, size: 20),
                  title: Text(recommendation),
                );
              }).toList(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildQuestHooksTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Quest Hook Generator',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Generate quest hooks that connect to your campaign',
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 24),

          ElevatedButton.icon(
            icon: Icon(Icons.add_task),
            label: Text('Generate Quest Hooks'),
            onPressed: _isGenerating ? null : () => _generateQuestHooks(),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(16),
            ),
          ),

          if (_isGenerating) ...[
            SizedBox(height: 24),
            Center(child: CircularProgressIndicator()),
            SizedBox(height: 8),
            Center(
              child: Text(
                'Generating quest hooks...',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getMomentumColor(int campaignMomentum) {
    if (campaignMomentum >= 8) return Colors.green;
    if (campaignMomentum >= 5) return Colors.blue;
    if (campaignMomentum >= 3) return Colors.orange;
    return Colors.red;
  }

  void _generateNPC(String npcRole) async {
    setState(() {
      _isGenerating = true;
    });

    try {
      var npcGenerationResult = await widget.dmAIToolsService.generateNPC(
        npcRole: npcRole,
        location: widget.gameSession.currentScene.location,
        gameSession: widget.gameSession,
      );

      widget.onNPCGenerated(npcGenerationResult);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('NPC generated: ${npcGenerationResult.npcName}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  void _showCustomNPCDialog(BuildContext context) {
    String npcRole = '';
    String faction = '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Custom NPC Generation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'NPC Role',
                hintText: 'e.g., Wizard, Blacksmith, Noble',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => npcRole = value,
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Faction (optional)',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => faction = value,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (npcRole.isNotEmpty) {
                Navigator.pop(context);
                _generateNPC(npcRole);
              }
            },
            child: Text('Generate'),
          ),
        ],
      ),
    );
  }

  void _runConsistencyCheck() async {
    setState(() {
      _isGenerating = true;
    });

    try {
      var consistencyReport = await widget.dmAIToolsService.checkCampaignConsistency(widget.gameSession);

      if (mounted) {
        setState(() {
          _lastConsistencyReport = consistencyReport;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  void _analyzeCampaign() async {
    setState(() {
      _isGenerating = true;
    });

    try {
      var campaignAnalysis = await widget.dmAIToolsService.analyzeCampaign(widget.gameSession);

      if (mounted) {
        setState(() {
          _lastCampaignAnalysis = campaignAnalysis;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  void _generateQuestHooks() async {
    setState(() {
      _isGenerating = true;
    });

    try {
      var questHooks = await widget.dmAIToolsService.suggestQuestHooks(widget.gameSession);

      widget.onQuestHooksGenerated(questHooks);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Generated ${questHooks.length} quest hooks')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }
}
