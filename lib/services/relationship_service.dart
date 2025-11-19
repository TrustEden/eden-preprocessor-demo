import 'package:eden_preprocessor_demo/models/relationship_system.dart';
import 'package:uuid/uuid.dart';

/// Service for managing NPC relationships and party dynamics
class RelationshipService {
  final RelationshipNetwork _relationshipNetwork;
  final Uuid _uuid = const Uuid();

  RelationshipService({RelationshipNetwork? relationshipNetwork})
      : _relationshipNetwork = relationshipNetwork ?? RelationshipNetwork();

  /// Get the relationship network
  RelationshipNetwork get relationshipNetwork => _relationshipNetwork;

  /// Get or create relationship with NPC
  NPCRelationship getOrCreateNPCRelationship({
    required String npcId,
    required String npcName,
    required String characterId,
    bool isMerchant = false,
    bool isQuestGiver = false,
    bool isRomanceable = false,
    String? factionId,
  }) {
    var relationship = _relationshipNetwork.getOrCreateNPCRelationship(
      npcId: npcId,
      npcName: npcName,
      characterId: characterId,
      isMerchant: isMerchant,
      isQuestGiver: isQuestGiver,
    );

    // Update additional properties if creating new
    relationship.isRomanceable = isRomanceable;
    relationship.factionId = factionId;

    return relationship;
  }

  /// Add a relationship event
  void addRelationshipEvent({
    required String npcId,
    required String characterId,
    required RelationshipEventType eventType,
    required String description,
    required int attitudeChange,
    required int sessionDay,
    String? relatedQuestId,
    bool isMemorableEvent = false,
  }) {
    String key = '${npcId}_$characterId';
    var relationship = _relationshipNetwork.npcRelationships[key];

    if (relationship == null) {
      throw Exception('Relationship not found for NPC $npcId and character $characterId');
    }

    var event = RelationshipEvent(
      eventId: _uuid.v4(),
      eventType: eventType,
      description: description,
      attitudeChange: attitudeChange,
      timestamp: DateTime.now(),
      sessionDay: sessionDay,
      relatedQuestId: relatedQuestId,
      isMemorableEvent: isMemorableEvent,
    );

    relationship.addRelationshipEvent(event);
    relationship.totalInteractions++;
    relationship.lastInteractionDate = DateTime.now();
  }

  /// Get relationship attitude
  int getRelationshipAttitude(String npcId, String characterId) {
    String key = '${npcId}_$characterId';
    var relationship = _relationshipNetwork.npcRelationships[key];
    return relationship?.currentAttitude ?? 0;
  }

  /// Get relationship tier
  RelationshipTier getRelationshipTier(String npcId, String characterId) {
    String key = '${npcId}_$characterId';
    var relationship = _relationshipNetwork.npcRelationships[key];
    return relationship?.currentTier ?? RelationshipTier.neutral;
  }

  /// Get merchant price modifier
  double getMerchantPriceModifier(String npcId, String characterId) {
    String key = '${npcId}_$characterId';
    var relationship = _relationshipNetwork.npcRelationships[key];
    return relationship?.getMerchantPriceModifier() ?? 1.0;
  }

  /// Check if NPC will offer a service
  bool willNPCOfferService({
    required String npcId,
    required String characterId,
    required String serviceType,
  }) {
    String key = '${npcId}_$characterId';
    var relationship = _relationshipNetwork.npcRelationships[key];
    return relationship?.willOfferService(serviceType) ?? false;
  }

  /// Get memorable events for dialogue
  List<RelationshipEvent> getMemorableEvents(String npcId, String characterId) {
    String key = '${npcId}_$characterId';
    var relationship = _relationshipNetwork.npcRelationships[key];
    return relationship?.getMemorableEvents() ?? [];
  }

  /// Apply time decay to all relationships
  void applyTimeDecay(int currentSessionDay) {
    for (var relationship in _relationshipNetwork.npcRelationships.values) {
      if (relationship.lastInteractionDate != null) {
        final daysSinceInteraction = currentSessionDay -
            (relationship.lastInteractionDate!.difference(DateTime.now()).inDays);
        relationship.applyTimeDecay(daysSinceInteraction);
      }
    }
  }

  /// Get all relationships for a character
  List<NPCRelationship> getCharacterRelationships(String characterId) {
    return _relationshipNetwork.getCharacterRelationships(characterId);
  }

  /// Get all relationships with an NPC across all characters
  List<NPCRelationship> getNPCRelationships(String npcId) {
    return _relationshipNetwork.getNPCRelationships(npcId);
  }

  /// Update party relationship
  void updatePartyRelationship({
    required String characterId1,
    required String characterId2,
    required int attitudeChange,
    String? reason,
  }) {
    _relationshipNetwork.updatePartyRelationship(
      characterId1,
      characterId2,
      attitudeChange,
    );
  }

  /// Get party relationship
  int getPartyRelationship(String characterId1, String characterId2) {
    return _relationshipNetwork.getPartyRelationship(characterId1, characterId2);
  }

  /// Mark NPC as rival
  void markAsRival(String npcId, String characterId) {
    String key = '${npcId}_$characterId';
    var relationship = _relationshipNetwork.npcRelationships[key];
    if (relationship != null) {
      relationship.isRival = true;
    }
  }

  /// Mark NPC as in love
  void markAsInLove(String npcId, String characterId) {
    String key = '${npcId}_$characterId';
    var relationship = _relationshipNetwork.npcRelationships[key];
    if (relationship != null) {
      relationship.isInLove = true;
    }
  }

  /// Mark NPC as betrayed
  void markAsBetrayed(String npcId, String characterId) {
    String key = '${npcId}_$characterId';
    var relationship = _relationshipNetwork.npcRelationships[key];
    if (relationship != null) {
      relationship.isBetrayed = true;
    }
  }

  /// Assign personal quest to NPC relationship
  void assignPersonalQuest(String npcId, String characterId, String questId) {
    String key = '${npcId}_$characterId';
    var relationship = _relationshipNetwork.npcRelationships[key];
    if (relationship != null) {
      relationship.hasPersonalQuest = true;
      relationship.personalQuestId = questId;
    }
  }

  /// Add memorable quote
  void addMemorableQuote(String npcId, String characterId, String quote) {
    String key = '${npcId}_$characterId';
    var relationship = _relationshipNetwork.npcRelationships[key];
    if (relationship != null) {
      relationship.memorableQuotes.add(quote);
      // Keep only last 10 quotes
      if (relationship.memorableQuotes.length > 10) {
        relationship.memorableQuotes.removeAt(0);
      }
    }
  }

  /// Get relationship summary for AI context
  String getRelationshipSummary(String npcId, String characterId) {
    String key = '${npcId}_$characterId';
    var relationship = _relationshipNetwork.npcRelationships[key];

    if (relationship == null) {
      return 'No established relationship';
    }

    var summary = StringBuffer();
    summary.writeln('${relationship.npcName}: ${relationship.currentTier.displayName}');
    summary.writeln('Attitude: ${relationship.currentAttitude}/100');

    if (relationship.isInLove) {
      summary.writeln('Status: In love with character');
    } else if (relationship.isBetrayed) {
      summary.writeln('Status: Feels betrayed');
    } else if (relationship.isRival) {
      summary.writeln('Status: Rival');
    }

    var memorableEvents = relationship.getMemorableEvents();
    if (memorableEvents.isNotEmpty) {
      summary.writeln('\nRecent memorable events:');
      for (var event in memorableEvents) {
        summary.writeln('- ${event.description}');
      }
    }

    if (relationship.memorableQuotes.isNotEmpty) {
      summary.writeln('\nMemorable quotes:');
      for (var quote in relationship.memorableQuotes.take(3)) {
        summary.writeln('- "$quote"');
      }
    }

    return summary.toString();
  }

  /// Get faction-wide attitude average
  int getFactionAverageAttitude(String factionId, String characterId) {
    var factionRelationships = _relationshipNetwork.npcRelationships.values
        .where((r) => r.factionId == factionId && r.characterId == characterId)
        .toList();

    if (factionRelationships.isEmpty) return 0;

    int total = factionRelationships.fold(0, (sum, r) => sum + r.currentAttitude);
    return (total / factionRelationships.length).round();
  }

  /// Batch update attitudes (for faction-wide events)
  void batchUpdateFactionAttitudes({
    required String factionId,
    required String characterId,
    required int attitudeChange,
    required String reason,
    required int sessionDay,
  }) {
    var factionRelationships = _relationshipNetwork.npcRelationships.values
        .where((r) => r.factionId == factionId && r.characterId == characterId)
        .toList();

    for (var relationship in factionRelationships) {
      addRelationshipEvent(
        npcId: relationship.npcId,
        characterId: characterId,
        eventType: RelationshipEventType.custom,
        description: reason,
        attitudeChange: attitudeChange,
        sessionDay: sessionDay,
      );
    }
  }

  /// Check for romance possibility
  bool canRomance(String npcId, String characterId) {
    String key = '${npcId}_$characterId';
    var relationship = _relationshipNetwork.npcRelationships[key];

    if (relationship == null) return false;
    if (!relationship.isRomanceable) return false;
    if (relationship.isBetrayed) return false;
    if (relationship.currentAttitude < 50) return false;

    return true;
  }

  /// Get relationship health score (for party cohesion tracking)
  double getPartyRelationshipHealth(List<String> characterIds) {
    if (characterIds.length < 2) return 100.0;

    int totalRelationships = 0;
    int positiveRelationships = 0;

    for (int i = 0; i < characterIds.length; i++) {
      for (int j = i + 1; j < characterIds.length; j++) {
        totalRelationships++;
        int attitude = getPartyRelationship(characterIds[i], characterIds[j]);
        if (attitude >= 0) positiveRelationships++;
      }
    }

    return (positiveRelationships / totalRelationships) * 100;
  }
}
