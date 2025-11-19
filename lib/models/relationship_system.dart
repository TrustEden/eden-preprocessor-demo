import 'package:eden_preprocessor_demo/models/character.dart';

/// Relationship attitude representing how an NPC feels about a character
/// Range: -100 (hostile) to +100 (devoted ally)
enum RelationshipTier {
  devoted(75, 100, 'Devoted', 0.8), // Major discounts, free info, personal favors
  trusted(50, 74, 'Trusted', 0.7), // Good discounts, reliable help
  friendly(25, 49, 'Friendly', 0.85), // Standard discounts, willing to help
  neutral(0, 24, 'Neutral', 1.0), // Normal prices, professional
  unfriendly(-24, -1, 'Unfriendly', 1.15), // Increased prices, reluctant
  hostile(-49, -25, 'Hostile', 1.3), // High prices, unhelpful
  enemy(-74, -50, 'Enemy', 2.0), // Won't trade, actively oppose
  nemesis(-100, -75, 'Nemesis', 999.0); // Refuses service, attacks on sight

  final int minAttitude;
  final int maxAttitude;
  final String displayName;
  final double priceModifier; // Merchant price multiplier

  const RelationshipTier(
    this.minAttitude,
    this.maxAttitude,
    this.displayName,
    this.priceModifier,
  );

  static RelationshipTier fromAttitude(int attitude) {
    for (var tier in RelationshipTier.values) {
      if (attitude >= tier.minAttitude && attitude <= tier.maxAttitude) {
        return tier;
      }
    }
    return RelationshipTier.neutral;
  }
}

/// Types of relationship events that can occur
enum RelationshipEventType {
  firstMeeting,
  helpedInCombat,
  savedLife,
  betrayed,
  lied,
  stole,
  completedQuest,
  failedQuest,
  gaveGift,
  insult,
  compliment,
  sharedSecret,
  revealedSecret,
  romance,
  rivalry,
  businessDeal,
  politicalAlliance,
  murder, // Of someone they cared about
  rescue, // Rescued them or someone they care about
  custom,
}

/// A specific event that affected the relationship
class RelationshipEvent {
  final String eventId;
  final RelationshipEventType eventType;
  final String description;
  final int attitudeChange;
  final DateTime timestamp;
  final int sessionDay;
  final String? relatedQuestId;
  final bool isMemorableEvent; // If true, NPC will reference it in dialogue

  RelationshipEvent({
    required this.eventId,
    required this.eventType,
    required this.description,
    required this.attitudeChange,
    required this.timestamp,
    required this.sessionDay,
    this.relatedQuestId,
    this.isMemorableEvent = false,
  });

  Map<String, dynamic> toJson() => {
        'eventId': eventId,
        'eventType': eventType.name,
        'description': description,
        'attitudeChange': attitudeChange,
        'timestamp': timestamp.toIso8601String(),
        'sessionDay': sessionDay,
        'relatedQuestId': relatedQuestId,
        'isMemorableEvent': isMemorableEvent,
      };

  factory RelationshipEvent.fromJson(Map<String, dynamic> json) {
    return RelationshipEvent(
      eventId: json['eventId'] as String,
      eventType: RelationshipEventType.values.firstWhere(
        (e) => e.name == json['eventType'],
        orElse: () => RelationshipEventType.custom,
      ),
      description: json['description'] as String,
      attitudeChange: json['attitudeChange'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
      sessionDay: json['sessionDay'] as int,
      relatedQuestId: json['relatedQuestId'] as String?,
      isMemorableEvent: json['isMemorableEvent'] as bool? ?? false,
    );
  }
}

/// Enhanced NPC relationship tracking with history and dynamics
class NPCRelationship {
  final String npcId;
  final String npcName;
  final String characterId;
  int currentAttitude; // -100 to +100
  final List<RelationshipEvent> relationshipHistory;
  RelationshipTier currentTier;

  // Relationship characteristics
  bool isMerchant;
  bool isQuestGiver;
  bool isRomanceable;
  bool isRival;
  String? factionId; // NPC's faction affiliation

  // Special states
  bool isInLove;
  bool isBetrayed;
  bool hasPersonalQuest;
  String? personalQuestId;

  // Interaction tracking
  int totalInteractions;
  DateTime? lastInteractionDate;
  List<String> memorableQuotes; // Things the NPC said that players remember

  NPCRelationship({
    required this.npcId,
    required this.npcName,
    required this.characterId,
    this.currentAttitude = 0,
    List<RelationshipEvent>? relationshipHistory,
    RelationshipTier? currentTier,
    this.isMerchant = false,
    this.isQuestGiver = false,
    this.isRomanceable = false,
    this.isRival = false,
    this.factionId,
    this.isInLove = false,
    this.isBetrayed = false,
    this.hasPersonalQuest = false,
    this.personalQuestId,
    this.totalInteractions = 0,
    this.lastInteractionDate,
    List<String>? memorableQuotes,
  })  : relationshipHistory = relationshipHistory ?? [],
        currentTier = currentTier ?? RelationshipTier.fromAttitude(currentAttitude),
        memorableQuotes = memorableQuotes ?? [];

  /// Add a relationship event and update attitude
  void addRelationshipEvent(RelationshipEvent event) {
    relationshipHistory.add(event);
    currentAttitude = (currentAttitude + event.attitudeChange).clamp(-100, 100);
    currentTier = RelationshipTier.fromAttitude(currentAttitude);

    // Special state updates
    if (event.eventType == RelationshipEventType.betrayed) {
      isBetrayed = true;
    }
    if (event.eventType == RelationshipEventType.romance && currentAttitude > 60) {
      isInLove = true;
    }
  }

  /// Get merchant price modifier based on relationship
  double getMerchantPriceModifier() {
    if (!isMerchant) return 1.0;
    return currentTier.priceModifier;
  }

  /// Check if NPC will offer a specific service
  bool willOfferService(String serviceType) {
    if (currentTier == RelationshipTier.nemesis) return false;
    if (currentTier == RelationshipTier.enemy && serviceType != 'mandatory') {
      return false;
    }
    if (isBetrayed && serviceType == 'trust_required') return false;
    return true;
  }

  /// Get recent memorable events for dialogue
  List<RelationshipEvent> getMemorableEvents() {
    return relationshipHistory
        .where((event) => event.isMemorableEvent)
        .toList()
        .reversed
        .take(3)
        .toList();
  }

  /// Calculate relationship decay over time (if not interacted with)
  void applyTimeDecay(int daysSinceLastInteraction) {
    if (daysSinceLastInteraction < 7) return; // No decay for first week

    // Positive relationships decay faster (people drift apart)
    // Negative relationships decay slower (grudges last)
    if (currentAttitude > 0) {
      int decay = (daysSinceLastInteraction / 7).floor();
      currentAttitude = (currentAttitude - decay).clamp(0, 100);
    } else if (currentAttitude < -50) {
      // Deep grudges barely fade
      int decay = (daysSinceLastInteraction / 30).floor();
      currentAttitude = (currentAttitude + decay).clamp(-100, 0);
    }

    currentTier = RelationshipTier.fromAttitude(currentAttitude);
  }

  Map<String, dynamic> toJson() => {
        'npcId': npcId,
        'npcName': npcName,
        'characterId': characterId,
        'currentAttitude': currentAttitude,
        'relationshipHistory': relationshipHistory.map((e) => e.toJson()).toList(),
        'currentTier': currentTier.name,
        'isMerchant': isMerchant,
        'isQuestGiver': isQuestGiver,
        'isRomanceable': isRomanceable,
        'isRival': isRival,
        'factionId': factionId,
        'isInLove': isInLove,
        'isBetrayed': isBetrayed,
        'hasPersonalQuest': hasPersonalQuest,
        'personalQuestId': personalQuestId,
        'totalInteractions': totalInteractions,
        'lastInteractionDate': lastInteractionDate?.toIso8601String(),
        'memorableQuotes': memorableQuotes,
      };

  factory NPCRelationship.fromJson(Map<String, dynamic> json) {
    return NPCRelationship(
      npcId: json['npcId'] as String,
      npcName: json['npcName'] as String,
      characterId: json['characterId'] as String,
      currentAttitude: json['currentAttitude'] as int,
      relationshipHistory: (json['relationshipHistory'] as List<dynamic>?)
              ?.map((e) => RelationshipEvent.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      currentTier: RelationshipTier.values.firstWhere(
        (e) => e.name == json['currentTier'],
        orElse: () => RelationshipTier.neutral,
      ),
      isMerchant: json['isMerchant'] as bool? ?? false,
      isQuestGiver: json['isQuestGiver'] as bool? ?? false,
      isRomanceable: json['isRomanceable'] as bool? ?? false,
      isRival: json['isRival'] as bool? ?? false,
      factionId: json['factionId'] as String?,
      isInLove: json['isInLove'] as bool? ?? false,
      isBetrayed: json['isBetrayed'] as bool? ?? false,
      hasPersonalQuest: json['hasPersonalQuest'] as bool? ?? false,
      personalQuestId: json['personalQuestId'] as String?,
      totalInteractions: json['totalInteractions'] as int? ?? 0,
      lastInteractionDate: json['lastInteractionDate'] != null
          ? DateTime.parse(json['lastInteractionDate'] as String)
          : null,
      memorableQuotes: (json['memorableQuotes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }
}

/// Network of relationships for tracking group dynamics
class RelationshipNetwork {
  final Map<String, NPCRelationship> npcRelationships; // Key: npcId_characterId
  final Map<String, int> partyRelationships; // Key: character1Id_character2Id, Value: attitude

  RelationshipNetwork({
    Map<String, NPCRelationship>? npcRelationships,
    Map<String, int>? partyRelationships,
  })  : npcRelationships = npcRelationships ?? {},
        partyRelationships = partyRelationships ?? {};

  /// Get or create NPC relationship
  NPCRelationship getOrCreateNPCRelationship({
    required String npcId,
    required String npcName,
    required String characterId,
    bool isMerchant = false,
    bool isQuestGiver = false,
  }) {
    String key = '${npcId}_$characterId';
    if (!npcRelationships.containsKey(key)) {
      npcRelationships[key] = NPCRelationship(
        npcId: npcId,
        npcName: npcName,
        characterId: characterId,
        isMerchant: isMerchant,
        isQuestGiver: isQuestGiver,
      );
    }
    return npcRelationships[key]!;
  }

  /// Get party member relationship
  int getPartyRelationship(String characterId1, String characterId2) {
    String key = _getPartyRelationshipKey(characterId1, characterId2);
    return partyRelationships[key] ?? 0; // Default neutral
  }

  /// Update party member relationship
  void updatePartyRelationship(
    String characterId1,
    String characterId2,
    int attitudeChange,
  ) {
    String key = _getPartyRelationshipKey(characterId1, characterId2);
    int current = partyRelationships[key] ?? 0;
    partyRelationships[key] = (current + attitudeChange).clamp(-100, 100);
  }

  String _getPartyRelationshipKey(String characterId1, String characterId2) {
    // Ensure consistent key regardless of order
    List<String> ids = [characterId1, characterId2]..sort();
    return '${ids[0]}_${ids[1]}';
  }

  /// Get all relationships for a specific character
  List<NPCRelationship> getCharacterRelationships(String characterId) {
    return npcRelationships.values
        .where((rel) => rel.characterId == characterId)
        .toList();
  }

  /// Get all relationships with a specific NPC across all characters
  List<NPCRelationship> getNPCRelationships(String npcId) {
    return npcRelationships.values
        .where((rel) => rel.npcId == npcId)
        .toList();
  }

  Map<String, dynamic> toJson() => {
        'npcRelationships': npcRelationships.map(
          (key, value) => MapEntry(key, value.toJson()),
        ),
        'partyRelationships': partyRelationships,
      };

  factory RelationshipNetwork.fromJson(Map<String, dynamic> json) {
    return RelationshipNetwork(
      npcRelationships: (json['npcRelationships'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(
              key,
              NPCRelationship.fromJson(value as Map<String, dynamic>),
            ),
          ) ??
          {},
      partyRelationships: (json['partyRelationships'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, value as int),
          ) ??
          {},
    );
  }
}
