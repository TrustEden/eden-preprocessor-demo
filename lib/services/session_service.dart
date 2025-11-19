import 'dart:async';
import 'package:uuid/uuid.dart';
import '../models/game_session.dart';
import '../models/enhanced_character.dart';
import 'database_service.dart';
import 'permission_service.dart';

/// Service to manage game sessions and coordinate DM/player interactions
class SessionService {
  static final SessionService _instance = SessionService._internal();
  factory SessionService() => _instance;
  SessionService._internal();

  final DatabaseService _db = DatabaseService();
  final PermissionService _permissions = PermissionService();
  final Uuid _uuid = const Uuid();

  // Current active session
  GameSession? _currentSession;

  // Stream controllers for real-time updates
  final _sessionUpdateController = StreamController<GameSession>.broadcast();
  final _eventController = StreamController<GameEvent>.broadcast();
  final _playerJoinController = StreamController<PlayerConnection>.broadcast();
  final _playerLeaveController = StreamController<String>.broadcast(); // playerId

  // Getters for streams
  Stream<GameSession> get sessionUpdates => _sessionUpdateController.stream;
  Stream<GameEvent> get gameEvents => _eventController.stream;
  Stream<PlayerConnection> get playerJoins => _playerJoinController.stream;
  Stream<String> get playerLeaves => _playerLeaveController.stream;

  /// Get current session
  GameSession? getCurrentSession() => _currentSession;

  /// Create a new session
  Future<GameSession> createSession({
    required String campaignName,
    required String dmPlayerId,
    required String dmPlayerName,
    String? campaignId,
  }) async {
    final sessionId = _uuid.v4();
    final actualCampaignId = campaignId ?? _uuid.v4();

    var session = GameSession(
      sessionId: sessionId,
      campaignId: actualCampaignId,
      campaignName: campaignName,
      dmPlayerId: dmPlayerId,
      currentScene: Scene(
        location: 'Tavern',
        description: 'You find yourselves in a cozy tavern. The fire crackles warmly, and the smell of roasted meat fills the air.',
        availableActions: ['Look around', 'Talk to bartender', 'Order drink'],
      ),
    );

    _currentSession = session;
    await _saveSession(session);
    _sessionUpdateController.add(session);

    return session;
  }

  /// Load an existing session
  Future<GameSession?> loadSession(String sessionId) async {
    // Load from database
    var session = await _db.loadGameSession(sessionId);

    if (session != null) {
      _currentSession = session;
      _sessionUpdateController.add(session);
    }

    return session;
  }

  /// Add a player to the session
  Future<void> addPlayer({
    required String playerId,
    required String playerName,
    EnhancedCharacter? character,
    SessionRole role = SessionRole.player,
  }) async {
    if (_currentSession == null) {
      throw StateError('No active session');
    }

    // Create player connection
    var connection = PlayerConnection(
      playerId: playerId,
      playerName: playerName,
      characterId: character?.id,
      role: role,
    );

    _currentSession!.players[playerId] = connection;

    // Add character if provided
    if (character != null) {
      _currentSession!.activeCharacters.add(character);
    }

    await _saveSession(_currentSession!);
    _playerJoinController.add(connection);
    _sessionUpdateController.add(_currentSession!);

    // Add event
    await addEvent(
      GameEvent(
        eventType: EventType.narrative,
        description: '$playerName joined the session',
        importance: 3,
      ),
    );
  }

  /// Remove a player from the session
  Future<void> removePlayer(String playerId, String requesterId) async {
    if (_currentSession == null) {
      throw StateError('No active session');
    }

    // Check permission
    if (!_permissions.canPerformAction(requesterId, GameAction.kickPlayer, _currentSession!)) {
      throw PermissionException('You do not have permission to remove players');
    }

    var connection = _currentSession!.players[playerId];
    if (connection == null) {
      throw ArgumentError('Player not found in session');
    }

    // Remove character
    if (connection.characterId != null) {
      _currentSession!.activeCharacters.removeWhere((c) => c.id == connection.characterId);
    }

    // Remove player
    _currentSession!.players.remove(playerId);

    await _saveSession(_currentSession!);
    _playerLeaveController.add(playerId);
    _sessionUpdateController.add(_currentSession!);

    // Add event
    await addEvent(
      GameEvent(
        eventType: EventType.narrative,
        description: '${connection.playerName} left the session',
        importance: 3,
      ),
    );
  }

  /// Update current scene
  Future<void> updateScene({
    required String requesterId,
    String? location,
    String? description,
    List<String>? visibleNPCIds,
    List<String>? availableActions,
  }) async {
    if (_currentSession == null) {
      throw StateError('No active session');
    }

    // Check permission
    if (!_permissions.canEdit(requesterId, ResourceType.scene, _currentSession!)) {
      throw PermissionException('You do not have permission to edit the scene');
    }

    if (location != null) {
      _currentSession!.currentScene.location = location;
    }
    if (description != null) {
      _currentSession!.currentScene.description = description;
    }
    if (visibleNPCIds != null) {
      _currentSession!.currentScene.visibleNPCIds = visibleNPCIds;
    }
    if (availableActions != null) {
      _currentSession!.currentScene.availableActions = availableActions;
    }

    await _saveSession(_currentSession!);
    _sessionUpdateController.add(_currentSession!);
  }

  /// Add a game event
  Future<void> addEvent(GameEvent event) async {
    if (_currentSession == null) {
      throw StateError('No active session');
    }

    _currentSession!.sharedHistory.add(event);
    await _saveSession(_currentSession!);

    _eventController.add(event);
    _sessionUpdateController.add(_currentSession!);
  }

  /// Add a DM secret event (only visible to DM)
  Future<void> addDMEvent({
    required String requesterId,
    required GameEvent event,
  }) async {
    if (_currentSession == null) {
      throw StateError('No active session');
    }

    // Verify DM
    if (!_permissions.canViewDMSecrets(requesterId, _currentSession!)) {
      throw PermissionException('Only the DM can add secret events');
    }

    event.isDMSecret = true;
    await addEvent(event);
  }

  /// Get visible events for a player
  List<GameEvent> getVisibleEvents(String playerId) {
    if (_currentSession == null) return [];
    return _permissions.getVisibleEvents(playerId, _currentSession!.sharedHistory, _currentSession!);
  }

  /// Update character
  Future<void> updateCharacter({
    required String requesterId,
    required EnhancedCharacter character,
  }) async {
    if (_currentSession == null) {
      throw StateError('No active session');
    }

    // Check permission
    if (!_permissions.canEdit(requesterId, ResourceType.ownCharacter, _currentSession!, resourceId: character.id)) {
      throw PermissionException('You do not have permission to edit this character');
    }

    // Find and update character
    int index = _currentSession!.activeCharacters.indexWhere((c) => c.id == character.id);
    if (index != -1) {
      _currentSession!.activeCharacters[index] = character;
      await _saveSession(_currentSession!);
      _sessionUpdateController.add(_currentSession!);
    }
  }

  /// Advance game time
  Future<void> advanceTime({
    required String requesterId,
    required int days,
  }) async {
    if (_currentSession == null) {
      throw StateError('No active session');
    }

    // Check permission
    if (!_permissions.canPerformAction(requesterId, GameAction.advanceTime, _currentSession!)) {
      throw PermissionException('Only the DM can advance time');
    }

    _currentSession!.gameTimeDays += days;
    await _saveSession(_currentSession!);
    _sessionUpdateController.add(_currentSession!);

    // Add event
    await addEvent(
      GameEvent(
        eventType: EventType.narrative,
        description: '$days day(s) pass...',
        importance: 5,
      ),
    );
  }

  /// Start combat
  Future<void> startCombat({
    required String requesterId,
    required CombatState combatState,
  }) async {
    if (_currentSession == null) {
      throw StateError('No active session');
    }

    // Check permission
    if (!_permissions.canPerformAction(requesterId, GameAction.startCombat, _currentSession!)) {
      throw PermissionException('You do not have permission to start combat');
    }

    _currentSession!.activeCombat = combatState;
    await _saveSession(_currentSession!);
    _sessionUpdateController.add(_currentSession!);

    // Add event
    await addEvent(
      GameEvent(
        eventType: EventType.combat,
        description: 'Combat begins!',
        importance: 8,
      ),
    );
  }

  /// End combat
  Future<void> endCombat({
    required String requesterId,
    String? outcome,
  }) async {
    if (_currentSession == null) {
      throw StateError('No active session');
    }

    // Check permission
    if (!_permissions.canPerformAction(requesterId, GameAction.endCombat, _currentSession!)) {
      throw PermissionException('You do not have permission to end combat');
    }

    _currentSession!.activeCombat = null;
    await _saveSession(_currentSession!);
    _sessionUpdateController.add(_currentSession!);

    // Add event
    await addEvent(
      GameEvent(
        eventType: EventType.combat,
        description: outcome ?? 'Combat ends',
        importance: 8,
      ),
    );
  }

  /// Save current session
  Future<void> saveCurrentSession() async {
    if (_currentSession != null) {
      await _saveSession(_currentSession!);
    }
  }

  /// Private: Save session to database
  Future<void> _saveSession(GameSession session) async {
    session.lastSaved = DateTime.now();
    await _db.saveGameSession(session);
  }

  /// End current session (cleanup)
  Future<void> endSession() async {
    if (_currentSession != null) {
      await _saveSession(_currentSession!);
      _currentSession = null;
    }
  }

  /// Add DM note
  Future<void> addDMNote({
    required String requesterId,
    required String note,
  }) async {
    if (_currentSession == null) {
      throw StateError('No active session');
    }

    if (!_permissions.canViewDMSecrets(requesterId, _currentSession!)) {
      throw PermissionException('Only the DM can add notes');
    }

    _currentSession!.dmSecrets.dmNotes.add(note);
    await _saveSession(_currentSession!);
    _sessionUpdateController.add(_currentSession!);
  }

  /// Add NPC secret
  Future<void> addNPCSecret({
    required String requesterId,
    required String npcId,
    required String secret,
  }) async {
    if (_currentSession == null) {
      throw StateError('No active session');
    }

    if (!_permissions.canViewDMSecrets(requesterId, _currentSession!)) {
      throw PermissionException('Only the DM can add NPC secrets');
    }

    _currentSession!.dmSecrets.npcSecrets[npcId] = secret;
    await _saveSession(_currentSession!);
    _sessionUpdateController.add(_currentSession!);
  }

  /// Get session statistics
  SessionStats getSessionStats() {
    if (_currentSession == null) {
      return SessionStats(
        totalEvents: 0,
        combatEncounters: 0,
        questsActive: 0,
        questsCompleted: 0,
        gameTimeDays: 0,
      );
    }

    return SessionStats(
      totalEvents: _currentSession!.sharedHistory.length,
      combatEncounters: _currentSession!.sharedHistory.where((e) => e.eventType == EventType.combat).length,
      questsActive: _currentSession!.activeQuests.length,
      questsCompleted: _currentSession!.completedQuests.length,
      gameTimeDays: _currentSession!.gameTimeDays,
    );
  }

  /// Dispose resources
  void dispose() {
    _sessionUpdateController.close();
    _eventController.close();
    _playerJoinController.close();
    _playerLeaveController.close();
  }
}

/// Session statistics
class SessionStats {
  final int totalEvents;
  final int combatEncounters;
  final int questsActive;
  final int questsCompleted;
  final int gameTimeDays;

  SessionStats({
    required this.totalEvents,
    required this.combatEncounters,
    required this.questsActive,
    required this.questsCompleted,
    required this.gameTimeDays,
  });
}

/// Permission exception
class PermissionException implements Exception {
  final String message;

  PermissionException(this.message);

  @override
  String toString() => 'PermissionException: $message';
}
