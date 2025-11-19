import 'package:eden_preprocessor_demo/models/crafting_economy.dart';
import 'package:uuid/uuid.dart';
import 'dart:math';

/// Service for managing crafting projects and recipes
class CraftingService {
  final Map<String, CraftingRecipe> _availableRecipes = {}; // recipeId -> recipe
  final Map<String, CraftingProject> _activeProjects = {}; // projectId -> project
  final Map<String, List<CraftingProject>> _characterProjects = {}; // characterId -> projects

  final Uuid _uuid = const Uuid();
  final Random _random = Random();

  /// Register a crafting recipe
  void registerRecipe(CraftingRecipe craftingRecipe) {
    _availableRecipes[craftingRecipe.recipeId] = craftingRecipe;
  }

  /// Get all available recipes
  List<CraftingRecipe> getAvailableRecipes() {
    return List.unmodifiable(_availableRecipes.values);
  }

  /// Get recipes by type
  List<CraftingRecipe> getRecipesByType(CraftableItemType itemType) {
    return _availableRecipes.values
        .where((r) => r.itemType == itemType)
        .toList();
  }

  /// Get recipes by rarity
  List<CraftingRecipe> getRecipesByRarity(ItemRarity itemRarity) {
    return _availableRecipes.values
        .where((r) => r.itemRarity == itemRarity)
        .toList();
  }

  /// Get common knowledge recipes
  List<CraftingRecipe> getCommonKnowledgeRecipes() {
    return _availableRecipes.values
        .where((r) => r.isCommonKnowledge)
        .toList();
  }

  /// Get recipe by ID
  CraftingRecipe? getRecipeById(String recipeId) {
    return _availableRecipes[recipeId];
  }

  /// Start a crafting project
  CraftingProject startCraftingProject({
    required String characterId,
    required String recipeId,
    required Map<String, int> currentMaterialPrices,
    bool materialsAcquired = true,
    bool workshopSecured = true,
  }) {
    var craftingRecipe = getRecipeById(recipeId);
    if (craftingRecipe == null) {
      throw Exception('Recipe not found: $recipeId');
    }

    var totalCost = craftingRecipe.calculateTotalCost(currentMaterialPrices);

    var craftingProject = CraftingProject(
      projectId: _uuid.v4(),
      characterId: characterId,
      recipeId: recipeId,
      projectStatus: materialsAcquired && workshopSecured
          ? CraftingStatus.inProgress
          : CraftingStatus.planning,
      totalDaysRequired: craftingRecipe.craftingTimeDays,
      materialsAcquired: materialsAcquired,
      workshopSecured: workshopSecured,
      totalCostGold: totalCost,
    );

    _activeProjects[craftingProject.projectId] = craftingProject;
    _characterProjects.putIfAbsent(characterId, () => []).add(craftingProject);

    return craftingProject;
  }

  /// Work on a crafting project for a day
  void workOnProject({
    required String projectId,
    required int skillCheckRoll,
    required int skillModifier,
  }) {
    var craftingProject = _activeProjects[projectId];
    if (craftingProject == null) {
      throw Exception('Project not found: $projectId');
    }

    var craftingRecipe = getRecipeById(craftingProject.recipeId);
    if (craftingRecipe == null) {
      throw Exception('Recipe not found: ${craftingProject.recipeId}');
    }

    if (craftingProject.projectStatus != CraftingStatus.inProgress) {
      throw Exception('Project not in progress');
    }

    int totalRoll = skillCheckRoll + skillModifier;
    bool checkSuccess = totalRoll >= craftingRecipe.baseDC;

    // Calculate quality contribution
    int qualityContribution = 0;
    if (checkSuccess) {
      // Success: positive contribution
      qualityContribution = (totalRoll - craftingRecipe.baseDC).clamp(0, 10);
    } else {
      // Failure: negative contribution
      qualityContribution = (totalRoll - craftingRecipe.baseDC).clamp(-10, 0);
    }

    var craftingCheck = CraftingCheck(
      checkRoll: totalRoll,
      checkDC: craftingRecipe.baseDC,
      checkSuccess: checkSuccess,
      qualityContribution: qualityContribution,
    );

    craftingProject.workDay(craftingCheck);
  }

  /// Complete a crafting project
  CraftingOutcome completeProject(String projectId) {
    var craftingProject = _activeProjects[projectId];
    if (craftingProject == null) {
      throw Exception('Project not found: $projectId');
    }

    var craftingRecipe = getRecipeById(craftingProject.recipeId);
    if (craftingRecipe == null) {
      throw Exception('Recipe not found: ${craftingProject.recipeId}');
    }

    if (craftingProject.projectStatus != CraftingStatus.readyToFinish) {
      throw Exception('Project not ready to finish');
    }

    // Determine outcome based on quality score
    OutcomeQuality outcomeQuality;
    bool isMasterwork = false;
    List<String> bonusProperties = [];

    int avgQualityPerDay =
        (craftingProject.qualityScore / craftingProject.daysWorked).round();

    if (avgQualityPerDay >= 8) {
      outcomeQuality = OutcomeQuality.masterwork;
      isMasterwork = true;
      bonusProperties.add('+1 enhancement');
    } else if (avgQualityPerDay >= 5) {
      outcomeQuality = OutcomeQuality.superior;
      bonusProperties.add('Minor quality bonus');
    } else if (avgQualityPerDay >= 2) {
      outcomeQuality = OutcomeQuality.standard;
    } else if (avgQualityPerDay >= -2) {
      outcomeQuality = OutcomeQuality.flawed;
    } else {
      outcomeQuality = OutcomeQuality.failure;
    }

    var craftingOutcome = CraftingOutcome(
      outcomeQuality: outcomeQuality,
      itemCreated: craftingRecipe.resultingItemName,
      isMasterwork: isMasterwork,
      bonusProperties: bonusProperties,
      narrativeDescription: _generateOutcomeNarrative(outcomeQuality, craftingRecipe),
    );

    craftingProject.complete(craftingOutcome);

    return craftingOutcome;
  }

  /// Generate narrative description for outcome
  String _generateOutcomeNarrative(OutcomeQuality outcomeQuality, CraftingRecipe craftingRecipe) {
    switch (outcomeQuality) {
      case OutcomeQuality.failure:
        return 'Despite your efforts, the ${craftingRecipe.resultingItemName} is ruined. The materials are wasted.';
      case OutcomeQuality.flawed:
        return 'You manage to create the ${craftingRecipe.resultingItemName}, but it has noticeable flaws.';
      case OutcomeQuality.standard:
        return 'You successfully craft a standard ${craftingRecipe.resultingItemName}.';
      case OutcomeQuality.superior:
        return 'Your skill shines through in this superior ${craftingRecipe.resultingItemName}.';
      case OutcomeQuality.masterwork:
        return 'You have created a masterwork ${craftingRecipe.resultingItemName} of exceptional quality!';
    }
  }

  /// Abandon a project
  void abandonProject(String projectId) {
    var craftingProject = _activeProjects[projectId];
    if (craftingProject != null) {
      craftingProject.projectStatus = CraftingStatus.abandoned;
    }
  }

  /// Get active projects for a character
  List<CraftingProject> getCharacterActiveProjects(String characterId) {
    return _characterProjects[characterId]
            ?.where((p) => p.projectStatus == CraftingStatus.inProgress ||
                p.projectStatus == CraftingStatus.readyToFinish)
            .toList() ??
        [];
  }

  /// Get all projects for a character
  List<CraftingProject> getCharacterProjects(String characterId) {
    return _characterProjects[characterId] ?? [];
  }

  /// Get completed projects for a character
  List<CraftingProject> getCharacterCompletedProjects(String characterId) {
    return _characterProjects[characterId]
            ?.where((p) => p.projectStatus == CraftingStatus.completed)
            .toList() ??
        [];
  }

  /// Check if character can learn a recipe
  bool canLearnRecipe({
    required String recipeId,
    required int characterSkillLevel,
    required List<String> characterFeats,
  }) {
    var craftingRecipe = getRecipeById(recipeId);
    if (craftingRecipe == null) return false;

    // Check skill level
    if (characterSkillLevel < craftingRecipe.requiredSkillLevel) {
      return false;
    }

    // Check required feats
    for (var requiredFeat in craftingRecipe.requiredFeats) {
      if (!characterFeats.contains(requiredFeat)) {
        return false;
      }
    }

    return true;
  }

  /// Learn a recipe
  void learnRecipe(String characterId, String recipeId) {
    // In a more complete implementation, would track learned recipes per character
    // For now, recipes are globally available if canLearnRecipe returns true
  }

  /// Get crafting summary for AI context
  String getCraftingSummaryForAI(String characterId) {
    var summary = StringBuffer();
    var activeProjects = getCharacterActiveProjects(characterId);

    if (activeProjects.isNotEmpty) {
      summary.writeln('Active Crafting Projects:');
      for (var craftingProject in activeProjects) {
        var craftingRecipe = getRecipeById(craftingProject.recipeId);
        if (craftingRecipe != null) {
          summary.writeln('- ${craftingRecipe.resultingItemName}');
          summary.writeln('  Progress: ${craftingProject.progressPercentage}% (${craftingProject.daysWorked}/${craftingProject.totalDaysRequired} days)');
          summary.writeln('  Quality Score: ${craftingProject.qualityScore}');
        }
      }
    }

    var completedProjects = getCharacterCompletedProjects(characterId);
    if (completedProjects.isNotEmpty) {
      summary.writeln('\nRecently Completed:');
      for (var craftingProject in completedProjects.reversed.take(3)) {
        var craftingRecipe = getRecipeById(craftingProject.recipeId);
        if (craftingRecipe != null && craftingProject.craftingOutcome != null) {
          summary.writeln('- ${craftingRecipe.resultingItemName}: ${craftingProject.craftingOutcome!.outcomeQuality.name}');
        }
      }
    }

    return summary.toString();
  }

  /// Calculate material costs for a recipe
  Map<String, int> calculateMaterialCosts(String recipeId, Map<String, int> currentPrices) {
    var craftingRecipe = getRecipeById(recipeId);
    if (craftingRecipe == null) return {};

    Map<String, int> materialCosts = {};

    for (var craftingMaterial in craftingRecipe.requiredMaterials) {
      int pricePerUnit = currentPrices[craftingMaterial.materialId] ?? craftingMaterial.basePrice;
      materialCosts[craftingMaterial.materialId] = pricePerUnit * craftingMaterial.quantity;
    }

    return materialCosts;
  }

  /// Get project by ID
  CraftingProject? getProjectById(String projectId) {
    return _activeProjects[projectId];
  }

  /// Critical success check (roll of 20+)
  bool checkCriticalSuccess(int skillCheckRoll, int skillModifier, int baseDC) {
    int totalRoll = skillCheckRoll + skillModifier;
    return skillCheckRoll == 20 && totalRoll >= baseDC;
  }

  /// Critical failure check (roll of 1)
  bool checkCriticalFailure(int skillCheckRoll) {
    return skillCheckRoll == 1;
  }
}
