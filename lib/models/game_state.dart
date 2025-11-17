import 'character.dart';
import 'combat_state.dart';

class GameState {
  String campaignId;
  String campaignName;
  Character character;

  // Narrative tracking
  List<GameEvent> narrativeHistory;
  String currentLocation;
  String currentSceneDescription;

  // Combat state (null when not in combat)
  CombatState? activeCombat;

  // Simple quest tracking
  List<String> activeObjectives;
  List<String> completedObjectives;

  // Meta
  DateTime lastSaved;
  int sessionNumber;

  GameState({
    required this.campaignId,
    required this.campaignName,
    required this.character,
    List<GameEvent>? narrativeHistory,
    required this.currentLocation,
    required this.currentSceneDescription,
    this.activeCombat,
    List<String>? activeObjectives,
    List<String>? completedObjectives,
    DateTime? lastSaved,
    this.sessionNumber = 1,
  })  : narrativeHistory = narrativeHistory ?? [],
        activeObjectives = activeObjectives ?? [],
        completedObjectives = completedObjectives ?? [],
        lastSaved = lastSaved ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'campaignId': campaignId,
        'campaignName': campaignName,
        'character': character.toJson(),
        'narrativeHistory':
            narrativeHistory.map((e) => e.toJson()).toList(),
        'currentLocation': currentLocation,
        'currentSceneDescription': currentSceneDescription,
        'activeCombat': activeCombat?.toJson(),
        'activeObjectives': activeObjectives,
        'completedObjectives': completedObjectives,
        'lastSaved': lastSaved.toIso8601String(),
        'sessionNumber': sessionNumber,
      };

  factory GameState.fromJson(Map<String, dynamic> json) => GameState(
        campaignId: json['campaignId'] as String,
        campaignName: json['campaignName'] as String,
        character: Character.fromJson(json['character'] as Map<String, dynamic>),
        narrativeHistory: (json['narrativeHistory'] as List<dynamic>?)
            ?.map((e) => GameEvent.fromJson(e as Map<String, dynamic>))
            .toList(),
        currentLocation: json['currentLocation'] as String,
        currentSceneDescription: json['currentSceneDescription'] as String,
        activeCombat: json['activeCombat'] != null
            ? CombatState.fromJson(json['activeCombat'] as Map<String, dynamic>)
            : null,
        activeObjectives:
            (json['activeObjectives'] as List<dynamic>?)?.cast<String>(),
        completedObjectives:
            (json['completedObjectives'] as List<dynamic>?)?.cast<String>(),
        lastSaved: DateTime.parse(json['lastSaved'] as String),
        sessionNumber: json['sessionNumber'] as int? ?? 1,
      );
}

class GameEvent {
  DateTime timestamp;
  String eventType; // "narrative", "combat", "skill_check", "level_up"
  String description;
  String? playerAction;
  String? dmResponse;
  Map<String, dynamic>? metadata;

  GameEvent({
    DateTime? timestamp,
    required this.eventType,
    required this.description,
    this.playerAction,
    this.dmResponse,
    this.metadata,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp.toIso8601String(),
        'eventType': eventType,
        'description': description,
        'playerAction': playerAction,
        'dmResponse': dmResponse,
        'metadata': metadata,
      };

  factory GameEvent.fromJson(Map<String, dynamic> json) => GameEvent(
        timestamp: DateTime.parse(json['timestamp'] as String),
        eventType: json['eventType'] as String,
        description: json['description'] as String,
        playerAction: json['playerAction'] as String?,
        dmResponse: json['dmResponse'] as String?,
        metadata: json['metadata'] as Map<String, dynamic>?,
      );
}
