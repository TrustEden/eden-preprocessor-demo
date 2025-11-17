import 'dart:math';
import '../models/item.dart';
import '../models/spell.dart';
import '../models/enhanced_character.dart';
import '../data/magic_items.dart';

enum CraftingType {
  potion,
  scroll,
  weapon,
  armor,
  wondrous,
  ammunition,
}

enum CraftingDifficulty {
  trivial, // DC 10
  easy, // DC 12
  medium, // DC 15
  hard, // DC 18
  veryHard, // DC 20
  nearlyImpossible, // DC 25
}

class CraftingRecipe {
  String id;
  String name;
  String description;
  CraftingType type;
  CraftingDifficulty difficulty;

  // Requirements
  int requiredLevel;
  String? requiredTool; // 'Alchemist Supplies', 'Smith Tools', etc.
  String? requiredProficiency;
  List<String>? requiredFeats;

  // Components
  Map<String, int> components; // component name -> quantity
  int goldCost; // GP cost for materials
  int craftingDays; // Days to complete

  // Result
  Item resultItem;

  CraftingRecipe({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.difficulty,
    required this.requiredLevel,
    this.requiredTool,
    this.requiredProficiency,
    this.requiredFeats,
    required this.components,
    required this.goldCost,
    required this.craftingDays,
    required this.resultItem,
  });

  int getDC() {
    switch (difficulty) {
      case CraftingDifficulty.trivial:
        return 10;
      case CraftingDifficulty.easy:
        return 12;
      case CraftingDifficulty.medium:
        return 15;
      case CraftingDifficulty.hard:
        return 18;
      case CraftingDifficulty.veryHard:
        return 20;
      case CraftingDifficulty.nearlyImpossible:
        return 25;
    }
  }
}

class CraftingSystem {
  static final Random _rng = Random();

  // ==================== POTION CRAFTING ====================

  static CraftingRecipe potionOfHealingRecipe() => CraftingRecipe(
        id: 'craft_potion_healing',
        name: 'Craft Potion of Healing',
        description: 'Brew a basic healing potion that restores 2d4+2 HP.',
        type: CraftingType.potion,
        difficulty: CraftingDifficulty.easy,
        requiredLevel: 3,
        requiredTool: 'Alchemist\'s Supplies',
        components: {
          'Healing herbs': 1,
          'Distilled water': 1,
        },
        goldCost: 25,
        craftingDays: 1,
        resultItem: MagicItems.potionOfHealing(),
      );

  static CraftingRecipe potionOfGreaterHealingRecipe() => CraftingRecipe(
        id: 'craft_potion_greater_healing',
        name: 'Craft Potion of Greater Healing',
        description: 'Brew a potent healing potion that restores 4d4+4 HP.',
        type: CraftingType.potion,
        difficulty: CraftingDifficulty.medium,
        requiredLevel: 5,
        requiredTool: 'Alchemist\'s Supplies',
        components: {
          'Rare healing herbs': 2,
          'Purified water': 1,
          'Silver dust': 1,
        },
        goldCost: 75,
        craftingDays: 2,
        resultItem: MagicItems.potionOfGreaterHealing(),
      );

  static CraftingRecipe potionOfInvisibilityRecipe() => CraftingRecipe(
        id: 'craft_potion_invisibility',
        name: 'Craft Potion of Invisibility',
        description: 'Create a potion that grants invisibility for 1 hour.',
        type: CraftingType.potion,
        difficulty: CraftingDifficulty.hard,
        requiredLevel: 7,
        requiredTool: 'Alchemist\'s Supplies',
        components: {
          'Essence of ether': 1,
          'Powdered diamond': 1,
          'Shadow extract': 1,
        },
        goldCost: 250,
        craftingDays: 4,
        resultItem: Item(
          id: 'potion_invisibility',
          name: 'Potion of Invisibility',
          description: 'Become invisible for 1 hour.',
          type: 'potion',
          value: 500,
        ),
      );

  // ==================== SCROLL CRAFTING ====================

  static CraftingRecipe scrollRecipe(Spell spell) {
    int spellLevel = spell.level;
    int baseDC = 10 + (spellLevel * 2);
    int baseCost = 10 + (spellLevel * 20);
    int days = 1 + (spellLevel ~/ 2);

    CraftingDifficulty difficulty;
    if (spellLevel == 0) {
      difficulty = CraftingDifficulty.trivial;
    } else if (spellLevel <= 2) {
      difficulty = CraftingDifficulty.easy;
    } else if (spellLevel <= 4) {
      difficulty = CraftingDifficulty.medium;
    } else if (spellLevel <= 6) {
      difficulty = CraftingDifficulty.hard;
    } else if (spellLevel <= 8) {
      difficulty = CraftingDifficulty.veryHard;
    } else {
      difficulty = CraftingDifficulty.nearlyImpossible;
    }

    return CraftingRecipe(
      id: 'craft_scroll_${spell.id}',
      name: 'Scribe Spell Scroll (${spell.name})',
      description: 'Create a spell scroll containing ${spell.name}.',
      type: CraftingType.scroll,
      difficulty: difficulty,
      requiredLevel: max(1, spellLevel),
      requiredTool: 'Calligrapher\'s Supplies',
      components: {
        'Parchment': 1,
        'Magical ink': spellLevel + 1,
        if (spell.components.contains('M')) 'Spell components': 1,
      },
      goldCost: baseCost,
      craftingDays: days,
      resultItem: Item(
        id: 'scroll_${spell.id}',
        name: 'Spell Scroll (${spell.name})',
        description: 'A scroll containing the ${spell.name} spell.',
        type: 'scroll',
        value: baseCost * 2,
      ),
    );
  }

  // ==================== WEAPON CRAFTING ====================

  static CraftingRecipe weaponPlus1Recipe(String weaponType) => CraftingRecipe(
        id: 'craft_weapon_plus1_${weaponType.toLowerCase()}',
        name: 'Forge +1 $weaponType',
        description: 'Create a masterwork $weaponType with a +1 magical bonus.',
        type: CraftingType.weapon,
        difficulty: CraftingDifficulty.medium,
        requiredLevel: 5,
        requiredTool: 'Smith\'s Tools',
        requiredProficiency: weaponType,
        components: {
          'Mithral ingots': 2,
          'Enchantment catalyst': 1,
          'Weapon mold': 1,
        },
        goldCost: 250,
        craftingDays: 5,
        resultItem: MagicItems.weaponPlus1(weaponType),
      );

  static CraftingRecipe armorPlus1Recipe(String armorType) => CraftingRecipe(
        id: 'craft_armor_plus1_${armorType.toLowerCase()}',
        name: 'Forge +1 $armorType',
        description: 'Create masterwork $armorType with a +1 magical bonus.',
        type: CraftingType.armor,
        difficulty: CraftingDifficulty.medium,
        requiredLevel: 5,
        requiredTool: 'Smith\'s Tools',
        components: {
          'Mithral ingots': 3,
          'Enchantment catalyst': 1,
          'Armor plates': 4,
        },
        goldCost: 250,
        craftingDays: 7,
        resultItem: MagicItems.armorPlus1(armorType),
      );

  // ==================== WONDROUS ITEM CRAFTING ====================

  static CraftingRecipe bagOfHoldingRecipe() => CraftingRecipe(
        id: 'craft_bag_of_holding',
        name: 'Create Bag of Holding',
        description: 'Enchant a bag to hold far more than its size suggests.',
        type: CraftingType.wondrous,
        difficulty: CraftingDifficulty.hard,
        requiredLevel: 7,
        requiredTool: 'Weaver\'s Tools',
        requiredProficiency: 'Arcana',
        components: {
          'Silk cloth': 5,
          'Dimensional essence': 1,
          'Enchanted thread': 10,
        },
        goldCost: 250,
        craftingDays: 10,
        resultItem: MagicItems.bagOfHolding(),
      );

  static CraftingRecipe cloakOfProtectionRecipe() => CraftingRecipe(
        id: 'craft_cloak_protection',
        name: 'Create Cloak of Protection',
        description: 'Weave a magical cloak that grants +1 to AC and saves.',
        type: CraftingType.wondrous,
        difficulty: CraftingDifficulty.medium,
        requiredLevel: 5,
        requiredTool: 'Weaver\'s Tools',
        components: {
          'Enchanted fabric': 3,
          'Protection runes': 4,
          'Silver thread': 5,
        },
        goldCost: 250,
        craftingDays: 8,
        resultItem: MagicItems.cloakOfProtection(),
      );

  // ==================== AMMUNITION CRAFTING ====================

  static CraftingRecipe silverArrowsRecipe() => CraftingRecipe(
        id: 'craft_silver_arrows',
        name: 'Craft Silver Arrows',
        description: 'Create arrows tipped with silver, effective against lycanthropes.',
        type: CraftingType.ammunition,
        difficulty: CraftingDifficulty.easy,
        requiredLevel: 1,
        requiredTool: 'Smith\'s Tools',
        components: {
          'Arrow shafts': 20,
          'Silver bars': 1,
          'Feathers': 20,
        },
        goldCost: 50,
        craftingDays: 1,
        resultItem: Item(
          id: 'silver_arrows',
          name: 'Silver Arrows (20)',
          description: '20 arrows tipped with silver. Effective against lycanthropes.',
          type: 'ammunition',
          value: 100,
        ),
      );

  // ==================== CRAFTING PROCESS ====================

  static bool canCraft(EnhancedCharacter character, CraftingRecipe recipe) {
    // Level check
    if (character.level < recipe.requiredLevel) {
      return false;
    }

    // Tool proficiency check
    if (recipe.requiredTool != null) {
      // In real implementation, check character's tool proficiencies
      // For now, just check if they have the tool
    }

    // Feat check
    if (recipe.requiredFeats != null) {
      for (var featName in recipe.requiredFeats!) {
        bool hasFeat = character.feats.any((f) => f.name == featName);
        if (!hasFeat) return false;
      }
    }

    return true;
  }

  static CraftingResult attemptCraft({
    required EnhancedCharacter character,
    required CraftingRecipe recipe,
    int? abilityModifier,
    int? proficiencyBonus,
  }) {
    if (!canCraft(character, recipe)) {
      return CraftingResult(
        success: false,
        message: 'You do not meet the requirements to craft this item.',
      );
    }

    // Roll crafting check
    int roll = _rng.nextInt(20) + 1;
    int modifier = (abilityModifier ?? 0) + (proficiencyBonus ?? 0);
    int total = roll + modifier;
    int dc = recipe.getDC();

    if (total >= dc) {
      // Success!
      return CraftingResult(
        success: true,
        message: 'You successfully craft ${recipe.resultItem.name}!',
        resultItem: recipe.resultItem,
        daysSpent: recipe.craftingDays,
        goldSpent: recipe.goldCost,
      );
    } else if (total >= dc - 5) {
      // Partial success - item created but with flaw
      return CraftingResult(
        success: true,
        message: 'You craft ${recipe.resultItem.name}, but it has a minor flaw.',
        resultItem: recipe.resultItem,
        daysSpent: recipe.craftingDays,
        goldSpent: recipe.goldCost,
        hasF law: true,
      );
    } else {
      // Failure - materials lost
      return CraftingResult(
        success: false,
        message: 'You fail to craft ${recipe.name}. Materials are lost.',
        daysSpent: recipe.craftingDays,
        goldSpent: recipe.goldCost ~/  2, // Half materials wasted
      );
    }
  }

  // ==================== RECIPE LISTS ====================

  static List<CraftingRecipe> getAllPotionRecipes() {
    return [
      potionOfHealingRecipe(),
      potionOfGreaterHealingRecipe(),
      potionOfInvisibilityRecipe(),
    ];
  }

  static List<CraftingRecipe> getAllWeaponRecipes() {
    return [
      weaponPlus1Recipe('Longsword'),
      weaponPlus1Recipe('Shortsword'),
      weaponPlus1Recipe('Battleaxe'),
      weaponPlus1Recipe('Greataxe'),
    ];
  }

  static List<CraftingRecipe> getAllArmorRecipes() {
    return [
      armorPlus1Recipe('Chain Mail'),
      armorPlus1Recipe('Leather Armor'),
      armorPlus1Recipe('Breastplate'),
    ];
  }

  static List<CraftingRecipe> getAllWondrousRecipes() {
    return [
      bagOfHoldingRecipe(),
      cloakOfProtectionRecipe(),
    ];
  }

  static List<CraftingRecipe> getAllAmmunitionRecipes() {
    return [
      silverArrowsRecipe(),
    ];
  }

  static List<CraftingRecipe> getAllRecipes() {
    return [
      ...getAllPotionRecipes(),
      ...getAllWeaponRecipes(),
      ...getAllArmorRecipes(),
      ...getAllWondrousRecipes(),
      ...getAllAmmunitionRecipes(),
    ];
  }
}

class CraftingResult {
  bool success;
  String message;
  Item? resultItem;
  int daysSpent;
  int goldSpent;
  bool hasFlaw;

  CraftingResult({
    required this.success,
    required this.message,
    this.resultItem,
    this.daysSpent = 0,
    this.goldSpent = 0,
    this.hasFlaw = false,
  });
}
