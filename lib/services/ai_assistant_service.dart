import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ai_configuration.dart';
import '../models/game_session.dart';
import '../models/enhanced_character.dart';
import 'api_key_service.dart';

/// AI assistant service that generates suggestions for DMs
/// This replaces the auto-response system with a suggestion-based approach
class AIAssistantService {
  static final AIAssistantService _instance = AIAssistantService._internal();
  factory AIAssistantService() => _instance;
  AIAssistantService._internal();

  final APIKeyService _keyService = APIKeyService();
  AIConfiguration _config = AIConfiguration();
  AIUsageStats _currentUsage = AIUsageStats(
    periodStart: DateTime.now(),
    periodEnd: DateTime.now().add(const Duration(days: 30)),
  );

  /// Set AI configuration
  void setConfiguration(AIConfiguration config) {
    _config = config;
  }

  /// Get current configuration
  AIConfiguration getConfiguration() => _config;

  /// Get current usage stats
  AIUsageStats getUsageStats() => _currentUsage;

  /// Generate narrative suggestions for DM (replaces auto-response)
  Future<List<NarrativeSuggestion>> generateNarrativeSuggestions({
    required String playerAction,
    required GameSession session,
    EnhancedCharacter? activeCharacter,
  }) async {
    try {
      // Check if we have an API key
      String? apiKey = await _keyService.getAPIKey(_config.provider);
      if (apiKey == null || apiKey.isEmpty) {
        throw APIKeyException(
          message: 'No API key configured for ${_config.provider}',
          provider: _config.provider,
        );
      }

      // Build the prompt
      String prompt = _buildSuggestionPrompt(
        playerAction: playerAction,
        session: session,
        activeCharacter: activeCharacter,
      );

      // Call appropriate AI provider
      String response;
      int tokensUsed;

      switch (_config.provider) {
        case AIProvider.claude:
          var result = await _callClaude(apiKey, prompt);
          response = result['text'] as String;
          tokensUsed = result['tokens'] as int;
          break;

        case AIProvider.openai:
          var result = await _callOpenAI(apiKey, prompt);
          response = result['text'] as String;
          tokensUsed = result['tokens'] as int;
          break;

        case AIProvider.gemini:
          var result = await _callGemini(apiKey, prompt);
          response = result['text'] as String;
          tokensUsed = result['tokens'] as int;
          break;

        case AIProvider.local:
          // Local model would be called here
          throw UnimplementedError('Local models not yet implemented');
      }

      // Track usage
      double cost = _config.estimateCost(prompt.length ~/ 4, tokensUsed);
      _currentUsage.recordRequest(_config.modelId, tokensUsed, cost);

      // Parse multiple suggestions from response
      return _parseSuggestions(response, session);
    } catch (e) {
      // Return error suggestion
      return [
        NarrativeSuggestion(
          narrative: 'Error generating suggestions: ${e.toString()}',
          style: SuggestionStyle.error,
          confidenceScore: 0.0,
          predictions: [],
        ),
      ];
    }
  }

  /// Build prompt for suggestion generation
  String _buildSuggestionPrompt({
    required String playerAction,
    required GameSession session,
    EnhancedCharacter? activeCharacter,
  }) {
    // Get recent history (last 10 events, not just 5)
    String recentHistory = session.sharedHistory
        .reversed
        .take(10)
        .map((e) => '${e.playerAction ?? ""} -> ${e.dmResponse ?? ""}')
        .join('\n');

    // Get active quests
    String activeQuests = session.activeQuests
        .map((q) => '- ${q.title}: ${q.description}')
        .join('\n');

    // Character info
    String characterInfo = '';
    if (activeCharacter != null) {
      characterInfo = '''
Name: ${activeCharacter.name}
Class: ${activeCharacter.characterClass.name} (Level ${activeCharacter.level})
Background: ${activeCharacter.background?.name ?? 'Unknown'}
Personality: ${activeCharacter.personalityTrait1 ?? 'Unknown'}
HP: ${activeCharacter.hpCurrent}/${activeCharacter.hpMax}
''';
    }

    // Build prompt based on configuration
    return '''
You are an AI assistant helping a Dungeon Master run a D&D 5th Edition campaign.
The DM will review your suggestions and choose one (or write their own).

CAMPAIGN TONE: ${_config.preferredTone}
NARRATIVE STYLE: ${_config.narrativeStyle}

CURRENT SCENE:
${session.currentScene.description}
Location: ${session.currentScene.location}

CHARACTER:
$characterInfo

RECENT EVENTS:
$recentHistory

ACTIVE QUESTS:
$activeQuests

PLAYER ACTION:
"$playerAction"

Generate ${_config.suggestionCount} different narrative responses for the DM to choose from.
Each should be 2-3 paragraphs and offer different tones/directions:

1. First suggestion: ${_getToneGuidance(0)}
2. Second suggestion: ${_getToneGuidance(1)}
${_config.suggestionCount > 2 ? '3. Third suggestion: ${_getToneGuidance(2)}' : ''}

For each suggestion, include:
- The narrative response
- [STYLE: dramatic/comedic/mysterious/action/social]
- [CONFIDENCE: 0.0-1.0 based on how well it fits the campaign]
- [CONSEQUENCE: potential outcomes]

Format each suggestion as:
---SUGGESTION START---
[STYLE: ...]
[CONFIDENCE: ...]
[NARRATIVE]
Your narrative text here...
[/NARRATIVE]
[CONSEQUENCE: ...]
---SUGGESTION END---

IMPORTANT:
- Stay true to D&D 5e rules
- Consider character background and personality
- Create meaningful choices
- Be descriptive but concise
- Don't auto-resolve actions - let dice determine outcomes
''';
  }

  String _getToneGuidance(int index) {
    switch (index) {
      case 0:
        return 'Dramatic and plot-advancing';
      case 1:
        return 'Safe and straightforward';
      case 2:
        return 'Creative or unexpected twist';
      default:
        return 'Your choice of approach';
    }
  }

  /// Call Claude API
  Future<Map<String, dynamic>> _callClaude(String apiKey, String prompt) async {
    final response = await http.post(
      Uri.parse('https://api.anthropic.com/v1/messages'),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
        'anthropic-version': '2023-06-01',
      },
      body: jsonEncode({
        'model': _config.modelId,
        'max_tokens': _config.maxTokens,
        'temperature': _config.temperature,
        'top_p': _config.topP,
        'messages': [
          {
            'role': 'user',
            'content': prompt,
          }
        ],
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Claude API error: ${response.statusCode} - ${response.body}');
    }

    var data = jsonDecode(response.body);
    String text = data['content'][0]['text'] as String;
    int tokens = (data['usage']['input_tokens'] as int) + (data['usage']['output_tokens'] as int);

    return {'text': text, 'tokens': tokens};
  }

  /// Call OpenAI API
  Future<Map<String, dynamic>> _callOpenAI(String apiKey, String prompt) async {
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': _config.modelId,
        'max_tokens': _config.maxTokens,
        'temperature': _config.temperature,
        'top_p': _config.topP,
        'messages': [
          {
            'role': 'user',
            'content': prompt,
          }
        ],
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('OpenAI API error: ${response.statusCode} - ${response.body}');
    }

    var data = jsonDecode(response.body);
    String text = data['choices'][0]['message']['content'] as String;
    int tokens = data['usage']['total_tokens'] as int;

    return {'text': text, 'tokens': tokens};
  }

  /// Call Gemini API
  Future<Map<String, dynamic>> _callGemini(String apiKey, String prompt) async {
    final response = await http.post(
      Uri.parse('https://generativelanguage.googleapis.com/v1/models/${_config.modelId}:generateContent?key=$apiKey'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': prompt}
            ]
          }
        ],
        'generationConfig': {
          'temperature': _config.temperature,
          'topP': _config.topP,
          'maxOutputTokens': _config.maxTokens,
        },
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Gemini API error: ${response.statusCode} - ${response.body}');
    }

    var data = jsonDecode(response.body);
    String text = data['candidates'][0]['content']['parts'][0]['text'] as String;
    // Gemini doesn't return token counts in the same way, estimate
    int tokens = (prompt.length ~/ 4) + (text.length ~/ 4);

    return {'text': text, 'tokens': tokens};
  }

  /// Parse multiple suggestions from AI response
  List<NarrativeSuggestion> _parseSuggestions(String response, GameSession session) {
    List<NarrativeSuggestion> suggestions = [];

    // Split by suggestion markers
    var parts = response.split('---SUGGESTION START---');

    for (var part in parts) {
      if (part.trim().isEmpty) continue;

      try {
        // Extract style
        var styleMatch = RegExp(r'\[STYLE:\s*(\w+)\]').firstMatch(part);
        var style = styleMatch != null
            ? _parseStyle(styleMatch.group(1)!)
            : SuggestionStyle.balanced;

        // Extract confidence
        var confMatch = RegExp(r'\[CONFIDENCE:\s*([\d.]+)\]').firstMatch(part);
        var confidence = confMatch != null
            ? double.parse(confMatch.group(1)!)
            : 0.7;

        // Extract narrative
        var narrativeMatch = RegExp(r'\[NARRATIVE\](.*?)\[/NARRATIVE\]', dotAll: true).firstMatch(part);
        var narrative = narrativeMatch != null
            ? narrativeMatch.group(1)!.trim()
            : part.split('[CONSEQUENCE:')[0].trim();

        // Extract consequences
        var conseqMatch = RegExp(r'\[CONSEQUENCE:\s*(.*?)\]', dotAll: true).firstMatch(part);
        List<ConsequencePrediction> predictions = [];
        if (conseqMatch != null) {
          predictions.add(ConsequencePrediction(
            description: conseqMatch.group(1)!.trim(),
            probability: 0.7,
          ));
        }

        suggestions.add(NarrativeSuggestion(
          narrative: narrative,
          style: style,
          confidenceScore: confidence,
          predictions: predictions,
        ));
      } catch (e) {
        // If parsing fails, skip this suggestion
        continue;
      }
    }

    // If no suggestions were parsed, return a fallback
    if (suggestions.isEmpty) {
      suggestions.add(NarrativeSuggestion(
        narrative: response,
        style: SuggestionStyle.balanced,
        confidenceScore: 0.5,
        predictions: [],
      ));
    }

    return suggestions;
  }

  SuggestionStyle _parseStyle(String styleStr) {
    switch (styleStr.toLowerCase()) {
      case 'dramatic':
        return SuggestionStyle.dramatic;
      case 'comedic':
        return SuggestionStyle.comedic;
      case 'mysterious':
        return SuggestionStyle.mysterious;
      case 'action':
        return SuggestionStyle.action;
      case 'social':
        return SuggestionStyle.social;
      default:
        return SuggestionStyle.balanced;
    }
  }

  /// Generate encounter suggestions
  Future<List<EncounterSuggestion>> generateEncounterSuggestions({
    required GameSession session,
    required EncounterDifficulty difficulty,
    String? theme,
  }) async {
    // Implementation for encounter generation
    // This would call AI to suggest encounter compositions
    return [];
  }

  /// Check narrative consistency
  Future<List<ConsistencyWarning>> checkConsistency({
    required String proposedNarrative,
    required GameSession session,
  }) async {
    // Implementation for consistency checking
    // This would call AI to verify the narrative doesn't contradict established facts
    return [];
  }
}

/// Narrative suggestion from AI
class NarrativeSuggestion {
  String narrative;
  SuggestionStyle style;
  double confidenceScore; // 0.0-1.0
  List<ConsequencePrediction> predictions;
  List<String> requiredDMDecisions;

  NarrativeSuggestion({
    required this.narrative,
    required this.style,
    required this.confidenceScore,
    required this.predictions,
    List<String>? requiredDMDecisions,
  }) : requiredDMDecisions = requiredDMDecisions ?? [];
}

enum SuggestionStyle {
  dramatic,
  comedic,
  mysterious,
  action,
  social,
  balanced,
  error,
}

class ConsequencePrediction {
  String description;
  double probability;

  ConsequencePrediction({
    required this.description,
    required this.probability,
  });
}

/// Encounter suggestion
class EncounterSuggestion {
  String title;
  String description;
  List<String> monsterIds;
  double challengeRating;
  int estimatedRounds;
  String tacticalNotes;

  EncounterSuggestion({
    required this.title,
    required this.description,
    required this.monsterIds,
    required this.challengeRating,
    required this.estimatedRounds,
    required this.tacticalNotes,
  });
}

enum EncounterDifficulty {
  easy,
  medium,
  hard,
  deadly,
}

/// Consistency warning
class ConsistencyWarning {
  WarningSeverity severity;
  String message;
  String? location;
  String? suggestion;

  ConsistencyWarning({
    required this.severity,
    required this.message,
    this.location,
    this.suggestion,
  });
}

enum WarningSeverity {
  low,
  medium,
  high,
}
