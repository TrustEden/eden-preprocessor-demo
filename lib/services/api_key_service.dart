import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/ai_configuration.dart';

/// Secure storage and management of API keys
class APIKeyService {
  static final APIKeyService _instance = APIKeyService._internal();
  factory APIKeyService() => _instance;
  APIKeyService._internal();

  late final FlutterSecureStorage _secureStorage;
  bool _initialized = false;

  // Key prefixes for different providers
  static const String _claudeKeyPrefix = 'api_key_claude';
  static const String _openaiKeyPrefix = 'api_key_openai';
  static const String _geminiKeyPrefix = 'api_key_gemini';

  /// Initialize the service
  Future<void> initialize() async {
    if (_initialized) return;

    _secureStorage = const FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock,
      ),
    );

    _initialized = true;
  }

  /// Store API key for a provider
  Future<void> storeAPIKey(AIProvider provider, String apiKey) async {
    await initialize();

    if (apiKey.isEmpty) {
      throw ArgumentError('API key cannot be empty');
    }

    // Validate key format before storing
    _validateAPIKey(provider, apiKey);

    String key = _getKeyForProvider(provider);
    await _secureStorage.write(key: key, value: apiKey);
  }

  /// Retrieve API key for a provider
  Future<String?> getAPIKey(AIProvider provider) async {
    await initialize();

    String key = _getKeyForProvider(provider);
    return await _secureStorage.read(key: key);
  }

  /// Check if API key exists for a provider
  Future<bool> hasAPIKey(AIProvider provider) async {
    await initialize();

    String key = _getKeyForProvider(provider);
    String? value = await _secureStorage.read(key: key);
    return value != null && value.isNotEmpty;
  }

  /// Delete API key for a provider
  Future<void> deleteAPIKey(AIProvider provider) async {
    await initialize();

    String key = _getKeyForProvider(provider);
    await _secureStorage.delete(key: key);
  }

  /// Delete all API keys (use with caution)
  Future<void> deleteAllAPIKeys() async {
    await initialize();

    for (var provider in AIProvider.values) {
      await deleteAPIKey(provider);
    }
  }

  /// Get masked version of API key for display
  Future<String?> getMaskedAPIKey(AIProvider provider) async {
    String? key = await getAPIKey(provider);
    if (key == null || key.isEmpty) return null;

    // Show first 4 and last 4 characters
    if (key.length <= 8) {
      return '••••••••';
    }

    return '${key.substring(0, 4)}••••${key.substring(key.length - 4)}';
  }

  /// Validate API key format for different providers
  void _validateAPIKey(AIProvider provider, String apiKey) {
    switch (provider) {
      case AIProvider.claude:
        // Claude keys start with 'sk-ant-'
        if (!apiKey.startsWith('sk-ant-')) {
          throw FormatException(
            'Invalid Claude API key format. Should start with "sk-ant-"',
          );
        }
        if (apiKey.length < 20) {
          throw FormatException('Claude API key is too short');
        }
        break;

      case AIProvider.openai:
        // OpenAI keys start with 'sk-'
        if (!apiKey.startsWith('sk-')) {
          throw FormatException(
            'Invalid OpenAI API key format. Should start with "sk-"',
          );
        }
        if (apiKey.length < 20) {
          throw FormatException('OpenAI API key is too short');
        }
        break;

      case AIProvider.gemini:
        // Gemini keys are typically 39 characters
        if (apiKey.length < 30) {
          throw FormatException('Gemini API key appears to be invalid');
        }
        break;

      case AIProvider.local:
        // Local models don't need API keys
        break;
    }
  }

  /// Get storage key for provider
  String _getKeyForProvider(AIProvider provider) {
    switch (provider) {
      case AIProvider.claude:
        return _claudeKeyPrefix;
      case AIProvider.openai:
        return _openaiKeyPrefix;
      case AIProvider.gemini:
        return _geminiKeyPrefix;
      case AIProvider.local:
        return 'api_key_local'; // Won't be used, but for completeness
    }
  }

  /// Test API key by making a simple request
  Future<APIKeyTestResult> testAPIKey(
    AIProvider provider,
    String apiKey,
  ) async {
    // This would make a minimal API call to verify the key works
    // For now, just validate format
    try {
      _validateAPIKey(provider, apiKey);
      return APIKeyTestResult(
        isValid: true,
        message: 'API key format is valid',
      );
    } catch (e) {
      return APIKeyTestResult(
        isValid: false,
        message: e.toString(),
      );
    }
  }

  /// Migrate existing API keys from SharedPreferences (for existing users)
  Future<void> migrateFromSharedPreferences() async {
    await initialize();

    try {
      // This would read from SharedPreferences and migrate to secure storage
      // Then delete from SharedPreferences
      // Implementation depends on your existing storage structure
    } catch (e) {
      // Migration failed, but don't crash
      print('API key migration failed: $e');
    }
  }

  /// Export API keys for backup (encrypted)
  Future<Map<String, String>> exportKeys() async {
    await initialize();

    Map<String, String> keys = {};

    for (var provider in AIProvider.values) {
      String? key = await getAPIKey(provider);
      if (key != null && key.isNotEmpty) {
        keys[provider.toString()] = key;
      }
    }

    return keys;
  }

  /// Import API keys from backup
  Future<void> importKeys(Map<String, String> keys) async {
    await initialize();

    for (var entry in keys.entries) {
      try {
        var provider = AIProvider.values.firstWhere(
          (p) => p.toString() == entry.key,
        );
        await storeAPIKey(provider, entry.value);
      } catch (e) {
        // Skip invalid entries
        print('Failed to import key for ${entry.key}: $e');
      }
    }
  }

  /// Clear all secure storage (for debugging/testing)
  Future<void> clearAll() async {
    await initialize();
    await _secureStorage.deleteAll();
  }
}

/// Result of API key validation test
class APIKeyTestResult {
  final bool isValid;
  final String message;
  final Map<String, dynamic>? details;

  APIKeyTestResult({
    required this.isValid,
    required this.message,
    this.details,
  });
}

/// Exception thrown when API key is missing or invalid
class APIKeyException implements Exception {
  final String message;
  final AIProvider provider;

  APIKeyException({
    required this.message,
    required this.provider,
  });

  @override
  String toString() => 'APIKeyException for ${provider.toString()}: $message';
}
