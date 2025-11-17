class Spell {
  String id;
  String name;
  int level; // 0-9 (0 = cantrip)
  String school; // Evocation, Abjuration, Conjuration, Divination, Enchantment, Illusion, Necromancy, Transmutation
  String castingTime; // "1 action", "1 bonus action", "1 minute", "1 hour", etc.
  String range; // "60 feet", "Touch", "Self", "30 feet", etc.
  List<String> components; // ["V", "S", "M"]
  String? materialComponents;
  String duration; // "Instantaneous", "Concentration, up to 1 minute", "8 hours", etc.
  bool concentration;
  String description;
  String? higherLevelDescription;

  // For targeting
  String targetType; // "single", "area", "self", "multiple"
  String? areaShape; // "sphere", "cone", "line", "cube", "cylinder"
  int? areaSize; // radius in feet

  // For effects
  String? damageType; // "fire", "cold", "lightning", "thunder", "acid", "poison", "psychic", "radiant", "necrotic", "force", "bludgeoning", "piercing", "slashing"
  String? damageDice; // "8d6", "1d8", etc.
  String? savingThrow; // "Dexterity", "Wisdom", "Constitution", etc.
  String? effect; // "healing", "buff", "debuff", "control", "utility"
  List<String>? conditions; // ["stunned", "paralyzed", "charmed", etc.]

  // Class availability
  List<String> availableToClasses; // ["Wizard", "Sorcerer", etc.]

  bool ritual; // Can be cast as ritual

  Spell({
    required this.id,
    required this.name,
    required this.level,
    required this.school,
    required this.castingTime,
    required this.range,
    required this.components,
    this.materialComponents,
    required this.duration,
    required this.concentration,
    required this.description,
    this.higherLevelDescription,
    required this.targetType,
    this.areaShape,
    this.areaSize,
    this.damageType,
    this.damageDice,
    this.savingThrow,
    this.effect,
    this.conditions,
    required this.availableToClasses,
    this.ritual = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'level': level,
    'school': school,
    'castingTime': castingTime,
    'range': range,
    'components': components,
    'materialComponents': materialComponents,
    'duration': duration,
    'concentration': concentration,
    'description': description,
    'higherLevelDescription': higherLevelDescription,
    'targetType': targetType,
    'areaShape': areaShape,
    'areaSize': areaSize,
    'damageType': damageType,
    'damageDice': damageDice,
    'savingThrow': savingThrow,
    'effect': effect,
    'conditions': conditions,
    'availableToClasses': availableToClasses,
    'ritual': ritual,
  };

  factory Spell.fromJson(Map<String, dynamic> json) => Spell(
    id: json['id'] as String,
    name: json['name'] as String,
    level: json['level'] as int,
    school: json['school'] as String,
    castingTime: json['castingTime'] as String,
    range: json['range'] as String,
    components: (json['components'] as List<dynamic>).cast<String>(),
    materialComponents: json['materialComponents'] as String?,
    duration: json['duration'] as String,
    concentration: json['concentration'] as bool,
    description: json['description'] as String,
    higherLevelDescription: json['higherLevelDescription'] as String?,
    targetType: json['targetType'] as String,
    areaShape: json['areaShape'] as String?,
    areaSize: json['areaSize'] as int?,
    damageType: json['damageType'] as String?,
    damageDice: json['damageDice'] as String?,
    savingThrow: json['savingThrow'] as String?,
    effect: json['effect'] as String?,
    conditions: (json['conditions'] as List<dynamic>?)?.cast<String>(),
    availableToClasses: (json['availableToClasses'] as List<dynamic>).cast<String>(),
    ritual: json['ritual'] as bool? ?? false,
  );
}

class SpellSlots {
  Map<int, int> currentSlots; // level -> remaining
  Map<int, int> maxSlots;     // level -> max

  SpellSlots({
    required this.currentSlots,
    required this.maxSlots,
  });

  bool canCast(Spell spell, {int? upcasting}) {
    int level = upcasting ?? spell.level;
    if (spell.level == 0) return true; // Cantrips always available
    return currentSlots[level] != null && currentSlots[level]! > 0;
  }

  void castSpell(Spell spell, {int? upcasting}) {
    int level = upcasting ?? spell.level;
    if (level > 0 && currentSlots.containsKey(level)) {
      currentSlots[level] = (currentSlots[level] ?? 0) - 1;
      if (currentSlots[level]! < 0) currentSlots[level] = 0;
    }
  }

  void longRest() {
    currentSlots = Map.from(maxSlots);
  }

  void shortRest(String className) {
    if (className == 'Warlock') {
      // Warlocks regain all spell slots on short rest
      currentSlots = Map.from(maxSlots);
    }
  }

  void recoverSlot(int level, int amount) {
    if (maxSlots.containsKey(level)) {
      currentSlots[level] = ((currentSlots[level] ?? 0) + amount).clamp(0, maxSlots[level]!);
    }
  }

  Map<String, dynamic> toJson() => {
    'currentSlots': currentSlots.map((k, v) => MapEntry(k.toString(), v)),
    'maxSlots': maxSlots.map((k, v) => MapEntry(k.toString(), v)),
  };

  factory SpellSlots.fromJson(Map<String, dynamic> json) {
    return SpellSlots(
      currentSlots: (json['currentSlots'] as Map<String, dynamic>).map(
        (k, v) => MapEntry(int.parse(k), v as int),
      ),
      maxSlots: (json['maxSlots'] as Map<String, dynamic>).map(
        (k, v) => MapEntry(int.parse(k), v as int),
      ),
    );
  }

  // Create spell slots based on class and level
  static SpellSlots forClass(String className, int level, {int? warlockSlotLevel}) {
    Map<int, int> slots = {};

    switch (className) {
      case 'Wizard':
      case 'Sorcerer':
      case 'Cleric':
      case 'Druid':
      case 'Bard':
        // Full casters
        slots = _getFullCasterSlots(level);
        break;

      case 'Paladin':
      case 'Ranger':
        // Half casters
        slots = _getHalfCasterSlots(level);
        break;

      case 'Warlock':
        // Pact magic (different progression)
        slots = _getWarlockSlots(level);
        break;

      case 'Fighter':
      case 'Rogue':
        // Subclass casters (Eldritch Knight, Arcane Trickster)
        if (level >= 3) {
          slots = _getThirdCasterSlots(level);
        }
        break;

      default:
        slots = {};
    }

    return SpellSlots(
      currentSlots: Map.from(slots),
      maxSlots: slots,
    );
  }

  static Map<int, int> _getFullCasterSlots(int level) {
    const List<Map<int, int>> slotsByLevel = [
      {}, // Level 0
      {1: 2}, // Level 1
      {1: 3}, // Level 2
      {1: 4, 2: 2}, // Level 3
      {1: 4, 2: 3}, // Level 4
      {1: 4, 2: 3, 3: 2}, // Level 5
      {1: 4, 2: 3, 3: 3}, // Level 6
      {1: 4, 2: 3, 3: 3, 4: 1}, // Level 7
      {1: 4, 2: 3, 3: 3, 4: 2}, // Level 8
      {1: 4, 2: 3, 3: 3, 4: 3, 5: 1}, // Level 9
      {1: 4, 2: 3, 3: 3, 4: 3, 5: 2}, // Level 10
      {1: 4, 2: 3, 3: 3, 4: 3, 5: 2, 6: 1}, // Level 11
      {1: 4, 2: 3, 3: 3, 4: 3, 5: 2, 6: 1}, // Level 12
      {1: 4, 2: 3, 3: 3, 4: 3, 5: 2, 6: 1, 7: 1}, // Level 13
      {1: 4, 2: 3, 3: 3, 4: 3, 5: 2, 6: 1, 7: 1}, // Level 14
      {1: 4, 2: 3, 3: 3, 4: 3, 5: 2, 6: 1, 7: 1, 8: 1}, // Level 15
      {1: 4, 2: 3, 3: 3, 4: 3, 5: 2, 6: 1, 7: 1, 8: 1}, // Level 16
      {1: 4, 2: 3, 3: 3, 4: 3, 5: 2, 6: 1, 7: 1, 8: 1, 9: 1}, // Level 17
      {1: 4, 2: 3, 3: 3, 4: 3, 5: 3, 6: 1, 7: 1, 8: 1, 9: 1}, // Level 18
      {1: 4, 2: 3, 3: 3, 4: 3, 5: 3, 6: 2, 7: 1, 8: 1, 9: 1}, // Level 19
      {1: 4, 2: 3, 3: 3, 4: 3, 5: 3, 6: 2, 7: 2, 8: 1, 9: 1}, // Level 20
    ];

    return level < slotsByLevel.length ? Map.from(slotsByLevel[level]) : {};
  }

  static Map<int, int> _getHalfCasterSlots(int level) {
    const List<Map<int, int>> slotsByLevel = [
      {}, {}, // Levels 0-1
      {1: 2}, // Level 2
      {1: 3}, // Level 3
      {1: 3}, // Level 4
      {1: 4, 2: 2}, // Level 5
      {1: 4, 2: 2}, // Level 6
      {1: 4, 2: 3}, // Level 7
      {1: 4, 2: 3}, // Level 8
      {1: 4, 2: 3, 3: 2}, // Level 9
      {1: 4, 2: 3, 3: 2}, // Level 10
      {1: 4, 2: 3, 3: 3}, // Level 11
      {1: 4, 2: 3, 3: 3}, // Level 12
      {1: 4, 2: 3, 3: 3, 4: 1}, // Level 13
      {1: 4, 2: 3, 3: 3, 4: 1}, // Level 14
      {1: 4, 2: 3, 3: 3, 4: 2}, // Level 15
      {1: 4, 2: 3, 3: 3, 4: 2}, // Level 16
      {1: 4, 2: 3, 3: 3, 4: 3, 5: 1}, // Level 17
      {1: 4, 2: 3, 3: 3, 4: 3, 5: 1}, // Level 18
      {1: 4, 2: 3, 3: 3, 4: 3, 5: 2}, // Level 19
      {1: 4, 2: 3, 3: 3, 4: 3, 5: 2}, // Level 20
    ];

    return level < slotsByLevel.length ? Map.from(slotsByLevel[level]) : {};
  }

  static Map<int, int> _getWarlockSlots(int level) {
    if (level < 1) return {};
    if (level < 2) return {1: 1};
    if (level < 3) return {1: 2};
    if (level < 5) return {2: 2};
    if (level < 7) return {3: 2};
    if (level < 9) return {4: 2};
    if (level < 11) return {5: 2};
    if (level < 17) return {5: 3};
    return {5: 4};
  }

  static Map<int, int> _getThirdCasterSlots(int level) {
    const List<Map<int, int>> slotsByLevel = [
      {}, {}, {}, // Levels 0-2
      {1: 2}, // Level 3
      {1: 3}, // Level 4
      {1: 3}, // Level 5
      {1: 3}, // Level 6
      {1: 4, 2: 2}, // Level 7
      {1: 4, 2: 2}, // Level 8
      {1: 4, 2: 2}, // Level 9
      {1: 4, 2: 3}, // Level 10
      {1: 4, 2: 3}, // Level 11
      {1: 4, 2: 3}, // Level 12
      {1: 4, 2: 3, 3: 2}, // Level 13
      {1: 4, 2: 3, 3: 2}, // Level 14
      {1: 4, 2: 3, 3: 2}, // Level 15
      {1: 4, 2: 3, 3: 3}, // Level 16
      {1: 4, 2: 3, 3: 3}, // Level 17
      {1: 4, 2: 3, 3: 3}, // Level 18
      {1: 4, 2: 3, 3: 3, 4: 1}, // Level 19
      {1: 4, 2: 3, 3: 3, 4: 1}, // Level 20
    ];

    return level < slotsByLevel.length ? Map.from(slotsByLevel[level]) : {};
  }
}

class ConcentrationManager {
  Spell? concentrationSpell;
  int? concentrationStartRound;

  bool startConcentration(Spell spell, int currentRound) {
    if (concentrationSpell != null) {
      // Must break existing concentration
      breakConcentration();
    }

    if (spell.concentration) {
      concentrationSpell = spell;
      concentrationStartRound = currentRound;
      return true;
    }
    return false;
  }

  bool makeConcentrationCheck(int damage, int constitutionModifier, Function rollD20) {
    if (concentrationSpell == null) return true;

    int dc = damage ~/ 2;
    if (dc < 10) dc = 10;

    var result = rollD20(constitutionModifier);

    if (result < dc) {
      breakConcentration();
      return false;
    }
    return true;
  }

  void breakConcentration() {
    concentrationSpell = null;
    concentrationStartRound = null;
  }

  bool isConcentrating() {
    return concentrationSpell != null;
  }

  Map<String, dynamic> toJson() => {
    'concentrationSpell': concentrationSpell?.toJson(),
    'concentrationStartRound': concentrationStartRound,
  };

  factory ConcentrationManager.fromJson(Map<String, dynamic> json) {
    return ConcentrationManager()
      ..concentrationSpell = json['concentrationSpell'] != null
          ? Spell.fromJson(json['concentrationSpell'] as Map<String, dynamic>)
          : null
      ..concentrationStartRound = json['concentrationStartRound'] as int?;
  }
}
