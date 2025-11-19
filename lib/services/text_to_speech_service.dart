import 'dart:convert';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Voice types for different characters/narration
enum VoiceType {
  narrator, // Default DM voice
  male,
  female,
  creature,
  villain,
  elder,
}

/// Voice settings
class VoiceSettings {
  final double pitch; // 0.5 to 2.0
  final double rate; // 0.5 to 2.0 (speed)
  final double volume; // 0.0 to 1.0
  final String? language; // e.g., "en-US"

  const VoiceSettings({
    this.pitch = 1.0,
    this.rate = 1.0,
    this.volume = 1.0,
    this.language,
  });

  Map<String, dynamic> toJson() => {
        'pitch': pitch,
        'rate': rate,
        'volume': volume,
        'language': language,
      };

  factory VoiceSettings.fromJson(Map<String, dynamic> json) => VoiceSettings(
        pitch: (json['pitch'] as num?)?.toDouble() ?? 1.0,
        rate: (json['rate'] as num?)?.toDouble() ?? 1.0,
        volume: (json['volume'] as num?)?.toDouble() ?? 1.0,
        language: json['language'] as String?,
      );

  VoiceSettings copyWith({
    double? pitch,
    double? rate,
    double? volume,
    String? language,
  }) =>
      VoiceSettings(
        pitch: pitch ?? this.pitch,
        rate: rate ?? this.rate,
        volume: volume ?? this.volume,
        language: language ?? this.language,
      );
}

/// Text-to-Speech service for DM narration
class TextToSpeechService {
  static final TextToSpeechService _instance = TextToSpeechService._internal();
  factory TextToSpeechService() => _instance;
  TextToSpeechService._internal();

  // TTS engines
  final FlutterTts _flutterTts = FlutterTts();
  bool _initialized = false;

  // Settings
  bool _enabled = true;
  VoiceSettings _currentSettings = const VoiceSettings();
  final Map<VoiceType, VoiceSettings> _voicePresets = {};

  // Cloud TTS (optional, for higher quality voices)
  String? _cloudTtsApiKey;
  String _cloudTtsProvider = 'google'; // 'google', 'azure', 'elevenlabs'

  // Playback state
  bool _isPlaying = false;
  bool _isPaused = false;

  bool get isEnabled => _enabled;
  bool get isPlaying => _isPlaying;
  bool get isPaused => _isPaused;
  VoiceSettings get currentSettings => _currentSettings;

  /// Initialize the TTS service
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Initialize Flutter TTS
      await _flutterTts.setLanguage("en-US");
      await _flutterTts.setPitch(_currentSettings.pitch);
      await _flutterTts.setSpeechRate(_currentSettings.rate);
      await _flutterTts.setVolume(_currentSettings.volume);

      // Set up callbacks
      _flutterTts.setStartHandler(() {
        _isPlaying = true;
        _isPaused = false;
      });

      _flutterTts.setCompletionHandler(() {
        _isPlaying = false;
        _isPaused = false;
      });

      _flutterTts.setErrorHandler((msg) {
        print('TTS Error: $msg');
        _isPlaying = false;
        _isPaused = false;
      });

      _flutterTts.setPauseHandler(() {
        _isPaused = true;
      });

      _flutterTts.setContinueHandler(() {
        _isPaused = false;
      });

      // Load saved settings
      await _loadSettings();

      // Initialize voice presets
      _initializeVoicePresets();

      _initialized = true;
    } catch (e) {
      print('Failed to initialize TTS: $e');
    }
  }

  /// Initialize default voice presets
  void _initializeVoicePresets() {
    _voicePresets[VoiceType.narrator] = const VoiceSettings(
      pitch: 1.0,
      rate: 0.9,
      volume: 1.0,
    );

    _voicePresets[VoiceType.male] = const VoiceSettings(
      pitch: 0.8,
      rate: 1.0,
      volume: 1.0,
    );

    _voicePresets[VoiceType.female] = const VoiceSettings(
      pitch: 1.3,
      rate: 1.0,
      volume: 1.0,
    );

    _voicePresets[VoiceType.creature] = const VoiceSettings(
      pitch: 0.6,
      rate: 0.8,
      volume: 1.0,
    );

    _voicePresets[VoiceType.villain] = const VoiceSettings(
      pitch: 0.7,
      rate: 0.85,
      volume: 1.0,
    );

    _voicePresets[VoiceType.elder] = const VoiceSettings(
      pitch: 0.9,
      rate: 0.75,
      volume: 0.9,
    );
  }

  /// Speak text with DM narration
  Future<void> speak(
    String text, {
    VoiceType voiceType = VoiceType.narrator,
    VoiceSettings? customSettings,
  }) async {
    if (!_enabled || !_initialized) return;

    await stop(); // Stop any current playback

    // Apply voice settings
    VoiceSettings settings = customSettings ?? _voicePresets[voiceType] ?? _currentSettings;
    await _applySettings(settings);

    try {
      await _flutterTts.speak(text);
    } catch (e) {
      print('Error speaking text: $e');
    }
  }

  /// Speak using cloud TTS for higher quality
  Future<void> speakWithCloudTTS(
    String text, {
    VoiceType voiceType = VoiceType.narrator,
  }) async {
    if (!_enabled || _cloudTtsApiKey == null) {
      // Fallback to local TTS
      await speak(text, voiceType: voiceType);
      return;
    }

    try {
      switch (_cloudTtsProvider) {
        case 'google':
          await _speakWithGoogleTTS(text, voiceType);
          break;
        case 'azure':
          await _speakWithAzureTTS(text, voiceType);
          break;
        case 'elevenlabs':
          await _speakWithElevenLabs(text, voiceType);
          break;
        default:
          await speak(text, voiceType: voiceType);
      }
    } catch (e) {
      print('Cloud TTS error, falling back to local: $e');
      await speak(text, voiceType: voiceType);
    }
  }

  /// Pause current playback
  Future<void> pause() async {
    if (_isPlaying && !_isPaused) {
      await _flutterTts.pause();
    }
  }

  /// Resume paused playback
  Future<void> resume() async {
    if (_isPaused) {
      // Flutter TTS doesn't support resume well, so we'll just note the state
      _isPaused = false;
    }
  }

  /// Stop current playback
  Future<void> stop() async {
    if (_isPlaying) {
      await _flutterTts.stop();
      _isPlaying = false;
      _isPaused = false;
    }
  }

  /// Enable/disable TTS
  void setEnabled(bool enabled) {
    _enabled = enabled;
    _saveSettings();
  }

  /// Update voice settings
  Future<void> updateSettings(VoiceSettings settings) async {
    _currentSettings = settings;
    await _applySettings(settings);
    await _saveSettings();
  }

  /// Set cloud TTS API key
  void setCloudTtsApiKey(String apiKey, {String provider = 'google'}) {
    _cloudTtsApiKey = apiKey;
    _cloudTtsProvider = provider;
    _saveSettings();
  }

  /// Apply voice settings to TTS engine
  Future<void> _applySettings(VoiceSettings settings) async {
    await _flutterTts.setPitch(settings.pitch);
    await _flutterTts.setSpeechRate(settings.rate);
    await _flutterTts.setVolume(settings.volume);
    if (settings.language != null) {
      await _flutterTts.setLanguage(settings.language!);
    }
  }

  /// Get available voices
  Future<List<dynamic>> getAvailableVoices() async {
    try {
      return await _flutterTts.getVoices ?? [];
    } catch (e) {
      print('Error getting voices: $e');
      return [];
    }
  }

  /// Set specific voice by name
  Future<void> setVoice(Map<String, String> voice) async {
    try {
      await _flutterTts.setVoice(voice);
    } catch (e) {
      print('Error setting voice: $e');
    }
  }

  // ==================== Cloud TTS Implementations ====================

  Future<void> _speakWithGoogleTTS(String text, VoiceType voiceType) async {
    final response = await http.post(
      Uri.parse('https://texttospeech.googleapis.com/v1/text:synthesize'),
      headers: {
        'Content-Type': 'application/json',
        'X-Goog-Api-Key': _cloudTtsApiKey!,
      },
      body: jsonEncode({
        'input': {'text': text},
        'voice': {
          'languageCode': 'en-US',
          'name': _getGoogleVoiceName(voiceType),
        },
        'audioConfig': {
          'audioEncoding': 'MP3',
          'pitch': _voicePresets[voiceType]?.pitch ?? 1.0,
          'speakingRate': _voicePresets[voiceType]?.rate ?? 1.0,
        },
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // TODO: Play the audio from base64
      // This would require an audio player implementation
      print('Google TTS audio received');
    }
  }

  Future<void> _speakWithAzureTTS(String text, VoiceType voiceType) async {
    // Azure TTS implementation
    // Similar to Google but with Azure endpoints
    print('Azure TTS not fully implemented');
  }

  Future<void> _speakWithElevenLabs(String text, VoiceType voiceType) async {
    // ElevenLabs API for very high quality character voices
    final response = await http.post(
      Uri.parse('https://api.elevenlabs.io/v1/text-to-speech/${_getElevenLabsVoiceId(voiceType)}'),
      headers: {
        'Content-Type': 'application/json',
        'xi-api-key': _cloudTtsApiKey!,
      },
      body: jsonEncode({
        'text': text,
        'model_id': 'eleven_monolingual_v1',
        'voice_settings': {
          'stability': 0.5,
          'similarity_boost': 0.5,
        },
      }),
    );

    if (response.statusCode == 200) {
      // TODO: Play the audio
      print('ElevenLabs TTS audio received');
    }
  }

  String _getGoogleVoiceName(VoiceType voiceType) {
    switch (voiceType) {
      case VoiceType.narrator:
        return 'en-US-Neural2-J'; // Warm, professional male
      case VoiceType.male:
        return 'en-US-Neural2-D'; // Standard male
      case VoiceType.female:
        return 'en-US-Neural2-F'; // Standard female
      case VoiceType.creature:
        return 'en-US-Neural2-A'; // Deep male
      case VoiceType.villain:
        return 'en-GB-Neural2-D'; // British male (dramatic)
      case VoiceType.elder:
        return 'en-US-Neural2-I'; // Older male
    }
  }

  String _getElevenLabsVoiceId(VoiceType voiceType) {
    // ElevenLabs voice IDs - these are examples
    switch (voiceType) {
      case VoiceType.narrator:
        return 'pNInz6obpgDQGcFmaJgB'; // Adam
      case VoiceType.male:
        return 'VR6AewLTigWG4xSOukaG'; // Arnold
      case VoiceType.female:
        return 'EXAVITQu4vr4xnSDxMaL'; // Bella
      case VoiceType.villain:
        return 'TxGEqnHWrfWFTfGW9XjX'; // Josh
      default:
        return 'pNInz6obpgDQGcFmaJgB';
    }
  }

  // ==================== Settings Persistence ====================

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _enabled = prefs.getBool('tts_enabled') ?? true;

      final settingsJson = prefs.getString('tts_settings');
      if (settingsJson != null) {
        _currentSettings = VoiceSettings.fromJson(jsonDecode(settingsJson));
      }

      _cloudTtsApiKey = prefs.getString('cloud_tts_api_key');
      _cloudTtsProvider = prefs.getString('cloud_tts_provider') ?? 'google';
    } catch (e) {
      print('Error loading TTS settings: $e');
    }
  }

  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('tts_enabled', _enabled);
      await prefs.setString('tts_settings', jsonEncode(_currentSettings.toJson()));

      if (_cloudTtsApiKey != null) {
        await prefs.setString('cloud_tts_api_key', _cloudTtsApiKey!);
      }
      await prefs.setString('cloud_tts_provider', _cloudTtsProvider);
    } catch (e) {
      print('Error saving TTS settings: $e');
    }
  }
}
