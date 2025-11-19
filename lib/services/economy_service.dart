import 'package:eden_preprocessor_demo/models/crafting_economy.dart';
import 'package:uuid/uuid.dart';
import 'dart:math';

/// Service for managing dynamic economy and merchant inventories
class EconomyService {
  final Map<String, DynamicPrice> _itemPrices = {}; // itemId -> pricing
  final Map<String, MerchantInventory> _merchantInventories = {}; // merchantId -> inventory

  final Uuid _uuid = const Uuid();
  final Random _random = Random();

  /// Register an item for dynamic pricing
  void registerItemPricing({
    required String itemId,
    required String itemName,
    required int basePrice,
    int initialSupply = 50,
    int initialDemand = 50,
    Map<String, double>? locationModifiers,
  }) {
    var dynamicPrice = DynamicPrice(
      itemId: itemId,
      itemName: itemName,
      basePrice: basePrice,
      supplyLevel: initialSupply,
      demandLevel: initialDemand,
      locationModifiers: locationModifiers,
    );

    dynamicPrice.updatePriceFromMarket();
    _itemPrices[itemId] = dynamicPrice;
  }

  /// Get current price for an item
  int getCurrentPrice(String itemId, {String? locationId}) {
    var dynamicPrice = _itemPrices[itemId];
    if (dynamicPrice == null) return 0;

    return dynamicPrice.getCurrentPrice(locationId: locationId);
  }

  /// Get price with merchant modifier
  int getPriceAtMerchant({
    required String itemId,
    required String merchantId,
    required String characterId,
    String? locationId,
  }) {
    var basePrice = getCurrentPrice(itemId, locationId: locationId);
    var merchantInventory = _merchantInventories[merchantId];

    if (merchantInventory == null) return basePrice;

    return merchantInventory.getPriceForCharacter(itemId, characterId, basePrice);
  }

  /// Update supply level for an item
  void updateSupplyLevel(String itemId, int change) {
    var dynamicPrice = _itemPrices[itemId];
    if (dynamicPrice != null) {
      dynamicPrice.supplyLevel = (dynamicPrice.supplyLevel + change).clamp(0, 100);
      dynamicPrice.updatePriceFromMarket();
    }
  }

  /// Update demand level for an item
  void updateDemandLevel(String itemId, int change) {
    var dynamicPrice = _itemPrices[itemId];
    if (dynamicPrice != null) {
      dynamicPrice.demandLevel = (dynamicPrice.demandLevel + change).clamp(0, 100);
      dynamicPrice.updatePriceFromMarket();
    }
  }

  /// Apply a price event to an item
  void applyPriceEvent({
    required String itemId,
    required String eventDescription,
    required int supplyChange,
    required int demandChange,
    required String eventCause,
  }) {
    var dynamicPrice = _itemPrices[itemId];
    if (dynamicPrice == null) return;

    var priceEvent = PriceEvent(
      eventId: _uuid.v4(),
      eventDescription: eventDescription,
      eventDate: DateTime.now(),
      supplyChange: supplyChange,
      demandChange: demandChange,
      eventCause: eventCause,
    );

    dynamicPrice.applyPriceEvent(priceEvent);
  }

  /// Create a merchant inventory
  MerchantInventory createMerchantInventory({
    required String merchantId,
    required String merchantName,
    required String locationId,
    List<String>? specializedCategories,
    double basePriceModifier = 1.0,
    bool usesDynamicPricing = true,
    bool offersRelationshipDiscounts = true,
    int daysUntilRestock = 7,
  }) {
    var merchantInventory = MerchantInventory(
      merchantId: merchantId,
      merchantName: merchantName,
      locationId: locationId,
      specializedCategories: specializedCategories,
      basePriceModifier: basePriceModifier,
      usesDynamicPricing: usesDynamicPricing,
      offersRelationshipDiscounts: offersRelationshipDiscounts,
      daysUntilRestock: daysUntilRestock,
    );

    _merchantInventories[merchantId] = merchantInventory;
    return merchantInventory;
  }

  /// Add item to merchant inventory
  void addItemToMerchant({
    required String merchantId,
    required String itemId,
    required String itemName,
    required int stockQuantity,
    required int maxStock,
    bool restocks = true,
  }) {
    var merchantInventory = _merchantInventories[merchantId];
    if (merchantInventory == null) return;

    var merchantItem = MerchantItem(
      itemId: itemId,
      itemName: itemName,
      stockQuantity: stockQuantity,
      maxStock: maxStock,
      restocks: restocks,
    );

    merchantInventory.merchantItems[itemId] = merchantItem;
  }

  /// Purchase item from merchant
  bool purchaseItemFromMerchant({
    required String merchantId,
    required String itemId,
    required int quantity,
    required String characterId,
  }) {
    var merchantInventory = _merchantInventories[merchantId];
    if (merchantInventory == null) return false;

    var merchantItem = merchantInventory.merchantItems[itemId];
    if (merchantItem == null) return false;

    bool purchaseSuccess = merchantItem.purchase(quantity);

    if (purchaseSuccess) {
      // Update market supply (item was bought, reduces supply)
      updateSupplyLevel(itemId, -1);
    }

    return purchaseSuccess;
  }

  /// Sell item to merchant
  void sellItemToMerchant({
    required String merchantId,
    required String itemId,
    required int quantity,
  }) {
    var merchantInventory = _merchantInventories[merchantId];
    if (merchantInventory == null) return;

    var merchantItem = merchantInventory.merchantItems[itemId];
    if (merchantItem != null) {
      merchantItem.stockQuantity += quantity;
      // Cap at max stock
      merchantItem.stockQuantity = merchantItem.stockQuantity.clamp(0, merchantItem.maxStock);
    }

    // Update market supply (item was sold to merchant, increases supply)
    updateSupplyLevel(itemId, 1);
  }

  /// Restock merchant inventory
  void restockMerchant(String merchantId) {
    var merchantInventory = _merchantInventories[merchantId];
    if (merchantInventory == null) return;

    for (var merchantItem in merchantInventory.merchantItems.values) {
      merchantItem.restock();
    }
  }

  /// Apply daily market fluctuations
  void applyDailyMarketFluctuations() {
    for (var dynamicPrice in _itemPrices.values) {
      // Small random fluctuations in supply and demand
      int supplyFluctuation = _random.nextInt(5) - 2; // -2 to +2
      int demandFluctuation = _random.nextInt(5) - 2; // -2 to +2

      dynamicPrice.supplyLevel = (dynamicPrice.supplyLevel + supplyFluctuation).clamp(0, 100);
      dynamicPrice.demandLevel = (dynamicPrice.demandLevel + demandFluctuation).clamp(0, 100);

      dynamicPrice.updatePriceFromMarket();
    }
  }

  /// Set relationship discount for character at merchant
  void setRelationshipDiscount({
    required String merchantId,
    required String characterId,
    required double discountMultiplier,
  }) {
    var merchantInventory = _merchantInventories[merchantId];
    if (merchantInventory == null) return;

    merchantInventory.customerDiscounts[characterId] = discountMultiplier.clamp(0.1, 2.0);
  }

  /// Get merchant inventory
  MerchantInventory? getMerchantInventory(String merchantId) {
    return _merchantInventories[merchantId];
  }

  /// Get all merchants in a location
  List<MerchantInventory> getMerchantsInLocation(String locationId) {
    return _merchantInventories.values
        .where((m) => m.locationId == locationId)
        .toList();
  }

  /// Get price history for an item
  List<PriceEvent> getPriceHistory(String itemId) {
    var dynamicPrice = _itemPrices[itemId];
    return dynamicPrice?.priceHistory ?? [];
  }

  /// Get items with rising prices
  List<DynamicPrice> getItemsWithRisingPrices() {
    return _itemPrices.values
        .where((p) => p.priceTrend == TrendDirection.rising)
        .toList();
  }

  /// Get items with falling prices
  List<DynamicPrice> getItemsWithFallingPrices() {
    return _itemPrices.values
        .where((p) => p.priceTrend == TrendDirection.falling)
        .toList();
  }

  /// Apply world event economic impact
  void applyWorldEventEconomicImpact({
    required String itemId,
    required double priceModifier,
    required String eventDescription,
  }) {
    var dynamicPrice = _itemPrices[itemId];
    if (dynamicPrice == null) return;

    // Modify supply/demand based on price modifier
    if (priceModifier > 1.0) {
      // Prices increasing - reduce supply or increase demand
      updateSupplyLevel(itemId, -20);
      updateDemandLevel(itemId, 10);
    } else if (priceModifier < 1.0) {
      // Prices decreasing - increase supply or reduce demand
      updateSupplyLevel(itemId, 20);
      updateDemandLevel(itemId, -10);
    }

    applyPriceEvent(
      itemId: itemId,
      eventDescription: eventDescription,
      supplyChange: 0,
      demandChange: 0,
      eventCause: 'World event',
    );
  }

  /// Get economy summary for AI context
  String getEconomySummaryForAI() {
    var summary = StringBuffer();

    var risingPrices = getItemsWithRisingPrices();
    if (risingPrices.isNotEmpty) {
      summary.writeln('Rising Prices:');
      for (var dynamicPrice in risingPrices.take(5)) {
        summary.writeln('- ${dynamicPrice.itemName}: ${dynamicPrice.currentPriceModifier.toStringAsFixed(2)}x base price');
      }
    }

    var fallingPrices = getItemsWithFallingPrices();
    if (fallingPrices.isNotEmpty) {
      summary.writeln('\nFalling Prices:');
      for (var dynamicPrice in fallingPrices.take(5)) {
        summary.writeln('- ${dynamicPrice.itemName}: ${dynamicPrice.currentPriceModifier.toStringAsFixed(2)}x base price');
      }
    }

    return summary.toString();
  }

  /// Get price trend summary
  String getPriceTrendSummary(String itemId) {
    var dynamicPrice = _itemPrices[itemId];
    if (dynamicPrice == null) return 'Unknown item';

    var summary = StringBuffer();
    summary.writeln('${dynamicPrice.itemName}:');
    summary.writeln('  Base Price: ${dynamicPrice.basePrice} gp');
    summary.writeln('  Current Modifier: ${dynamicPrice.currentPriceModifier.toStringAsFixed(2)}x');
    summary.writeln('  Supply: ${dynamicPrice.supplyLevel}/100');
    summary.writeln('  Demand: ${dynamicPrice.demandLevel}/100');
    summary.writeln('  Trend: ${dynamicPrice.priceTrend.name}');

    return summary.toString();
  }

  /// Check if merchant has item in stock
  bool merchantHasItemInStock({
    required String merchantId,
    required String itemId,
    required int quantity,
  }) {
    var merchantInventory = _merchantInventories[merchantId];
    if (merchantInventory == null) return false;

    var merchantItem = merchantInventory.merchantItems[itemId];
    if (merchantItem == null) return false;

    return merchantItem.stockQuantity >= quantity;
  }

  /// Get available stock for item at merchant
  int getMerchantItemStock(String merchantId, String itemId) {
    var merchantInventory = _merchantInventories[merchantId];
    if (merchantInventory == null) return 0;

    var merchantItem = merchantInventory.merchantItems[itemId];
    return merchantItem?.stockQuantity ?? 0;
  }

  /// Set location modifier for item
  void setLocationModifier({
    required String itemId,
    required String locationId,
    required double modifier,
  }) {
    var dynamicPrice = _itemPrices[itemId];
    if (dynamicPrice == null) return;

    dynamicPrice.locationModifiers[locationId] = modifier.clamp(0.1, 5.0);
  }

  /// Get item pricing
  DynamicPrice? getItemPricing(String itemId) {
    return _itemPrices[itemId];
  }
}
