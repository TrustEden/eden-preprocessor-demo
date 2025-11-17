// Comprehensive D&D 5e Feats
// All official feats from PHB, Xanathar's, Tasha's, and other sourcebooks

class Feat {
  final String name;
  final String description;
  final List<String> prerequisites;
  final Map<String, int> abilityScoreIncreases;
  final List<String> benefits;

  Feat({
    required this.name,
    required this.description,
    List<String>? prerequisites,
    Map<String, int>? abilityScoreIncreases,
    required this.benefits,
  })  : prerequisites = prerequisites ?? [],
        abilityScoreIncreases = abilityScoreIncreases ?? {};
}

final Map<String, Feat> allFeats = {
  // PHB Feats
  'Alert': _alert,
  'Athlete': _athlete,
  'Actor': _actor,
  'Charger': _charger,
  'Crossbow Expert': _crossbowExpert,
  'Defensive Duelist': _defensiveDuelist,
  'Dual Wielder': _dualWielder,
  'Dungeon Delver': _dungeonDelver,
  'Durable': _durable,
  'Elemental Adept': _elementalAdept,
  'Grappler': _grappler,
  'Great Weapon Master': _greatWeaponMaster,
  'Healer': _healer,
  'Heavily Armored': _heavilyArmored,
  'Heavy Armor Master': _heavyArmorMaster,
  'Inspiring Leader': _inspiringLeader,
  'Keen Mind': _keenMind,
  'Lightly Armored': _lightlyArmored,
  'Linguist': _linguist,
  'Lucky': _lucky,
  'Mage Slayer': _mageSlayer,
  'Magic Initiate': _magicInitiate,
  'Martial Adept': _martialAdept,
  'Medium Armor Master': _mediumArmorMaster,
  'Mobile': _mobile,
  'Moderately Armored': _moderatelyArmored,
  'Mounted Combatant': _mountedCombatant,
  'Observant': _observant,
  'Polearm Master': _polearmMaster,
  'Resilient': _resilient,
  'Ritual Caster': _ritualCaster,
  'Savage Attacker': _savageAttacker,
  'Sentinel': _sentinel,
  'Sharpshooter': _sharpshooter,
  'Shield Master': _shieldMaster,
  'Skilled': _skilled,
  'Skulker': _skulker,
  'Spell Sniper': _spellSniper,
  'Tavern Brawler': _tavernBrawler,
  'Tough': _tough,
  'War Caster': _warCaster,
  'Weapon Master': _weaponMaster,

  // Xanathar's Guide Feats
  'Bountiful Luck': _bountifulLuck,
  'Dragon Fear': _dragonFear,
  'Dragon Hide': _dragonHide,
  'Drow High Magic': _drowHighMagic,
  'Dwarven Fortitude': _dwarvenFortitude,
  'Elven Accuracy': _elvenAccuracy,
  'Fade Away': _fadeAway,
  'Fey Teleportation': _feyTeleportation,
  'Flames of Phlegethos': _flamesOfPhlegethos,
  'Infernal Constitution': _infernalConstitution,
  'Orcish Fury': _orcishFury,
  'Prodigy': _prodigy,
  'Second Chance': _secondChance,
  'Squat Nimbleness': _squatNimbleness,
  'Wood Elf Magic': _woodElfMagic,

  // Tasha's Cauldron Feats
  'Artificer Initiate': _artificerInitiate,
  'Chef': _chef,
  'Crusher': _crusher,
  'Eldritch Adept': _eldritchAdept,
  'Fey Touched': _feyTouched,
  'Fighting Initiate': _fightingInitiate,
  'Gunner': _gunner,
  'Metamagic Adept': _metamagicAdept,
  'Piercer': _piercer,
  'Poisoner': _poisoner,
  'Practiced Expert': _practicedExpert,
  'Shadow Touched': _shadowTouched,
  'Skill Expert': _skillExpert,
  'Slasher': _slasher,
  'Telekinetic': _telekinetic,
  'Telepathic': _telepathic,
};

// ============================================================================
// PHB FEATS
// ============================================================================

final Feat _alert = Feat(
  name: 'Alert',
  description: 'Always on the lookout for danger, you gain the following benefits:',
  benefits: [
    '+5 bonus to initiative',
    'Can\'t be surprised while conscious',
    'Other creatures don\'t gain advantage on attack rolls against you due to being hidden',
  ],
);

final Feat _athlete = Feat(
  name: 'Athlete',
  description: 'You have undergone extensive physical training to gain the following benefits:',
  abilityScoreIncreases: {'Strength or Dexterity': 1},
  benefits: [
    'Increase STR or DEX by 1 (max 20)',
    'Standing up from prone costs only 5 feet of movement',
    'Climbing doesn\'t cost extra movement',
    'Running jump distance increases by number of feet equal to your STR modifier',
  ],
);

final Feat _actor = Feat(
  name: 'Actor',
  description: 'Skilled at mimicry and dramatics, you gain the following benefits:',
  abilityScoreIncreases: {'Charisma': 1},
  benefits: [
    'Increase CHA by 1 (max 20)',
    'Advantage on Deception and Performance checks when trying to pass yourself off as different person',
    'Can mimic speech of another person or sounds made by other creatures',
  ],
);

final Feat _charger = Feat(
  name: 'Charger',
  description: 'When you use your action to Dash, you can use a bonus action to make one melee weapon attack or shove a creature. If you move at least 10 feet in a straight line before taking this bonus action, you either gain +5 to attack damage roll or push target up to 10 feet away.',
  benefits: [
    'Bonus action attack or shove after Dash',
    '+5 damage or push 10 feet if moved 10+ feet straight',
  ],
);

final Feat _crossbowExpert = Feat(
  name: 'Crossbow Expert',
  description: 'Thanks to extensive practice with crossbows, you gain the following benefits:',
  benefits: [
    'Ignore loading property of crossbows',
    'No disadvantage on ranged attack rolls for being within 5 feet of hostile creature',
    'When using one-handed weapon, can use bonus action to attack with loaded hand crossbow',
  ],
);

final Feat _defensiveDuelist = Feat(
  name: 'Defensive Duelist',
  description: 'When wielding a finesse weapon and another creature hits you with a melee attack, you can use your reaction to add your proficiency bonus to AC for that attack.',
  prerequisites: ['Dexterity 13 or higher'],
  benefits: [
    'Reaction to add proficiency bonus to AC when hit while wielding finesse weapon',
  ],
);

final Feat _dualWielder = Feat(
  name: 'Dual Wielder',
  description: 'You master fighting with two weapons, gaining the following benefits:',
  benefits: [
    '+1 AC while wielding separate melee weapons in each hand',
    'Can two-weapon fight with non-light weapons',
    'Can draw or stow two one-handed weapons when you would draw or stow one',
  ],
);

final Feat _dungeonDelver = Feat(
  name: 'Dungeon Delver',
  description: 'Alert to hidden traps and secret doors, you gain the following benefits:',
  benefits: [
    'Advantage on Perception and Investigation checks to detect secret doors',
    'Advantage on saves to avoid or resist traps',
    'Resistance to damage dealt by traps',
    'Travel at normal pace while searching for traps',
  ],
);

final Feat _durable = Feat(
  name: 'Durable',
  description: 'Hardy and resilient, you gain the following benefits:',
  abilityScoreIncreases: {'Constitution': 1},
  benefits: [
    'Increase CON by 1 (max 20)',
    'When you roll Hit Dice to regain HP, minimum amount regained equals 2× CON modifier (min of 2)',
  ],
);

final Feat _elementalAdept = Feat(
  name: 'Elemental Adept',
  description: 'When you gain this feat, choose acid, cold, fire, lightning, or thunder. Spells you cast ignore resistance to that damage type. Treat any 1 on damage dice for that type as a 2.',
  prerequisites: ['Ability to cast at least one spell'],
  benefits: [
    'Spells ignore resistance to chosen damage type',
    'Treat damage dice rolls of 1 as 2 for chosen type',
  ],
);

final Feat _grappler = Feat(
  name: 'Grappler',
  description: 'You\'ve developed skills to hold your own in close-quarters grappling:',
  prerequisites: ['Strength 13 or higher'],
  benefits: [
    'Advantage on attack rolls against creatures you\'re grappling',
    'Can use action to pin grappled creature (both restrained until grapple ends)',
  ],
);

final Feat _greatWeaponMaster = Feat(
  name: 'Great Weapon Master',
  description: 'You\'ve learned to put weapon heft to your advantage. On your turn, when you score critical hit or reduce creature to 0 HP with melee weapon, you can make one melee weapon attack as bonus action. Before making melee attack with heavy weapon, you can take -5 to attack roll. If attack hits, add +10 to damage.',
  benefits: [
    'Bonus action attack on critical or kill',
    'Power attack: -5 to hit, +10 damage with heavy weapons',
  ],
);

final Feat _healer = Feat(
  name: 'Healer',
  description: 'You are an able physician, allowing you to mend wounds. You gain the following benefits:',
  benefits: [
    'When using healer\'s kit to stabilize, creature regains 1 HP',
    'As action, spend one use of healer\'s kit to restore 1d6+4 HP plus additional HP equal to creature\'s maximum number of Hit Dice. Can\'t use on creature again until it finishes short or long rest',
  ],
);

final Feat _heavilyArmored = Feat(
  name: 'Heavily Armored',
  description: 'You have trained to master use of heavy armor:',
  prerequisites: ['Proficiency with medium armor'],
  abilityScoreIncreases: {'Strength': 1},
  benefits: [
    'Increase STR by 1 (max 20)',
    'Gain proficiency with heavy armor',
  ],
);

final Feat _heavyArmorMaster = Feat(
  name: 'Heavy Armor Master',
  description: 'You can use armor to deflect strikes that would kill others:',
  prerequisites: ['Proficiency with heavy armor'],
  abilityScoreIncreases: {'Strength': 1},
  benefits: [
    'Increase STR by 1 (max 20)',
    'While wearing heavy armor, reduce non-magical bludgeoning, piercing, slashing damage by 3',
  ],
);

final Feat _inspiringLeader = Feat(
  name: 'Inspiring Leader',
  description: 'You can spend 10 minutes inspiring companions. Up to 6 friendly creatures (including you) who can see or hear you gain temporary HP equal to your level + CHA modifier. Creature can\'t gain temp HP from this feat again until after short or long rest.',
  prerequisites: ['Charisma 13 or higher'],
  benefits: [
    'Grant temp HP = level + CHA mod to up to 6 allies',
  ],
);

final Feat _keenMind = Feat(
  name: 'Keen Mind',
  description: 'You have a mind that can track time, direction, and detail with uncanny precision:',
  abilityScoreIncreases: {'Intelligence': 1},
  benefits: [
    'Increase INT by 1 (max 20)',
    'Always know which way is north',
    'Always know hours until next sunrise/sunset',
    'Accurately recall anything seen or heard within past month',
  ],
);

final Feat _lightlyArmored = Feat(
  name: 'Lightly Armored',
  description: 'You have trained to master use of light armor:',
  abilityScoreIncreases: {'Strength or Dexterity': 1},
  benefits: [
    'Increase STR or DEX by 1 (max 20)',
    'Gain proficiency with light armor',
  ],
);

final Feat _linguist = Feat(
  name: 'Linguist',
  description: 'You have studied languages and codes:',
  abilityScoreIncreases: {'Intelligence': 1},
  benefits: [
    'Increase INT by 1 (max 20)',
    'Learn three languages of your choice',
    'Create written ciphers. Others can\'t decipher unless you teach them, they succeed on INT check (DC = INT score + proficiency bonus), or use magic',
  ],
);

final Feat _lucky = Feat(
  name: 'Lucky',
  description: 'You have inexplicable luck that seems to kick in at just the right moment. You have 3 luck points. When you make attack roll, ability check, or saving throw, you can spend luck point to roll additional d20. You choose which d20 to use. You can spend luck point after rolling but before outcome determined. You can also spend luck point when attack roll is made against you. Roll d20 and choose whether attack uses attacker\'s roll or yours. Regain expended luck points on long rest.',
  benefits: [
    '3 luck points per long rest',
    'Spend to roll extra d20 on attack, check, or save',
    'Spend when attacked to impose disadvantage',
  ],
);

final Feat _mageSlayer = Feat(
  name: 'Mage Slayer',
  description: 'You have practiced techniques for fighting spellcasters:',
  benefits: [
    'Creature within 5 feet casts spell, you can use reaction to make melee weapon attack',
    'Advantage on saves vs spells cast by creatures within 5 feet',
    'Creature you damage has disadvantage on concentration saves',
  ],
);

final Feat _magicInitiate = Feat(
  name: 'Magic Initiate',
  description: 'Choose a class: bard, cleric, druid, sorcerer, warlock, or wizard. You learn two cantrips and one 1st-level spell from that class\'s spell list. Once per long rest, you can cast that spell. Spellcasting ability is the class\'s.',
  benefits: [
    'Learn 2 cantrips from chosen class',
    'Learn 1 1st-level spell from chosen class (cast 1/long rest)',
  ],
);

final Feat _martialAdept = Feat(
  name: 'Martial Adept',
  description: 'You have martial training that allows you to perform special combat maneuvers. You learn two maneuvers from Battle Master archetype. If maneuver requires save, DC = 8 + proficiency bonus + STR or DEX modifier. You gain one d6 superiority die (regains on short or long rest).',
  benefits: [
    'Learn 2 Battle Master maneuvers',
    'Gain 1 superiority die (d6)',
  ],
);

final Feat _mediumArmorMaster = Feat(
  name: 'Medium Armor Master',
  description: 'You have practiced moving in medium armor:',
  prerequisites: ['Proficiency with medium armor'],
  benefits: [
    'Wearing medium armor doesn\'t impose disadvantage on Stealth checks',
    'Can add up to 3 (instead of 2) to AC if DEX is 16 or higher',
  ],
);

final Feat _mobile = Feat(
  name: 'Mobile',
  description: 'You are exceptionally speedy and agile:',
  benefits: [
    'Speed increases by 10 feet',
    'Dash action doesn\'t provoke opportunity attacks',
    'When you make melee attack against creature, don\'t provoke opportunity attacks from that creature (hit or miss)',
  ],
);

final Feat _moderatelyArmored = Feat(
  name: 'Moderately Armored',
  description: 'You have trained to master use of medium armor and shields:',
  prerequisites: ['Proficiency with light armor'],
  abilityScoreIncreases: {'Strength or Dexterity': 1},
  benefits: [
    'Increase STR or DEX by 1 (max 20)',
    'Gain proficiency with medium armor and shields',
  ],
);

final Feat _mountedCombatant = Feat(
  name: 'Mounted Combatant',
  description: 'You are a dangerous foe to face while mounted:',
  benefits: [
    'Advantage on melee attack rolls vs unmounted creatures smaller than mount',
    'Force attack targeting mount to target you instead',
    'If mount subjected to save for half damage, takes no damage on success, half on failure',
  ],
);

final Feat _observant = Feat(
  name: 'Observant',
  description: 'Quick to notice details, you gain the following benefits:',
  abilityScoreIncreases: {'Intelligence or Wisdom': 1},
  benefits: [
    'Increase INT or WIS by 1 (max 20)',
    'Can read lips if you can see speaker and understand language',
    '+5 passive Perception and Investigation',
  ],
);

final Feat _polearmMaster = Feat(
  name: 'Polearm Master',
  description: 'You gain the following benefits when wielding glaive, halberd, pike, quarterstaff, or spear:',
  benefits: [
    'Bonus action attack with opposite end (1d4 bludgeoning)',
    'Creatures entering your reach provoke opportunity attack (even with Disengage)',
  ],
);

final Feat _resilient = Feat(
  name: 'Resilient',
  description: 'Choose one ability score. You gain the following benefits:',
  abilityScoreIncreases: {'Chosen ability': 1},
  benefits: [
    'Increase chosen ability by 1 (max 20)',
    'Gain proficiency in saves using chosen ability',
  ],
);

final Feat _ritualCaster = Feat(
  name: 'Ritual Caster',
  description: 'You have learned ritual spells from chosen class (cleric or wizard). Choose class with 13 or higher in spellcasting ability. You learn two 1st-level ritual spells from that class. Can cast as rituals only. Can add ritual spells from that class to ritual book.',
  prerequisites: ['Intelligence or Wisdom 13 or higher'],
  benefits: [
    'Learn 2 1st-level ritual spells from chosen class',
    'Can learn more ritual spells by copying into ritual book',
  ],
);

final Feat _savageAttacker = Feat(
  name: 'Savage Attacker',
  description: 'Once per turn when you roll damage for melee weapon attack, you can reroll weapon\'s damage dice and use either total.',
  benefits: [
    'Reroll melee weapon damage once per turn',
  ],
);

final Feat _sentinel = Feat(
  name: 'Sentinel',
  description: 'You have mastered techniques to take advantage of every drop in enemy\'s guard:',
  benefits: [
    'Hit with opportunity attack, creature\'s speed becomes 0 for rest of turn',
    'Creatures provoke opportunity attacks even if Disengage',
    'Creature within 5 feet attacks target other than you, you can use reaction to make melee weapon attack against attacking creature',
  ],
);

final Feat _sharpshooter = Feat(
  name: 'Sharpshooter',
  description: 'You have mastered ranged weapons and can make shots others find impossible:',
  benefits: [
    'Ranged weapon attacks ignore half and three-quarters cover',
    'No disadvantage on long range',
    'Before ranged attack with weapon, take -5 to hit for +10 damage',
  ],
);

final Feat _shieldMaster = Feat(
  name: 'Shield Master',
  description: 'You use shields not just for protection but also offense:',
  benefits: [
    'If you Attack, can use bonus action to shove with shield',
    'Add shield AC bonus to DEX saves vs spells or effects targeting only you',
    'If DEX save for half damage, take no damage on success (instead of half)',
  ],
);

final Feat _skilled = Feat(
  name: 'Skilled',
  description: 'You gain proficiency in any combination of three skills or tools of your choice.',
  benefits: [
    'Gain proficiency in 3 skills or tools',
  ],
);

final Feat _skulker = Feat(
  name: 'Skulker',
  description: 'You are expert at slinking through shadows:',
  prerequisites: ['Dexterity 13 or higher'],
  benefits: [
    'Can try to hide when lightly obscured',
    'Dim light doesn\'t impose disadvantage on Perception checks',
    'Missing with ranged weapon attack doesn\'t reveal position',
  ],
);

final Feat _spellSniper = Feat(
  name: 'Spell Sniper',
  description: 'You have learned techniques to enhance your attacks with certain spells:',
  prerequisites: ['Ability to cast at least one spell'],
  benefits: [
    'Ranged spell attack range doubled',
    'Ranged spell attacks ignore half and three-quarters cover',
    'Learn one cantrip requiring attack roll from any class',
  ],
);

final Feat _tavernBrawler = Feat(
  name: 'Tavern Brawler',
  description: 'Accustomed to rough-and-tumble fighting using whatever is at hand:',
  abilityScoreIncreases: {'Strength or Constitution': 1},
  benefits: [
    'Increase STR or CON by 1 (max 20)',
    'Proficiency with improvised weapons',
    'Unarmed strikes use d4 for damage',
    'Bonus action to grapple when hitting with unarmed or improvised weapon',
  ],
);

final Feat _tough = Feat(
  name: 'Tough',
  description: 'Your hit point maximum increases by amount equal to twice your level when you gain this feat. Whenever you gain a level, you gain 2 additional hit points.',
  benefits: [
    'HP max increases by 2× level',
    'Gain 2 HP per level',
  ],
);

final Feat _warCaster = Feat(
  name: 'War Caster',
  description: 'You have practiced casting spells in midst of combat:',
  prerequisites: ['Ability to cast at least one spell'],
  benefits: [
    'Advantage on CON saves to maintain concentration',
    'Can perform somatic components even with weapons/shield',
    'Can cast spell as opportunity attack instead of melee attack',
  ],
);

final Feat _weaponMaster = Feat(
  name: 'Weapon Master',
  description: 'You have practiced extensively with variety of weapons:',
  abilityScoreIncreases: {'Strength or Dexterity': 1},
  benefits: [
    'Increase STR or DEX by 1 (max 20)',
    'Gain proficiency with four weapons of your choice',
  ],
);

// ============================================================================
// XANATHAR'S GUIDE FEATS
// ============================================================================

final Feat _bountifulLuck = Feat(
  name: 'Bountiful Luck',
  description: 'Your people have extraordinary luck. When ally you can see within 30 feet rolls 1 on d20 for attack, ability check, or save, you can use reaction to let them reroll. Must use new roll.',
  prerequisites: ['Halfling'],
  benefits: [
    'Reaction to let ally within 30 feet reroll natural 1',
  ],
);

final Feat _dragonFear = Feat(
  name: 'Dragon Fear',
  description: 'When angered, you radiate menace:',
  prerequisites: ['Dragonborn'],
  abilityScoreIncreases: {'Strength, Constitution, or Charisma': 1},
  benefits: [
    'Increase STR, CON, or CHA by 1 (max 20)',
    'Instead of breath weapon, roar (30 ft cone, WIS save or frightened for 1 minute)',
  ],
);

final Feat _dragonHide = Feat(
  name: 'Dragon Hide',
  description: 'You manifest scales and claws reminiscent of draconic ancestor:',
  prerequisites: ['Dragonborn'],
  abilityScoreIncreases: {'Strength, Constitution, or Charisma': 1},
  benefits: [
    'Increase STR, CON, or CHA by 1 (max 20)',
    'AC = 13 + DEX modifier when unarmored',
    'Claws: unarmed strike 1d4 + STR slashing damage',
  ],
);

final Feat _drowHighMagic = Feat(
  name: 'Drow High Magic',
  description: 'You learn more of magic typical of dark elves. Learn detect magic. At 3rd level, learn levitate. At 5th level, learn dispel magic. Can cast each once per long rest. CHA is spellcasting ability.',
  prerequisites: ['Drow (dark elf)'],
  benefits: [
    'Learn detect magic, levitate (at 3rd), dispel magic (at 5th)',
    'Cast each 1/long rest',
  ],
);

final Feat _dwarvenFortitude = Feat(
  name: 'Dwarven Fortitude',
  description: 'You have fortitude of your dwarven ancestors. When you Dodge in combat, can spend one Hit Die to heal yourself (roll die + CON modifier).',
  prerequisites: ['Dwarf'],
  benefits: [
    'Spend Hit Die when Dodging to heal',
  ],
);

final Feat _elvenAccuracy = Feat(
  name: 'Elven Accuracy',
  description: 'Accuracy of elves is legendary:',
  prerequisites: ['Elf or half-elf'],
  abilityScoreIncreases: {'Dexterity, Intelligence, Wisdom, or Charisma': 1},
  benefits: [
    'Increase DEX, INT, WIS, or CHA by 1 (max 20)',
    'When you have advantage on attack using DEX, INT, WIS, or CHA, can reroll one of dice once',
  ],
);

final Feat _fadeAway = Feat(
  name: 'Fade Away',
  description: 'Your people are clever, with knack for finding escape:',
  prerequisites: ['Gnome'],
  abilityScoreIncreases: {'Dexterity or Intelligence': 1},
  benefits: [
    'Increase DEX or INT by 1 (max 20)',
    'When you take damage, use reaction to become invisible until end of next turn or until you attack/damage/force save',
  ],
);

final Feat _feyTeleportation = Feat(
  name: 'Fey Teleportation',
  description: 'Your study of high elven lore unlocked fey power:',
  prerequisites: ['Elf (high elf)'],
  abilityScoreIncreases: {'Intelligence or Charisma': 1},
  benefits: [
    'Increase INT or CHA by 1 (max 20)',
    'Learn Sylvan language',
    'Learn misty step, cast once per short or long rest',
  ],
);

final Feat _flamesOfPhlegethos = Feat(
  name: 'Flames of Phlegethos',
  description: 'You learn to call on hellfire:',
  prerequisites: ['Tiefling'],
  abilityScoreIncreases: {'Intelligence or Charisma': 1},
  benefits: [
    'Increase INT or CHA by 1 (max 20)',
    'When you roll fire damage for spell, reroll any 1s',
    'When you cast fire damage spell, can sheath self in flames until end of next turn (sheds light 30 ft, creature within 5 feet that hits takes 1d4 fire)',
  ],
);

final Feat _infernalConstitution = Feat(
  name: 'Infernal Constitution',
  description: 'Fiendish blood runs strong in you:',
  prerequisites: ['Tiefling'],
  abilityScoreIncreases: {'Constitution': 1},
  benefits: [
    'Increase CON by 1 (max 20)',
    'Resistance to cold and poison damage',
    'Advantage on saves vs being poisoned',
  ],
);

final Feat _orcishFury = Feat(
  name: 'Orcish Fury',
  description: 'Your fury burns tirelessly:',
  prerequisites: ['Half-orc'],
  abilityScoreIncreases: {'Strength or Constitution': 1},
  benefits: [
    'Increase STR or CON by 1 (max 20)',
    'When you hit with attack using STR, add one weapon damage die',
    'When you use Relentless Endurance, can make one weapon attack as reaction',
  ],
);

final Feat _prodigy = Feat(
  name: 'Prodigy',
  description: 'You have gift for learning new things:',
  prerequisites: ['Half-elf, half-orc, or human'],
  benefits: [
    'Gain one skill proficiency, one tool proficiency, fluency in one language',
    'Choose one skill you\'re proficient in. Gain expertise (double proficiency)',
  ],
);

final Feat _secondChance = Feat(
  name: 'Second Chance',
  description: 'Fortune favors you when someone tries to strike you:',
  prerequisites: ['Halfling'],
  abilityScoreIncreases: {'Dexterity, Constitution, or Charisma': 1},
  benefits: [
    'Increase DEX, CON, or CHA by 1 (max 20)',
    'When creature you can see hits you with attack, force reroll. Must use new roll',
  ],
);

final Feat _squatNimbleness = Feat(
  name: 'Squat Nimbleness',
  description: 'You are uncommonly nimble for your race:',
  prerequisites: ['Dwarf or small race'],
  abilityScoreIncreases: {'Strength or Dexterity': 1},
  benefits: [
    'Increase STR or DEX by 1 (max 20)',
    'Speed increases by 5 feet',
    'Proficiency in Acrobatics or Athletics',
    'Advantage on checks to escape grapple',
  ],
);

final Feat _woodElfMagic = Feat(
  name: 'Wood Elf Magic',
  description: 'You learn magic of primeval woods:',
  prerequisites: ['Elf (wood elf)'],
  benefits: [
    'Learn one druid cantrip',
    'Learn longstrider and pass without trace, each cast 1/long rest',
    'WIS is spellcasting ability',
  ],
);

// ============================================================================
// TASHA'S CAULDRON FEATS
// ============================================================================

final Feat _artificerInitiate = Feat(
  name: 'Artificer Initiate',
  description: 'You\'ve learned some of an artificer\'s inventiveness:',
  benefits: [
    'Learn one cantrip from artificer spell list',
    'Learn one 1st-level artificer spell (cast with spell slot or 1/long rest)',
    'Gain proficiency with one artisan\'s tools',
    'INT is spellcasting ability',
  ],
);

final Feat _chef = Feat(
  name: 'Chef',
  description: 'Time and effort spent mastering culinary arts has paid off:',
  abilityScoreIncreases: {'Constitution or Wisdom': 1},
  benefits: [
    'Increase CON or WIS by 1 (max 20)',
    'Proficiency with cook\'s utensils',
    'During short rest with cook\'s utensils, cook food for up to 6 creatures (regain extra HP = proficiency bonus)',
    'During long rest, cook treats equal to proficiency bonus (bonus action to eat for prof bonus temp HP)',
  ],
);

final Feat _crusher = Feat(
  name: 'Crusher',
  description: 'You are practiced in the art of crushing your enemies:',
  abilityScoreIncreases: {'Strength or Constitution': 1},
  benefits: [
    'Increase STR or CON by 1 (max 20)',
    'Once per turn, bludgeoning damage moves creature 5 feet to unoccupied space',
    'Critical with bludgeoning weapon, attack rolls against that creature have advantage until start of your next turn',
  ],
);

final Feat _eldritchAdept = Feat(
  name: 'Eldritch Adept',
  description: 'Studying occult lore, you learned to cast eldritch invocations:',
  prerequisites: ['Spellcasting or Pact Magic feature'],
  benefits: [
    'Learn one eldritch invocation (must meet prerequisites)',
    'Can replace invocation when gaining level',
  ],
);

final Feat _feyTouched = Feat(
  name: 'Fey Touched',
  description: 'Your exposure to Feywild\'s magic changed you:',
  abilityScoreIncreases: {'Intelligence, Wisdom, or Charisma': 1},
  benefits: [
    'Increase INT, WIS, or CHA by 1 (max 20)',
    'Learn misty step',
    'Learn one 1st-level divination or enchantment spell',
    'Can cast each 1/long rest or with spell slot',
  ],
);

final Feat _fightingInitiate = Feat(
  name: 'Fighting Initiate',
  description: 'Your martial training helped you develop particular style of fighting:',
  prerequisites: ['Proficiency with a martial weapon'],
  benefits: [
    'Learn one Fighting Style from fighter class',
  ],
);

final Feat _gunner = Feat(
  name: 'Gunner',
  description: 'You have quick draw and deadly aim with firearms:',
  abilityScoreIncreases: {'Dexterity': 1},
  benefits: [
    'Increase DEX by 1 (max 20)',
    'Proficiency with firearms',
    'Ignore loading property of firearms',
    'No disadvantage on ranged attacks for being within 5 feet',
  ],
);

final Feat _metamagicAdept = Feat(
  name: 'Metamagic Adept',
  description: 'You\'ve learned how to exert your will on your spells:',
  prerequisites: ['Spellcasting or Pact Magic feature'],
  benefits: [
    'Learn two Metamagic options from sorcerer',
    'Gain 2 sorcery points (regain on long rest)',
  ],
);

final Feat _piercer = Feat(
  name: 'Piercer',
  description: 'You achieve perfection in the art of piercing enemies:',
  abilityScoreIncreases: {'Strength or Dexterity': 1},
  benefits: [
    'Increase STR or DEX by 1 (max 20)',
    'Once per turn, reroll one piercing damage die',
    'Critical with piercing weapon rolls one extra damage die',
  ],
);

final Feat _poisoner = Feat(
  name: 'Poisoner',
  description: 'You can prepare and deliver deadly poisons:',
  benefits: [
    'Ignore poison damage resistance when you apply poison',
    'Can coat weapon as bonus action',
    'Proficiency with poisoner\'s kit',
    'Can create potent poison with poisoner\'s kit (50 gp, 1 hour; DC 14 CON save or 2d8 poison + poisoned 1 minute)',
  ],
);

final Feat _practicedExpert = Feat(
  name: 'Practiced Expert',
  description: 'You have honed your proficiency with particular skills:',
  abilityScoreIncreases: {'Any': 1},
  benefits: [
    'Increase one ability by 1 (max 20)',
    'Gain proficiency in one skill',
    'Choose one skill you\'re proficient in. Gain expertise',
  ],
);

final Feat _shadowTouched = Feat(
  name: 'Shadow Touched',
  description: 'Your exposure to Shadowfell\'s magic changed you:',
  abilityScoreIncreases: {'Intelligence, Wisdom, or Charisma': 1},
  benefits: [
    'Increase INT, WIS, or CHA by 1 (max 20)',
    'Learn invisibility',
    'Learn one 1st-level necromancy or illusion spell',
    'Can cast each 1/long rest or with spell slot',
  ],
);

final Feat _skillExpert = Feat(
  name: 'Skill Expert',
  description: 'You have honed your proficiency:',
  abilityScoreIncreases: {'Any': 1},
  benefits: [
    'Increase one ability by 1 (max 20)',
    'Gain proficiency in one skill',
    'Choose one skill you\'re proficient in. Gain expertise',
  ],
);

final Feat _slasher = Feat(
  name: 'Slasher',
  description: 'You\'ve learned where to cut to cause the most pain:',
  abilityScoreIncreases: {'Strength or Dexterity': 1},
  benefits: [
    'Increase STR or DEX by 1 (max 20)',
    'Once per turn, slashing damage reduces creature speed by 10 feet until start of your next turn',
    'Critical with slashing weapon causes disadvantage on attack rolls until start of your next turn',
  ],
);

final Feat _telekinetic = Feat(
  name: 'Telekinetic',
  description: 'You learn to move things with your mind:',
  abilityScoreIncreases: {'Intelligence, Wisdom, or Charisma': 1},
  benefits: [
    'Increase INT, WIS, or CHA by 1 (max 20)',
    'Learn mage hand (invisible)',
    'Bonus action to shove creature 5 feet with telekinesis (STR/DEX save)',
  ],
);

final Feat _telepathic = Feat(
  name: 'Telepathic',
  description: 'You awaken ability to mentally connect with others:',
  abilityScoreIncreases: {'Intelligence, Wisdom, or Charisma': 1},
  benefits: [
    'Increase INT, WIS, or CHA by 1 (max 20)',
    'Can speak telepathically to creature within 60 feet',
    'Learn detect thoughts (cast 1/long rest or with spell slot)',
  ],
);
