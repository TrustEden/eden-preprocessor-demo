import 'package:eden_preprocessor_demo/models/combat.dart';

/// Enhanced combat system with reactions, environmental hazards, and boss mechanics

/// Types of reactions that can be triggered in combat
enum ReactionType {
  opportunityAttack, // Attack when enemy leaves reach
  shield, // Shield spell or similar
  counterspell, // Counter enemy spell
  parry, // Deflect attack
  riposte, // Counter-attack after dodge
  interceptingStrike, // Polearm Master feat
  sentinelStrike, // Sentinel feat
  mageSlayer, // Mage Slayer feat reaction
  uncanny Dodge, // Rogue ability
  custom,
}

/// Reaction that can be taken during combat
class CombatReaction {
  final String reactionId;
  final String reactionName;
  final ReactionType reactionType;
  final String description;

  // Trigger conditions
  final ReactionTrigger reactionTrigger;

  // Action cost
  final bool consumesReaction; // Most reactions consume the reaction
  final int? resourceCost; // Some use spell slots or other resources

  // Effects
  final String effectDescription;
  final int? damageBonus;
  final int? acBonus;
  final bool? canCancelTriggeringAction; // e.g., Counterspell

  CombatReaction({
    required this.reactionId,
    required this.reactionName,
    required this.reactionType,
    required this.description,
    required this.reactionTrigger,
    this.consumesReaction = true,
    this.resourceCost,
    required this.effectDescription,
    this.damageBonus,
    this.acBonus,
    this.canCancelTriggeringAction,
  });

  Map<String, dynamic> toJson() => {
        'reactionId': reactionId,
        'reactionName': reactionName,
        'reactionType': reactionType.name,
        'description': description,
        'reactionTrigger': reactionTrigger.toJson(),
        'consumesReaction': consumesReaction,
        'resourceCost': resourceCost,
        'effectDescription': effectDescription,
        'damageBonus': damageBonus,
        'acBonus': acBonus,
        'canCancelTriggeringAction': canCancelTriggeringAction,
      };

  factory CombatReaction.fromJson(Map<String, dynamic> json) {
    return CombatReaction(
      reactionId: json['reactionId'] as String,
      reactionName: json['reactionName'] as String,
      reactionType: ReactionType.values.firstWhere(
        (e) => e.name == json['reactionType'],
        orElse: () => ReactionType.custom,
      ),
      description: json['description'] as String,
      reactionTrigger: ReactionTrigger.fromJson(
        json['reactionTrigger'] as Map<String, dynamic>,
      ),
      consumesReaction: json['consumesReaction'] as bool? ?? true,
      resourceCost: json['resourceCost'] as int?,
      effectDescription: json['effectDescription'] as String,
      damageBonus: json['damageBonus'] as int?,
      acBonus: json['acBonus'] as int?,
      canCancelTriggeringAction: json['canCancelTriggeringAction'] as bool?,
    );
  }
}

/// What triggers a reaction
class ReactionTrigger {
  final TriggerCondition triggerCondition;
  final int? requiredRange; // In feet
  final bool requiresLineOfSight;
  final String? requiredTargetType; // 'ally', 'enemy', 'creature', 'spell'

  ReactionTrigger({
    required this.triggerCondition,
    this.requiredRange,
    this.requiresLineOfSight = true,
    this.requiredTargetType,
  });

  Map<String, dynamic> toJson() => {
        'triggerCondition': triggerCondition.name,
        'requiredRange': requiredRange,
        'requiresLineOfSight': requiresLineOfSight,
        'requiredTargetType': requiredTargetType,
      };

  factory ReactionTrigger.fromJson(Map<String, dynamic> json) {
    return ReactionTrigger(
      triggerCondition: TriggerCondition.values.firstWhere(
        (e) => e.name == json['triggerCondition'],
      ),
      requiredRange: json['requiredRange'] as int?,
      requiresLineOfSight: json['requiresLineOfSight'] as bool? ?? true,
      requiredTargetType: json['requiredTargetType'] as String?,
    );
  }
}

enum TriggerCondition {
  enemyLeavesReach,
  allyTakesDamage,
  enemyCastsSpell,
  beingAttacked,
  enemyEntersReach,
  allyMakesAttack,
  custom,
}

/// Environmental hazard in combat
class EnvironmentalHazard {
  final String hazardId;
  final String hazardName;
  final HazardType hazardType;
  final String description;

  // Position
  final List<String> affectedPositions; // Grid positions like "B3", "C4"
  final int radius; // Area of effect in feet

  // Effects
  final HazardEffect hazardEffect;
  final int damagePerTurn;
  final String damageType;
  final int saveDC;
  final String saveAbility;

  // Behavior
  final bool isPersistent; // Stays after being triggered
  final int? durationRounds;
  final bool blocksMovement;
  final bool providesCover;
  final CoverType? coverType;

  // Interaction
  final bool canBeDisabled;
  final int? disableDC;
  final String? disableMethod;

  EnvironmentalHazard({
    required this.hazardId,
    required this.hazardName,
    required this.hazardType,
    required this.description,
    List<String>? affectedPositions,
    this.radius = 5,
    required this.hazardEffect,
    this.damagePerTurn = 0,
    this.damageType = 'fire',
    this.saveDC = 15,
    this.saveAbility = 'dexterity',
    this.isPersistent = true,
    this.durationRounds,
    this.blocksMovement = false,
    this.providesCover = false,
    this.coverType,
    this.canBeDisabled = false,
    this.disableDC,
    this.disableMethod,
  }) : affectedPositions = affectedPositions ?? [];

  Map<String, dynamic> toJson() => {
        'hazardId': hazardId,
        'hazardName': hazardName,
        'hazardType': hazardType.name,
        'description': description,
        'affectedPositions': affectedPositions,
        'radius': radius,
        'hazardEffect': hazardEffect.name,
        'damagePerTurn': damagePerTurn,
        'damageType': damageType,
        'saveDC': saveDC,
        'saveAbility': saveAbility,
        'isPersistent': isPersistent,
        'durationRounds': durationRounds,
        'blocksMovement': blocksMovement,
        'providesCover': providesCover,
        'coverType': coverType?.name,
        'canBeDisabled': canBeDisabled,
        'disableDC': disableDC,
        'disableMethod': disableMethod,
      };

  factory EnvironmentalHazard.fromJson(Map<String, dynamic> json) {
    return EnvironmentalHazard(
      hazardId: json['hazardId'] as String,
      hazardName: json['hazardName'] as String,
      hazardType: HazardType.values.firstWhere(
        (e) => e.name == json['hazardType'],
        orElse: () => HazardType.trap,
      ),
      description: json['description'] as String,
      affectedPositions: (json['affectedPositions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      radius: json['radius'] as int? ?? 5,
      hazardEffect: HazardEffect.values.firstWhere(
        (e) => e.name == json['hazardEffect'],
        orElse: () => HazardEffect.damage,
      ),
      damagePerTurn: json['damagePerTurn'] as int? ?? 0,
      damageType: json['damageType'] as String? ?? 'fire',
      saveDC: json['saveDC'] as int? ?? 15,
      saveAbility: json['saveAbility'] as String? ?? 'dexterity',
      isPersistent: json['isPersistent'] as bool? ?? true,
      durationRounds: json['durationRounds'] as int?,
      blocksMovement: json['blocksMovement'] as bool? ?? false,
      providesCover: json['providesCover'] as bool? ?? false,
      coverType: json['coverType'] != null
          ? CoverType.values.firstWhere((e) => e.name == json['coverType'])
          : null,
      canBeDisabled: json['canBeDisabled'] as bool? ?? false,
      disableDC: json['disableDC'] as int?,
      disableMethod: json['disableMethod'] as String?,
    );
  }
}

enum HazardType {
  trap,
  magicalEffect,
  fire,
  poison,
  acid,
  terrain,
  weather,
  custom,
}

enum HazardEffect {
  damage,
  condition,
  movement,
  visibility,
  combination,
}

enum CoverType {
  half, // +2 AC
  threeQuarters, // +5 AC
  full, // Can't be targeted
}

/// Boss mechanic for legendary creatures
class BossMechanic {
  final String mechanicId;
  final String mechanicName;
  final MechanicType mechanicType;
  final String description;

  // Legendary Actions (if applicable)
  final int? legendaryActionsPerRound;
  final List<LegendaryAction> legendaryActions;

  // Lair Actions (if applicable)
  final bool hasLairActions;
  final int? lairActionInitiative; // Usually 20
  final List<LairAction> lairActions;

  // Phase transitions
  final List<BossPhase> bossPhases;
  int currentPhaseIndex;

  // Resistances and immunities
  final List<String> damageResistances;
  final List<String> damageImmunities;
  final List<String> conditionImmunities;

  // Special traits
  final bool hasMagicResistance;
  final bool hasLegendaryResistance;
  int? legendaryResistancesRemaining;
  final int? maxLegendaryResistances;

  BossMechanic({
    required this.mechanicId,
    required this.mechanicName,
    required this.mechanicType,
    required this.description,
    this.legendaryActionsPerRound,
    List<LegendaryAction>? legendaryActions,
    this.hasLairActions = false,
    this.lairActionInitiative,
    List<LairAction>? lairActions,
    List<BossPhase>? bossPhases,
    this.currentPhaseIndex = 0,
    List<String>? damageResistances,
    List<String>? damageImmunities,
    List<String>? conditionImmunities,
    this.hasMagicResistance = false,
    this.hasLegendaryResistance = false,
    this.legendaryResistancesRemaining,
    this.maxLegendaryResistances,
  })  : legendaryActions = legendaryActions ?? [],
        lairActions = lairActions ?? [],
        bossPhases = bossPhases ?? [],
        damageResistances = damageResistances ?? [],
        damageImmunities = damageImmunities ?? [],
        conditionImmunities = conditionImmunities ?? [];

  /// Advance to next phase
  bool advancePhase() {
    if (currentPhaseIndex < bossPhases.length - 1) {
      currentPhaseIndex++;
      return true;
    }
    return false;
  }

  /// Get current phase
  BossPhase? getCurrentPhase() {
    if (currentPhaseIndex < bossPhases.length) {
      return bossPhases[currentPhaseIndex];
    }
    return null;
  }

  /// Use legendary resistance
  bool useLegendaryResistance() {
    if (hasLegendaryResistance &&
        legendaryResistancesRemaining != null &&
        legendaryResistancesRemaining! > 0) {
      legendaryResistancesRemaining = legendaryResistancesRemaining! - 1;
      return true;
    }
    return false;
  }

  Map<String, dynamic> toJson() => {
        'mechanicId': mechanicId,
        'mechanicName': mechanicName,
        'mechanicType': mechanicType.name,
        'description': description,
        'legendaryActionsPerRound': legendaryActionsPerRound,
        'legendaryActions': legendaryActions.map((e) => e.toJson()).toList(),
        'hasLairActions': hasLairActions,
        'lairActionInitiative': lairActionInitiative,
        'lairActions': lairActions.map((e) => e.toJson()).toList(),
        'bossPhases': bossPhases.map((e) => e.toJson()).toList(),
        'currentPhaseIndex': currentPhaseIndex,
        'damageResistances': damageResistances,
        'damageImmunities': damageImmunities,
        'conditionImmunities': conditionImmunities,
        'hasMagicResistance': hasMagicResistance,
        'hasLegendaryResistance': hasLegendaryResistance,
        'legendaryResistancesRemaining': legendaryResistancesRemaining,
        'maxLegendaryResistances': maxLegendaryResistances,
      };

  factory BossMechanic.fromJson(Map<String, dynamic> json) {
    return BossMechanic(
      mechanicId: json['mechanicId'] as String,
      mechanicName: json['mechanicName'] as String,
      mechanicType: MechanicType.values.firstWhere(
        (e) => e.name == json['mechanicType'],
        orElse: () => MechanicType.standard,
      ),
      description: json['description'] as String,
      legendaryActionsPerRound: json['legendaryActionsPerRound'] as int?,
      legendaryActions: (json['legendaryActions'] as List<dynamic>?)
              ?.map((e) => LegendaryAction.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      hasLairActions: json['hasLairActions'] as bool? ?? false,
      lairActionInitiative: json['lairActionInitiative'] as int?,
      lairActions: (json['lairActions'] as List<dynamic>?)
              ?.map((e) => LairAction.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      bossPhases: (json['bossPhases'] as List<dynamic>?)
              ?.map((e) => BossPhase.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      currentPhaseIndex: json['currentPhaseIndex'] as int? ?? 0,
      damageResistances: (json['damageResistances'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      damageImmunities: (json['damageImmunities'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      conditionImmunities: (json['conditionImmunities'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      hasMagicResistance: json['hasMagicResistance'] as bool? ?? false,
      hasLegendaryResistance: json['hasLegendaryResistance'] as bool? ?? false,
      legendaryResistancesRemaining: json['legendaryResistancesRemaining'] as int?,
      maxLegendaryResistances: json['maxLegendaryResistances'] as int?,
    );
  }
}

enum MechanicType {
  standard,
  legendary,
  mythic,
  lair,
}

/// Legendary action that can be taken
class LegendaryAction {
  final String actionId;
  final String actionName;
  final String description;
  final int actionCost; // How many legendary actions it costs (usually 1-3)
  final String effect;

  LegendaryAction({
    required this.actionId,
    required this.actionName,
    required this.description,
    this.actionCost = 1,
    required this.effect,
  });

  Map<String, dynamic> toJson() => {
        'actionId': actionId,
        'actionName': actionName,
        'description': description,
        'actionCost': actionCost,
        'effect': effect,
      };

  factory LegendaryAction.fromJson(Map<String, dynamic> json) {
    return LegendaryAction(
      actionId: json['actionId'] as String,
      actionName: json['actionName'] as String,
      description: json['description'] as String,
      actionCost: json['actionCost'] as int? ?? 1,
      effect: json['effect'] as String,
    );
  }
}

/// Lair action that occurs on initiative count 20
class LairAction {
  final String actionId;
  final String actionName;
  final String description;
  final String effect;
  final int? saveDC;
  final String? saveAbility;

  LairAction({
    required this.actionId,
    required this.actionName,
    required this.description,
    required this.effect,
    this.saveDC,
    this.saveAbility,
  });

  Map<String, dynamic> toJson() => {
        'actionId': actionId,
        'actionName': actionName,
        'description': description,
        'effect': effect,
        'saveDC': saveDC,
        'saveAbility': saveAbility,
      };

  factory LairAction.fromJson(Map<String, dynamic> json) {
    return LairAction(
      actionId: json['actionId'] as String,
      actionName: json['actionName'] as String,
      description: json['description'] as String,
      effect: json['effect'] as String,
      saveDC: json['saveDC'] as int?,
      saveAbility: json['saveAbility'] as String?,
    );
  }
}

/// Phase of a boss fight
class BossPhase {
  final String phaseId;
  final String phaseName;
  final int phaseNumber;
  final String description;

  // Trigger condition
  final PhaseTrigger phaseTrigger;

  // Phase changes
  final List<String> newAbilities; // Abilities gained in this phase
  final List<String> lostAbilities; // Abilities lost
  final String? environmentalChange; // Changes to battlefield
  final String narrativeDescription; // How the transition is described

  BossPhase({
    required this.phaseId,
    required this.phaseName,
    required this.phaseNumber,
    required this.description,
    required this.phaseTrigger,
    List<String>? newAbilities,
    List<String>? lostAbilities,
    this.environmentalChange,
    required this.narrativeDescription,
  })  : newAbilities = newAbilities ?? [],
        lostAbilities = lostAbilities ?? [];

  Map<String, dynamic> toJson() => {
        'phaseId': phaseId,
        'phaseName': phaseName,
        'phaseNumber': phaseNumber,
        'description': description,
        'phaseTrigger': phaseTrigger.toJson(),
        'newAbilities': newAbilities,
        'lostAbilities': lostAbilities,
        'environmentalChange': environmentalChange,
        'narrativeDescription': narrativeDescription,
      };

  factory BossPhase.fromJson(Map<String, dynamic> json) {
    return BossPhase(
      phaseId: json['phaseId'] as String,
      phaseName: json['phaseName'] as String,
      phaseNumber: json['phaseNumber'] as int,
      description: json['description'] as String,
      phaseTrigger: PhaseTrigger.fromJson(
        json['phaseTrigger'] as Map<String, dynamic>,
      ),
      newAbilities: (json['newAbilities'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      lostAbilities: (json['lostAbilities'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      environmentalChange: json['environmentalChange'] as String?,
      narrativeDescription: json['narrativeDescription'] as String,
    );
  }
}

/// What triggers a phase transition
class PhaseTrigger {
  final TriggerType triggerType;
  final int? hpThreshold; // Percentage of HP remaining
  final int? roundNumber; // Specific round
  final String? conditionMet; // Special condition

  PhaseTrigger({
    required this.triggerType,
    this.hpThreshold,
    this.roundNumber,
    this.conditionMet,
  });

  Map<String, dynamic> toJson() => {
        'triggerType': triggerType.name,
        'hpThreshold': hpThreshold,
        'roundNumber': roundNumber,
        'conditionMet': conditionMet,
      };

  factory PhaseTrigger.fromJson(Map<String, dynamic> json) {
    return PhaseTrigger(
      triggerType: TriggerType.values.firstWhere(
        (e) => e.name == json['triggerType'],
      ),
      hpThreshold: json['hpThreshold'] as int?,
      roundNumber: json['roundNumber'] as int?,
      conditionMet: json['conditionMet'] as String?,
    );
  }
}

enum TriggerType {
  hpThreshold,
  roundNumber,
  condition,
  manual,
}
