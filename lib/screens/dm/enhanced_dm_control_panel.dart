import 'package:flutter/material.dart';
import 'package:eden_preprocessor_demo/models/game_session.dart';
import 'package:eden_preprocessor_demo/services/session_service.dart';
import 'package:eden_preprocessor_demo/services/ai_assistant_service.dart';
import 'package:eden_preprocessor_demo/services/permission_service.dart';
// Phase 2 Services
import 'package:eden_preprocessor_demo/services/relationship_service.dart';
import 'package:eden_preprocessor_demo/services/world_event_service.dart';
import 'package:eden_preprocessor_demo/services/enhanced_combat_service.dart';
import 'package:eden_preprocessor_demo/services/character_arc_service.dart';
import 'package:eden_preprocessor_demo/services/crafting_service.dart';
import 'package:eden_preprocessor_demo/services/economy_service.dart';
import 'package:eden_preprocessor_demo/services/dm_ai_tools_service.dart';
import 'package:eden_preprocessor_demo/services/encounter_builder_service.dart';
// Phase 1 Widgets
import 'package:eden_preprocessor_demo/widgets/dm_party_panel.dart';
import 'package:eden_preprocessor_demo/widgets/dm_narrative_center.dart';
import 'package:eden_preprocessor_demo/widgets/dm_ai_assistant_panel.dart';
// Phase 2 Widgets
import 'package:eden_preprocessor_demo/widgets/relationship_tracking_panel.dart';
import 'package:eden_preprocessor_demo/widgets/world_events_panel.dart';
import 'package:eden_preprocessor_demo/widgets/character_development_panel.dart';
import 'package:eden_preprocessor_demo/widgets/crafting_economy_panel.dart';
import 'package:eden_preprocessor_demo/widgets/dm_ai_tools_panel.dart';

/// Enhanced DM Control Panel with Phase 2 gameplay depth features
class EnhancedDMControlPanel extends StatefulWidget {
  final GameSession gameSession;
  final String dmPlayerId;

  const EnhancedDMControlPanel({
    Key? key,
    required this.gameSession,
    required this.dmPlayerId,
  }) : super(key: key);

  @override
  State<EnhancedDMControlPanel> createState() => _EnhancedDMControlPanelState();
}

class _EnhancedDMControlPanelState extends State<EnhancedDMControlPanel> with SingleTickerProviderStateMixin {
  // Phase 1 Services
  final SessionService _sessionService = SessionService();
  final AIAssistantService _aiService = AIAssistantService();
  final PermissionService _permissions = PermissionService();

  // Phase 2 Services
  final RelationshipService _relationshipService = RelationshipService();
  final WorldEventService _worldEventService = WorldEventService();
  final EnhancedCombatService _enhancedCombatService = EnhancedCombatService();
  final CharacterArcService _characterArcService = CharacterArcService();
  final CraftingService _craftingService = CraftingService();
  final EconomyService _economyService = EconomyService();
  late final DMAIToolsService _dmAIToolsService;
  final EncounterBuilderService _encounterBuilderService = EncounterBuilderService();

  late GameSession _session;
  late TabController _sidebarTabController;
  bool _autoSaveEnabled = true;
  DateTime? _lastSaved;
  bool _showPhase2Sidebar = false;

  @override
  void initState() {
    super.initState();
    _session = widget.gameSession;
    _sidebarTabController = TabController(length: 5, vsync: this);
    _dmAIToolsService = DMAIToolsService(aiAssistantService: _aiService);

    // Listen to session updates
    _sessionService.sessionUpdates.listen((gameSession) {
      if (mounted) {
        setState(() {
          _session = gameSession;
        });
      }
    });

    // Auto-save every 2 minutes
    if (_autoSaveEnabled) {
      Future.delayed(const Duration(minutes: 2), _autoSave);
    }
  }

  @override
  void dispose() {
    _sidebarTabController.dispose();
    super.dispose();
  }

  Future<void> _autoSave() async {
    if (!_autoSaveEnabled || !mounted) return;

    await _sessionService.saveCurrentSession();
    setState(() {
      _lastSaved = DateTime.now();
    });

    // Schedule next auto-save
    Future.delayed(const Duration(minutes: 2), _autoSave);
  }

  Future<void> _manualSave() async {
    await _sessionService.saveCurrentSession();
    setState(() {
      _lastSaved = DateTime.now();
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Session saved')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Row(
        children: [
          // Main 3-panel layout (Phase 1)
          Expanded(
            child: Row(
              children: [
                // Left: Party Panel (300px)
                SizedBox(
                  width: 300,
                  child: DMPartyPanel(
                    session: _session,
                    onCharacterTap: (character) {},
                    onAddPlayer: () {},
                  ),
                ),

                // Center: Narrative Center (flex: 3)
                Expanded(
                  flex: 3,
                  child: DMNarrativeCenter(
                    session: _session,
                    onSendResponse: (response, isSecret) {},
                    onUpdateScene: (description) {},
                  ),
                ),

                // Right: AI Assistant Panel (flex: 2)
                Expanded(
                  flex: 2,
                  child: DMAIAssistantPanel(
                    session: _session,
                    aiService: _aiService,
                    onUseSuggestion: (suggestion) {},
                  ),
                ),
              ],
            ),
          ),

          // Phase 2 Sidebar (collapsible)
          if (_showPhase2Sidebar)
            Container(
              width: 400,
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: Column(
                children: [
                  // Tab bar
                  Container(
                    color: Theme.of(context).primaryColor,
                    child: TabBar(
                      controller: _sidebarTabController,
                      isScrollable: true,
                      tabs: const [
                        Tab(icon: Icon(Icons.people), text: 'Relationships'),
                        Tab(icon: Icon(Icons.public), text: 'World'),
                        Tab(icon: Icon(Icons.auto_stories), text: 'Character'),
                        Tab(icon: Icon(Icons.construction), text: 'Economy'),
                        Tab(icon: Icon(Icons.psychology), text: 'AI Tools'),
                      ],
                    ),
                  ),

                  // Tab content
                  Expanded(
                    child: TabBarView(
                      controller: _sidebarTabController,
                      children: [
                        // Relationships
                        RelationshipTrackingPanel(
                          npcRelationships: _relationshipService.relationshipNetwork.npcRelationships,
                          onAddRelationshipEvent: (npcId, characterId, eventType, attitudeChange, description) {
                            _relationshipService.addRelationshipEvent(
                              npcId: npcId,
                              characterId: characterId,
                              eventType: eventType,
                              description: description,
                              attitudeChange: attitudeChange,
                              sessionDay: _session.gameTimeDays,
                            );
                            setState(() {});
                          },
                          currentCharacterId: _session.activeCharacters.isNotEmpty
                              ? _session.activeCharacters.first.id
                              : '',
                        ),

                        // World Events
                        WorldEventsPanel(
                          activeWorldEvents: _worldEventService.activeWorldEvents,
                          upcomingWorldEvents: _worldEventService.upcomingWorldEvents,
                          activeFactionConflicts: _worldEventService.activeFactionConflicts,
                          onTriggerWorldEvent: (eventId) {
                            _worldEventService.startWorldEvent(eventId, _session.gameTimeDays);
                            setState(() {});
                          },
                          onConcludeWorldEvent: (eventId, consequences) {
                            _worldEventService.concludeWorldEvent(
                              eventId: eventId,
                              currentGameDay: _session.gameTimeDays,
                              actualConsequences: consequences,
                            );
                            setState(() {});
                          },
                          onEscalateConflict: (conflictId, amount) {
                            _worldEventService.escalateFactionConflict(
                              conflictId,
                              amount,
                              _session.currentScene.location,
                            );
                            setState(() {});
                          },
                          onDeEscalateConflict: (conflictId, amount) {
                            _worldEventService.deEscalateFactionConflict(conflictId, amount);
                            setState(() {});
                          },
                          currentGameDay: _session.gameTimeDays,
                        ),

                        // Character Development
                        CharacterDevelopmentPanel(
                          personalQuests: _characterArcService
                              .getPersonalQuests(_session.activeCharacters.first.id),
                          characterArcs: _characterArcService
                              .getCharacterArcs(_session.activeCharacters.first.id),
                          growthMilestones: _characterArcService
                              .getGrowthMilestones(_session.activeCharacters.first.id),
                          onCompleteQuestObjective: (questId, objectiveId) {
                            _characterArcService.completeQuestObjective(questId, objectiveId);
                            setState(() {});
                          },
                          onAdvanceArcStage: (arcId) {
                            _characterArcService.advanceArcStage(arcId);
                            setState(() {});
                          },
                          characterId: _session.activeCharacters.isNotEmpty
                              ? _session.activeCharacters.first.id
                              : '',
                        ),

                        // Crafting & Economy
                        CraftingEconomyPanel(
                          activeCraftingProjects: _craftingService
                              .getCharacterActiveProjects(_session.activeCharacters.first.id),
                          availableRecipes: _craftingService.getAvailableRecipes(),
                          merchantInventories: [],
                          itemPrices: {},
                          onStartCraftingProject: (recipeId) {
                            // Start crafting project
                          },
                          onWorkOnProject: (projectId) {
                            // Work on project
                          },
                          onPurchaseItem: (merchantId, itemId, quantity) {
                            _economyService.purchaseItemFromMerchant(
                              merchantId: merchantId,
                              itemId: itemId,
                              quantity: quantity,
                              characterId: _session.activeCharacters.first.id,
                            );
                            setState(() {});
                          },
                          characterId: _session.activeCharacters.isNotEmpty
                              ? _session.activeCharacters.first.id
                              : '',
                        ),

                        // AI Tools
                        DMAIToolsPanel(
                          dmAIToolsService: _dmAIToolsService,
                          gameSession: _session,
                          onNPCGenerated: (npcGenerationResult) {
                            // Handle generated NPC
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Generated NPC: ${npcGenerationResult.npcName}'),
                              ),
                            );
                          },
                          onQuestHooksGenerated: (questHooks) {
                            // Handle generated quest hooks
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Generated ${questHooks.length} quest hooks'),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),

      // Floating action buttons
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Toggle Phase 2 sidebar
          FloatingActionButton(
            heroTag: 'toggle_phase2',
            onPressed: () {
              setState(() {
                _showPhase2Sidebar = !_showPhase2Sidebar;
              });
            },
            tooltip: _showPhase2Sidebar ? 'Hide Advanced Features' : 'Show Advanced Features',
            child: Icon(_showPhase2Sidebar ? Icons.chevron_right : Icons.extension),
          ),
          SizedBox(height: 8),

          // Start Combat
          FloatingActionButton(
            heroTag: 'start_combat',
            onPressed: _startCombat,
            tooltip: 'Start Combat',
            child: Icon(Icons.swords),
          ),
          SizedBox(height: 8),

          // Advance Time
          FloatingActionButton(
            heroTag: 'advance_time',
            onPressed: _advanceTime,
            tooltip: 'Advance Time',
            child: Icon(Icons.access_time),
          ),
          SizedBox(height: 8),

          // Add DM Note
          FloatingActionButton(
            heroTag: 'add_note',
            onPressed: _addDMNote,
            tooltip: 'Add DM Note',
            child: Icon(Icons.note_add),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('DM Control Center'),
          Text(
            'Session ${_session.sessionId.substring(0, 8)} • Day ${_session.gameTimeDays}',
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
      actions: [
        // Connected players
        Chip(
          avatar: Icon(Icons.people, size: 16),
          label: Text('${_session.players.length} players'),
        ),
        SizedBox(width: 8),

        // Auto-save status
        if (_lastSaved != null)
          Chip(
            avatar: Icon(Icons.check, size: 16),
            label: Text('Saved ${_formatTime(_lastSaved!)}'),
          ),
        SizedBox(width: 8),

        // Manual save
        IconButton(
          icon: Icon(Icons.save),
          onPressed: _manualSave,
          tooltip: 'Save Now',
        ),

        // Settings
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {},
          tooltip: 'Settings',
        ),
      ],
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) return 'just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    return '${difference.inDays}d ago';
  }

  void _startCombat() {
    // Combat initialization logic
  }

  void _advanceTime() {
    setState(() {
      _session.gameTimeDays++;
    });

    // Check for auto-triggered events
    _worldEventService.checkForAutoTriggers(_session.gameTimeDays);

    // Apply time-based updates
    _characterArcService.updateQuestTimeLimit(_session.gameTimeDays);
    _relationshipService.applyTimeDecay(_session.gameTimeDays);
    _economyService.applyDailyMarketFluctuations();
  }

  void _addDMNote() {
    // Show dialog to add DM note
  }
}
