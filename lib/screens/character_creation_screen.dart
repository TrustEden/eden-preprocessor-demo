import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/character.dart';
import '../models/item.dart';
import '../models/game_state.dart';
import '../services/database_service.dart';
import 'main_game_screen.dart';

class CharacterCreationScreen extends StatefulWidget {
  const CharacterCreationScreen({Key? key}) : super(key: key);

  @override
  _CharacterCreationScreenState createState() =>
      _CharacterCreationScreenState();
}

class _CharacterCreationScreenState extends State<CharacterCreationScreen> {
  final _nameController = TextEditingController();
  String _fightingStyle = 'Defense';
  final _dbService = DatabaseService();

  // Use standard array for ability scores
  final Map<String, int> abilityScores = {
    'strength': 15,
    'dexterity': 14,
    'constitution': 13,
    'intelligence': 12,
    'wisdom': 10,
    'charisma': 8,
  };

  Future<void> _createCharacter() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a name')),
      );
      return;
    }

    int conMod = (abilityScores['constitution']! - 10) ~/ 2;

    Character character = Character(
      id: const Uuid().v4(),
      name: _nameController.text,
      race: 'Human',
      className: 'Fighter',
      level: 1,
      experience: 0,
      strength: abilityScores['strength']!,
      dexterity: abilityScores['dexterity']!,
      constitution: abilityScores['constitution']!,
      intelligence: abilityScores['intelligence']!,
      wisdom: abilityScores['wisdom']!,
      charisma: abilityScores['charisma']!,
      hpCurrent: 10 + conMod,
      hpMax: 10 + conMod,
      armorClass: 10,
      proficiencyBonus: 2,
      secondWindUses: 1,
      actionSurgeUses: 0, // Gained at level 2
      fightingStyle: _fightingStyle,
      inventory: _getStartingEquipment(),
    );

    // Equip starting gear
    _equipStartingGear(character);

    // Create new game state
    GameState gameState = GameState(
      campaignId: const Uuid().v4(),
      campaignName: '${character.name}\'s Adventure',
      character: character,
      currentLocation: 'The Crossroads Tavern',
      currentSceneDescription:
          'You stand at the entrance of a weathered tavern. The wooden sign above reads "The Crossroads Inn". Inside, you can hear the murmur of patrons and the crackling of a fireplace. Your adventure begins here.',
      sessionNumber: 1,
    );

    // Add initial event
    gameState.narrativeHistory.add(GameEvent(
      eventType: 'narrative',
      description: 'Campaign started',
      dmResponse: gameState.currentSceneDescription,
    ));

    // Save to database
    await _dbService.saveGameState(gameState);

    // Navigate to game screen
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => MainGameScreen(gameState: gameState),
      ),
    );
  }

  List<Item> _getStartingEquipment() {
    return [
      Item(
        id: const Uuid().v4(),
        name: 'Longsword',
        type: 'weapon',
        weight: 3,
        value: 15,
        damageDice: '1d8',
        damageType: 'slashing',
        weaponProperties: ['versatile'],
      ),
      Item(
        id: const Uuid().v4(),
        name: 'Chain Mail',
        type: 'armor',
        weight: 55,
        value: 75,
        armorBonus: 16,
        armorType: 'heavy',
      ),
      Item(
        id: const Uuid().v4(),
        name: 'Shield',
        type: 'armor',
        weight: 6,
        value: 10,
        armorBonus: 2,
        armorType: 'shield',
      ),
      Item(
        id: const Uuid().v4(),
        name: 'Healing Potion',
        type: 'consumable',
        weight: 0,
        value: 50,
        effect: 'heal_2d4+2',
        quantity: 2,
      ),
    ];
  }

  void _equipStartingGear(Character character) {
    character.equippedWeapon =
        character.inventory.firstWhere((i) => i.name == 'Longsword');
    character.equippedArmor =
        character.inventory.firstWhere((i) => i.name == 'Chain Mail');
    character.equippedShield =
        character.inventory.firstWhere((i) => i.name == 'Shield');

    character.recalculateArmorClass();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Your Fighter'),
        backgroundColor: Colors.brown[700],
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Character Name:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: 'Enter your character\'s name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Fighting Style:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                RadioListTile(
                  title: const Text('Defense (+1 AC while wearing armor)'),
                  value: 'Defense',
                  groupValue: _fightingStyle,
                  onChanged: (value) => setState(() => _fightingStyle = value!),
                ),
                RadioListTile(
                  title: const Text('Dueling (+2 damage with one-handed weapon)'),
                  value: 'Dueling',
                  groupValue: _fightingStyle,
                  onChanged: (value) => setState(() => _fightingStyle = value!),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Ability Scores (Standard Array):',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'STR: 15 (+2)  DEX: 14 (+2)  CON: 13 (+1)',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                Text(
                  'INT: 12 (+1)  WIS: 10 (+0)  CHA: 8 (-1)',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Starting Equipment:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text('• Longsword', style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                Text('• Chain Mail & Shield', style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                Text('• 2x Healing Potions', style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _createCharacter,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      backgroundColor: Colors.brown[700],
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Begin Adventure',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
