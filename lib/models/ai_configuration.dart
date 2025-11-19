/// AI provider configuration and settings
class AIConfiguration {
  // Provider selection
  AIProvider provider;
  String modelId;

  // API credentials (stored securely elsewhere, just IDs here)
  String? apiKeyIdentifier;

  // Generation parameters
  int maxTokens;
  double temperature; // 0.0-1.0 (deterministic vs creative)
  double topP; // Nucleus sampling

  // Behavior settings
  int suggestionCount; // How many narrative options to generate
  bool autoFormatNarrative;
  bool includeMetadata; // Include predictions, CR calculations, etc.
  bool streamResponses; // Stream tokens as they arrive

  // Campaign settings
  CampaignTone preferredTone;
  List<String> contentRestrictions;
  NarrativeStyle narrativeStyle;

  // Cost management
  int? monthlyTokenBudget;
  bool useLocalFallback; // Fallback to local model when budget exceeded
  bool enableCostWarnings;

  // Advanced
  Map<String, dynamic> customParameters; // Provider-specific params

  AIConfiguration({
    this.provider = AIProvider.claude,
    String? modelId,
    this.apiKeyIdentifier,
    this.maxTokens = 1500,
    this.temperature = 0.7,
    this.topP = 1.0,
    this.suggestionCount = 3,
    this.autoFormatNarrative = true,
    this.includeMetadata = true,
    this.streamResponses = false,
    this.preferredTone = CampaignTone.balanced,
    List<String>? contentRestrictions,
    this.narrativeStyle = NarrativeStyle.descriptive,
    this.monthlyTokenBudget,
    this.useLocalFallback = false,
    this.enableCostWarnings = true,
    Map<String, dynamic>? customParameters,
  })  : modelId = modelId ?? _getDefaultModel(provider),
        contentRestrictions = contentRestrictions ?? [],
        customParameters = customParameters ?? {};

  static String _getDefaultModel(AIProvider provider) {
    switch (provider) {
      case AIProvider.claude:
        return 'claude-sonnet-4-20250514';
      case AIProvider.openai:
        return 'gpt-4-turbo-preview';
      case AIProvider.gemini:
        return 'gemini-pro';
      case AIProvider.local:
        return 'llama-2-7b';
    }
  }

  /// Get available models for current provider
  List<AIModel> getAvailableModels() {
    switch (provider) {
      case AIProvider.claude:
        return [
          AIModel(
            id: 'claude-sonnet-4-20250514',
            name: 'Claude Sonnet 4',
            description: 'Latest model, best quality',
            costPer1kTokens: 0.015,
            maxTokens: 4096,
          ),
          AIModel(
            id: 'claude-3-5-sonnet-20241022',
            name: 'Claude 3.5 Sonnet',
            description: 'Previous generation, still excellent',
            costPer1kTokens: 0.003,
            maxTokens: 4096,
          ),
          AIModel(
            id: 'claude-3-haiku-20240307',
            name: 'Claude 3 Haiku',
            description: 'Fast and economical',
            costPer1kTokens: 0.00025,
            maxTokens: 4096,
          ),
        ];

      case AIProvider.openai:
        return [
          AIModel(
            id: 'gpt-4-turbo-preview',
            name: 'GPT-4 Turbo',
            description: 'Most capable OpenAI model',
            costPer1kTokens: 0.01,
            maxTokens: 4096,
          ),
          AIModel(
            id: 'gpt-4',
            name: 'GPT-4',
            description: 'Standard GPT-4',
            costPer1kTokens: 0.03,
            maxTokens: 8192,
          ),
          AIModel(
            id: 'gpt-3.5-turbo',
            name: 'GPT-3.5 Turbo',
            description: 'Fast and affordable',
            costPer1kTokens: 0.0005,
            maxTokens: 4096,
          ),
        ];

      case AIProvider.gemini:
        return [
          AIModel(
            id: 'gemini-pro',
            name: 'Gemini Pro',
            description: 'Google\'s flagship model',
            costPer1kTokens: 0.00025,
            maxTokens: 2048,
          ),
          AIModel(
            id: 'gemini-pro-vision',
            name: 'Gemini Pro Vision',
            description: 'Multimodal capabilities',
            costPer1kTokens: 0.00025,
            maxTokens: 2048,
          ),
        ];

      case AIProvider.local:
        return [
          AIModel(
            id: 'llama-2-7b',
            name: 'Llama 2 7B',
            description: 'Free, runs locally',
            costPer1kTokens: 0.0,
            maxTokens: 4096,
          ),
          AIModel(
            id: 'llama-2-13b',
            name: 'Llama 2 13B',
            description: 'Better quality, requires more RAM',
            costPer1kTokens: 0.0,
            maxTokens: 4096,
          ),
        ];
    }
  }

  /// Estimate cost for a request
  double estimateCost(int promptTokens, int completionTokens) {
    var model = getAvailableModels().firstWhere(
      (m) => m.id == modelId,
      orElse: () => getAvailableModels().first,
    );

    return ((promptTokens + completionTokens) / 1000) * model.costPer1kTokens;
  }

  Map<String, dynamic> toJson() => {
        'provider': provider.toString(),
        'modelId': modelId,
        'apiKeyIdentifier': apiKeyIdentifier,
        'maxTokens': maxTokens,
        'temperature': temperature,
        'topP': topP,
        'suggestionCount': suggestionCount,
        'autoFormatNarrative': autoFormatNarrative,
        'includeMetadata': includeMetadata,
        'streamResponses': streamResponses,
        'preferredTone': preferredTone.toString(),
        'contentRestrictions': contentRestrictions,
        'narrativeStyle': narrativeStyle.toString(),
        'monthlyTokenBudget': monthlyTokenBudget,
        'useLocalFallback': useLocalFallback,
        'enableCostWarnings': enableCostWarnings,
        'customParameters': customParameters,
      };

  factory AIConfiguration.fromJson(Map<String, dynamic> json) {
    return AIConfiguration(
      provider: AIProvider.values.firstWhere(
        (e) => e.toString() == json['provider'],
        orElse: () => AIProvider.claude,
      ),
      modelId: json['modelId'] as String?,
      apiKeyIdentifier: json['apiKeyIdentifier'] as String?,
      maxTokens: json['maxTokens'] as int? ?? 1500,
      temperature: (json['temperature'] as num?)?.toDouble() ?? 0.7,
      topP: (json['topP'] as num?)?.toDouble() ?? 1.0,
      suggestionCount: json['suggestionCount'] as int? ?? 3,
      autoFormatNarrative: json['autoFormatNarrative'] as bool? ?? true,
      includeMetadata: json['includeMetadata'] as bool? ?? true,
      streamResponses: json['streamResponses'] as bool? ?? false,
      preferredTone: CampaignTone.values.firstWhere(
        (e) => e.toString() == json['preferredTone'],
        orElse: () => CampaignTone.balanced,
      ),
      contentRestrictions: (json['contentRestrictions'] as List<dynamic>?)?.cast<String>() ?? [],
      narrativeStyle: NarrativeStyle.values.firstWhere(
        (e) => e.toString() == json['narrativeStyle'],
        orElse: () => NarrativeStyle.descriptive,
      ),
      monthlyTokenBudget: json['monthlyTokenBudget'] as int?,
      useLocalFallback: json['useLocalFallback'] as bool? ?? false,
      enableCostWarnings: json['enableCostWarnings'] as bool? ?? true,
      customParameters: (json['customParameters'] as Map<String, dynamic>?) ?? {},
    );
  }

  AIConfiguration copyWith({
    AIProvider? provider,
    String? modelId,
    String? apiKeyIdentifier,
    int? maxTokens,
    double? temperature,
    double? topP,
    int? suggestionCount,
    bool? autoFormatNarrative,
    bool? includeMetadata,
    bool? streamResponses,
    CampaignTone? preferredTone,
    List<String>? contentRestrictions,
    NarrativeStyle? narrativeStyle,
    int? monthlyTokenBudget,
    bool? useLocalFallback,
    bool? enableCostWarnings,
    Map<String, dynamic>? customParameters,
  }) {
    return AIConfiguration(
      provider: provider ?? this.provider,
      modelId: modelId ?? this.modelId,
      apiKeyIdentifier: apiKeyIdentifier ?? this.apiKeyIdentifier,
      maxTokens: maxTokens ?? this.maxTokens,
      temperature: temperature ?? this.temperature,
      topP: topP ?? this.topP,
      suggestionCount: suggestionCount ?? this.suggestionCount,
      autoFormatNarrative: autoFormatNarrative ?? this.autoFormatNarrative,
      includeMetadata: includeMetadata ?? this.includeMetadata,
      streamResponses: streamResponses ?? this.streamResponses,
      preferredTone: preferredTone ?? this.preferredTone,
      contentRestrictions: contentRestrictions ?? this.contentRestrictions,
      narrativeStyle: narrativeStyle ?? this.narrativeStyle,
      monthlyTokenBudget: monthlyTokenBudget ?? this.monthlyTokenBudget,
      useLocalFallback: useLocalFallback ?? this.useLocalFallback,
      enableCostWarnings: enableCostWarnings ?? this.enableCostWarnings,
      customParameters: customParameters ?? this.customParameters,
    );
  }
}

enum AIProvider {
  claude, // Anthropic Claude
  openai, // OpenAI GPT
  gemini, // Google Gemini
  local, // Local model (Llama, etc.)
}

class AIModel {
  String id;
  String name;
  String description;
  double costPer1kTokens;
  int maxTokens;

  AIModel({
    required this.id,
    required this.name,
    required this.description,
    required this.costPer1kTokens,
    required this.maxTokens,
  });
}

enum CampaignTone {
  heroic, // Classic heroic fantasy
  dark, // Gritty, dark themes
  comedic, // Light-hearted, funny
  political, // Intrigue and diplomacy
  horror, // Scary, unsettling
  balanced, // Mix of tones
}

enum NarrativeStyle {
  concise, // Short, to the point
  descriptive, // Rich details
  dramatic, // Emphasis on tension
  cinematic, // Movie-like descriptions
}

/// Usage tracking for cost management
class AIUsageStats {
  DateTime periodStart;
  DateTime periodEnd;
  int tokensUsed;
  double costAccrued;
  int requestCount;
  Map<String, int> tokensByModel; // modelId -> tokens

  AIUsageStats({
    required this.periodStart,
    required this.periodEnd,
    this.tokensUsed = 0,
    this.costAccrued = 0.0,
    this.requestCount = 0,
    Map<String, int>? tokensByModel,
  }) : tokensByModel = tokensByModel ?? {};

  double get percentOfBudget {
    // This would be calculated against the configured budget
    return 0.0; // Placeholder
  }

  Map<String, dynamic> toJson() => {
        'periodStart': periodStart.toIso8601String(),
        'periodEnd': periodEnd.toIso8601String(),
        'tokensUsed': tokensUsed,
        'costAccrued': costAccrued,
        'requestCount': requestCount,
        'tokensByModel': tokensByModel,
      };

  factory AIUsageStats.fromJson(Map<String, dynamic> json) {
    return AIUsageStats(
      periodStart: DateTime.parse(json['periodStart'] as String),
      periodEnd: DateTime.parse(json['periodEnd'] as String),
      tokensUsed: json['tokensUsed'] as int? ?? 0,
      costAccrued: (json['costAccrued'] as num?)?.toDouble() ?? 0.0,
      requestCount: json['requestCount'] as int? ?? 0,
      tokensByModel: (json['tokensByModel'] as Map<String, dynamic>?)?.cast<String, int>() ?? {},
    );
  }

  void recordRequest(String modelId, int tokensUsed, double cost) {
    this.tokensUsed += tokensUsed;
    costAccrued += cost;
    requestCount++;
    tokensByModel[modelId] = (tokensByModel[modelId] ?? 0) + tokensUsed;
  }
}
