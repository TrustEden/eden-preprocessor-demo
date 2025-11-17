// OpenAI Provider Implementation
// Supports GPT-4, GPT-4 Turbo, and DALL-E 3 for image generation

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'ai_provider_interface.dart';

class OpenAIProvider extends AIProvider {
  static const String baseUrl = 'https://api.openai.com/v1';

  // Available OpenAI models
  static const String gpt4Turbo = 'gpt-4-turbo-preview';
  static const String gpt4 = 'gpt-4';
  static const String gpt35Turbo = 'gpt-3.5-turbo';
  static const String dalle3 = 'dall-e-3';
  static const String dalle2 = 'dall-e-2';

  final String defaultModel;
  final String imageModel;

  OpenAIProvider({
    required String apiKey,
    this.defaultModel = gpt4Turbo,
    this.imageModel = dalle3,
  }) : super(apiKey: apiKey, providerName: 'OpenAI');

  @override
  Future<AIResponse> generateNarrative({
    required String prompt,
    required List<Message> conversationHistory,
    int maxTokens = 1000,
    double temperature = 0.7,
  }) async {
    try {
      final messages = <Map<String, dynamic>>[];

      // Add conversation history
      for (final message in conversationHistory) {
        messages.add({
          'role': message.role,
          'content': message.content,
        });
      }

      // Add current prompt
      messages.add({
        'role': 'user',
        'content': prompt,
      });

      final requestBody = {
        'model': defaultModel,
        'messages': messages,
        'max_tokens': maxTokens,
        'temperature': temperature,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['choices'][0]['message']['content'] as String;
        final tokensUsed = data['usage']['total_tokens'] as int;

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
          error: 'OpenAI API error: ${error['error']?['message'] ?? response.body}',
        );
      }
    } catch (e) {
      return AIResponse(
        text: '',
        tokensUsed: 0,
        model: defaultModel,
        success: false,
        error: 'Exception calling OpenAI: $e',
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
    try {
      final size = _getClosestSize(width, height);

      final enhancedPrompt = style != null
          ? '$prompt, $style, high quality, detailed'
          : prompt;

      final requestBody = {
        'model': imageModel,
        'prompt': enhancedPrompt,
        'n': 1,
        'size': size,
        'quality': 'hd', // For DALL-E 3
        'style': 'vivid', // For DALL-E 3: 'vivid' or 'natural'
      };

      final response = await http.post(
        Uri.parse('$baseUrl/images/generations'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final imageUrl = data['data'][0]['url'] as String;

        return ImageResponse(
          imageUrl: imageUrl,
          success: true,
        );
      } else {
        final error = jsonDecode(response.body);
        return ImageResponse(
          success: false,
          error: 'DALL-E API error: ${error['error']?['message'] ?? response.body}',
        );
      }
    } catch (e) {
      return ImageResponse(
        success: false,
        error: 'Exception generating image: $e',
      );
    }
  }

  @override
  Future<AIResponse> generateStructuredData({
    required String prompt,
    required String schema,
    int maxTokens = 2000,
  }) async {
    // OpenAI supports JSON mode
    try {
      final messages = [
        {
          'role': 'system',
          'content': 'You are a helpful assistant that outputs JSON. Respond only with valid JSON matching the provided schema.',
        },
        {
          'role': 'user',
          'content': '$prompt\n\nSchema:\n$schema',
        },
      ];

      final requestBody = {
        'model': defaultModel,
        'messages': messages,
        'max_tokens': maxTokens,
        'temperature': 0.3,
        'response_format': {'type': 'json_object'}, // JSON mode
      };

      final response = await http.post(
        Uri.parse('$baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['choices'][0]['message']['content'] as String;
        final tokensUsed = data['usage']['total_tokens'] as int;

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
          error: 'OpenAI JSON mode error: ${error['error']?['message']}',
        );
      }
    } catch (e) {
      return AIResponse(
        text: '',
        tokensUsed: 0,
        model: defaultModel,
        success: false,
        error: 'Exception in structured data generation: $e',
      );
    }
  }

  @override
  AICapabilities getCapabilities() {
    return AICapabilities(
      supportsText: true,
      supportsImages: true,
      supportsVision: true, // GPT-4 Vision
      supportsStructuredOutput: true,
      maxContextTokens: 128000, // GPT-4 Turbo
      maxOutputTokens: 4096,
      availableModels: [gpt4Turbo, gpt4, gpt35Turbo, dalle3, dalle2],
    );
  }

  String _getClosestSize(int width, int height) {
    // DALL-E 3 supports: 1024x1024, 1024x1792, 1792x1024
    // DALL-E 2 supports: 256x256, 512x512, 1024x1024

    if (imageModel == dalle3) {
      if (width > height * 1.5) return '1792x1024';
      if (height > width * 1.5) return '1024x1792';
      return '1024x1024';
    } else {
      // DALL-E 2
      if (width <= 256 && height <= 256) return '256x256';
      if (width <= 512 && height <= 512) return '512x512';
      return '1024x1024';
    }
  }

  /// Analyze an image using GPT-4 Vision
  Future<AIResponse> analyzeImage({
    required String imageUrl,
    required String question,
  }) async {
    try {
      final requestBody = {
        'model': 'gpt-4-vision-preview',
        'messages': [
          {
            'role': 'user',
            'content': [
              {'type': 'text', 'text': question},
              {
                'type': 'image_url',
                'image_url': {'url': imageUrl}
              }
            ]
          }
        ],
        'max_tokens': 1000,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['choices'][0]['message']['content'] as String;
        final tokensUsed = data['usage']['total_tokens'] as int;

        return AIResponse(
          text: text,
          tokensUsed: tokensUsed,
          model: 'gpt-4-vision-preview',
          success: true,
        );
      } else {
        return AIResponse(
          text: '',
          tokensUsed: 0,
          model: 'gpt-4-vision-preview',
          success: false,
          error: 'Vision API error: ${response.body}',
        );
      }
    } catch (e) {
      return AIResponse(
        text: '',
        tokensUsed: 0,
        model: 'gpt-4-vision-preview',
        success: false,
        error: 'Exception in vision analysis: $e',
      );
    }
  }
}
