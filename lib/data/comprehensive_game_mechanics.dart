// COMPREHENSIVE D&D 5E GAME MECHANICS
// Conditions, effects, environmental hazards, special mechanics

// ============================================================================
// CONDITIONS
// ============================================================================

class Condition {
  final String name;
  final String description;
  final List<String> effects;
  final String source;

  Condition({
    required this.name,
    required this.description,
    required this.effects,
    required this.source,
  });
}

final List<Condition> allConditions = [
  Condition(
    name: 'Blinded',
    description: 'A blinded creature can\'t see and automatically fails any ability check that requires sight.',
    effects: [
      'Attack rolls against the creature have advantage',
      'The creature\'s attack rolls have disadvantage',
    ],
    source: 'PHB',
  ),
  Condition(
    name: 'Charmed',
    description: 'A charmed creature can\'t attack the charmer or target the charmer with harmful abilities or magical effects.',
    effects: [
      'The charmer has advantage on any ability check to interact socially with the creature',
    ],
    source: 'PHB',
  ),
  Condition(
    name: 'Deafened',
    description: 'A deafened creature can\'t hear and automatically fails any ability check that requires hearing.',
    effects: [],
    source: 'PHB',
  ),
  Condition(
    name: 'Frightened',
    description: 'A frightened creature has disadvantage on ability checks and attack rolls while the source of its fear is within line of sight.',
    effects: [
      'The creature can\'t willingly move closer to the source of its fear',
    ],
    source: 'PHB',
  ),
  Condition(
    name: 'Grappled',
    description: 'A grappled creature\'s speed becomes 0, and it can\'t benefit from any bonus to its speed.',
    effects: [
      'The condition ends if the grappler is incapacitated',
      'The condition ends if an effect removes the grappled creature from the reach of the grappler',
    ],
    source: 'PHB',
  ),
  Condition(
    name: 'Incapacitated',
    description: 'An incapacitated creature can\'t take actions or reactions.',
    effects: [],
    source: 'PHB',
  ),
  Condition(
    name: 'Invisible',
    description: 'An invisible creature is impossible to see without the aid of magic or a special sense.',
    effects: [
      'For the purpose of hiding, the creature is heavily obscured',
      'The creature\'s location can be detected by any noise it makes or any tracks it leaves',
      'Attack rolls against the creature have disadvantage',
      'The creature\'s attack rolls have advantage',
    ],
    source: 'PHB',
  ),
  Condition(
    name: 'Paralyzed',
    description: 'A paralyzed creature is incapacitated and can\'t move or speak.',
    effects: [
      'The creature automatically fails Strength and Dexterity saving throws',
      'Attack rolls against the creature have advantage',
      'Any attack that hits the creature is a critical hit if the attacker is within 5 feet',
    ],
    source: 'PHB',
  ),
  Condition(
    name: 'Petrified',
    description: 'A petrified creature is transformed, along with any nonmagical object it is wearing or carrying, into a solid inanimate substance (usually stone).',
    effects: [
      'Its weight increases by a factor of ten, and it ceases aging',
      'The creature is incapacitated, can\'t move or speak, and is unaware of its surroundings',
      'Attack rolls against the creature have advantage',
      'The creature automatically fails Strength and Dexterity saving throws',
      'The creature has resistance to all damage',
      'The creature is immune to poison and disease',
    ],
    source: 'PHB',
  ),
  Condition(
    name: 'Poisoned',
    description: 'A poisoned creature has disadvantage on attack rolls and ability checks.',
    effects: [],
    source: 'PHB',
  ),
  Condition(
    name: 'Prone',
    description: 'A prone creature\'s only movement option is to crawl, unless it stands up and thereby ends the condition.',
    effects: [
      'The creature has disadvantage on attack rolls',
      'An attack roll against the creature has advantage if the attacker is within 5 feet',
      'Otherwise, the attack roll has disadvantage',
    ],
    source: 'PHB',
  ),
  Condition(
    name: 'Restrained',
    description: 'A restrained creature\'s speed becomes 0, and it can\'t benefit from any bonus to its speed.',
    effects: [
      'Attack rolls against the creature have advantage',
      'The creature\'s attack rolls have disadvantage',
      'The creature has disadvantage on Dexterity saving throws',
    ],
    source: 'PHB',
  ),
  Condition(
    name: 'Stunned',
    description: 'A stunned creature is incapacitated, can\'t move, and can speak only falteringly.',
    effects: [
      'The creature automatically fails Strength and Dexterity saving throws',
      'Attack rolls against the creature have advantage',
    ],
    source: 'PHB',
  ),
  Condition(
    name: 'Unconscious',
    description: 'An unconscious creature is incapacitated, can\'t move or speak, and is unaware of its surroundings.',
    effects: [
      'The creature drops whatever it\'s holding and falls prone',
      'The creature automatically fails Strength and Dexterity saving throws',
      'Attack rolls against the creature have advantage',
      'Any attack that hits the creature is a critical hit if the attacker is within 5 feet',
    ],
    source: 'PHB',
  ),
  Condition(
    name: 'Exhaustion',
    description: 'Some special abilities and environmental hazards can lead to exhaustion. Exhaustion has six levels.',
    effects: [
      'Level 1: Disadvantage on ability checks',
      'Level 2: Speed halved',
      'Level 3: Disadvantage on attack rolls and saving throws',
      'Level 4: Hit point maximum halved',
      'Level 5: Speed reduced to 0',
      'Level 6: Death',
    ],
    source: 'PHB',
  ),
];

// ============================================================================
// ENVIRONMENTAL HAZARDS
// ============================================================================

class EnvironmentalHazard {
  final String name;
  final String description;
  final String effect;
  final String savingThrow;
  final int dc;
  final String damage;

  EnvironmentalHazard({
    required this.name,
    required this.description,
    required this.effect,
    required this.savingThrow,
    required this.dc,
    required this.damage,
  });
}

final List<EnvironmentalHazard> environmentalHazards = [
  EnvironmentalHazard(
    name: 'Extreme Cold',
    description: 'Whenever the temperature is at or below 0 degrees Fahrenheit, a creature exposed must succeed on a DC 10 Constitution save or gain one level of exhaustion.',
    effect: 'Exhaustion',
    savingThrow: 'Constitution',
    dc: 10,
    damage: '1 level of exhaustion',
  ),
  EnvironmentalHazard(
    name: 'Extreme Heat',
    description: 'When the temperature is above 100 degrees Fahrenheit, a creature exposed must succeed on a Constitution save or gain one level of exhaustion.',
    effect: 'Exhaustion',
    savingThrow: 'Constitution',
    dc: 10,
    damage: '1 level of exhaustion',
  ),
  EnvironmentalHazard(
    name: 'Strong Wind',
    description: 'A strong wind imposes disadvantage on ranged weapon attack rolls and Perception checks that rely on hearing. It also extinguishes open flames.',
    effect: 'Disadvantage on ranged attacks and Perception',
    savingThrow: 'None',
    dc: 0,
    damage: 'None',
  ),
  EnvironmentalHazard(
    name: 'Heavy Precipitation',
    description: 'Everything within heavy precipitation is lightly obscured. Heavy precipitation extinguishes open flames.',
    effect: 'Lightly obscured',
    savingThrow: 'None',
    dc: 0,
    damage: 'None',
  ),
  EnvironmentalHazard(
    name: 'Falling',
    description: 'A creature takes 1d6 bludgeoning damage per 10 feet fallen, to a maximum of 20d6. The creature lands prone, unless it avoids taking damage.',
    effect: 'Bludgeoning damage and prone',
    savingThrow: 'None',
    dc: 0,
    damage: '1d6 per 10 feet (max 20d6)',
  ),
  EnvironmentalHazard(
    name: 'Suffocating',
    description: 'A creature can hold its breath for 1 + CON modifier minutes (minimum 30 seconds). When out of breath, it can survive for CON modifier rounds (minimum 1). After that, it drops to 0 hit points.',
    effect: 'Death',
    savingThrow: 'None',
    dc: 0,
    damage: 'Drops to 0 HP',
  ),
  EnvironmentalHazard(
    name: 'Lava',
    description: 'A creature that enters lava or starts its turn there takes 18d10 fire damage. Lava destroys most objects instantly.',
    effect: 'Massive fire damage',
    savingThrow: 'None',
    dc: 0,
    damage: '18d10 fire',
  ),
  EnvironmentalHazard(
    name: 'Quicksand',
    description: 'A creature that enters quicksand sinks 1d4+1 feet and becomes restrained. At the start of each turn, it sinks another 1d4 feet.',
    effect: 'Restrained and sinking',
    savingThrow: 'Strength or Dexterity',
    dc: 10,
    damage: 'Suffocation if fully submerged',
  ),
  EnvironmentalHazard(
    name: 'Razorvine',
    description: 'A creature moving through razorvine must make a DC 10 Dexterity save or take 1d10 slashing damage.',
    effect: 'Slashing damage',
    savingThrow: 'Dexterity',
    dc: 10,
    damage: '1d10 slashing',
  ),
  EnvironmentalHazard(
    name: 'Slippery Ice',
    description: 'Slippery ice is difficult terrain. When moving on slippery ice, a creature must succeed on a DC 10 Dexterity (Acrobatics) check or fall prone.',
    effect: 'Difficult terrain and potential prone',
    savingThrow: 'Dexterity (Acrobatics)',
    dc: 10,
    damage: 'Prone',
  ),
  EnvironmentalHazard(
    name: 'Thin Ice',
    description: 'Thin ice can support 100 pounds per 10-foot square. More weight breaks the ice. A creature that falls through must make a DC 10 Dexterity save or be restrained.',
    effect: 'Falling and potential restraint',
    savingThrow: 'Dexterity',
    dc: 10,
    damage: 'Cold exposure',
  ),
];

// ============================================================================
// TRAPS
// ============================================================================

class Trap {
  final String name;
  final String description;
  final String trigger;
  final String effect;
  final String savingThrow;
  final int dc;
  final String damage;
  final int detectDC;
  final int disarmDC;

  Trap({
    required this.name,
    required this.description,
    required this.trigger,
    required this.effect,
    required this.savingThrow,
    required this.dc,
    required this.damage,
    required this.detectDC,
    required this.disarmDC,
  });
}

final List<Trap> commonTraps = [
  Trap(
    name: 'Poison Dart Trap',
    description: 'A hidden pressure plate triggers darts to shoot from the walls.',
    trigger: 'Pressure plate',
    effect: 'Poison darts',
    savingThrow: 'Dexterity',
    dc: 13,
    damage: '1d4 piercing + 1d10 poison',
    detectDC: 15,
    disarmDC: 13,
  ),
  Trap(
    name: 'Falling Net',
    description: 'A net falls from the ceiling when triggered.',
    trigger: 'Tripwire',
    effect: 'Restrained',
    savingThrow: 'Dexterity',
    dc: 10,
    damage: 'Restrained',
    detectDC: 12,
    disarmDC: 10,
  ),
  Trap(
    name: 'Pit Trap',
    description: 'A 10-foot deep pit opens beneath the creature.',
    trigger: 'Pressure plate',
    effect: 'Falling damage',
    savingThrow: 'Dexterity',
    dc: 12,
    damage: '1d6 bludgeoning',
    detectDC: 15,
    disarmDC: 13,
  ),
  Trap(
    name: 'Spiked Pit',
    description: 'A 20-foot deep pit with spikes at the bottom.',
    trigger: 'Pressure plate',
    effect: 'Falling and piercing damage',
    savingThrow: 'Dexterity',
    dc: 15,
    damage: '2d6 bludgeoning + 2d6 piercing',
    detectDC: 15,
    disarmDC: 15,
  ),
  Trap(
    name: 'Swinging Blade',
    description: 'A massive blade swings across the corridor.',
    trigger: 'Tripwire',
    effect: 'Slashing damage',
    savingThrow: 'Dexterity',
    dc: 15,
    damage: '4d10 slashing',
    detectDC: 15,
    disarmDC: 15,
  ),
  Trap(
    name: 'Collapsing Ceiling',
    description: 'The ceiling collapses when the trap is triggered.',
    trigger: 'Pressure plate or weight',
    effect: 'Bludgeoning damage',
    savingThrow: 'Dexterity',
    dc: 15,
    damage: '4d10 bludgeoning',
    detectDC: 12,
    disarmDC: 15,
  ),
  Trap(
    name: 'Rolling Sphere',
    description: 'A 10-foot sphere of solid stone rolls through the corridor.',
    trigger: 'Tripwire',
    effect: 'Bludgeoning damage',
    savingThrow: 'Dexterity',
    dc: 15,
    damage: '10d10 bludgeoning',
    detectDC: 15,
    disarmDC: 15,
  ),
  Trap(
    name: 'Magic Mouth',
    description: 'When triggered, the mouth speaks a message and alerts nearby enemies.',
    trigger: 'Proximity',
    effect: 'Alert',
    savingThrow: 'None',
    dc: 0,
    damage: 'None (alerts enemies)',
    detectDC: 15,
    disarmDC: 15,
  ),
  Trap(
    name: 'Glyph of Warding',
    description: 'A magical glyph that explodes when triggered.',
    trigger: 'Touch or proximity',
    effect: 'Elemental damage',
    savingThrow: 'Dexterity',
    dc: 15,
    damage: '5d8 (type varies)',
    detectDC: 15,
    disarmDC: 15,
  ),
  Trap(
    name: 'Poison Gas',
    description: 'Poison gas fills the area when triggered.',
    trigger: 'Pressure plate',
    effect: 'Poison damage',
    savingThrow: 'Constitution',
    dc: 15,
    damage: '3d6 poison',
    detectDC: 15,
    disarmDC: 13,
  ),
];

// ============================================================================
// SPECIAL COMBAT ACTIONS
// ============================================================================

class CombatAction {
  final String name;
  final String actionType; // action, bonus action, reaction
  final String description;
  final String requirement;
  final String effect;

  CombatAction({
    required this.name,
    required this.actionType,
    required this.description,
    required this.requirement,
    required this.effect,
  });
}

final List<CombatAction> specialCombatActions = [
  CombatAction(
    name: 'Grapple',
    actionType: 'Action (Attack)',
    description: 'You attempt to seize and hold a creature.',
    requirement: 'One free hand, target no more than one size larger',
    effect: 'Target is grappled (escape DC = your Athletics or Acrobatics)',
  ),
  CombatAction(
    name: 'Shove',
    actionType: 'Action (Attack)',
    description: 'You attempt to shove a creature, either to knock it prone or push it away.',
    requirement: 'Target no more than one size larger',
    effect: 'Target is knocked prone or pushed 5 feet away',
  ),
  CombatAction(
    name: 'Dodge',
    actionType: 'Action',
    description: 'Focus entirely on avoiding attacks.',
    requirement: 'None',
    effect: 'Attack rolls against you have disadvantage, you have advantage on Dexterity saves',
  ),
  CombatAction(
    name: 'Disengage',
    actionType: 'Action',
    description: 'Your movement doesn\'t provoke opportunity attacks.',
    requirement: 'None',
    effect: 'No opportunity attacks for the rest of your turn',
  ),
  CombatAction(
    name: 'Dash',
    actionType: 'Action',
    description: 'Gain extra movement for the current turn.',
    requirement: 'None',
    effect: 'Gain extra movement equal to your speed',
  ),
  CombatAction(
    name: 'Help',
    actionType: 'Action',
    description: 'Aid another creature in completing a task or give advantage on an attack.',
    requirement: 'Within 5 feet of target',
    effect: 'Target has advantage on next ability check or attack',
  ),
  CombatAction(
    name: 'Hide',
    actionType: 'Action',
    description: 'Make a Dexterity (Stealth) check to hide.',
    requirement: 'Must be obscured from enemies',
    effect: 'Hidden (if successful)',
  ),
  CombatAction(
    name: 'Ready',
    actionType: 'Action',
    description: 'Prepare an action to trigger in response to a specified circumstance.',
    requirement: 'None',
    effect: 'Trigger action as a reaction when condition is met',
  ),
  CombatAction(
    name: 'Search',
    actionType: 'Action',
    description: 'Make a Wisdom (Perception) or Intelligence (Investigation) check to find something.',
    requirement: 'None',
    effect: 'Reveal hidden creatures or objects (if successful)',
  ),
  CombatAction(
    name: 'Use Object',
    actionType: 'Action',
    description: 'Interact with an object.',
    requirement: 'None',
    effect: 'Varies by object',
  ),
  CombatAction(
    name: 'Opportunity Attack',
    actionType: 'Reaction',
    description: 'You can make one melee attack against a creature that leaves your reach.',
    requirement: 'Creature leaves your reach without Disengaging',
    effect: 'One melee attack',
  ),
  CombatAction(
    name: 'Two-Weapon Fighting',
    actionType: 'Bonus Action',
    description: 'When you take the Attack action with a light weapon, you can make an attack with a different light weapon you\'re holding.',
    requirement: 'Both weapons must be light melee weapons',
    effect: 'One attack (no ability modifier to damage unless negative)',
  ),
];

// ============================================================================
// COVER
// ============================================================================

class CoverType {
  final String name;
  final String description;
  final int acBonus;
  final int dexSaveBonus;
  final String requirement;

  CoverType({
    required this.name,
    required this.description,
    required this.acBonus,
    required this.dexSaveBonus,
    required this.requirement,
  });
}

final List<CoverType> coverTypes = [
  CoverType(
    name: 'Half Cover',
    description: 'A target has half cover if an obstacle blocks at least half of its body.',
    acBonus: 2,
    dexSaveBonus: 2,
    requirement: 'At least half the body is obscured',
  ),
  CoverType(
    name: 'Three-Quarters Cover',
    description: 'A target has three-quarters cover if about three-quarters of it is covered by an obstacle.',
    acBonus: 5,
    dexSaveBonus: 5,
    requirement: 'About three-quarters of the body is obscured',
  ),
  CoverType(
    name: 'Total Cover',
    description: 'A target has total cover if it is completely concealed by an obstacle.',
    acBonus: 0, // Cannot be targeted
    dexSaveBonus: 0, // Cannot be targeted
    requirement: 'Completely obscured (cannot be targeted directly)',
  ),
];

// ============================================================================
// VISION AND LIGHT
// ============================================================================

class LightingCondition {
  final String name;
  final String description;
  final String effect;

  LightingCondition({
    required this.name,
    required this.description,
    required this.effect,
  });
}

final List<LightingCondition> lightingConditions = [
  LightingCondition(
    name: 'Bright Light',
    description: 'Most creatures can see normally in bright light.',
    effect: 'Normal vision',
  ),
  LightingCondition(
    name: 'Dim Light',
    description: 'Dim light creates a lightly obscured area.',
    effect: 'Disadvantage on Perception checks that rely on sight',
  ),
  LightingCondition(
    name: 'Darkness',
    description: 'Darkness creates a heavily obscured area.',
    effect: 'Creatures are effectively blinded',
  ),
  LightingCondition(
    name: 'Lightly Obscured',
    description: 'An area is lightly obscured by dim light, patchy fog, or moderate foliage.',
    effect: 'Disadvantage on Perception checks that rely on sight',
  ),
  LightingCondition(
    name: 'Heavily Obscured',
    description: 'An area is heavily obscured by darkness, opaque fog, or dense foliage.',
    effect: 'Vision is blocked entirely (creatures are effectively blinded)',
  ),
];

// ============================================================================
// RESTING
// ============================================================================

class RestType {
  final String name;
  final String duration;
  final String description;
  final List<String> benefits;
  final List<String> restrictions;

  RestType({
    required this.name,
    required this.duration,
    required this.description,
    required this.benefits,
    required this.restrictions,
  });
}

final List<RestType> restTypes = [
  RestType(
    name: 'Short Rest',
    duration: 'At least 1 hour',
    description: 'A period of downtime, at least 1 hour long, during which you do nothing more strenuous than eating, drinking, reading, and tending to wounds.',
    benefits: [
      'Spend Hit Dice to regain hit points',
      'Regain some class features that recharge on a short rest',
      'Some magic items recharge',
    ],
    restrictions: [
      'Cannot benefit from more than one long rest in a 24-hour period',
      'Must have at least 1 hit point at the start',
    ],
  ),
  RestType(
    name: 'Long Rest',
    duration: 'At least 8 hours',
    description: 'A period of extended downtime, at least 8 hours long, during which you sleep or perform light activity.',
    benefits: [
      'Regain all lost hit points',
      'Regain spent Hit Dice (up to half your total)',
      'Regain all spell slots',
      'Regain all class features',
      'Reduce exhaustion by 1 level',
    ],
    restrictions: [
      'Cannot benefit from more than one long rest in a 24-hour period',
      'Must have at least 1 hit point at the start',
      'Interrupted by 1 hour of strenuous activity (fighting, spellcasting, etc.)',
      'Must sleep for at least 6 hours',
    ],
  ),
];

// Helper functions
Condition? getConditionByName(String name) {
  try {
    return allConditions.firstWhere((c) => c.name.toLowerCase() == name.toLowerCase());
  } catch (e) {
    return null;
  }
}

List<EnvironmentalHazard> getHazardsBySave(String save) {
  return environmentalHazards.where((h) => h.savingThrow.toLowerCase().contains(save.toLowerCase())).toList();
}

List<Trap> getTrapsByDifficulty(int maxDC) {
  return commonTraps.where((t) => t.dc <= maxDC).toList();
}

List<CombatAction> getActionsByType(String type) {
  return specialCombatActions.where((a) => a.actionType.toLowerCase().contains(type.toLowerCase())).toList();
}
