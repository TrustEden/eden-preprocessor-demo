// Abstract AI Provider Interface
// Allows switching between Claude, Gemini, OpenAI, and other AI providers

abstract class AIProvider {
  final String apiKey;
  final String providerName;

  AIProvider({required this.apiKey, required this.providerName});

  /// Generate narrative text based on context and prompt
  Future<AIResponse> generateNarrative({
    required String prompt,
    required List<Message> conversationHistory,
    int maxTokens = 1000,
    double temperature = 0.7,
  });

  /// Generate an image based on description
  Future<ImageResponse> generateImage({
    required String prompt,
    String? style,
    int width = 1024,
    int height = 1024,
  });

  /// Generate JSON-structured data (for monsters, items, quests, etc.)
  Future<AIResponse> generateStructuredData({
    required String prompt,
    required String schema,
    int maxTokens = 2000,
  });

  /// Get model capabilities
  AICapabilities getCapabilities();
}

class Message {
  final String role; // 'user', 'assistant', 'system'
  final String content;

  Message({required this.role, required this.content});

  Map<String, dynamic> toJson() => {
        'role': role,
        'content': content,
      };
}

class AIResponse {
  final String text;
  final int tokensUsed;
  final String model;
  final bool success;
  final String? error;

  AIResponse({
    required this.text,
    required this.tokensUsed,
    required this.model,
    required this.success,
    this.error,
  });
}

class ImageResponse {
  final String? imageUrl;
  final List<int>? imageBytes;
  final bool success;
  final String? error;

  ImageResponse({
    this.imageUrl,
    this.imageBytes,
    required this.success,
    this.error,
  });
}

class AICapabilities {
  final bool supportsText;
  final bool supportsImages;
  final bool supportsVision;
  final bool supportsStructuredOutput;
  final int maxContextTokens;
  final int maxOutputTokens;
  final List<String> availableModels;

  AICapabilities({
    required this.supportsText,
    required this.supportsImages,
    required this.supportsVision,
    required this.supportsStructuredOutput,
    required this.maxContextTokens,
    required this.maxOutputTokens,
    required this.availableModels,
  });
}

// AI Provider Registry
class AIProviderRegistry {
  static final Map<String, AIProvider Function(String apiKey)> _providers = {};

  static void register(
      String name, AIProvider Function(String apiKey) factory) {
    _providers[name] = factory;
  }

  static AIProvider create(String name, String apiKey) {
    final factory = _providers[name];
    if (factory == null) {
      throw Exception('AI provider "$name" not registered');
    }
    return factory(apiKey);
  }

  static List<String> getAvailableProviders() {
    return _providers.keys.toList();
  }
}
