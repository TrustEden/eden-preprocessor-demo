import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/enhanced_character.dart';
import '../models/race.dart';
import '../models/character_class.dart';

/// Service for generating AI character portraits
/// Supports multiple AI image generation providers
class PortraitGenerationService {
  static final PortraitGenerationService _instance = PortraitGenerationService._internal();
  factory PortraitGenerationService() => _instance;
  PortraitGenerationService._internal();

  String? _apiKey;
  String _provider = 'dall-e'; // Options: 'dall-e', 'stable-diffusion', 'midjourney'

  void setApiKey(String apiKey) {
    _apiKey = apiKey;
  }

  void setProvider(String provider) {
    _provider = provider;
  }

  /// Generate a character portrait based on character attributes
  Future<String?> generatePortrait(EnhancedCharacter character) async {
    if (_apiKey == null || _apiKey!.isEmpty) {
      throw Exception('Portrait generation API key not set');
    }

    String prompt = _buildPromptFromCharacter(character);

    switch (_provider) {
      case 'dall-e':
        return await _generateWithDallE(prompt);
      case 'stable-diffusion':
        return await _generateWithStableDiffusion(prompt);
      default:
        throw Exception('Unsupported portrait generation provider: $_provider');
    }
  }

  /// Build a detailed prompt from character attributes
  String _buildPromptFromCharacter(EnhancedCharacter character) {
    List<String> promptParts = [];

    // Start with art style
    promptParts.add('Fantasy character portrait');

    // Add character basics
    promptParts.add('a ${_getAgeDescriptor(character)} ${character.race.name}');

    // Add class
    promptParts.add('${character.characterClass.name}');

    // Add physical descriptions from race
    if (character.race.id.contains('elf')) {
      promptParts.add('with pointed ears and graceful features');
    } else if (character.race.id.contains('dwarf')) {
      promptParts.add('with a sturdy build and strong features');
    } else if (character.race.id.contains('orc') || character.race.id == 'half_orc') {
      promptParts.add('with prominent tusks and muscular build');
    } else if (character.race.id.contains('halfling')) {
      promptParts.add('with a small stature and cheerful expression');
    } else if (character.race.id.contains('dragonborn')) {
      promptParts.add('with draconic scales and reptilian features');
    } else if (character.race.id == 'tiefling') {
      promptParts.add('with horns, tail, and demonic heritage features');
    }

    // Add equipment descriptions
    if (character.equippedArmor != null) {
      promptParts.add('wearing ${character.equippedArmor!.name}');
    }

    if (character.equippedWeapon != null) {
      promptParts.add('wielding a ${character.equippedWeapon!.name}');
    }

    // Add class-specific details
    switch (character.characterClass.id) {
      case 'wizard':
      case 'sorcerer':
        promptParts.add('with mystical robes and arcane symbols');
        break;
      case 'cleric':
      case 'paladin':
        promptParts.add('with holy symbols and divine radiance');
        break;
      case 'rogue':
        promptParts.add('with dark leather armor and stealth gear');
        break;
      case 'barbarian':
        promptParts.add('with wild appearance and tribal markings');
        break;
      case 'ranger':
        promptParts.add('with nature-themed gear and woodland colors');
        break;
      case 'monk':
        promptParts.add('in simple martial arts attire');
        break;
      case 'bard':
        promptParts.add('with a musical instrument and colorful clothing');
        break;
      case 'druid':
        promptParts.add('adorned with natural materials and animal motifs');
        break;
    }

    // Add personality hints if available
    if (character.personalityTrait1 != null) {
      if (character.personalityTrait1!.toLowerCase().contains('brave') ||
          character.personalityTrait1!.toLowerCase().contains('confident')) {
        promptParts.add('with a confident and determined expression');
      } else if (character.personalityTrait1!.toLowerCase().contains('shy') ||
                 character.personalityTrait1!.toLowerCase().contains('quiet')) {
        promptParts.add('with a gentle and thoughtful expression');
      }
    }

    // Art style specifications
    promptParts.add('detailed digital art, D&D character art style, heroic fantasy, high quality, professional illustration');

    return promptParts.join(', ');
  }

  String _getAgeDescriptor(EnhancedCharacter character) {
    // Base age description on level as a proxy
    if (character.level <= 3) {
      return 'young';
    } else if (character.level <= 10) {
      return 'experienced';
    } else {
      return 'veteran';
    }
  }

  /// Generate portrait using DALL-E API
  Future<String?> _generateWithDallE(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/images/generations'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'dall-e-3',
          'prompt': prompt,
          'n': 1,
          'size': '1024x1024',
          'quality': 'standard',
          'style': 'vivid',
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'][0]['url'] as String;
      } else {
        print('DALL-E API error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error generating portrait with DALL-E: $e');
      return null;
    }
  }

  /// Generate portrait using Stable Diffusion API
  Future<String?> _generateWithStableDiffusion(String prompt) async {
    try {
      // This is a generic implementation for Stability AI API
      final response = await http.post(
        Uri.parse('https://api.stability.ai/v1/generation/stable-diffusion-xl-1024-v1-0/text-to-image'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'text_prompts': [
            {
              'text': prompt,
              'weight': 1,
            },
          ],
          'cfg_scale': 7,
          'height': 1024,
          'width': 1024,
          'samples': 1,
          'steps': 30,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Base64 encoded image
        String base64Image = data['artifacts'][0]['base64'] as String;
        return 'data:image/png;base64,$base64Image';
      } else {
        print('Stable Diffusion API error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error generating portrait with Stable Diffusion: $e');
      return null;
    }
  }

  /// Get a placeholder portrait URL while generation is in progress
  String getPlaceholderPortrait(EnhancedCharacter character) {
    // Return a UI Avatars placeholder based on character name and class
    String initials = character.name.split(' ').map((n) => n[0]).take(2).join('');
    String color = _getColorForClass(character.characterClass.id);

    return 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(character.name)}&size=512&background=$color&color=fff&bold=true';
  }

  String _getColorForClass(String classId) {
    switch (classId) {
      case 'fighter': return '8B4513'; // Brown
      case 'wizard': return '4169E1'; // Royal Blue
      case 'rogue': return '2F4F4F'; // Dark Slate Gray
      case 'cleric': return 'FFD700'; // Gold
      case 'ranger': return '228B22'; // Forest Green
      case 'barbarian': return 'DC143C'; // Crimson
      case 'paladin': return 'B8860B'; // Dark Goldenrod
      case 'druid': return '6B8E23'; // Olive Drab
      case 'monk': return '8B7355'; // Burlywood
      case 'bard': return 'DA70D6'; // Orchid
      case 'warlock': return '483D8B'; // Dark Slate Blue
      case 'sorcerer': return 'FF4500'; // Orange Red
      default: return '696969'; // Dim Gray
    }
  }

  /// Update character with generated portrait
  Future<void> updateCharacterPortrait(EnhancedCharacter character) async {
    String prompt = _buildPromptFromCharacter(character);
    String? portraitUrl = await generatePortrait(character);

    if (portraitUrl != null) {
      character.portraitUrl = portraitUrl;
      character.portraitPrompt = prompt;
      character.portraitGeneratedAt = DateTime.now();
    }
  }
}
