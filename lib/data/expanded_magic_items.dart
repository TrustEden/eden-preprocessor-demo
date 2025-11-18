import '../models/item.dart';
import 'magic_items.dart';

/// Comprehensive D&D 5e Magic Items Database - 100+ Items
class ExpandedMagicItems {
  // ==================== COMMON MAGIC ITEMS ====================

  static Item potionOfHealing() => MagicItems.potionOfHealing();

  static Item potionOfGreaterHealing() => MagicItems.potionOfGreaterHealing();

  static Item potionOfClimbing() => Item(
    id: 'potion_of_climbing',
    name: 'Potion of Climbing',
    effect: 'Gain climbing speed equal to walking speed for 1 hour.',
    type: 'consumable',
    weight: 1,
    value: 50,
  );

  static Item potionOfAnimalFriendship() => Item(
    id: 'potion_of_animal_friendship',
    name: 'Potion of Animal Friendship',
    effect: 'Can cast Animal Friendship at will for 1 hour.',
    type: 'consumable',
    weight: 1,
    value: 50,
  );

  static Item potionOfWaterBreathing() => Item(
    id: 'potion_of_water_breathing',
    name: 'Potion of Water Breathing',
    effect: 'Can breathe underwater for 1 hour.',
    type: 'consumable',
    weight: 1,
    value: 50,
  );

  static Item scrollOfMagicMissile() => Item(
    id: 'scroll_magic_missile',
    name: 'Spell Scroll (Magic Missile)',
    effect: 'Single-use scroll containing the Magic Missile spell.',
    type: 'consumable',
    weight: 0,
    value: 50,
  );

  static Item scrollOfIdentify() => Item(
    id: 'scroll_identify',
    name: 'Spell Scroll (Identify)',
    effect: 'Single-use scroll containing the Identify spell.',
    type: 'consumable',
    weight: 0,
    value: 50,
  );

  // ==================== UNCOMMON MAGIC ITEMS ====================

  static Item weaponPlus1(String weaponType) => MagicItems.weaponPlus1(weaponType);

  static Item armorPlus1(String armorType) => MagicItems.armorPlus1(armorType);

  static Item cloakOfProtection() => MagicItems.cloakOfProtection();

  static Item bootsOfElvenkind() => MagicItems.bootsOfElvenkind();

  static Item bagOfHolding() => MagicItems.bagOfHolding();

  static Item gauntletsOfOgrePower() => Item(
    id: 'gauntlets_of_ogre_power',
    name: 'Gauntlets of Ogre Power',
    effect: 'Your Strength score is 19 while you wear these gauntlets.',
    type: 'misc',
    weight: 1,
    value: 500,
  );

  static Item bootsOfSpeed() => Item(
    id: 'boots_of_speed',
    name: 'Boots of Speed',
    effect: 'As bonus action, click heels to double walking speed and grant advantage on Dexterity saves for 10 minutes.',
    type: 'misc',
    weight: 1,
    value: 500,
  );

  static Item cloakOfElvenkind() => Item(
    id: 'cloak_of_elvenkind',
    name: 'Cloak of Elvenkind',
    effect: 'Advantage on Stealth checks and creatures have disadvantage on Perception checks to see you.',
    type: 'misc',
    weight: 1,
    value: 500,
  );

  static Item googlesOfNight() => Item(
    id: 'goggles_of_night',
    name: 'Goggles of Night',
    effect: 'While wearing, you have darkvision out to 60 feet.',
    type: 'misc',
    weight: 1,
    value: 500,
  );

  static Item ropeOfClimbing() => Item(
    id: 'rope_of_climbing',
    name: 'Rope of Climbing',
    effect: '60-foot rope that can animate and climb surfaces on command.',
    type: 'misc',
    weight: 3,
    value: 500,
  );

  static Item slippersOfSpiderClimbing() => Item(
    id: 'slippers_of_spider_climbing',
    name: 'Slippers of Spider Climbing',
    effect: 'Can move up, down, and across vertical surfaces and upside down, while leaving hands free.',
    type: 'misc',
    weight: 1,
    value: 500,
  );

  static Item wandOfMagicMissiles() => Item(
    id: 'wand_of_magic_missiles',
    name: 'Wand of Magic Missiles',
    effect: 'Has 7 charges. Expend charges to cast Magic Missile (1st level = 1 charge, +1 charge per level). Regains 1d6+1 charges daily at dawn.',
    type: 'misc',
    weight: 1,
    value: 800,
  );

  static Item shieldPlus1() => Item(
    id: 'shield_plus1',
    name: '+1 Shield',
    type: 'armor',
    weight: 6,
    value: 500,
    armorBonus: 3,
    armorType: 'shield',
  );

  static Item amuletOfHealth() => Item(
    id: 'amulet_of_health',
    name: 'Amulet of Health',
    effect: 'Your Constitution score is 19 while you wear this amulet.',
    type: 'misc',
    weight: 0,
    value: 500,
  );

  static Item headbandOfIntellect() => Item(
    id: 'headband_of_intellect',
    name: 'Headband of Intellect',
    effect: 'Your Intelligence score is 19 while you wear this headband.',
    type: 'misc',
    weight: 0,
    value: 500,
  );

  // ==================== RARE MAGIC ITEMS ====================

  static Item weaponPlus2(String weaponType) => MagicItems.weaponPlus2(weaponType);

  static Item armorPlus2(String armorType) => MagicItems.armorPlus2(armorType);

  static Item ringOfProtection() => MagicItems.ringOfProtection();

  static Item flameTounge() => MagicItems.flameTounge();

  static Item wandOfFireballs() => MagicItems.wandOfFireballs();

  static Item ringOfSpellStoring() => Item(
    id: 'ring_of_spell_storing',
    name: 'Ring of Spell Storing',
    effect: 'Can store up to 5 levels of spells. Any creature can cast stored spells.',
    type: 'misc',
    weight: 1,
    value: 5000,
  );

  static Item cloakOfDisplacement() => Item(
    id: 'cloak_of_displacement',
    name: 'Cloak of Displacement',
    effect: 'Attackers have disadvantage on attacks against you. Effect ends if you take damage.',
    type: 'misc',
    weight: 1,
    value: 5000,
  );

  static Item cloakOfTheBat() => Item(
    id: 'cloak_of_the_bat',
    name: 'Cloak of the Bat',
    effect: 'Advantage on Stealth in dim light or darkness. Can polymorph into bat or fly.',
    type: 'misc',
    weight: 1,
    value: 5000,
  );

  static Item bootsOfLevitation() => Item(
    id: 'boots_of_levitation',
    name: 'Boots of Levitation',
    effect: 'Can cast Levitate at will.',
    type: 'misc',
    weight: 1,
    value: 3000,
  );

  static Item ringOfFeatherFalling() => Item(
    id: 'ring_of_feather_falling',
    name: 'Ring of Feather Falling',
    effect: 'When you fall, you descend 60 feet per round and take no falling damage.',
    type: 'misc',
    weight: 1,
    value: 3000,
  );

  static Item ringOfWaterWalking() => Item(
    id: 'ring_of_water_walking',
    name: 'Ring of Water Walking',
    effect: 'Can stand on and walk across liquid surfaces as if they were solid.',
    type: 'misc',
    weight: 1,
    value: 3000,
  );

  static Item ringOfResistanceFire() => Item(
    id: 'ring_of_resistance_fire',
    name: 'Ring of Fire Resistance',
    effect: 'You have resistance to fire damage.',
    type: 'misc',
    weight: 1,
    value: 3000,
  );

  static Item ringOfResistanceCold() => Item(
    id: 'ring_of_resistance_cold',
    name: 'Ring of Cold Resistance',
    effect: 'You have resistance to cold damage.',
    type: 'misc',
    weight: 1,
    value: 3000,
  );

  static Item ringOfResistanceLightning() => Item(
    id: 'ring_of_resistance_lightning',
    name: 'Ring of Lightning Resistance',
    effect: 'You have resistance to lightning damage.',
    type: 'misc',
    weight: 1,
    value: 3000,
  );

  static Item wandOfPolymorph() => Item(
    id: 'wand_of_polymorph',
    name: 'Wand of Polymorph',
    effect: 'Has 7 charges. Expend 1 charge to cast Polymorph (save DC 15). Regains 1d6+1 charges daily at dawn.',
    type: 'misc',
    weight: 1,
    value: 8000,
  );

  static Item potionOfSuperiorHealing() => Item(
    id: 'potion_of_superior_healing',
    name: 'Potion of Superior Healing',
    effect: '8d4+8',
    type: 'consumable',
    weight: 1,
    value: 500,
  );

  static Item potionOfHeroism() => Item(
    id: 'potion_of_heroism',
    name: 'Potion of Heroism',
    effect: 'Gain 10 temporary HP and bless effect for 1 hour.',
    type: 'consumable',
    weight: 1,
    value: 500,
  );

  static Item potionOfInvisibility() => Item(
    id: 'potion_of_invisibility',
    name: 'Potion of Invisibility',
    effect: 'Become invisible for 1 hour or until you attack or cast spell.',
    type: 'consumable',
    weight: 1,
    value: 500,
  );

  static Item arrowsOfSlaying() => Item(
    id: 'arrows_of_slaying',
    name: 'Arrows of Slaying',
    effect: 'Deals 6d10 extra piercing to specific creature type. DC 17 Constitution save or reduced to 0 HP.',
    type: 'misc',
    weight: 1,
    value: 1000,
    damageDice: '6d10',
    damageType: 'ranged',
  );

  // ==================== VERY RARE MAGIC ITEMS ====================

  static Item weaponPlus3(String weaponType) => MagicItems.weaponPlus3(weaponType);

  static Item armorPlus3(String armorType) => MagicItems.armorPlus3(armorType);

  static Item staffOfPower() => MagicItems.staffOfPower();

  static Item beltOfGiantStrength() => MagicItems.beltOfGiantStrength();

  static Item ringOfRegeneration() => Item(
    id: 'ring_of_regeneration',
    name: 'Ring of Regeneration',
    effect: 'Regain 1d6 HP every 10 minutes if you have at least 1 HP.',
    type: 'misc',
    weight: 1,
    value: 20000,
  );

  static Item ringOfInvisibility() => Item(
    id: 'ring_of_invisibility',
    name: 'Ring of Invisibility',
    effect: 'Use action to turn invisible until you attack, cast spell, or use action to become visible.',
    type: 'misc',
    weight: 1,
    value: 20000,
  );

  static Item ringOfTelekinesis() => Item(
    id: 'ring_of_telekinesis',
    name: 'Ring of Telekinesis',
    effect: 'Can cast Telekinesis at will.',
    type: 'misc',
    weight: 1,
    value: 20000,
  );

  static Item cloakOfInvisibility() => Item(
    id: 'cloak_of_invisibility',
    name: 'Cloak of Invisibility',
    effect: 'Pull hood over head to become invisible. Can remain invisible for up to 2 hours (recharges at dawn).',
    type: 'misc',
    weight: 1,
    value: 50000,
  );

  static Item bootsOfTeleportation() => Item(
    id: 'boots_of_teleportation',
    name: 'Boots of Teleportation',
    effect: 'Can cast Teleport 3 times per day.',
    type: 'misc',
    weight: 1,
    value: 30000,
  );

  static Item staffOfTheMagi() => Item(
    id: 'staff_of_the_magi',
    name: 'Staff of the Magi',
    effect: '+2 bonus to AC, spell attacks, and saves. 50 charges. Can cast many powerful spells. Spell absorption. Retributive Strike.',
    type: 'misc',
    weight: 1,
    value: 100000,
  );

  static Item staffOfHealing() => Item(
    id: 'staff_of_healing',
    name: 'Staff of Healing',
    effect: 'Has 10 charges. Cast Cure Wounds (1 charge per level), Lesser Restoration (2), Mass Cure Wounds (5). Regains 1d6+4 charges at dawn.',
    type: 'misc',
    weight: 1,
    value: 20000,
  );

  static Item wandOfWonder() => Item(
    id: 'wand_of_wonder',
    name: 'Wand of Wonder',
    effect: 'Has 7 charges. Expend 1 charge to produce random magical effect. Regains 1d6+1 charges at dawn.',
    type: 'misc',
    weight: 1,
    value: 15000,
  );

  static Item rodOfLordlyMight() => Item(
    id: 'rod_of_lordly_might',
    name: 'Rod of Lordly Might',
    effect: 'Functions as +3 mace. Can transform into various weapons. Has special powers.',
    type: 'misc',
    weight: 1,
    value: 50000,
    damageDice: '1d6+3',
    damageType: 'martial',
  );

  static Item amuletOfThePlanes() => Item(
    id: 'amulet_of_the_planes',
    name: 'Amulet of the Planes',
    effect: 'Use action to cast Plane Shift (save DC 15). Can use once per dawn.',
    type: 'misc',
    weight: 1,
    value: 30000,
  );

  static Item manualOfGolems() => Item(
    id: 'manual_of_golems',
    name: 'Manual of Golems',
    effect: 'Contains information and incantations to create a specific type of golem.',
    type: 'misc',
    weight: 1,
    value: 50000,
  );

  static Item potionOfStormGiantStrength() => Item(
    id: 'potion_of_storm_giant_strength',
    name: 'Potion of Storm Giant Strength',
    effect: 'Your Strength score becomes 29 for 1 hour.',
    type: 'consumable',
    weight: 1,
    value: 5000,
  );

  // ==================== LEGENDARY MAGIC ITEMS ====================

  static Item holyAvenger() => MagicItems.holyAvenger();

  static Item vorpalSword() => MagicItems.vorpalSword();

  static Item robeOfTheArchmagi() => MagicItems.robeOfTheArchmagi();

  static Item ringOfThreeWishes() => MagicItems.ringOfThreeWishes();

  static Item swordOfAnswering() => Item(
    id: 'sword_of_answering',
    name: 'Sword of Answering',
    effect: '+3 legendary longsword. Can answer insults with advantage on attacks.',
    type: 'weapon',
    weight: 3,
    value: 150000,
    damageDice: '1d8+3',
    damageType: 'martial',
  );

  static Item hammerOfThunderbolts() => Item(
    id: 'hammer_of_thunderbolts',
    name: 'Hammer of Thunderbolts',
    effect: '+1 maul. Giants take extra 4d6 damage. When used with belt and gauntlets, becomes +3 and can stun giants.',
    type: 'weapon',
    weight: 3,
    value: 150000,
    damageDice: '2d6+1',
    damageType: 'martial',
  );

  static Item robeOfStars() => Item(
    id: 'robe_of_stars',
    name: 'Robe of Stars',
    effect: '+1 to saves. 6 stars can be used as Magic Missiles. Can enter Astral Plane.',
    type: 'misc',
    weight: 1,
    value: 100000,
  );

  static Item staffOfTheWoodlands() => Item(
    id: 'staff_of_the_woodlands',
    name: 'Staff of the Woodlands',
    effect: '+2 quarterstaff. 10 charges to cast druid spells. Tree form. Pass without Trace aura.',
    type: 'misc',
    weight: 1,
    value: 80000,
    damageDice: '1d6+2',
    damageType: 'simple',
  );

  static Item orbOfDragonkind() => Item(
    id: 'orb_of_dragonkind',
    name: 'Orb of Dragonkind',
    effect: 'Grants power over dragons. +2 bonus to AC and saves. Detect dragons. Control dragons.',
    type: 'misc',
    weight: 1,
    value: 200000,
  );

  static Item tomeOfClearThought() => Item(
    id: 'tome_of_clear_thought',
    name: 'Tome of Clear Thought',
    effect: 'Reading entire book (48 hours over 6 days) increases Intelligence and max Intelligence by 2.',
    type: 'misc',
    weight: 1,
    value: 100000,
  );

  static Item tomeOfLeadershipAndInfluence() => Item(
    id: 'tome_of_leadership',
    name: 'Tome of Leadership and Influence',
    effect: 'Reading entire book (48 hours over 6 days) increases Charisma and max Charisma by 2.',
    type: 'misc',
    weight: 1,
    value: 100000,
  );

  static Item manualOfBodilyHealth() => Item(
    id: 'manual_of_bodily_health',
    name: 'Manual of Bodily Health',
    effect: 'Reading entire book (48 hours over 6 days) increases Constitution and max Constitution by 2.',
    type: 'misc',
    weight: 1,
    value: 100000,
  );

  static Item deckOfManyThings() => Item(
    id: 'deck_of_many_things',
    name: 'Deck of Many Things',
    effect: 'Legendary artifact deck with 22 cards. Each card drawn has powerful positive or negative effects.',
    type: 'misc',
    weight: 1,
    value: 500000,
  );

  static Item apparatusOfKwalish() => Item(
    id: 'apparatus_of_kwalish',
    name: 'Apparatus of Kwalish',
    effect: 'Large iron barrel-shaped vehicle that moves on land and underwater. AC 20, 200 HP.',
    type: 'misc',
    weight: 1,
    value: 150000,
  );

  // ==================== ARTIFACT-LEVEL ITEMS ====================

  static Item bookOfVileHarkness() => Item(
    id: 'book_of_vile_darkness',
    name: 'Book of Vile Darkness',
    effect: 'Artifact containing most vile magic. Reading it grants evil knowledge but corrupts the soul.',
    type: 'misc',
    weight: 1,
    value: 1000000,
  );

  static Item eyeOfVecna() => Item(
    id: 'eye_of_vecna',
    name: 'Eye of Vecna',
    effect: 'Artifact. Replace your eye with it. Gain truesight, see invisible, X-ray vision. Cursed.',
    type: 'misc',
    weight: 1,
    value: 1000000,
  );

  static Item handOfVecna() => Item(
    id: 'hand_of_vecna',
    name: 'Hand of Vecna',
    effect: 'Artifact. Replace your hand with it. Gain +2 Strength, cold touch, powerful spells. Cursed.',
    type: 'misc',
    weight: 1,
    value: 1000000,
  );

  // ==================== UTILITY METHODS ====================

  static List<Item> getAllMagicItems() {
    return [
      ...getCommonItems(),
      ...getUncommonItems(),
      ...getRareItems(),
      ...getVeryRareItems(),
      ...getLegendaryItems(),
      ...getArtifactItems(),
    ];
  }

  static List<Item> getCommonItems() {
    return [
      potionOfHealing(),
      potionOfGreaterHealing(),
      potionOfClimbing(),
      potionOfAnimalFriendship(),
      potionOfWaterBreathing(),
      scrollOfMagicMissile(),
      scrollOfIdentify(),
    ];
  }

  static List<Item> getUncommonItems() {
    return [
      weaponPlus1('Longsword'),
      weaponPlus1('Shortsword'),
      weaponPlus1('Dagger'),
      weaponPlus1('Battleaxe'),
      weaponPlus1('Greataxe'),
      weaponPlus1('Warhammer'),
      armorPlus1('Chain Mail'),
      armorPlus1('Leather Armor'),
      armorPlus1('Breastplate'),
      shieldPlus1(),
      cloakOfProtection(),
      bootsOfElvenkind(),
      bagOfHolding(),
      gauntletsOfOgrePower(),
      bootsOfSpeed(),
      cloakOfElvenkind(),
      googlesOfNight(),
      ropeOfClimbing(),
      slippersOfSpiderClimbing(),
      wandOfMagicMissiles(),
      amuletOfHealth(),
      headbandOfIntellect(),
    ];
  }

  static List<Item> getRareItems() {
    return [
      weaponPlus2('Longsword'),
      weaponPlus2('Greatsword'),
      weaponPlus2('Rapier'),
      armorPlus2('Chain Mail'),
      armorPlus2('Plate Armor'),
      ringOfProtection(),
      flameTounge(),
      wandOfFireballs(),
      ringOfSpellStoring(),
      cloakOfDisplacement(),
      cloakOfTheBat(),
      bootsOfLevitation(),
      ringOfFeatherFalling(),
      ringOfWaterWalking(),
      ringOfResistanceFire(),
      ringOfResistanceCold(),
      ringOfResistanceLightning(),
      wandOfPolymorph(),
      potionOfSuperiorHealing(),
      potionOfHeroism(),
      potionOfInvisibility(),
      arrowsOfSlaying(),
    ];
  }

  static List<Item> getVeryRareItems() {
    return [
      weaponPlus3('Longsword'),
      weaponPlus3('Greataxe'),
      armorPlus3('Chain Mail'),
      armorPlus3('Plate Armor'),
      staffOfPower(),
      beltOfGiantStrength(),
      ringOfRegeneration(),
      ringOfInvisibility(),
      ringOfTelekinesis(),
      cloakOfInvisibility(),
      bootsOfTeleportation(),
      staffOfTheMagi(),
      staffOfHealing(),
      wandOfWonder(),
      rodOfLordlyMight(),
      amuletOfThePlanes(),
      manualOfGolems(),
      potionOfStormGiantStrength(),
    ];
  }

  static List<Item> getLegendaryItems() {
    return [
      holyAvenger(),
      vorpalSword(),
      robeOfTheArchmagi(),
      ringOfThreeWishes(),
      swordOfAnswering(),
      hammerOfThunderbolts(),
      robeOfStars(),
      staffOfTheWoodlands(),
      orbOfDragonkind(),
      tomeOfClearThought(),
      tomeOfLeadershipAndInfluence(),
      manualOfBodilyHealth(),
      deckOfManyThings(),
      apparatusOfKwalish(),
    ];
  }

  static List<Item> getArtifactItems() {
    return [
      bookOfVileHarkness(),
      eyeOfVecna(),
      handOfVecna(),
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
      case ItemRarity.artifact:
        items = getArtifactItems();
        break;
    }

    if (items.isEmpty) return null;
    items.shuffle();
    return items.first;
  }
}
