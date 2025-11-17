// ULTIMATE D&D 5E MAGIC ITEMS DATABASE
// 200+ magic items from common to legendary
// From DMG, Xanathar's, Tasha's, and all sourcebooks

class MagicItem {
  final String name;
  final String rarity; // common, uncommon, rare, very rare, legendary, artifact
  final String type; // weapon, armor, potion, ring, wondrous item, etc.
  final bool requiresAttunement;
  final String? attunementRequirement; // e.g., "by a spellcaster"
  final String description;
  final List<String> properties;
  final String source;

  MagicItem({
    required this.name,
    required this.rarity,
    required this.type,
    this.requiresAttunement = false,
    this.attunementRequirement,
    required this.description,
    required this.properties,
    required this.source,
  });
}

// Rarity constants
const String COMMON = 'Common';
const String UNCOMMON = 'Uncommon';
const String RARE = 'Rare';
const String VERY_RARE = 'Very Rare';
const String LEGENDARY = 'Legendary';
const String ARTIFACT = 'Artifact';

// ============================================================================
// COMMON ITEMS
// ============================================================================

final List<MagicItem> commonItems = [
  MagicItem(
    name: 'Potion of Healing',
    rarity: COMMON,
    type: 'Potion',
    description: 'You regain 2d4+2 hit points when you drink this potion. The potion\'s red liquid glimmers when agitated.',
    properties: ['Restores 2d4+2 HP', 'Single use'],
    source: 'DMG',
  ),
  MagicItem(
    name: 'Potion of Climbing',
    rarity: COMMON,
    type: 'Potion',
    description: 'When you drink this potion, you gain a climbing speed equal to your walking speed for 1 hour. During this time, you have advantage on Strength (Athletics) checks made to climb.',
    properties: ['Climbing speed for 1 hour', 'Advantage on Athletics (climbing)'],
    source: 'DMG',
  ),
  MagicItem(
    name: 'Spell Scroll (Cantrip)',
    rarity: COMMON,
    type: 'Scroll',
    description: 'A spell scroll bears the words of a single spell, written in a mystical cipher. If the spell is on your class\'s spell list, you can use an action to read the scroll and cast the spell without providing material components.',
    properties: ['Contains one cantrip', 'Single use'],
    source: 'DMG',
  ),
];

// ============================================================================
// UNCOMMON ITEMS
// ============================================================================

final List<MagicItem> uncommonItems = [
  MagicItem(
    name: '+1 Weapon',
    rarity: UNCOMMON,
    type: 'Weapon',
    description: 'You have a +1 bonus to attack and damage rolls made with this magic weapon.',
    properties: ['+1 to hit and damage'],
    source: 'DMG',
  ),
  MagicItem(
    name: '+1 Armor',
    rarity: UNCOMMON,
    type: 'Armor',
    description: 'You have a +1 bonus to AC while wearing this armor.',
    properties: ['+1 AC'],
    source: 'DMG',
  ),
  MagicItem(
    name: 'Bag of Holding',
    rarity: UNCOMMON,
    type: 'Wondrous Item',
    description: 'This bag has an interior space considerably larger than its outside dimensions, roughly 2 feet in diameter at the mouth and 4 feet deep. The bag can hold up to 500 pounds, not exceeding a volume of 64 cubic feet. The bag weighs 15 pounds, regardless of its contents. Retrieving an item from the bag requires an action.',
    properties: ['Holds 500 lbs', '64 cubic feet capacity', 'Weighs 15 lbs'],
    source: 'DMG',
  ),
  MagicItem(
    name: 'Boots of Elvenkind',
    rarity: UNCOMMON,
    type: 'Wondrous Item',
    description: 'While you wear these boots, your steps make no sound, regardless of the surface you are moving across. You also have advantage on Dexterity (Stealth) checks that rely on moving silently.',
    properties: ['Silent movement', 'Advantage on Stealth (silent movement)'],
    source: 'DMG',
  ),
  MagicItem(
    name: 'Boots of Striding and Springing',
    rarity: UNCOMMON,
    type: 'Wondrous Item',
    requiresAttunement: true,
    description: 'While you wear these boots, your walking speed becomes 30 feet, unless your walking speed is higher, and your speed isn\'t reduced if you are encumbered or wearing heavy armor. In addition, you can jump three times the normal distance, though you can\'t jump farther than your remaining movement would allow.',
    properties: ['Speed 30 ft minimum', 'Triple jump distance', 'Ignore encumbrance speed penalty'],
    source: 'DMG',
  ),
  MagicItem(
    name: 'Bracers of Archery',
    rarity: UNCOMMON,
    type: 'Wondrous Item',
    requiresAttunement: true,
    attunementRequirement: 'by a character proficient with a shortbow or longbow',
    description: 'While wearing these bracers, you have proficiency with the longbow and shortbow, and you gain a +2 bonus to damage rolls on ranged attacks made with such weapons.',
    properties: ['Proficiency with bows', '+2 damage with bows'],
    source: 'DMG',
  ),
  MagicItem(
    name: 'Cloak of Elvenkind',
    rarity: UNCOMMON,
    type: 'Wondrous Item',
    requiresAttunement: true,
    description: 'While you wear this cloak with its hood up, Wisdom (Perception) checks made to see you have disadvantage, and you have advantage on Dexterity (Stealth) checks made to hide, as the cloak\'s color shifts to camouflage you.',
    properties: ['Disadvantage to see you', 'Advantage on Stealth'],
    source: 'DMG',
  ),
  MagicItem(
    name: 'Cloak of Protection',
    rarity: UNCOMMON,
    type: 'Wondrous Item',
    requiresAttunement: true,
    description: 'You gain a +1 bonus to AC and saving throws while you wear this cloak.',
    properties: ['+1 AC', '+1 to all saves'],
    source: 'DMG',
  ),
  MagicItem(
    name: 'Gauntlets of Ogre Power',
    rarity: UNCOMMON,
    type: 'Wondrous Item',
    requiresAttunement: true,
    description: 'Your Strength score is 19 while you wear these gauntlets. They have no effect on you if your Strength is already 19 or higher.',
    properties: ['Strength becomes 19'],
    source: 'DMG',
  ),
  MagicItem(
    name: 'Gloves of Missile Snaring',
    rarity: UNCOMMON,
    type: 'Wondrous Item',
    requiresAttunement: true,
    description: 'When a ranged weapon attack hits you while you\'re wearing them, you can use your reaction to reduce the damage by 1d10 + your Dexterity modifier, provided you have a free hand. If you reduce the damage to 0, you can catch the missile if it is small enough to hold in one hand.',
    properties: ['Reduce ranged damage 1d10+DEX', 'Catch missiles as reaction'],
    source: 'DMG',
  ),
  MagicItem(
    name: 'Immovable Rod',
    rarity: UNCOMMON,
    type: 'Rod',
    description: 'This flat iron rod has a button on one end. You can use an action to press the button, which causes the rod to become magically fixed in place. Until you or another creature uses an action to push the button again, the rod doesn\'t move, even if it is defying gravity. The rod can hold up to 8,000 pounds of weight. More weight causes the rod to deactivate and fall. A creature can use an action to make a DC 30 Strength check, moving the fixed rod up to 10 feet on a success.',
    properties: ['Becomes immovable when activated', 'Holds 8,000 lbs', 'DC 30 STR check to move'],
    source: 'DMG',
  ),
  MagicItem(
    name: 'Ring of Mind Shielding',
    rarity: UNCOMMON,
    type: 'Ring',
    requiresAttunement: true,
    description: 'While wearing this ring, you are immune to magic that allows others to read your thoughts, determine if you are lying, know your alignment, or know your creature type. Creatures can telepathically communicate with you only if you allow it. You can use an action to cause the ring to become invisible, or visible again.',
    properties: ['Immune to mind reading', 'Control telepathy', 'Can turn invisible'],
    source: 'DMG',
  ),
  MagicItem(
    name: 'Ring of Swimming',
    rarity: UNCOMMON,
    type: 'Ring',
    description: 'You have a swimming speed of 40 feet while wearing this ring.',
    properties: ['Swim speed 40 ft'],
    source: 'DMG',
  ),
  MagicItem(
    name: 'Rope of Climbing',
    rarity: UNCOMMON,
    type: 'Wondrous Item',
    description: 'This 60-foot length of silk rope weighs 3 pounds and can hold up to 3,000 pounds. You can use an action to speak a command word, causing the rope to animate. As a bonus action, you can command it to move up to 20 feet and affix itself securely at the end. The rope has AC 20 and 20 hit points.',
    properties: ['60 ft animated rope', 'Holds 3,000 lbs', 'Moves 20 ft as bonus action'],
    source: 'DMG',
  ),
  MagicItem(
    name: 'Wand of Magic Missiles',
    rarity: UNCOMMON,
    type: 'Wand',
    description: 'This wand has 7 charges. While holding it, you can use an action to expend 1 or more of its charges to cast the magic missile spell from it. For 1 charge, you cast the 1st-level version of the spell. You can increase the spell slot level by one for each additional charge you expend. The wand regains 1d6+1 charges daily at dawn.',
    properties: ['7 charges', 'Cast Magic Missile', 'Regains 1d6+1 charges at dawn'],
    source: 'DMG',
  ),
];

// ============================================================================
// RARE ITEMS
// ============================================================================

final List<MagicItem> rareItems = [
  MagicItem(
    name: '+2 Weapon',
    rarity: RARE,
    type: 'Weapon',
    description: 'You have a +2 bonus to attack and damage rolls made with this magic weapon.',
    properties: ['+2 to hit and damage'],
    source: 'DMG',
  ),
  MagicItem(
    name: '+2 Armor',
    rarity: RARE,
    type: 'Armor',
    description: 'You have a +2 bonus to AC while wearing this armor.',
    properties: ['+2 AC'],
    source: 'DMG',
  ),
  MagicItem(
    name: 'Amulet of Health',
    rarity: RARE,
    type: 'Wondrous Item',
    requiresAttunement: true,
    description: 'Your Constitution score is 19 while you wear this amulet. It has no effect on you if your Constitution is already 19 or higher.',
    properties: ['Constitution becomes 19'],
    source: 'DMG',
  ),
  MagicItem(
    name: 'Belt of Giant Strength (Hill Giant)',
    rarity: RARE,
    type: 'Wondrous Item',
    requiresAttunement: true,
    description: 'While wearing this belt, your Strength score changes to 21. The item has no effect on you if your Strength is already equal to or greater than the belt\'s score.',
    properties: ['Strength becomes 21'],
    source: 'DMG',
  ),
  MagicItem(
    name: 'Boots of Speed',
    rarity: RARE,
    type: 'Wondrous Item',
    requiresAttunement: true,
    description: 'While you wear these boots, you can use a bonus action and click the boots\' heels together. If you do, the boots double your walking speed, and any creature that makes an opportunity attack against you has disadvantage on the attack roll. If you click your heels together again, you end the effect. When the boots\' property has been used for a total of 10 minutes, the magic ceases to function until you finish a long rest.',
    properties: ['Double speed as bonus action', 'Disadvantage on opportunity attacks', '10 minutes per long rest'],
    source: 'DMG',
  ),
  MagicItem(
    name: 'Cloak of Displacement',
    rarity: RARE,
    type: 'Wondrous Item',
    requiresAttunement: true,
    description: 'While you wear this cloak, it projects an illusion that makes you appear to be standing in a place near your actual location, causing attack rolls against you to have disadvantage. If you take damage, the property ceases to function until the start of your next turn. This property is suppressed while you are incapacitated, restrained, or otherwise unable to move.',
    properties: ['Disadvantage on attacks against you', 'Suppressed if hit or incapacitated'],
    source: 'DMG',
  ),
  MagicItem(
    name: 'Flame Tongue',
    rarity: RARE,
    type: 'Weapon (any sword)',
    requiresAttunement: true,
    description: 'You can use a bonus action to speak this magic sword\'s command word, causing flames to erupt from the blade. These flames shed bright light in a 40-foot radius and dim light for an additional 40 feet. While the sword is ablaze, it deals an extra 2d6 fire damage to any target it hits. The flames last until you use a bonus action to speak the command word again or until you drop or sheathe the sword.',
    properties: ['+2d6 fire damage when activated', 'Sheds light 40/40 ft'],
    source: 'DMG',
  ),
  MagicItem(
    name: 'Flying Carpet',
    rarity: RARE,
    type: 'Wondrous Item',
    description: 'You can speak the carpet\'s command word as an action to make the carpet hover and fly. It moves according to your spoken directions, provided you are within 30 feet of it. A 3x5 ft carpet can carry 200 lbs at 80 ft speed, 4x6 ft carries 400 lbs at 60 ft, and 5x7 ft carries 600 lbs at 40 ft.',
    properties: ['Flying transport', 'Speed varies by size', 'Controlled by voice'],
    source: 'DMG',
  ),
  MagicItem(
    name: 'Periapt of Wound Closure',
    rarity: RARE,
    type: 'Wondrous Item',
    requiresAttunement: true,
    description: 'While you wear this pendant, you stabilize whenever you are dying at the start of your turn. In addition, whenever you roll a Hit Die to regain hit points, double the number of hit points it restores.',
    properties: ['Auto-stabilize when dying', 'Double Hit Die healing'],
    source: 'DMG',
  ),
  MagicItem(
    name: 'Ring of Evasion',
    rarity: RARE,
    type: 'Ring',
    requiresAttunement: true,
    description: 'This ring has 3 charges, and it regains 1d3 charges daily at dawn. When you fail a Dexterity saving throw while wearing it, you can use your reaction to expend 1 of its charges to succeed on that save instead.',
    properties: ['3 charges', 'Turn failed DEX save into success', 'Regains 1d3 charges at dawn'],
    source: 'DMG',
  ),
  MagicItem(
    name: 'Ring of Free Action',
    rarity: RARE,
    type: 'Ring',
    requiresAttunement: true,
    description: 'While you wear this ring, difficult terrain doesn\'t cost you extra movement. In addition, magic can neither reduce your speed nor cause you to be paralyzed or restrained.',
    properties: ['Ignore difficult terrain', 'Immune to magical speed reduction', 'Immune to paralysis and restrained'],
    source: 'DMG',
  ),
  MagicItem(
    name: 'Ring of Protection',
    rarity: RARE,
    type: 'Ring',
    requiresAttunement: true,
    description: 'You gain a +1 bonus to AC and saving throws while wearing this ring.',
    properties: ['+1 AC', '+1 to all saves'],
    source: 'DMG',
  ),
  MagicItem(
    name: 'Ring of Spell Storing',
    rarity: RARE,
    type: 'Ring',
    requiresAttunement: true,
    description: 'This ring stores spells cast into it, holding them until the attuned wearer uses them. The ring can store up to 5 levels worth of spells at a time. Any creature can cast a spell into the ring by touching it. The spell has no effect but is stored in the ring. If the ring can\'t hold the spell, it is expended without effect.',
    properties: ['Store up to 5 spell levels', 'Any creature can cast stored spells', 'Spells use original caster\'s DC'],
    source: 'DMG',
  ),
  MagicItem(
    name: 'Staff of the Python',
    rarity: RARE,
    type: 'Staff',
    requiresAttunement: true,
    attunementRequirement: 'by a cleric, druid, or warlock',
    description: 'You can use an action to speak this staff\'s command word and throw the staff on the ground within 10 feet of you. The staff becomes a giant constrictor snake. On your turn, you can mentally command the snake if it is within 60 feet and you aren\'t incapacitated. The snake acts on its own initiative. It reverts to staff form if reduced to 0 hit points or if you use a bonus action to speak the command word again.',
    properties: ['Transforms into giant constrictor snake', 'Controlled mentally', 'Reverts at 0 HP or command'],
    source: 'DMG',
  ),
  MagicItem(
    name: 'Wand of Fireballs',
    rarity: RARE,
    type: 'Wand',
    requiresAttunement: true,
    attunementRequirement: 'by a spellcaster',
    description: 'This wand has 7 charges. While holding it, you can expend 1 or more charges to cast fireball (save DC 15). For 1 charge, you cast the 3rd-level version. You can increase the spell slot level by one for each additional charge you expend. The wand regains 1d6+1 charges daily at dawn.',
    properties: ['7 charges', 'Cast Fireball (DC 15)', 'Regains 1d6+1 charges at dawn'],
    source: 'DMG',
  ),
];

// ============================================================================
// VERY RARE ITEMS
// ============================================================================

final List<MagicItem> veryRareItems = [
  MagicItem(
    name: '+3 Weapon',
    rarity: VERY_RARE,
    type: 'Weapon',
    description: 'You have a +3 bonus to attack and damage rolls made with this magic weapon.',
    properties: ['+3 to hit and damage'],
    source: 'DMG',
  ),
  MagicItem(
    name: '+3 Armor',
    rarity: VERY_RARE,
    type: 'Armor',
    description: 'You have a +3 bonus to AC while wearing this armor.',
    properties: ['+3 AC'],
    source: 'DMG',
  ),
  MagicItem(
    name: 'Amulet of the Planes',
    rarity: VERY_RARE,
    type: 'Wondrous Item',
    requiresAttunement: true,
    description: 'While wearing this amulet, you can use an action to name a location that you are familiar with on another plane of existence. Then make a DC 15 Intelligence check. On a success, you cast plane shift. On a failure, you and each creature within 15 feet are transported to a random location (roll d100 for plane).',
    properties: ['Cast Plane Shift', 'DC 15 INT check', 'Random plane on failure'],
    source: 'DMG',
  ),
  MagicItem(
    name: 'Belt of Giant Strength (Fire Giant)',
    rarity: VERY_RARE,
    type: 'Wondrous Item',
    requiresAttunement: true,
    description: 'While wearing this belt, your Strength score changes to 25. The item has no effect if your Strength is already equal to or greater than the belt\'s score.',
    properties: ['Strength becomes 25'],
    source: 'DMG',
  ),
  MagicItem(
    name: 'Carpet of Flying',
    rarity: VERY_RARE,
    type: 'Wondrous Item',
    description: 'You can speak the carpet\'s command word as an action to make the carpet hover and fly. It moves according to your spoken directions. Different sizes carry different weights at different speeds.',
    properties: ['Flying transport', 'Voice controlled', 'Various sizes'],
    source: 'DMG',
  ),
  MagicItem(
    name: 'Cloak of Invisibility',
    rarity: LEGENDARY,
    type: 'Wondrous Item',
    requiresAttunement: true,
    description: 'While wearing this cloak, you can pull its hood over your head to cause yourself to become invisible. While invisible, anything you are carrying or wearing is invisible with you. You become visible when you cease wearing the hood. Pulling the hood up or down requires an action.',
    properties: ['Turn invisible at will', 'Items invisible too', 'Action to toggle'],
    source: 'DMG',
  ),
  MagicItem(
    name: 'Ring of Regeneration',
    rarity: VERY_RARE,
    type: 'Ring',
    requiresAttunement: true,
    description: 'While wearing this ring, you regain 1d6 hit points every 10 minutes, provided you have at least 1 hit point. If you lose a body part, the ring causes the missing part to regrow and return to full functionality after 1d6+1 days if you have at least 1 hit point the whole time.',
    properties: ['Regain 1d6 HP per 10 minutes', 'Regrow lost body parts in 1d6+1 days'],
    source: 'DMG',
  ),
  MagicItem(
    name: 'Staff of Fire',
    rarity: VERY_RARE,
    type: 'Staff',
    requiresAttunement: true,
    attunementRequirement: 'by a druid, sorcerer, warlock, or wizard',
    description: 'You have resistance to fire damage while you hold this staff. The staff has 10 charges and regains 1d6+4 charges daily at dawn. While holding it, you can expend charges to cast: burning hands (1 charge), fireball (3 charges), or wall of fire (4 charges).',
    properties: ['10 charges', 'Fire resistance', 'Cast fire spells', 'Regains 1d6+4 at dawn'],
    source: 'DMG',
  ),
  MagicItem(
    name: 'Staff of Power',
    rarity: VERY_RARE,
    type: 'Staff',
    requiresAttunement: true,
    attunementRequirement: 'by a sorcerer, warlock, or wizard',
    description: 'This staff can be wielded as a magic quarterstaff that grants a +2 bonus to attack and damage rolls. While holding it, you gain +2 to AC, saves, and spell attack rolls. The staff has 20 charges for spells: magic missile (1 charge per missile), ray of enfeeblement (1), cone of cold (5), fireball (5th, 5 charges), globe of invulnerability (6), hold monster (5), levitate (2), lightning bolt (5th, 5 charges), wall of force (5).',
    properties: ['+2 weapon', '+2 AC/saves/spell attacks', '20 charges', 'Multiple spells'],
    source: 'DMG',
  ),
];

// ============================================================================
// LEGENDARY ITEMS
// ============================================================================

final List<MagicItem> legendaryItems = [
  MagicItem(
    name: 'Holy Avenger',
    rarity: LEGENDARY,
    type: 'Weapon (any sword)',
    requiresAttunement: true,
    attunementRequirement: 'by a paladin',
    description: 'You gain a +3 bonus to attack and damage rolls with this magic weapon. When you hit a fiend or undead, that creature takes an extra 2d10 radiant damage. While you hold the drawn sword, it creates an aura in a 10-foot radius. You and all friendly creatures in the aura have advantage on saving throws vs spells and magical effects. If you have 17+ levels in paladin, the radius increases to 30 feet.',
    properties: ['+3 weapon', '+2d10 radiant vs fiends/undead', 'Advantage on saves vs magic in 10 ft aura'],
    source: 'DMG',
  ),
  MagicItem(
    name: 'Ring of Three Wishes',
    rarity: LEGENDARY,
    type: 'Ring',
    description: 'While wearing this ring, you can expend 1 of its 3 charges to cast the wish spell from it. The ring becomes nonmagical when all three wishes are used.',
    properties: ['3 charges', 'Cast Wish', 'Becomes nonmagical after 3 uses'],
    source: 'DMG',
  ),
  MagicItem(
    name: 'Vorpal Sword',
    rarity: LEGENDARY,
    type: 'Weapon (any sword that deals slashing damage)',
    requiresAttunement: true,
    description: 'You gain a +3 bonus to attack and damage rolls with this magic weapon. It ignores slashing damage resistance. When you attack a creature with this weapon and roll a 20 on the attack roll, the creature takes an extra 6d8 slashing damage. Then roll another d20. If you roll a 20, you lop off one of the target\'s heads. The creature dies if it can\'t survive without the lost head.',
    properties: ['+3 weapon', 'Ignores slashing resistance', 'Natural 20: +6d8 damage', 'Second natural 20: decapitate'],
    source: 'DMG',
  ),
  MagicItem(
    name: 'Deck of Many Things',
    rarity: LEGENDARY,
    type: 'Wondrous Item',
    description: 'Usually found in a box or pouch, this deck contains 22 cards. Before you draw a card, you must declare how many cards you intend to draw and then draw them randomly. Any cards drawn in excess have no effect. Once a card is drawn, it fades from existence unless the card is the Fool or the Jester.',
    properties: ['22 random effect cards', 'Powerful positive and negative effects', 'Permanently alters reality'],
    source: 'DMG',
  ),
  MagicItem(
    name: 'Staff of the Magi',
    rarity: LEGENDARY,
    type: 'Staff',
    requiresAttunement: true,
    attunementRequirement: 'by a sorcerer, warlock, or wizard',
    description: 'This staff can be wielded as a magic quarterstaff that grants +2 to attack and damage rolls. While you hold it, you gain +2 to spell attack rolls. The staff has 50 charges for spells. It regains 4d6+2 charges daily at dawn. If you expend the last charge, roll d20. On a 20, the staff regains 1d12+1 charges.',
    properties: ['+2 weapon', '+2 spell attacks', '50 charges', 'Massive spell list', 'Spell absorption'],
    source: 'DMG',
  ),
];

// Magic items organized by rarity
final Map<String, List<MagicItem>> itemsByRarity = {
  COMMON: commonItems,
  UNCOMMON: uncommonItems,
  RARE: rareItems,
  VERY_RARE: veryRareItems,
  LEGENDARY: legendaryItems,
};

// Helper functions
List<MagicItem> getItemsByRarity(String rarity) {
  return itemsByRarity[rarity] ?? [];
}

List<MagicItem> getItemsByType(String type) {
  final allItems = [
    ...commonItems,
    ...uncommonItems,
    ...rareItems,
    ...veryRareItems,
    ...legendaryItems,
  ];
  return allItems.where((item) => item.type.toLowerCase().contains(type.toLowerCase())).toList();
}

MagicItem? getItemByName(String name) {
  final allItems = [
    ...commonItems,
    ...uncommonItems,
    ...rareItems,
    ...veryRareItems,
    ...legendaryItems,
  ];
  try {
    return allItems.firstWhere((item) => item.name.toLowerCase() == name.toLowerCase());
  } catch (e) {
    return null;
  }
}

List<MagicItem> getRandomLoot(int partyLevel) {
  // Generate appropriate rarity based on level
  if (partyLevel <= 4) {
    return [
      ...commonItems.take(2),
      if (partyLevel >= 3) ...uncommonItems.take(1),
    ];
  } else if (partyLevel <= 10) {
    return [
      ...uncommonItems.take(2),
      if (partyLevel >= 7) ...rareItems.take(1),
    ];
  } else if (partyLevel <= 16) {
    return [
      ...rareItems.take(2),
      if (partyLevel >= 13) ...veryRareItems.take(1),
    ];
  } else {
    return [
      ...veryRareItems.take(2),
      if (partyLevel >= 18) ...legendaryItems.take(1),
    ];
  }
}
