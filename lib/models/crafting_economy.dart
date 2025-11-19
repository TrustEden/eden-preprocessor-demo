/// Crafting and economy system for item creation and dynamic pricing

/// Types of craftable items
enum CraftableItemType {
  weapon,
  armor,
  potion,
  scroll,
  wondrous, // Wondrous items
  tool,
  ammunition,
  food,
  poison,
  custom,
}

/// Rarity of crafted items
enum ItemRarity {
  common,
  uncommon,
  rare,
  veryRare,
  legendary,
  artifact,
}

/// Crafting recipe for creating items
class CraftingRecipe {
  final String recipeId;
  final String recipeName;
  final String resultingItemId;
  final String resultingItemName;
  final CraftableItemType itemType;
  final ItemRarity itemRarity;

  // Requirements
  final List<CraftingMaterial> requiredMaterials;
  final Map<String, int> requiredTools; // toolType -> quantity
  final int craftingTimeDays;
  final int requiredSkillLevel; // 1-20
  final String requiredSkill; // e.g., 'smithing', 'alchemy', 'enchanting'

  // Costs
  final int baseCostGold;
  final int? workshopCostPerDay; // Cost to use workshop if needed

  // Success mechanics
  final int baseDC; // Difficulty check
  final bool canCriticalSuccess; // Can create superior version
  final bool canCriticalFailure; // Can waste materials

  // Recipe discovery
  final bool isCommonKnowledge;
  final String? discoveryMethod; // How to learn this recipe
  final List<String> requiredFeats; // Feats needed to craft

  CraftingRecipe({
    required this.recipeId,
    required this.recipeName,
    required this.resultingItemId,
    required this.resultingItemName,
    required this.itemType,
    required this.itemRarity,
    List<CraftingMaterial>? requiredMaterials,
    Map<String, int>? requiredTools,
    required this.craftingTimeDays,
    required this.requiredSkillLevel,
    required this.requiredSkill,
    required this.baseCostGold,
    this.workshopCostPerDay,
    required this.baseDC,
    this.canCriticalSuccess = true,
    this.canCriticalFailure = true,
    this.isCommonKnowledge = false,
    this.discoveryMethod,
    List<String>? requiredFeats,
  })  : requiredMaterials = requiredMaterials ?? [],
        requiredTools = requiredTools ?? {},
        requiredFeats = requiredFeats ?? [];

  /// Calculate total gold cost including materials
  int calculateTotalCost(Map<String, int> materialPrices) {
    int materialCost = 0;
    for (var material in requiredMaterials) {
      int pricePerUnit = materialPrices[material.materialId] ?? material.basePrice;
      materialCost += pricePerUnit * material.quantity;
    }

    int workshopCost = (workshopCostPerDay ?? 0) * craftingTimeDays;
    return baseCostGold + materialCost + workshopCost;
  }

  Map<String, dynamic> toJson() => {
        'recipeId': recipeId,
        'recipeName': recipeName,
        'resultingItemId': resultingItemId,
        'resultingItemName': resultingItemName,
        'itemType': itemType.name,
        'itemRarity': itemRarity.name,
        'requiredMaterials': requiredMaterials.map((e) => e.toJson()).toList(),
        'requiredTools': requiredTools,
        'craftingTimeDays': craftingTimeDays,
        'requiredSkillLevel': requiredSkillLevel,
        'requiredSkill': requiredSkill,
        'baseCostGold': baseCostGold,
        'workshopCostPerDay': workshopCostPerDay,
        'baseDC': baseDC,
        'canCriticalSuccess': canCriticalSuccess,
        'canCriticalFailure': canCriticalFailure,
        'isCommonKnowledge': isCommonKnowledge,
        'discoveryMethod': discoveryMethod,
        'requiredFeats': requiredFeats,
      };

  factory CraftingRecipe.fromJson(Map<String, dynamic> json) {
    return CraftingRecipe(
      recipeId: json['recipeId'] as String,
      recipeName: json['recipeName'] as String,
      resultingItemId: json['resultingItemId'] as String,
      resultingItemName: json['resultingItemName'] as String,
      itemType: CraftableItemType.values.firstWhere(
        (e) => e.name == json['itemType'],
        orElse: () => CraftableItemType.custom,
      ),
      itemRarity: ItemRarity.values.firstWhere(
        (e) => e.name == json['itemRarity'],
        orElse: () => ItemRarity.common,
      ),
      requiredMaterials: (json['requiredMaterials'] as List<dynamic>?)
              ?.map((e) => CraftingMaterial.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      requiredTools: (json['requiredTools'] as Map<String, dynamic>?)
              ?.map((key, value) => MapEntry(key, value as int)) ??
          {},
      craftingTimeDays: json['craftingTimeDays'] as int,
      requiredSkillLevel: json['requiredSkillLevel'] as int,
      requiredSkill: json['requiredSkill'] as String,
      baseCostGold: json['baseCostGold'] as int,
      workshopCostPerDay: json['workshopCostPerDay'] as int?,
      baseDC: json['baseDC'] as int,
      canCriticalSuccess: json['canCriticalSuccess'] as bool? ?? true,
      canCriticalFailure: json['canCriticalFailure'] as bool? ?? true,
      isCommonKnowledge: json['isCommonKnowledge'] as bool? ?? false,
      discoveryMethod: json['discoveryMethod'] as String?,
      requiredFeats: (json['requiredFeats'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }
}

/// Material needed for crafting
class CraftingMaterial {
  final String materialId;
  final String materialName;
  final int quantity;
  final int basePrice; // Price per unit in gold
  final MaterialRarity materialRarity;
  final String? source; // Where to obtain this material

  CraftingMaterial({
    required this.materialId,
    required this.materialName,
    required this.quantity,
    required this.basePrice,
    required this.materialRarity,
    this.source,
  });

  Map<String, dynamic> toJson() => {
        'materialId': materialId,
        'materialName': materialName,
        'quantity': quantity,
        'basePrice': basePrice,
        'materialRarity': materialRarity.name,
        'source': source,
      };

  factory CraftingMaterial.fromJson(Map<String, dynamic> json) {
    return CraftingMaterial(
      materialId: json['materialId'] as String,
      materialName: json['materialName'] as String,
      quantity: json['quantity'] as int,
      basePrice: json['basePrice'] as int,
      materialRarity: MaterialRarity.values.firstWhere(
        (e) => e.name == json['materialRarity'],
        orElse: () => MaterialRarity.common,
      ),
      source: json['source'] as String?,
    );
  }
}

enum MaterialRarity {
  abundant, // Easy to find
  common,
  uncommon,
  rare,
  exotic, // Very hard to find
}

/// Active crafting project
class CraftingProject {
  final String projectId;
  final String characterId;
  final String recipeId;
  CraftingStatus projectStatus;

  // Progress
  int daysWorked;
  final int totalDaysRequired;
  int progressPercentage;

  // Resources
  final bool materialsAcquired;
  final bool workshopSecured;
  final int totalCostGold;
  int goldSpent;

  // Quality control
  final List<CraftingCheck> craftingChecks;
  int qualityScore; // Accumulates from checks

  // Completion
  DateTime? completionDate;
  CraftingOutcome? craftingOutcome;

  CraftingProject({
    required this.projectId,
    required this.characterId,
    required this.recipeId,
    this.projectStatus = CraftingStatus.planning,
    this.daysWorked = 0,
    required this.totalDaysRequired,
    this.progressPercentage = 0,
    required this.materialsAcquired,
    required this.workshopSecured,
    required this.totalCostGold,
    this.goldSpent = 0,
    List<CraftingCheck>? craftingChecks,
    this.qualityScore = 0,
    this.completionDate,
    this.craftingOutcome,
  }) : craftingChecks = craftingChecks ?? [];

  /// Work on the project for a day
  void workDay(CraftingCheck check) {
    if (projectStatus != CraftingStatus.inProgress) return;

    daysWorked++;
    craftingChecks.add(check);
    qualityScore += check.qualityContribution;
    progressPercentage = ((daysWorked / totalDaysRequired) * 100).round();

    if (daysWorked >= totalDaysRequired) {
      projectStatus = CraftingStatus.readyToFinish;
    }
  }

  /// Complete the project
  void complete(CraftingOutcome outcome) {
    projectStatus = CraftingStatus.completed;
    craftingOutcome = outcome;
    completionDate = DateTime.now();
  }

  Map<String, dynamic> toJson() => {
        'projectId': projectId,
        'characterId': characterId,
        'recipeId': recipeId,
        'projectStatus': projectStatus.name,
        'daysWorked': daysWorked,
        'totalDaysRequired': totalDaysRequired,
        'progressPercentage': progressPercentage,
        'materialsAcquired': materialsAcquired,
        'workshopSecured': workshopSecured,
        'totalCostGold': totalCostGold,
        'goldSpent': goldSpent,
        'craftingChecks': craftingChecks.map((e) => e.toJson()).toList(),
        'qualityScore': qualityScore,
        'completionDate': completionDate?.toIso8601String(),
        'craftingOutcome': craftingOutcome?.toJson(),
      };

  factory CraftingProject.fromJson(Map<String, dynamic> json) {
    return CraftingProject(
      projectId: json['projectId'] as String,
      characterId: json['characterId'] as String,
      recipeId: json['recipeId'] as String,
      projectStatus: CraftingStatus.values.firstWhere(
        (e) => e.name == json['projectStatus'],
        orElse: () => CraftingStatus.planning,
      ),
      daysWorked: json['daysWorked'] as int? ?? 0,
      totalDaysRequired: json['totalDaysRequired'] as int,
      progressPercentage: json['progressPercentage'] as int? ?? 0,
      materialsAcquired: json['materialsAcquired'] as bool,
      workshopSecured: json['workshopSecured'] as bool,
      totalCostGold: json['totalCostGold'] as int,
      goldSpent: json['goldSpent'] as int? ?? 0,
      craftingChecks: (json['craftingChecks'] as List<dynamic>?)
              ?.map((e) => CraftingCheck.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      qualityScore: json['qualityScore'] as int? ?? 0,
      completionDate: json['completionDate'] != null
          ? DateTime.parse(json['completionDate'] as String)
          : null,
      craftingOutcome: json['craftingOutcome'] != null
          ? CraftingOutcome.fromJson(json['craftingOutcome'] as Map<String, dynamic>)
          : null,
    );
  }
}

enum CraftingStatus {
  planning,
  inProgress,
  readyToFinish,
  completed,
  failed,
  abandoned,
}

/// Daily crafting check
class CraftingCheck {
  final int checkRoll;
  final int checkDC;
  final bool checkSuccess;
  final int qualityContribution; // Positive or negative

  CraftingCheck({
    required this.checkRoll,
    required this.checkDC,
    required this.checkSuccess,
    required this.qualityContribution,
  });

  Map<String, dynamic> toJson() => {
        'checkRoll': checkRoll,
        'checkDC': checkDC,
        'checkSuccess': checkSuccess,
        'qualityContribution': qualityContribution,
      };

  factory CraftingCheck.fromJson(Map<String, dynamic> json) {
    return CraftingCheck(
      checkRoll: json['checkRoll'] as int,
      checkDC: json['checkDC'] as int,
      checkSuccess: json['checkSuccess'] as bool,
      qualityContribution: json['qualityContribution'] as int,
    );
  }
}

/// Outcome of a crafting project
class CraftingOutcome {
  final OutcomeQuality outcomeQuality;
  final String itemCreated;
  final bool isMasterwork; // Superior quality
  final List<String> bonusProperties; // Additional properties if crit success
  final String narrativeDescription;

  CraftingOutcome({
    required this.outcomeQuality,
    required this.itemCreated,
    this.isMasterwork = false,
    List<String>? bonusProperties,
    required this.narrativeDescription,
  }) : bonusProperties = bonusProperties ?? [];

  Map<String, dynamic> toJson() => {
        'outcomeQuality': outcomeQuality.name,
        'itemCreated': itemCreated,
        'isMasterwork': isMasterwork,
        'bonusProperties': bonusProperties,
        'narrativeDescription': narrativeDescription,
      };

  factory CraftingOutcome.fromJson(Map<String, dynamic> json) {
    return CraftingOutcome(
      outcomeQuality: OutcomeQuality.values.firstWhere(
        (e) => e.name == json['outcomeQuality'],
        orElse: () => OutcomeQuality.standard,
      ),
      itemCreated: json['itemCreated'] as String,
      isMasterwork: json['isMasterwork'] as bool? ?? false,
      bonusProperties: (json['bonusProperties'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      narrativeDescription: json['narrativeDescription'] as String,
    );
  }
}

enum OutcomeQuality {
  failure, // Wasted materials
  flawed, // Item works but has drawbacks
  standard, // Normal quality
  superior, // Better than normal
  masterwork, // Exceptional quality
}

/// Dynamic pricing for items based on supply and demand
class DynamicPrice {
  final String itemId;
  final String itemName;
  final int basePrice;
  double currentPriceModifier; // Multiplier applied to base price

  // Supply and demand
  int supplyLevel; // 0-100, higher = more available
  int demandLevel; // 0-100, higher = more wanted

  // Location-based pricing
  final Map<String, double> locationModifiers; // locationId -> modifier

  // Event-based pricing
  final List<PriceEvent> priceHistory;

  // Market trends
  TrendDirection priceTrend;
  int trendStrength; // 1-10

  DynamicPrice({
    required this.itemId,
    required this.itemName,
    required this.basePrice,
    this.currentPriceModifier = 1.0,
    this.supplyLevel = 50,
    this.demandLevel = 50,
    Map<String, double>? locationModifiers,
    List<PriceEvent>? priceHistory,
    this.priceTrend = TrendDirection.stable,
    this.trendStrength = 1,
  })  : locationModifiers = locationModifiers ?? {},
        priceHistory = priceHistory ?? [];

  /// Calculate current price
  int getCurrentPrice({String? locationId}) {
    double modifier = currentPriceModifier;

    // Apply location modifier
    if (locationId != null && locationModifiers.containsKey(locationId)) {
      modifier *= locationModifiers[locationId]!;
    }

    return (basePrice * modifier).round();
  }

  /// Update price based on supply and demand
  void updatePriceFromMarket() {
    // Simple supply/demand calculation
    // High demand + low supply = high prices
    // Low demand + high supply = low prices
    double marketFactor = (demandLevel / 50.0) * (50.0 / supplyLevel.clamp(1, 100));
    currentPriceModifier = marketFactor.clamp(0.1, 5.0); // Cap at 10% to 500%

    // Update trend
    if (currentPriceModifier > 1.2) {
      priceTrend = TrendDirection.rising;
    } else if (currentPriceModifier < 0.8) {
      priceTrend = TrendDirection.falling;
    } else {
      priceTrend = TrendDirection.stable;
    }
  }

  /// Apply a price event
  void applyPriceEvent(PriceEvent event) {
    priceHistory.add(event);
    supplyLevel = (supplyLevel + event.supplyChange).clamp(0, 100);
    demandLevel = (demandLevel + event.demandChange).clamp(0, 100);
    updatePriceFromMarket();
  }

  Map<String, dynamic> toJson() => {
        'itemId': itemId,
        'itemName': itemName,
        'basePrice': basePrice,
        'currentPriceModifier': currentPriceModifier,
        'supplyLevel': supplyLevel,
        'demandLevel': demandLevel,
        'locationModifiers': locationModifiers,
        'priceHistory': priceHistory.map((e) => e.toJson()).toList(),
        'priceTrend': priceTrend.name,
        'trendStrength': trendStrength,
      };

  factory DynamicPrice.fromJson(Map<String, dynamic> json) {
    return DynamicPrice(
      itemId: json['itemId'] as String,
      itemName: json['itemName'] as String,
      basePrice: json['basePrice'] as int,
      currentPriceModifier: (json['currentPriceModifier'] as num?)?.toDouble() ?? 1.0,
      supplyLevel: json['supplyLevel'] as int? ?? 50,
      demandLevel: json['demandLevel'] as int? ?? 50,
      locationModifiers: (json['locationModifiers'] as Map<String, dynamic>?)
              ?.map((key, value) => MapEntry(key, (value as num).toDouble())) ??
          {},
      priceHistory: (json['priceHistory'] as List<dynamic>?)
              ?.map((e) => PriceEvent.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      priceTrend: TrendDirection.values.firstWhere(
        (e) => e.name == json['priceTrend'],
        orElse: () => TrendDirection.stable,
      ),
      trendStrength: json['trendStrength'] as int? ?? 1,
    );
  }
}

enum TrendDirection {
  rising,
  stable,
  falling,
}

/// Event that affected pricing
class PriceEvent {
  final String eventId;
  final String eventDescription;
  final DateTime eventDate;
  final int supplyChange; // Positive or negative
  final int demandChange; // Positive or negative
  final String eventCause; // What caused this

  PriceEvent({
    required this.eventId,
    required this.eventDescription,
    required this.eventDate,
    required this.supplyChange,
    required this.demandChange,
    required this.eventCause,
  });

  Map<String, dynamic> toJson() => {
        'eventId': eventId,
        'eventDescription': eventDescription,
        'eventDate': eventDate.toIso8601String(),
        'supplyChange': supplyChange,
        'demandChange': demandChange,
        'eventCause': eventCause,
      };

  factory PriceEvent.fromJson(Map<String, dynamic> json) {
    return PriceEvent(
      eventId: json['eventId'] as String,
      eventDescription: json['eventDescription'] as String,
      eventDate: DateTime.parse(json['eventDate'] as String),
      supplyChange: json['supplyChange'] as int,
      demandChange: json['demandChange'] as int,
      eventCause: json['eventCause'] as String,
    );
  }
}

/// Merchant inventory with dynamic pricing
class MerchantInventory {
  final String merchantId;
  final String merchantName;
  final String locationId;

  // Inventory
  final Map<String, MerchantItem> merchantItems; // itemId -> item
  final List<String> specializedCategories; // What merchant focuses on

  // Pricing strategy
  final double basePriceModifier; // Merchant's general pricing (0.5 = discount, 2.0 = expensive)
  final bool usesDynamicPricing;

  // Relationship-based pricing
  final bool offersRelationshipDiscounts;
  final Map<String, double> customerDiscounts; // characterId -> discount multiplier

  // Stock refresh
  final int daysUntilRestock;
  final DateTime lastRestockDate;

  MerchantInventory({
    required this.merchantId,
    required this.merchantName,
    required this.locationId,
    Map<String, MerchantItem>? merchantItems,
    List<String>? specializedCategories,
    this.basePriceModifier = 1.0,
    this.usesDynamicPricing = true,
    this.offersRelationshipDiscounts = true,
    Map<String, double>? customerDiscounts,
    this.daysUntilRestock = 7,
    DateTime? lastRestockDate,
  })  : merchantItems = merchantItems ?? {},
        specializedCategories = specializedCategories ?? [],
        customerDiscounts = customerDiscounts ?? {},
        lastRestockDate = lastRestockDate ?? DateTime.now();

  /// Get price for a character (includes relationship discounts)
  int getPriceForCharacter(String itemId, String characterId, int basePrice) {
    double finalModifier = basePriceModifier;

    // Apply relationship discount
    if (offersRelationshipDiscounts && customerDiscounts.containsKey(characterId)) {
      finalModifier *= customerDiscounts[characterId]!;
    }

    return (basePrice * finalModifier).round();
  }

  Map<String, dynamic> toJson() => {
        'merchantId': merchantId,
        'merchantName': merchantName,
        'locationId': locationId,
        'merchantItems': merchantItems.map((key, value) => MapEntry(key, value.toJson())),
        'specializedCategories': specializedCategories,
        'basePriceModifier': basePriceModifier,
        'usesDynamicPricing': usesDynamicPricing,
        'offersRelationshipDiscounts': offersRelationshipDiscounts,
        'customerDiscounts': customerDiscounts,
        'daysUntilRestock': daysUntilRestock,
        'lastRestockDate': lastRestockDate.toIso8601String(),
      };

  factory MerchantInventory.fromJson(Map<String, dynamic> json) {
    return MerchantInventory(
      merchantId: json['merchantId'] as String,
      merchantName: json['merchantName'] as String,
      locationId: json['locationId'] as String,
      merchantItems: (json['merchantItems'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(
              key,
              MerchantItem.fromJson(value as Map<String, dynamic>),
            ),
          ) ??
          {},
      specializedCategories: (json['specializedCategories'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      basePriceModifier: (json['basePriceModifier'] as num?)?.toDouble() ?? 1.0,
      usesDynamicPricing: json['usesDynamicPricing'] as bool? ?? true,
      offersRelationshipDiscounts: json['offersRelationshipDiscounts'] as bool? ?? true,
      customerDiscounts: (json['customerDiscounts'] as Map<String, dynamic>?)
              ?.map((key, value) => MapEntry(key, (value as num).toDouble())) ??
          {},
      daysUntilRestock: json['daysUntilRestock'] as int? ?? 7,
      lastRestockDate: json['lastRestockDate'] != null
          ? DateTime.parse(json['lastRestockDate'] as String)
          : DateTime.now(),
    );
  }
}

/// Item in merchant's inventory
class MerchantItem {
  final String itemId;
  final String itemName;
  int stockQuantity;
  final int maxStock;
  final bool restocks;

  MerchantItem({
    required this.itemId,
    required this.itemName,
    required this.stockQuantity,
    required this.maxStock,
    this.restocks = true,
  });

  /// Purchase items
  bool purchase(int quantity) {
    if (stockQuantity >= quantity) {
      stockQuantity -= quantity;
      return true;
    }
    return false;
  }

  /// Restock
  void restock() {
    if (restocks) {
      stockQuantity = maxStock;
    }
  }

  Map<String, dynamic> toJson() => {
        'itemId': itemId,
        'itemName': itemName,
        'stockQuantity': stockQuantity,
        'maxStock': maxStock,
        'restocks': restocks,
      };

  factory MerchantItem.fromJson(Map<String, dynamic> json) {
    return MerchantItem(
      itemId: json['itemId'] as String,
      itemName: json['itemName'] as String,
      stockQuantity: json['stockQuantity'] as int,
      maxStock: json['maxStock'] as int,
      restocks: json['restocks'] as bool? ?? true,
    );
  }
}
