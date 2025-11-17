import 'party.dart';
import 'quest.dart';
import 'faction.dart';
import 'item.dart';
import '../services/procedural_generation.dart';

enum CampaignStatus {
  planning,
  active,
  onHiatus,
  completed,
}

class GameSession {
  String id;
  int sessionNumber;
  DateTime date;
  int durationMinutes;
  String summary;
  List<String> highlightsAchievements;
  List<String> questsCompleted;
  List<String> npcsEncountered;
  List<String> locationsVisited;
  int experienceAwarded;
  int goldAwarded;
  List<Item> lootAcquired;

  GameSession({
    required this.id,
    required this.sessionNumber,
    required this.date,
    required this.durationMinutes,
    required this.summary,
    List<String>? highlightsAchievements,
    List<String>? questsCompleted,
    List<String>? npcsEncountered,
    List<String>? locationsVisited,
    this.experienceAwarded = 0,
    this.goldAwarded = 0,
    List<Item>? lootAcquired,
  })  : highlightsAchievements = highlightsAchievements ?? [],
        questsCompleted = questsCompleted ?? [],
        npcsEncountered = npcsEncountered ?? [],
        locationsVisited = locationsVisited ?? [],
        lootAcquired = lootAcquired ?? [];

  Map<String, dynamic> toJson() => {
        'id': id,
        'sessionNumber': sessionNumber,
        'date': date.toIso8601String(),
        'durationMinutes': durationMinutes,
        'summary': summary,
        'highlightsAchievements': highlightsAchievements,
        'questsCompleted': questsCompleted,
        'npcsEncountered': npcsEncountered,
        'locationsVisited': locationsVisited,
        'experienceAwarded': experienceAwarded,
        'goldAwarded': goldAwarded,
        'lootAcquired': lootAcquired.map((i) => i.toJson()).toList(),
      };

  factory GameSession.fromJson(Map<String, dynamic> json) => GameSession(
        id: json['id'] as String,
        sessionNumber: json['sessionNumber'] as int,
        date: DateTime.parse(json['date'] as String),
        durationMinutes: json['durationMinutes'] as int,
        summary: json['summary'] as String,
        highlightsAchievements:
            (json['highlightsAchievements'] as List<dynamic>?)?.cast<String>(),
        questsCompleted: (json['questsCompleted'] as List<dynamic>?)?.cast<String>(),
        npcsEncountered: (json['npcsEncountered'] as List<dynamic>?)?.cast<String>(),
        locationsVisited: (json['locationsVisited'] as List<dynamic>?)?.cast<String>(),
        experienceAwarded: json['experienceAwarded'] as int? ?? 0,
        goldAwarded: json['goldAwarded'] as int? ?? 0,
        lootAcquired: (json['lootAcquired'] as List<dynamic>?)
                ?.map((i) => Item.fromJson(i as Map<String, dynamic>))
                .toList() ??
            [],
      );
}

class CampaignTimeline {
  int currentDay;
  String currentSeason; // 'Spring', 'Summer', 'Fall', 'Winter'
  int currentYear;
  Map<int, List<String>> eventsByDay; // day -> events

  CampaignTimeline({
    this.currentDay = 1,
    this.currentSeason = 'Spring',
    this.currentYear = 1,
    Map<int, List<String>>? eventsByDay,
  }) : eventsByDay = eventsByDay ?? {};

  void advanceTime({int days = 1}) {
    currentDay += days;

    // Simple season calculation (90 days per season)
    if (currentDay > 360) {
      currentYear++;
      currentDay = currentDay % 360;
    }

    int dayInYear = currentDay % 360;
    if (dayInYear <= 90) {
      currentSeason = 'Spring';
    } else if (dayInYear <= 180) {
      currentSeason = 'Summer';
    } else if (dayInYear <= 270) {
      currentSeason = 'Fall';
    } else {
      currentSeason = 'Winter';
    }
  }

  void addEvent(String event) {
    eventsByDay.putIfAbsent(currentDay, () => []);
    eventsByDay[currentDay]!.add(event);
  }

  List<String> getEventsForDay(int day) {
    return eventsByDay[day] ?? [];
  }

  String getDateString() {
    return 'Day $currentDay, $currentSeason, Year $currentYear';
  }

  Map<String, dynamic> toJson() => {
        'currentDay': currentDay,
        'currentSeason': currentSeason,
        'currentYear': currentYear,
        'eventsByDay': eventsByDay.map(
          (k, v) => MapEntry(k.toString(), v),
        ),
      };

  factory CampaignTimeline.fromJson(Map<String, dynamic> json) =>
      CampaignTimeline(
        currentDay: json['currentDay'] as int? ?? 1,
        currentSeason: json['currentSeason'] as String? ?? 'Spring',
        currentYear: json['currentYear'] as int? ?? 1,
        eventsByDay: (json['eventsByDay'] as Map<String, dynamic>?)?.map(
          (k, v) => MapEntry(int.parse(k), (v as List<dynamic>).cast<String>()),
        ),
      );
}

class Campaign {
  String id;
  String name;
  String description;
  CampaignStatus status;

  // Campaign world
  String settingName; // "Forgotten Realms", "Custom World", etc.
  String? campaignTheme; // "High Fantasy", "Dark Fantasy", "Sword & Sorcery", etc.

  // Party
  Party? party;

  // World State
  CampaignTimeline timeline;
  FactionReputation? factionReputation;
  Map<String, Faction> factions;

  // NPCs and Locations
  List<NPC> knownNPCs; // All NPCs the party has met
  List<Dungeon> discoveredLocations;
  Map<String, bool> locationStatus; // locationId -> isCleared

  // Quests
  List<Quest> availableQuests;
  List<Quest> activeQuests;
  List<Quest> completedQuests;
  List<Quest> failedQuests;

  // Sessions
  List<GameSession> sessions;
  int currentSessionNumber;

  // Campaign Stats
  int totalCombatEncounters;
  int totalMonstersSlain;
  int totalGoldEarned;
  int totalExperienceEarned;
  int totalQuestsCompleted;
  int totalPlaytimeMinutes;

  // DM Notes
  String? dmNotes;
  List<String>? futurePlotHooks;
  Map<String, dynamic>? customData;

  Campaign({
    required this.id,
    required this.name,
    required this.description,
    this.status = CampaignStatus.planning,
    required this.settingName,
    this.campaignTheme,
    this.party,
    CampaignTimeline? timeline,
    this.factionReputation,
    Map<String, Faction>? factions,
    List<NPC>? knownNPCs,
    List<Dungeon>? discoveredLocations,
    Map<String, bool>? locationStatus,
    List<Quest>? availableQuests,
    List<Quest>? activeQuests,
    List<Quest>? completedQuests,
    List<Quest>? failedQuests,
    List<GameSession>? sessions,
    this.currentSessionNumber = 0,
    this.totalCombatEncounters = 0,
    this.totalMonstersSlain = 0,
    this.totalGoldEarned = 0,
    this.totalExperienceEarned = 0,
    this.totalQuestsCompleted = 0,
    this.totalPlaytimeMinutes = 0,
    this.dmNotes,
    this.futurePlotHooks,
    this.customData,
  })  : timeline = timeline ?? CampaignTimeline(),
        factions = factions ?? {},
        knownNPCs = knownNPCs ?? [],
        discoveredLocations = discoveredLocations ?? [],
        locationStatus = locationStatus ?? {},
        availableQuests = availableQuests ?? [],
        activeQuests = activeQuests ?? [],
        completedQuests = completedQuests ?? [],
        failedQuests = failedQuests ?? [],
        sessions = sessions ?? [];

  // ==================== SESSION MANAGEMENT ====================

  GameSession startNewSession() {
    currentSessionNumber++;
    var session = GameSession(
      id: 'session_${id}_$currentSessionNumber',
      sessionNumber: currentSessionNumber,
      date: DateTime.now(),
      durationMinutes: 0,
      summary: '',
    );
    sessions.add(session);
    return session;
  }

  void endSession(GameSession session, {
    required String summary,
    List<String>? highlights,
    int? durationMinutes,
  }) {
    session.summary = summary;
    if (highlights != null) {
      session.highlightsAchievements.addAll(highlights);
    }
    if (durationMinutes != null) {
      session.durationMinutes = durationMinutes;
      totalPlaytimeMinutes += durationMinutes;
    }

    // Record timeline event
    timeline.addEvent('Session ${session.sessionNumber}: $summary');
  }

  // ==================== QUEST MANAGEMENT ====================

  void addAvailableQuest(Quest quest) {
    if (!availableQuests.any((q) => q.id == quest.id)) {
      availableQuests.add(quest);
    }
  }

  void acceptQuest(String questId) {
    var quest = availableQuests.firstWhere(
      (q) => q.id == questId,
      orElse: () => throw Exception('Quest not found in available quests'),
    );
    quest.status = QuestStatus.active;
    availableQuests.removeWhere((q) => q.id == questId);
    activeQuests.add(quest);

    if (party != null) {
      party!.acceptQuest(quest);
    }

    timeline.addEvent('Quest started: ${quest.name}');
  }

  void completeQuest(String questId) {
    var quest = activeQuests.firstWhere(
      (q) => q.id == questId,
      orElse: () => throw Exception('Quest not found in active quests'),
    );
    quest.completeQuest();

    activeQuests.removeWhere((q) => q.id == questId);
    completedQuests.add(quest);
    totalQuestsCompleted++;

    if (party != null) {
      party!.completeQuest(questId);
    }

    timeline.addEvent('Quest completed: ${quest.name}');

    // Check for follow-up quests
    if (quest.nextQuestId != null) {
      // Generate or unlock next quest
    }
  }

  void failQuest(String questId) {
    var quest = activeQuests.firstWhere(
      (q) => q.id == questId,
      orElse: () => throw Exception('Quest not found in active quests'),
    );
    quest.failQuest();

    activeQuests.removeWhere((q) => q.id == questId);
    failedQuests.add(quest);

    timeline.addEvent('Quest failed: ${quest.name}');
  }

  // ==================== NPC & LOCATION MANAGEMENT ====================

  void addNPC(NPC npc) {
    if (!knownNPCs.any((n) => n.id == npc.id)) {
      knownNPCs.add(npc);
      timeline.addEvent('Met ${npc.name}');
    }
  }

  void discoverLocation(Dungeon location) {
    if (!discoveredLocations.any((l) => l.id == location.id)) {
      discoveredLocations.add(location);
      locationStatus[location.id] = false;
      timeline.addEvent('Discovered ${location.name}');
    }
  }

  void clearLocation(String locationId) {
    locationStatus[locationId] = true;
    timeline.addEvent('Cleared location');
  }

  // ==================== TIME MANAGEMENT ====================

  void advanceTime({int days = 1}) {
    timeline.advanceTime(days: days);

    // Update active quests with time limits
    for (var quest in activeQuests) {
      if (quest.timeLimit != null) {
        quest.advanceTime(days: days);
        if (quest.status == QuestStatus.failed) {
          failQuest(quest.id);
        }
      }
    }
  }

  // ==================== STATISTICS ====================

  int get totalSessions => sessions.length;

  int get averageSessionLength {
    if (sessions.isEmpty) return 0;
    return totalPlaytimeMinutes ~/ sessions.length;
  }

  int get partyLevel => party?.averageLevel ?? 1;

  double get questSuccessRate {
    int total = completedQuests.length + failedQuests.length;
    if (total == 0) return 0;
    return (completedQuests.length / total) * 100;
  }

  // ==================== CAMPAIGN PROGRESSION ====================

  String get progressionStatus {
    if (status == CampaignStatus.completed) {
      return 'Campaign Complete';
    }

    int level = partyLevel;
    if (level <= 4) {
      return 'Local Heroes (Levels 1-4)';
    } else if (level <= 10) {
      return 'Heroes of the Realm (Levels 5-10)';
    } else if (level <= 16) {
      return 'Masters of the Realm (Levels 11-16)';
    } else {
      return 'Masters of the World (Levels 17-20)';
    }
  }

  // ==================== SERIALIZATION ====================

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'status': status.toString(),
        'settingName': settingName,
        'campaignTheme': campaignTheme,
        'party': party?.toJson(),
        'timeline': timeline.toJson(),
        'factionReputation': factionReputation?.toJson(),
        'factions': factions.map((k, v) => MapEntry(k, v.toJson())),
        'knownNPCs': knownNPCs.map((n) => n.toJson()).toList(),
        'discoveredLocations': discoveredLocations.map((l) => l.toJson()).toList(),
        'locationStatus': locationStatus,
        'availableQuests': availableQuests.map((q) => q.toJson()).toList(),
        'activeQuests': activeQuests.map((q) => q.toJson()).toList(),
        'completedQuests': completedQuests.map((q) => q.toJson()).toList(),
        'failedQuests': failedQuests.map((q) => q.toJson()).toList(),
        'sessions': sessions.map((s) => s.toJson()).toList(),
        'currentSessionNumber': currentSessionNumber,
        'totalCombatEncounters': totalCombatEncounters,
        'totalMonstersSlain': totalMonstersSlain,
        'totalGoldEarned': totalGoldEarned,
        'totalExperienceEarned': totalExperienceEarned,
        'totalQuestsCompleted': totalQuestsCompleted,
        'totalPlaytimeMinutes': totalPlaytimeMinutes,
        'dmNotes': dmNotes,
        'futurePlotHooks': futurePlotHooks,
        'customData': customData,
      };

  factory Campaign.fromJson(Map<String, dynamic> json) => Campaign(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        status: CampaignStatus.values.firstWhere(
          (s) => s.toString() == json['status'],
          orElse: () => CampaignStatus.planning,
        ),
        settingName: json['settingName'] as String,
        campaignTheme: json['campaignTheme'] as String?,
        party: json['party'] != null
            ? Party.fromJson(json['party'] as Map<String, dynamic>)
            : null,
        timeline: json['timeline'] != null
            ? CampaignTimeline.fromJson(json['timeline'] as Map<String, dynamic>)
            : null,
        factionReputation: json['factionReputation'] != null
            ? FactionReputation.fromJson(
                json['factionReputation'] as Map<String, dynamic>)
            : null,
        factions: (json['factions'] as Map<String, dynamic>?)?.map(
          (k, v) => MapEntry(k, Faction.fromJson(v as Map<String, dynamic>)),
        ),
        knownNPCs: (json['knownNPCs'] as List<dynamic>?)
            ?.map((n) => NPC.fromJson(n as Map<String, dynamic>))
            .toList(),
        discoveredLocations: (json['discoveredLocations'] as List<dynamic>?)
            ?.map((l) => Dungeon.fromJson(l as Map<String, dynamic>))
            .toList(),
        locationStatus:
            (json['locationStatus'] as Map<String, dynamic>?)?.cast<String, bool>(),
        availableQuests: (json['availableQuests'] as List<dynamic>?)
            ?.map((q) => Quest.fromJson(q as Map<String, dynamic>))
            .toList(),
        activeQuests: (json['activeQuests'] as List<dynamic>?)
            ?.map((q) => Quest.fromJson(q as Map<String, dynamic>))
            .toList(),
        completedQuests: (json['completedQuests'] as List<dynamic>?)
            ?.map((q) => Quest.fromJson(q as Map<String, dynamic>))
            .toList(),
        failedQuests: (json['failedQuests'] as List<dynamic>?)
            ?.map((q) => Quest.fromJson(q as Map<String, dynamic>))
            .toList(),
        sessions: (json['sessions'] as List<dynamic>?)
            ?.map((s) => GameSession.fromJson(s as Map<String, dynamic>))
            .toList(),
        currentSessionNumber: json['currentSessionNumber'] as int? ?? 0,
        totalCombatEncounters: json['totalCombatEncounters'] as int? ?? 0,
        totalMonstersSlain: json['totalMonstersSlain'] as int? ?? 0,
        totalGoldEarned: json['totalGoldEarned'] as int? ?? 0,
        totalExperienceEarned: json['totalExperienceEarned'] as int? ?? 0,
        totalQuestsCompleted: json['totalQuestsCompleted'] as int? ?? 0,
        totalPlaytimeMinutes: json['totalPlaytimeMinutes'] as int? ?? 0,
        dmNotes: json['dmNotes'] as String?,
        futurePlotHooks: (json['futurePlotHooks'] as List<dynamic>?)?.cast<String>(),
        customData: json['customData'] as Map<String, dynamic>?,
      );
}
