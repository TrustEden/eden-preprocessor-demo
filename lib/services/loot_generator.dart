import 'dart:math';
import '../models/item.dart';
import '../models/monster.dart';
import '../data/magic_items.dart';
import '../data/expanded_magic_items.dart';

enum TreasureHoardSize {
  individual, // Single monster
  small, // 1-5 creatures
  medium, // 6-10 creatures
  large, // 11-20 creatures
  huge, // Boss encounter
}

class LootTable {
  String id;
  String name;
  int minChallengeRating;
  int maxChallengeRating;
  Map<ItemRarity, double> raritychances; // % chance for each rarity

  LootTable({
    required this.id,
    required this.name,
    required this.minChallengeRating,
    required this.maxChallengeRating,
    required this.raritychances,
  });
}

class TreasureHoard {
  int copperPieces;
  int silverPieces;
  int electrumPieces;
  int goldPieces;
  int platinumPieces;
  List<Item> items;
  List<Item> gems;
  List<Item> artObjects;

  TreasureHoard({
    this.copperPieces = 0,
    this.silverPieces = 0,
    this.electrumPieces = 0,
    this.goldPieces = 0,
    this.platinumPieces = 0,
    List<Item>? items,
    List<Item>? gems,
    List<Item>? artObjects,
  })  : items = items ?? [],
        gems = gems ?? [],
        artObjects = artObjects ?? [];

  int get totalValueInGold {
    return goldPieces +
        (platinumPieces * 10) +
        (electrumPieces ~/ 2).toInt() +
        (silverPieces ~/ 10).toInt() +
        (copperPieces ~/ 100).toInt() +
        items.fold<int>(0, (sum, item) => sum + item.value) +
        gems.fold<int>(0, (sum, gem) => sum + gem.value) +
        artObjects.fold<int>(0, (sum, art) => sum + art.value);
  }

  void addCurrency({
    int? copper,
    int? silver,
    int? electrum,
    int? gold,
    int? platinum,
  }) {
    copperPieces += copper ?? 0;
    silverPieces += silver ?? 0;
    electrumPieces += electrum ?? 0;
    goldPieces += gold ?? 0;
    platinumPieces += platinum ?? 0;
  }

  void addItem(Item item) {
    if (item.type == 'gem') {
      gems.add(item);
    } else if (item.type == 'art') {
      artObjects.add(item);
    } else {
      items.add(item);
    }
  }
}

class LootGenerator {
  static final Random _rng = Random();

  /// Generate treasure based on monster CR and hoard size
  static TreasureHoard generate({
    required double challengeRating,
    TreasureHoardSize hoardSize = TreasureHoardSize.individual,
    bool includemagicItems = true,
  }) {
    var hoard = TreasureHoard();

    // Generate currency based on CR
    _generateCurrency(hoard, challengeRating, hoardSize);

    // Generate gems and art objects
    if (hoardSize != TreasureHoardSize.individual) {
      _generateGemsAndArt(hoard, challengeRating, hoardSize);
    }

    // Generate magic items based on CR
    if (includemagicItems) {
      _generateMagicItems(hoard, challengeRating, hoardSize);
    }

    return hoard;
  }

  /// Generate loot from a specific monster
  static TreasureHoard generateFromMonster(Monster monster, {int quantity = 1}) {
    double cr = monster.challengeRating;
    TreasureHoardSize size;

    if (quantity == 1) {
      size = TreasureHoardSize.individual;
    } else if (quantity <= 5) {
      size = TreasureHoardSize.small;
    } else if (quantity <= 10) {
      size = TreasureHoardSize.medium;
    } else {
      size = TreasureHoardSize.large;
    }

    return generate(challengeRating: cr, hoardSize: size);
  }

  /// Generate boss treasure (guaranteed magic item)
  static TreasureHoard generateBossTreasure(double challengeRating) {
    var hoard = generate(
      challengeRating: challengeRating,
      hoardSize: TreasureHoardSize.huge,
      includemagicItems: true,
    );

    // Boss always has at least one magic item
    if (hoard.items.isEmpty) {
      hoard.addItem(_selectMagicItemByRarity(_getRarityForCR(challengeRating)));
    }

    return hoard;
  }

  // ==================== CURRENCY GENERATION ====================

  static void _generateCurrency(
    TreasureHoard hoard,
    double cr,
    TreasureHoardSize size,
  ) {
    int multiplier = _getHoardMultiplier(size);

    if (cr < 1) {
      // CR 0-1: Mostly copper and silver
      hoard.addCurrency(
        copper: _rollDice(2, 6) * 10 * multiplier,
        silver: _rollDice(1, 6) * 5 * multiplier,
      );
    } else if (cr < 5) {
      // CR 1-4: Silver and gold
      hoard.addCurrency(
        silver: _rollDice(3, 6) * 10 * multiplier,
        gold: _rollDice(2, 6) * 10 * multiplier,
      );
    } else if (cr < 11) {
      // CR 5-10: Gold and platinum
      hoard.addCurrency(
        gold: _rollDice(4, 6) * 100 * multiplier,
        platinum: _rollDice(1, 6) * 10 * multiplier,
      );
    } else if (cr < 17) {
      // CR 11-16: Lots of gold and platinum
      hoard.addCurrency(
        gold: _rollDice(6, 6) * 100 * multiplier,
        platinum: _rollDice(3, 6) * 10 * multiplier,
      );
    } else {
      // CR 17+: Massive treasure
      hoard.addCurrency(
        gold: _rollDice(8, 6) * 1000 * multiplier,
        platinum: _rollDice(6, 6) * 100 * multiplier,
      );
    }
  }

  static int _getHoardMultiplier(TreasureHoardSize size) {
    switch (size) {
      case TreasureHoardSize.individual:
        return 1;
      case TreasureHoardSize.small:
        return 2;
      case TreasureHoardSize.medium:
        return 4;
      case TreasureHoardSize.large:
        return 6;
      case TreasureHoardSize.huge:
        return 10;
    }
  }

  // ==================== GEMS & ART GENERATION ====================

  static void _generateGemsAndArt(
    TreasureHoard hoard,
    double cr,
    TreasureHoardSize size,
  ) {
    int numGems = 0;
    int numArt = 0;

    if (cr >= 5) {
      numGems = _rollDice(1, 4);
      numArt = _rollDice(1, 3);
    }
    if (cr >= 11) {
      numGems = _rollDice(2, 6);
      numArt = _rollDice(1, 6);
    }

    // Generate gems
    for (int i = 0; i < numGems; i++) {
      hoard.addItem(_generateGem(cr));
    }

    // Generate art objects
    for (int i = 0; i < numArt; i++) {
      hoard.addItem(_generateArtObject(cr));
    }
  }

  static Item _generateGem(double cr) {
    int value;
    String name;

    if (cr < 5) {
      value = [10, 50, 100][_rng.nextInt(3)];
      name = _getGemName(value);
    } else if (cr < 11) {
      value = [100, 500][_rng.nextInt(2)];
      name = _getGemName(value);
    } else {
      value = [500, 1000, 5000][_rng.nextInt(3)];
      name = _getGemName(value);
    }

    return Item(
      id: 'gem_${name.toLowerCase().replaceAll(' ', '_')}',
      name: name,
      effect: 'A valuable gemstone.',
      type: 'gem',
      weight: 0,
      value: value,
    );
  }

  static String _getGemName(int value) {
    if (value == 10) {
      return ['Azurite', 'Obsidian', 'Turquoise'][_rng.nextInt(3)];
    } else if (value == 50) {
      return ['Bloodstone', 'Citrine', 'Jasper', 'Moonstone'][_rng.nextInt(4)];
    } else if (value == 100) {
      return ['Amber', 'Amethyst', 'Jade', 'Pearl'][_rng.nextInt(4)];
    } else if (value == 500) {
      return ['Garnet', 'Alexandrite', 'Aquamarine', 'Topaz'][_rng.nextInt(4)];
    } else if (value == 1000) {
      return ['Emerald', 'Sapphire', 'Ruby', 'Diamond'][_rng.nextInt(4)];
    } else {
      return ['Black Opal', 'Blue Sapphire', 'Fire Opal', 'Star Ruby'][_rng.nextInt(4)];
    }
  }

  static Item _generateArtObject(double cr) {
    int value;
    String name;

    if (cr < 5) {
      value = [25, 50, 100][_rng.nextInt(3)];
      name = _getArtObjectName(value);
    } else if (cr < 11) {
      value = [250, 750][_rng.nextInt(2)];
      name = _getArtObjectName(value);
    } else {
      value = [1000, 2500, 7500][_rng.nextInt(3)];
      name = _getArtObjectName(value);
    }

    return Item(
      id: 'art_${name.toLowerCase().replaceAll(' ', '_')}',
      name: name,
      effect: 'A valuable art object.',
      type: 'art',
      weight: 1,
      value: value,
    );
  }

  static String _getArtObjectName(int value) {
    if (value <= 100) {
      return ['Silver Ewer', 'Carved Bone Statuette', 'Gold Bracelet', 'Silk Robe'][_rng.nextInt(4)];
    } else if (value <= 750) {
      return ['Gold Ring', 'Fine Tapestry', 'Bronze Crown', 'Silver Chalice'][_rng.nextInt(4)];
    } else {
      return ['Jeweled Crown', 'Ancient Painting', 'Gold Scepter', 'Platinum Idol'][_rng.nextInt(4)];
    }
  }

  // ==================== MAGIC ITEM GENERATION ====================

  static void _generateMagicItems(
    TreasureHoard hoard,
    double cr,
    TreasureHoardSize size,
  ) {
    int numItems = 0;

    // Determine number of magic items based on CR and hoard size
    if (cr >= 1 && cr < 5) {
      if (size == TreasureHoardSize.huge) numItems = 1;
      else if (_rng.nextDouble() < 0.3) numItems = 1;
    } else if (cr >= 5 && cr < 11) {
      if (size == TreasureHoardSize.huge) numItems = _rollDice(1, 4);
      else if (size == TreasureHoardSize.large) numItems = _rollDice(1, 3);
      else if (_rng.nextDouble() < 0.5) numItems = 1;
    } else if (cr >= 11 && cr < 17) {
      if (size == TreasureHoardSize.huge) numItems = _rollDice(1, 6);
      else if (size == TreasureHoardSize.large) numItems = _rollDice(1, 4);
      else numItems = _rollDice(1, 2);
    } else if (cr >= 17) {
      if (size == TreasureHoardSize.huge) numItems = _rollDice(2, 6);
      else numItems = _rollDice(1, 4);
    }

    // Generate magic items
    for (int i = 0; i < numItems; i++) {
      ItemRarity rarity = _getRarityForCR(cr);
      hoard.addItem(_selectMagicItemByRarity(rarity));
    }
  }

  static ItemRarity _getRarityForCR(double cr) {
    double roll = _rng.nextDouble() * 100;

    if (cr < 5) {
      if (roll < 80) return ItemRarity.common;
      if (roll < 95) return ItemRarity.uncommon;
      return ItemRarity.rare;
    } else if (cr < 11) {
      if (roll < 60) return ItemRarity.uncommon;
      if (roll < 90) return ItemRarity.rare;
      return ItemRarity.veryRare;
    } else if (cr < 17) {
      if (roll < 50) return ItemRarity.rare;
      if (roll < 85) return ItemRarity.veryRare;
      return ItemRarity.legendary;
    } else {
      if (roll < 40) return ItemRarity.veryRare;
      if (roll < 80) return ItemRarity.legendary;
      return ItemRarity.artifact;
    }
  }

  static Item _selectMagicItemByRarity(ItemRarity rarity) {
    // Use expanded magic items database
    Item? item = ExpandedMagicItems.getRandomItemByRarity(rarity);

    // Fallback to basic items
    if (item == null) {
      switch (rarity) {
        case ItemRarity.common:
          return MagicItems.potionOfHealing();
        case ItemRarity.uncommon:
          return MagicItems.weaponPlus1('Longsword');
        case ItemRarity.rare:
          return MagicItems.weaponPlus2('Longsword');
        case ItemRarity.veryRare:
          return MagicItems.weaponPlus3('Longsword');
        case ItemRarity.legendary:
          return MagicItems.vorpalSword();
        case ItemRarity.artifact:
          return MagicItems.ringOfThreeWishes();
      }
    }

    return item;
  }

  // ==================== QUEST REWARD GENERATION ====================

  /// Generate appropriate treasure for quest completion
  static TreasureHoard generateQuestReward({
    required int partyLevel,
    required int partySize,
    bool isMajorQuest = false,
  }) {
    double effectiveCR = partyLevel.toDouble();
    TreasureHoardSize size = isMajorQuest
        ? TreasureHoardSize.huge
        : TreasureHoardSize.large;

    var hoard = generate(
      challengeRating: effectiveCR,
      hoardSize: size,
      includemagicItems: isMajorQuest,
    );

    // Quest rewards tend to be gold-heavy
    hoard.goldPieces = (hoard.goldPieces * 1.5).round();

    return hoard;
  }

  /// Generate random loot drop
  static List<Item> generateRandomLoot(int maxValue) {
    List<Item> loot = [];
    int remainingValue = maxValue;

    while (remainingValue > 50) {
      int itemValue = _rng.nextInt(remainingValue ~/ 2) + 25;
      loot.add(_generateRandomItem(itemValue));
      remainingValue -= itemValue;
    }

    return loot;
  }

  static Item _generateRandomItem(int targetValue) {
    List<String> itemTypes = ['potion', 'scroll', 'weapon', 'armor', 'wondrous'];
    String type = itemTypes[_rng.nextInt(itemTypes.length)];

    return Item(
      id: 'random_${type}_${_rng.nextInt(10000)}',
      name: 'Random $type',
      effect: 'A random item.',
      type: type,
      weight: 1,
      value: targetValue,
    );
  }

  // ==================== UTILITY ====================

  static int _rollDice(int count, int sides) {
    int total = 0;
    for (int i = 0; i < count; i++) {
      total += _rng.nextInt(sides) + 1;
    }
    return total;
  }

  /// Convert treasure hoard to simple loot list for party distribution
  static List<Item> convertHoardToLoot(TreasureHoard hoard) {
    List<Item> loot = [];

    // Add currency as single item
    if (hoard.totalValueInGold > 0) {
      loot.add(Item(
        id: 'currency_${DateTime.now().millisecondsSinceEpoch}',
        name: '${hoard.goldPieces} Gold, ${hoard.platinumPieces} Platinum',
        effect: 'Currency from treasure hoard',
        type: 'currency',
        weight: 0,
        value: hoard.totalValueInGold,
      ));
    }

    // Add all items
    loot.addAll(hoard.items);
    loot.addAll(hoard.gems);
    loot.addAll(hoard.artObjects);

    return loot;
  }
}
