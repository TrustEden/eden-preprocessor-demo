import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/campaign.dart';
import '../models/enhanced_character.dart';

/// Multiplayer event types
enum MultiplayerEventType {
  playerJoined,
  playerLeft,
  gameStateUpdate,
  chatMessage,
  actionPerformed,
  turnChanged,
  combatUpdate,
  characterUpdate,
  dmResponse,
}

/// Multiplayer event
class MultiplayerEvent {
  final MultiplayerEventType type;
  final String playerId;
  final Map<String, dynamic> data;
  final DateTime timestamp;

  MultiplayerEvent({
    required this.type,
    required this.playerId,
    required this.data,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'type': type.toString(),
        'playerId': playerId,
        'data': data,
        'timestamp': timestamp.toIso8601String(),
      };

  factory MultiplayerEvent.fromJson(Map<String, dynamic> json) {
    return MultiplayerEvent(
      type: MultiplayerEventType.values.firstWhere(
        (e) => e.toString() == json['type'],
      ),
      playerId: json['playerId'] as String,
      data: json['data'] as Map<String, dynamic>,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}

/// Player information
class PlayerInfo {
  final String playerId;
  final String playerName;
  final String? characterId;
  final bool isHost;
  final DateTime joinedAt;
  bool isConnected;

  PlayerInfo({
    required this.playerId,
    required this.playerName,
    this.characterId,
    this.isHost = false,
    DateTime? joinedAt,
    this.isConnected = true,
  }) : joinedAt = joinedAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'playerId': playerId,
        'playerName': playerName,
        'characterId': characterId,
        'isHost': isHost,
        'joinedAt': joinedAt.toIso8601String(),
        'isConnected': isConnected,
      };

  factory PlayerInfo.fromJson(Map<String, dynamic> json) => PlayerInfo(
        playerId: json['playerId'] as String,
        playerName: json['playerName'] as String,
        characterId: json['characterId'] as String?,
        isHost: json['isHost'] as bool? ?? false,
        joinedAt: DateTime.parse(json['joinedAt'] as String),
        isConnected: json['isConnected'] as bool? ?? true,
      );
}

/// Multiplayer service for real-time co-op campaigns
class MultiplayerService {
  static final MultiplayerService _instance = MultiplayerService._internal();
  factory MultiplayerService() => _instance;
  MultiplayerService._internal();

  // WebSocket connection
  WebSocketChannel? _channel;
  String? _wsServerUrl;

  // Current session
  String? _sessionId;
  String? _playerId;
  bool _isHost = false;

  // Players in session
  final Map<String, PlayerInfo> _players = {};

  // Event streams
  final _eventController = StreamController<MultiplayerEvent>.broadcast();
  Stream<MultiplayerEvent> get eventStream => _eventController.stream;

  final _playerListController = StreamController<List<PlayerInfo>>.broadcast();
  Stream<List<PlayerInfo>> get playerListStream => _playerListController.stream;

  final _connectionStatusController = StreamController<bool>.broadcast();
  Stream<bool> get connectionStatusStream => _connectionStatusController.stream;

  // Connection status
  bool get isConnected => _channel != null;
  bool get isHost => _isHost;
  String? get sessionId => _sessionId;
  String? get playerId => _playerId;
  List<PlayerInfo> get players => _players.values.toList();

  /// Configure the WebSocket server URL
  void setServerUrl(String url) {
    _wsServerUrl = url;
  }

  /// Host a new multiplayer session
  Future<String> hostSession({
    required Campaign campaign,
    required String playerName,
    required String playerId,
  }) async {
    if (_wsServerUrl == null) {
      throw Exception('WebSocket server URL not configured');
    }

    _playerId = playerId;
    _isHost = true;
    _sessionId = campaign.multiplayerSessionId ?? campaign.id;

    // Update campaign
    campaign.isMultiplayer = true;
    campaign.multiplayerSessionId = _sessionId;
    campaign.hostPlayerId = playerId;
    campaign.connectedPlayerIds = [playerId];

    // Connect to WebSocket server
    await _connect();

    // Send host session message
    _send({
      'action': 'host',
      'sessionId': _sessionId,
      'playerId': playerId,
      'playerName': playerName,
      'campaignData': campaign.toJson(),
    });

    // Add self to players
    _players[playerId] = PlayerInfo(
      playerId: playerId,
      playerName: playerName,
      isHost: true,
    );
    _playerListController.add(_players.values.toList());

    return _sessionId!;
  }

  /// Join an existing multiplayer session
  Future<void> joinSession({
    required String sessionId,
    required String playerName,
    required String playerId,
    String? characterId,
  }) async {
    if (_wsServerUrl == null) {
      throw Exception('WebSocket server URL not configured');
    }

    _playerId = playerId;
    _isHost = false;
    _sessionId = sessionId;

    // Connect to WebSocket server
    await _connect();

    // Send join message
    _send({
      'action': 'join',
      'sessionId': sessionId,
      'playerId': playerId,
      'playerName': playerName,
      'characterId': characterId,
    });
  }

  /// Leave the current session
  Future<void> leaveSession() async {
    if (_sessionId != null && _playerId != null) {
      _send({
        'action': 'leave',
        'sessionId': _sessionId,
        'playerId': _playerId,
      });
    }

    await _disconnect();
  }

  /// Send a multiplayer event
  void sendEvent(MultiplayerEvent event) {
    if (!isConnected) {
      throw Exception('Not connected to multiplayer session');
    }

    _send({
      'action': 'event',
      'sessionId': _sessionId,
      'event': event.toJson(),
    });
  }

  /// Broadcast a game state update
  void broadcastGameState(Campaign campaign) {
    sendEvent(MultiplayerEvent(
      type: MultiplayerEventType.gameStateUpdate,
      playerId: _playerId!,
      data: campaign.toJson(),
    ));
  }

  /// Send a chat message
  void sendChatMessage(String message) {
    sendEvent(MultiplayerEvent(
      type: MultiplayerEventType.chatMessage,
      playerId: _playerId!,
      data: {'message': message},
    ));
  }

  /// Broadcast a player action
  void broadcastAction({
    required String action,
    Map<String, dynamic>? actionData,
  }) {
    sendEvent(MultiplayerEvent(
      type: MultiplayerEventType.actionPerformed,
      playerId: _playerId!,
      data: {
        'action': action,
        'actionData': actionData ?? {},
      },
    ));
  }

  /// Update turn to next player
  void changeTurn(String nextPlayerId) {
    if (!_isHost) {
      throw Exception('Only the host can change turns');
    }

    sendEvent(MultiplayerEvent(
      type: MultiplayerEventType.turnChanged,
      playerId: _playerId!,
      data: {'currentTurnPlayerId': nextPlayerId},
    ));
  }

  /// Broadcast character update
  void broadcastCharacterUpdate(EnhancedCharacter character) {
    sendEvent(MultiplayerEvent(
      type: MultiplayerEventType.characterUpdate,
      playerId: _playerId!,
      data: character.toJson(),
    ));
  }

  /// Broadcast DM response (host only)
  void broadcastDMResponse(String response) {
    if (!_isHost) {
      throw Exception('Only the host can send DM responses');
    }

    sendEvent(MultiplayerEvent(
      type: MultiplayerEventType.dmResponse,
      playerId: _playerId!,
      data: {'response': response},
    ));
  }

  /// Connect to WebSocket server
  Future<void> _connect() async {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(_wsServerUrl!));

      // Listen to incoming messages
      _channel!.stream.listen(
        _handleMessage,
        onError: _handleError,
        onDone: _handleDisconnect,
        cancelOnError: false,
      );

      _connectionStatusController.add(true);
    } catch (e) {
      print('Failed to connect to multiplayer server: $e');
      _connectionStatusController.add(false);
      rethrow;
    }
  }

  /// Disconnect from WebSocket server
  Future<void> _disconnect() async {
    await _channel?.sink.close();
    _channel = null;
    _sessionId = null;
    _playerId = null;
    _isHost = false;
    _players.clear();
    _connectionStatusController.add(false);
  }

  /// Send data through WebSocket
  void _send(Map<String, dynamic> data) {
    if (_channel == null) {
      throw Exception('Not connected to server');
    }

    _channel!.sink.add(jsonEncode(data));
  }

  /// Handle incoming WebSocket message
  void _handleMessage(dynamic message) {
    try {
      final data = jsonDecode(message as String) as Map<String, dynamic>;
      final action = data['action'] as String?;

      switch (action) {
        case 'player_joined':
          _handlePlayerJoined(data);
          break;
        case 'player_left':
          _handlePlayerLeft(data);
          break;
        case 'event':
          _handleEvent(data);
          break;
        case 'player_list':
          _handlePlayerList(data);
          break;
        case 'error':
          print('Server error: ${data['message']}');
          break;
      }
    } catch (e) {
      print('Error handling message: $e');
    }
  }

  void _handlePlayerJoined(Map<String, dynamic> data) {
    final playerInfo = PlayerInfo.fromJson(data['player'] as Map<String, dynamic>);
    _players[playerInfo.playerId] = playerInfo;
    _playerListController.add(_players.values.toList());

    _eventController.add(MultiplayerEvent(
      type: MultiplayerEventType.playerJoined,
      playerId: playerInfo.playerId,
      data: {'playerName': playerInfo.playerName},
    ));
  }

  void _handlePlayerLeft(Map<String, dynamic> data) {
    final playerId = data['playerId'] as String;
    final player = _players.remove(playerId);
    _playerListController.add(_players.values.toList());

    if (player != null) {
      _eventController.add(MultiplayerEvent(
        type: MultiplayerEventType.playerLeft,
        playerId: playerId,
        data: {'playerName': player.playerName},
      ));
    }
  }

  void _handleEvent(Map<String, dynamic> data) {
    final event = MultiplayerEvent.fromJson(data['event'] as Map<String, dynamic>);
    _eventController.add(event);
  }

  void _handlePlayerList(Map<String, dynamic> data) {
    final players = (data['players'] as List<dynamic>)
        .map((p) => PlayerInfo.fromJson(p as Map<String, dynamic>))
        .toList();

    _players.clear();
    for (var player in players) {
      _players[player.playerId] = player;
    }
    _playerListController.add(_players.values.toList());
  }

  void _handleError(error) {
    print('WebSocket error: $error');
    _connectionStatusController.add(false);
  }

  void _handleDisconnect() {
    print('Disconnected from multiplayer server');
    _disconnect();
  }

  /// Dispose resources
  void dispose() {
    _disconnect();
    _eventController.close();
    _playerListController.close();
    _connectionStatusController.close();
  }
}
