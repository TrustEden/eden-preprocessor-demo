// Claude Service Adapter
// Adapts the existing Claude service to the new AI Provider interface

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'ai_provider_interface.dart';

class ClaudeProviderAdapter extends AIProvider {
  static const String baseUrl = 'https://api.anthropic.com/v1';
  static const String defaultModel = 'claude-sonnet-4-20250514';

  ClaudeProviderAdapter({required String apiKey})
      : super(apiKey: apiKey, providerName: 'Claude');

  @override
  Future<AIResponse> generateNarrative({
    required String prompt,
    required List<Message> conversationHistory,
    int maxTokens = 1000,
    double temperature = 0.7,
  }) async {
    try {
      final messages = <Map<String, dynamic>>[];

      // Separate system messages
      final systemMessages = conversationHistory
          .where((m) => m.role == 'system')
          .map((m) => m.content)
          .join('\n');

      // Add non-system messages
      for (final message in conversationHistory) {
        if (message.role != 'system') {
          messages.add({
            'role': message.role,
            'content': message.content,
          });
        }
      }

      // Add current prompt
      messages.add({
        'role': 'user',
        'content': prompt,
      });

      final requestBody = {
        'model': defaultModel,
        'max_tokens': maxTokens,
        'temperature': temperature,
        'messages': messages,
        if (systemMessages.isNotEmpty) 'system': systemMessages,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/messages'),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': apiKey,
          'anthropic-version': '2023-06-01',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['content'][0]['text'] as String;
        final tokensUsed = (data['usage']['input_tokens'] as int) +
            (data['usage']['output_tokens'] as int);

        return AIResponse(
          text: text,
          tokensUsed: tokensUsed,
          model: defaultModel,
          success: true,
        );
      } else {
        final error = jsonDecode(response.body);
        return AIResponse(
          text: '',
          tokensUsed: 0,
          model: defaultModel,
          success: false,
          error: 'Claude API error: ${error['error']?['message'] ?? response.body}',
        );
      }
    } catch (e) {
      return AIResponse(
        text: '',
        tokensUsed: 0,
        model: defaultModel,
        success: false,
        error: 'Exception calling Claude: $e',
      );
    }
  }

  @override
  Future<ImageResponse> generateImage({
    required String prompt,
    String? style,
    int width = 1024,
    int height = 1024,
  }) async {
    // Claude doesn't support image generation directly
    return ImageResponse(
      success: false,
      error: 'Claude does not support image generation. Please use Gemini or OpenAI for images.',
    );
  }

  @override
  Future<AIResponse> generateStructuredData({
    required String prompt,
    required String schema,
    int maxTokens = 2000,
  }) async {
    final enhancedPrompt = '''
$prompt

Please respond with ONLY valid JSON matching this schema:
$schema

Important: Output ONLY the JSON object, nothing else.
''';

    return generateNarrative(
      prompt: enhancedPrompt,
      conversationHistory: [],
      maxTokens: maxTokens,
      temperature: 0.3,
    );
  }

  @override
  AICapabilities getCapabilities() {
    return AICapabilities(
      supportsText: true,
      supportsImages: false,
      supportsVision: true, // Claude supports vision
      supportsStructuredOutput: true,
      maxContextTokens: 200000, // Claude Sonnet 4 has 200k context
      maxOutputTokens: 4096,
      availableModels: [
        'claude-sonnet-4-20250514',
        'claude-opus-4-20250514',
        'claude-3-5-sonnet-20240620',
      ],
    );
  }
}
