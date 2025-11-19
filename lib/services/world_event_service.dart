import 'package:eden_preprocessor_demo/models/world_events.dart';
import 'package:uuid/uuid.dart';

/// Service for managing dynamic world events and faction conflicts
class WorldEventService {
  final List<WorldEvent> _activeWorldEvents = [];
  final List<WorldEvent> _upcomingWorldEvents = [];
  final List<WorldEvent> _completedWorldEvents = [];
  final List<FactionConflict> _activeFactionConflicts = [];

  final Uuid _uuid = const Uuid();

  /// Get all active world events
  List<WorldEvent> get activeWorldEvents => List.unmodifiable(_activeWorldEvents);

  /// Get upcoming world events
  List<WorldEvent> get upcomingWorldEvents => List.unmodifiable(_upcomingWorldEvents);

  /// Get completed world events
  List<WorldEvent> get completedWorldEvents => List.unmodifiable(_completedWorldEvents);

  /// Get active faction conflicts
  List<FactionConflict> get activeFactionConflicts => List.unmodifiable(_activeFactionConflicts);

  /// Create a new world event
  WorldEvent createWorldEvent({
    required String eventName,
    required String description,
    required WorldEventType eventType,
    required EventScale eventScale,
    required String narrativeHook,
    int? scheduledDay,
    int? durationDays,
    List<String>? affectedLocations,
    List<String>? affectedFactions,
    Map<String, int>? factionStandingChanges,
    Map<String, double>? economicImpacts,
    List<EventConsequence>? possibleConsequences,
    bool canPlayerIntervene = true,
    EventTrigger? eventTrigger,
  }) {
    var worldEvent = WorldEvent(
      eventId: _uuid.v4(),
      eventName: eventName,
      description: description,
      eventType: eventType,
      eventScale: eventScale,
      narrativeHook: narrativeHook,
      scheduledDay: scheduledDay,
      durationDays: durationDays,
      affectedLocations: affectedLocations,
      affectedFactions: affectedFactions,
      factionStandingChanges: factionStandingChanges,
      economicImpacts: economicImpacts,
      possibleConsequences: possibleConsequences,
      canPlayerIntervene: canPlayerIntervene,
      eventTrigger: eventTrigger,
    );

    _upcomingWorldEvents.add(worldEvent);
    return worldEvent;
  }

  /// Start a world event
  void startWorldEvent(String eventId, int currentGameDay) {
    var worldEvent = _upcomingWorldEvents.firstWhere((e) => e.eventId == eventId);
    worldEvent.startEvent(currentGameDay);
    _upcomingWorldEvents.remove(worldEvent);
    _activeWorldEvents.add(worldEvent);
  }

  /// Update world event status
  void updateWorldEventStatus(String eventId, WorldEventStatus newStatus) {
    var worldEvent = _activeWorldEvents.firstWhere((e) => e.eventId == eventId);
    worldEvent.eventStatus = newStatus;
  }

  /// Conclude a world event
  void concludeWorldEvent({
    required String eventId,
    required int currentGameDay,
    required List<EventConsequence> actualConsequences,
  }) {
    var worldEvent = _activeWorldEvents.firstWhere((e) => e.eventId == eventId);
    worldEvent.concludeEvent(currentGameDay, actualConsequences);
    _activeWorldEvents.remove(worldEvent);
    _completedWorldEvents.add(worldEvent);
  }

  /// Cancel a world event (prevented by players)
  void cancelWorldEvent({
    required String eventId,
    required int currentGameDay,
    required String reason,
  }) {
    var worldEvent = _activeWorldEvents.firstWhere((e) => e.eventId == eventId);
    worldEvent.cancelEvent(currentGameDay, reason);
    _activeWorldEvents.remove(worldEvent);
    _completedWorldEvents.add(worldEvent);
  }

  /// Add narrative update to event
  void addNarrativeUpdate(String eventId, String narrativeUpdate) {
    var worldEvent = _activeWorldEvents.firstWhere((e) => e.eventId == eventId);
    worldEvent.narrativeUpdates.add(narrativeUpdate);
  }

  /// Make players aware of an event
  void makePlayersAwareOfEvent(String eventId) {
    var worldEvent = _activeWorldEvents.firstWhere((e) => e.eventId == eventId);
    worldEvent.playerAware = true;
  }

  /// Check for events that should auto-trigger
  List<WorldEvent> checkForAutoTriggers(int currentGameDay) {
    var triggeredEvents = <WorldEvent>[];

    for (var worldEvent in _upcomingWorldEvents) {
      if (worldEvent.shouldTrigger(currentGameDay)) {
        startWorldEvent(worldEvent.eventId, currentGameDay);
        triggeredEvents.add(worldEvent);
      }
    }

    return triggeredEvents;
  }

  /// Create faction conflict
  FactionConflict createFactionConflict({
    required String conflictName,
    required String faction1Id,
    required String faction2Id,
    required ConflictType conflictType,
    int initialIntensity = 25,
    List<ConflictResolution>? possibleResolutions,
  }) {
    var factionConflict = FactionConflict(
      conflictId: _uuid.v4(),
      conflictName: conflictName,
      faction1Id: faction1Id,
      faction2Id: faction2Id,
      conflictType: conflictType,
      conflictIntensity: initialIntensity,
      possibleResolutions: possibleResolutions,
    );

    _activeFactionConflicts.add(factionConflict);
    return factionConflict;
  }

  /// Escalate faction conflict
  void escalateFactionConflict(String conflictId, int amount, String location) {
    var factionConflict = _activeFactionConflicts.firstWhere((c) => c.conflictId == conflictId);
    factionConflict.escalate(amount);

    if (!factionConflict.battleLocations.contains(location)) {
      factionConflict.battleLocations.add(location);
    }
  }

  /// De-escalate faction conflict
  void deEscalateFactionConflict(String conflictId, int amount) {
    var factionConflict = _activeFactionConflicts.firstWhere((c) => c.conflictId == conflictId);
    factionConflict.deEscalate(amount);
  }

  /// Set player alignment in conflict
  void setPlayerAlignmentInConflict(String conflictId, String factionId) {
    var factionConflict = _activeFactionConflicts.firstWhere((c) => c.conflictId == conflictId);
    factionConflict.playerAlignedFaction = factionId;
  }

  /// Update player influence in conflict
  void updatePlayerInfluenceInConflict(String conflictId, int influenceChange) {
    var factionConflict = _activeFactionConflicts.firstWhere((c) => c.conflictId == conflictId);
    factionConflict.playerInfluence =
        (factionConflict.playerInfluence + influenceChange).clamp(0, 100);
  }

  /// Resolve faction conflict
  void resolveFactionConflict(String conflictId, ConflictResolution resolution) {
    var factionConflict = _activeFactionConflicts.firstWhere((c) => c.conflictId == conflictId);
    factionConflict.resolve(resolution);
    _activeFactionConflicts.remove(factionConflict);
  }

  /// Get events affecting a specific location
  List<WorldEvent> getEventsAffectingLocation(String locationId) {
    return _activeWorldEvents
        .where((e) => e.affectedLocations.contains(locationId))
        .toList();
  }

  /// Get events affecting a specific faction
  List<WorldEvent> getEventsAffectingFaction(String factionId) {
    return _activeWorldEvents
        .where((e) => e.affectedFactions.contains(factionId))
        .toList();
  }

  /// Get conflicts involving a faction
  List<FactionConflict> getConflictsInvolvingFaction(String factionId) {
    return _activeFactionConflicts
        .where((c) => c.faction1Id == factionId || c.faction2Id == factionId)
        .toList();
  }

  /// Get player-known events (for player view)
  List<WorldEvent> getPlayerKnownEvents() {
    return _activeWorldEvents.where((e) => e.playerAware).toList();
  }

  /// Calculate cumulative faction standing changes from events
  Map<String, int> calculateFactionStandingChanges(String factionId) {
    Map<String, int> totalChanges = {};

    for (var worldEvent in _completedWorldEvents) {
      if (worldEvent.factionStandingChanges.containsKey(factionId)) {
        var existingChange = totalChanges[factionId] ?? 0;
        totalChanges[factionId] = existingChange + worldEvent.factionStandingChanges[factionId]!;
      }
    }

    return totalChanges;
  }

  /// Calculate cumulative economic impacts
  Map<String, double> calculateEconomicImpacts(String itemCategory) {
    double totalModifier = 1.0;

    for (var worldEvent in _activeWorldEvents) {
      if (worldEvent.economicImpacts.containsKey(itemCategory)) {
        totalModifier *= worldEvent.economicImpacts[itemCategory]!;
      }
    }

    return {itemCategory: totalModifier};
  }

  /// Get event summary for AI context
  String getEventSummaryForAI() {
    var summary = StringBuffer();

    if (_activeWorldEvents.isNotEmpty) {
      summary.writeln('Active World Events:');
      for (var worldEvent in _activeWorldEvents) {
        summary.writeln('- ${worldEvent.eventName} (${worldEvent.eventType.name}): ${worldEvent.description}');
        if (worldEvent.narrativeUpdates.isNotEmpty) {
          summary.writeln('  Latest: ${worldEvent.narrativeUpdates.last}');
        }
      }
    }

    if (_activeFactionConflicts.isNotEmpty) {
      summary.writeln('\nActive Faction Conflicts:');
      for (var factionConflict in _activeFactionConflicts) {
        summary.writeln('- ${factionConflict.conflictName} (${factionConflict.conflictType.name})');
        summary.writeln('  Status: ${factionConflict.conflictStatus.name}, Intensity: ${factionConflict.conflictIntensity}/100');
        if (factionConflict.playerAlignedFaction != null) {
          summary.writeln('  Players support: ${factionConflict.playerAlignedFaction}');
        }
      }
    }

    return summary.toString();
  }

  /// Get upcoming events summary
  String getUpcomingEventsSummary() {
    var summary = StringBuffer();
    summary.writeln('Upcoming World Events:');

    for (var worldEvent in _upcomingWorldEvents) {
      summary.writeln('- ${worldEvent.eventName}');
      if (worldEvent.scheduledDay != null) {
        summary.writeln('  Scheduled for day ${worldEvent.scheduledDay}');
      }
    }

    return summary.toString();
  }

  /// Trigger event manually (DM action)
  void triggerEventManually(String eventId, int currentGameDay) {
    var worldEvent = _upcomingWorldEvents.firstWhere((e) => e.eventId == eventId);
    startWorldEvent(eventId, currentGameDay);
  }

  /// Set winning faction in conflict
  void setWinningFactionInConflict(String conflictId, String factionId) {
    var factionConflict = _activeFactionConflicts.firstWhere((c) => c.conflictId == conflictId);
    factionConflict.winningFactionId = factionId;
  }

  /// Get event by ID
  WorldEvent? getWorldEventById(String eventId) {
    try {
      return _activeWorldEvents.firstWhere((e) => e.eventId == eventId);
    } catch (e) {
      try {
        return _upcomingWorldEvents.firstWhere((e) => e.eventId == eventId);
      } catch (e) {
        try {
          return _completedWorldEvents.firstWhere((e) => e.eventId == eventId);
        } catch (e) {
          return null;
        }
      }
    }
  }

  /// Get conflict by ID
  FactionConflict? getFactionConflictById(String conflictId) {
    try {
      return _activeFactionConflicts.firstWhere((c) => c.conflictId == conflictId);
    } catch (e) {
      return null;
    }
  }
}
