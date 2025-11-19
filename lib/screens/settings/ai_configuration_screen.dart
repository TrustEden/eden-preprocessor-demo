import 'package:flutter/material.dart';
import '../../models/ai_configuration.dart';
import '../../services/ai_assistant_service.dart';
import '../../services/api_key_service.dart';

/// Configuration screen for AI settings
class AIConfigurationScreen extends StatefulWidget {
  const AIConfigurationScreen({Key? key}) : super(key: key);

  @override
  State<AIConfigurationScreen> createState() => _AIConfigurationScreenState();
}

class _AIConfigurationScreenState extends State<AIConfigurationScreen> {
  final AIAssistantService _aiService = AIAssistantService();
  final APIKeyService _keyService = APIKeyService();

  late AIConfiguration _config;
  final Map<AIProvider, TextEditingController> _keyControllers = {};
  final Map<AIProvider, String?> _maskedKeys = {};

  bool _isLoading = true;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _loadConfiguration();
  }

  Future<void> _loadConfiguration() async {
    setState(() => _isLoading = true);

    _config = _aiService.getConfiguration();

    // Initialize controllers for each provider
    for (var provider in AIProvider.values) {
      _keyControllers[provider] = TextEditingController();
      _maskedKeys[provider] = await _keyService.getMaskedAPIKey(provider);
    }

    setState(() => _isLoading = false);
  }

  Future<void> _saveConfiguration() async {
    setState(() => _isLoading = true);

    // Save API keys
    for (var entry in _keyControllers.entries) {
      if (entry.value.text.isNotEmpty) {
        try {
          await _keyService.storeAPIKey(entry.key, entry.value.text);
          entry.value.clear(); // Clear after saving
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error saving ${entry.key} key: $e')),
            );
          }
        }
      }
    }

    // Update AI service configuration
    _aiService.setConfiguration(_config);

    setState(() {
      _hasChanges = false;
      _isLoading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Configuration saved')),
      );
    }

    // Reload masked keys
    await _loadConfiguration();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Configuration'),
        backgroundColor: Colors.purple[700],
        actions: [
          if (_hasChanges)
            TextButton.icon(
              onPressed: _saveConfiguration,
              icon: const Icon(Icons.save, color: Colors.white),
              label: const Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Provider selection
          _buildProviderSection(),
          const SizedBox(height: 24),

          // Model selection
          _buildModelSection(),
          const SizedBox(height: 24),

          // API Key management
          _buildAPIKeySection(),
          const SizedBox(height: 24),

          // Generation parameters
          _buildGenerationParametersSection(),
          const SizedBox(height: 24),

          // Campaign settings
          _buildCampaignSettingsSection(),
          const SizedBox(height: 24),

          // Cost management
          _buildCostManagementSection(),
          const SizedBox(height: 24),

          // Usage stats
          _buildUsageStatsSection(),
        ],
      ),
    );
  }

  Widget _buildProviderSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'AI Provider',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...AIProvider.values.map((provider) {
              return RadioListTile<AIProvider>(
                title: Text(_getProviderName(provider)),
                subtitle: Text(_getProviderDescription(provider)),
                value: provider,
                groupValue: _config.provider,
                onChanged: (value) {
                  setState(() {
                    _config = _config.copyWith(provider: value);
                    _hasChanges = true;
                  });
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildModelSection() {
    var availableModels = _config.getAvailableModels();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Model Selection',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _config.modelId,
              decoration: const InputDecoration(
                labelText: 'Model',
                border: OutlineInputBorder(),
              ),
              items: availableModels.map((model) {
                return DropdownMenuItem(
                  value: model.id,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(model.name),
                      Text(
                        model.description,
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                      Text(
                        '\$${model.costPer1kTokens.toStringAsFixed(4)}/1K tokens',
                        style: const TextStyle(fontSize: 10, color: Colors.green),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _config = _config.copyWith(modelId: value);
                    _hasChanges = true;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAPIKeySection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'API Keys',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'API keys are stored securely and encrypted.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ...AIProvider.values.where((p) => p != AIProvider.local).map((provider) {
              return _buildAPIKeyField(provider);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildAPIKeyField(AIProvider provider) {
    var controller = _keyControllers[provider]!;
    var maskedKey = _maskedKeys[provider];

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _getProviderName(provider),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (maskedKey != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.green[300]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green[700], size: 20),
                  const SizedBox(width: 8),
                  Text('Configured: $maskedKey'),
                  const Spacer(),
                  TextButton(
                    onPressed: () async {
                      await _keyService.deleteAPIKey(provider);
                      setState(() {
                        _maskedKeys[provider] = null;
                      });
                    },
                    child: const Text('Remove'),
                  ),
                ],
              ),
            )
          else
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: 'Enter API Key',
                hintText: _getAPIKeyHint(provider),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.help_outline),
                  onPressed: () => _showAPIKeyHelp(provider),
                ),
              ),
              obscureText: true,
              onChanged: (_) => setState(() => _hasChanges = true),
            ),
        ],
      ),
    );
  }

  Widget _buildGenerationParametersSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Generation Parameters',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Max tokens
            _buildSlider(
              'Max Tokens',
              _config.maxTokens.toDouble(),
              500,
              4000,
              (value) {
                setState(() {
                  _config = _config.copyWith(maxTokens: value.toInt());
                  _hasChanges = true;
                });
              },
              label: _config.maxTokens.toString(),
            ),

            // Temperature
            _buildSlider(
              'Creativity (Temperature)',
              _config.temperature,
              0.0,
              1.0,
              (value) {
                setState(() {
                  _config = _config.copyWith(temperature: value);
                  _hasChanges = true;
                });
              },
              label: _config.temperature.toStringAsFixed(2),
              divisions: 20,
            ),

            // Suggestion count
            const Text('Suggestions per Request:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<int>(
              value: _config.suggestionCount,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: [1, 2, 3, 5].map((count) {
                return DropdownMenuItem(
                  value: count,
                  child: Text('$count suggestion${count > 1 ? "s" : ""}'),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _config = _config.copyWith(suggestionCount: value);
                    _hasChanges = true;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCampaignSettingsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Campaign Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Campaign tone
            const Text('Campaign Tone:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: CampaignTone.values.map((tone) {
                return ChoiceChip(
                  label: Text(_formatTone(tone)),
                  selected: _config.preferredTone == tone,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _config = _config.copyWith(preferredTone: tone);
                        _hasChanges = true;
                      });
                    }
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // Narrative style
            const Text('Narrative Style:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: NarrativeStyle.values.map((style) {
                return ChoiceChip(
                  label: Text(_formatNarrativeStyle(style)),
                  selected: _config.narrativeStyle == style,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _config = _config.copyWith(narrativeStyle: style);
                        _hasChanges = true;
                      });
                    }
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCostManagementSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cost Management',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Enable Cost Warnings'),
              subtitle: const Text('Warn before exceeding budget'),
              value: _config.enableCostWarnings,
              onChanged: (value) {
                setState(() {
                  _config = _config.copyWith(enableCostWarnings: value);
                  _hasChanges = true;
                });
              },
            ),
            // Budget could be added here
          ],
        ),
      ),
    );
  }

  Widget _buildUsageStatsSection() {
    var stats = _aiService.getUsageStats();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Usage Statistics',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildStatRow('Requests This Month', stats.requestCount.toString()),
            _buildStatRow('Tokens Used', stats.tokensUsed.toString()),
            _buildStatRow('Cost Accrued', '\$${stats.costAccrued.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(
    String label,
    double value,
    double min,
    double max,
    Function(double) onChanged, {
    String? label,
    int? divisions,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label:', style: const TextStyle(fontWeight: FontWeight.bold)),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions ?? ((max - min) ~/ 100),
          label: label ?? value.toStringAsFixed(0),
          onChanged: onChanged,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  String _getProviderName(AIProvider provider) {
    switch (provider) {
      case AIProvider.claude:
        return 'Claude (Anthropic)';
      case AIProvider.openai:
        return 'GPT (OpenAI)';
      case AIProvider.gemini:
        return 'Gemini (Google)';
      case AIProvider.local:
        return 'Local Model';
    }
  }

  String _getProviderDescription(AIProvider provider) {
    switch (provider) {
      case AIProvider.claude:
        return 'Best narrative quality, higher cost';
      case AIProvider.openai:
        return 'Good quality, moderate cost';
      case AIProvider.gemini:
        return 'Fast and affordable';
      case AIProvider.local:
        return 'Free, runs on your computer';
    }
  }

  String _getAPIKeyHint(AIProvider provider) {
    switch (provider) {
      case AIProvider.claude:
        return 'sk-ant-...';
      case AIProvider.openai:
        return 'sk-...';
      case AIProvider.gemini:
        return 'AI...';
      case AIProvider.local:
        return '';
    }
  }

  void _showAPIKeyHelp(AIProvider provider) {
    String url;
    switch (provider) {
      case AIProvider.claude:
        url = 'console.anthropic.com';
        break;
      case AIProvider.openai:
        url = 'platform.openai.com/api-keys';
        break;
      case AIProvider.gemini:
        url = 'makersuite.google.com/app/apikey';
        break;
      default:
        return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Get ${_getProviderName(provider)} API Key'),
        content: Text('Visit $url to create an API key'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _formatTone(CampaignTone tone) {
    switch (tone) {
      case CampaignTone.heroic:
        return 'Heroic';
      case CampaignTone.dark:
        return 'Dark';
      case CampaignTone.comedic:
        return 'Comedic';
      case CampaignTone.political:
        return 'Political';
      case CampaignTone.horror:
        return 'Horror';
      case CampaignTone.balanced:
        return 'Balanced';
    }
  }

  String _formatNarrativeStyle(NarrativeStyle style) {
    switch (style) {
      case NarrativeStyle.concise:
        return 'Concise';
      case NarrativeStyle.descriptive:
        return 'Descriptive';
      case NarrativeStyle.dramatic:
        return 'Dramatic';
      case NarrativeStyle.cinematic:
        return 'Cinematic';
    }
  }

  @override
  void dispose() {
    for (var controller in _keyControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}
