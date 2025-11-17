import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/character.dart';
import '../models/game_state.dart';
import '../models/combat_state.dart';

class ClaudeService {
  final String apiKey;
  static const String API_URL = 'https://api.anthropic.com/v1/messages';

  ClaudeService({required this.apiKey});

  Future<DMResponse> getDMResponse({
    required String playerAction,
    required Character character,
    required GameState gameState,
  }) async {
    // Build context
    String prompt = _buildPrompt(
      playerAction: playerAction,
      character: character,
      gameState: gameState,
    );

    try {
      var response = await http.post(
        Uri.parse(API_URL),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': apiKey,
          'anthropic-version': '2023-06-01',
        },
        body: jsonEncode({
          'model': 'claude-sonnet-4-20250514',
          'max_tokens': 1500,
          'messages': [
            {
              'role': 'user',
              'content': prompt,
            }
          ],
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('API Error: ${response.statusCode} - ${response.body}');
      }

      var data = jsonDecode(response.body);
      String dmNarration = data['content'][0]['text'];

      // Parse the response
      return _parseResponse(dmNarration);
    } catch (e) {
      print('Error calling Claude API: $e');
      return DMResponse(
        narration: "The dungeon master seems distracted. Try again.",
        requiresRoll: false,
      );
    }
  }

  String _buildPrompt({
    required String playerAction,
    required Character character,
    required GameState gameState,
  }) {
    // Get recent history (last 5 events)
    String recentHistory = gameState.narrativeHistory
        .reversed
        .take(5)
        .map((e) => '${e.playerAction ?? ""} -> ${e.dmResponse ?? ""}')
        .join('\n');

    return '''
You are a Dungeon Master running a D&D 5th Edition campaign for a solo player.

CHARACTER:
Name: ${character.name}
Class: Fighter (Level ${character.level})
HP: ${character.hpCurrent}/${character.hpMax}
AC: ${character.armorClass}
Current Location: ${gameState.currentLocation}

RECENT EVENTS:
$recentHistory

CURRENT SCENE:
${gameState.currentSceneDescription}

PLAYER ACTION:
"$playerAction"

INSTRUCTIONS:
1. Narrate what happens based on the player's action
2. Be descriptive but concise (2-3 paragraphs max)
3. If a skill check is needed, specify: "Roll [SKILL] check, DC [NUMBER]"
4. If combat should start, say: "COMBAT_START:" followed by enemy description
5. Create meaningful choices and consequences
6. Stay true to D&D 5e rules
7. Remember this is a Fighter - they're good at combat, athletics, and survival
8. Keep the story engaging and moving forward

RESPONSE FORMAT:
Just write your narration naturally. Use special markers only when needed:
- "Roll [skill] check, DC [number]" - for skill checks
- "COMBAT_START: [enemy description]" - to start combat
- "XP_AWARD: [amount]" - to give experience points

Your response:''';
  }

  DMResponse _parseResponse(String narration) {
    DMResponse response = DMResponse(
      narration: narration,
      requiresRoll: false,
    );

    // Check for skill check request
    RegExp rollPattern =
        RegExp(r'Roll (\w+) check, DC (\d+)', caseSensitive: false);
    var rollMatch = rollPattern.firstMatch(narration);
    if (rollMatch != null) {
      response.requiresRoll = true;
      response.rollSkill = rollMatch.group(1)!.toLowerCase();
      response.rollDC = int.parse(rollMatch.group(2)!);
    }

    // Check for combat start
    if (narration.contains('COMBAT_START:')) {
      response.combatStarts = true;
      // Extract enemy description
      int startIndex = narration.indexOf('COMBAT_START:') + 13;
      int endIndex = narration.indexOf('\n', startIndex);
      if (endIndex == -1) endIndex = narration.length;
      response.enemyDescription =
          narration.substring(startIndex, endIndex).trim();
    }

    // Check for XP award
    RegExp xpPattern = RegExp(r'XP_AWARD: (\d+)');
    var xpMatch = xpPattern.firstMatch(narration);
    if (xpMatch != null) {
      response.xpAwarded = int.parse(xpMatch.group(1)!);
    }

    // Clean up special markers from narration
    response.narration = narration
        .replaceAll(rollPattern, '')
        .replaceAll(RegExp(r'COMBAT_START:.*'), '')
        .replaceAll(xpPattern, '')
        .trim();

    return response;
  }

  Future<String> getEnemyAction({
    required Enemy enemy,
    required CombatState combat,
  }) async {
    // Simple prompt for enemy tactics
    String prompt = '''
You are controlling a ${enemy.name} in combat.

COMBAT SITUATION:
Round: ${combat.currentRound}
${enemy.name} HP: ${combat.combatants.firstWhere((c) => c.id == enemy.id).hpCurrent}/${combat.combatants.firstWhere((c) => c.id == enemy.id).hpMax}
Player HP: ${combat.combatants.firstWhere((c) => c.isPlayer).hpCurrent}/${combat.combatants.firstWhere((c) => c.isPlayer).hpMax}

What does the ${enemy.name} do on its turn? Choose ONE action:
1. ATTACK - Attack the player
2. DODGE - Focus on defense
3. DASH - Move away (flee if low HP)

Respond with just the action name: ATTACK, DODGE, or DASH''';

    try {
      var response = await http.post(
        Uri.parse(API_URL),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': apiKey,
          'anthropic-version': '2023-06-01',
        },
        body: jsonEncode({
          'model': 'claude-sonnet-4-20250514',
          'max_tokens': 50,
          'messages': [
            {'role': 'user', 'content': prompt}
          ],
        }),
      );

      var data = jsonDecode(response.body);
      String action = data['content'][0]['text'].trim().toUpperCase();

      if (action.contains('ATTACK')) return 'ATTACK';
      if (action.contains('DODGE')) return 'DODGE';
      if (action.contains('DASH')) return 'DASH';

      return 'ATTACK'; // Default
    } catch (e) {
      return 'ATTACK'; // Default on error
    }
  }

  /// Generate enemies based on description and character level
  Future<List<Enemy>> generateEnemies(
      String description, int characterLevel) async {
    // For MVP, we'll use a simple static enemy generator
    // In production, this could query Claude for dynamic enemy stats
    return _generateStaticEnemies(description, characterLevel);
  }

  List<Enemy> _generateStaticEnemies(String description, int level) {
    // Simple enemy templates based on description keywords
    if (description.toLowerCase().contains('goblin')) {
      int numGoblins = level >= 3 ? 2 : 1;
      return List.generate(
        numGoblins,
        (i) => Enemy(
          id: 'goblin_$i',
          name: numGoblins > 1 ? 'Goblin ${i + 1}' : 'Goblin',
          hp: 7,
          ac: 15,
          initiativeBonus: 2,
          attackBonus: 4,
          attackDamage: '1d6+2',
        ),
      );
    } else if (description.toLowerCase().contains('bandit')) {
      return [
        Enemy(
          id: 'bandit_1',
          name: 'Bandit',
          hp: 11,
          ac: 12,
          initiativeBonus: 1,
          attackBonus: 3,
          attackDamage: '1d8+1',
        ),
      ];
    } else if (description.toLowerCase().contains('wolf')) {
      return [
        Enemy(
          id: 'wolf_1',
          name: 'Wolf',
          hp: 11,
          ac: 13,
          initiativeBonus: 2,
          attackBonus: 4,
          attackDamage: '2d4+2',
        ),
      ];
    } else if (description.toLowerCase().contains('orc')) {
      return [
        Enemy(
          id: 'orc_1',
          name: 'Orc',
          hp: 15,
          ac: 13,
          initiativeBonus: 0,
          attackBonus: 5,
          attackDamage: '1d12+3',
        ),
      ];
    } else {
      // Default enemy
      return [
        Enemy(
          id: 'enemy_1',
          name: 'Hostile Creature',
          hp: 8 + (level * 2),
          ac: 12 + level,
          initiativeBonus: level ~/ 2,
          attackBonus: 2 + level,
          attackDamage: '1d6+${level}',
        ),
      ];
    }
  }
}

class DMResponse {
  String narration;
  bool requiresRoll;
  String? rollSkill;
  int? rollDC;
  bool combatStarts;
  String? enemyDescription;
  int? xpAwarded;

  DMResponse({
    required this.narration,
    this.requiresRoll = false,
    this.rollSkill,
    this.rollDC,
    this.combatStarts = false,
    this.enemyDescription,
    this.xpAwarded,
  });
}
