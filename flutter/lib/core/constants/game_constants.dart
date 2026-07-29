class GameConstants {
  static const int virtualWidth = 1280;
  static const int virtualHeight = 720;

  static const int maxWeek = 17;
  static const int actsCount = 3;

  static const int maxStat = 20;
  static const int minStat = 1;
  static const int baseStat = 5;

  static const int maxResource = 100;
  static const int startingGold = 50;
  static const int startingEnergy = 100;
  static const int startingSanity = 100;

  static const int energyRecoverPerWeek = 50;
  static const int sanityRecoverPerWeek = 10;

  static const double combatEnemyDelay = 0.8;

  static const int maxDialogueChoices = 3;

  static const List<String> statNames = [
    'logic',
    'creativity',
    'endurance',
    'social',
    'coding',
  ];

  static const Map<String, String> statLabels = {
    'logic': 'Logique',
    'creativity': 'Creativite',
    'endurance': 'Endurance Mentale',
    'social': 'Social',
    'coding': 'Code',
  };

  static const List<String> partyIds = [
    'not_a_genius',
    'laurencium',
    'king',
    'arsene',
  ];

  static const List<String> actColors = [
    'green',
    'gold',
    'red',
  ];
}
