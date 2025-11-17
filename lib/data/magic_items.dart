import '../models/item.dart';

enum ItemRarity {
  common,
  uncommon,
  rare,
  veryRare,
  legendary,
  artifact,
}

class MagicItems {
  // Common Magic Items
  static Item potionOfHealing() => Item(
    id: 'potion_of_healing',
    name: 'Potion of Healing',
    description: 'You regain 2d4 + 2 hit points when you drink this potion.',
    type: 'potion',
    value: 50,
    healingDice: '2d4+2',
  );

  static Item potionOfGreaterHealing() => Item(
    id: 'potion_of_greater_healing',
    name: 'Potion of Greater Healing',
    description: 'You regain 4d4 + 4 hit points when you drink this potion.',
    type: 'potion',
    value: 150,
    healingDice: '4d4+4',
  );

  // Uncommon Magic Items
  static Item weaponPlus1(String weaponType) => Item(
    id: '${weaponType}_plus1',
    name: '+1 $weaponType',
    description: 'This magic weapon has a +1 bonus to attack and damage rolls.',
    type: 'weapon',
    value: 500,
    weaponDamage: weaponType == 'Longsword' ? '1d8+1' : '1d6+1',
    weaponType: 'martial',
  );

  static Item armorPlus1(String armorType) => Item(
    id: '${armorType}_plus1',
    name: '+1 $armorType',
    description: 'This magic armor has a +1 bonus to AC.',
    type: 'armor',
    value: 500,
    armorBonus: armorType == 'Chain Mail' ? 17 : 12,
    armorType: 'medium',
  );

  static Item cloakOfProtection() => Item(
    id: 'cloak_of_protection',
    name: 'Cloak of Protection',
    description: 'You gain a +1 bonus to AC and saving throws while wearing this cloak.',
    type: 'wondrous',
    value: 500,
  );

  static Item bootsOfElvenkind() => Item(
    id: 'boots_of_elvenkind',
    name: 'Boots of Elvenkind',
    description: 'While you wear these boots, your steps make no sound, and you have advantage on Stealth checks that rely on moving silently.',
    type: 'wondrous',
    value: 500,
  );

  static Item bagOfHolding() => Item(
    id: 'bag_of_holding',
    name: 'Bag of Holding',
    description: 'This bag has an interior space considerably larger than its outside dimensions. The bag can hold up to 500 pounds, not exceeding a volume of 64 cubic feet.',
    type: 'wondrous',
    value: 500,
  );

  // Rare Magic Items
  static Item weaponPlus2(String weaponType) => Item(
    id: '${weaponType}_plus2',
    name: '+2 $weaponType',
    description: 'This magic weapon has a +2 bonus to attack and damage rolls.',
    type: 'weapon',
    value: 2000,
    weaponDamage: weaponType == 'Longsword' ? '1d8+2' : '1d6+2',
    weaponType: 'martial',
  );

  static Item armorPlus2(String armorType) => Item(
    id: '${armorType}_plus2',
    name: '+2 $armorType',
    description: 'This magic armor has a +2 bonus to AC.',
    type: 'armor',
    value: 2000,
    armorBonus: armorType == 'Chain Mail' ? 18 : 13,
    armorType: 'medium',
  );

  static Item ringOfProtection() => Item(
    id: 'ring_of_protection',
    name: 'Ring of Protection',
    description: 'You gain a +1 bonus to AC and saving throws while wearing this ring.',
    type: 'ring',
    value: 2000,
  );

  static Item flameTounge() => Item(
    id: 'flame_tongue',
    name: 'Flame Tongue',
    description: 'You can use a bonus action to cause flames to erupt from the blade. While the sword is ablaze, it deals an extra 2d6 fire damage.',
    type: 'weapon',
    value: 5000,
    weaponDamage: '1d8',
    weaponType: 'martial',
  );

  static Item wandOfFireballs() => Item(
    id: 'wand_of_fireballs',
    name: 'Wand of Fireballs',
    description: 'This wand has 7 charges. You can expend charges to cast fireball (save DC 15). The wand regains 1d6 + 1 charges daily at dawn.',
    type: 'wand',
    value: 8000,
  );

  // Very Rare Magic Items
  static Item weaponPlus3(String weaponType) => Item(
    id: '${weaponType}_plus3',
    name: '+3 $weaponType',
    description: 'This magic weapon has a +3 bonus to attack and damage rolls.',
    type: 'weapon',
    value: 10000,
    weaponDamage: weaponType == 'Longsword' ? '1d8+3' : '1d6+3',
    weaponType: 'martial',
  );

  static Item armorPlus3(String armorType) => Item(
    id: '${armorType}_plus3',
    name: '+3 $armorType',
    description: 'This magic armor has a +3 bonus to AC.',
    type: 'armor',
    value: 10000,
    armorBonus: armorType == 'Chain Mail' ? 19 : 14,
    armorType: 'medium',
  );

  static Item staffOfPower() => Item(
    id: 'staff_of_power',
    name: 'Staff of Power',
    description: 'This staff grants a +2 bonus to AC, saving throws, and spell attack rolls. It has 20 charges and can cast many powerful spells.',
    type: 'staff',
    value: 50000,
  );

  static Item beltOfGiantStrength() => Item(
    id: 'belt_of_giant_strength',
    name: 'Belt of Giant Strength',
    description: 'While wearing this belt, your Strength score changes to 27.',
    type: 'wondrous',
    value: 20000,
  );

  // Legendary Magic Items
  static Item holyAvenger() => Item(
    id: 'holy_avenger',
    name: 'Holy Avenger',
    description: 'This legendary longsword grants a +3 bonus and deals extra radiant damage to fiends and undead. Requires attunement by a paladin.',
    type: 'weapon',
    value: 100000,
    weaponDamage: '1d8+3',
    weaponType: 'martial',
  );

  static Item vorpalSword() => Item(
    id: 'vorpal_sword',
    name: 'Vorpal Sword',
    description: 'This legendary sword has a +3 bonus. On a roll of 20, it severs the target\'s head.',
    type: 'weapon',
    value: 150000,
    weaponDamage: '1d8+3',
    weaponType: 'martial',
  );

  static Item robeOfTheArchmagi() => Item(
    id: 'robe_of_the_archmagi',
    name: 'Robe of the Archmagi',
    description: 'This robe grants AC 15 + Dex mod, advantage on saves vs. spells, and increases spell save DC and attack bonus by 2.',
    type: 'wondrous',
    value: 100000,
  );

  static Item ringOfThreeWishes() => Item(
    id: 'ring_of_three_wishes',
    name: 'Ring of Three Wishes',
    description: 'This ring has 3 charges, each allowing you to cast the wish spell.',
    type: 'ring',
    value: 500000,
  );

  static List<Item> getCommonItems() {
    return [
      potionOfHealing(),
      potionOfGreaterHealing(),
    ];
  }

  static List<Item> getUncommonItems() {
    return [
      weaponPlus1('Longsword'),
      weaponPlus1('Shortsword'),
      armorPlus1('Chain Mail'),
      cloakOfProtection(),
      bootsOfElvenkind(),
      bagOfHolding(),
    ];
  }

  static List<Item> getRareItems() {
    return [
      weaponPlus2('Longsword'),
      armorPlus2('Chain Mail'),
      ringOfProtection(),
      flameTounge(),
      wandOfFireballs(),
    ];
  }

  static List<Item> getVeryRareItems() {
    return [
      weaponPlus3('Longsword'),
      armorPlus3('Chain Mail'),
      staffOfPower(),
      beltOfGiantStrength(),
    ];
  }

  static List<Item> getLegendaryItems() {
    return [
      holyAvenger(),
      vorpalSword(),
      robeOfTheArchmagi(),
      ringOfThreeWishes(),
    ];
  }

  static List<Item> getAllMagicItems() {
    return [
      ...getCommonItems(),
      ...getUncommonItems(),
      ...getRareItems(),
      ...getVeryRareItems(),
      ...getLegendaryItems(),
    ];
  }

  static Item? getRandomItemByRarity(ItemRarity rarity) {
    List<Item> items = [];
    switch (rarity) {
      case ItemRarity.common:
        items = getCommonItems();
        break;
      case ItemRarity.uncommon:
        items = getUncommonItems();
        break;
      case ItemRarity.rare:
        items = getRareItems();
        break;
      case ItemRarity.veryRare:
        items = getVeryRareItems();
        break;
      case ItemRarity.legendary:
        items = getLegendaryItems();
        break;
      default:
        items = getCommonItems();
    }

    if (items.isEmpty) return null;
    items.shuffle();
    return items.first;
  }
}
