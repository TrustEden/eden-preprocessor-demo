import 'dart:math';
import '../models/monster.dart';
import '../models/item.dart';

class DungeonRoom {
  String id;
  String description;
  List<Monster> monsters;
  List<Item> treasure;
  bool isCleared;
  List<String> connectedRoomIds; // IDs of connected rooms
  String roomType; // "combat", "treasure", "trap", "puzzle", "empty", "boss"

  DungeonRoom({
    required this.id,
    required this.description,
    List<Monster>? monsters,
    List<Item>? treasure,
    this.isCleared = false,
    List<String>? connectedRoomIds,
    required this.roomType,
  })  : monsters = monsters ?? [],
        treasure = treasure ?? [],
        connectedRoomIds = connectedRoomIds ?? [];

  Map<String, dynamic> toJson() => {
        'id': id,
        'description': description,
        'monsters': monsters.map((m) => m.toJson()).toList(),
        'treasure': treasure.map((t) => t.toJson()).toList(),
        'isCleared': isCleared,
        'connectedRoomIds': connectedRoomIds,
        'roomType': roomType,
      };

  factory DungeonRoom.fromJson(Map<String, dynamic> json) => DungeonRoom(
        id: json['id'] as String,
        description: json['description'] as String,
        monsters: (json['monsters'] as List<dynamic>)
            .map((m) => Monster.fromJson(m as Map<String, dynamic>))
            .toList(),
        treasure: (json['treasure'] as List<dynamic>)
            .map((t) => Item.fromJson(t as Map<String, dynamic>))
            .toList(),
        isCleared: json['isCleared'] as bool,
        connectedRoomIds:
            (json['connectedRoomIds'] as List<dynamic>).cast<String>(),
        roomType: json['roomType'] as String,
      );
}

class Dungeon {
  String id;
  String name;
  String theme; // "undead", "goblin_lair", "dragon_lair", "dungeon", "cave"
  int difficulty; // 1-5
  List<DungeonRoom> rooms;
  String currentRoomId;

  Dungeon({
    required this.id,
    required this.name,
    required this.theme,
    required this.difficulty,
    required this.rooms,
    required this.currentRoomId,
  });

  DungeonRoom? getCurrentRoom() {
    try {
      return rooms.firstWhere((r) => r.id == currentRoomId);
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'theme': theme,
        'difficulty': difficulty,
        'rooms': rooms.map((r) => r.toJson()).toList(),
        'currentRoomId': currentRoomId,
      };

  factory Dungeon.fromJson(Map<String, dynamic> json) => Dungeon(
        id: json['id'] as String,
        name: json['name'] as String,
        theme: json['theme'] as String,
        difficulty: json['difficulty'] as int,
        rooms: (json['rooms'] as List<dynamic>)
            .map((r) => DungeonRoom.fromJson(r as Map<String, dynamic>))
            .toList(),
        currentRoomId: json['currentRoomId'] as String,
      );
}

class DungeonGenerator {
  static final Random _rng = Random();

  static Dungeon generate({
    required int partyLevel,
    required int difficulty, // 1-5 (Easy to Deadly)
    required int numberOfRooms,
    required String theme,
  }) {
    List<DungeonRoom> rooms = [];

    // Generate entrance
    rooms.add(_generateRoom(
      index: 0,
      theme: theme,
      roomType: 'empty',
      partyLevel: partyLevel,
      difficulty: difficulty,
    ));

    // Generate middle rooms
    for (int i = 1; i < numberOfRooms - 1; i++) {
      String roomType = _selectRoomType();
      rooms.add(_generateRoom(
        index: i,
        theme: theme,
        roomType: roomType,
        partyLevel: partyLevel,
        difficulty: difficulty,
      ));
    }

    // Generate boss room
    if (numberOfRooms > 1) {
      rooms.add(_generateRoom(
        index: numberOfRooms - 1,
        theme: theme,
        roomType: 'boss',
        partyLevel: partyLevel,
        difficulty: difficulty,
      ));
    }

    // Connect rooms linearly (in real implementation would create branching paths)
    for (int i = 0; i < rooms.length - 1; i++) {
      rooms[i].connectedRoomIds.add(rooms[i + 1].id);
      rooms[i + 1].connectedRoomIds.add(rooms[i].id);
    }

    String dungeonName = _generateDungeonName(theme);

    return Dungeon(
      id: 'dungeon_${DateTime.now().millisecondsSinceEpoch}',
      name: dungeonName,
      theme: theme,
      difficulty: difficulty,
      rooms: rooms,
      currentRoomId: rooms[0].id,
    );
  }

  static String _selectRoomType() {
    double roll = _rng.nextDouble();
    if (roll < 0.4) return 'combat';
    if (roll < 0.6) return 'treasure';
    if (roll < 0.75) return 'trap';
    if (roll < 0.85) return 'puzzle';
    return 'empty';
  }

  static DungeonRoom _generateRoom({
    required int index,
    required String theme,
    required String roomType,
    required int partyLevel,
    required int difficulty,
  }) {
    String description = _generateRoomDescription(theme, roomType, index);
    List<Monster> monsters = [];
    List<Item> treasure = [];

    if (roomType == 'combat') {
      monsters = _generateEncounter(theme, partyLevel, difficulty);
      treasure = _generateTreasure(partyLevel, difficulty: 2);
    } else if (roomType == 'boss') {
      monsters = _generateBossEncounter(theme, partyLevel);
      treasure = _generateTreasure(partyLevel, difficulty: 4);
    } else if (roomType == 'treasure') {
      treasure = _generateTreasure(partyLevel, difficulty: 3);
    }

    return DungeonRoom(
      id: 'room_$index',
      description: description,
      monsters: monsters,
      treasure: treasure,
      roomType: roomType,
    );
  }

  static String _generateRoomDescription(
      String theme, String roomType, int index) {
    List<String> descriptions = [];

    switch (theme) {
      case 'undead':
        descriptions = [
          'A dark tomb with ancient sarcophagi lining the walls. The air is thick with the smell of decay.',
          'A crypt filled with dusty bones and crumbling graves. Eerie whispers echo through the chamber.',
          'A skeletal remains of a burial chamber. Cobwebs hang from every corner.',
          'An ossuary packed with thousands of bones. Candles flicker with unnatural green flames.',
        ];
        break;
      case 'goblin_lair':
        descriptions = [
          'A crude cavern with crude furniture and filth everywhere. The stench is overwhelming.',
          'A hastily dug tunnel with rough walls. Goblin graffiti covers the stone.',
          'A cluttered den filled with stolen goods and trash. Small footprints cover the floor.',
          'A warren of interconnected caves. The sound of chittering echoes in the distance.',
        ];
        break;
      case 'dragon_lair':
        descriptions = [
          'A vast cavern with a high ceiling. Scorch marks cover the walls and floor.',
          'A treasure chamber with piles of gold coins scattered about. The heat is oppressive.',
          'A volcanic cave with lava flows. The smell of sulfur fills the air.',
          'An ancient dragon\'s roost. Massive claw marks gouge the stone.',
        ];
        break;
      case 'dungeon':
        descriptions = [
          'A stone corridor with iron-banded doors. Torches flicker on the walls.',
          'A prison cell block with rusted bars. Old chains hang from the ceiling.',
          'A guard room with weapon racks and a table. A cold draft blows through.',
          'A torture chamber with sinister devices. Dark stains cover the floor.',
        ];
        break;
      default:
        descriptions = [
          'A dark cave with stalactites hanging from the ceiling. Water drips steadily.',
          'A natural cavern with rough stone walls. Strange fungi grow in the corners.',
          'An underground chamber. The sound of running water echoes.',
          'A rocky passage that winds deeper underground. Bats flutter overhead.',
        ];
    }

    String baseDesc = descriptions[_rng.nextInt(descriptions.length)];

    // Add room type flavor
    if (roomType == 'treasure') {
      baseDesc += ' You notice something glinting in the shadows.';
    } else if (roomType == 'trap') {
      baseDesc += ' Something about this room feels... dangerous.';
    } else if (roomType == 'boss') {
      baseDesc += ' This appears to be the lair of something powerful.';
    }

    return baseDesc;
  }

  static List<Monster> _generateEncounter(
      String theme, int partyLevel, int difficulty) {
    // Simplified encounter generation
    List<Monster> encounter = [];

    double minCR = max(0.125, (partyLevel - 2) / 2);
    double maxCR = partyLevel.toDouble();

    // Increase CR for harder difficulties
    if (difficulty >= 3) maxCR += 1;
    if (difficulty >= 4) maxCR += 1;

    int numMonsters = _rng.nextInt(3) + 1; // 1-3 monsters

    for (int i = 0; i < numMonsters; i++) {
      Monster monster = Monsters.getRandomMonsterByCR(minCR, maxCR);
      encounter.add(monster);
    }

    return encounter;
  }

  static List<Monster> _generateBossEncounter(String theme, int partyLevel) {
    // Boss is higher CR
    double bossCR = partyLevel + 2.0;

    Monster boss = Monsters.getRandomMonsterByCR(bossCR - 1, bossCR);

    // Add some minions
    List<Monster> encounter = [boss];
    int numMinions = _rng.nextInt(2) + 1;

    for (int i = 0; i < numMinions; i++) {
      Monster minion = Monsters.getRandomMonsterByCR(0.25, partyLevel / 2);
      encounter.add(minion);
    }

    return encounter;
  }

  static List<Item> _generateTreasure(int partyLevel, {int difficulty = 2}) {
    List<Item> treasure = [];

    // Gold
    int goldAmount = (partyLevel * 10 * difficulty) + _rng.nextInt(50);
    treasure.add(Item(
      id: 'gold_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Gold Coins',
      effect: '$goldAmount gold pieces',
      type: 'currency',
      weight: 0,
      value: goldAmount,
    ));

    // Random items based on level and difficulty
    if (_rng.nextDouble() < 0.3 * difficulty) {
      // Potion
      treasure.add(Item(
        id: 'potion_healing_${DateTime.now().millisecondsSinceEpoch}',
        name: 'Potion of Healing',
        effect: '2d4+2',
        type: 'consumable',
        weight: 1,
        value: 50,
      ));
    }

    if (partyLevel >= 5 && _rng.nextDouble() < 0.2 * difficulty) {
      // Magic weapon
      treasure.add(Item(
        id: 'magic_weapon_${DateTime.now().millisecondsSinceEpoch}',
        name: '+1 Longsword',
        effect: 'A finely crafted longsword with a +1 bonus',
        type: 'weapon',
        weight: 3,
        value: 500,
        damageDice: '1d8+1',
        damageType: 'martial',
      ));
    }

    return treasure;
  }

  static String _generateDungeonName(String theme) {
    Map<String, List<String>> nameTemplates = {
      'undead': [
        'The Tomb of Eternal Rest',
        'The Catacombs of the Forgotten',
        'The Crypt of Shadows',
        'The Necropolis',
      ],
      'goblin_lair': [
        'The Goblin Warren',
        'Snaggle-Tooth\'s Lair',
        'The Filthy Caves',
        'The Goblin King\'s Domain',
      ],
      'dragon_lair': [
        'The Dragon\'s Hoard',
        'The Wyrm\'s Nest',
        'The Scorched Caverns',
        'The Ancient Dragon\'s Lair',
      ],
      'dungeon': [
        'The Black Dungeon',
        'The Iron Prison',
        'The Forgotten Fortress',
        'The Dark Keep',
      ],
    };

    List<String> names = nameTemplates[theme] ?? [
      'The Deep Caves',
      'The Dark Depths',
      'The Unknown Caverns',
    ];

    return names[_rng.nextInt(names.length)];
  }
}

class NPCGenerator {
  static final Random _rng = Random();

  static GeneratedNPC generate() {
    String name = _generateName();
    String race = _selectRace();
    String occupation = _selectOccupation();
    String personality = _generatePersonality();
    String quirk = _generateQuirk();

    return GeneratedNPC(
      id: 'npc_${DateTime.now().millisecondsSinceEpoch}_${_rng.nextInt(1000)}',
      name: name,
      race: race,
      occupation: occupation,
      personality: personality,
      quirk: quirk,
    );
  }

  static String _generateName() {
    List<String> firstNames = [
      'Aldric',
      'Brenna',
      'Cedric',
      'Dalia',
      'Eldon',
      'Fiona',
      'Gareth',
      'Helena',
      'Ivan',
      'Jessa',
      'Kael',
      'Luna',
      'Marcus',
      'Nora',
      'Owen',
      'Petra',
    ];

    List<String> lastNames = [
      'Ironforge',
      'Stormwind',
      'Brightblade',
      'Shadowbrook',
      'Goldleaf',
      'Stoneheart',
      'Swiftarrow',
      'Moonwhisper',
    ];

    return '${firstNames[_rng.nextInt(firstNames.length)]} ${lastNames[_rng.nextInt(lastNames.length)]}';
  }

  static String _selectRace() {
    List<String> races = [
      'Human',
      'Elf',
      'Dwarf',
      'Halfling',
      'Half-Elf',
      'Tiefling',
    ];
    return races[_rng.nextInt(races.length)];
  }

  static String _selectOccupation() {
    List<String> occupations = [
      'Blacksmith',
      'Merchant',
      'Innkeeper',
      'Guard',
      'Farmer',
      'Scholar',
      'Priest',
      'Thief',
      'Bard',
      'Alchemist',
    ];
    return occupations[_rng.nextInt(occupations.length)];
  }

  static String _generatePersonality() {
    List<String> personalities = [
      'Friendly and outgoing',
      'Suspicious and cautious',
      'Greedy and opportunistic',
      'Kind and generous',
      'Gruff but fair',
      'Nervous and twitchy',
      'Arrogant and condescending',
      'Wise and thoughtful',
      'Cheerful and optimistic',
      'Cynical and bitter',
    ];
    return personalities[_rng.nextInt(personalities.length)];
  }

  static String _generateQuirk() {
    List<String> quirks = [
      'Always whistles while working',
      'Collects odd trinkets',
      'Speaks in rhymes',
      'Has a pet rat named Squeakers',
      'Constantly chews on a piece of straw',
      'Laughs at inappropriate times',
      'Uses big words incorrectly',
      'Always counting on their fingers',
      'Taps their foot constantly',
      'Winks excessively',
    ];
    return quirks[_rng.nextInt(quirks.length)];
  }
}

class GeneratedNPC {
  String id;
  String name;
  String race;
  String occupation;
  String personality;
  String quirk;

  GeneratedNPC({
    required this.id,
    required this.name,
    required this.race,
    required this.occupation,
    required this.personality,
    required this.quirk,
  });

  String getDescription() {
    return '$name is a $race $occupation. They are $personality and $quirk.';
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'race': race,
        'occupation': occupation,
        'personality': personality,
        'quirk': quirk,
      };

  factory GeneratedNPC.fromJson(Map<String, dynamic> json) => GeneratedNPC(
        id: json['id'] as String,
        name: json['name'] as String,
        race: json['race'] as String,
        occupation: json['occupation'] as String,
        personality: json['personality'] as String,
        quirk: json['quirk'] as String,
      );
}
