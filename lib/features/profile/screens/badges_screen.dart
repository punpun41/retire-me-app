import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BadgesScreen extends StatefulWidget {
  const BadgesScreen({super.key});

  @override
  State<BadgesScreen> createState() => _BadgesScreenState();
}

class _BadgesScreenState extends State<BadgesScreen> {
  List<String> _unlockedBadges = [];
  int _sugarAvoided = 0, _kcalAvoided = 0, _nicotineAvoided = 0, _waterAdded = 0;
  int _streakDays = 0, _totalExp = 0;

  @override
  void initState() {
    super.initState();
    _loadBadgesData();
  }

  Future<void> _loadBadgesData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _unlockedBadges = prefs.getStringList('unlocked_badges') ?? [];
      _sugarAvoided = prefs.getInt('user_total_sugar') ?? 0;
      _kcalAvoided = prefs.getInt('user_total_kcal') ?? 0;
      _nicotineAvoided = prefs.getInt('user_avoided_nicotine') ?? 0;
      _waterAdded = prefs.getInt('user_total_water') ?? 0;
      _streakDays = prefs.getInt('user_streak_days') ?? 0;
      _totalExp = prefs.getInt('user_total_exp') ?? 0;

      bool isChanged = false;
      if (_sugarAvoided >= 25000 && !_unlockedBadges.contains('sugar')) { _unlockedBadges.add('sugar'); isChanged = true; }
      if (_kcalAvoided >= 500000 && !_unlockedBadges.contains('calorie')) { _unlockedBadges.add('calorie'); isChanged = true; }
      if (_nicotineAvoided >= 1000 && !_unlockedBadges.contains('smoke')) { _unlockedBadges.add('smoke'); isChanged = true; }
      if (_streakDays >= 7 && !_unlockedBadges.contains('7days')) { _unlockedBadges.add('7days'); isChanged = true; }
      if (_waterAdded >= 5 && !_unlockedBadges.contains('water')) { _unlockedBadges.add('water'); isChanged = true; }
      if (_streakDays >= 30 && !_unlockedBadges.contains('30days')) { _unlockedBadges.add('30days'); isChanged = true; }
      if (_totalExp >= 80000 && !_unlockedBadges.contains('pillar')) { _unlockedBadges.add('pillar'); isChanged = true; }

      if (isChanged) prefs.setStringList('unlocked_badges', _unlockedBadges);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: const BoxDecoration(color: Color(0xFFFF935D), shape: BoxShape.circle),
              child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
            ),
          ),
        ),
        title: Text("Badges", style: GoogleFonts.fraunces(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF0C1325))),
        centerTitle: true,
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(24),
        crossAxisCount: 3,
        childAspectRatio: 0.65,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
        children: [
          _buildBadgeItem('sugar', 'assets/images/ach_sugar_fighter.png', 'Sugar Fighter', 'Avoid 25k g sugar', '${_sugarAvoided ~/ 1000}kg / 25kg', const Color(0xFFFF935D)),
          _buildBadgeItem('calorie', 'assets/images/ach_calorie_crusher.png', 'Calorie Crusher', 'Avoid 500k calories', '${_kcalAvoided ~/ 1000}k / 500k', const Color(0xFFFF935D)),
          _buildBadgeItem('smoke', 'assets/images/ach_smoke_free.png', 'Smoke-Free Hero', 'Avoid 1k nicotine sticks', '${_nicotineAvoided} / 1k', const Color(0xFFFF935D)),
          _buildBadgeItem('7days', 'assets/images/ach_7_days.png', '7 Days Warrior', 'Check in for 7 days', '$_streakDays / 7 days', const Color(0xFFFF935D)),
          _buildBadgeItem('water', 'assets/images/ach_hydration_hero.png', 'Hydration Hero', 'Drink 5 Liter water', '$_waterAdded / 5 Liter', const Color(0xFFFF935D)),
          _buildBadgeItem('30days', 'assets/images/ach_30_days.png', '30 Days Champ', 'Check in for 30 days', '$_streakDays / 30 days', Colors.grey.shade400),
          _buildBadgeItem('financial', 'assets/images/ach_financial_grower.png', 'Financial Grower', 'Invest for 30 days', '$_streakDays / 30 days', Colors.grey.shade400),
          _buildBadgeItem('pillar', 'assets/images/ach_pillar_master.png', 'Pillar Master', 'Achieve 80k exp total', '${_totalExp ~/ 1000}k / 80k', Colors.grey.shade400),
        ],
      ),
    );
  }

  Widget _buildBadgeItem(String id, String imagePath, String title, String desc, String progress, Color progressColor) {
    bool isUnlocked = _unlockedBadges.contains(id);

    Widget badgeImage = SizedBox(
      height: isUnlocked ? 65 : 45,
      child: Image.asset(imagePath, fit: BoxFit.contain),
    );

    if (!isUnlocked) {
      badgeImage = ColorFiltered(
        colorFilter: const ColorFilter.matrix([
          0.2126, 0.7152, 0.0722, 0, 0,
          0.2126, 0.7152, 0.0722, 0, 0,
          0.2126, 0.7152, 0.0722, 0, 0,
          0, 0, 0, 1, 0,
        ]),
        child: badgeImage,
      );
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Center(child: badgeImage)),
          const SizedBox(height: 8),
          Text(title, textAlign: TextAlign.center, maxLines: 2, style: GoogleFonts.fraunces(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF0C1325))),
          const SizedBox(height: 4),
          Text(desc, textAlign: TextAlign.center, maxLines: 2, style: TextStyle(fontSize: 8, color: Colors.grey.shade600)),
          const SizedBox(height: 4),
          Text(progress, style: GoogleFonts.fraunces(fontSize: 8, fontWeight: FontWeight.bold, color: isUnlocked ? progressColor : Colors.grey.shade400)),
        ],
      ),
    );
  }
}