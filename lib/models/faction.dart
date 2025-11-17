import 'item.dart';
import 'quest.dart';

enum FactionStanding {
  hated, // -3000 to -1000
  hostile, // -1000 to -500
  unfriendly, // -500 to 0
  neutral, // 0 to 500
  friendly, // 500 to 1500
  honored, // 1500 to 3000
  revered, // 3000 to 6000
  exalted, // 6000+
}

enum FactionType {
  guild, // Merchant guilds, craft guilds
  religious, // Churches, cults
  military, // Armies, guards
  criminal, // Thieves' guilds, assassins
  arcane, // Wizard colleges, magic societies
  noble, // Royal houses, aristocracy
  tribal, // Barbarian clans, druid circles
  faction, // Generic faction
}

class Faction {
  String id;
  String name;
  String description;
  FactionType type;

  // Faction identity
  String? symbol;
  String? motto;
  String? headquarters;
  String? leader;

  // Faction relationships
  Map<String, int> allyFactions; // factionId -> relationship strength
  Map<String, int> enemyFactions; // factionId -> hostility level

  // Faction benefits
  Map<FactionStanding, List<String>> standingBenefits; // What you get at each level
  Map<FactionStanding, List<Item>> standingRewards; // Items unlocked
  Map<FactionStanding, double> discountRates; // Store discount per standing

  // Faction quests
  List<Quest>? availableQuests;

  Faction({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    this.symbol,
    this.motto,
    this.headquarters,
    this.leader,
    Map<String, int>? allyFactions,
    Map<String, int>? enemyFactions,
    Map<FactionStanding, List<String>>? standingBenefits,
    Map<FactionStanding, List<Item>>? standingRewards,
    Map<FactionStanding, double>? discountRates,
    this.availableQuests,
  })  : allyFactions = allyFactions ?? {},
        enemyFactions = enemyFactions ?? {},
        standingBenefits = standingBenefits ?? {},
        standingRewards = standingRewards ?? {},
        discountRates = discountRates ?? _defaultDiscountRates();

  static Map<FactionStanding, double> _defaultDiscountRates() {
    return {
      FactionStanding.hated: 1.5, // 50% markup
      FactionStanding.hostile: 1.25, // 25% markup
      FactionStanding.unfriendly: 1.1, // 10% markup
      FactionStanding.neutral: 1.0, // No discount
      FactionStanding.friendly: 0.95, // 5% discount
      FactionStanding.honored: 0.90, // 10% discount
      FactionStanding.revered: 0.85, // 15% discount
      FactionStanding.exalted: 0.75, // 25% discount
    };
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'type': type.toString(),
        'symbol': symbol,
        'motto': motto,
        'headquarters': headquarters,
        'leader': leader,
        'allyFactions': allyFactions,
        'enemyFactions': enemyFactions,
        'standingBenefits': standingBenefits.map(
          (k, v) => MapEntry(k.toString(), v),
        ),
        'standingRewards': standingRewards.map(
          (k, v) => MapEntry(k.toString(), v.map((i) => i.toJson()).toList()),
        ),
        'discountRates': discountRates.map(
          (k, v) => MapEntry(k.toString(), v),
        ),
        'availableQuests':
            availableQuests?.map((q) => q.toJson()).toList(),
      };

  factory Faction.fromJson(Map<String, dynamic> json) => Faction(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        type: FactionType.values.firstWhere(
          (t) => t.toString() == json['type'],
          orElse: () => FactionType.faction,
        ),
        symbol: json['symbol'] as String?,
        motto: json['motto'] as String?,
        headquarters: json['headquarters'] as String?,
        leader: json['leader'] as String?,
        allyFactions:
            (json['allyFactions'] as Map<String, dynamic>?)?.cast<String, int>(),
        enemyFactions:
            (json['enemyFactions'] as Map<String, dynamic>?)?.cast<String, int>(),
        standingBenefits: (json['standingBenefits'] as Map<String, dynamic>?)
            ?.map((k, v) => MapEntry(
                  FactionStanding.values
                      .firstWhere((s) => s.toString() == k),
                  (v as List<dynamic>).cast<String>(),
                )),
        standingRewards: (json['standingRewards'] as Map<String, dynamic>?)
            ?.map((k, v) => MapEntry(
                  FactionStanding.values
                      .firstWhere((s) => s.toString() == k),
                  (v as List<dynamic>)
                      .map((i) => Item.fromJson(i as Map<String, dynamic>))
                      .toList(),
                )),
        discountRates: (json['discountRates'] as Map<String, dynamic>?)
            ?.map((k, v) => MapEntry(
                  FactionStanding.values
                      .firstWhere((s) => s.toString() == k),
                  v as double,
                )),
        availableQuests: (json['availableQuests'] as List<dynamic>?)
            ?.map((q) => Quest.fromJson(q as Map<String, dynamic>))
            .toList(),
      );
}

class FactionReputation {
  String characterId; // Or party ID
  Map<String, int> reputationPoints; // factionId -> points

  FactionReputation({
    required this.characterId,
    Map<String, int>? reputationPoints,
  }) : reputationPoints = reputationPoints ?? {};

  // Get standing with faction
  FactionStanding getStanding(String factionId) {
    int points = reputationPoints[factionId] ?? 0;

    if (points >= 6000) return FactionStanding.exalted;
    if (points >= 3000) return FactionStanding.revered;
    if (points >= 1500) return FactionStanding.honored;
    if (points >= 500) return FactionStanding.friendly;
    if (points >= 0) return FactionStanding.neutral;
    if (points >= -500) return FactionStanding.unfriendly;
    if (points >= -1000) return FactionStanding.hostile;
    return FactionStanding.hated;
  }

  // Modify reputation
  void modifyReputation(String factionId, int change, {Map<String, Faction>? factions}) {
    reputationPoints[factionId] = (reputationPoints[factionId] ?? 0) + change;

    // Cap at -3000 to 10000
    if (reputationPoints[factionId]! < -3000) {
      reputationPoints[factionId] = -3000;
    }
    if (reputationPoints[factionId]! > 10000) {
      reputationPoints[factionId] = 10000;
    }

    // Apply allied/enemy faction changes (10% of change)
    if (factions != null && factions.containsKey(factionId)) {
      var faction = factions[factionId]!;

      // Allies gain reputation too
      for (var allyId in faction.allyFactions.keys) {
        int allyChange = (change * 0.1).round();
        reputationPoints[allyId] = (reputationPoints[allyId] ?? 0) + allyChange;
      }

      // Enemies lose reputation
      for (var enemyId in faction.enemyFactions.keys) {
        int enemyChange = (change * 0.15).round();
        reputationPoints[enemyId] = (reputationPoints[enemyId] ?? 0) - enemyChange;
      }
    }
  }

  // Get all factions at or above certain standing
  List<String> getFactionsAtStanding(FactionStanding minStanding) {
    List<String> result = [];
    int minPoints = _getMinPointsForStanding(minStanding);

    for (var entry in reputationPoints.entries) {
      if (entry.value >= minPoints) {
        result.add(entry.key);
      }
    }

    return result;
  }

  int _getMinPointsForStanding(FactionStanding standing) {
    switch (standing) {
      case FactionStanding.exalted:
        return 6000;
      case FactionStanding.revered:
        return 3000;
      case FactionStanding.honored:
        return 1500;
      case FactionStanding.friendly:
        return 500;
      case FactionStanding.neutral:
        return 0;
      case FactionStanding.unfriendly:
        return -500;
      case FactionStanding.hostile:
        return -1000;
      case FactionStanding.hated:
        return -3000;
    }
  }

  // Get points needed for next standing
  int pointsToNextStanding(String factionId) {
    int current = reputationPoints[factionId] ?? 0;
    FactionStanding currentStanding = getStanding(factionId);

    switch (currentStanding) {
      case FactionStanding.hated:
        return -1000 - current;
      case FactionStanding.hostile:
        return -500 - current;
      case FactionStanding.unfriendly:
        return 0 - current;
      case FactionStanding.neutral:
        return 500 - current;
      case FactionStanding.friendly:
        return 1500 - current;
      case FactionStanding.honored:
        return 3000 - current;
      case FactionStanding.revered:
        return 6000 - current;
      case FactionStanding.exalted:
        return 0; // Already at max
    }
  }

  // Check if can access faction store
  bool canAccessStore(String factionId, {FactionStanding minimumStanding = FactionStanding.neutral}) {
    return getStanding(factionId).index >= minimumStanding.index;
  }

  // Get store discount rate
  double getStoreDiscount(String factionId, Faction faction) {
    FactionStanding standing = getStanding(factionId);
    return faction.discountRates[standing] ?? 1.0;
  }

  Map<String, dynamic> toJson() => {
        'characterId': characterId,
        'reputationPoints': reputationPoints,
      };

  factory FactionReputation.fromJson(Map<String, dynamic> json) =>
      FactionReputation(
        characterId: json['characterId'] as String,
        reputationPoints: (json['reputationPoints'] as Map<String, dynamic>?)
            ?.cast<String, int>(),
      );
}

// Predefined Factions
class Factions {
  static Faction thievesGuild() => Faction(
        id: 'thieves_guild',
        name: 'The Shadow Syndicate',
        description: 'A clandestine organization of thieves, spies, and assassins operating in the shadows.',
        type: FactionType.criminal,
        symbol: 'Hooded dagger',
        motto: 'What\'s yours is ours',
        headquarters: 'The Underground, beneath the city',
        leader: 'The Faceless One',
        standingBenefits: {
          FactionStanding.friendly: ['Access to fence for stolen goods'],
          FactionStanding.honored: ['Thieves\' tools discount', 'Safe houses access'],
          FactionStanding.revered: ['Assassination contracts', 'Information network'],
          FactionStanding.exalted: ['Master thief title', 'Guild leadership position'],
        },
        enemyFactions: {'city_guard': 100},
      );

  static Faction magesGuild() => Faction(
        id: 'mages_guild',
        name: 'The Arcane Collegium',
        description: 'An elite academy of wizards dedicated to the pursuit of magical knowledge.',
        type: FactionType.arcane,
        symbol: 'Crossed wands over open book',
        motto: 'Knowledge is power',
        headquarters: 'The Crystal Tower',
        leader: 'Archmage Aldrin the Wise',
        standingBenefits: {
          FactionStanding.friendly: ['Library access', 'Spell scroll crafting'],
          FactionStanding.honored: ['Advanced spell research', 'Familiar summoning'],
          FactionStanding.revered: ['Teleportation circles', 'Rare component access'],
          FactionStanding.exalted: ['Archmage title', 'Personal tower'],
        },
      );

  static Faction cityGuard() => Faction(
        id: 'city_guard',
        name: 'The City Watch',
        description: 'Law enforcement and military force protecting the city and its citizens.',
        type: FactionType.military,
        symbol: 'Crossed swords over shield',
        motto: 'Order above all',
        headquarters: 'The Citadel',
        leader: 'Captain Commander Valerius',
        standingBenefits: {
          FactionStanding.friendly: ['Reduced fines', 'Guard assistance'],
          FactionStanding.honored: ['Deputy badge', 'Armory access'],
          FactionStanding.revered: ['Officer commission', 'Command authority'],
          FactionStanding.exalted: ['Captain rank', 'City defense command'],
        },
        enemyFactions: {'thieves_guild': 100, 'cultists': 80},
      );

  static Faction temple() => Faction(
        id: 'temple_of_light',
        name: 'Temple of the Radiant Dawn',
        description: 'A holy order dedicated to healing, protection, and destroying undead.',
        type: FactionType.religious,
        symbol: 'Golden sun rising',
        motto: 'Light conquers darkness',
        headquarters: 'The Grand Cathedral',
        leader: 'High Priestess Seraphina',
        standingBenefits: {
          FactionStanding.friendly: ['Free healing for minor wounds'],
          FactionStanding.honored: ['Holy symbol blessing', 'Undead banishment'],
          FactionStanding.revered: ['Resurrection services', 'Divine guidance'],
          FactionStanding.exalted: ['Saint title', 'Miracle prayers'],
        },
      );

  static Faction merchantGuild() => Faction(
        id: 'merchant_guild',
        name: 'The Golden Consortium',
        description: 'Powerful alliance of merchants, traders, and craftsmen controlling commerce.',
        type: FactionType.guild,
        symbol: 'Golden scales',
        motto: 'Trade enriches all',
        headquarters: 'The Exchange',
        leader: 'Guildmaster Goldsworth',
        standingBenefits: {
          FactionStanding.friendly: ['Better prices at shops'],
          FactionStanding.honored: ['Bulk discounts', 'Import access'],
          FactionStanding.revered: ['Merchant license', 'Warehouse access'],
          FactionStanding.exalted: ['Guildmaster vote', 'Trade monopoly'],
        },
      );

  static Faction druids() => Faction(
        id: 'circle_of_nature',
        name: 'The Emerald Circle',
        description: 'Ancient druidic order protecting nature and maintaining balance.',
        type: FactionType.tribal,
        symbol: 'Oak tree in circle',
        motto: 'Nature endures',
        headquarters: 'The Sacred Grove',
        leader: 'Archdruid Thornwhisper',
        standingBenefits: {
          FactionStanding.friendly: ['Herbal remedies', 'Animal friendship'],
          FactionStanding.honored: ['Shape-shifting training', 'Grove sanctuary'],
          FactionStanding.revered: ['Elder knowledge', 'Wild summoning'],
          FactionStanding.exalted: ['Archdruid title', 'Nature\'s avatar'],
        },
      );

  static Faction cultists() => Faction(
        id: 'cultists',
        name: 'Cult of the Void',
        description: 'Sinister cult worshipping dark powers and seeking forbidden knowledge.',
        type: FactionType.religious,
        symbol: 'Black star',
        motto: 'Embrace the darkness',
        headquarters: 'Hidden catacombs',
        leader: 'The Veiled Prophet',
        standingBenefits: {
          FactionStanding.friendly: ['Dark rituals', 'Forbidden lore'],
          FactionStanding.honored: ['Void magic', 'Summoning circles'],
          FactionStanding.revered: ['Demonic pacts', 'Soul binding'],
          FactionStanding.exalted: ['High priest title', 'Void lord'],
        },
        enemyFactions: {'temple_of_light': 100, 'city_guard': 80},
      );

  static List<Faction> getAllFactions() {
    return [
      thievesGuild(),
      magesGuild(),
      cityGuard(),
      temple(),
      merchantGuild(),
      druids(),
      cultists(),
    ];
  }

  static Map<String, Faction> getAllFactionsMap() {
    var factions = getAllFactions();
    return Map.fromEntries(factions.map((f) => MapEntry(f.id, f)));
  }
}
