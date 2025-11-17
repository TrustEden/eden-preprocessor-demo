import '../models/spell.dart';

/// Comprehensive D&D 5e Spell Database - 100+ Spells
class ExpandedSpellDatabase {
  // ==================== CANTRIPS (LEVEL 0) ====================

  static Spell acidSplash() => Spell(
    id: 'acid_splash', name: 'Acid Splash', level: 0, school: 'Conjuration',
    castingTime: '1 action', range: '60 feet', components: ['V', 'S'],
    duration: 'Instantaneous', concentration: false,
    description: 'You hurl a bubble of acid. Choose one or two creatures within range. Each must succeed on a Dexterity saving throw or take 1d6 acid damage.',
    targetType: 'multiple', damageType: 'acid', damageDice: '1d6', savingThrow: 'Dexterity',
    availableToClasses: ['Sorcerer', 'Wizard'],
  );

  static Spell bladeWard() => Spell(
    id: 'blade_ward', name: 'Blade Ward', level: 0, school: 'Abjuration',
    castingTime: '1 action', range: 'Self', components: ['V', 'S'],
    duration: '1 round', concentration: false,
    description: 'You have resistance to bludgeoning, piercing, and slashing damage until the end of your next turn.',
    targetType: 'self', effect: 'buff',
    availableToClasses: ['Bard', 'Sorcerer', 'Warlock', 'Wizard'],
  );

  static Spell chillingTouch() => Spell(
    id: 'chilling_touch', name: 'Chilling Touch', level: 0, school: 'Necromancy',
    castingTime: '1 action', range: '120 feet', components: ['V', 'S'],
    duration: '1 round', concentration: false,
    description: 'Make a ranged spell attack. On hit, target takes 1d8 necrotic damage and can\'t regain HP until your next turn. Undead have disadvantage on attacks against you.',
    targetType: 'single', damageType: 'necrotic', damageDice: '1d8',
    availableToClasses: ['Sorcerer', 'Warlock', 'Wizard'],
  );

  static Spell dancingLights() => Spell(
    id: 'dancing_lights', name: 'Dancing Lights', level: 0, school: 'Evocation',
    castingTime: '1 action', range: '120 feet', components: ['V', 'S', 'M'],
    materialComponents: 'A bit of phosphorus or wychwood',
    duration: 'Concentration, up to 1 minute', concentration: true,
    description: 'You create up to four torch-sized lights that hover and shed dim light in a 10-foot radius.',
    targetType: 'area', effect: 'utility',
    availableToClasses: ['Bard', 'Sorcerer', 'Wizard'],
  );

  static Spell light() => Spell(
    id: 'light', name: 'Light', level: 0, school: 'Evocation',
    castingTime: '1 action', range: 'Touch', components: ['V', 'M'],
    materialComponents: 'A firefly or phosphorescent moss',
    duration: '1 hour', concentration: false,
    description: 'You touch one object no larger than 10 feet. It sheds bright light in a 20-foot radius and dim light for an additional 20 feet.',
    targetType: 'single', effect: 'utility',
    availableToClasses: ['Bard', 'Cleric', 'Sorcerer', 'Wizard'],
  );

  static Spell mageHand() => Spell(
    id: 'mage_hand', name: 'Mage Hand', level: 0, school: 'Conjuration',
    castingTime: '1 action', range: '30 feet', components: ['V', 'S'],
    duration: '1 minute', concentration: false,
    description: 'A spectral hand appears. You can use it to manipulate objects, open doors, retrieve items. It can\'t attack or activate magic items.',
    targetType: 'area', effect: 'utility',
    availableToClasses: ['Bard', 'Sorcerer', 'Warlock', 'Wizard'],
  );

  static Spell mendingCantrip() => Spell(
    id: 'mending', name: 'Mending', level: 0, school: 'Transmutation',
    castingTime: '1 minute', range: 'Touch', components: ['V', 'S', 'M'],
    materialComponents: 'Two lodestones',
    duration: 'Instantaneous', concentration: false,
    description: 'This spell repairs a single break or tear in an object. It can\'t restore magic to an item.',
    targetType: 'single', effect: 'utility',
    availableToClasses: ['Bard', 'Cleric', 'Druid', 'Sorcerer', 'Wizard'],
  );

  static Spell message() => Spell(
    id: 'message', name: 'Message', level: 0, school: 'Transmutation',
    castingTime: '1 action', range: '120 feet', components: ['V', 'S', 'M'],
    materialComponents: 'A short piece of copper wire',
    duration: '1 round', concentration: false,
    description: 'You point toward a creature and whisper a message. The target hears it and can reply in a whisper only you hear.',
    targetType: 'single', effect: 'utility',
    availableToClasses: ['Bard', 'Sorcerer', 'Wizard'],
  );

  static Spell minorIllusion() => Spell(
    id: 'minor_illusion', name: 'Minor Illusion', level: 0, school: 'Illusion',
    castingTime: '1 action', range: '30 feet', components: ['S', 'M'],
    materialComponents: 'A bit of fleece',
    duration: '1 minute', concentration: false,
    description: 'You create a sound or an image of an object (no larger than 5-foot cube). Physical inspection reveals it as an illusion.',
    targetType: 'area', effect: 'utility',
    availableToClasses: ['Bard', 'Sorcerer', 'Warlock', 'Wizard'],
  );

  static Spell poisonSpray() => Spell(
    id: 'poison_spray', name: 'Poison Spray', level: 0, school: 'Conjuration',
    castingTime: '1 action', range: '10 feet', components: ['V', 'S'],
    duration: 'Instantaneous', concentration: false,
    description: 'You extend your hand toward a creature and spray toxic gas. Make a Constitution save or take 1d12 poison damage.',
    targetType: 'single', damageType: 'poison', damageDice: '1d12', savingThrow: 'Constitution',
    availableToClasses: ['Druid', 'Sorcerer', 'Warlock', 'Wizard'],
  );

  static Spell produceFlame() => Spell(
    id: 'produce_flame', name: 'Produce Flame', level: 0, school: 'Conjuration',
    castingTime: '1 action', range: 'Self', components: ['V', 'S'],
    duration: '10 minutes', concentration: false,
    description: 'A flame appears in your hand, shedding bright light. You can hurl it up to 30 feet as a ranged spell attack, dealing 1d8 fire damage.',
    targetType: 'single', damageType: 'fire', damageDice: '1d8',
    availableToClasses: ['Druid'],
  );

  static Spell shillelagh() => Spell(
    id: 'shillelagh', name: 'Shillelagh', level: 0, school: 'Transmutation',
    castingTime: '1 bonus action', range: 'Touch', components: ['V', 'S', 'M'],
    materialComponents: 'Mistletoe and a shamrock leaf',
    duration: '1 minute', concentration: false,
    description: 'Your club or quarterstaff becomes magical. Use your spellcasting ability for attack/damage. Damage becomes 1d8.',
    targetType: 'self', effect: 'buff',
    availableToClasses: ['Druid'],
  );

  static Spell shockingGrasp() => Spell(
    id: 'shocking_grasp', name: 'Shocking Grasp', level: 0, school: 'Evocation',
    castingTime: '1 action', range: 'Touch', components: ['V', 'S'],
    duration: 'Instantaneous', concentration: false,
    description: 'Lightning springs from your hand. Make a melee spell attack for 1d8 lightning damage. Target can\'t take reactions until its next turn.',
    targetType: 'single', damageType: 'lightning', damageDice: '1d8',
    availableToClasses: ['Sorcerer', 'Wizard'],
  );

  static Spell spareTheDying() => Spell(
    id: 'spare_the_dying', name: 'Spare the Dying', level: 0, school: 'Necromancy',
    castingTime: '1 action', range: 'Touch', components: ['V', 'S'],
    duration: 'Instantaneous', concentration: false,
    description: 'You touch a living creature at 0 HP. It becomes stable.',
    targetType: 'single', effect: 'healing',
    availableToClasses: ['Cleric'],
  );

  static Spell thaumaturgy() => Spell(
    id: 'thaumaturgy', name: 'Thaumaturgy', level: 0, school: 'Transmutation',
    castingTime: '1 action', range: '30 feet', components: ['V'],
    duration: '1 minute', concentration: false,
    description: 'You manifest a minor wonder: trembling ground, booming voice, flickering flames, unlocked doors, blown open windows, or altered eyes.',
    targetType: 'area', effect: 'utility',
    availableToClasses: ['Cleric'],
  );

  static Spell thornWhip() => Spell(
    id: 'thorn_whip', name: 'Thorn Whip', level: 0, school: 'Transmutation',
    castingTime: '1 action', range: '30 feet', components: ['V', 'S', 'M'],
    materialComponents: 'The stem of a plant with thorns',
    duration: 'Instantaneous', concentration: false,
    description: 'You create a whip of thorns. Make a melee spell attack for 1d6 piercing damage and pull target 10 feet closer.',
    targetType: 'single', damageType: 'piercing', damageDice: '1d6',
    availableToClasses: ['Druid'],
  );

  static Spell trueStrike() => Spell(
    id: 'true_strike', name: 'True Strike', level: 0, school: 'Divination',
    castingTime: '1 action', range: '30 feet', components: ['S'],
    duration: 'Concentration, up to 1 round', concentration: true,
    description: 'You have advantage on your next attack roll against the target.',
    targetType: 'single', effect: 'buff',
    availableToClasses: ['Bard', 'Sorcerer', 'Warlock', 'Wizard'],
  );

  static Spell viciousMockery() => Spell(
    id: 'vicious_mockery', name: 'Vicious Mockery', level: 0, school: 'Enchantment',
    castingTime: '1 action', range: '60 feet', components: ['V'],
    duration: 'Instantaneous', concentration: false,
    description: 'You unleash a string of insults. Target makes Wisdom save or takes 1d4 psychic damage and has disadvantage on next attack.',
    targetType: 'single', damageType: 'psychic', damageDice: '1d4', savingThrow: 'Wisdom',
    availableToClasses: ['Bard'],
  );

  // ==================== LEVEL 1 SPELLS ====================

  static Spell alarm() => Spell(
    id: 'alarm', name: 'Alarm', level: 1, school: 'Abjuration',
    castingTime: '1 minute', range: '30 feet', components: ['V', 'S', 'M'],
    materialComponents: 'A tiny bell and silver wire',
    duration: '8 hours', concentration: false, ritual: true,
    description: 'You set an alarm against intrusion in a 20-foot cube. When triggered, it produces a mental or audible alarm.',
    targetType: 'area', effect: 'utility',
    availableToClasses: ['Ranger', 'Wizard'],
  );

  static Spell bane() => Spell(
    id: 'bane', name: 'Bane', level: 1, school: 'Enchantment',
    castingTime: '1 action', range: '30 feet', components: ['V', 'S', 'M'],
    materialComponents: 'A drop of blood',
    duration: 'Concentration, up to 1 minute', concentration: true,
    description: 'Up to 3 creatures must make Charisma saves. On fail, subtract 1d4 from attack rolls and saving throws.',
    targetType: 'multiple', effect: 'debuff', savingThrow: 'Charisma',
    availableToClasses: ['Bard', 'Cleric'],
  );

  static Spell bless() => Spell(
    id: 'bless', name: 'Bless', level: 1, school: 'Enchantment',
    castingTime: '1 action', range: '30 feet', components: ['V', 'S', 'M'],
    materialComponents: 'Sprinkle of holy water',
    duration: 'Concentration, up to 1 minute', concentration: true,
    description: 'Up to 3 creatures add 1d4 to attack rolls and saving throws.',
    targetType: 'multiple', effect: 'buff',
    availableToClasses: ['Cleric', 'Paladin'],
  );

  static Spell charmPerson() => Spell(
    id: 'charm_person', name: 'Charm Person', level: 1, school: 'Enchantment',
    castingTime: '1 action', range: '30 feet', components: ['V', 'S'],
    duration: '1 hour', concentration: false,
    description: 'Target makes Wisdom save or is charmed by you. When spell ends, it knows it was charmed.',
    targetType: 'single', effect: 'control', savingThrow: 'Wisdom', conditions: ['charmed'],
    availableToClasses: ['Bard', 'Druid', 'Sorcerer', 'Warlock', 'Wizard'],
  );

  static Spell command() => Spell(
    id: 'command', name: 'Command', level: 1, school: 'Enchantment',
    castingTime: '1 action', range: '60 feet', components: ['V'],
    duration: 'Instantaneous', concentration: false,
    description: 'Target makes Wisdom save or follows a one-word command on its next turn (approach, drop, flee, grovel, halt).',
    targetType: 'single', effect: 'control', savingThrow: 'Wisdom',
    availableToClasses: ['Cleric', 'Paladin'],
  );

  static Spell comprehendLanguages() => Spell(
    id: 'comprehend_languages', name: 'Comprehend Languages', level: 1, school: 'Divination',
    castingTime: '1 action', range: 'Self', components: ['V', 'S', 'M'],
    materialComponents: 'A pinch of soot and salt',
    duration: '1 hour', concentration: false, ritual: true,
    description: 'You understand literal meaning of any spoken or written language.',
    targetType: 'self', effect: 'utility',
    availableToClasses: ['Bard', 'Sorcerer', 'Warlock', 'Wizard'],
  );

  static Spell createOrDestroyWater() => Spell(
    id: 'create_or_destroy_water', name: 'Create or Destroy Water', level: 1, school: 'Transmutation',
    castingTime: '1 action', range: '30 feet', components: ['V', 'S', 'M'],
    materialComponents: 'A drop of water for creating or sand for destroying',
    duration: 'Instantaneous', concentration: false,
    description: 'Create up to 10 gallons of water in an open container, or destroy same amount in area.',
    targetType: 'area', effect: 'utility',
    availableToClasses: ['Cleric', 'Druid'],
  );

  static Spell detectMagic() => Spell(
    id: 'detect_magic', name: 'Detect Magic', level: 1, school: 'Divination',
    castingTime: '1 action', range: 'Self', components: ['V', 'S'],
    duration: 'Concentration, up to 10 minutes', concentration: true, ritual: true,
    description: 'Sense presence of magic within 30 feet. You learn its school if you see it.',
    targetType: 'self', effect: 'utility',
    availableToClasses: ['Bard', 'Cleric', 'Druid', 'Paladin', 'Ranger', 'Sorcerer', 'Wizard'],
  );

  static Spell disguiseSelf() => Spell(
    id: 'disguise_self', name: 'Disguise Self', level: 1, school: 'Illusion',
    castingTime: '1 action', range: 'Self', components: ['V', 'S'],
    duration: '1 hour', concentration: false,
    description: 'You make yourself look different. Physical inspection reveals the disguise.',
    targetType: 'self', effect: 'utility',
    availableToClasses: ['Bard', 'Sorcerer', 'Wizard'],
  );

  static Spell divineFavor() => Spell(
    id: 'divine_favor', name: 'Divine Favor', level: 1, school: 'Evocation',
    castingTime: '1 bonus action', range: 'Self', components: ['V', 'S'],
    duration: 'Concentration, up to 1 minute', concentration: true,
    description: 'Your weapon strikes shimmer with divine energy. Add 1d4 radiant damage to each attack.',
    targetType: 'self', effect: 'buff',
    availableToClasses: ['Paladin'],
  );

  static Spell entangle() => Spell(
    id: 'entangle', name: 'Entangle', level: 1, school: 'Conjuration',
    castingTime: '1 action', range: '90 feet', components: ['V', 'S'],
    duration: 'Concentration, up to 1 minute', concentration: true,
    description: 'Grasping weeds sprout in a 20-foot square. Creatures make Strength save or are restrained. Difficult terrain.',
    targetType: 'area', areaShape: 'cube', areaSize: 20, effect: 'control',
    savingThrow: 'Strength', conditions: ['restrained'],
    availableToClasses: ['Druid'],
  );

  static Spell faerieFire() => Spell(
    id: 'faerie_fire', name: 'Faerie Fire', level: 1, school: 'Evocation',
    castingTime: '1 action', range: '60 feet', components: ['V'],
    duration: 'Concentration, up to 1 minute', concentration: true,
    description: 'Objects and creatures in a 20-foot cube glow. Attack rolls against them have advantage.',
    targetType: 'area', areaShape: 'cube', areaSize: 20, effect: 'debuff', savingThrow: 'Dexterity',
    availableToClasses: ['Bard', 'Druid'],
  );

  static Spell falseLife() => Spell(
    id: 'false_life', name: 'False Life', level: 1, school: 'Necromancy',
    castingTime: '1 action', range: 'Self', components: ['V', 'S', 'M'],
    materialComponents: 'A small amount of alcohol or distilled spirits',
    duration: '1 hour', concentration: false,
    description: 'You gain 1d4 + 4 temporary hit points.',
    targetType: 'self', effect: 'buff',
    availableToClasses: ['Sorcerer', 'Wizard'],
  );

  static Spell featherFall() => Spell(
    id: 'feather_fall', name: 'Feather Fall', level: 1, school: 'Transmutation',
    castingTime: '1 reaction', range: '60 feet', components: ['V', 'M'],
    materialComponents: 'A small feather or piece of down',
    duration: '1 minute', concentration: false,
    description: 'Choose up to 5 falling creatures. Their rate of descent slows to 60 feet/round. They take no falling damage.',
    targetType: 'multiple', effect: 'utility',
    availableToClasses: ['Bard', 'Sorcerer', 'Wizard'],
  );

  static Spell findFamiliar() => Spell(
    id: 'find_familiar', name: 'Find Familiar', level: 1, school: 'Conjuration',
    castingTime: '1 hour', range: '10 feet', components: ['V', 'S', 'M'],
    materialComponents: '10 gp worth of charcoal, incense, and herbs (consumed)',
    duration: 'Instantaneous', concentration: false, ritual: true,
    description: 'You gain the service of a familiar, a spirit that takes animal form. It acts independently but obeys your commands.',
    targetType: 'self', effect: 'utility',
    availableToClasses: ['Wizard'],
  );

  static Spell fogCloud() => Spell(
    id: 'fog_cloud', name: 'Fog Cloud', level: 1, school: 'Conjuration',
    castingTime: '1 action', range: '120 feet', components: ['V', 'S'],
    duration: 'Concentration, up to 1 hour', concentration: true,
    description: 'You create a 20-foot-radius sphere of fog. The area is heavily obscured.',
    targetType: 'area', areaShape: 'sphere', areaSize: 20, effect: 'utility',
    availableToClasses: ['Druid', 'Ranger', 'Sorcerer', 'Wizard'],
  );

  static Spell grease() => Spell(
    id: 'grease', name: 'Grease', level: 1, school: 'Conjuration',
    castingTime: '1 action', range: '60 feet', components: ['V', 'S', 'M'],
    materialComponents: 'Butter or pork fat',
    duration: 'Concentration, up to 1 minute', concentration: true,
    description: 'Slick grease covers a 10-foot square. Creatures must make Dexterity save or fall prone. Standing requires a save.',
    targetType: 'area', areaShape: 'cube', areaSize: 10, effect: 'control',
    savingThrow: 'Dexterity', conditions: ['prone'],
    availableToClasses: ['Wizard'],
  );

  static Spell guidingBolt() => Spell(
    id: 'guiding_bolt', name: 'Guiding Bolt', level: 1, school: 'Evocation',
    castingTime: '1 action', range: '120 feet', components: ['V', 'S'],
    duration: 'Instantaneous', concentration: false,
    description: 'Make a ranged spell attack. On hit, deal 4d6 radiant damage. Next attack has advantage.',
    higherLevelDescription: '+1d6 per level above 1st.',
    targetType: 'single', damageType: 'radiant', damageDice: '4d6',
    availableToClasses: ['Cleric'],
  );

  static Spell healingWord() => Spell(
    id: 'healing_word', name: 'Healing Word', level: 1, school: 'Evocation',
    castingTime: '1 bonus action', range: '60 feet', components: ['V'],
    duration: 'Instantaneous', concentration: false,
    description: 'Creature regains 1d4 + spellcasting modifier HP.',
    higherLevelDescription: '+1d4 per level above 1st.',
    targetType: 'single', damageDice: '1d4', effect: 'healing',
    availableToClasses: ['Bard', 'Cleric', 'Druid'],
  );

  static Spell heroism() => Spell(
    id: 'heroism', name: 'Heroism', level: 1, school: 'Enchantment',
    castingTime: '1 action', range: 'Touch', components: ['V', 'S'],
    duration: 'Concentration, up to 1 minute', concentration: true,
    description: 'Willing creature is immune to being frightened and gains temp HP equal to spellcasting mod each turn.',
    targetType: 'single', effect: 'buff',
    availableToClasses: ['Bard', 'Paladin'],
  );

  static Spell hex() => Spell(
    id: 'hex', name: 'Hex', level: 1, school: 'Enchantment',
    castingTime: '1 bonus action', range: '90 feet', components: ['V', 'S', 'M'],
    materialComponents: 'The petrified eye of a newt',
    duration: 'Concentration, up to 1 hour', concentration: true,
    description: 'Target takes extra 1d6 necrotic damage from your attacks. Choose ability—target has disadvantage on checks with it.',
    targetType: 'single', damageType: 'necrotic', damageDice: '1d6', effect: 'debuff',
    availableToClasses: ['Warlock'],
  );

  static Spell huntersMark() => Spell(
    id: 'hunters_mark', name: 'Hunter\'s Mark', level: 1, school: 'Divination',
    castingTime: '1 bonus action', range: '90 feet', components: ['V'],
    duration: 'Concentration, up to 1 hour', concentration: true,
    description: 'When you hit target with weapon attack, deal extra 1d6 damage. Advantage on Perception and Survival checks to find it.',
    targetType: 'single', damageDice: '1d6', effect: 'buff',
    availableToClasses: ['Ranger'],
  );

  static Spell identify() => Spell(
    id: 'identify', name: 'Identify', level: 1, school: 'Divination',
    castingTime: '1 minute', range: 'Touch', components: ['V', 'S', 'M'],
    materialComponents: 'A pearl worth at least 100 gp and an owl feather',
    duration: 'Instantaneous', concentration: false, ritual: true,
    description: 'You learn properties of a magic item or spell affecting an object.',
    targetType: 'single', effect: 'utility',
    availableToClasses: ['Bard', 'Wizard'],
  );

  static Spell jump() => Spell(
    id: 'jump', name: 'Jump', level: 1, school: 'Transmutation',
    castingTime: '1 action', range: 'Touch', components: ['V', 'S', 'M'],
    materialComponents: 'A grasshopper\'s hind leg',
    duration: '1 minute', concentration: false,
    description: 'Touch a creature. Its jump distance is tripled.',
    targetType: 'single', effect: 'buff',
    availableToClasses: ['Druid', 'Ranger', 'Sorcerer', 'Wizard'],
  );

  static Spell longstrider() => Spell(
    id: 'longstrider', name: 'Longstrider', level: 1, school: 'Transmutation',
    castingTime: '1 action', range: 'Touch', components: ['V', 'S', 'M'],
    materialComponents: 'A pinch of dirt',
    duration: '1 hour', concentration: false,
    description: 'Touch a creature. Its speed increases by 10 feet.',
    targetType: 'single', effect: 'buff',
    availableToClasses: ['Bard', 'Druid', 'Ranger', 'Wizard'],
  );

  static Spell mageArmor() => Spell(
    id: 'mage_armor', name: 'Mage Armor', level: 1, school: 'Abjuration',
    castingTime: '1 action', range: 'Touch', components: ['V', 'S', 'M'],
    materialComponents: 'A piece of cured leather',
    duration: '8 hours', concentration: false,
    description: 'Touch a willing unarmored creature. Its AC becomes 13 + Dexterity modifier.',
    targetType: 'single', effect: 'buff',
    availableToClasses: ['Sorcerer', 'Wizard'],
  );

  static Spell protectionFromEvilAndGood() => Spell(
    id: 'protection_from_evil_and_good', name: 'Protection from Evil and Good', level: 1, school: 'Abjuration',
    castingTime: '1 action', range: 'Touch', components: ['V', 'S', 'M'],
    materialComponents: 'Holy water or powdered silver and iron',
    duration: 'Concentration, up to 10 minutes', concentration: true,
    description: 'Aberrations, celestials, elementals, fey, fiends, undead have disadvantage on attacks. Target can\'t be charmed/frightened/possessed.',
    targetType: 'single', effect: 'buff',
    availableToClasses: ['Cleric', 'Paladin', 'Warlock', 'Wizard'],
  );

  static Spell sanctuary() => Spell(
    id: 'sanctuary', name: 'Sanctuary', level: 1, school: 'Abjuration',
    castingTime: '1 bonus action', range: '30 feet', components: ['V', 'S', 'M'],
    materialComponents: 'A small silver mirror',
    duration: 'Concentration, up to 1 minute', concentration: true,
    description: 'Creatures targeting the protected must make Wisdom save or choose a new target. Ends if target attacks.',
    targetType: 'single', effect: 'buff', savingThrow: 'Wisdom',
    availableToClasses: ['Cleric'],
  );

  static Spell shieldOfFaith() => Spell(
    id: 'shield_of_faith', name: 'Shield of Faith', level: 1, school: 'Abjuration',
    castingTime: '1 bonus action', range: '60 feet', components: ['V', 'S', 'M'],
    materialComponents: 'A small parchment with holy text',
    duration: 'Concentration, up to 10 minutes', concentration: true,
    description: 'Creature gains +2 AC.',
    targetType: 'single', effect: 'buff',
    availableToClasses: ['Cleric', 'Paladin'],
  );

  static Spell silentImage() => Spell(
    id: 'silent_image', name: 'Silent Image', level: 1, school: 'Illusion',
    castingTime: '1 action', range: '60 feet', components: ['V', 'S', 'M'],
    materialComponents: 'A bit of fleece',
    duration: 'Concentration, up to 10 minutes', concentration: true,
    description: 'Create an image no larger than 15-foot cube. It moves as you direct. Physical inspection reveals it\'s an illusion.',
    targetType: 'area', effect: 'utility',
    availableToClasses: ['Bard', 'Sorcerer', 'Wizard'],
  );

  static Spell speakWithAnimals() => Spell(
    id: 'speak_with_animals', name: 'Speak with Animals', level: 1, school: 'Divination',
    castingTime: '1 action', range: 'Self', components: ['V', 'S'],
    duration: '10 minutes', concentration: false, ritual: true,
    description: 'You can comprehend and verbally communicate with beasts.',
    targetType: 'self', effect: 'utility',
    availableToClasses: ['Bard', 'Druid', 'Ranger'],
  );

  static Spell tashasHideousLaughter() => Spell(
    id: 'tashas_hideous_laughter', name: 'Tasha\'s Hideous Laughter', level: 1, school: 'Enchantment',
    castingTime: '1 action', range: '30 feet', components: ['V', 'S', 'M'],
    materialComponents: 'Tiny tarts and a feather',
    duration: 'Concentration, up to 1 minute', concentration: true,
    description: 'Target makes Wisdom save or falls prone, incapacitated with laughter. Can repeat save at end of turns or when damaged.',
    targetType: 'single', effect: 'control', savingThrow: 'Wisdom', conditions: ['prone', 'incapacitated'],
    availableToClasses: ['Bard', 'Wizard'],
  );

  static Spell thunderwave() => Spell(
    id: 'thunderwave', name: 'Thunderwave', level: 1, school: 'Evocation',
    castingTime: '1 action', range: 'Self (15-foot cube)', components: ['V', 'S'],
    duration: 'Instantaneous', concentration: false,
    description: 'Creatures in a 15-foot cube make Constitution save or take 2d8 thunder damage and pushed 10 feet. Half on success.',
    higherLevelDescription: '+1d8 per level above 1st.',
    targetType: 'area', areaShape: 'cube', areaSize: 15,
    damageType: 'thunder', damageDice: '2d8', savingThrow: 'Constitution',
    availableToClasses: ['Bard', 'Druid', 'Sorcerer', 'Wizard'],
  );

  static Spell unseenServant() => Spell(
    id: 'unseen_servant', name: 'Unseen Servant', level: 1, school: 'Conjuration',
    castingTime: '1 action', range: '60 feet', components: ['V', 'S', 'M'],
    materialComponents: 'String and a bit of wood',
    duration: '1 hour', concentration: false, ritual: true,
    description: 'Create an invisible, mindless force that performs simple tasks. AC 10, 1 HP, can\'t attack.',
    targetType: 'area', effect: 'utility',
    availableToClasses: ['Bard', 'Warlock', 'Wizard'],
  );

  static Spell witchBolt() => Spell(
    id: 'witch_bolt', name: 'Witch Bolt', level: 1, school: 'Evocation',
    castingTime: '1 action', range: '30 feet', components: ['V', 'S', 'M'],
    materialComponents: 'A twig from a tree struck by lightning',
    duration: 'Concentration, up to 1 minute', concentration: true,
    description: 'Ranged spell attack for 1d12 lightning damage. On later turns, use action to deal 1d12 automatically if in range.',
    higherLevelDescription: '+1d12 per level above 1st.',
    targetType: 'single', damageType: 'lightning', damageDice: '1d12',
    availableToClasses: ['Sorcerer', 'Warlock', 'Wizard'],
  );

  // ==================== LEVEL 2 SPELLS ====================

  static Spell aid() => Spell(
    id: 'aid', name: 'Aid', level: 2, school: 'Abjuration',
    castingTime: '1 action', range: '30 feet', components: ['V', 'S', 'M'],
    materialComponents: 'A tiny strip of white cloth',
    duration: '8 hours', concentration: false,
    description: 'Up to 3 creatures gain 5 temp HP and increase max HP by 5.',
    higherLevelDescription: '+5 HP per level above 2nd.',
    targetType: 'multiple', effect: 'buff',
    availableToClasses: ['Cleric', 'Paladin'],
  );

  static Spell alterSelf() => Spell(
    id: 'alter_self', name: 'Alter Self', level: 2, school: 'Transmutation',
    castingTime: '1 action', range: 'Self', components: ['V', 'S'],
    duration: 'Concentration, up to 1 hour', concentration: true,
    description: 'Assume different form: Aquatic Adaptation, Change Appearance, or Natural Weapons (1d6 + Str unarmed).',
    targetType: 'self', effect: 'buff',
    availableToClasses: ['Sorcerer', 'Wizard'],
  );

  static Spell arcaneLock() => Spell(
    id: 'arcane_lock', name: 'Arcane Lock', level: 2, school: 'Abjuration',
    castingTime: '1 action', range: 'Touch', components: ['V', 'S', 'M'],
    materialComponents: 'Gold dust worth 25 gp (consumed)',
    duration: 'Until dispelled', concentration: false,
    description: 'Door, window, or container is locked. Only you and designated creatures can open without DC 25 check.',
    targetType: 'single', effect: 'utility',
    availableToClasses: ['Wizard'],
  );

  static Spell barkskin() => Spell(
    id: 'barkskin', name: 'Barkskin', level: 2, school: 'Transmutation',
    castingTime: '1 action', range: 'Touch', components: ['V', 'S', 'M'],
    materialComponents: 'A handful of oak bark',
    duration: 'Concentration, up to 1 hour', concentration: true,
    description: 'Touch a creature. Its AC can\'t be less than 16.',
    targetType: 'single', effect: 'buff',
    availableToClasses: ['Druid', 'Ranger'],
  );

  static Spell blindnessDeafness() => Spell(
    id: 'blindness_deafness', name: 'Blindness/Deafness', level: 2, school: 'Necromancy',
    castingTime: '1 action', range: '30 feet', components: ['V'],
    duration: 'Concentration, up to 1 minute', concentration: true,
    description: 'Target makes Constitution save or is blinded or deafened. Can repeat save at end of each turn.',
    targetType: 'single', effect: 'debuff', savingThrow: 'Constitution', conditions: ['blinded'],
    availableToClasses: ['Bard', 'Cleric', 'Sorcerer', 'Wizard'],
  );

  static Spell blur() => Spell(
    id: 'blur', name: 'Blur', level: 2, school: 'Illusion',
    castingTime: '1 action', range: 'Self', components: ['V'],
    duration: 'Concentration, up to 1 minute', concentration: true,
    description: 'Your body becomes blurred. Attackers have disadvantage unless they have blindsight/truesight.',
    targetType: 'self', effect: 'buff',
    availableToClasses: ['Sorcerer', 'Wizard'],
  );

  static Spell calmEmotions() => Spell(
    id: 'calm_emotions', name: 'Calm Emotions', level: 2, school: 'Enchantment',
    castingTime: '1 action', range: '60 feet', components: ['V', 'S'],
    duration: 'Concentration, up to 1 minute', concentration: true,
    description: 'Humanoids in 20-foot sphere make Charisma save. Suppress charmed/frightened or make indifferent to hostiles.',
    targetType: 'area', areaShape: 'sphere', areaSize: 20, effect: 'control', savingThrow: 'Charisma',
    availableToClasses: ['Bard', 'Cleric'],
  );

  static Spell continualFlame() => Spell(
    id: 'continual_flame', name: 'Continual Flame', level: 2, school: 'Evocation',
    castingTime: '1 action', range: 'Touch', components: ['V', 'S', 'M'],
    materialComponents: 'Ruby dust worth 50 gp (consumed)',
    duration: 'Until dispelled', concentration: false,
    description: 'A flame springs from object you touch. It sheds bright light 20 feet, dim 20 more. Looks like fire but no heat.',
    targetType: 'single', effect: 'utility',
    availableToClasses: ['Cleric', 'Wizard'],
  );

  static Spell crownOfMadness() => Spell(
    id: 'crown_of_madness', name: 'Crown of Madness', level: 2, school: 'Enchantment',
    castingTime: '1 action', range: '120 feet', components: ['V', 'S'],
    duration: 'Concentration, up to 1 minute', concentration: true,
    description: 'Humanoid makes Wisdom save or is charmed. Must use action to attack creature you mentally choose. Repeat save each turn.',
    targetType: 'single', effect: 'control', savingThrow: 'Wisdom', conditions: ['charmed'],
    availableToClasses: ['Bard', 'Sorcerer', 'Warlock', 'Wizard'],
  );

  static Spell darkness() => Spell(
    id: 'darkness', name: 'Darkness', level: 2, school: 'Evocation',
    castingTime: '1 action', range: '60 feet', components: ['V', 'M'],
    materialComponents: 'Bat fur and a drop of pitch or piece of coal',
    duration: 'Concentration, up to 10 minutes', concentration: true,
    description: 'Magical darkness spreads from a point in a 15-foot radius. Darkvision can\'t see through it.',
    targetType: 'area', areaShape: 'sphere', areaSize: 15, effect: 'utility',
    availableToClasses: ['Sorcerer', 'Warlock', 'Wizard'],
  );

  static Spell darkvision() => Spell(
    id: 'darkvision', name: 'Darkvision', level: 2, school: 'Transmutation',
    castingTime: '1 action', range: 'Touch', components: ['V', 'S', 'M'],
    materialComponents: 'Either a pinch of dried carrot or an agate',
    duration: '8 hours', concentration: false,
    description: 'Willing creature gains darkvision out to 60 feet.',
    targetType: 'single', effect: 'buff',
    availableToClasses: ['Druid', 'Ranger', 'Sorcerer', 'Wizard'],
  );

  static Spell detectThoughts() => Spell(
    id: 'detect_thoughts', name: 'Detect Thoughts', level: 2, school: 'Divination',
    castingTime: '1 action', range: 'Self', components: ['V', 'S', 'M'],
    materialComponents: 'A copper piece',
    duration: 'Concentration, up to 1 minute', concentration: true,
    description: 'Read surface thoughts of creatures within 30 feet. Can probe deeper with Wisdom save.',
    targetType: 'area', effect: 'utility', savingThrow: 'Wisdom',
    availableToClasses: ['Bard', 'Sorcerer', 'Wizard'],
  );

  static Spell enhanceAbility() => Spell(
    id: 'enhance_ability', name: 'Enhance Ability', level: 2, school: 'Transmutation',
    castingTime: '1 action', range: 'Touch', components: ['V', 'S', 'M'],
    materialComponents: 'Fur or feather from a beast',
    duration: 'Concentration, up to 1 hour', concentration: true,
    description: 'Target gains advantage on ability checks of chosen type (Str, Dex, Con, Int, Wis, Cha) and other benefits.',
    targetType: 'single', effect: 'buff',
    availableToClasses: ['Bard', 'Cleric', 'Druid', 'Sorcerer'],
  );

  static Spell enlargeReduce() => Spell(
    id: 'enlarge_reduce', name: 'Enlarge/Reduce', level: 2, school: 'Transmutation',
    castingTime: '1 action', range: '30 feet', components: ['V', 'S', 'M'],
    materialComponents: 'A pinch of powdered iron',
    duration: 'Concentration, up to 1 minute', concentration: true,
    description: 'Target makes Constitution save. Enlarge: size doubles, advantage on Str checks, +1d4 damage. Reduce: opposite.',
    targetType: 'single', effect: 'buff', savingThrow: 'Constitution',
    availableToClasses: ['Sorcerer', 'Wizard'],
  );

  static Spell findTraps() => Spell(
    id: 'find_traps', name: 'Find Traps', level: 2, school: 'Divination',
    castingTime: '1 action', range: '120 feet', components: ['V', 'S'],
    duration: 'Instantaneous', concentration: false,
    description: 'You sense presence of any trap within line of sight within range.',
    targetType: 'area', effect: 'utility',
    availableToClasses: ['Cleric', 'Druid', 'Ranger'],
  );

  static Spell flameBlade() => Spell(
    id: 'flame_blade', name: 'Flame Blade', level: 2, school: 'Evocation',
    castingTime: '1 bonus action', range: 'Self', components: ['V', 'S', 'M'],
    materialComponents: 'Leaf of sumac',
    duration: 'Concentration, up to 10 minutes', concentration: true,
    description: 'Evoke fiery blade. Use action for melee spell attack within 5 feet for 3d6 fire damage. Sheds bright light 10 feet, dim 10.',
    higherLevelDescription: '+1d6 per 2 levels above 2nd.',
    targetType: 'self', damageType: 'fire', damageDice: '3d6', effect: 'buff',
    availableToClasses: ['Druid'],
  );

  static Spell flamingSphere() => Spell(
    id: 'flaming_sphere', name: 'Flaming Sphere', level: 2, school: 'Conjuration',
    castingTime: '1 action', range: '60 feet', components: ['V', 'S', 'M'],
    materialComponents: 'A bit of tallow, pinch of brimstone, and dust of powdered iron',
    duration: 'Concentration, up to 1 minute', concentration: true,
    description: '5-foot diameter sphere of fire appears. Creatures within 5 feet make Dexterity save or take 2d6 fire damage. Bonus action to move.',
    higherLevelDescription: '+1d6 per level above 2nd.',
    targetType: 'area', areaShape: 'sphere', areaSize: 5,
    damageType: 'fire', damageDice: '2d6', savingThrow: 'Dexterity',
    availableToClasses: ['Druid', 'Wizard'],
  );

  static Spell gentleRepose() => Spell(
    id: 'gentle_repose', name: 'Gentle Repose', level: 2, school: 'Necromancy',
    castingTime: '1 action', range: 'Touch', components: ['V', 'S', 'M'],
    materialComponents: 'A pinch of salt and copper piece on each eye (consumed)',
    duration: '10 days', concentration: false, ritual: true,
    description: 'Corpse can\'t become undead and extends revival time limit by 10 days.',
    targetType: 'single', effect: 'utility',
    availableToClasses: ['Cleric', 'Wizard'],
  );

  static Spell gustOfWind() => Spell(
    id: 'gust_of_wind', name: 'Gust of Wind', level: 2, school: 'Evocation',
    castingTime: '1 action', range: 'Self (60-foot line)', components: ['V', 'S', 'M'],
    materialComponents: 'A legume seed',
    duration: 'Concentration, up to 1 minute', concentration: true,
    description: '60-foot line of strong wind. Creatures make Strength save or pushed 15 feet. Difficult terrain, extinguishes flames.',
    targetType: 'area', areaShape: 'line', areaSize: 60, savingThrow: 'Strength',
    availableToClasses: ['Druid', 'Sorcerer', 'Wizard'],
  );

  static Spell heatMetal() => Spell(
    id: 'heat_metal', name: 'Heat Metal', level: 2, school: 'Transmutation',
    castingTime: '1 action', range: '60 feet', components: ['V', 'S', 'M'],
    materialComponents: 'A piece of iron and a flame',
    duration: 'Concentration, up to 1 minute', concentration: true,
    description: 'Object glows red-hot. Creature holding/wearing takes 2d8 fire damage. Bonus action to cause damage again. Disadvantage on attacks/checks.',
    higherLevelDescription: '+1d8 per level above 2nd.',
    targetType: 'single', damageType: 'fire', damageDice: '2d8',
    availableToClasses: ['Bard', 'Druid'],
  );

  static Spell invisibility() => Spell(
    id: 'invisibility', name: 'Invisibility', level: 2, school: 'Illusion',
    castingTime: '1 action', range: 'Touch', components: ['V', 'S', 'M'],
    materialComponents: 'An eyelash in gum arabic',
    duration: 'Concentration, up to 1 hour', concentration: true,
    description: 'Creature you touch becomes invisible. Anything it carries is invisible. Ends if attacks or casts a spell.',
    higherLevelDescription: 'Target 1 additional creature per level above 2nd.',
    targetType: 'single', effect: 'buff',
    availableToClasses: ['Bard', 'Sorcerer', 'Warlock', 'Wizard'],
  );

  static Spell knock() => Spell(
    id: 'knock', name: 'Knock', level: 2, school: 'Transmutation',
    castingTime: '1 action', range: '60 feet', components: ['V'],
    duration: 'Instantaneous', concentration: false,
    description: 'Object held shut by mundane or magical means opens. Arcane lock suppressed for 10 minutes. Loud knock audible 300 feet.',
    targetType: 'single', effect: 'utility',
    availableToClasses: ['Bard', 'Sorcerer', 'Wizard'],
  );

  static Spell lesserRestoration() => Spell(
    id: 'lesser_restoration', name: 'Lesser Restoration', level: 2, school: 'Abjuration',
    castingTime: '1 action', range: 'Touch', components: ['V', 'S'],
    duration: 'Instantaneous', concentration: false,
    description: 'End one disease or condition: blinded, deafened, paralyzed, or poisoned.',
    targetType: 'single', effect: 'healing',
    availableToClasses: ['Bard', 'Cleric', 'Druid', 'Paladin', 'Ranger'],
  );

  static Spell levitate() => Spell(
    id: 'levitate', name: 'Levitate', level: 2, school: 'Transmutation',
    castingTime: '1 action', range: '60 feet', components: ['V', 'S', 'M'],
    materialComponents: 'A small leather loop or piece of golden wire',
    duration: 'Concentration, up to 10 minutes', concentration: true,
    description: 'Target makes Constitution save or rises 20 feet and floats. You can move it up/down 20 feet per turn.',
    targetType: 'single', effect: 'control', savingThrow: 'Constitution',
    availableToClasses: ['Sorcerer', 'Wizard'],
  );

  static Spell locateObject() => Spell(
    id: 'locate_object', name: 'Locate Object', level: 2, school: 'Divination',
    castingTime: '1 action', range: 'Self', components: ['V', 'S', 'M'],
    materialComponents: 'A forked twig',
    duration: 'Concentration, up to 10 minutes', concentration: true,
    description: 'Sense direction to known or familiar object within 1,000 feet.',
    targetType: 'self', effect: 'utility',
    availableToClasses: ['Bard', 'Cleric', 'Druid', 'Paladin', 'Ranger', 'Wizard'],
  );

  static Spell magicWeapon() => Spell(
    id: 'magic_weapon', name: 'Magic Weapon', level: 2, school: 'Transmutation',
    castingTime: '1 bonus action', range: 'Touch', components: ['V', 'S'],
    duration: 'Concentration, up to 1 hour', concentration: true,
    description: 'Nonmagical weapon becomes +1 magic weapon.',
    higherLevelDescription: '+2 at 4th level, +3 at 6th.',
    targetType: 'single', effect: 'buff',
    availableToClasses: ['Paladin', 'Wizard'],
  );

  static Spell mirrorImage() => Spell(
    id: 'mirror_image', name: 'Mirror Image', level: 2, school: 'Illusion',
    castingTime: '1 action', range: 'Self', components: ['V', 'S'],
    duration: 'Concentration, up to 1 minute', concentration: true,
    description: 'Three duplicates appear. Attacks have 1/4 chance to hit you, rest hit duplicates. AC 10 + Dex mod, destroyed on hit.',
    targetType: 'self', effect: 'buff',
    availableToClasses: ['Sorcerer', 'Warlock', 'Wizard'],
  );

  static Spell mistyStep() => Spell(
    id: 'misty_step', name: 'Misty Step', level: 2, school: 'Conjuration',
    castingTime: '1 bonus action', range: 'Self', components: ['V'],
    duration: 'Instantaneous', concentration: false,
    description: 'Briefly surrounded by silvery mist, you teleport up to 30 feet to an unoccupied space you can see.',
    targetType: 'self', effect: 'utility',
    availableToClasses: ['Sorcerer', 'Warlock', 'Wizard'],
  );

  static Spell moonbeam() => Spell(
    id: 'moonbeam', name: 'Moonbeam', level: 2, school: 'Evocation',
    castingTime: '1 action', range: '120 feet', components: ['V', 'S', 'M'],
    materialComponents: 'Several seeds of any moonseed plant and piece of opalescent feldspar',
    duration: 'Concentration, up to 1 minute', concentration: true,
    description: 'Silvery beam shines down in 5-foot radius, 40-foot high cylinder. Constitution save or 2d10 radiant. Bonus action to move.',
    higherLevelDescription: '+1d10 per level above 2nd.',
    targetType: 'area', areaShape: 'cylinder', areaSize: 5,
    damageType: 'radiant', damageDice: '2d10', savingThrow: 'Constitution',
    availableToClasses: ['Druid'],
  );

  static Spell passWithoutTrace() => Spell(
    id: 'pass_without_trace', name: 'Pass without Trace', level: 2, school: 'Abjuration',
    castingTime: '1 action', range: 'Self', components: ['V', 'S', 'M'],
    materialComponents: 'Ashes from burned leaf of mistletoe and sprig of spruce',
    duration: 'Concentration, up to 1 hour', concentration: true,
    description: 'You and creatures within 30 feet gain +10 to Stealth and can\'t be tracked except by magic.',
    targetType: 'area', effect: 'buff',
    availableToClasses: ['Druid', 'Ranger'],
  );

  static Spell prayerOfHealing() => Spell(
    id: 'prayer_of_healing', name: 'Prayer of Healing', level: 2, school: 'Evocation',
    castingTime: '10 minutes', range: '30 feet', components: ['V'],
    duration: 'Instantaneous', concentration: false,
    description: 'Up to 6 creatures regain 2d8 + spellcasting modifier HP.',
    higherLevelDescription: '+1d8 per level above 2nd.',
    targetType: 'multiple', damageDice: '2d8', effect: 'healing',
    availableToClasses: ['Cleric'],
  );

  static Spell rayOfEnfeeblement() => Spell(
    id: 'ray_of_enfeeblement', name: 'Ray of Enfeeblement', level: 2, school: 'Necromancy',
    castingTime: '1 action', range: '60 feet', components: ['V', 'S'],
    duration: 'Concentration, up to 1 minute', concentration: true,
    description: 'Ranged spell attack. On hit, target deals half damage with Strength-based attacks. Constitution save each turn to end.',
    targetType: 'single', effect: 'debuff', savingThrow: 'Constitution',
    availableToClasses: ['Warlock', 'Wizard'],
  );

  static Spell ropeT() => Spell(
    id: 'rope_trick', name: 'Rope Trick', level: 2, school: 'Transmutation',
    castingTime: '1 action', range: 'Touch', components: ['V', 'S', 'M'],
    materialComponents: 'Powdered corn extract and twisted loop of parchment',
    duration: '1 hour', concentration: false,
    description: '60-foot rope rises and hangs. Upper end opens extradimensional space holding up to 8 Medium creatures.',
    targetType: 'area', effect: 'utility',
    availableToClasses: ['Wizard'],
  );

  static Spell seeInvisibility() => Spell(
    id: 'see_invisibility', name: 'See Invisibility', level: 2, school: 'Divination',
    castingTime: '1 action', range: 'Self', components: ['V', 'S', 'M'],
    materialComponents: 'A pinch of talc and powdered silver',
    duration: '1 hour', concentration: false,
    description: 'You see invisible creatures and objects as if visible. You can also see into Ethereal Plane.',
    targetType: 'self', effect: 'utility',
    availableToClasses: ['Bard', 'Sorcerer', 'Wizard'],
  );

  static Spell shatter() => Spell(
    id: 'shatter', name: 'Shatter', level: 2, school: 'Evocation',
    castingTime: '1 action', range: '60 feet', components: ['V', 'S', 'M'],
    materialComponents: 'A chip of mica',
    duration: 'Instantaneous', concentration: false,
    description: 'Sudden loud ringing in 10-foot radius. Constitution save or 3d8 thunder damage. Half on success. Nonmagical objects shatter.',
    higherLevelDescription: '+1d8 per level above 2nd.',
    targetType: 'area', areaShape: 'sphere', areaSize: 10,
    damageType: 'thunder', damageDice: '3d8', savingThrow: 'Constitution',
    availableToClasses: ['Bard', 'Sorcerer', 'Warlock', 'Wizard'],
  );

  static Spell silence() => Spell(
    id: 'silence', name: 'Silence', level: 2, school: 'Illusion',
    castingTime: '1 action', range: '120 feet', components: ['V', 'S'],
    duration: 'Concentration, up to 10 minutes', concentration: true, ritual: true,
    description: 'No sound in or out of 20-foot radius sphere. Creatures inside are immune to thunder, deafened, can\'t cast with V component.',
    targetType: 'area', areaShape: 'sphere', areaSize: 20, effect: 'utility',
    availableToClasses: ['Bard', 'Cleric', 'Ranger'],
  );

  static Spell spiderClimb() => Spell(
    id: 'spider_climb', name: 'Spider Climb', level: 2, school: 'Transmutation',
    castingTime: '1 action', range: 'Touch', components: ['V', 'S', 'M'],
    materialComponents: 'A drop of bitumen and a spider',
    duration: 'Concentration, up to 1 hour', concentration: true,
    description: 'Willing creature gains climb speed equal to walking speed. Can move on walls/ceilings hands-free.',
    targetType: 'single', effect: 'buff',
    availableToClasses: ['Sorcerer', 'Warlock', 'Wizard'],
  );

  static Spell spikeGrowth() => Spell(
    id: 'spike_growth', name: 'Spike Growth', level: 2, school: 'Transmutation',
    castingTime: '1 action', range: '150 feet', components: ['V', 'S', 'M'],
    materialComponents: 'Seven sharp thorns or seven small twigs',
    duration: 'Concentration, up to 10 minutes', concentration: true,
    description: 'Ground in 20-foot radius becomes difficult terrain. For every 5 feet, creature takes 2d4 piercing damage.',
    targetType: 'area', areaShape: 'sphere', areaSize: 20,
    damageType: 'piercing', damageDice: '2d4', effect: 'control',
    availableToClasses: ['Druid', 'Ranger'],
  );

  static Spell suggestion() => Spell(
    id: 'suggestion', name: 'Suggestion', level: 2, school: 'Enchantment',
    castingTime: '1 action', range: '30 feet', components: ['V', 'M'],
    materialComponents: 'A snake\'s tongue and honeycomb or drop of sweet oil',
    duration: 'Concentration, up to 8 hours', concentration: true,
    description: 'Target makes Wisdom save or follows reasonable suggestion for the duration.',
    targetType: 'single', effect: 'control', savingThrow: 'Wisdom',
    availableToClasses: ['Bard', 'Sorcerer', 'Warlock', 'Wizard'],
  );

  static Spell web() => Spell(
    id: 'web', name: 'Web', level: 2, school: 'Conjuration',
    castingTime: '1 action', range: '60 feet', components: ['V', 'S', 'M'],
    materialComponents: 'A bit of spiderweb',
    duration: 'Concentration, up to 1 hour', concentration: true,
    description: 'Thick webs fill 20-foot cube. Dexterity save or restrained. Difficult terrain. Strength check to escape. Flammable.',
    targetType: 'area', areaShape: 'cube', areaSize: 20,
    effect: 'control', savingThrow: 'Dexterity', conditions: ['restrained'],
    availableToClasses: ['Sorcerer', 'Wizard'],
  );

  static Spell zoneOfTruth() => Spell(
    id: 'zone_of_truth', name: 'Zone of Truth', level: 2, school: 'Enchantment',
    castingTime: '1 action', range: '60 feet', components: ['V', 'S'],
    duration: 'Concentration, up to 10 minutes', concentration: true,
    description: '15-foot radius sphere. Charisma save or can\'t speak deliberate lie. You know who succeeds.',
    targetType: 'area', areaShape: 'sphere', areaSize: 15,
    effect: 'utility', savingThrow: 'Charisma',
    availableToClasses: ['Bard', 'Cleric', 'Paladin'],
  );

  // Method to get all spells
  static List<Spell> getAllSpells() {
    return [
      // Cantrips
      acidSplash(), bladeWard(), chillingTouch(), dancingLights(), light(),
      mageHand(), mendingCantrip(), message(), minorIllusion(), poisonSpray(),
      produceFlame(), shillelagh(), shockingGrasp(), spareTheDying(), thaumaturgy(),
      thornWhip(), trueStrike(), viciousMockery(),

      // Level 1
      alarm(), bane(), bless(), charmPerson(), command(), comprehendLanguages(),
      createOrDestroyWater(), detectMagic(), disguiseSelf(), divineFavor(), entangle(),
      faerieFire(), falseLife(), featherFall(), findFamiliar(), fogCloud(), grease(),
      guidingBolt(), healingWord(), heroism(), hex(), huntersMark(), identify(), jump(),
      longstrider(), mageArmor(), protectionFromEvilAndGood(), sanctuary(), shieldOfFaith(),
      silentImage(), speakWithAnimals(), tashasHideousLaughter(), thunderwave(),
      unseenServant(), witchBolt(),

      // Level 2
      aid(), alterSelf(), arcaneLock(), barkskin(), blindnessDeafness(), blur(),
      calmEmotions(), continualFlame(), crownOfMadness(), darkness(), darkvision(),
      detectThoughts(), enhanceAbility(), enlargeReduce(), findTraps(), flameBlade(),
      flamingSphere(), gentleRepose(), gustOfWind(), heatMetal(), invisibility(),
      knock(), lesserRestoration(), levitate(), locateObject(), magicWeapon(),
      mirrorImage(), mistyStep(), moonbeam(), passWithoutTrace(), prayerOfHealing(),
      rayOfEnfeeblement(), ropeT(), seeInvisibility(), shatter(), silence(),
      spiderClimb(), spikeGrowth(), suggestion(), web(), zoneOfTruth(),

      // Level 3
      fireball(), lightningBolt(), counterspell(), haste(), dispelMagic(), fly(),
      majorImage(), slow(), tongues(), revivify(),

      // Level 4
      banishment(), blackTentacles(), blight(), confusion(), dimensionDoor(),
      freedomOfMovement(), greaterInvisibility(), iceStorm(), polymorph(),
      stoneShape(), wallOfFire(),

      // Level 5
      animate(), cloudkill(), coneOfCold(), conjureElemental(), dominate(),
      flamestrike(), scrying(), teleportationCircle(), wallOfForce(), wallOfStone(),
    ];
  }

  static List<Spell> getSpellsByLevel(int level) {
    return getAllSpells().where((s) => s.level == level).toList();
  }

  static List<Spell> getSpellsForClass(String className) {
    return getAllSpells().where((s) => s.availableToClasses.contains(className)).toList();
  }

  // ==================== LEVEL 3+ SPELLS ====================
  // Adding from original spell_database.dart
  static Spell fireball() => Spell(
    id: 'fireball', name: 'Fireball', level: 3, school: 'Evocation',
    castingTime: '1 action', range: '150 feet', components: ['V', 'S', 'M'],
    materialComponents: 'A tiny ball of bat guano and sulfur',
    duration: 'Instantaneous', concentration: false,
    description: 'A bright streak flashes from your finger to a point, blossoming into flame. Each creature in 20-foot radius makes Dexterity save or takes 8d6 fire damage (half on success).',
    higherLevelDescription: '+1d6 per level above 3rd.',
    targetType: 'area', areaShape: 'sphere', areaSize: 20,
    damageType: 'fire', damageDice: '8d6', savingThrow: 'Dexterity',
    availableToClasses: ['Sorcerer', 'Wizard'],
  );

  static Spell lightningBolt() => Spell(
    id: 'lightning_bolt', name: 'Lightning Bolt', level: 3, school: 'Evocation',
    castingTime: '1 action', range: 'Self (100-foot line)', components: ['V', 'S', 'M'],
    materialComponents: 'A bit of fur and a rod of amber, crystal, or glass',
    duration: 'Instantaneous', concentration: false,
    description: 'Lightning forms 100-foot line, 5 feet wide. Dexterity save or 8d6 lightning damage (half on success).',
    higherLevelDescription: '+1d6 per level above 3rd.',
    targetType: 'area', areaShape: 'line', areaSize: 100,
    damageType: 'lightning', damageDice: '8d6', savingThrow: 'Dexterity',
    availableToClasses: ['Sorcerer', 'Wizard'],
  );

  static Spell counterspell() => Spell(
    id: 'counterspell', name: 'Counterspell', level: 3, school: 'Abjuration',
    castingTime: '1 reaction', range: '60 feet', components: ['S'],
    duration: 'Instantaneous', concentration: false,
    description: 'Interrupt a creature casting a spell. If spell is 3rd level or lower, it fails. Higher requires ability check.',
    higherLevelDescription: 'Automatically interrupt spell of level equal to slot used.',
    targetType: 'single', effect: 'utility',
    availableToClasses: ['Sorcerer', 'Warlock', 'Wizard'],
  );

  static Spell haste() => Spell(
    id: 'haste', name: 'Haste', level: 3, school: 'Transmutation',
    castingTime: '1 action', range: '30 feet', components: ['V', 'S', 'M'],
    materialComponents: 'A shaving of licorice root',
    duration: 'Concentration, up to 1 minute', concentration: true,
    description: 'Willing creature doubles speed, +2 AC, advantage on Dexterity saves, extra action (Attack, Dash, Disengage, Hide, Use Object). Lethargy afterward.',
    targetType: 'single', effect: 'buff',
    availableToClasses: ['Sorcerer', 'Wizard'],
  );

  static Spell dispelMagic() => Spell(
    id: 'dispel_magic', name: 'Dispel Magic', level: 3, school: 'Abjuration',
    castingTime: '1 action', range: '120 feet', components: ['V', 'S'],
    duration: 'Instantaneous', concentration: false,
    description: 'End spells on creature/object. Automatically ends spells of 3rd level or lower. Higher requires ability check.',
    higherLevelDescription: 'Automatically end spells of level equal to slot used.',
    targetType: 'single', effect: 'utility',
    availableToClasses: ['Bard', 'Cleric', 'Druid', 'Paladin', 'Sorcerer', 'Warlock', 'Wizard'],
  );

  static Spell fly() => Spell(
    id: 'fly', name: 'Fly', level: 3, school: 'Transmutation',
    castingTime: '1 action', range: 'Touch', components: ['V', 'S', 'M'],
    materialComponents: 'A wing feather from any bird',
    duration: 'Concentration, up to 10 minutes', concentration: true,
    description: 'Willing creature gains flying speed of 60 feet.',
    higherLevelDescription: 'Target 1 additional creature per level above 3rd.',
    targetType: 'single', effect: 'buff',
    availableToClasses: ['Sorcerer', 'Warlock', 'Wizard'],
  );

  static Spell majorImage() => Spell(
    id: 'major_image', name: 'Major Image', level: 3, school: 'Illusion',
    castingTime: '1 action', range: '120 feet', components: ['V', 'S', 'M'],
    materialComponents: 'A bit of fleece',
    duration: 'Concentration, up to 10 minutes', concentration: true,
    description: 'Create image of object/creature no larger than 20-foot cube. Includes sound, smell, temperature. Physical inspection reveals illusion.',
    targetType: 'area', effect: 'utility',
    availableToClasses: ['Bard', 'Sorcerer', 'Warlock', 'Wizard'],
  );

  static Spell slow() => Spell(
    id: 'slow', name: 'Slow', level: 3, school: 'Transmutation',
    castingTime: '1 action', range: '120 feet', components: ['V', 'S', 'M'],
    materialComponents: 'A drop of molasses',
    duration: 'Concentration, up to 1 minute', concentration: true,
    description: 'Up to 6 creatures in 40-foot cube make Wisdom save or have speed halved, -2 AC, disadvantage on Dexterity saves, can\'t use reactions.',
    targetType: 'area', areaShape: 'cube', areaSize: 40,
    effect: 'debuff', savingThrow: 'Wisdom',
    availableToClasses: ['Sorcerer', 'Wizard'],
  );

  static Spell tongues() => Spell(
    id: 'tongues', name: 'Tongues', level: 3, school: 'Divination',
    castingTime: '1 action', range: 'Touch', components: ['V', 'M'],
    materialComponents: 'A small clay model of a ziggurat',
    duration: '1 hour', concentration: false,
    description: 'Creature understands any spoken language and can speak any language it knows.',
    targetType: 'single', effect: 'utility',
    availableToClasses: ['Bard', 'Cleric', 'Sorcerer', 'Warlock', 'Wizard'],
  );

  static Spell revivify() => Spell(
    id: 'revivify', name: 'Revivify', level: 3, school: 'Necromancy',
    castingTime: '1 action', range: 'Touch', components: ['V', 'S', 'M'],
    materialComponents: 'Diamonds worth 300 gp (consumed)',
    duration: 'Instantaneous', concentration: false,
    description: 'Return creature dead within 1 minute to life with 1 HP. Can\'t restore missing body parts or death from old age.',
    targetType: 'single', effect: 'healing',
    availableToClasses: ['Cleric', 'Paladin'],
  );

  // LEVEL 4 SPELLS
  static Spell banishment() => Spell(
    id: 'banishment', name: 'Banishment', level: 4, school: 'Abjuration',
    castingTime: '1 action', range: '60 feet', components: ['V', 'S', 'M'],
    materialComponents: 'An item distasteful to the target',
    duration: 'Concentration, up to 1 minute', concentration: true,
    description: 'Charisma save or banished to harmless demiplane. If native to different plane, sent home if concentration held 1 minute.',
    higherLevelDescription: 'Target 1 additional creature per level above 4th.',
    targetType: 'single', effect: 'control', savingThrow: 'Charisma',
    availableToClasses: ['Cleric', 'Paladin', 'Sorcerer', 'Warlock', 'Wizard'],
  );

  static Spell blackTentacles() => Spell(
    id: 'black_tentacles', name: 'Evard\'s Black Tentacles', level: 4, school: 'Conjuration',
    castingTime: '1 action', range: '90 feet', components: ['V', 'S', 'M'],
    materialComponents: 'A piece of tentacle from giant octopus or squid',
    duration: 'Concentration, up to 1 minute', concentration: true,
    description: 'Squirming tentacles fill 20-foot square. Difficult terrain, Dexterity save or restrained, 3d6 bludgeoning at start of turn.',
    targetType: 'area', areaShape: 'cube', areaSize: 20,
    damageType: 'bludgeoning', damageDice: '3d6',
    effect: 'control', savingThrow: 'Dexterity', conditions: ['restrained'],
    availableToClasses: ['Wizard'],
  );

  static Spell blight() => Spell(
    id: 'blight', name: 'Blight', level: 4, school: 'Necromancy',
    castingTime: '1 action', range: '30 feet', components: ['V', 'S'],
    duration: 'Instantaneous', concentration: false,
    description: 'Constitution save or 8d8 necrotic damage (half on success). Plants have disadvantage and take maximum damage.',
    higherLevelDescription: '+1d8 per level above 4th.',
    targetType: 'single', damageType: 'necrotic', damageDice: '8d8', savingThrow: 'Constitution',
    availableToClasses: ['Druid', 'Sorcerer', 'Warlock', 'Wizard'],
  );

  static Spell confusion() => Spell(
    id: 'confusion', name: 'Confusion', level: 4, school: 'Enchantment',
    castingTime: '1 action', range: '90 feet', components: ['V', 'S', 'M'],
    materialComponents: 'Three nut shells',
    duration: 'Concentration, up to 1 minute', concentration: true,
    description: 'Creatures in 10-foot radius make Wisdom save or can\'t take reactions, roll d10 each turn for behavior.',
    targetType: 'area', areaShape: 'sphere', areaSize: 10,
    effect: 'control', savingThrow: 'Wisdom',
    availableToClasses: ['Bard', 'Druid', 'Sorcerer', 'Wizard'],
  );

  static Spell dimensionDoor() => Spell(
    id: 'dimension_door', name: 'Dimension Door', level: 4, school: 'Conjuration',
    castingTime: '1 action', range: '500 feet', components: ['V'],
    duration: 'Instantaneous', concentration: false,
    description: 'Teleport to location you can see, visualize, or describe by distance/direction. Can bring willing creature within 5 feet.',
    targetType: 'self', effect: 'utility',
    availableToClasses: ['Bard', 'Sorcerer', 'Warlock', 'Wizard'],
  );

  static Spell freedomOfMovement() => Spell(
    id: 'freedom_of_movement', name: 'Freedom of Movement', level: 4, school: 'Abjuration',
    castingTime: '1 action', range: 'Touch', components: ['V', 'S', 'M'],
    materialComponents: 'A leather strap bound around arm or appendage',
    duration: '1 hour', concentration: false,
    description: 'Willing creature\'s movement unaffected by difficult terrain, magic can\'t reduce speed or paralyze/restrain. Can spend 5 feet to escape nonmagical restraints.',
    targetType: 'single', effect: 'buff',
    availableToClasses: ['Bard', 'Cleric', 'Druid', 'Ranger'],
  );

  static Spell greaterInvisibility() => Spell(
    id: 'greater_invisibility', name: 'Greater Invisibility', level: 4, school: 'Illusion',
    castingTime: '1 action', range: 'Touch', components: ['V', 'S'],
    duration: 'Concentration, up to 1 minute', concentration: true,
    description: 'Willing creature becomes invisible. Unlike invisibility, attacking/casting doesn\'t end it.',
    targetType: 'single', effect: 'buff',
    availableToClasses: ['Bard', 'Sorcerer', 'Wizard'],
  );

  static Spell iceStorm() => Spell(
    id: 'ice_storm', name: 'Ice Storm', level: 4, school: 'Evocation',
    castingTime: '1 action', range: '300 feet', components: ['V', 'S', 'M'],
    materialComponents: 'A pinch of dust and a few drops of water',
    duration: 'Instantaneous', concentration: false,
    description: 'Hail falls in 20-foot radius, 40-foot high cylinder. Dexterity save or 2d8 bludgeoning + 4d6 cold (half on success). Difficult terrain.',
    higherLevelDescription: '+1d8 bludgeoning per level above 4th.',
    targetType: 'area', areaShape: 'cylinder', areaSize: 20,
    damageType: 'cold', damageDice: '4d6', savingThrow: 'Dexterity',
    availableToClasses: ['Druid', 'Sorcerer', 'Wizard'],
  );

  static Spell polymorph() => Spell(
    id: 'polymorph', name: 'Polymorph', level: 4, school: 'Transmutation',
    castingTime: '1 action', range: '60 feet', components: ['V', 'S', 'M'],
    materialComponents: 'A caterpillar cocoon',
    duration: 'Concentration, up to 1 hour', concentration: true,
    description: 'Transform creature into beast with CR ≤ target level (unwilling Wisdom save). Stats become beast\'s. Reverts at 0 HP.',
    targetType: 'single', effect: 'control', savingThrow: 'Wisdom',
    availableToClasses: ['Bard', 'Druid', 'Sorcerer', 'Wizard'],
  );

  static Spell stoneShape() => Spell(
    id: 'stone_shape', name: 'Stone Shape', level: 4, school: 'Transmutation',
    castingTime: '1 action', range: 'Touch', components: ['V', 'S', 'M'],
    materialComponents: 'Soft clay molded into desired shape',
    duration: 'Instantaneous', concentration: false,
    description: 'Touch stone object of Medium size or smaller/section of stone no more than 5 feet. You form it into any shape.',
    targetType: 'single', effect: 'utility',
    availableToClasses: ['Cleric', 'Druid', 'Wizard'],
  );

  static Spell wallOfFire() => Spell(
    id: 'wall_of_fire', name: 'Wall of Fire', level: 4, school: 'Evocation',
    castingTime: '1 action', range: '120 feet', components: ['V', 'S', 'M'],
    materialComponents: 'A small piece of phosphorus',
    duration: 'Concentration, up to 1 minute', concentration: true,
    description: 'Create opaque wall of fire on solid surface. One side deals 5d8 fire to creatures within 10 feet. Passing through deals 5d8.',
    higherLevelDescription: '+1d8 per level above 4th.',
    targetType: 'area', areaShape: 'line', areaSize: 60,
    damageType: 'fire', damageDice: '5d8', savingThrow: 'Dexterity',
    availableToClasses: ['Druid', 'Sorcerer', 'Wizard'],
  );

  // LEVEL 5 SPELLS
  static Spell animate() => Spell(
    id: 'animate_objects', name: 'Animate Objects', level: 5, school: 'Transmutation',
    castingTime: '1 action', range: '120 feet', components: ['V', 'S'],
    duration: 'Concentration, up to 1 minute', concentration: true,
    description: 'Animate up to 10 nonmagical objects. Obey your commands. Stats based on size.',
    targetType: 'multiple', effect: 'utility',
    availableToClasses: ['Bard', 'Sorcerer', 'Wizard'],
  );

  static Spell cloudkill() => Spell(
    id: 'cloudkill', name: 'Cloudkill', level: 5, school: 'Conjuration',
    castingTime: '1 action', range: '120 feet', components: ['V', 'S'],
    duration: 'Concentration, up to 10 minutes', concentration: true,
    description: '20-foot radius sphere of poisonous fog. Constitution save or 5d8 poison (half on success). Heavily obscured. Moves away 10 feet/turn.',
    higherLevelDescription: '+1d8 per level above 5th.',
    targetType: 'area', areaShape: 'sphere', areaSize: 20,
    damageType: 'poison', damageDice: '5d8', savingThrow: 'Constitution',
    availableToClasses: ['Sorcerer', 'Wizard'],
  );

  static Spell coneOfCold() => Spell(
    id: 'cone_of_cold', name: 'Cone of Cold', level: 5, school: 'Evocation',
    castingTime: '1 action', range: 'Self (60-foot cone)', components: ['V', 'S', 'M'],
    materialComponents: 'A small crystal or glass cone',
    duration: 'Instantaneous', concentration: false,
    description: 'Blast of cold air in 60-foot cone. Constitution save or 8d8 cold damage (half on success).',
    higherLevelDescription: '+1d8 per level above 5th.',
    targetType: 'area', areaShape: 'cone', areaSize: 60,
    damageType: 'cold', damageDice: '8d8', savingThrow: 'Constitution',
    availableToClasses: ['Sorcerer', 'Wizard'],
  );

  static Spell conjureElemental() => Spell(
    id: 'conjure_elemental', name: 'Conjure Elemental', level: 5, school: 'Conjuration',
    castingTime: '1 minute', range: '90 feet', components: ['V', 'S', 'M'],
    materialComponents: 'Burning incense for air, soft clay for earth, sulfur/phosphorus for fire, water/sand for water',
    duration: 'Concentration, up to 1 hour', concentration: true,
    description: 'Summon elemental of CR 5 or lower. Obeys verbal commands. Returns to home plane when reduced to 0 HP or spell ends.',
    higherLevelDescription: 'Summon creature of CR one higher per level above 5th.',
    targetType: 'area', effect: 'utility',
    availableToClasses: ['Druid', 'Wizard'],
  );

  static Spell dominate() => Spell(
    id: 'dominate_person', name: 'Dominate Person', level: 5, school: 'Enchantment',
    castingTime: '1 action', range: '60 feet', components: ['V', 'S'],
    duration: 'Concentration, up to 1 minute', concentration: true,
    description: 'Humanoid makes Wisdom save or charmed. Telepathic link, you command its actions. New save when takes damage.',
    targetType: 'single', effect: 'control', savingThrow: 'Wisdom', conditions: ['charmed'],
    availableToClasses: ['Bard', 'Sorcerer', 'Wizard'],
  );

  static Spell flamestrike() => Spell(
    id: 'flame_strike', name: 'Flame Strike', level: 5, school: 'Evocation',
    castingTime: '1 action', range: '60 feet', components: ['V', 'S', 'M'],
    materialComponents: 'A pinch of sulfur',
    duration: 'Instantaneous', concentration: false,
    description: 'Column of divine fire in 10-foot radius, 40-foot high cylinder. Dexterity save or 4d6 fire + 4d6 radiant (half on success).',
    higherLevelDescription: '+1d6 fire per level above 5th.',
    targetType: 'area', areaShape: 'cylinder', areaSize: 10,
    damageType: 'fire', damageDice: '4d6', savingThrow: 'Dexterity',
    availableToClasses: ['Cleric'],
  );

  static Spell scrying() => Spell(
    id: 'scrying', name: 'Scrying', level: 5, school: 'Divination',
    castingTime: '10 minutes', range: 'Self', components: ['V', 'S', 'M'],
    materialComponents: 'Focus worth 1,000 gp (crystal ball, silver mirror, or holy water font)',
    duration: 'Concentration, up to 10 minutes', concentration: true,
    description: 'See/hear particular creature on same plane. Wisdom save modified by knowledge/connection. Creates invisible sensor.',
    targetType: 'single', effect: 'utility', savingThrow: 'Wisdom',
    availableToClasses: ['Bard', 'Cleric', 'Druid', 'Warlock', 'Wizard'],
  );

  static Spell teleportationCircle() => Spell(
    id: 'teleportation_circle', name: 'Teleportation Circle', level: 5, school: 'Conjuration',
    castingTime: '1 minute', range: '10 feet', components: ['V', 'M'],
    materialComponents: 'Rare chalks and inks infused with precious gems worth 50 gp (consumed)',
    duration: '1 round', concentration: false,
    description: 'Create 10-foot diameter circle linked to permanent destination circle whose sigil sequence you know. Lasts 1 round.',
    targetType: 'area', effect: 'utility',
    availableToClasses: ['Bard', 'Sorcerer', 'Wizard'],
  );

  static Spell wallOfForce() => Spell(
    id: 'wall_of_force', name: 'Wall of Force', level: 5, school: 'Evocation',
    castingTime: '1 action', range: '120 feet', components: ['V', 'S', 'M'],
    materialComponents: 'A pinch of powder made by crushing clear gemstone',
    duration: 'Concentration, up to 10 minutes', concentration: true,
    description: 'Create invisible wall of pure force. Can be hemisphere or ten 10×10-foot panels. Nothing can pass through. Immune to all damage.',
    targetType: 'area', effect: 'utility',
    availableToClasses: ['Wizard'],
  );

  static Spell wallOfStone() => Spell(
    id: 'wall_of_stone', name: 'Wall of Stone', level: 5, school: 'Evocation',
    castingTime: '1 action', range: '120 feet', components: ['V', 'S', 'M'],
    materialComponents: 'A small block of granite',
    duration: 'Concentration, up to 10 minutes', concentration: true,
    description: 'Create wall of solid stone. Can be ten 10×10-foot panels. AC 15, 30 HP per 10-foot section. Becomes permanent if concentration held.',
    targetType: 'area', effect: 'utility',
    availableToClasses: ['Druid', 'Sorcerer', 'Wizard'],
  );
}
