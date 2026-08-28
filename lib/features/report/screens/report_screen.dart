import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../home/widgets/custom_popup_dialog.dart';
import '../widgets/mini_mission_card.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> with TickerProviderStateMixin {
  int _weeklyExpFinancial = 0;
  int _weeklyExpHealth = 0;
  int _weeklyExpSocial = 0;
  int _weeklyExpPurpose = 0;
  int _weeklyTotalExp = 0;
  int _weeklyTotalMoneySaved = 0;
  int _currentLevel = 2;

  late TabController _tabController;

  List<bool> _finComp = List.filled(4, false);
  List<bool> _healthComp = List.filled(4, false);
  List<bool> _socialComp = List.filled(4, false);
  List<bool> _purposeComp = List.filled(4, false);

  List<bool> _finSel = List.filled(4, false);
  List<bool> _healthSel = List.filled(4, false);
  List<bool> _socialSel = List.filled(4, false);
  List<bool> _purposeSel = List.filled(4, false);

  final List<Map<String, String>> _finData = [
    {"title": "Cook Your Own Meal", "subtitle": "Prepare a meal at home instead of eating out"},
    {"title": "Track Your Spending", "subtitle": "Record all your expenses today"},
    {"title": "No Impulse Buy", "subtitle": "Avoid buying anything not on your shopping list"},
    {"title": "Read Finance Article", "subtitle": "Learn one new personal finance concept today"},
  ];
  final List<Map<String, String>> _healthData = [
    {"title": "Hydration Check", "subtitle": "Drink 2 liters of water today"},
    {"title": "30 Min Walk", "subtitle": "Take a brisk walk for at least 30 minutes"},
    {"title": "Sugar Free Day", "subtitle": "Consume zero added sugar today"},
    {"title": "Sleep 8 Hours", "subtitle": "Get a full 8 hours of uninterrupted sleep"},
  ];
  final List<Map<String, String>> _socialData = [
    {"title": "Call a Friend", "subtitle": "Check in on someone you care about"},
    {"title": "Compliment Someone", "subtitle": "Give a genuine compliment to someone"},
    {"title": "Group Activity", "subtitle": "Participate in a community event"},
    {"title": "Help a Neighbor", "subtitle": "Offer assistance to someone in your neighborhood"},
  ];
  final List<Map<String, String>> _purposeData = [
    {"title": "Read 10 Pages", "subtitle": "Read a non-fiction or self-development book"},
    {"title": "Meditate 10 Mins", "subtitle": "Practice mindfulness or meditation"},
    {"title": "Learn a Skill", "subtitle": "Spend 20 minutes learning something new"},
    {"title": "Journaling", "subtitle": "Write down your thoughts and goals"},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    _loadAllData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _getWeeklyDateRange() {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    String startStr = DateFormat('MMM d').format(startOfWeek);
    String endStr = DateFormat('d, yyyy').format(now);
    return "$startStr-$endStr";
  }

  Future<void> _loadAllData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String? lastMissionDate = prefs.getString('daily_mission_date');

    if (lastMissionDate != todayStr) {
      for (int i = 0; i < 4; i++) {
        await prefs.setBool('financial_comp_$i', false);
        await prefs.setBool('health_comp_$i', false);
        await prefs.setBool('social_comp_$i', false);
        await prefs.setBool('purpose_comp_$i', false);
      }
      await prefs.setString('daily_mission_date', todayStr);
    }

    setState(() {
      _weeklyExpFinancial = prefs.getInt('weekly_exp_financial') ?? 78;
      _weeklyExpHealth = prefs.getInt('weekly_exp_health') ?? 82;
      _weeklyExpSocial = prefs.getInt('weekly_exp_social') ?? 80;
      _weeklyExpPurpose = prefs.getInt('weekly_exp_purpose') ?? 76;
      _weeklyTotalExp = prefs.getInt('weekly_total_exp') ?? 316;
      _weeklyTotalMoneySaved = prefs.getInt('weekly_total_money_saved') ?? 245000;
      _currentLevel = prefs.getInt('user_current_level') ?? 2;

      for (int i = 0; i < 4; i++) {
        _finComp[i] = prefs.getBool('financial_comp_$i') ?? false;
        _healthComp[i] = prefs.getBool('health_comp_$i') ?? false;
        _socialComp[i] = prefs.getBool('social_comp_$i') ?? false;
        _purposeComp[i] = prefs.getBool('purpose_comp_$i') ?? false;
      }
    });
  }

  Future<void> _saveMissions(int tabIndex, String prefix, List<bool> selected, List<bool> completed) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int earnedExp = 0;
    int addedWater = 0;

    setState(() {
      for (int i = 0; i < 4; i++) {
        if (selected[i]) {
          completed[i] = true;
          selected[i] = false;
          earnedExp += 10;
          prefs.setBool('${prefix}_comp_$i', true);

          if (prefix == 'health' && i == 0) {
            addedWater = 2;
          }
        }
      }

      _weeklyTotalExp += earnedExp;
      if (tabIndex == 0) _weeklyExpFinancial += earnedExp;
      if (tabIndex == 1) _weeklyExpHealth += earnedExp;
      if (tabIndex == 2) _weeklyExpSocial += earnedExp;
      if (tabIndex == 3) _weeklyExpPurpose += earnedExp;
    });

    int globalTotal = prefs.getInt('user_total_exp') ?? 0;
    await prefs.setInt('user_total_exp', globalTotal + earnedExp);

    int globalPilarExp = prefs.getInt('user_exp_$prefix') ?? 0;
    await prefs.setInt('user_exp_$prefix', globalPilarExp + earnedExp);

    if (addedWater > 0) {
      int currentWater = prefs.getInt('user_total_water') ?? 0;
      await prefs.setInt('user_total_water', currentWater + addedWater);
    }

    await prefs.setInt('weekly_total_exp', _weeklyTotalExp);
    await prefs.setInt('weekly_exp_$prefix', (tabIndex == 0 ? _weeklyExpFinancial : tabIndex == 1 ? _weeklyExpHealth : tabIndex == 2 ? _weeklyExpSocial : _weeklyExpPurpose));

    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => CustomPopupDialog(
          imagePath: 'assets/images/mascot_levelup.png',
          title: "Your mission has been saved! 🌟",
          subtitle: "You've earned $earnedExp EXP! Your future self is definitely proud of your consistency today. Keep up the grind!",
          buttonText: "Continue",
          onButtonPressed: () => Navigator.pop(context),
        ),
      );
    }
  }

  Color _getActiveTabColor() {
    switch (_tabController.index) {
      case 0: return const Color(0xFF6EBE71);
      case 1: return const Color(0xFFFF935D);
      case 2: return const Color(0xFF8F7DF8);
      case 3: return const Color(0xFFFFC107);
      default: return const Color(0xFF6EBE71);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    String dateRangeText = _getWeeklyDateRange();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 24, bottom: 16),
                child: Center(
                  child: Text("Report", style: GoogleFonts.fraunces(fontSize: 28, fontWeight: FontWeight.bold, color: const Color(0xFF0C1325))),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2DCFF),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(color: const Color(0xFF7C5BFF).withOpacity(0.15), blurRadius: 24, offset: const Offset(0, 12)),
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset('assets/images/chart.png', width: 18, height: 18, color: const Color(0xFF0C1325)),
                              const SizedBox(width: 8),
                              Text("Weekly report", style: GoogleFonts.fraunces(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF0C1325))),
                            ],
                          ),
                          Text(dateRangeText, style: GoogleFonts.fraunces(fontSize: 12, color: Colors.grey.shade700)),
                        ],
                      ),
                      const SizedBox(height: 24),

                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                _buildPillarRow("Financial", _weeklyExpFinancial, 'assets/images/ic_financial.png', const Color(0xFF6EBE71)),
                                const SizedBox(height: 12),
                                _buildPillarRow("Health", _weeklyExpHealth, 'assets/images/ic_health.png', const Color(0xFFFF935D)),
                                const SizedBox(height: 12),
                                _buildPillarRow("Social", _weeklyExpSocial, 'assets/images/ic_social.png', const Color(0xFF8F7DF8)),
                                const SizedBox(height: 12),
                                _buildPillarRow("Purpose", _weeklyExpPurpose, 'assets/images/ic_purpose.png', const Color(0xFFFFC107)),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                              height: 140,
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: RadarChart(_buildRadarChartData()),
                                  ),
                                  Align(alignment: const Alignment(0, -0.95), child: Image.asset('assets/images/ic_financial.png', width: 14, color: const Color(0xFF6EBE71))),
                                  Align(alignment: const Alignment(0.9, 0), child: Image.asset('assets/images/ic_health.png', width: 14, color: const Color(0xFFFF935D))),
                                  Align(alignment: const Alignment(0, 0.9), child: Image.asset('assets/images/ic_purpose.png', width: 14, color: const Color(0xFFFFC107))),
                                  Align(alignment: const Alignment(-0.9, 0), child: Image.asset('assets/images/ic_social.png', width: 14, color: const Color(0xFF8F7DF8))),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  CircleAvatar(backgroundColor: const Color(0xFFFFF7E5), radius: 16, child: Image.asset('assets/images/coin.png', width: 20)),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Total EXP this week", style: TextStyle(fontSize: 9, color: Colors.grey.shade600), maxLines: 1),
                                        Text("$_weeklyTotalExp / 400", style: GoogleFonts.fraunces(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF0C1325))),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(width: 1, height: 30, color: Colors.grey.shade600),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Row(
                                children: [
                                  CircleAvatar(backgroundColor: const Color(0xFFEAF7E2), radius: 16, child: Image.asset('assets/images/saving.png', width: 18)),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Total savings", style: TextStyle(fontSize: 9, color: Colors.grey.shade600), maxLines: 1),
                                        Text(currencyFormat.format(_weeklyTotalMoneySaved), style: GoogleFonts.fraunces(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF0C1325)), maxLines: 1),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Daily Mini Mission", style: GoogleFonts.fraunces(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF0C1325))),
                    const SizedBox(height: 4),
                    Text("Complete daily missions to gain EXP", style: GoogleFonts.fraunces(fontSize: 12, color: Colors.grey.shade600)),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: _getActiveTabColor(),
                  labelColor: _getActiveTabColor(),
                  unselectedLabelColor: Colors.grey.shade500,
                  labelStyle: GoogleFonts.fraunces(fontWeight: FontWeight.bold, fontSize: 13),
                  unselectedLabelStyle: GoogleFonts.fraunces(fontWeight: FontWeight.w600, fontSize: 13),
                  dividerColor: Colors.grey.shade300,
                  tabs: const [
                    Tab(text: "Financial"),
                    Tab(text: "Health"),
                    Tab(text: "Social"),
                    Tab(text: "Purpose"),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _getSelectedTabContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getSelectedTabContent() {
    switch (_tabController.index) {
      case 0: return _buildMissionListTab(0, 'financial', 'assets/images/ic_financial.png', const Color(0xFF6EBE71), _finData, _finComp, _finSel);
      case 1: return _buildMissionListTab(1, 'health', 'assets/images/ic_health.png', const Color(0xFFFF935D), _healthData, _healthComp, _healthSel);
      case 2: return _buildMissionListTab(2, 'social', 'assets/images/ic_social.png', const Color(0xFF8F7DF8), _socialData, _socialComp, _socialSel);
      case 3: return _buildMissionListTab(3, 'purpose', 'assets/images/ic_purpose.png', const Color(0xFFFFC107), _purposeData, _purposeComp, _purposeSel);
      default: return const SizedBox.shrink();
    }
  }

  Widget _buildMissionListTab(int tabIndex, String prefix, String imagePath, Color color, List<Map<String, String>> data, List<bool> compList, List<bool> selList) {
    bool isSaveEnabled = selList.contains(true);
    bool isAllCompleted = !compList.contains(false);

    return Padding(
      key: ValueKey<int>(tabIndex),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Column(
        children: [
          for (int i = 0; i < 4; i++)
            MiniMissionCard(
              imagePath: imagePath,
              iconColor: color,
              title: data[i]["title"]!,
              subtitle: data[i]["subtitle"]!,
              isCompleted: compList[i],
              isSelected: selList[i],
              onTap: () {
                setState(() {
                  selList[i] = !selList[i];
                });
              },
            ),

          const SizedBox(height: 16),

          IgnorePointer(
            ignoring: !isSaveEnabled || isAllCompleted,
            child: Opacity(
              opacity: (isSaveEnabled && !isAllCompleted) ? 1.0 : 0.4,
              child: SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () => _saveMissions(tabIndex, prefix, selList, compList),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0C1325),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    isAllCompleted ? "All Missions Completed" : "Save Mission",
                    style: GoogleFonts.fraunces(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildPillarRow(String title, int exp, String imagePath, Color color) {
    return Row(
      children: [
        Image.asset(imagePath, width: 14, height: 14, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(title, style: GoogleFonts.fraunces(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF0C1325))),
        ),
        Text(exp.toString(), style: GoogleFonts.fraunces(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF0C1325))),
        const SizedBox(width: 16),
      ],
    );
  }

  RadarChartData _buildRadarChartData() {
    return RadarChartData(
      radarShape: RadarShape.polygon,
      tickCount: 2,
      ticksTextStyle: const TextStyle(color: Colors.transparent),
      radarBackgroundColor: Colors.transparent,
      radarBorderData: const BorderSide(color: Colors.transparent),
      gridBorderData: BorderSide(color: const Color(0xFF0C1325).withOpacity(0.2), width: 1),
      titlePositionPercentageOffset: 0.15,
      getTitle: (index, angle) => const RadarChartTitle(text: '', angle: 0),
      dataSets: [
        RadarDataSet(
          fillColor: const Color(0xFFFF935D).withOpacity(0.05),
          borderColor: const Color(0xFFFF935D),
          entryRadius: 0,
          dataEntries: const [RadarEntry(value: 100), RadarEntry(value: 100), RadarEntry(value: 100), RadarEntry(value: 100)],
          borderWidth: 2,
        ),
        RadarDataSet(
          fillColor: const Color(0xFF0C1325).withOpacity(0.15),
          borderColor: const Color(0xFF0C1325).withOpacity(0.55),
          entryRadius: 0,
          dataEntries: [
            RadarEntry(value: _weeklyExpFinancial.toDouble()),
            RadarEntry(value: _weeklyExpHealth.toDouble()),
            RadarEntry(value: _weeklyExpPurpose.toDouble()),
            RadarEntry(value: _weeklyExpSocial.toDouble()),
          ],
          borderWidth: 2.5,
        ),
      ],
    );
  }
}