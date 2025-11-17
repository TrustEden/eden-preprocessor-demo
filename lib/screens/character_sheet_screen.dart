import 'package:flutter/material.dart';
import '../models/character.dart';

class CharacterSheetScreen extends StatelessWidget {
  final Character character;

  const CharacterSheetScreen({Key? key, required this.character})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Character Sheet'),
        backgroundColor: Colors.brown[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      character.name,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${character.race} ${character.className} - Level ${character.level}',
                      style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 8),
                    Text('Experience: ${character.experience} XP'),
                    Text('Fighting Style: ${character.fightingStyle}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Combat Stats
            const Text(
              'Combat Stats',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildStatRow('Hit Points',
                        '${character.hpCurrent} / ${character.hpMax}'),
                    _buildStatRow('Armor Class', '${character.armorClass}'),
                    _buildStatRow(
                        'Initiative Bonus', '+${character.initiativeBonus}'),
                    _buildStatRow(
                        'Proficiency Bonus', '+${character.proficiencyBonus}'),
                    _buildStatRow('Attack Bonus', '+${character.getAttackBonus()}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Ability Scores
            const Text(
              'Ability Scores',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildAbilityRow(
                        'Strength', character.strength, character.strengthModifier),
                    _buildAbilityRow('Dexterity', character.dexterity,
                        character.dexterityModifier),
                    _buildAbilityRow('Constitution', character.constitution,
                        character.constitutionModifier),
                    _buildAbilityRow('Intelligence', character.intelligence,
                        character.intelligenceModifier),
                    _buildAbilityRow(
                        'Wisdom', character.wisdom, character.wisdomModifier),
                    _buildAbilityRow('Charisma', character.charisma,
                        character.charismaModifier),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Skills
            const Text(
              'Proficient Skills',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (character.athleticsProficient)
                      _buildSkillRow('Athletics',
                          character.getSkillModifier('athletics')),
                    if (character.perceptionProficient)
                      _buildSkillRow('Perception',
                          character.getSkillModifier('perception')),
                    if (character.survivalProficient)
                      _buildSkillRow(
                          'Survival', character.getSkillModifier('survival')),
                    if (character.intimidationProficient)
                      _buildSkillRow('Intimidation',
                          character.getSkillModifier('intimidation')),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Fighter Features
            const Text(
              'Class Features',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Second Wind (${character.secondWindUses}/1 uses)',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text('  Heal 1d10 + level HP as a bonus action'),
                    if (character.level >= 2) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Action Surge (${character.actionSurgeUses}/1 uses)',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Text('  Take an additional action on your turn'),
                    ],
                    if (character.level >= 5) ...[
                      const SizedBox(height: 8),
                      const Text(
                        'Extra Attack',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Text('  Attack twice when you take the Attack action'),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Equipment
            const Text(
              'Equipment',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Equipped:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    if (character.equippedWeapon != null) ...[
                      const SizedBox(height: 4),
                      Text('⚔️ ${character.equippedWeapon!.name}'),
                      Text(
                        '  Damage: ${character.equippedWeapon!.damageDice} ${character.equippedWeapon!.damageType}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                    if (character.equippedArmor != null) ...[
                      const SizedBox(height: 4),
                      Text('🛡️ ${character.equippedArmor!.name}'),
                      Text(
                        '  AC: ${character.equippedArmor!.armorBonus}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                    if (character.equippedShield != null) ...[
                      const SizedBox(height: 4),
                      Text('🛡️ ${character.equippedShield!.name}'),
                      Text(
                        '  AC: +${character.equippedShield!.armorBonus}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                    const SizedBox(height: 16),
                    const Text(
                      'Inventory:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    ...character.inventory
                        .where((item) =>
                            item != character.equippedWeapon &&
                            item != character.equippedArmor &&
                            item != character.equippedShield)
                        .map((item) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Text(
                                '${_getItemIcon(item.type)} ${item.name}${item.quantity != null ? " (${item.quantity})" : ""}',
                              ),
                            )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildAbilityRow(String ability, int score, int modifier) {
    String modStr = modifier >= 0 ? '+$modifier' : '$modifier';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(ability, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text('$score ($modStr)',
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSkillRow(String skill, int modifier) {
    String modStr = modifier >= 0 ? '+$modifier' : '$modifier';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text('$skill $modStr'),
    );
  }

  String _getItemIcon(String type) {
    switch (type) {
      case 'weapon':
        return '⚔️';
      case 'armor':
        return '🛡️';
      case 'consumable':
        return '🧪';
      default:
        return '📦';
    }
  }
}
