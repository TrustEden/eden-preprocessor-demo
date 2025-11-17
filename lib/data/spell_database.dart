import '../models/spell.dart';

/// Database of D&D 5e spells
class SpellDatabase {
  // Cantrips (Level 0)
  static Spell fireBolt() => Spell(
    id: 'fire_bolt',
    name: 'Fire Bolt',
    level: 0,
    school: 'Evocation',
    castingTime: '1 action',
    range: '120 feet',
    components: ['V', 'S'],
    duration: 'Instantaneous',
    concentration: false,
    description: 'You hurl a mote of fire at a creature or object. Make a ranged spell attack. On a hit, the target takes 1d10 fire damage. A flammable object hit by this spell ignites if it isn\'t being worn or carried.',
    higherLevelDescription: 'The spell\'s damage increases by 1d10 when you reach 5th level (2d10), 11th level (3d10), and 17th level (4d10).',
    targetType: 'single',
    damageType: 'fire',
    damageDice: '1d10',
    availableToClasses: ['Wizard', 'Sorcerer'],
  );

  static Spell rayOfFrost() => Spell(
    id: 'ray_of_frost',
    name: 'Ray of Frost',
    level: 0,
    school: 'Evocation',
    castingTime: '1 action',
    range: '60 feet',
    components: ['V', 'S'],
    duration: 'Instantaneous',
    concentration: false,
    description: 'A frigid beam of blue-white light streaks toward a creature. Make a ranged spell attack. On a hit, it takes 1d8 cold damage and its speed is reduced by 10 feet until the start of your next turn.',
    targetType: 'single',
    damageType: 'cold',
    damageDice: '1d8',
    availableToClasses: ['Wizard', 'Sorcerer'],
  );

  static Spell sacredFlame() => Spell(
    id: 'sacred_flame',
    name: 'Sacred Flame',
    level: 0,
    school: 'Evocation',
    castingTime: '1 action',
    range: '60 feet',
    components: ['V', 'S'],
    duration: 'Instantaneous',
    concentration: false,
    description: 'Flame-like radiance descends on a creature. The target must succeed on a Dexterity saving throw or take 1d8 radiant damage. The target gains no benefit from cover for this saving throw.',
    targetType: 'single',
    damageType: 'radiant',
    damageDice: '1d8',
    savingThrow: 'Dexterity',
    availableToClasses: ['Cleric'],
  );

  static Spell eldritchBlast() => Spell(
    id: 'eldritch_blast',
    name: 'Eldritch Blast',
    level: 0,
    school: 'Evocation',
    castingTime: '1 action',
    range: '120 feet',
    components: ['V', 'S'],
    duration: 'Instantaneous',
    concentration: false,
    description: 'A beam of crackling energy streaks toward a creature. Make a ranged spell attack. On a hit, the target takes 1d10 force damage. The spell creates more than one beam when you reach higher levels: two beams at 5th level, three at 11th, and four at 17th.',
    targetType: 'single',
    damageType: 'force',
    damageDice: '1d10',
    availableToClasses: ['Warlock'],
  );

  static Spell guidance() => Spell(
    id: 'guidance',
    name: 'Guidance',
    level: 0,
    school: 'Divination',
    castingTime: '1 action',
    range: 'Touch',
    components: ['V', 'S'],
    duration: 'Concentration, up to 1 minute',
    concentration: true,
    description: 'You touch one willing creature. Once before the spell ends, the target can roll a d4 and add the number to one ability check of its choice.',
    targetType: 'single',
    effect: 'buff',
    availableToClasses: ['Cleric', 'Druid'],
  );

  static Spell prestidigitation() => Spell(
    id: 'prestidigitation',
    name: 'Prestidigitation',
    level: 0,
    school: 'Transmutation',
    castingTime: '1 action',
    range: '10 feet',
    components: ['V', 'S'],
    duration: 'Up to 1 hour',
    concentration: false,
    description: 'This spell is a minor magical trick. You create an instantaneous, harmless sensory effect, light/snuff a candle, clean/soil an object, chill/warm material, make a mark appear, or create a trinket.',
    targetType: 'area',
    effect: 'utility',
    availableToClasses: ['Bard', 'Sorcerer', 'Warlock', 'Wizard'],
  );

  // Level 1 Spells
  static Spell magicMissile() => Spell(
    id: 'magic_missile',
    name: 'Magic Missile',
    level: 1,
    school: 'Evocation',
    castingTime: '1 action',
    range: '120 feet',
    components: ['V', 'S'],
    duration: 'Instantaneous',
    concentration: false,
    description: 'You create three glowing darts of magical force. Each dart hits a creature of your choice that you can see within range. A dart deals 1d4 + 1 force damage to its target. The darts all strike simultaneously.',
    higherLevelDescription: 'When you cast this spell using a spell slot of 2nd level or higher, the spell creates one more dart for each slot level above 1st.',
    targetType: 'multiple',
    damageType: 'force',
    damageDice: '1d4+1',
    availableToClasses: ['Wizard', 'Sorcerer'],
  );

  static Spell shield() => Spell(
    id: 'shield',
    name: 'Shield',
    level: 1,
    school: 'Abjuration',
    castingTime: '1 reaction',
    range: 'Self',
    components: ['V', 'S'],
    duration: 'Until the start of your next turn',
    concentration: false,
    description: 'An invisible barrier of magical force appears and protects you. Until the start of your next turn, you have a +5 bonus to AC, including against the triggering attack, and you take no damage from magic missile.',
    targetType: 'self',
    effect: 'buff',
    availableToClasses: ['Wizard', 'Sorcerer'],
  );

  static Spell cureWounds() => Spell(
    id: 'cure_wounds',
    name: 'Cure Wounds',
    level: 1,
    school: 'Evocation',
    castingTime: '1 action',
    range: 'Touch',
    components: ['V', 'S'],
    duration: 'Instantaneous',
    concentration: false,
    description: 'A creature you touch regains hit points equal to 1d8 + your spellcasting ability modifier.',
    higherLevelDescription: 'When you cast this spell using a spell slot of 2nd level or higher, the healing increases by 1d8 for each slot level above 1st.',
    targetType: 'single',
    damageDice: '1d8',
    effect: 'healing',
    availableToClasses: ['Bard', 'Cleric', 'Druid', 'Paladin', 'Ranger'],
  );

  static Spell burningHands() => Spell(
    id: 'burning_hands',
    name: 'Burning Hands',
    level: 1,
    school: 'Evocation',
    castingTime: '1 action',
    range: 'Self',
    components: ['V', 'S'],
    duration: 'Instantaneous',
    concentration: false,
    description: 'A thin sheet of flames shoots forth from your outstretched fingertips. Each creature in a 15-foot cone must make a Dexterity saving throw. A creature takes 3d6 fire damage on a failed save, or half as much on a successful one.',
    higherLevelDescription: 'When you cast this spell using a spell slot of 2nd level or higher, the damage increases by 1d6 for each slot level above 1st.',
    targetType: 'area',
    areaShape: 'cone',
    areaSize: 15,
    damageType: 'fire',
    damageDice: '3d6',
    savingThrow: 'Dexterity',
    availableToClasses: ['Wizard', 'Sorcerer'],
  );

  static Spell sleep() => Spell(
    id: 'sleep',
    name: 'Sleep',
    level: 1,
    school: 'Enchantment',
    castingTime: '1 action',
    range: '90 feet',
    components: ['V', 'S', 'M'],
    materialComponents: 'A pinch of fine sand, rose petals, or a cricket',
    duration: 'Concentration, up to 1 minute',
    concentration: true,
    description: 'This spell sends creatures into a magical slumber. Roll 5d8; the total is how many hit points of creatures this spell can affect. Creatures within 20 feet of a point you choose are affected in ascending order of their current hit points. Subtract each creature\'s hit points from the total before moving on to the next.',
    targetType: 'area',
    areaShape: 'sphere',
    areaSize: 20,
    effect: 'control',
    conditions: ['unconscious'],
    savingThrow: 'None',
    availableToClasses: ['Bard', 'Sorcerer', 'Wizard'],
  );

  // Level 2 Spells
  static Spell scorchingRay() => Spell(
    id: 'scorching_ray',
    name: 'Scorching Ray',
    level: 2,
    school: 'Evocation',
    castingTime: '1 action',
    range: '120 feet',
    components: ['V', 'S'],
    duration: 'Instantaneous',
    concentration: false,
    description: 'You create three rays of fire and hurl them at targets within range. Make a ranged spell attack for each ray. On a hit, the target takes 2d6 fire damage.',
    higherLevelDescription: 'When you cast this spell using a spell slot of 3rd level or higher, you create one additional ray for each slot level above 2nd.',
    targetType: 'multiple',
    damageType: 'fire',
    damageDice: '2d6',
    availableToClasses: ['Wizard', 'Sorcerer'],
  );

  static Spell holdPerson() => Spell(
    id: 'hold_person',
    name: 'Hold Person',
    level: 2,
    school: 'Enchantment',
    castingTime: '1 action',
    range: '60 feet',
    components: ['V', 'S', 'M'],
    materialComponents: 'A small, straight piece of iron',
    duration: 'Concentration, up to 1 minute',
    concentration: true,
    description: 'Choose a humanoid that you can see within range. The target must succeed on a Wisdom saving throw or be paralyzed for the duration. At the end of each of its turns, the target can make another Wisdom saving throw. On a success, the spell ends.',
    higherLevelDescription: 'When you cast this spell using a spell slot of 3rd level or higher, you can target one additional humanoid for each slot level above 2nd.',
    targetType: 'single',
    effect: 'control',
    conditions: ['paralyzed'],
    savingThrow: 'Wisdom',
    availableToClasses: ['Bard', 'Cleric', 'Druid', 'Sorcerer', 'Warlock', 'Wizard'],
  );

  static Spell spiritualWeapon() => Spell(
    id: 'spiritual_weapon',
    name: 'Spiritual Weapon',
    level: 2,
    school: 'Evocation',
    castingTime: '1 bonus action',
    range: '60 feet',
    components: ['V', 'S'],
    duration: 'Concentration, up to 1 minute',
    concentration: true,
    description: 'You create a floating spectral weapon that lasts for the duration. When you cast the spell, you can make a melee spell attack against a creature within 5 feet of the weapon. On a hit, the target takes force damage equal to 1d8 + your spellcasting modifier. As a bonus action on your turn, you can move the weapon and repeat the attack.',
    higherLevelDescription: 'When you cast this spell using a spell slot of 3rd level or higher, the damage increases by 1d8 for every two slot levels above 2nd.',
    targetType: 'single',
    damageType: 'force',
    damageDice: '1d8',
    availableToClasses: ['Cleric'],
  );

  // Level 3 Spells
  static Spell fireball() => Spell(
    id: 'fireball',
    name: 'Fireball',
    level: 3,
    school: 'Evocation',
    castingTime: '1 action',
    range: '150 feet',
    components: ['V', 'S', 'M'],
    materialComponents: 'A tiny ball of bat guano and sulfur',
    duration: 'Instantaneous',
    concentration: false,
    description: 'A bright streak flashes from your pointing finger to a point you choose within range and then blossoms with a low roar into an explosion of flame. Each creature in a 20-foot radius sphere must make a Dexterity saving throw. A target takes 8d6 fire damage on a failed save, or half as much on a successful one.',
    higherLevelDescription: 'When you cast this spell using a spell slot of 4th level or higher, the damage increases by 1d6 for each slot level above 3rd.',
    targetType: 'area',
    areaShape: 'sphere',
    areaSize: 20,
    damageType: 'fire',
    damageDice: '8d6',
    savingThrow: 'Dexterity',
    availableToClasses: ['Wizard', 'Sorcerer'],
  );

  static Spell lightningBolt() => Spell(
    id: 'lightning_bolt',
    name: 'Lightning Bolt',
    level: 3,
    school: 'Evocation',
    castingTime: '1 action',
    range: 'Self (100-foot line)',
    components: ['V', 'S', 'M'],
    materialComponents: 'A bit of fur and a rod of amber, crystal, or glass',
    duration: 'Instantaneous',
    concentration: false,
    description: 'A stroke of lightning forming a line 100 feet long and 5 feet wide blasts out from you. Each creature in the line must make a Dexterity saving throw. A creature takes 8d6 lightning damage on a failed save, or half as much on a successful one.',
    higherLevelDescription: 'When you cast this spell using a spell slot of 4th level or higher, the damage increases by 1d6 for each slot level above 3rd.',
    targetType: 'area',
    areaShape: 'line',
    areaSize: 100,
    damageType: 'lightning',
    damageDice: '8d6',
    savingThrow: 'Dexterity',
    availableToClasses: ['Wizard', 'Sorcerer'],
  );

  static Spell counterspell() => Spell(
    id: 'counterspell',
    name: 'Counterspell',
    level: 3,
    school: 'Abjuration',
    castingTime: '1 reaction',
    range: '60 feet',
    components: ['S'],
    duration: 'Instantaneous',
    concentration: false,
    description: 'You attempt to interrupt a creature in the process of casting a spell. If the creature is casting a spell of 3rd level or lower, its spell fails. If it is casting a spell of 4th level or higher, make an ability check using your spellcasting ability. The DC equals 10 + the spell\'s level. On a success, the creature\'s spell fails.',
    higherLevelDescription: 'When you cast this spell using a spell slot of 4th level or higher, the interrupted spell has no effect if its level is less than or equal to the level of the spell slot you used.',
    targetType: 'single',
    effect: 'utility',
    availableToClasses: ['Sorcerer', 'Warlock', 'Wizard'],
  );

  static Spell haste() => Spell(
    id: 'haste',
    name: 'Haste',
    level: 3,
    school: 'Transmutation',
    castingTime: '1 action',
    range: '30 feet',
    components: ['V', 'S', 'M'],
    materialComponents: 'A shaving of licorice root',
    duration: 'Concentration, up to 1 minute',
    concentration: true,
    description: 'Choose a willing creature. Until the spell ends, the target\'s speed is doubled, it gains a +2 bonus to AC, it has advantage on Dexterity saving throws, and it gains an additional action on each of its turns (limited to Attack, Dash, Disengage, Hide, or Use an Object). When the spell ends, the target can\'t move or take actions until after its next turn.',
    targetType: 'single',
    effect: 'buff',
    availableToClasses: ['Sorcerer', 'Wizard'],
  );

  // Level 4 Spells
  static Spell polymorph() => Spell(
    id: 'polymorph',
    name: 'Polymorph',
    level: 4,
    school: 'Transmutation',
    castingTime: '1 action',
    range: '60 feet',
    components: ['V', 'S', 'M'],
    materialComponents: 'A caterpillar cocoon',
    duration: 'Concentration, up to 1 hour',
    concentration: true,
    description: 'This spell transforms a creature into a beast with a CR as high as the target\'s level. The target\'s game statistics are replaced by the beast\'s. When it drops to 0 hit points, it reverts to its normal form. The creature is limited in actions it can perform and can\'t cast spells.',
    targetType: 'single',
    effect: 'control',
    savingThrow: 'Wisdom',
    availableToClasses: ['Bard', 'Druid', 'Sorcerer', 'Wizard'],
  );

  static Spell wallOfFire() => Spell(
    id: 'wall_of_fire',
    name: 'Wall of Fire',
    level: 4,
    school: 'Evocation',
    castingTime: '1 action',
    range: '120 feet',
    components: ['V', 'S', 'M'],
    materialComponents: 'A small piece of phosphorus',
    duration: 'Concentration, up to 1 minute',
    concentration: true,
    description: 'You create a wall of fire on a solid surface. The wall is opaque and lasts for the duration. One side deals 5d8 fire damage to creatures within 10 feet. Creatures that enter the wall or start their turn there take 5d8 fire damage.',
    higherLevelDescription: 'When you cast this spell using a spell slot of 5th level or higher, the damage increases by 1d8 for each slot level above 4th.',
    targetType: 'area',
    areaShape: 'line',
    areaSize: 60,
    damageType: 'fire',
    damageDice: '5d8',
    savingThrow: 'Dexterity',
    availableToClasses: ['Druid', 'Sorcerer', 'Wizard'],
  );

  // Level 5 Spells
  static Spell coneOfCold() => Spell(
    id: 'cone_of_cold',
    name: 'Cone of Cold',
    level: 5,
    school: 'Evocation',
    castingTime: '1 action',
    range: 'Self (60-foot cone)',
    components: ['V', 'S', 'M'],
    materialComponents: 'A small crystal or glass cone',
    duration: 'Instantaneous',
    concentration: false,
    description: 'A blast of cold air erupts from your hands. Each creature in a 60-foot cone must make a Constitution saving throw. A creature takes 8d8 cold damage on a failed save, or half as much on a successful one.',
    higherLevelDescription: 'When you cast this spell using a spell slot of 6th level or higher, the damage increases by 1d8 for each slot level above 5th.',
    targetType: 'area',
    areaShape: 'cone',
    areaSize: 60,
    damageType: 'cold',
    damageDice: '8d8',
    savingThrow: 'Constitution',
    availableToClasses: ['Sorcerer', 'Wizard'],
  );

  static Spell revivify() => Spell(
    id: 'revivify',
    name: 'Revivify',
    level: 3,
    school: 'Necromancy',
    castingTime: '1 action',
    range: 'Touch',
    components: ['V', 'S', 'M'],
    materialComponents: 'Diamonds worth 300 gp, which the spell consumes',
    duration: 'Instantaneous',
    concentration: false,
    description: 'You touch a creature that has died within the last minute. That creature returns to life with 1 hit point. This spell can\'t return to life a creature that has died of old age, nor can it restore any missing body parts.',
    targetType: 'single',
    effect: 'healing',
    availableToClasses: ['Cleric', 'Paladin'],
  );

  static List<Spell> getAllCantrips() {
    return [
      fireBolt(),
      rayOfFrost(),
      sacredFlame(),
      eldritchBlast(),
      guidance(),
      prestidigitation(),
    ];
  }

  static List<Spell> getLevel1Spells() {
    return [
      magicMissile(),
      shield(),
      cureWounds(),
      burningHands(),
      sleep(),
    ];
  }

  static List<Spell> getLevel2Spells() {
    return [
      scorchingRay(),
      holdPerson(),
      spiritualWeapon(),
    ];
  }

  static List<Spell> getLevel3Spells() {
    return [
      fireball(),
      lightningBolt(),
      counterspell(),
      haste(),
      revivify(),
    ];
  }

  static List<Spell> getLevel4Spells() {
    return [
      polymorph(),
      wallOfFire(),
    ];
  }

  static List<Spell> getLevel5Spells() {
    return [
      coneOfCold(),
    ];
  }

  static List<Spell> getAllSpells() {
    return [
      ...getAllCantrips(),
      ...getLevel1Spells(),
      ...getLevel2Spells(),
      ...getLevel3Spells(),
      ...getLevel4Spells(),
      ...getLevel5Spells(),
    ];
  }

  static List<Spell> getSpellsForClass(String className, int maxLevel) {
    return getAllSpells()
        .where((spell) =>
            spell.availableToClasses.contains(className) &&
            spell.level <= maxLevel)
        .toList();
  }

  static List<Spell> getCantripsForClass(String className) {
    return getAllCantrips()
        .where((spell) => spell.availableToClasses.contains(className))
        .toList();
  }

  static Spell? getSpellById(String id) {
    try {
      return getAllSpells().firstWhere((spell) => spell.id == id);
    } catch (e) {
      return null;
    }
  }
}
