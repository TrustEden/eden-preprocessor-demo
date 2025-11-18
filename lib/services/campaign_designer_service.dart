// Campaign Designer Service
// Create, edit, and manage campaigns offline without API costs

import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../models/campaign_template.dart';

class CampaignDesignerService {
  static final CampaignDesignerService _instance = CampaignDesignerService._internal();
  factory CampaignDesignerService() => _instance;
  CampaignDesignerService._internal();

  final Uuid _uuid = const Uuid();
  final List<CampaignTemplate> _campaigns = [];

  Future<void> initialize() async {
    await _loadCampaigns();
    _ensureDefaultCampaigns();
  }

  Future<void> _loadCampaigns() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/custom_campaigns.json');

      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final List<dynamic> jsonList = jsonDecode(jsonString);
        _campaigns.clear();
        _campaigns.addAll(jsonList.map((json) => CampaignTemplate.fromJson(json)));
      }
    } catch (e) {
      print('Error loading campaigns: $e');
    }
  }

  Future<void> _saveCampaigns() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/custom_campaigns.json');

      final jsonList = _campaigns.map((c) => c.toJson()).toList();
      await file.writeAsString(jsonEncode(jsonList));
    } catch (e) {
      print('Error saving campaigns: $e');
    }
  }

  void _ensureDefaultCampaigns() {
    if (_campaigns.isEmpty) {
      _campaigns.addAll(getDefaultCampaigns());
    }
  }

  // Campaign CRUD operations

  CampaignTemplate createCampaign({
    required String name,
    required String description,
    required String theme,
    int recommendedLevel = 1,
  }) {
    final campaign = CampaignTemplate(
      id: _uuid.v4(),
      name: name,
      description: description,
      theme: theme,
      recommendedLevel: recommendedLevel,
    );

    _campaigns.add(campaign);
    _saveCampaigns();

    return campaign;
  }

  void updateCampaign(CampaignTemplate campaign) {
    final index = _campaigns.indexWhere((c) => c.id == campaign.id);
    if (index != -1) {
      _campaigns[index] = campaign;
      _saveCampaigns();
    }
  }

  void deleteCampaign(String campaignId) {
    _campaigns.removeWhere((c) => c.id == campaignId);
    _saveCampaigns();
  }

  CampaignTemplate? getCampaign(String campaignId) {
    try {
      return _campaigns.firstWhere((c) => c.id == campaignId);
    } catch (e) {
      return null;
    }
  }

  List<CampaignTemplate> getAllCampaigns() {
    return List.unmodifiable(_campaigns);
  }

  // Act management

  Act addAct(String campaignId, {
    required String name,
    required String description,
    required int actNumber,
  }) {
    final campaign = getCampaign(campaignId);
    if (campaign == null) throw Exception('Campaign not found');

    final act = Act(
      id: _uuid.v4(),
      name: name,
      description: description,
      actNumber: actNumber,
    );

    campaign.acts.add(act);
    updateCampaign(campaign);

    return act;
  }

  // Location management

  Location addLocation(String campaignId, {
    required String name,
    required String description,
    required String type,
  }) {
    final campaign = getCampaign(campaignId);
    if (campaign == null) throw Exception('Campaign not found');

    final location = Location(
      id: _uuid.v4(),
      name: name,
      description: description,
      type: type,
    );

    campaign.locations.add(location);
    updateCampaign(campaign);

    return location;
  }

  // NPC management

  NPC addNPC(String campaignId, {
    required String name,
    required String description,
    required String race,
    String? characterClass,
    int level = 1,
    String alignment = 'Neutral',
    String personality = '',
    String motivation = '',
  }) {
    final campaign = getCampaign(campaignId);
    if (campaign == null) throw Exception('Campaign not found');

    final npc = NPC(
      id: _uuid.v4(),
      name: name,
      description: description,
      race: race,
      characterClass: characterClass,
      level: level,
      alignment: alignment,
      personality: personality,
      motivation: motivation,
    );

    campaign.npcs.add(npc);
    updateCampaign(campaign);

    return npc;
  }

  // Quest management

  QuestTemplate addQuest(String campaignId, {
    required String name,
    required String description,
    required String type,
    required String giver,
    int recommendedLevel = 1,
  }) {
    final campaign = getCampaign(campaignId);
    if (campaign == null) throw Exception('Campaign not found');

    final quest = QuestTemplate(
      id: _uuid.v4(),
      name: name,
      description: description,
      type: type,
      giver: giver,
      recommendedLevel: recommendedLevel,
    );

    campaign.quests.add(quest);
    updateCampaign(campaign);

    return quest;
  }

  void addQuestObjective(String campaignId, String questId, {
    required String description,
    required String type,
    Map<String, dynamic>? parameters,
    bool optional = false,
  }) {
    final campaign = getCampaign(campaignId);
    if (campaign == null) throw Exception('Campaign not found');

    final quest = campaign.quests.firstWhere((q) => q.id == questId);
    final objective = QuestObjectiveTemplate(
      id: _uuid.v4(),
      description: description,
      type: type,
      parameters: parameters,
      optional: optional,
    );

    quest.objectives.add(objective);
    updateCampaign(campaign);
  }

  // Encounter management

  EncounterTemplate addEncounter(String campaignId, {
    required String name,
    required String description,
    required String type,
    int difficulty = 5,
    List<String>? monsterIds,
    List<int>? monsterCounts,
  }) {
    final campaign = getCampaign(campaignId);
    if (campaign == null) throw Exception('Campaign not found');

    final encounter = EncounterTemplate(
      id: _uuid.v4(),
      name: name,
      description: description,
      type: type,
      difficulty: difficulty,
      monsterIds: monsterIds,
      monsterCounts: monsterCounts,
    );

    campaign.encounters.add(encounter);
    updateCampaign(campaign);

    return encounter;
  }

  // Export/Import

  Future<String> exportCampaign(String campaignId) async {
    final campaign = getCampaign(campaignId);
    if (campaign == null) throw Exception('Campaign not found');

    return jsonEncode(campaign.toJson());
  }

  Future<CampaignTemplate> importCampaign(String jsonString) async {
    final json = jsonDecode(jsonString);
    final campaign = CampaignTemplate.fromJson(json);

    // Assign new ID to avoid conflicts
    campaign.id = _uuid.v4();

    _campaigns.add(campaign);
    await _saveCampaigns();

    return campaign;
  }

  // Templates and generators

  List<CampaignTemplate> getDefaultCampaigns() {
    return [
      _createLostMinesCampaign(),
      _createDragonQueenCampaign(),
      _createCurseStrahdCampaign(),
      _createStormKingCampaign(),
      _createTombAnnihilationCampaign(),
    ];
  }

  CampaignTemplate _createLostMinesCampaign() {
    final campaign = CampaignTemplate(
      id: 'lost-mines-phandelver',
      name: 'Lost Mine of Phandelver',
      description: 'A classic D&D adventure for levels 1-5. Explore the Sword Coast, battle goblins, and uncover ancient mysteries.',
      theme: 'Classic Fantasy',
      recommendedLevel: 1,
    );

    // Act 1: Goblin Arrows
    campaign.acts.add(Act(
      id: 'act1',
      name: 'Goblin Arrows',
      description: 'The party is ambushed by goblins on the Triboar Trail.',
      actNumber: 1,
    ));

    // Locations
    campaign.locations.addAll([
      Location(
        id: 'phandalin',
        name: 'Phandalin',
        description: 'A small frontier town trying to recover from past troubles.',
        type: 'Town',
        features: {
          'Stonehill Inn': 'The local tavern and inn',
          'Lionshield Coster': 'Trading post',
          'Shrine of Luck': 'Temple to Tymora',
        },
      ),
      Location(
        id: 'cragmaw-hideout',
        name: 'Cragmaw Hideout',
        description: 'A goblin lair in a cave near the trail.',
        type: 'Dungeon',
        features: {
          'Kennel': 'Wolves kept by goblins',
          'Goblin Den': 'Main goblin living area',
          'Twin Pools Cave': 'Natural cave with waterfall',
        },
      ),
      Location(
        id: 'redbrand-hideout',
        name: 'Redbrand Hideout',
        description: 'Secret base beneath Tresendar Manor.',
        type: 'Dungeon',
      ),
      Location(
        id: 'wave-echo-cave',
        name: 'Wave Echo Cave',
        description: 'The legendary lost mine, filled with magic and danger.',
        type: 'Dungeon',
      ),
    ]);

    // NPCs
    campaign.npcs.addAll([
      NPC(
        id: 'sildar',
        name: 'Sildar Hallwinter',
        description: 'A human fighter and member of the Lords\' Alliance.',
        race: 'Human',
        characterClass: 'Fighter',
        level: 4,
        alignment: 'Lawful Good',
        personality: 'Loyal, brave, dedicated to justice',
        motivation: 'Find Iarno Albrek and bring peace to Phandalin',
      ),
      NPC(
        id: 'gundren',
        name: 'Gundren Rockseeker',
        description: 'A dwarf prospector who discovered Wave Echo Cave.',
        race: 'Dwarf',
        level: 2,
        alignment: 'Neutral Good',
        personality: 'Enthusiastic, optimistic, stubborn',
        motivation: 'Reclaim Wave Echo Cave and restart the mines',
      ),
      NPC(
        id: 'glasstaff',
        name: 'Iarno "Glasstaff" Albrek',
        description: 'A corrupt wizard leading the Redbrands.',
        race: 'Human',
        characterClass: 'Wizard',
        level: 4,
        alignment: 'Lawful Evil',
        personality: 'Ambitious, cunning, cowardly',
        motivation: 'Gain power and wealth',
      ),
    ]);

    // Quests
    campaign.quests.addAll([
      QuestTemplate(
        id: 'delivery-phandalin',
        name: 'Delivery to Phandalin',
        description: 'Deliver supplies to Barthen\'s Provisions in Phandalin.',
        type: 'main',
        giver: 'gundren',
        recommendedLevel: 1,
      ),
      QuestTemplate(
        id: 'redbrand-menace',
        name: 'The Redbrand Menace',
        description: 'Deal with the Redbrand ruffians terrorizing Phandalin.',
        type: 'main',
        giver: 'townmaster',
        recommendedLevel: 2,
      ),
      QuestTemplate(
        id: 'find-cragmaw-castle',
        name: 'Find Cragmaw Castle',
        description: 'Locate the goblin stronghold and rescue Gundren.',
        type: 'main',
        giver: 'sildar',
        recommendedLevel: 3,
      ),
    ]);

    // Encounters
    campaign.encounters.addAll([
      EncounterTemplate(
        id: 'goblin-ambush',
        name: 'Goblin Ambush',
        description: 'Goblins attack the party on the Triboar Trail.',
        type: 'combat',
        difficulty: 2,
        monsterIds: ['goblin', 'goblin', 'goblin', 'goblin'],
        monsterCounts: [4],
      ),
      EncounterTemplate(
        id: 'bugbear-boss',
        name: 'Klarg the Bugbear',
        description: 'The bugbear leader of Cragmaw Hideout.',
        type: 'combat',
        difficulty: 3,
        monsterIds: ['bugbear', 'goblin'],
        monsterCounts: [1, 2],
      ),
    ]);

    return campaign;
  }

  CampaignTemplate _createDragonQueenCampaign() {
    return CampaignTemplate(
      id: 'hoard-dragon-queen',
      name: 'Hoard of the Dragon Queen',
      description: 'Face the Cult of the Dragon as they seek to free Tiamat. Epic campaign for levels 1-8.',
      theme: 'Epic Fantasy',
      recommendedLevel: 1,
    );
  }

  CampaignTemplate _createCurseStrahdCampaign() {
    return CampaignTemplate(
      id: 'curse-strahd',
      name: 'Curse of Strahd',
      description: 'Gothic horror in the mist-shrouded land of Barovia. Face the vampire lord Strahd von Zarovich.',
      theme: 'Gothic Horror',
      recommendedLevel: 1,
    );
  }

  CampaignTemplate _createStormKingCampaign() {
    return CampaignTemplate(
      id: 'storm-kings-thunder',
      name: 'Storm King\'s Thunder',
      description: 'Giants have emerged to threaten civilization. Restore the ordning and save the Sword Coast.',
      theme: 'Epic Fantasy',
      recommendedLevel: 5,
    );
  }

  CampaignTemplate _createTombAnnihilationCampaign() {
    return CampaignTemplate(
      id: 'tomb-annihilation',
      name: 'Tomb of Annihilation',
      description: 'Explore the jungles of Chult and delve into the deadly Tomb of the Nine Gods.',
      theme: 'Jungle Adventure',
      recommendedLevel: 1,
    );
  }
}
