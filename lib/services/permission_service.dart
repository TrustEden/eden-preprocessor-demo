import '../models/game_session.dart';

/// Service to manage permissions for different session roles
class PermissionService {
  static final PermissionService _instance = PermissionService._internal();
  factory PermissionService() => _instance;
  PermissionService._internal();

  /// Check if a player can view a specific game event
  bool canViewEvent(String playerId, GameEvent event, GameSession session) {
    var role = _getRole(playerId, session);

    // DM can see everything
    if (role == SessionRole.dungeonMaster) return true;

    // Co-hosts can see most things except personal DM notes
    if (role == SessionRole.coHost) {
      if (event.eventType == EventType.dmNote) return false;
      return !event.isDMSecret;
    }

    // Players and observers can only see non-secret events
    return !event.isDMSecret;
  }

  /// Check if a player can edit a specific resource type
  bool canEdit(String playerId, ResourceType resourceType, GameSession session, {String? resourceId}) {
    var role = _getRole(playerId, session);

    switch (resourceType) {
      case ResourceType.scene:
        return role == SessionRole.dungeonMaster;

      case ResourceType.ownCharacter:
        // Players can edit their own character
        if (role == SessionRole.player || role == SessionRole.dungeonMaster) {
          if (resourceId != null) {
            var character = session.getCharacterForPlayer(playerId);
            return character?.id == resourceId;
          }
          return true;
        }
        return false;

      case ResourceType.anyCharacter:
        return role == SessionRole.dungeonMaster;

      case ResourceType.npc:
        return role == SessionRole.dungeonMaster || role == SessionRole.coHost;

      case ResourceType.monster:
        return role == SessionRole.dungeonMaster || role == SessionRole.coHost;

      case ResourceType.combat:
        return role == SessionRole.dungeonMaster || role == SessionRole.coHost;

      case ResourceType.quest:
        return role == SessionRole.dungeonMaster;

      case ResourceType.dmSecrets:
        return role == SessionRole.dungeonMaster;

      case ResourceType.campaign:
        return role == SessionRole.dungeonMaster;

      case ResourceType.loot:
        // DM controls loot distribution
        return role == SessionRole.dungeonMaster;
    }
  }

  /// Check if a player can perform a specific action
  bool canPerformAction(String playerId, GameAction action, GameSession session) {
    var role = _getRole(playerId, session);

    switch (action) {
      case GameAction.sendChatMessage:
        return role != SessionRole.observer;

      case GameAction.rollDice:
        return role != SessionRole.observer;

      case GameAction.controlCharacter:
        if (role == SessionRole.observer) return false;
        return true;

      case GameAction.startCombat:
        return role == SessionRole.dungeonMaster || role == SessionRole.coHost;

      case GameAction.endCombat:
        return role == SessionRole.dungeonMaster || role == SessionRole.coHost;

      case GameAction.advanceTime:
        return role == SessionRole.dungeonMaster;

      case GameAction.awardXP:
        return role == SessionRole.dungeonMaster;

      case GameAction.modifyNPC:
        return role == SessionRole.dungeonMaster || role == SessionRole.coHost;

      case GameAction.triggerEvent:
        return role == SessionRole.dungeonMaster;

      case GameAction.editScene:
        return role == SessionRole.dungeonMaster;

      case GameAction.kickPlayer:
        return role == SessionRole.dungeonMaster;

      case GameAction.pauseSession:
        return role == SessionRole.dungeonMaster;

      case GameAction.saveSession:
        return role == SessionRole.dungeonMaster;

      case GameAction.useAI:
        return role == SessionRole.dungeonMaster || role == SessionRole.coHost;
    }
  }

  /// Check if player can view DM secrets
  bool canViewDMSecrets(String playerId, GameSession session) {
    return _getRole(playerId, session) == SessionRole.dungeonMaster;
  }

  /// Check if player can invite others
  bool canInvitePlayers(String playerId, GameSession session) {
    var role = _getRole(playerId, session);
    return role == SessionRole.dungeonMaster || role == SessionRole.coHost;
  }

  /// Check if player can change another player's role
  bool canChangeRole(String playerId, String targetPlayerId, GameSession session) {
    var role = _getRole(playerId, session);
    var targetRole = _getRole(targetPlayerId, session);

    // Only DM can change roles
    if (role != SessionRole.dungeonMaster) return false;

    // Can't change own role
    if (playerId == targetPlayerId) return false;

    // Can't demote the DM
    if (targetRole == SessionRole.dungeonMaster) return false;

    return true;
  }

  /// Get filtered events based on player permissions
  List<GameEvent> getVisibleEvents(String playerId, List<GameEvent> allEvents, GameSession session) {
    return allEvents.where((event) => canViewEvent(playerId, event, session)).toList();
  }

  /// Get filtered DM secrets if player has permission
  DMSecrets? getVisibleSecrets(String playerId, GameSession session) {
    if (!canViewDMSecrets(playerId, session)) {
      return null;
    }
    return session.dmSecrets;
  }

  /// Helper to get player role
  SessionRole _getRole(String playerId, GameSession session) {
    // Check if DM
    if (playerId == session.dmPlayerId) {
      return SessionRole.dungeonMaster;
    }

    // Check player list
    var connection = session.players[playerId];
    if (connection != null) {
      return connection.role;
    }

    // Default to observer if not found
    return SessionRole.observer;
  }

  /// Check if action requires DM approval
  bool requiresDMApproval(GameAction action) {
    switch (action) {
      case GameAction.awardXP:
      case GameAction.modifyNPC:
      case GameAction.startCombat:
      case GameAction.triggerEvent:
        return true;
      default:
        return false;
    }
  }

  /// Get role display name
  String getRoleDisplayName(SessionRole role) {
    switch (role) {
      case SessionRole.dungeonMaster:
        return 'Dungeon Master';
      case SessionRole.player:
        return 'Player';
      case SessionRole.observer:
        return 'Observer';
      case SessionRole.coHost:
        return 'Co-Host';
    }
  }

  /// Get role description
  String getRoleDescription(SessionRole role) {
    switch (role) {
      case SessionRole.dungeonMaster:
        return 'Full control over the game. Can edit everything, use AI tools, and manage players.';
      case SessionRole.player:
        return 'Can control their own character, interact with the world, and participate in combat.';
      case SessionRole.observer:
        return 'Read-only access. Can watch the game but cannot interact.';
      case SessionRole.coHost:
        return 'Assistant DM. Can control NPCs/monsters and help manage combat.';
    }
  }

  /// Get list of actions available to a role
  List<GameAction> getAvailableActions(SessionRole role) {
    List<GameAction> actions = [];

    for (var action in GameAction.values) {
      // Create a mock session to test permissions
      var mockSession = GameSession(
        sessionId: 'mock',
        campaignId: 'mock',
        campaignName: 'Mock',
        dmPlayerId: 'dm',
        currentScene: Scene(location: 'Mock', description: 'Mock'),
      );

      String testPlayerId = role == SessionRole.dungeonMaster ? 'dm' : 'player';
      if (role != SessionRole.dungeonMaster) {
        mockSession.players[testPlayerId] = PlayerConnection(
          playerId: testPlayerId,
          playerName: 'Test',
          role: role,
        );
      }

      if (canPerformAction(testPlayerId, action, mockSession)) {
        actions.add(action);
      }
    }

    return actions;
  }
}

/// Types of resources that can be edited
enum ResourceType {
  scene, // Current scene description
  ownCharacter, // Player's own character
  anyCharacter, // Any character in the party
  npc, // Non-player characters
  monster, // Enemy monsters
  combat, // Combat state
  quest, // Quest information
  dmSecrets, // DM-only information
  campaign, // Campaign settings
  loot, // Treasure and items
}

/// Actions that can be performed in the game
enum GameAction {
  sendChatMessage,
  rollDice,
  controlCharacter,
  startCombat,
  endCombat,
  advanceTime,
  awardXP,
  modifyNPC,
  triggerEvent,
  editScene,
  kickPlayer,
  pauseSession,
  saveSession,
  useAI,
}

/// Permission check result with reason
class PermissionCheckResult {
  bool allowed;
  String? reason;

  PermissionCheckResult({
    required this.allowed,
    this.reason,
  });

  factory PermissionCheckResult.allow() {
    return PermissionCheckResult(allowed: true);
  }

  factory PermissionCheckResult.deny(String reason) {
    return PermissionCheckResult(allowed: false, reason: reason);
  }
}
