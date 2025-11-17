class Background {
  String id;
  String name;
  String description;
  List<String> skillProficiencies;
  List<String> toolProficiencies;
  List<String> languages;
  String feature;
  String featureDescription;
  List<String> suggestedCharacteristics;

  Background({
    required this.id,
    required this.name,
    required this.description,
    required this.skillProficiencies,
    required this.toolProficiencies,
    required this.languages,
    required this.feature,
    required this.featureDescription,
    required this.suggestedCharacteristics,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'skillProficiencies': skillProficiencies,
    'toolProficiencies': toolProficiencies,
    'languages': languages,
    'feature': feature,
    'featureDescription': featureDescription,
    'suggestedCharacteristics': suggestedCharacteristics,
  };

  factory Background.fromJson(Map<String, dynamic> json) => Background(
    id: json['id'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
    skillProficiencies: (json['skillProficiencies'] as List<dynamic>).cast<String>(),
    toolProficiencies: (json['toolProficiencies'] as List<dynamic>).cast<String>(),
    languages: (json['languages'] as List<dynamic>).cast<String>(),
    feature: json['feature'] as String,
    featureDescription: json['featureDescription'] as String,
    suggestedCharacteristics: (json['suggestedCharacteristics'] as List<dynamic>).cast<String>(),
  );
}

class Backgrounds {
  static Background soldier() => Background(
    id: 'soldier',
    name: 'Soldier',
    description: 'You have a military background, trained in combat and warfare.',
    skillProficiencies: ['Athletics', 'Intimidation'],
    toolProficiencies: ['Gaming set'],
    languages: [],
    feature: 'Military Rank',
    featureDescription: 'You have a military rank from your career. Soldiers loyal to your former organization still recognize your authority.',
    suggestedCharacteristics: [
      'I\'m always polite and respectful.',
      'I\'m haunted by memories of war.',
      'I\'ve lost too many friends, and I\'m slow to make new ones.',
      'I can stare down a hell hound without flinching.',
    ],
  );

  static Background folkHero() => Background(
    id: 'folk_hero',
    name: 'Folk Hero',
    description: 'You came from humble origins, but you\'re destined for so much more.',
    skillProficiencies: ['Animal Handling', 'Survival'],
    toolProficiencies: ['Artisan\'s tools'],
    languages: [],
    feature: 'Rustic Hospitality',
    featureDescription: 'Common folk will shelter you and help you, seeing you as their champion.',
    suggestedCharacteristics: [
      'I judge people by their actions, not their words.',
      'Thinking is for other people. I prefer action.',
      'I have a crude sense of humor.',
      'I face problems head-on.',
    ],
  );

  static Background criminal() => Background(
    id: 'criminal',
    name: 'Criminal',
    description: 'You have a history of breaking the law.',
    skillProficiencies: ['Deception', 'Stealth'],
    toolProficiencies: ['Thieves\' tools', 'Gaming set'],
    languages: [],
    feature: 'Criminal Contact',
    featureDescription: 'You have a reliable contact in the criminal underworld who acts as your liaison.',
    suggestedCharacteristics: [
      'I always have a plan for what to do when things go wrong.',
      'I am incredibly slow to trust.',
      'I don\'t pay attention to the risks in a situation.',
      'The best way to get me to do something is to tell me I can\'t.',
    ],
  );

  static Background acolyte() => Background(
    id: 'acolyte',
    name: 'Acolyte',
    description: 'You have spent your life in service to a temple.',
    skillProficiencies: ['Insight', 'Religion'],
    toolProficiencies: [],
    languages: ['Two of your choice'],
    feature: 'Shelter of the Faithful',
    featureDescription: 'You can receive free healing and care at temples of your faith. Those who share your religion will support you.',
    suggestedCharacteristics: [
      'I idolize a particular hero of my faith.',
      'I can find common ground between the fiercest enemies.',
      'I see omens in every event and action.',
      'Nothing can shake my optimistic attitude.',
    ],
  );

  static Background noble() => Background(
    id: 'noble',
    name: 'Noble',
    description: 'You were born into a position of privilege and power.',
    skillProficiencies: ['History', 'Persuasion'],
    toolProficiencies: ['Gaming set'],
    languages: ['One of your choice'],
    feature: 'Position of Privilege',
    featureDescription: 'People are inclined to think the best of you. You\'re welcome in high society, and commoners defer to you.',
    suggestedCharacteristics: [
      'My eloquent flattery makes everyone I talk to feel wonderful.',
      'If you do me an injury, I will crush you.',
      'I take great pains to always look my best.',
      'I don\'t like to get my hands dirty.',
    ],
  );

  static Background sage() => Background(
    id: 'sage',
    name: 'Sage',
    description: 'You spent years learning the lore of the multiverse.',
    skillProficiencies: ['Arcana', 'History'],
    toolProficiencies: [],
    languages: ['Two of your choice'],
    feature: 'Researcher',
    featureDescription: 'When you attempt to learn something, you know where to find the information.',
    suggestedCharacteristics: [
      'I use polysyllabic words to convey the impression of erudition.',
      'I\'ve read every book in the world\'s greatest libraries.',
      'I\'m willing to listen to every side of an argument.',
      'I speak without really thinking, invariably insulting others.',
    ],
  );

  static Background outlander() => Background(
    id: 'outlander',
    name: 'Outlander',
    description: 'You grew up in the wilds, far from civilization.',
    skillProficiencies: ['Athletics', 'Survival'],
    toolProficiencies: ['Musical instrument'],
    languages: ['One of your choice'],
    feature: 'Wanderer',
    featureDescription: 'You have excellent memory for maps and geography. You can find food and water for yourself and up to 5 others each day.',
    suggestedCharacteristics: [
      'I\'m driven by wanderlust that led me away from home.',
      'I watch over my friends as if they were a litter of newborn pups.',
      'I once ran twenty-five miles without stopping.',
      'I have a lesson for every situation, drawn from nature.',
    ],
  );

  static Background charlatan() => Background(
    id: 'charlatan',
    name: 'Charlatan',
    description: 'You have always had a way with people.',
    skillProficiencies: ['Deception', 'Sleight of Hand'],
    toolProficiencies: ['Disguise kit', 'Forgery kit'],
    languages: [],
    feature: 'False Identity',
    featureDescription: 'You have created a second identity with documentation, disguises, and acquaintances to support it.',
    suggestedCharacteristics: [
      'I fall in and out of love easily.',
      'I have a joke for every occasion.',
      'Flattery is my preferred trick for getting what I want.',
      'I\'m a born gambler who can\'t resist taking a risk.',
    ],
  );

  static Background entertainer() => Background(
    id: 'entertainer',
    name: 'Entertainer',
    description: 'You thrive in front of an audience.',
    skillProficiencies: ['Acrobatics', 'Performance'],
    toolProficiencies: ['Disguise kit', 'Musical instrument'],
    languages: [],
    feature: 'By Popular Demand',
    featureDescription: 'You can find a place to perform in any town, and receive free lodging and food.',
    suggestedCharacteristics: [
      'I know a story relevant to almost every situation.',
      'Whenever I come to a new place, I collect local rumors.',
      'I\'m a hopeless romantic, always searching for that special someone.',
      'Nobody stays angry at me for long.',
    ],
  );

  static Background guildArtisan() => Background(
    id: 'guild_artisan',
    name: 'Guild Artisan',
    description: 'You are a skilled member of an artisan\'s guild.',
    skillProficiencies: ['Insight', 'Persuasion'],
    toolProficiencies: ['Artisan\'s tools'],
    languages: ['One of your choice'],
    feature: 'Guild Membership',
    featureDescription: 'You can rely on guild connections for lodging and assistance. Your guild will support you if accused of a crime.',
    suggestedCharacteristics: [
      'I believe that anything worth doing is worth doing right.',
      'I\'m a perfectionist who obsesses over every detail.',
      'I\'m always polite and respectful.',
      'I\'m well read and can quote classic texts.',
    ],
  );

  static List<Background> getAllBackgrounds() {
    return [
      soldier(),
      folkHero(),
      criminal(),
      acolyte(),
      noble(),
      sage(),
      outlander(),
      charlatan(),
      entertainer(),
      guildArtisan(),
    ];
  }
}
