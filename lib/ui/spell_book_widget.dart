import 'package:flutter/material.dart';
import '../models/spell.dart';
import '../models/enhanced_character.dart';

class SpellBookWidget extends StatefulWidget {
  final EnhancedCharacter character;
  final Function(Spell, int)? onSpellCast;
  final Function(Spell)? onSpellPrepare;
  final Function(Spell)? onSpellUnprepare;

  const SpellBookWidget({
    Key? key,
    required this.character,
    this.onSpellCast,
    this.onSpellPrepare,
    this.onSpellUnprepare,
  }) : super(key: key);

  @override
  State<SpellBookWidget> createState() => _SpellBookWidgetState();
}

class _SpellBookWidgetState extends State<SpellBookWidget> {
  int _selectedLevel = 0; // 0 = cantrips, 1-9 = spell levels
  String _searchQuery = '';
  SpellSchool? _selectedSchool;
  bool _showPreparedOnly = false;

  List<Spell> get _filteredSpells {
    List<Spell> spells = widget.character.knownSpells;

    // Filter by level
    spells = spells.where((spell) => spell.level == _selectedLevel).toList();

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      spells = spells
          .where((spell) =>
              spell.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              spell.description
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
          .toList();
    }

    // Filter by school
    if (_selectedSchool != null) {
      spells = spells.where((spell) => spell.school == _selectedSchool!.name).toList();
    }

    // Filter by prepared
    if (_showPreparedOnly) {
      spells = spells
          .where((spell) =>
              widget.character.preparedSpells.any((s) => s.id == spell.id))
          .toList();
    }

    return spells;
  }

  bool _isSpellPrepared(Spell spell) {
    return widget.character.preparedSpells.any((s) => s.id == spell.id);
  }

  bool _canPrepareMoreSpells() {
    int maxPrepared = _calculateMaxPreparedSpells();
    return widget.character.preparedSpells.length < maxPrepared;
  }

  int _calculateMaxPreparedSpells() {
    String classId = widget.character.characterClass.id;
    int spellcastingMod = _getSpellcastingModifier();

    // Different classes have different rules
    if (classId == 'wizard' || classId == 'cleric' || classId == 'druid') {
      return widget.character.level + spellcastingMod;
    } else if (classId == 'paladin' || classId == 'ranger') {
      return (widget.character.level ~/ 2) + spellcastingMod;
    }

    // Bard, Sorcerer, Warlock don't prepare spells
    return 0;
  }

  int _getSpellcastingModifier() {
    String primaryAbility = widget.character.characterClass.primaryAbility;

    switch (primaryAbility.toLowerCase()) {
      case 'intelligence':
        return (widget.character.intelligence - 10) ~/ 2;
      case 'wisdom':
        return (widget.character.wisdom - 10) ~/ 2;
      case 'charisma':
        return (widget.character.charisma - 10) ~/ 2;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spell Book'),
        actions: [
          IconButton(
            icon: Icon(
              _showPreparedOnly ? Icons.bookmark : Icons.bookmark_border,
              color: _showPreparedOnly ? Colors.amber : null,
            ),
            onPressed: () {
              setState(() {
                _showPreparedOnly = !_showPreparedOnly;
              });
            },
            tooltip: 'Show Prepared Only',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSpellSlotTracker(),
          _buildSearchBar(),
          _buildLevelSelector(),
          _buildSchoolFilter(),
          Expanded(
            child: _filteredSpells.isEmpty
                ? _buildEmptyState()
                : _buildSpellList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSpellSlotTracker() {
    if (widget.character.spellSlots == null) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Spell Slots',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                for (int level = 1; level <= 9; level++)
                  if (_getMaxSlotsForLevel(level) > 0)
                    _buildSlotLevel(level),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlotLevel(int level) {
    int maxSlots = _getMaxSlotsForLevel(level);
    int usedSlots = _getUsedSlotsForLevel(level);
    int remainingSlots = maxSlots - usedSlots;

    return Column(
      children: [
        Text(
          'Level $level',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < maxSlots; i++)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Icon(
                  i < remainingSlots ? Icons.circle : Icons.circle_outlined,
                  size: 16,
                  color: i < remainingSlots ? Colors.blue : Colors.grey,
                ),
              ),
          ],
        ),
        Text(
          '$remainingSlots/$maxSlots',
          style: const TextStyle(fontSize: 10),
        ),
      ],
    );
  }

  int _getMaxSlotsForLevel(int level) {
    if (widget.character.spellSlots == null) return 0;
    return widget.character.spellSlots!.maxSlots[level] ?? 0;
  }

  int _getUsedSlotsForLevel(int level) {
    if (widget.character.spellSlots == null) return 0;

    int maxSlots = widget.character.spellSlots!.maxSlots[level] ?? 0;
    int currentSlots = widget.character.spellSlots!.currentSlots[level] ?? 0;
    return maxSlots - currentSlots;
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search spells...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildLevelSelector() {
    return SizedBox(
      height: 60,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          _buildLevelChip('Cantrips', 0),
          for (int level = 1; level <= 9; level++) _buildLevelChip('$level', level),
        ],
      ),
    );
  }

  Widget _buildLevelChip(String label, int level) {
    bool isSelected = _selectedLevel == level;
    int spellCount =
        widget.character.knownSpells.where((s) => s.level == level).length;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label),
            Text(
              '($spellCount)',
              style: const TextStyle(fontSize: 10),
            ),
          ],
        ),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedLevel = level;
          });
        },
        selectedColor: Colors.blue.shade200,
      ),
    );
  }

  Widget _buildSchoolFilter() {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          _buildSchoolChip('All', null),
          for (var school in SpellSchool.values)
            _buildSchoolChip(school.name, school),
        ],
      ),
    );
  }

  Widget _buildSchoolChip(String label, SpellSchool? school) {
    bool isSelected = _selectedSchool == school;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedSchool = school;
          });
        },
        selectedColor: _getSchoolColor(school),
      ),
    );
  }

  Color _getSchoolColor(SpellSchool? school) {
    if (school == null) return Colors.grey.shade300;

    switch (school) {
      case SpellSchool.abjuration:
        return Colors.blue.shade200;
      case SpellSchool.conjuration:
        return Colors.purple.shade200;
      case SpellSchool.divination:
        return Colors.cyan.shade200;
      case SpellSchool.enchantment:
        return Colors.pink.shade200;
      case SpellSchool.evocation:
        return Colors.red.shade200;
      case SpellSchool.illusion:
        return Colors.indigo.shade200;
      case SpellSchool.necromancy:
        return Colors.grey.shade400;
      case SpellSchool.transmutation:
        return Colors.orange.shade200;
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.auto_stories,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No spells found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters',
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildSpellList() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _filteredSpells.length,
      itemBuilder: (context, index) {
        return _buildSpellCard(_filteredSpells[index]);
      },
    );
  }

  Widget _buildSpellCard(Spell spell) {
    bool isPrepared = _isSpellPrepared(spell);
    Color schoolColor = _getSchoolColor(_getSchoolEnum(spell.school));

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isPrepared ? Colors.amber : schoolColor,
          width: isPrepared ? 3 : 1,
        ),
      ),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: schoolColor,
          child: Text(
            spell.level == 0 ? 'C' : '${spell.level}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                spell.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (isPrepared)
              const Icon(Icons.bookmark, color: Colors.amber, size: 20),
            if (spell.concentration)
              const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Chip(
                  label: Text('C', style: TextStyle(fontSize: 10)),
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.zero,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            if (spell.ritual)
              const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Chip(
                  label: Text('R', style: TextStyle(fontSize: 10)),
                  backgroundColor: Colors.purple,
                  padding: EdgeInsets.zero,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
          ],
        ),
        subtitle: Text(
          '${spell.school} • ${spell.castingTime}',
          style: const TextStyle(fontStyle: FontStyle.italic),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSpellDetailRow('Range', spell.range),
                _buildSpellDetailRow('Duration', spell.duration),
                _buildSpellDetailRow(
                  'Components',
                  spell.components.join(', ') +
                      (spell.materialComponents != null
                          ? ' (${spell.materialComponents})'
                          : ''),
                ),
                if (spell.damageType != null)
                  _buildSpellDetailRow('Damage', '${spell.damageDice} ${spell.damageType}'),
                if (spell.savingThrow != null)
                  _buildSpellDetailRow('Save', spell.savingThrow!),
                const Divider(height: 24),
                Text(
                  spell.description,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (_shouldShowPrepareButton())
                      OutlinedButton.icon(
                        onPressed: () {
                          if (isPrepared) {
                            widget.onSpellUnprepare?.call(spell);
                            setState(() {});
                          } else if (_canPrepareMoreSpells()) {
                            widget.onSpellPrepare?.call(spell);
                            setState(() {});
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Maximum spells prepared'),
                              ),
                            );
                          }
                        },
                        icon: Icon(
                          isPrepared ? Icons.bookmark_remove : Icons.bookmark_add,
                        ),
                        label: Text(isPrepared ? 'Unprepare' : 'Prepare'),
                      ),
                    const SizedBox(width: 8),
                    if (spell.level > 0)
                      ElevatedButton.icon(
                        onPressed: () => _showCastDialog(spell),
                        icon: const Icon(Icons.auto_fix_high),
                        label: const Text('Cast'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: schoolColor,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _shouldShowPrepareButton() {
    String classId = widget.character.characterClass.id;
    return ['wizard', 'cleric', 'druid', 'paladin', 'ranger'].contains(classId);
  }

  Widget _buildSpellDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  void _showCastDialog(Spell spell) {
    showDialog(
      context: context,
      builder: (context) => _CastSpellDialog(
        spell: spell,
        character: widget.character,
        onCast: (level) {
          widget.onSpellCast?.call(spell, level);
          Navigator.pop(context);
          setState(() {});
        },
      ),
    );
  }

  SpellSchool? _getSchoolEnum(String schoolName) {
    try {
      return SpellSchool.values.firstWhere(
        (school) => school.name.toLowerCase() == schoolName.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }
}

class _CastSpellDialog extends StatefulWidget {
  final Spell spell;
  final EnhancedCharacter character;
  final Function(int) onCast;

  const _CastSpellDialog({
    required this.spell,
    required this.character,
    required this.onCast,
  });

  @override
  State<_CastSpellDialog> createState() => _CastSpellDialogState();
}

class _CastSpellDialogState extends State<_CastSpellDialog> {
  late int _selectedLevel;

  @override
  void initState() {
    super.initState();
    _selectedLevel = widget.spell.level;
  }

  List<int> _getAvailableLevels() {
    List<int> levels = [];
    for (int level = widget.spell.level; level <= 9; level++) {
      int maxSlots = _getMaxSlotsForLevel(level);
      int usedSlots = _getUsedSlotsForLevel(level);
      if (maxSlots > usedSlots) {
        levels.add(level);
      }
    }
    return levels;
  }

  int _getMaxSlotsForLevel(int level) {
    if (widget.character.spellSlots == null) return 0;
    return widget.character.spellSlots!.maxSlots[level] ?? 0;
  }

  int _getUsedSlotsForLevel(int level) {
    if (widget.character.spellSlots == null) return 0;

    int maxSlots = widget.character.spellSlots!.maxSlots[level] ?? 0;
    int currentSlots = widget.character.spellSlots!.currentSlots[level] ?? 0;
    return maxSlots - currentSlots;
  }

  @override
  Widget build(BuildContext context) {
    List<int> availableLevels = _getAvailableLevels();

    if (availableLevels.isEmpty) {
      return AlertDialog(
        title: const Text('No Spell Slots'),
        content: const Text('You have no spell slots available to cast this spell.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      );
    }

    return AlertDialog(
      title: Text('Cast ${widget.spell.name}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.spell.description,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),
          if (widget.spell.concentration)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.warning_amber, color: Colors.orange),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'This spell requires concentration',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          const Text(
            'Cast at level:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: availableLevels.map((level) {
              bool isSelected = level == _selectedLevel;
              int remaining = _getMaxSlotsForLevel(level) - _getUsedSlotsForLevel(level);

              return ChoiceChip(
                label: Text('Level $level ($remaining left)'),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _selectedLevel = level;
                    });
                  }
                },
              );
            }).toList(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => widget.onCast(_selectedLevel),
          child: const Text('Cast Spell'),
        ),
      ],
    );
  }
}

enum SpellSchool {
  abjuration,
  conjuration,
  divination,
  enchantment,
  evocation,
  illusion,
  necromancy,
  transmutation,
}
