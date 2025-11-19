import 'package:eden_preprocessor_demo/models/enhanced_combat.dart';
import 'package:eden_preprocessor_demo/models/combat.dart';
import 'package:uuid/uuid.dart';

/// Service for managing enhanced combat features including reactions, hazards, and boss mechanics
class EnhancedCombatService {
  final List<CombatReaction> _availableReactions = [];
  final Map<String, List<CombatReaction>> _characterReactions = {}; // characterId -> reactions
  final Map<String, bool> _reactionAvailability = {}; // characterId -> has reaction available
  final List<EnvironmentalHazard> _activeHazards = [];
  final Map<String, BossMechanic> _bossMechanics = {}; // monsterId -> mechanics

  final Uuid _uuid = const Uuid();

  /// Register a reaction for a character
  void registerReactionForCharacter({
    required String characterId,
    required String reactionName,
    required ReactionType reactionType,
    required String description,
    required ReactionTrigger reactionTrigger,
    required String effectDescription,
    int? damageBonus,
    int? acBonus,
    bool? canCancelTriggeringAction,
  }) {
    var reaction = CombatReaction(
      reactionId: _uuid.v4(),
      reactionName: reactionName,
      reactionType: reactionType,
      description: description,
      reactionTrigger: reactionTrigger,
      effectDescription: effectDescription,
      damageBonus: damageBonus,
      acBonus: acBonus,
      canCancelTriggeringAction: canCancelTriggeringAction,
    );

    _characterReactions.putIfAbsent(characterId, () => []).add(reaction);
    _reactionAvailability[characterId] = true; // Reaction available
  }

  /// Get reactions for a character
  List<CombatReaction> getCharacterReactions(String characterId) {
    return _characterReactions[characterId] ?? [];
  }

  /// Check if character has reaction available
  bool hasReactionAvailable(String characterId) {
    return _reactionAvailability[characterId] ?? false;
  }

  /// Use a reaction (consumes it for the round)
  void useReaction(String characterId, String reactionId) {
    _reactionAvailability[characterId] = false;
  }

  /// Reset reactions at start of character's turn
  void resetReaction(String characterId) {
    _reactionAvailability[characterId] = true;
  }

  /// Reset all reactions at start of round
  void resetAllReactions() {
    for (var characterId in _reactionAvailability.keys) {
      _reactionAvailability[characterId] = true;
    }
  }

  /// Check for triggered reactions
  List<CombatReaction> checkForTriggeredReactions({
    required String characterId,
    required TriggerCondition triggerCondition,
    String? targetId,
  }) {
    if (!hasReactionAvailable(characterId)) return [];

    var characterReactions = getCharacterReactions(characterId);
    return characterReactions
        .where((r) => r.reactionTrigger.triggerCondition == triggerCondition)
        .toList();
  }

  /// Add environmental hazard
  EnvironmentalHazard addEnvironmentalHazard({
    required String hazardName,
    required HazardType hazardType,
    required String description,
    List<String>? affectedPositions,
    int radius = 5,
    required HazardEffect hazardEffect,
    int damagePerTurn = 0,
    String damageType = 'fire',
    int saveDC = 15,
    String saveAbility = 'dexterity',
    bool isPersistent = true,
    int? durationRounds,
    bool blocksMovement = false,
    bool providesCover = false,
    CoverType? coverType,
    bool canBeDisabled = false,
    int? disableDC,
    String? disableMethod,
  }) {
    var hazard = EnvironmentalHazard(
      hazardId: _uuid.v4(),
      hazardName: hazardName,
      hazardType: hazardType,
      description: description,
      affectedPositions: affectedPositions,
      radius: radius,
      hazardEffect: hazardEffect,
      damagePerTurn: damagePerTurn,
      damageType: damageType,
      saveDC: saveDC,
      saveAbility: saveAbility,
      isPersistent: isPersistent,
      durationRounds: durationRounds,
      blocksMovement: blocksMovement,
      providesCover: providesCover,
      coverType: coverType,
      canBeDisabled: canBeDisabled,
      disableDC: disableDC,
      disableMethod: disableMethod,
    );

    _activeHazards.add(hazard);
    return hazard;
  }

  /// Get all active hazards
  List<EnvironmentalHazard> getActiveHazards() {
    return List.unmodifiable(_activeHazards);
  }

  /// Get hazards at a position
  List<EnvironmentalHazard> getHazardsAtPosition(String position) {
    return _activeHazards
        .where((h) => h.affectedPositions.contains(position))
        .toList();
  }

  /// Remove hazard
  void removeHazard(String hazardId) {
    _activeHazards.removeWhere((h) => h.hazardId == hazardId);
  }

  /// Disable hazard (if possible)
  bool attemptDisableHazard(String hazardId, int checkResult) {
    var hazard = _activeHazards.firstWhere((h) => h.hazardId == hazardId);

    if (!hazard.canBeDisabled) return false;
    if (hazard.disableDC == null) return false;

    if (checkResult >= hazard.disableDC!) {
      removeHazard(hazardId);
      return true;
    }

    return false;
  }

  /// Add boss mechanics to a monster
  void addBossMechanics({
    required String monsterId,
    required String mechanicName,
    required MechanicType mechanicType,
    required String description,
    int? legendaryActionsPerRound,
    List<LegendaryAction>? legendaryActions,
    bool hasLairActions = false,
    int? lairActionInitiative,
    List<LairAction>? lairActions,
    List<BossPhase>? bossPhases,
    List<String>? damageResistances,
    List<String>? damageImmunities,
    List<String>? conditionImmunities,
    bool hasMagicResistance = false,
    bool hasLegendaryResistance = false,
    int? maxLegendaryResistances,
  }) {
    var bossMechanic = BossMechanic(
      mechanicId: _uuid.v4(),
      mechanicName: mechanicName,
      mechanicType: mechanicType,
      description: description,
      legendaryActionsPerRound: legendaryActionsPerRound,
      legendaryActions: legendaryActions,
      hasLairActions: hasLairActions,
      lairActionInitiative: lairActionInitiative,
      lairActions: lairActions,
      bossPhases: bossPhases,
      damageResistances: damageResistances,
      damageImmunities: damageImmunities,
      conditionImmunities: conditionImmunities,
      hasMagicResistance: hasMagicResistance,
      hasLegendaryResistance: hasLegendaryResistance,
      legendaryResistancesRemaining: maxLegendaryResistances,
      maxLegendaryResistances: maxLegendaryResistances,
    );

    _bossMechanics[monsterId] = bossMechanic;
  }

  /// Get boss mechanics for monster
  BossMechanic? getBossMechanics(String monsterId) {
    return _bossMechanics[monsterId];
  }

  /// Use legendary action
  bool useLegendaryAction(String monsterId, String actionId, int actionCost) {
    var bossMechanic = _bossMechanics[monsterId];
    if (bossMechanic == null) return false;
    if (bossMechanic.legendaryActionsPerRound == null) return false;

    // Check if enough legendary actions remain (would need to track this)
    // For now, just return true if action exists
    var action = bossMechanic.legendaryActions.firstWhere(
      (a) => a.actionId == actionId,
      orElse: () => throw Exception('Legendary action not found'),
    );

    return true; // Would need to track action economy
  }

  /// Trigger lair action
  String? triggerLairAction(String monsterId) {
    var bossMechanic = _bossMechanics[monsterId];
    if (bossMechanic == null) return null;
    if (!bossMechanic.hasLairActions) return null;
    if (bossMechanic.lairActions.isEmpty) return null;

    // Randomly select a lair action (or let DM choose)
    var randomAction = bossMechanic.lairActions[0]; // Simplified
    return randomAction.effect;
  }

  /// Check for boss phase transition
  bool checkBossPhaseTransition(String monsterId, int currentHP, int maxHP) {
    var bossMechanic = _bossMechanics[monsterId];
    if (bossMechanic == null) return false;

    var currentPhase = bossMechanic.getCurrentPhase();
    if (currentPhase == null) return false;

    // Check if should advance based on HP threshold
    var hpPercentage = ((currentHP / maxHP) * 100).round();

    // Check next phase trigger
    if (bossMechanic.currentPhaseIndex < bossMechanic.bossPhases.length - 1) {
      var nextPhase = bossMechanic.bossPhases[bossMechanic.currentPhaseIndex + 1];

      if (nextPhase.phaseTrigger.triggerType == TriggerType.hpThreshold &&
          nextPhase.phaseTrigger.hpThreshold != null &&
          hpPercentage <= nextPhase.phaseTrigger.hpThreshold!) {
        return bossMechanic.advancePhase();
      }
    }

    return false;
  }

  /// Advance boss phase manually
  bool advanceBossPhase(String monsterId) {
    var bossMechanic = _bossMechanics[monsterId];
    if (bossMechanic == null) return false;
    return bossMechanic.advancePhase();
  }

  /// Use legendary resistance
  bool useLegendaryResistance(String monsterId) {
    var bossMechanic = _bossMechanics[monsterId];
    if (bossMechanic == null) return false;
    return bossMechanic.useLegendaryResistance();
  }

  /// Get remaining legendary resistances
  int? getRemainingLegendaryResistances(String monsterId) {
    var bossMechanic = _bossMechanics[monsterId];
    return bossMechanic?.legendaryResistancesRemaining;
  }

  /// Check damage resistance
  bool hasDamageResistance(String monsterId, String damageType) {
    var bossMechanic = _bossMechanics[monsterId];
    if (bossMechanic == null) return false;
    return bossMechanic.damageResistances.contains(damageType);
  }

  /// Check damage immunity
  bool hasDamageImmunity(String monsterId, String damageType) {
    var bossMechanic = _bossMechanics[monsterId];
    if (bossMechanic == null) return false;
    return bossMechanic.damageImmunities.contains(damageType);
  }

  /// Check condition immunity
  bool hasConditionImmunity(String monsterId, String condition) {
    var bossMechanic = _bossMechanics[monsterId];
    if (bossMechanic == null) return false;
    return bossMechanic.conditionImmunities.contains(condition);
  }

  /// Get combat summary for AI context
  String getCombatSummaryForAI() {
    var summary = StringBuffer();

    if (_activeHazards.isNotEmpty) {
      summary.writeln('Environmental Hazards:');
      for (var hazard in _activeHazards) {
        summary.writeln('- ${hazard.hazardName}: ${hazard.description}');
        summary.writeln('  Damage: ${hazard.damagePerTurn} ${hazard.damageType}/turn, DC ${hazard.saveDC} ${hazard.saveAbility}');
      }
    }

    if (_bossMechanics.isNotEmpty) {
      summary.writeln('\nBoss Mechanics Active:');
      for (var entry in _bossMechanics.entries) {
        var bossMechanic = entry.value;
        summary.writeln('- ${bossMechanic.mechanicName}');

        var currentPhase = bossMechanic.getCurrentPhase();
        if (currentPhase != null) {
          summary.writeln('  Phase: ${currentPhase.phaseName}');
        }

        if (bossMechanic.legendaryActionsPerRound != null) {
          summary.writeln('  Legendary Actions: ${bossMechanic.legendaryActionsPerRound}/round');
        }

        if (bossMechanic.hasLairActions) {
          summary.writeln('  Has Lair Actions on initiative ${bossMechanic.lairActionInitiative}');
        }

        if (bossMechanic.legendaryResistancesRemaining != null) {
          summary.writeln('  Legendary Resistances: ${bossMechanic.legendaryResistancesRemaining}/${bossMechanic.maxLegendaryResistances}');
        }
      }
    }

    return summary.toString();
  }

  /// Clear all combat data (when combat ends)
  void clearCombatData() {
    _activeHazards.clear();
    _reactionAvailability.clear();
  }

  /// Get opportunity attack reaction for a character
  CombatReaction? getOpportunityAttackReaction(String characterId) {
    var characterReactions = getCharacterReactions(characterId);
    try {
      return characterReactions.firstWhere(
        (r) => r.reactionType == ReactionType.opportunityAttack,
      );
    } catch (e) {
      return null;
    }
  }
}
