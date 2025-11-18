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
    effect: 'heal_2d4+2',
    type: 'consumable',
    weight: 1,
    value: 50,
  );

  static Item potionOfGreaterHealing() => Item(
    id: 'potion_of_greater_healing',
    name: 'Potion of Greater Healing',
    effect: 'heal_4d4+4',
    type: 'consumable',
    weight: 1,
    value: 150,
  );

  // Uncommon Magic Items
  static Item weaponPlus1(String weaponType) => Item(
    id: '${weaponType}_plus1',
    name: '+1 $weaponType',
    effect: 'This magic weapon has a +1 bonus to attack and damage rolls.',
    type: 'weapon',
    weight: 3,
    value: 500,
    damageDice: weaponType == 'Longsword' ? '1d8+1' : '1d6+1',
    damageType: 'martial',
  );

  static Item armorPlus1(String armorType) => Item(
    id: '${armorType}_plus1',
    name: '+1 $armorType',
    effect: 'This magic armor has a +1 bonus to AC.',
    type: 'armor',
    weight: 20,
    value: 500,
    armorBonus: armorType == 'Chain Mail' ? 17 : 12,
    armorType: 'medium',
  );

  static Item cloakOfProtection() => Item(
    id: 'cloak_of_protection',
    name: 'Cloak of Protection',
    effect: 'You gain a +1 bonus to AC and saving throws while wearing this cloak.',
    type: 'misc',
    weight: 1,
    value: 500,
  );

  static Item bootsOfElvenkind() => Item(
    id: 'boots_of_elvenkind',
    name: 'Boots of Elvenkind',
    effect: 'While you wear these boots, your steps make no sound, and you have advantage on Stealth checks that rely on moving silently.',
    type: 'misc',
    value: 500,
  );

  static Item bagOfHolding() => Item(
    id: 'bag_of_holding',
    name: 'Bag of Holding',
    effect: 'This bag has an interior space considerably larger than its outside dimensions. The bag can hold up to 500 pounds, not exceeding a volume of 64 cubic feet.',
    type: 'misc',
    value: 500,
  );

  // Rare Magic Items
  static Item weaponPlus2(String weaponType) => Item(
    id: '${weaponType}_plus2',
    name: '+2 $weaponType',
    effect: 'This magic weapon has a +2 bonus to attack and damage rolls.',
    type: 'weapon',
    weight: 3,
    value: 2000,
    damageDice: weaponType == 'Longsword' ? '1d8+2' : '1d6+2',
    damageType: 'martial',
  );

  static Item armorPlus2(String armorType) => Item(
    id: '${armorType}_plus2',
    name: '+2 $armorType',
    effect: 'This magic armor has a +2 bonus to AC.',
    type: 'armor',
    weight: 20,
    value: 2000,
    armorBonus: armorType == 'Chain Mail' ? 18 : 13,
    armorType: 'medium',
  );

  static Item ringOfProtection() => Item(
    id: 'ring_of_protection',
    name: 'Ring of Protection',
    effect: 'You gain a +1 bonus to AC and saving throws while wearing this ring.',
    type: 'misc',
    weight: 1,
    value: 2000,
  );

  static Item flameTounge() => Item(
    id: 'flame_tongue',
    name: 'Flame Tongue',
    effect: 'You can use a bonus action to cause flames to erupt from the blade. While the sword is ablaze, it deals an extra 2d6 fire damage.',
    type: 'weapon',
    value: 5000,
    damageDice: '1d8',
    damageType: 'martial',
  );

  static Item wandOfFireballs() => Item(
    id: 'wand_of_fireballs',
    name: 'Wand of Fireballs',
    effect: 'This wand has 7 charges. You can expend charges to cast fireball (save DC 15). The wand regains 1d6 + 1 charges daily at dawn.',
    type: 'misc',
    weight: 1,
    value: 8000,
  );

  // Very Rare Magic Items
  static Item weaponPlus3(String weaponType) => Item(
    id: '${weaponType}_plus3',
    name: '+3 $weaponType',
    effect: 'This magic weapon has a +3 bonus to attack and damage rolls.',
    type: 'weapon',
    weight: 3,
    value: 10000,
    damageDice: weaponType == 'Longsword' ? '1d8+3' : '1d6+3',
    damageType: 'martial',
  );

  static Item armorPlus3(String armorType) => Item(
    id: '${armorType}_plus3',
    name: '+3 $armorType',
    effect: 'This magic armor has a +3 bonus to AC.',
    type: 'armor',
    weight: 20,
    value: 10000,
    armorBonus: armorType == 'Chain Mail' ? 19 : 14,
    armorType: 'medium',
  );

  static Item staffOfPower() => Item(
    id: 'staff_of_power',
    name: 'Staff of Power',
    effect: 'This staff grants a +2 bonus to AC, saving throws, and spell attack rolls. It has 20 charges and can cast many powerful spells.',
    type: 'misc',
    value: 50000,
  );

  static Item beltOfGiantStrength() => Item(
    id: 'belt_of_giant_strength',
    name: 'Belt of Giant Strength',
    effect: 'While wearing this belt, your Strength score changes to 27.',
    type: 'misc',
    value: 20000,
  );

  // Legendary Magic Items
  static Item holyAvenger() => Item(
    id: 'holy_avenger',
    name: 'Holy Avenger',
    effect: 'This legendary longsword grants a +3 bonus and deals extra radiant damage to fiends and undead. Requires attunement by a paladin.',
    type: 'weapon',
    weight: 3,
    value: 100000,
    damageDice: '1d8+3',
    damageType: 'martial',
  );

  static Item vorpalSword() => Item(
    id: 'vorpal_sword',
    name: 'Vorpal Sword',
    effect: 'This legendary sword has a +3 bonus. On a roll of 20, it severs the target\'s head.',
    type: 'weapon',
    value: 150000,
    damageDice: '1d8+3',
    damageType: 'martial',
  );

  static Item robeOfTheArchmagi() => Item(
    id: 'robe_of_the_archmagi',
    name: 'Robe of the Archmagi',
    effect: 'This robe grants AC 15 + Dex mod, advantage on saves vs. spells, and increases spell save DC and attack bonus by 2.',
    type: 'misc',
    value: 100000,
  );

  static Item ringOfThreeWishes() => Item(
    id: 'ring_of_three_wishes',
    name: 'Ring of Three Wishes',
    effect: 'This ring has 3 charges, each allowing you to cast the wish spell.',
    type: 'misc',
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
