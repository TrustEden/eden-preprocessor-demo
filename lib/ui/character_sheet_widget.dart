import 'package:flutter/material.dart';
import '../models/enhanced_character.dart';
import '../services/character_advancement.dart';

class CharacterSheetWidget extends StatefulWidget {
  final EnhancedCharacter character;
  final Function(EnhancedCharacter)? onUpdate;

  const CharacterSheetWidget({
    Key? key,
    required this.character,
    this.onUpdate,
  }) : super(key: key);

  @override
  State<CharacterSheetWidget> createState() => _CharacterSheetWidgetState();
}

class _CharacterSheetWidgetState extends State<CharacterSheetWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.character.name),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.person), text: 'Stats'),
            Tab(icon: Icon(Icons.fitness_center), text: 'Combat'),
            Tab(icon: Icon(Icons.auto_fix_high), text: 'Spells'),
            Tab(icon: Icon(Icons.inventory), text: 'Inventory'),
            Tab(icon: Icon(Icons.info), text: 'Info'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildStatsTab(),
          _buildCombatTab(),
          _buildSpellsTab(),
          _buildInventoryTab(),
          _buildInfoTab(),
        ],
      ),
    );
  }

  // ==================== STATS TAB ====================

  Widget _buildStatsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildCharacterHeader(),
          const SizedBox(height: 24),
          _buildAbilityScores(),
          const SizedBox(height: 24),
          _buildProficienciesAndSkills(),
        ],
      ),
    );
  }

  Widget _buildCharacterHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              widget.character.name,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              '${widget.character.race.name} ${widget.character.characterClass.name}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Level ${widget.character.level}',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 16),
            _buildHPBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHPBar() {
    double hpPercent =
        widget.character.hitPointsCurrent / widget.character.hitPointsMax;
    Color hpColor = hpPercent > 0.5
        ? Colors.green
        : hpPercent > 0.25
            ? Colors.orange
            : Colors.red;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Hit Points'),
            Text(
              '${widget.character.hitPointsCurrent} / ${widget.character.hitPointsMax}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: hpPercent,
            backgroundColor: Colors.grey.shade300,
            color: hpColor,
            minHeight: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildAbilityScores() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ability Scores',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAbilityBox('STR', widget.character.strength),
                _buildAbilityBox('DEX', widget.character.dexterity),
                _buildAbilityBox('CON', widget.character.constitution),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAbilityBox('INT', widget.character.intelligence),
                _buildAbilityBox('WIS', widget.character.wisdom),
                _buildAbilityBox('CHA', widget.character.charisma),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAbilityBox(String name, int score) {
    int modifier = (score - 10) ~/ 2;
    String modStr = modifier >= 0 ? '+$modifier' : '$modifier';

    return Container(
      width: 80,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            name,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            '$score',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            modStr,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  Widget _buildProficienciesAndSkills() {
    int profBonus =
        CharacterAdvancement.getProficiencyBonus(widget.character.level);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Proficiency & Skills',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Chip(
                  label: Text('Proficiency +$profBonus'),
                  backgroundColor: Colors.blue.shade100,
                ),
              ],
            ),
            const Divider(),
            _buildSkillItem('Acrobatics', 'DEX', widget.character.dexterity),
            _buildSkillItem('Animal Handling', 'WIS', widget.character.wisdom),
            _buildSkillItem('Arcana', 'INT', widget.character.intelligence),
            _buildSkillItem('Athletics', 'STR', widget.character.strength),
            _buildSkillItem('Deception', 'CHA', widget.character.charisma),
            _buildSkillItem('History', 'INT', widget.character.intelligence),
            _buildSkillItem('Insight', 'WIS', widget.character.wisdom),
            _buildSkillItem(
                'Intimidation', 'CHA', widget.character.charisma),
            _buildSkillItem(
                'Investigation', 'INT', widget.character.intelligence),
            _buildSkillItem('Medicine', 'WIS', widget.character.wisdom),
            _buildSkillItem('Nature', 'INT', widget.character.intelligence),
            _buildSkillItem('Perception', 'WIS', widget.character.wisdom),
            _buildSkillItem('Performance', 'CHA', widget.character.charisma),
            _buildSkillItem('Persuasion', 'CHA', widget.character.charisma),
            _buildSkillItem('Religion', 'INT', widget.character.intelligence),
            _buildSkillItem('Sleight of Hand', 'DEX', widget.character.dexterity),
            _buildSkillItem('Stealth', 'DEX', widget.character.dexterity),
            _buildSkillItem('Survival', 'WIS', widget.character.wisdom),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillItem(String skillName, String ability, int abilityScore) {
    int modifier = widget.character.getSkillModifier(skillName);
    String modStr = modifier >= 0 ? '+$modifier' : '$modifier';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Text(
              ability,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ),
          Expanded(child: Text(skillName)),
          Text(
            modStr,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // ==================== COMBAT TAB ====================

  Widget _buildCombatTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildCombatStats(),
          const SizedBox(height: 16),
          _buildSavingThrows(),
          const SizedBox(height: 16),
          _buildWeaponsAndAttacks(),
        ],
      ),
    );
  }

  Widget _buildCombatStats() {
    int profBonus =
        CharacterAdvancement.getProficiencyBonus(widget.character.level);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCombatStat('AC', '${widget.character.armorClass}'),
                _buildCombatStat('Initiative',
                    '+${(widget.character.dexterity - 10) ~/ 2}'),
                _buildCombatStat('Speed', '${widget.character.race.speed} ft'),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCombatStat('Prof Bonus', '+$profBonus'),
                _buildCombatStat(
                    'Passive Perception', '${10 + widget.character.getSkillModifier('Perception')}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCombatStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildSavingThrows() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Saving Throws',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(),
            _buildSavingThrowItem('Strength', widget.character.strength),
            _buildSavingThrowItem('Dexterity', widget.character.dexterity),
            _buildSavingThrowItem('Constitution', widget.character.constitution),
            _buildSavingThrowItem('Intelligence', widget.character.intelligence),
            _buildSavingThrowItem('Wisdom', widget.character.wisdom),
            _buildSavingThrowItem('Charisma', widget.character.charisma),
          ],
        ),
      ),
    );
  }

  Widget _buildSavingThrowItem(String ability, int score) {
    int modifier = widget.character.getSavingThrowModifier(ability);
    String modStr = modifier >= 0 ? '+$modifier' : '$modifier';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(ability),
          Text(
            modStr,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildWeaponsAndAttacks() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weapons & Attacks',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.gps_fixed),
              title: Text('Unarmed Strike'),
              subtitle: Text('+2 to hit, 1 bludgeoning damage'),
            ),
            const Divider(),
            const Text(
              'Equip weapons from inventory to see them here',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== SPELLS TAB ====================

  Widget _buildSpellsTab() {
    if (widget.character.spellSlots == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text(
            'This class does not have spellcasting abilities.',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSpellSlots(),
          const SizedBox(height: 16),
          _buildSpellList(),
        ],
      ),
    );
  }

  Widget _buildSpellSlots() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Spell Slots',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(),
            for (int level = 1; level <= 9; level++)
              if (widget.character.spellSlots!.maxSlots[level] != null &&
                  widget.character.spellSlots!.maxSlots[level]! > 0)
                _buildSpellSlotRow(level),
          ],
        ),
      ),
    );
  }

  Widget _buildSpellSlotRow(int level) {
    int current = widget.character.spellSlots!.currentSlots[level] ?? 0;
    int max = widget.character.spellSlots!.maxSlots[level] ?? 0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text('Level $level'),
          ),
          Expanded(
            child: Row(
              children: List.generate(
                max,
                (index) => Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Icon(
                    index < current ? Icons.circle : Icons.circle_outlined,
                    size: 20,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ),
          Text('$current / $max'),
        ],
      ),
    );
  }

  Widget _buildSpellList() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Known Spells',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(),
            if (widget.character.cantrips.isEmpty &&
                widget.character.knownSpells.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'No spells learned yet.',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              )
            else ...[
              if (widget.character.cantrips.isNotEmpty) ...[
                const Text(
                  'Cantrips',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                for (var spell in widget.character.cantrips)
                  ListTile(
                    dense: true,
                    leading: const Icon(Icons.auto_awesome, size: 20),
                    title: Text(spell.name),
                    subtitle: Text(spell.school),
                  ),
                const Divider(),
              ],
              for (var spell in widget.character.knownSpells)
                ListTile(
                  dense: true,
                  leading: CircleAvatar(
                    radius: 12,
                    child: Text('${spell.level}'),
                  ),
                  title: Text(spell.name),
                  subtitle: Text(spell.school),
                ),
            ],
          ],
        ),
      ),
    );
  }

  // ==================== INVENTORY TAB ====================

  Widget _buildInventoryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildCurrencyCard(),
          const SizedBox(height: 16),
          _buildInventoryList(),
        ],
      ),
    );
  }

  Widget _buildCurrencyCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Currency',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(),
            _buildCurrencyRow('Platinum', 0, Colors.grey.shade400),
            _buildCurrencyRow('Gold', 0, Colors.amber),
            _buildCurrencyRow('Electrum', 0, Colors.grey.shade300),
            _buildCurrencyRow('Silver', 0, Colors.grey.shade400),
            _buildCurrencyRow('Copper', 0, Colors.brown.shade300),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyRow(String type, int amount, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.monetization_on, color: color, size: 20),
              const SizedBox(width: 8),
              Text(type),
            ],
          ),
          Text(
            '$amount',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryList() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Inventory',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(),
            if (widget.character.inventory.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Inventory is empty',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              )
            else
              for (var item in widget.character.inventory)
                ListTile(
                  leading: _getItemIcon(item.type),
                  title: Text(item.name),
                  subtitle: Text(item.description),
                  trailing: Text('${item.value} gp'),
                ),
          ],
        ),
      ),
    );
  }

  Icon _getItemIcon(String type) {
    switch (type.toLowerCase()) {
      case 'weapon':
        return const Icon(Icons.gps_fixed);
      case 'armor':
        return const Icon(Icons.shield);
      case 'potion':
        return const Icon(Icons.local_drink);
      case 'scroll':
        return const Icon(Icons.description);
      case 'wondrous':
        return const Icon(Icons.auto_awesome);
      default:
        return const Icon(Icons.inventory_2);
    }
  }

  // ==================== INFO TAB ====================

  Widget _buildInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildBackgroundCard(),
          const SizedBox(height: 16),
          _buildFeaturesCard(),
          const SizedBox(height: 16),
          _buildFeatsCard(),
        ],
      ),
    );
  }

  Widget _buildBackgroundCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Character Info',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(),
            _buildInfoRow('Race', widget.character.race.name),
            _buildInfoRow('Class', widget.character.characterClass.name),
            _buildInfoRow(
                'Background', widget.character.background?.name ?? 'None'),
            _buildInfoRow('Level', '${widget.character.level}'),
            _buildInfoRow('Hit Die', '1d${widget.character.characterClass.hitDie}'),
            _buildInfoRow(
                'Size', widget.character.race.size),
            _buildInfoRow(
                'Speed', '${widget.character.race.speed} ft'),
            if (widget.character.race.darkvision > 0)
              _buildInfoRow('Darkvision',
                  '${widget.character.race.darkvision} ft'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildFeaturesCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Class Features',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(),
            for (int level = 1; level <= widget.character.level; level++)
              if (widget.character.characterClass.featuresByLevel[level] != null)
                for (var feature
                    in widget.character.characterClass.featuresByLevel[level]!)
                  ExpansionTile(
                    title: Text(feature.name),
                    subtitle: Text('Level $level'),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(feature.description),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Feats',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(),
            if (widget.character.feats.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'No feats selected yet.',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              )
            else
              for (var feat in widget.character.feats)
                ExpansionTile(
                  title: Text(feat.name),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(feat.description),
                    ),
                  ],
                ),
          ],
        ),
      ),
    );
  }
}
