import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../models/campaign.dart';
import '../models/enhanced_character.dart';
import '../models/party.dart';

/// Campaign export/import formats
enum ExportFormat {
  json,
  compressed, // JSON + gzip compression
  package, // Full campaign package with all assets
}

/// Campaign metadata for sharing
class CampaignMetadata {
  final String version;
  final String exportedBy;
  final DateTime exportedAt;
  final String campaignId;
  final String campaignName;
  final String description;
  final int partyLevel;
  final int sessionsPlayed;
  final List<String> tags;
  final String? imageUrl;
  final double? rating;
  final int? downloads;

  CampaignMetadata({
    required this.version,
    required this.exportedBy,
    DateTime? exportedAt,
    required this.campaignId,
    required this.campaignName,
    required this.description,
    required this.partyLevel,
    required this.sessionsPlayed,
    List<String>? tags,
    this.imageUrl,
    this.rating,
    this.downloads,
  })  : exportedAt = exportedAt ?? DateTime.now(),
        tags = tags ?? [];

  Map<String, dynamic> toJson() => {
        'version': version,
        'exportedBy': exportedBy,
        'exportedAt': exportedAt.toIso8601String(),
        'campaignId': campaignId,
        'campaignName': campaignName,
        'description': description,
        'partyLevel': partyLevel,
        'sessionsPlayed': sessionsPlayed,
        'tags': tags,
        'imageUrl': imageUrl,
        'rating': rating,
        'downloads': downloads,
      };

  factory CampaignMetadata.fromJson(Map<String, dynamic> json) =>
      CampaignMetadata(
        version: json['version'] as String,
        exportedBy: json['exportedBy'] as String,
        exportedAt: DateTime.parse(json['exportedAt'] as String),
        campaignId: json['campaignId'] as String,
        campaignName: json['campaignName'] as String,
        description: json['description'] as String,
        partyLevel: json['partyLevel'] as int,
        sessionsPlayed: json['sessionsPlayed'] as int,
        tags: (json['tags'] as List<dynamic>?)?.cast<String>(),
        imageUrl: json['imageUrl'] as String?,
        rating: (json['rating'] as num?)?.toDouble(),
        downloads: json['downloads'] as int?,
      );

  factory CampaignMetadata.fromCampaign(Campaign campaign,
      {required String exportedBy}) {
    return CampaignMetadata(
      version: '1.0.0',
      exportedBy: exportedBy,
      campaignId: campaign.id,
      campaignName: campaign.name,
      description: campaign.description,
      partyLevel: campaign.partyLevel,
      sessionsPlayed: campaign.totalSessions,
      tags: [
        campaign.settingName,
        if (campaign.campaignTheme != null) campaign.campaignTheme!,
      ],
    );
  }
}

/// Campaign export package
class CampaignPackage {
  final CampaignMetadata metadata;
  final Campaign campaign;
  final List<EnhancedCharacter>? characters;
  final Map<String, dynamic>? additionalData;

  CampaignPackage({
    required this.metadata,
    required this.campaign,
    this.characters,
    this.additionalData,
  });

  Map<String, dynamic> toJson() => {
        'metadata': metadata.toJson(),
        'campaign': campaign.toJson(),
        'characters': characters?.map((c) => c.toJson()).toList(),
        'additionalData': additionalData,
      };

  factory CampaignPackage.fromJson(Map<String, dynamic> json) =>
      CampaignPackage(
        metadata:
            CampaignMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
        campaign: Campaign.fromJson(json['campaign'] as Map<String, dynamic>),
        characters: (json['characters'] as List<dynamic>?)
            ?.map((c) => EnhancedCharacter.fromJson(c as Map<String, dynamic>))
            .toList(),
        additionalData: json['additionalData'] as Map<String, dynamic>?,
      );
}

/// Service for exporting and importing campaigns
class CampaignExportService {
  static final CampaignExportService _instance =
      CampaignExportService._internal();
  factory CampaignExportService() => _instance;
  CampaignExportService._internal();

  static const String currentVersion = '1.0.0';

  // ==================== EXPORT ====================

  /// Export a campaign to file
  Future<String?> exportCampaign({
    required Campaign campaign,
    required String exportedBy,
    ExportFormat format = ExportFormat.compressed,
    List<EnhancedCharacter>? includeCharacters,
    bool includeProgress = true,
    bool includeMetadata = true,
  }) async {
    try {
      // Create campaign package
      final metadata = CampaignMetadata.fromCampaign(
        campaign,
        exportedBy: exportedBy,
      );

      Campaign exportCampaign = campaign;
      if (!includeProgress) {
        // Create a copy without progress data
        exportCampaign = _stripProgress(campaign);
      }

      final package = CampaignPackage(
        metadata: metadata,
        campaign: exportCampaign,
        characters: includeCharacters,
      );

      // Get export directory
      final directory = await _getExportDirectory();
      final fileName =
          '${campaign.name.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}';

      String? filePath;

      switch (format) {
        case ExportFormat.json:
          filePath = await _exportAsJson(package, directory, fileName);
          break;
        case ExportFormat.compressed:
          filePath = await _exportAsCompressed(package, directory, fileName);
          break;
        case ExportFormat.package:
          filePath = await _exportAsPackage(package, directory, fileName);
          break;
      }

      return filePath;
    } catch (e) {
      print('Error exporting campaign: $e');
      return null;
    }
  }

  /// Export campaign as JSON file
  Future<String> _exportAsJson(
    CampaignPackage package,
    Directory directory,
    String fileName,
  ) async {
    final file = File('${directory.path}/$fileName.json');
    final jsonString = const JsonEncoder.withIndent('  ').convert(package.toJson());
    await file.writeAsString(jsonString);
    return file.path;
  }

  /// Export campaign as compressed file
  Future<String> _exportAsCompressed(
    CampaignPackage package,
    Directory directory,
    String fileName,
  ) async {
    final jsonString = jsonEncode(package.toJson());
    final bytes = utf8.encode(jsonString);

    // Compress using gzip
    final compressed = GZipEncoder().encode(bytes);

    final file = File('${directory.path}/$fileName.campaign');
    await file.writeAsBytes(compressed!);
    return file.path;
  }

  /// Export campaign as full package with assets
  Future<String> _exportAsPackage(
    CampaignPackage package,
    Directory directory,
    String fileName,
  ) async {
    final archive = Archive();

    // Add campaign data
    final jsonString = jsonEncode(package.toJson());
    final jsonBytes = utf8.encode(jsonString);
    archive.addFile(ArchiveFile('campaign.json', jsonBytes.length, jsonBytes));

    // Add README
    final readme = _generateReadme(package.campaign);
    final readmeBytes = utf8.encode(readme);
    archive.addFile(ArchiveFile('README.md', readmeBytes.length, readmeBytes));

    // TODO: Add character portraits if available
    // TODO: Add custom maps/assets

    // Encode as zip
    final zipEncoder = ZipEncoder();
    final zipBytes = zipEncoder.encode(archive);

    final file = File('${directory.path}/$fileName.campaignpack');
    await file.writeAsBytes(zipBytes!);
    return file.path;
  }

  /// Export campaign for sharing (user selects location)
  Future<String?> exportCampaignWithDialog({
    required Campaign campaign,
    required String exportedBy,
    ExportFormat format = ExportFormat.compressed,
    List<EnhancedCharacter>? includeCharacters,
  }) async {
    try {
      // Let user select save location
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
      if (selectedDirectory == null) return null;

      final metadata = CampaignMetadata.fromCampaign(
        campaign,
        exportedBy: exportedBy,
      );

      final package = CampaignPackage(
        metadata: metadata,
        campaign: campaign,
        characters: includeCharacters,
      );

      final fileName =
          '${campaign.name.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}';
      final directory = Directory(selectedDirectory);

      String? filePath;
      switch (format) {
        case ExportFormat.json:
          filePath = await _exportAsJson(package, directory, fileName);
          break;
        case ExportFormat.compressed:
          filePath = await _exportAsCompressed(package, directory, fileName);
          break;
        case ExportFormat.package:
          filePath = await _exportAsPackage(package, directory, fileName);
          break;
      }

      return filePath;
    } catch (e) {
      print('Error exporting campaign with dialog: $e');
      return null;
    }
  }

  // ==================== IMPORT ====================

  /// Import a campaign from file
  Future<CampaignPackage?> importCampaign(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('File not found: $filePath');
      }

      final extension = filePath.split('.').last;

      switch (extension) {
        case 'json':
          return await _importFromJson(file);
        case 'campaign':
          return await _importFromCompressed(file);
        case 'campaignpack':
          return await _importFromPackage(file);
        default:
          throw Exception('Unsupported file format: $extension');
      }
    } catch (e) {
      print('Error importing campaign: $e');
      return null;
    }
  }

  /// Import campaign with file picker dialog
  Future<CampaignPackage?> importCampaignWithDialog() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json', 'campaign', 'campaignpack'],
      );

      if (result == null || result.files.isEmpty) return null;

      String filePath = result.files.first.path!;
      return await importCampaign(filePath);
    } catch (e) {
      print('Error importing campaign with dialog: $e');
      return null;
    }
  }

  Future<CampaignPackage> _importFromJson(File file) async {
    final jsonString = await file.readAsString();
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return CampaignPackage.fromJson(json);
  }

  Future<CampaignPackage> _importFromCompressed(File file) async {
    final compressed = await file.readAsBytes();
    final decompressed = GZipDecoder().decodeBytes(compressed);
    final jsonString = utf8.decode(decompressed);
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return CampaignPackage.fromJson(json);
  }

  Future<CampaignPackage> _importFromPackage(File file) async {
    final zipBytes = await file.readAsBytes();
    final archive = ZipDecoder().decodeBytes(zipBytes);

    // Find campaign.json in archive
    final campaignFile =
        archive.files.firstWhere((f) => f.name == 'campaign.json');
    final jsonBytes = campaignFile.content as List<int>;
    final jsonString = utf8.decode(jsonBytes);
    final json = jsonDecode(jsonString) as Map<String, dynamic>;

    return CampaignPackage.fromJson(json);
  }

  // ==================== VALIDATION ====================

  /// Validate an imported campaign
  Future<ValidationResult> validateCampaign(CampaignPackage package) async {
    List<String> errors = [];
    List<String> warnings = [];

    // Check version compatibility
    if (!_isVersionCompatible(package.metadata.version)) {
      errors.add(
          'Incompatible version: ${package.metadata.version}. Current version: $currentVersion');
    }

    // Validate campaign data
    if (package.campaign.name.isEmpty) {
      errors.add('Campaign name is empty');
    }

    if (package.campaign.party == null) {
      warnings.add('Campaign has no party');
    }

    // Validate characters if included
    if (package.characters != null) {
      for (var character in package.characters!) {
        if (character.name.isEmpty) {
          errors.add('Character with ID ${character.id} has no name');
        }
        if (character.level < 1 || character.level > 20) {
          errors.add(
              'Character ${character.name} has invalid level: ${character.level}');
        }
      }
    }

    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      warnings: warnings,
    );
  }

  bool _isVersionCompatible(String version) {
    // Simple version check - in production would parse and compare versions
    final parts = version.split('.');
    final currentParts = currentVersion.split('.');

    // Major version must match
    return parts[0] == currentParts[0];
  }

  // ==================== UTILITIES ====================

  /// Strip progress data from campaign for template export
  Campaign _stripProgress(Campaign campaign) {
    // Create a new campaign with same structure but no progress
    return Campaign(
      id: campaign.id,
      name: campaign.name,
      description: campaign.description,
      status: CampaignStatus.planning,
      settingName: campaign.settingName,
      campaignTheme: campaign.campaignTheme,
      // Keep party structure but reset progress
      party: campaign.party != null
          ? Party(
              id: campaign.party!.id,
              name: campaign.party!.name,
              leader: campaign.party!.leader,
            )
          : null,
      // Keep world structure but no discovered locations
      factions: campaign.factions,
      // No progress data
      availableQuests: [],
      activeQuests: [],
      completedQuests: [],
      failedQuests: [],
      sessions: [],
      knownNPCs: [],
      discoveredLocations: [],
      dmNotes: campaign.dmNotes,
      futurePlotHooks: campaign.futurePlotHooks,
    );
  }

  /// Generate README for campaign package
  String _generateReadme(Campaign campaign) {
    return '''
# ${campaign.name}

${campaign.description}

## Campaign Information

- **Setting**: ${campaign.settingName}
- **Theme**: ${campaign.campaignTheme ?? 'N/A'}
- **Status**: ${campaign.status}
- **Party Level**: ${campaign.partyLevel}
- **Sessions Played**: ${campaign.totalSessions}

## Import Instructions

1. Open the AI Dungeon Master application
2. Go to Campaign Management
3. Select "Import Campaign"
4. Choose this campaign package file
5. Follow the import wizard to complete setup

## Additional Notes

${campaign.dmNotes ?? 'No additional notes'}

---

*Exported on ${DateTime.now().toString()}*
''';
  }

  /// Get export directory
  Future<Directory> _getExportDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final exportDir = Directory('${appDir.path}/campaign_exports');

    if (!await exportDir.exists()) {
      await exportDir.create(recursive: true);
    }

    return exportDir;
  }

  /// Get list of exported campaigns
  Future<List<FileSystemEntity>> getExportedCampaigns() async {
    final exportDir = await _getExportDirectory();
    return exportDir.listSync();
  }

  /// Delete exported campaign file
  Future<bool> deleteExportedCampaign(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      print('Error deleting exported campaign: $e');
      return false;
    }
  }
}

/// Validation result
class ValidationResult {
  final bool isValid;
  final List<String> errors;
  final List<String> warnings;

  ValidationResult({
    required this.isValid,
    required this.errors,
    required this.warnings,
  });

  bool get hasWarnings => warnings.isNotEmpty;
  bool get hasErrors => errors.isNotEmpty;
}
