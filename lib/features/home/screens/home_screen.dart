import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/custom_popup_dialog.dart';
import '../widgets/daily_checkin_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Variabel Data
  String _userName = "User";
  int _totalExp = 0;
  int _streakDays = 0;

  // Variabel Manajemen Waktu (Daily Lock)
  bool _hasCheckedInToday = false;
  String? _lastCheckInDateStr;

  // Variabel Onboarding (Acuan Kalkulasi)
  int _dailySavings = 0;
  String _guiltyPleasure = "";

  // Variabel Akumulasi (Lifetime Metrics)
  int _totalMoneySaved = 0;
  int _totalSugarAvoided = 0;
  int _totalKcalAvoided = 0;

  // Variabel Kalkulasi Level
  int _currentLevel = 1;
  int _maxExpForCurrentLevel = 300;
  String _avatarImagePath = 'assets/images/avatar_baby.png';

  @override
  void initState() {
    super.initState();
    _loadUserData();

// //cek data
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//       _showDebugDialog();
//     });
  }

  Future<void> _loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _userName = prefs.getString('user_name') ?? "User";
      _totalExp = prefs.getInt('user_total_exp') ?? 0;
      _streakDays = prefs.getInt('user_streak_days') ?? 0;
      _lastCheckInDateStr = prefs.getString('user_last_checkin_date');

      _dailySavings = prefs.getInt('user_daily_savings') ?? 0;
      _guiltyPleasure = prefs.getString('user_habit') ?? "Bad Habit";

      _totalMoneySaved = prefs.getInt('user_total_money_saved') ?? 0;
      _totalSugarAvoided = prefs.getInt('user_total_sugar') ?? 0;
      _totalKcalAvoided = prefs.getInt('user_total_kcal') ?? 0;

      if (_lastCheckInDateStr != null) {
        DateTime lastDate = DateTime.parse(_lastCheckInDateStr!);
        DateTime now = DateTime.now();
        DateTime today = DateTime(now.year, now.month, now.day);
        DateTime lastCheckIn = DateTime(lastDate.year, lastDate.month, lastDate.day);

        int differenceInDays = today.difference(lastCheckIn).inDays;

        if (differenceInDays == 0) {
          _hasCheckedInToday = true;
        } else if (differenceInDays > 1) {
          _streakDays = 0;
          prefs.setInt('user_streak_days', 0);
        }
      }

      _calculateLevelAndAvatar();
    });
  }

  // Fungsi untuk menampilkan isi memori langsung ke layar (Debug)
  Future<void> _showDebugDialog() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    String allData = "";
    for (String key in keys) {
      allData += "$key : ${prefs.get(key)}\n\n";
    }

    if (allData.isEmpty) {
      allData = "Memori kosong! Belum ada data yang tersimpan.";
    }

    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Cek Isi Memori (Debug)"),
          content: SingleChildScrollView(child: Text(allData)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Tutup"),
            )
          ],
        ),
      );
    }
  }

  void _calculateLevelAndAvatar() {
    if (_totalExp <= 300) {
      _currentLevel = 1;
      _maxExpForCurrentLevel = 300;
      _avatarImagePath = 'assets/images/avatar_baby.png';
    } else if (_totalExp <= 1000) {
      _currentLevel = 2;
      _maxExpForCurrentLevel = 1000;
      _avatarImagePath = 'assets/images/avatar_toddler.png';
    } else {
      _currentLevel = 3;
      _maxExpForCurrentLevel = 3000;
      _avatarImagePath = 'assets/images/avatar_adventurer.png';
    }
  }

  void _showPopup(String imagePath, String title, String subtitle) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CustomPopupDialog(
        imagePath: imagePath,
        title: title,
        subtitle: subtitle,
        buttonText: "Continue",
        onButtonPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Future<void> _processCheckInResult(Map<String, dynamic> result) async {
    int financial = result['financial'];
    int health = result['health'];
    int social = result['social'];
    int purpose = result['purpose'];
    bool avoidedBadHabit = result['avoidedBadHabit'];

    int pillarExp = (financial + health + social + purpose) * 4;
    int bonusExp = avoidedBadHabit ? 20 : 0;
    int totalGainedExp = pillarExp + bonusExp;

    int moneySavedToday = 0;
    int sugarAvoidedToday = 0;
    int kcalAvoidedToday = 0;

    if (avoidedBadHabit) {
      moneySavedToday = _dailySavings;
      String habit = _guiltyPleasure.toLowerCase();

      // Penambahan kata 'coffee'
      if (habit.contains('boba') || habit.contains('sugar') || habit.contains('sweet') || habit.contains('coffee')) {
        sugarAvoidedToday = 25;
        kcalAvoidedToday = 300;
      } else if (habit.contains('fast food') || habit.contains('junk food') || habit.contains('snack')) {
        sugarAvoidedToday = 5;
        kcalAvoidedToday = 500;
      } else {
        kcalAvoidedToday = 200;
      }
    }

    int oldLevel = _currentLevel;
    int oldStreak = _streakDays;
    int oldSugar = _totalSugarAvoided;
    int oldKcal = _totalKcalAvoided;
    int oldTotalExp = _totalExp;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _totalExp += totalGainedExp;

      if (!_hasCheckedInToday) {
        if (_streakDays == 0) {
          _streakDays = 1;
        } else {
          _streakDays += 1;
        }
        _hasCheckedInToday = true;
      }

      _totalMoneySaved += moneySavedToday;
      _totalSugarAvoided += sugarAvoidedToday;
      _totalKcalAvoided += kcalAvoidedToday;

      _calculateLevelAndAvatar();
    });

    int newLevel = _currentLevel;
    int newStreak = _streakDays;
    int newSugar = _totalSugarAvoided;
    int newKcal = _totalKcalAvoided;
    int newTotalExp = _totalExp;

    DateTime now = DateTime.now();
    String todayStr = DateTime(now.year, now.month, now.day).toIso8601String();

    // --- PENYIMPANAN DATA UTAMA ---
    await prefs.setString('user_last_checkin_date', todayStr);
    await prefs.setInt('user_total_exp', _totalExp);
    await prefs.setInt('user_streak_days', _streakDays);
    await prefs.setInt('user_total_money_saved', _totalMoneySaved);
    await prefs.setInt('user_total_sugar', _totalSugarAvoided);
    await prefs.setInt('user_total_kcal', _totalKcalAvoided);

    // --- PENYIMPANAN EXP PILAR (DIRAPIKAN) ---
    int oldFin = prefs.getInt('user_exp_financial') ?? 0;
    int oldHealth = prefs.getInt('user_exp_health') ?? 0;
    int oldSocial = prefs.getInt('user_exp_social') ?? 0;
    int oldPurpose = prefs.getInt('user_exp_purpose') ?? 0;

    await prefs.setInt('user_exp_financial', oldFin + (financial * 4));
    await prefs.setInt('user_exp_health', oldHealth + (health * 4));
    await prefs.setInt('user_exp_social', oldSocial + (social * 4));
    await prefs.setInt('user_exp_purpose', oldPurpose + (purpose * 4));

    if (mounted) {
      if (newLevel > oldLevel) {
        _showPopup('assets/images/mascot_levelup.png', "LEVEL UP! 🌟", "You've reached Level $newLevel! Your future self is definitely proud of your consistency today.");
      } else {
        _showPopup('assets/images/mascot_congrats.png', "Congratulations! You earned\n$totalGainedExp exp! 🎉", "Your daily reflection is safely saved. Another step closer to your future self!");
      }

      if (oldStreak < 7 && newStreak >= 7) {
        _showPopup('assets/images/ach_7_days.png', "7 Days Warrior! 🛡️", "Incredible! You checked in for 7 consecutive days.");
      }
      if (oldStreak < 30 && newStreak >= 30) {
        _showPopup('assets/images/ach_30_days.png', "30 Days Champ! 🏆", "A full month of consistency. You are a true champion!");
      }
      if (oldSugar < 25000 && newSugar >= 25000) {
        _showPopup('assets/images/ach_sugar_fighter.png', "Sugar Fighter! 🍬", "You successfully avoided 25,000g of sugar!");
      }
      if (oldKcal < 500000 && newKcal >= 500000) {
        _showPopup('assets/images/ach_calorie_crusher.png', "Calorie Crusher! 🔥", "Half a million calories avoided. Phenomenal work!");
      }
      if (oldTotalExp < 80000 && newTotalExp >= 80000) {
        _showPopup('assets/images/ach_pillar_master.png', "Pillar Master! 🏛️", "You achieved 80,000 EXP across all 4 pillars!");
      }
    }
  }

  Widget _buildAvatarWithOrnaments() {
    List<Widget> stackChildren = [
      Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 40, spreadRadius: 10),
          ],
        ),
      ),
    ];

    if (_currentLevel == 1) {
      stackChildren.addAll([
        Positioned(top: 0, right: -20, child: Transform.rotate(angle: 0.2, child: Image.asset('assets/images/star.png', width: 100))),
        Positioned(bottom: 100, left: -50, child: Transform.rotate(angle: -0.2, child: Image.asset('assets/images/heart.png', width: 150))),
        Image.asset(_avatarImagePath, width: 280, fit: BoxFit.contain),
      ]);
    }
    else if (_currentLevel == 2) {
      stackChildren.addAll([
        Positioned(top: 20, left: -50, child: Image.asset('assets/images/cloud.png', width: 120)),
        Positioned(top: 60, right: -30, child: Transform.rotate(angle: 0.1, child: Image.asset('assets/images/heart.png', width: 80))),
        Image.asset(_avatarImagePath, width: 280, fit: BoxFit.contain),
      ]);
    }
    else {
      stackChildren.addAll([
        Positioned(top: 20, left: -50, child: Transform.rotate(angle: -0.15, child: Image.asset('assets/images/map.png', width: 130))),
        Positioned(top: 80, right: -40, child: Image.asset('assets/images/compass.png', width: 90)),
        Image.asset(_avatarImagePath, width: 280, fit: BoxFit.contain),
      ]);
    }

    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: stackChildren,
    );
  }

  @override
  Widget build(BuildContext context) {
    double progressRatio = _totalExp / _maxExpForCurrentLevel;
    if (progressRatio > 1.0) progressRatio = 1.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.67,
            decoration: const BoxDecoration(
              color: Color(0xFFFFE8D6),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(48),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2F9DB),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Image.asset('assets/images/avatar_baby.png', fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Halo, $_userName! 👋",
                              style: GoogleFonts.fraunces(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF0C1325),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.local_fire_department_rounded,
                                  size: 16,
                                  color: _streakDays > 0 ? const Color(0xFFFF7A00) : Colors.grey.shade400,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "$_streakDays consecutive days",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: _streakDays > 0 ? const Color(0xFF0C1325) : Colors.grey.shade500,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFF7C5BFF).withOpacity(0.3)),
                        ),
                        child: Text(
                          "Level $_currentLevel",
                          style: GoogleFonts.fraunces(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF7C5BFF),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Future Avatar",
                        style: GoogleFonts.fraunces(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0C1325),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "EXP $_totalExp / $_maxExpForCurrentLevel",
                        style: GoogleFonts.fraunces(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        height: 12,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: progressRatio,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF935D),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Center(
                    child: _buildAvatarWithOrnaments(),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onLongPress: () async {
                        final SharedPreferences prefs = await SharedPreferences.getInstance();
                        await prefs.remove('user_last_checkin_date');
                        setState(() {
                          _hasCheckedInToday = false;
                        });
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("DEBUG: Status harian di-reset!")),
                          );
                        }
                      },
                      onPressed: _hasCheckedInToday
                          ? () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Kamu sudah merefleksikan kegiatanmu hari ini. Sampai jumpa besok!"),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                          : () async {
                        final result = await showModalBottomSheet<Map<String, dynamic>>(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => const DailyCheckInSheet(),
                        );

                        if (result != null) {
                          await _processCheckInResult(result);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _hasCheckedInToday ? Colors.grey.shade400 : const Color(0xFF0C1325),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        elevation: _hasCheckedInToday ? 0 : 10,
                        shadowColor: Colors.black.withOpacity(0.2),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.bolt_rounded, color: _hasCheckedInToday ? Colors.grey.shade500 : const Color(0xFFFFC107)),
                          const SizedBox(width: 8),
                          Text(
                            _hasCheckedInToday ? "Future Secured" : "Secure the future",
                            style: GoogleFonts.fraunces(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    "Press once to log your daily activity.",
                    style: GoogleFonts.fraunces(
                      fontSize: 16,
                      color: const Color(0xFF0C1325),
                    ),
                  ),
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ],
      ),
    );
  }
}