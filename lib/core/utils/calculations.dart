// File: lib/core/utils/calculations.dart
import 'dart:math';
import '../../models/user_profile_model.dart';

class AppCalculations {

  static void processDailyCheckIn({
    required UserProfile profile,
    required int scaleFinancial,
    required int scaleHealth,
    required int scaleSocial,
    required int scalePurpose,
    required bool isBadHabitAvoided,
    required String badHabitType,
  }) {
    int addedFinancial = scaleFinancial * 4;
    int addedHealth = scaleHealth * 4;
    int addedSocial = scaleSocial * 4;
    int addedPurpose = scalePurpose * 4;

    if (isBadHabitAvoided) {
      addedFinancial += 10;
      addedHealth += 10;

      profile.totalMoneySaved += profile.dailySavings;

      switch (badHabitType.toLowerCase()) {
        case 'coffee':
        case 'boba':
          profile.avoidedSugarGrams += 25;
          profile.avoidedCalories += 300;
          break;
        case 'cigarette':
        case 'vape':
          profile.avoidedNicotineSticks += 10;
          break;
        case 'junkfood':
          profile.avoidedCalories += 500;
          break;
        case 'impulse':
          profile.avoidedImpulseItems += 1;
          break;
      }
    }

    profile.expFinancial += addedFinancial;
    profile.expHealth += addedHealth;
    profile.expSocial += addedSocial;
    profile.expPurpose += addedPurpose;

    profile.totalExp += (addedFinancial + addedHealth + addedSocial + addedPurpose);
  }


  static double calculateEstimatedFunds(int currentAge, int retirementAge, int currentTotalSaved) {
    int yearsToRetire = retirementAge - currentAge;
    if (yearsToRetire <= 0) return currentTotalSaved.toDouble();

    double rate = 0.06; // 6%
    int n = 12;

    double amount = (currentTotalSaved * pow((1 + (rate / n)), n * yearsToRetire)).toDouble();

    return amount;
  }
  static void checkAndResetWeeklyData(UserProfile profile) {
    DateTime now = DateTime.now();

    if (profile.lastWeeklyReset == null) {
      profile.lastWeeklyReset = now;
      return;
    }

    Duration difference = now.difference(profile.lastWeeklyReset!);

    if (difference.inDays >= 7) {
      profile.weeklyExpFinancial = 0;
      profile.weeklyExpHealth = 0;
      profile.weeklyExpSocial = 0;
      profile.weeklyExpPurpose = 0;
      profile.weeklyTotalExp = 0;
      profile.weeklyTotalMoneySaved = 0;

      profile.lastWeeklyReset = now;
    }
  }
}