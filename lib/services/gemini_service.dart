// Google Gemini AI Provider Implementation
// Supports text generation AND image generation via Imagen

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'ai_provider_interface.dart';

class GeminiProvider extends AIProvider {
  static const String baseUrl = 'https://generativelanguage.googleapis.com/v1beta';
  static const String imageBaseUrl = 'https://imagen.googleapis.com/v1';

  // Available Gemini models
  static const String geminiPro = 'gemini-1.5-pro-latest';
  static const String geminiFlash = 'gemini-1.5-flash-latest';
  static const String geminiProVision = 'gemini-1.5-pro-vision-latest';

  final String defaultModel;

  GeminiProvider({
    required String apiKey,
    this.defaultModel = geminiPro,
  }) : super(apiKey: apiKey, providerName: 'Gemini');

  @override
  Future<AIResponse> generateNarrative({
    required String prompt,
    required List<Message> conversationHistory,
    int maxTokens = 1000,
    double temperature = 0.7,
  }) async {
    try {
      // Convert conversation history to Gemini format
      final List<Map<String, dynamic>> contents = [];

      // Add system prompt if exists
      final systemMessages = conversationHistory.where((m) => m.role == 'system');
      String systemPrompt = systemMessages.isNotEmpty
          ? systemMessages.map((m) => m.content).join('\n')
          : '';

      // Add conversation history
      for (final message in conversationHistory) {
        if (message.role == 'system') continue;

        contents.add({
          'role': message.role == 'assistant' ? 'model' : 'user',
          'parts': [
            {'text': message.content}
          ]
        });
      }

      // Add current prompt
      contents.add({
        'role': 'user',
        'parts': [
          {'text': systemPrompt.isNotEmpty ? '$systemPrompt\n\n$prompt' : prompt}
        ]
      });

      final requestBody = {
        'contents': contents,
        'generationConfig': {
          'temperature': temperature,
          'maxOutputTokens': maxTokens,
          'topP': 0.95,
          'topK': 40,
        },
        'safetySettings': [
          {
            'category': 'HARM_CATEGORY_HARASSMENT',
            'threshold': 'BLOCK_NONE'
          },
          {
            'category': 'HARM_CATEGORY_HATE_SPEECH',
            'threshold': 'BLOCK_NONE'
          },
          {
            'category': 'HARM_CATEGORY_SEXUALLY_EXPLICIT',
            'threshold': 'BLOCK_NONE'
          },
          {
            'category': 'HARM_CATEGORY_DANGEROUS_CONTENT',
            'threshold': 'BLOCK_NONE'
          },
        ],
      };

      final url = '$baseUrl/models/$defaultModel:generateContent?key=$apiKey';
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['candidates'] == null || data['candidates'].isEmpty) {
          return AIResponse(
            text: '',
            tokensUsed: 0,
            model: defaultModel,
            success: false,
            error: 'No response generated (possibly blocked by safety filters)',
          );
        }

        final text = data['candidates'][0]['content']['parts'][0]['text'] as String;
        final tokensUsed = (data['usageMetadata']?['totalTokenCount'] as int?) ?? 0;

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
          error: 'Gemini API error: ${error['error']?['message'] ?? response.body}',
        );
      }
    } catch (e) {
      return AIResponse(
        text: '',
        tokensUsed: 0,
        model: defaultModel,
        success: false,
        error: 'Exception calling Gemini: $e',
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
      // Gemini can use Imagen for image generation
      // Note: This endpoint might require different authentication
      // For now, we'll use a simple approach

      final enhancedPrompt = style != null
          ? '$prompt, style: $style, high quality, detailed'
          : '$prompt, high quality, detailed';

      final requestBody = {
        'prompt': enhancedPrompt,
        'number_of_images': 1,
        'aspect_ratio': _getAspectRatio(width, height),
        'safety_filter_level': 'block_few',
        'person_generation': 'allow_all',
      };

      // Using Imagen 3 via Vertex AI
      final url = '$imageBaseUrl/projects/YOUR_PROJECT/locations/us-central1/publishers/google/models/imagen-3.0-generate-001:predict';

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Extract image data
        final predictions = data['predictions'] as List?;
        if (predictions != null && predictions.isNotEmpty) {
          final bytesB64 = predictions[0]['bytesBase64Encoded'] as String?;

          if (bytesB64 != null) {
            final imageBytes = base64Decode(bytesB64);
            return ImageResponse(
              imageBytes: imageBytes,
              success: true,
            );
          }
        }

        return ImageResponse(
          success: false,
          error: 'No image data in response',
        );
      } else {
        return ImageResponse(
          success: false,
          error: 'Imagen API error: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      // Fallback: Generate a placeholder or use alternative method
      return ImageResponse(
        success: false,
        error: 'Image generation not available in this configuration. Error: $e',
      );
    }
  }

  @override
  Future<AIResponse> generateStructuredData({
    required String prompt,
    required String schema,
    int maxTokens = 2000,
  }) async {
    // Use JSON mode for structured output
    final enhancedPrompt = '''
$prompt

Please respond with ONLY valid JSON matching this schema:
$schema

Do not include any text before or after the JSON. Only output the JSON object.
''';

    return generateNarrative(
      prompt: enhancedPrompt,
      conversationHistory: [],
      maxTokens: maxTokens,
      temperature: 0.3, // Lower temperature for more consistent structure
    );
  }

  @override
  AICapabilities getCapabilities() {
    return AICapabilities(
      supportsText: true,
      supportsImages: true,
      supportsVision: true,
      supportsStructuredOutput: true,
      maxContextTokens: 1000000, // Gemini 1.5 Pro supports 1M tokens!
      maxOutputTokens: 8192,
      availableModels: [geminiPro, geminiFlash, geminiProVision],
    );
  }

  String _getAspectRatio(int width, int height) {
    final ratio = width / height;
    if (ratio > 1.3) return '16:9';
    if (ratio > 1.1) return '4:3';
    if (ratio > 0.9) return '1:1';
    if (ratio > 0.7) return '3:4';
    return '9:16';
  }

  // Gemini-specific features

  /// Use Gemini's vision capabilities to analyze an image
  Future<AIResponse> analyzeImage({
    required List<int> imageBytes,
    required String question,
  }) async {
    try {
      final base64Image = base64Encode(imageBytes);

      final requestBody = {
        'contents': [
          {
            'role': 'user',
            'parts': [
              {'text': question},
              {
                'inline_data': {
                  'mime_type': 'image/jpeg',
                  'data': base64Image,
                }
              }
            ]
          }
        ],
        'generationConfig': {
          'temperature': 0.4,
          'maxOutputTokens': 1000,
        },
      };

      final url = '$baseUrl/models/$geminiProVision:generateContent?key=$apiKey';
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['candidates'][0]['content']['parts'][0]['text'] as String;
        final tokensUsed = (data['usageMetadata']?['totalTokenCount'] as int?) ?? 0;

        return AIResponse(
          text: text,
          tokensUsed: tokensUsed,
          model: geminiProVision,
          success: true,
        );
      } else {
        return AIResponse(
          text: '',
          tokensUsed: 0,
          model: geminiProVision,
          success: false,
          error: 'Vision API error: ${response.body}',
        );
      }
    } catch (e) {
      return AIResponse(
        text: '',
        tokensUsed: 0,
        model: geminiProVision,
        success: false,
        error: 'Exception in vision analysis: $e',
      );
    }
  }

  /// Generate a character portrait using Gemini's image generation
  Future<ImageResponse> generateCharacterPortrait({
    required String characterName,
    required String race,
    required String characterClass,
    required String description,
    String style = 'fantasy art, D&D style',
  }) async {
    final prompt = '''
Create a detailed character portrait for a D&D character:
- Name: $characterName
- Race: $race
- Class: $characterClass
- Description: $description
- Style: $style
- High quality, professional fantasy art
- Face should be clearly visible
- Appropriate class equipment and clothing
''';

    return generateImage(prompt: prompt, style: style);
  }

  /// Generate a monster illustration
  Future<ImageResponse> generateMonsterImage({
    required String monsterName,
    required String description,
    String environment = 'dark dungeon',
  }) async {
    final prompt = '''
Create an epic D&D monster illustration:
- Monster: $monsterName
- Description: $description
- Environment: $environment
- Menacing and atmospheric
- High quality fantasy art
- Dynamic pose
''';

    return generateImage(prompt: prompt);
  }

  /// Generate a scene or location image
  Future<ImageResponse> generateSceneImage({
    required String sceneDescription,
    String mood = 'atmospheric',
  }) async {
    final prompt = '''
Create a D&D scene illustration:
- Scene: $sceneDescription
- Mood: $mood
- Cinematic composition
- High quality fantasy art
- Rich details and atmosphere
''';

    return generateImage(prompt: prompt);
  }
}
