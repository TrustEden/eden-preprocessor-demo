// Multi-AI Service Manager
// Manages multiple AI providers and allows switching between them

import 'package:shared_preferences/shared_preferences.dart';
import 'ai_provider_interface.dart';
import 'gemini_service.dart';
import 'openai_service.dart';
import 'claude_service_adapter.dart';

class MultiAIService {
  static final MultiAIService _instance = MultiAIService._internal();
  factory MultiAIService() => _instance;
  MultiAIService._internal();

  AIProvider? _currentProvider;
  String _currentProviderName = 'Claude';

  final Map<String, String> _apiKeys = {};

  // Provider preferences
  static const String _prefKeyCurrentProvider = 'current_ai_provider';
  static const String _prefKeyClaudeKey = 'claude_api_key';
  static const String _prefKeyGeminiKey = 'gemini_api_key';
  static const String _prefKeyOpenAIKey = 'openai_api_key';

  /// Initialize the service and load saved preferences
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();

    // Load API keys
    _apiKeys['Claude'] = prefs.getString(_prefKeyClaudeKey) ?? '';
    _apiKeys['Gemini'] = prefs.getString(_prefKeyGeminiKey) ?? '';
    _apiKeys['OpenAI'] = prefs.getString(_prefKeyOpenAIKey) ?? '';

    // Load current provider
    _currentProviderName = prefs.getString(_prefKeyCurrentProvider) ?? 'Claude';

    // Initialize current provider
    await _initializeProvider(_currentProviderName);
  }

  Future<void> _initializeProvider(String providerName) async {
    final apiKey = _apiKeys[providerName];
    if (apiKey == null || apiKey.isEmpty) {
      _currentProvider = null;
      return;
    }

    switch (providerName) {
      case 'Gemini':
        _currentProvider = GeminiProvider(apiKey: apiKey);
        break;
      case 'OpenAI':
        _currentProvider = OpenAIProvider(apiKey: apiKey);
        break;
      case 'Claude':
      default:
        _currentProvider = ClaudeProviderAdapter(apiKey: apiKey);
        break;
    }

    _currentProviderName = providerName;
  }

  /// Set API key for a specific provider
  Future<void> setApiKey(String providerName, String apiKey) async {
    _apiKeys[providerName] = apiKey;

    final prefs = await SharedPreferences.getInstance();
    switch (providerName) {
      case 'Claude':
        await prefs.setString(_prefKeyClaudeKey, apiKey);
        break;
      case 'Gemini':
        await prefs.setString(_prefKeyGeminiKey, apiKey);
        break;
      case 'OpenAI':
        await prefs.setString(_prefKeyOpenAIKey, apiKey);
        break;
    }

    // If this is the current provider, reinitialize
    if (providerName == _currentProviderName) {
      await _initializeProvider(providerName);
    }
  }

  /// Switch to a different AI provider
  Future<bool> switchProvider(String providerName) async {
    if (!['Claude', 'Gemini', 'OpenAI'].contains(providerName)) {
      return false;
    }

    await _initializeProvider(providerName);

    if (_currentProvider == null) {
      return false; // API key not set
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKeyCurrentProvider, providerName);

    return true;
  }

  /// Get current provider
  AIProvider? get currentProvider => _currentProvider;

  String get currentProviderName => _currentProviderName;

  /// Check if a provider has an API key set
  bool hasApiKey(String providerName) {
    final key = _apiKeys[providerName];
    return key != null && key.isNotEmpty;
  }

  /// Get list of available providers
  List<String> get availableProviders => ['Claude', 'Gemini', 'OpenAI'];

  /// Get provider status
  Map<String, bool> getProviderStatus() {
    return {
      'Claude': hasApiKey('Claude'),
      'Gemini': hasApiKey('Gemini'),
      'OpenAI': hasApiKey('OpenAI'),
    };
  }

  // Convenience methods that delegate to current provider

  Future<AIResponse> generateNarrative({
    required String prompt,
    required List<Message> conversationHistory,
    int maxTokens = 1000,
    double temperature = 0.7,
  }) async {
    if (_currentProvider == null) {
      return AIResponse(
        text: '',
        tokensUsed: 0,
        model: 'none',
        success: false,
        error: 'No AI provider configured. Please set an API key.',
      );
    }

    return _currentProvider!.generateNarrative(
      prompt: prompt,
      conversationHistory: conversationHistory,
      maxTokens: maxTokens,
      temperature: temperature,
    );
  }

  Future<ImageResponse> generateImage({
    required String prompt,
    String? style,
    int width = 1024,
    int height = 1024,
  }) async {
    if (_currentProvider == null) {
      return ImageResponse(
        success: false,
        error: 'No AI provider configured. Please set an API key.',
      );
    }

    final capabilities = _currentProvider!.getCapabilities();
    if (!capabilities.supportsImages) {
      return ImageResponse(
        success: false,
        error: 'Current provider ($_currentProviderName) does not support image generation.',
      );
    }

    return _currentProvider!.generateImage(
      prompt: prompt,
      style: style,
      width: width,
      height: height,
    );
  }

  Future<AIResponse> generateStructuredData({
    required String prompt,
    required String schema,
    int maxTokens = 2000,
  }) async {
    if (_currentProvider == null) {
      return AIResponse(
        text: '',
        tokensUsed: 0,
        model: 'none',
        success: false,
        error: 'No AI provider configured. Please set an API key.',
      );
    }

    return _currentProvider!.generateStructuredData(
      prompt: prompt,
      schema: schema,
      maxTokens: maxTokens,
    );
  }

  AICapabilities? getCapabilities() {
    return _currentProvider?.getCapabilities();
  }

  // Provider-specific features

  /// Generate character portrait (uses best available provider)
  Future<ImageResponse> generateCharacterPortrait({
    required String characterName,
    required String race,
    required String characterClass,
    required String description,
  }) async {
    if (_currentProvider == null) {
      return ImageResponse(
        success: false,
        error: 'No AI provider configured.',
      );
    }

    // Prefer Gemini for character portraits due to quality
    if (_currentProvider is GeminiProvider) {
      return (_currentProvider as GeminiProvider).generateCharacterPortrait(
        characterName: characterName,
        race: race,
        characterClass: characterClass,
        description: description,
      );
    }

    // Fall back to generic image generation
    final prompt = '''
D&D character portrait: $characterName, a $race $characterClass.
Description: $description
Fantasy art style, detailed, professional quality.
''';

    return generateImage(prompt: prompt, style: 'fantasy art');
  }

  /// Generate monster illustration
  Future<ImageResponse> generateMonsterImage({
    required String monsterName,
    required String description,
  }) async {
    if (_currentProvider == null) {
      return ImageResponse(
        success: false,
        error: 'No AI provider configured.',
      );
    }

    if (_currentProvider is GeminiProvider) {
      return (_currentProvider as GeminiProvider).generateMonsterImage(
        monsterName: monsterName,
        description: description,
      );
    }

    final prompt = '''
Epic D&D monster: $monsterName.
Description: $description
Menacing, atmospheric, high quality fantasy art.
''';

    return generateImage(prompt: prompt, style: 'dark fantasy');
  }

  /// Generate scene/location image
  Future<ImageResponse> generateSceneImage({
    required String sceneDescription,
  }) async {
    if (_currentProvider == null) {
      return ImageResponse(
        success: false,
        error: 'No AI provider configured.',
      );
    }

    if (_currentProvider is GeminiProvider) {
      return (_currentProvider as GeminiProvider).generateSceneImage(
        sceneDescription: sceneDescription,
      );
    }

    return generateImage(
      prompt: sceneDescription,
      style: 'cinematic fantasy art',
    );
  }
}
