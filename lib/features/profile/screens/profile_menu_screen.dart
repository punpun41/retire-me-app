import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../onboarding/screens/splash_screen.dart';
import 'badges_screen.dart';
import 'retirement_target_screen.dart';
import 'guilty_pleasure_screen.dart';

class ProfileMenuScreen extends StatefulWidget {
  const ProfileMenuScreen({super.key});

  @override
  State<ProfileMenuScreen> createState() => _ProfileMenuScreenState();
}

class _ProfileMenuScreenState extends State<ProfileMenuScreen> {
  String _userName = "User";
  int _currentAge = 22;
  int _retirementAge = 42;
  int _currentLevel = 2;
  String _avatarImagePath = 'assets/images/avatar_toddler.png';

  List<Map<String, dynamic>> _displayBadges = [];

  final List<Map<String, String>> _allBadges = [
    {'id': 'sugar', 'image': 'assets/images/ach_sugar_fighter.png', 'title': 'Sugar Fighter', 'subtitle': 'Avoid 25k g sugar'},
    {'id': 'calorie', 'image': 'assets/images/ach_calorie_crusher.png', 'title': 'Calorie Crusher', 'subtitle': 'Avoid 500k kcal'},
    {'id': 'smoke', 'image': 'assets/images/ach_smoke_free.png', 'title': 'Smoke-Free', 'subtitle': 'Avoid 1k sticks'},
    {'id': '7days', 'image': 'assets/images/ach_7_days.png', 'title': '7 Days Warrior', 'subtitle': '7 consecutive days'},
    {'id': 'water', 'image': 'assets/images/ach_hydration_hero.png', 'title': 'Hydration Hero', 'subtitle': 'Drink 5 Liter water'},
    {'id': '30days', 'image': 'assets/images/ach_30_days.png', 'title': '30 Days Champ', 'subtitle': '30 consecutive days'},
    {'id': 'financial', 'image': 'assets/images/ach_financial_grower.png', 'title': 'Financial Grower', 'subtitle': 'Invest for 30 days'},
    {'id': 'pillar', 'image': 'assets/images/ach_pillar_master.png', 'title': 'Pillar Master', 'subtitle': '80,000 exp total'},
  ];

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> unlockedIds = prefs.getStringList('unlocked_badges') ?? [];
    bool isBadgeUpdated = false;

    int sugar = prefs.getInt('user_total_sugar') ?? 0;
    int kcal = prefs.getInt('user_total_kcal') ?? 0;
    int nic = prefs.getInt('user_avoided_nicotine') ?? 0;
    int water = prefs.getInt('user_total_water') ?? 0;
    int streak = prefs.getInt('user_streak_days') ?? 0;
    int exp = prefs.getInt('user_total_exp') ?? 0;

    if (sugar >= 25000 && !unlockedIds.contains('sugar')) { unlockedIds.add('sugar'); isBadgeUpdated = true; }
    if (kcal >= 500000 && !unlockedIds.contains('calorie')) { unlockedIds.add('calorie'); isBadgeUpdated = true; }
    if (nic >= 1000 && !unlockedIds.contains('smoke')) { unlockedIds.add('smoke'); isBadgeUpdated = true; }
    if (streak >= 7 && !unlockedIds.contains('7days')) { unlockedIds.add('7days'); isBadgeUpdated = true; }
    if (water >= 5 && !unlockedIds.contains('water')) { unlockedIds.add('water'); isBadgeUpdated = true; }
    if (streak >= 30 && !unlockedIds.contains('30days')) { unlockedIds.add('30days'); isBadgeUpdated = true; }
    if (exp >= 80000 && !unlockedIds.contains('pillar')) { unlockedIds.add('pillar'); isBadgeUpdated = true; }

    if (isBadgeUpdated) {
      await prefs.setStringList('unlocked_badges', unlockedIds);
    }

    List<Map<String, dynamic>> selectedBadges = [];
    List<Map<String, String>> unlockedList = _allBadges.where((b) => unlockedIds.contains(b['id'])).toList();
    unlockedList.shuffle(Random());

    for (var b in unlockedList) {
      if (selectedBadges.length < 3) selectedBadges.add({...b, 'isUnlocked': true});
    }

    if (selectedBadges.length < 3) {
      List<Map<String, String>> lockedList = _allBadges.where((b) => !unlockedIds.contains(b['id'])).toList();
      lockedList.shuffle(Random());
      for (var b in lockedList) {
        if (selectedBadges.length < 3) selectedBadges.add({...b, 'isUnlocked': false});
      }
    }

    setState(() {
      _userName = prefs.getString('user_name') ?? "Rea";
      _currentAge = prefs.getInt('user_current_age') ?? 22;
      _retirementAge = prefs.getInt('user_retirement_age') ?? 42;
      _currentLevel = prefs.getInt('user_current_level') ?? 2;
      _displayBadges = selectedBadges;

      if (_currentLevel == 1) _avatarImagePath = 'assets/images/avatar_baby.png';
      else if (_currentLevel == 2) _avatarImagePath = 'assets/images/avatar_toddler.png';
      else _avatarImagePath = 'assets/images/avatar_adventurer.png';
    });
  }

  Widget _bubble(double size, Color color, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(opacity),
      ),
    );
  }

  void _showResetConfirmationDialog() {
    const Color purple = Color(0xFF7C5BFF);
    const Color darkNavy = Color(0xFF0C1325);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF6F3FF),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x1A000000),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(top: -30, left: -35, child: _bubble(90, purple, 0.05)),
                    Positioned(top: -10, right: -30, child: _bubble(65, purple, 0.10)),
                    Positioned(top: 45, left: 8, child: _bubble(18, purple, 0.12)),
                    Positioned(top: 120, right: 6, child: _bubble(26, purple, 0.16)),
                    Positioned(bottom: 100, left: -28, child: _bubble(50, purple, 0.08)),
                    Positioned(bottom: 75, right: 26, child: _bubble(15, purple, 0.18)),
                    Positioned(bottom: -55, right: -50, child: _bubble(95, purple, 0.06)),
                    Positioned(bottom: -20, left: -20, child: _bubble(48, purple, 0.07)),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset('assets/images/reset.png', height: 108, fit: BoxFit.contain),
                          const SizedBox(height: 14),
                          Text(
                            "RESET YOUR DATA? 🥺",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.fraunces(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                              color: darkNavy,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Your progress, badges, and daily check-ins will be deleted and cannot be undone.",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.fraunces(fontSize: 14, height: 1.4),
                          ),
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 46,
                                  child: OutlinedButton(
                                    onPressed: () async {
                                      final prefs = await SharedPreferences.getInstance();
                                      await prefs.clear();

                                      if (mounted) {
                                        Navigator.pop(context);
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(builder: (context) => const SplashScreen()),
                                              (route) => false,
                                        );
                                      }
                                    },
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      side: const BorderSide(color: Colors.grey, width: 1),
                                      padding: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                    ),
                                    child: Text("Yes, reset", style: GoogleFonts.fraunces(fontSize: 14, fontWeight: FontWeight.bold, color: darkNavy)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: SizedBox(
                                  height: 46,
                                  child: ElevatedButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: darkNavy,
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      padding: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                    ),
                                    child: Text("No, keep it", style: GoogleFonts.fraunces(fontSize: 14, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    int estimateYears = _retirementAge - _currentAge;
    if (estimateYears < 0) estimateYears = 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFFD6),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 8))],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 64, height: 64,
                              decoration: const BoxDecoration(color: Color(0xFFFFB284), shape: BoxShape.circle),
                              child: Padding(padding: const EdgeInsets.all(8.0), child: Image.asset(_avatarImagePath)),
                            ),
                            Positioned(
                              bottom: -4, right: -4,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                child: const Icon(Icons.camera_alt, size: 14, color: Color(0xFF0C1325)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_userName, style: GoogleFonts.fraunces(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF0C1325))),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: const Color(0xFF8F7DF8).withOpacity(0.3)),
                                ),
                                child: Text("Future Traveler", style: GoogleFonts.fraunces(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF8F7DF8))),
                              ),
                              const SizedBox(height: 4),
                              Text("$_userName.profile@email.com", style: GoogleFonts.fraunces(fontSize: 12, color: Colors.grey.shade700)),
                            ],
                          ),
                        ),
                        Image.asset('assets/images/cloud.png', width: 70),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.6), borderRadius: BorderRadius.circular(16)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildHeaderStat(Icons.calendar_today, "Retire target", "$_retirementAge Tahun", const Color(0xFF6EBE71)),
                          Container(width: 1, height: 30, color: Colors.grey.shade300),
                          _buildHeaderStat(Icons.track_changes, "Current age", "$_currentAge Tahun", const Color(0xFF6EBE71)),
                          Container(width: 1, height: 30, color: Colors.grey.shade300),
                          _buildHeaderStat(Icons.show_chart, "Retire estimate", "$estimateYears Tahun", const Color(0xFF6EBE71)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 8))],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset('assets/images/badge.png', width: 22, height: 22),
                            const SizedBox(width: 8),
                            Text("Badges", style: GoogleFonts.fraunces(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF0C1325))),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const BadgesScreen())).then((_) => _loadProfileData());
                          },
                          child: Text("See more", style: TextStyle(fontSize: 12, color: Colors.grey.shade600, decoration: TextDecoration.underline)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (_displayBadges.isNotEmpty)
                      Row(
                        children: [
                          Expanded(child: _buildBadgePreview(_displayBadges[0]['image'], _displayBadges[0]['title'], _displayBadges[0]['subtitle'], _displayBadges[0]['isUnlocked'])),
                          const SizedBox(width: 8),
                          Expanded(child: _buildBadgePreview(_displayBadges[1]['image'], _displayBadges[1]['title'], _displayBadges[1]['subtitle'], _displayBadges[1]['isUnlocked'])),
                          const SizedBox(width: 8),
                          Expanded(child: _buildBadgePreview(_displayBadges[2]['image'], _displayBadges[2]['title'], _displayBadges[2]['subtitle'], _displayBadges[2]['isUnlocked'])),
                        ],
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 8))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.settings_outlined, color: Color(0xFF0C1325)),
                        const SizedBox(width: 8),
                        Text("Settings", style: GoogleFonts.fraunces(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF0C1325))),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade200)),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Container(padding: const EdgeInsets.all(8), decoration: const BoxDecoration(color: Color(0xFFEAF7E2), shape: BoxShape.circle), child: const Icon(Icons.edit, color: Color(0xFF6EBE71), size: 16)),
                            title: Text("Edit retirement target", style: GoogleFonts.fraunces(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF0C1325))),
                            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const RetirementTargetScreen())).then((_) => _loadProfileData());
                            },
                          ),
                          Divider(color: Colors.grey.shade200, height: 1, indent: 16, endIndent: 16),
                          ListTile(
                            leading: Container(padding: const EdgeInsets.all(8), decoration: const BoxDecoration(color: Color(0xFFEAF7E2), shape: BoxShape.circle), child: const Icon(Icons.edit, color: Color(0xFF6EBE71), size: 16)),
                            title: Text("Edit Guilty Pleasure", style: GoogleFonts.fraunces(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF0C1325))),
                            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const GuiltyPleasureScreen())).then((_) => _loadProfileData());
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton.icon(
                        onPressed: _showResetConfirmationDialog,
                        icon: const Icon(Icons.delete_outline, size: 18),
                        label: Text("Reset Data", style: GoogleFonts.fraunces(fontSize: 14, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF5252),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderStat(IconData icon, String title, String value, Color iconColor) {
    return Column(
      children: [
        Icon(icon, color: iconColor, size: 16),
        const SizedBox(height: 4),
        Text(title, style: TextStyle(fontSize: 9, color: Colors.grey.shade600)),
        const SizedBox(height: 2),
        Text(value, style: GoogleFonts.fraunces(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF0C1325))),
      ],
    );
  }

  Widget _buildBadgePreview(String imagePath, String title, String subtitle, bool isUnlocked) {
    Widget badgeImage = SizedBox(
      height: 52,
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
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: badgeImage),
          const SizedBox(height: 8),
          Text(title, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.fraunces(fontSize: 9, fontWeight: FontWeight.bold, color: const Color(0xFF0C1325))),
          const SizedBox(height: 4),
          Text(subtitle, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 7, color: Colors.grey.shade500)),
        ],
      ),
    );
  }
}