
class UserProfile {
  String name;
  String selectedArchetype;
  String selectedGuiltyPleasure;
  int currentAge;
  int retirementAge;
  int dailySavings; // Rp yang dihemat dari Guilty Pleasure
  int totalWaterConsumed;
  int totalExp;

  // EXP Pilar
  int expFinancial;
  int expHealth;
  int expSocial;
  int expPurpose;

  int avoidedSugarGrams;
  int avoidedCalories;
  int avoidedNicotineSticks;
  int avoidedImpulseItems;

  // Uang Hemat Riil (Lifetime)
  int totalMoneySaved;
  List<String> unlockedBadges;


  DateTime? lastWeeklyReset;
  int weeklyExpFinancial;
  int weeklyExpHealth;
  int weeklyExpSocial;
  int weeklyExpPurpose;
  int weeklyTotalExp;
  int weeklyTotalMoneySaved;


  UserProfile({
    required this.name,
    required this.selectedArchetype,
    required this.selectedGuiltyPleasure,
    required this.currentAge,
    required this.retirementAge,
    required this.dailySavings,
    this.totalExp = 0,
    this.expFinancial = 0,
    this.expHealth = 0,
    this.expSocial = 0,
    this.expPurpose = 0,
    this.avoidedSugarGrams = 0,
    this.avoidedCalories = 0,
    this.avoidedNicotineSticks = 0,
    this.avoidedImpulseItems = 0,
    this.totalMoneySaved = 0,
    this.totalWaterConsumed = 0,
    this.unlockedBadges = const [],
    this.lastWeeklyReset,
    this.weeklyExpFinancial = 0,
    this.weeklyExpHealth = 0,
    this.weeklyExpSocial = 0,
    this.weeklyExpPurpose = 0,
    this.weeklyTotalExp = 0,
    this.weeklyTotalMoneySaved = 0,
  });

  String get currentLevelAvatarPath {
    if (totalExp <= 300) return 'assets/images/avatar_baby.png';
    if (totalExp <= 1000) return 'assets/images/avatar_toddler.png';
    return 'assets/images/avatar_adventurer.png';
  }

  int get currentLevelInt {
    if (totalExp <= 300) return 1;
    if (totalExp <= 1000) return 2;
    return 3;
  }
}