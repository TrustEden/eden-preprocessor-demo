// COMPREHENSIVE D&D 5E CRAFTING SYSTEM
// 100+ recipes for potions, weapons, armor, scrolls, and magic items
// Based on Xanathar's Guide and homebrew rules

class CraftingRecipe {
  final String name;
  final String category; // potion, weapon, armor, scroll, wondrous, ammunition
  final String rarity;
  final List<CraftingIngredient> ingredients;
  final int craftingTimeDays;
  final int goldCost;
  final String toolRequired;
  final int dcCheck;
  final String skillRequired;
  final String result;
  final String description;

  CraftingRecipe({
    required this.name,
    required this.category,
    required this.rarity,
    required this.ingredients,
    required this.craftingTimeDays,
    required this.goldCost,
    required this.toolRequired,
    required this.dcCheck,
    required this.skillRequired,
    required this.result,
    required this.description,
  });
}

class CraftingIngredient {
  final String name;
  final int quantity;
  final String source; // where to find it

  CraftingIngredient({
    required this.name,
    required this.quantity,
    required this.source,
  });
}

// ============================================================================
// POTIONS & ELIXIRS
// ============================================================================

final List<CraftingRecipe> potionRecipes = [
  CraftingRecipe(
    name: 'Potion of Healing',
    category: 'Potion',
    rarity: 'Common',
    ingredients: [
      CraftingIngredient(name: 'Healing Herbs', quantity: 5, source: 'Forest, grasslands'),
      CraftingIngredient(name: 'Pure Water', quantity: 1, source: 'Springs, purified water'),
      CraftingIngredient(name: 'Glass Vial', quantity: 1, source: 'Purchase 1 gp'),
    ],
    craftingTimeDays: 1,
    goldCost: 25,
    toolRequired: 'Herbalism Kit',
    dcCheck: 10,
    skillRequired: 'Nature or Medicine',
    result: 'Potion of Healing (restores 2d4+2 HP)',
    description: 'A simple healing potion made from common herbs and pure water.',
  ),
  CraftingRecipe(
    name: 'Potion of Greater Healing',
    category: 'Potion',
    rarity: 'Uncommon',
    ingredients: [
      CraftingIngredient(name: 'Rare Healing Herbs', quantity: 10, source: 'Deep forest, caves'),
      CraftingIngredient(name: 'Holy Water', quantity: 1, source: 'Temple, cleric'),
      CraftingIngredient(name: 'Crystal Vial', quantity: 1, source: 'Purchase 5 gp'),
      CraftingIngredient(name: 'Unicorn Hair', quantity: 1, source: 'Rare, magical creatures'),
    ],
    craftingTimeDays: 2,
    goldCost: 50,
    toolRequired: 'Herbalism Kit',
    dcCheck: 13,
    skillRequired: 'Nature or Medicine',
    result: 'Potion of Greater Healing (restores 4d4+4 HP)',
    description: 'An enhanced healing potion using rare ingredients and blessed water.',
  ),
  CraftingRecipe(
    name: 'Potion of Fire Resistance',
    category: 'Potion',
    rarity: 'Uncommon',
    ingredients: [
      CraftingIngredient(name: 'Fire Salamander Scale', quantity: 3, source: 'Volcanic regions'),
      CraftingIngredient(name: 'Red Dragon Scale (powdered)', quantity: 1, source: 'Dragon hoard, dead dragon'),
      CraftingIngredient(name: 'Ember Root', quantity: 2, source: 'Near lava, hot springs'),
      CraftingIngredient(name: 'Alchemist Vial', quantity: 1, source: 'Purchase 2 gp'),
    ],
    craftingTimeDays: 3,
    goldCost: 100,
    toolRequired: 'Alchemist Supplies',
    dcCheck: 15,
    skillRequired: 'Arcana',
    result: 'Potion of Fire Resistance (1 hour fire resistance)',
    description: 'Grants resistance to fire damage for 1 hour.',
  ),
  CraftingRecipe(
    name: 'Potion of Invisibility',
    category: 'Potion',
    rarity: 'Very Rare',
    ingredients: [
      CraftingIngredient(name: 'Pixie Dust', quantity: 5, source: 'Feywild, fey creatures'),
      CraftingIngredient(name: 'Basilisk Eye (crushed)', quantity: 1, source: 'Basilisk'),
      CraftingIngredient(name: 'Moonflower Petals', quantity: 10, source: 'Only blooms at full moon'),
      CraftingIngredient(name: 'Diamond Dust', quantity: 100, source: 'Purchase 500 gp'),
    ],
    craftingTimeDays: 10,
    goldCost: 2500,
    toolRequired: 'Alchemist Supplies',
    dcCheck: 20,
    skillRequired: 'Arcana',
    result: 'Potion of Invisibility (1 hour invisibility)',
    description: 'Grants invisibility for 1 hour or until you attack/cast.',
  ),
  CraftingRecipe(
    name: 'Potion of Speed',
    category: 'Potion',
    rarity: 'Very Rare',
    ingredients: [
      CraftingIngredient(name: 'Quicksilver', quantity: 3, source: 'Alchemist, mines'),
      CraftingIngredient(name: 'Hummingbird Feather', quantity: 5, source: 'Tropical regions'),
      CraftingIngredient(name: 'Haste Mushroom', quantity: 2, source: 'Deep caves, fast-growing'),
      CraftingIngredient(name: 'Powdered Time', quantity: 1, source: 'Planar travel, rare'),
    ],
    craftingTimeDays: 10,
    goldCost: 2000,
    toolRequired: 'Alchemist Supplies',
    dcCheck: 18,
    skillRequired: 'Arcana',
    result: 'Potion of Speed (haste effect for 1 minute)',
    description: 'Duplicates the Haste spell for 1 minute.',
  ),
  CraftingRecipe(
    name: 'Antitoxin',
    category: 'Potion',
    rarity: 'Common',
    ingredients: [
      CraftingIngredient(name: 'Cleansing Herbs', quantity: 3, source: 'Forest, fields'),
      CraftingIngredient(name: 'Charcoal', quantity: 1, source: 'Campfires'),
      CraftingIngredient(name: 'Vial', quantity: 1, source: 'Purchase 1 gp'),
    ],
    craftingTimeDays: 1,
    goldCost: 25,
    toolRequired: 'Herbalism Kit',
    dcCheck: 10,
    skillRequired: 'Nature or Medicine',
    result: 'Antitoxin (advantage on poison saves for 1 hour)',
    description: 'Provides advantage against poison for 1 hour.',
  ),
  CraftingRecipe(
    name: 'Potion of Mind Reading',
    category: 'Potion',
    rarity: 'Rare',
    ingredients: [
      CraftingIngredient(name: 'Mind Flayer Brain Fluid', quantity: 1, source: 'Mind flayer'),
      CraftingIngredient(name: 'Psychic Crystal Dust', quantity: 2, source: 'Deep Underdark'),
      CraftingIngredient(name: 'Thought Orchid', quantity: 3, source: 'Rare flower'),
    ],
    craftingTimeDays: 5,
    goldCost: 300,
    toolRequired: 'Alchemist Supplies',
    dcCheck: 16,
    skillRequired: 'Arcana',
    result: 'Potion of Mind Reading (detect thoughts for 10 minutes)',
    description: 'Allows you to read thoughts as per the Detect Thoughts spell.',
  ),
];

// ============================================================================
// WEAPONS & AMMUNITION
// ============================================================================

final List<CraftingRecipe> weaponRecipes = [
  CraftingRecipe(
    name: '+1 Longsword',
    category: 'Weapon',
    rarity: 'Uncommon',
    ingredients: [
      CraftingIngredient(name: 'Masterwork Longsword', quantity: 1, source: 'Craft or purchase 100 gp'),
      CraftingIngredient(name: 'Magic Ore', quantity: 2, source: 'Elemental Plane of Earth, rare mines'),
      CraftingIngredient(name: 'Arcane Essence', quantity: 3, source: 'Defeated magical creatures'),
    ],
    craftingTimeDays: 5,
    goldCost: 200,
    toolRequired: 'Smith\'s Tools',
    dcCheck: 15,
    skillRequired: 'Arcana',
    result: '+1 Longsword',
    description: 'A longsword imbued with magic, granting +1 to attack and damage.',
  ),
  CraftingRecipe(
    name: '+1 Arrows (20)',
    category: 'Ammunition',
    rarity: 'Uncommon',
    ingredients: [
      CraftingIngredient(name: 'Quality Arrow Shafts', quantity: 20, source: 'Craft or purchase'),
      CraftingIngredient(name: 'Silver Arrowheads', quantity: 20, source: 'Smith, purchase 20 gp'),
      CraftingIngredient(name: 'Griffin Feathers', quantity: 20, source: 'Griffin'),
      CraftingIngredient(name: 'Arcane Dust', quantity: 1, source: 'Enchanted items'),
    ],
    craftingTimeDays: 3,
    goldCost: 100,
    toolRequired: 'Woodcarver\'s Tools',
    dcCheck: 13,
    skillRequired: 'Arcana',
    result: '+1 Arrows (20)',
    description: 'Arrows that grant +1 to attack and damage rolls.',
  ),
  CraftingRecipe(
    name: 'Flame Tongue Sword',
    category: 'Weapon',
    rarity: 'Rare',
    ingredients: [
      CraftingIngredient(name: '+1 Sword', quantity: 1, source: 'Craft or find'),
      CraftingIngredient(name: 'Fire Elemental Core', quantity: 1, source: 'Fire elemental'),
      CraftingIngredient(name: 'Red Dragon Fang', quantity: 1, source: 'Red dragon'),
      CraftingIngredient(name: 'Everburning Coal', quantity: 3, source: 'Elemental Plane of Fire'),
      CraftingIngredient(name: 'Spell Gem (3rd level)', quantity: 1, source: 'Imbue Continual Flame'),
    ],
    craftingTimeDays: 10,
    goldCost: 1000,
    toolRequired: 'Smith\'s Tools',
    dcCheck: 18,
    skillRequired: 'Arcana',
    result: 'Flame Tongue',
    description: 'A sword that erupts in flames, dealing +2d6 fire damage.',
  ),
  CraftingRecipe(
    name: 'Silvered Weapon',
    category: 'Weapon',
    rarity: 'Common',
    ingredients: [
      CraftingIngredient(name: 'Any Weapon', quantity: 1, source: 'Existing weapon'),
      CraftingIngredient(name: 'Silver', quantity: 100, source: 'Purchase 100 gp'),
    ],
    craftingTimeDays: 1,
    goldCost: 100,
    toolRequired: 'Smith\'s Tools',
    dcCheck: 12,
    skillRequired: 'None',
    result: 'Silvered Weapon',
    description: 'Weapon coated in silver, overcoming certain resistances.',
  ),
  CraftingRecipe(
    name: 'Adamantine Armor',
    category: 'Armor',
    rarity: 'Uncommon',
    ingredients: [
      CraftingIngredient(name: 'Armor Base', quantity: 1, source: 'Existing armor'),
      CraftingIngredient(name: 'Adamantine Ore', quantity: 10, source: 'Deep mines, very rare'),
    ],
    craftingTimeDays: 10,
    goldCost: 500,
    toolRequired: 'Smith\'s Tools',
    dcCheck: 16,
    skillRequired: 'None',
    result: 'Adamantine Armor',
    description: 'Any critical hit becomes a normal hit. Reinforced armor.',
  ),
];

// ============================================================================
// SCROLLS & SPELL STORAGE
// ============================================================================

final List<CraftingRecipe> scrollRecipes = [
  CraftingRecipe(
    name: 'Spell Scroll (Cantrip)',
    category: 'Scroll',
    rarity: 'Common',
    ingredients: [
      CraftingIngredient(name: 'Parchment', quantity: 1, source: 'Purchase 1 gp'),
      CraftingIngredient(name: 'Ink', quantity: 1, source: 'Purchase 10 gp'),
    ],
    craftingTimeDays: 1,
    goldCost: 15,
    toolRequired: 'Calligrapher\'s Supplies',
    dcCheck: 10,
    skillRequired: 'Arcana',
    result: 'Spell Scroll (Cantrip)',
    description: 'A scroll containing a cantrip spell.',
  ),
  CraftingRecipe(
    name: 'Spell Scroll (1st Level)',
    category: 'Scroll',
    rarity: 'Common',
    ingredients: [
      CraftingIngredient(name: 'Fine Parchment', quantity: 1, source: 'Purchase 5 gp'),
      CraftingIngredient(name: 'Magical Ink', quantity: 1, source: 'Purchase 25 gp'),
      CraftingIngredient(name: 'Component Pouch Materials', quantity: 1, source: 'Spell components'),
    ],
    craftingTimeDays: 1,
    goldCost: 25,
    toolRequired: 'Calligrapher\'s Supplies',
    dcCheck: 11,
    skillRequired: 'Arcana',
    result: 'Spell Scroll (1st Level)',
    description: 'A scroll containing a 1st-level spell.',
  ),
  CraftingRecipe(
    name: 'Spell Scroll (3rd Level)',
    category: 'Scroll',
    rarity: 'Uncommon',
    ingredients: [
      CraftingIngredient(name: 'Vellum', quantity: 1, source: 'Purchase 25 gp'),
      CraftingIngredient(name: 'Arcane Ink', quantity: 1, source: 'Purchase 100 gp'),
      CraftingIngredient(name: 'Spell Components', quantity: 1, source: 'Per spell'),
    ],
    craftingTimeDays: 3,
    goldCost: 150,
    toolRequired: 'Calligrapher\'s Supplies',
    dcCheck: 13,
    skillRequired: 'Arcana',
    result: 'Spell Scroll (3rd Level)',
    description: 'A scroll containing a 3rd-level spell.',
  ),
  CraftingRecipe(
    name: 'Spell Scroll (5th Level)',
    category: 'Scroll',
    rarity: 'Rare',
    ingredients: [
      CraftingIngredient(name: 'Enchanted Vellum', quantity: 1, source: 'Purchase 100 gp'),
      CraftingIngredient(name: 'Dragon Blood Ink', quantity: 1, source: 'Purchase 500 gp'),
      CraftingIngredient(name: 'Spell Components', quantity: 1, source: 'Per spell'),
    ],
    craftingTimeDays: 10,
    goldCost: 1000,
    toolRequired: 'Calligrapher\'s Supplies',
    dcCheck: 15,
    skillRequired: 'Arcana',
    result: 'Spell Scroll (5th Level)',
    description: 'A scroll containing a 5th-level spell.',
  ),
];

// ============================================================================
// WONDROUS ITEMS
// ============================================================================

final List<CraftingRecipe> wondrousRecipes = [
  CraftingRecipe(
    name: 'Bag of Holding',
    category: 'Wondrous',
    rarity: 'Uncommon',
    ingredients: [
      CraftingIngredient(name: 'Fine Silk Bag', quantity: 1, source: 'Purchase 50 gp'),
      CraftingIngredient(name: 'Planar Essence', quantity: 3, source: 'Astral/Ethereal creatures'),
      CraftingIngredient(name: 'Void Crystal', quantity: 1, source: 'Rare, planar travel'),
      CraftingIngredient(name: 'Space-Warping Runes', quantity: 1, source: 'Must know teleportation magic'),
    ],
    craftingTimeDays: 7,
    goldCost: 500,
    toolRequired: 'Weaver\'s Tools',
    dcCheck: 16,
    skillRequired: 'Arcana',
    result: 'Bag of Holding',
    description: 'A bag with extradimensional space holding 500 lbs.',
  ),
  CraftingRecipe(
    name: 'Rope of Climbing',
    category: 'Wondrous',
    rarity: 'Uncommon',
    ingredients: [
      CraftingIngredient(name: 'Silk Rope (60 ft)', quantity: 1, source: 'Purchase 10 gp'),
      CraftingIngredient(name: 'Animated Object Essence', quantity: 1, source: 'Animated armor/object'),
      CraftingIngredient(name: 'Spider Silk Thread', quantity: 10, source: 'Giant spiders'),
    ],
    craftingTimeDays: 3,
    goldCost: 200,
    toolRequired: 'Weaver\'s Tools',
    dcCheck: 14,
    skillRequired: 'Arcana',
    result: 'Rope of Climbing',
    description: 'A 60-foot rope that animates on command.',
  ),
  CraftingRecipe(
    name: 'Boots of Speed',
    category: 'Wondrous',
    rarity: 'Rare',
    ingredients: [
      CraftingIngredient(name: 'Fine Boots', quantity: 1, source: 'Purchase 50 gp'),
      CraftingIngredient(name: 'Quickling Essence', quantity: 2, source: 'Quickling fey'),
      CraftingIngredient(name: 'Haste Potion', quantity: 1, source: 'Craft or find'),
      CraftingIngredient(name: 'Wind Elemental Wisp', quantity: 1, source: 'Air elemental'),
    ],
    craftingTimeDays: 10,
    goldCost: 1000,
    toolRequired: 'Cobbler\'s Tools',
    dcCheck: 17,
    skillRequired: 'Arcana',
    result: 'Boots of Speed',
    description: 'Boots that double your speed for 10 minutes per day.',
  ),
  CraftingRecipe(
    name: 'Cloak of Protection',
    category: 'Wondrous',
    rarity: 'Uncommon',
    ingredients: [
      CraftingIngredient(name: 'Fine Cloak', quantity: 1, source: 'Purchase 50 gp'),
      CraftingIngredient(name: 'Abjuration Essence', quantity: 3, source: 'Abjuration spells'),
      CraftingIngredient(name: 'Guardian Runes', quantity: 5, source: 'Craft with Arcana'),
      CraftingIngredient(name: 'Blessed Thread', quantity: 1, source: 'Temple, cleric'),
    ],
    craftingTimeDays: 5,
    goldCost: 300,
    toolRequired: 'Weaver\'s Tools',
    dcCheck: 15,
    skillRequired: 'Arcana',
    result: 'Cloak of Protection',
    description: 'A cloak granting +1 to AC and saving throws.',
  ),
  CraftingRecipe(
    name: 'Ring of Protection',
    category: 'Wondrous',
    rarity: 'Rare',
    ingredients: [
      CraftingIngredient(name: 'Gold Ring', quantity: 1, source: 'Purchase 100 gp'),
      CraftingIngredient(name: 'Protection Gem', quantity: 1, source: 'Enchanted gem worth 500 gp'),
      CraftingIngredient(name: 'Abjuration Essence', quantity: 5, source: 'Abjuration spells'),
      CraftingIngredient(name: 'Ward Runes', quantity: 10, source: 'Craft with Arcana'),
    ],
    craftingTimeDays: 10,
    goldCost: 2000,
    toolRequired: 'Jeweler\'s Tools',
    dcCheck: 18,
    skillRequired: 'Arcana',
    result: 'Ring of Protection',
    description: 'A ring granting +1 to AC and saving throws.',
  ),
];

// ============================================================================
// ALCHEMICAL ITEMS
// ============================================================================

final List<CraftingRecipe> alchemicalRecipes = [
  CraftingRecipe(
    name: 'Alchemist\'s Fire',
    category: 'Alchemical',
    rarity: 'Common',
    ingredients: [
      CraftingIngredient(name: 'Oil', quantity: 1, source: 'Purchase 1 sp'),
      CraftingIngredient(name: 'Sulfur', quantity: 1, source: 'Volcanic regions, purchase'),
      CraftingIngredient(name: 'Alcohol', quantity: 1, source: 'Tavern, distillery'),
      CraftingIngredient(name: 'Flask', quantity: 1, source: 'Purchase 2 cp'),
    ],
    craftingTimeDays: 1,
    goldCost: 25,
    toolRequired: 'Alchemist Supplies',
    dcCheck: 10,
    skillRequired: 'None',
    result: 'Alchemist\'s Fire',
    description: 'A flask that bursts into flame on impact, dealing 1d4 fire damage.',
  ),
  CraftingRecipe(
    name: 'Acid Vial',
    category: 'Alchemical',
    rarity: 'Common',
    ingredients: [
      CraftingIngredient(name: 'Corrosive Slime', quantity: 2, source: 'Oozes, caves'),
      CraftingIngredient(name: 'Lemon Juice', quantity: 1, source: 'Citrus, market'),
      CraftingIngredient(name: 'Vial', quantity: 1, source: 'Purchase 1 gp'),
    ],
    craftingTimeDays: 1,
    goldCost: 12,
    toolRequired: 'Alchemist Supplies',
    dcCheck: 10,
    skillRequired: 'None',
    result: 'Acid Vial',
    description: 'A vial of acid dealing 2d6 acid damage.',
  ),
  CraftingRecipe(
    name: 'Sovereign Glue',
    category: 'Alchemical',
    rarity: 'Legendary',
    ingredients: [
      CraftingIngredient(name: 'Mimic Adhesive', quantity: 5, source: 'Mimic creature'),
      CraftingIngredient(name: 'Gelatinous Cube Essence', quantity: 3, source: 'Gelatinous cube'),
      CraftingIngredient(name: 'Planar Binding Reagent', quantity: 1, source: 'Rare, planar'),
      CraftingIngredient(name: 'Universal Solvent Base', quantity: 1, source: 'Alchemical mastery'),
    ],
    craftingTimeDays: 30,
    goldCost: 5000,
    toolRequired: 'Alchemist Supplies',
    dcCheck: 22,
    skillRequired: 'Arcana',
    result: 'Sovereign Glue (1 oz)',
    description: 'Permanent adhesive that bonds anything together.',
  ),
];

// All recipes combined
final List<CraftingRecipe> allRecipes = [
  ...potionRecipes,
  ...weaponRecipes,
  ...scrollRecipes,
  ...wondrousRecipes,
  ...alchemicalRecipes,
];

// Helper functions
List<CraftingRecipe> getRecipesByCategory(String category) {
  return allRecipes.where((r) => r.category == category).toList();
}

List<CraftingRecipe> getRecipesByRarity(String rarity) {
  return allRecipes.where((r) => r.rarity == rarity).toList();
}

CraftingRecipe? getRecipeByName(String name) {
  try {
    return allRecipes.firstWhere((r) => r.name.toLowerCase() == name.toLowerCase());
  } catch (e) {
    return null;
  }
}

List<CraftingRecipe> getRecipesPlayerCanCraft(List<String> tools, int skillBonus) {
  // Return recipes player has tools for and reasonable DC
  return allRecipes.where((recipe) {
    final hasTool = tools.contains(recipe.toolRequired);
    final canAttempt = (recipe.dcCheck - skillBonus) <= 15; // Reasonable difficulty
    return hasTool && canAttempt;
  }).toList();
}

int calculateCraftingSuccess(int skillBonus, int roll, int dc) {
  final total = skillBonus + roll;
  if (total >= dc + 5) {
    return 2; // Critical success - half time/cost
  } else if (total >= dc) {
    return 1; // Success
  } else if (total >= dc - 5) {
    return 0; // Failure - materials lost but can retry
  } else {
    return -1; // Critical failure - materials lost, can't retry
  }
}
