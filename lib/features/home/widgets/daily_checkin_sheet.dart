import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DailyCheckInSheet extends StatefulWidget {
  const DailyCheckInSheet({super.key});

  @override
  State<DailyCheckInSheet> createState() => _DailyCheckInSheetState();
}

class _DailyCheckInSheetState extends State<DailyCheckInSheet> {
  int? _financialScore;
  int? _healthScore;
  int? _socialScore;
  int? _purposeScore;
  bool? _avoidedBadHabit;

  bool get _isFormValid {
    return _financialScore != null &&
        _healthScore != null &&
        _socialScore != null &&
        _purposeScore != null &&
        _avoidedBadHabit != null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          // Drag Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 14),

          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/mascot_daily.png',
                        height: 56,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Daily Check-in",
                              style: GoogleFonts.fraunces(
                                fontSize: 21, // 20 -> 21
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF0C1325),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              "Let's do a quick reflection on today's 4 pillars!",
                              style: GoogleFonts.fraunces(
                                fontSize: 12, // 11 -> 12
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20), // 16 -> 20

                  // --- PILLAR SCORING SECTION ---
                  _buildPillarCard(
                    title: "Financial",
                    subtitle: "How well are you managing your finances today?",
                    iconAssetPath: 'assets/images/ic_financial.png',
                    iconBgColor: const Color(0xFFEAF7E2),
                    activeColor: const Color(0xFF6EBE71),
                    currentScore: _financialScore,
                    onScoreSelected: (score) => setState(() => _financialScore = score),
                  ),
                  const SizedBox(height: 10),

                  _buildPillarCard(
                    title: "Health",
                    subtitle: "How well did you take care of your health today?",
                    iconAssetPath: 'assets/images/ic_health.png',
                    iconBgColor: const Color(0xFFFEF0E6),
                    activeColor: const Color(0xFFF39C73),
                    currentScore: _healthScore,
                    onScoreSelected: (score) => setState(() => _healthScore = score),
                  ),
                  const SizedBox(height: 10),

                  _buildPillarCard(
                    title: "Social",
                    subtitle: "How meaningful were your connections with others?",
                    iconAssetPath: 'assets/images/ic_social.png',
                    iconBgColor: const Color(0xFFF1EEFF),
                    activeColor: const Color(0xFF8F7DF8),
                    currentScore: _socialScore,
                    onScoreSelected: (score) => setState(() => _socialScore = score),
                  ),
                  const SizedBox(height: 10),

                  _buildPillarCard(
                    title: "Purpose",
                    subtitle: "How aligned were your activities with your life purpose?",
                    iconAssetPath: 'assets/images/ic_purpose.png',
                    iconBgColor: const Color(0xFFFFF8D6),
                    activeColor: const Color(0xFFFBC02D),
                    currentScore: _purposeScore,
                    onScoreSelected: (score) => setState(() => _purposeScore = score),
                  ),
                  const SizedBox(height: 22), // 20 -> 22

                  // --- BAD HABIT TOGGLE SECTION ---
                  Text(
                    "Did you manage to avoid bad habits today?",
                    style: GoogleFonts.fraunces(
                      fontSize: 16, // 15 -> 16
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0C1325),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12), // 10 -> 12
                  Row(
                    children: [
                      Expanded(child: _buildToggleBtn(isYes: true, label: "Yes! :D")),
                      const SizedBox(width: 12),
                      Expanded(child: _buildToggleBtn(isYes: false, label: "No")),
                    ],
                  ),
                  const SizedBox(height: 14),
                ],
              ),
            ),
          ),

          // --- SUBMIT BUTTON SECTION ---
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 14, 24, 22),
            child: SizedBox(
              width: double.infinity,
              height: 54, // 50 -> 54
              child: ElevatedButton(
                onPressed: _isFormValid
                    ? () {
                  Navigator.pop(context, {
                    'financial': _financialScore,
                    'health': _healthScore,
                    'social': _socialScore,
                    'purpose': _purposeScore,
                    'avoidedBadHabit': _avoidedBadHabit,
                  });
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0C1325),
                  disabledBackgroundColor: Colors.grey.shade300,
                  elevation: 0,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  "Save",
                  style: GoogleFonts.fraunces(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _isFormValid ? Colors.white : Colors.grey.shade500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPillarCard({
    required String title,
    required String subtitle,
    required String iconAssetPath,
    required Color iconBgColor,
    required Color activeColor,
    required int? currentScore,
    required Function(int) onScoreSelected,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12), // 10/10 -> 12/12
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40, // 36 -> 40
            height: 40,
            padding: const EdgeInsets.all(9), // 8 -> 9
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Image.asset(iconAssetPath, fit: BoxFit.contain),
          ),
          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.fraunces(
                    fontSize: 14.5, // 14 -> 14.5
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0C1325),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.fraunces(
                    fontSize: 10, // 9.5 -> 10
                    color: Colors.grey.shade600,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 4),

          // Lingkaran Angka 1-5
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(5, (index) {
              int score = index + 1;
              bool isLit = currentScore != null && score <= currentScore;

              return GestureDetector(
                onTap: () => onScoreSelected(score),
                child: Container(
                  margin: const EdgeInsets.only(left: 5), // 4 -> 5
                  width: 25, // 22 -> 25
                  height: 25,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isLit ? activeColor : Colors.transparent,
                    border: Border.all(
                      color: isLit ? activeColor : const Color(0xFFB0B3B8),
                      width: 1.1,
                    ),
                  ),
                  child: Text(
                    score.toString(),
                    style: GoogleFonts.fraunces(
                      fontSize: 12, // 11 -> 12
                      fontWeight: isLit ? FontWeight.bold : FontWeight.w500,
                      color: isLit ? Colors.white : const Color(0xFF8A8D93),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleBtn({required bool isYes, required String label}) {
    bool isSelected = _avoidedBadHabit == isYes;

    Color bgColor = Colors.white;
    Color borderColor = const Color(0xFFE5E7EB);
    Color textColor = Colors.grey.shade600;

    if (isSelected) {
      if (isYes) {
        bgColor = const Color(0xFFFFF2B2);
        borderColor = const Color(0xFFFFD54F);
        textColor = const Color(0xFF0C1325);
      } else {
        bgColor = const Color(0xFFFFD8D8);
        borderColor = const Color(0xFFEF9A9A);
        textColor = const Color(0xFF0C1325);
      }
    }

    return GestureDetector(
      onTap: () => setState(() => _avoidedBadHabit = isYes),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 13), // 11 -> 13
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(15), // 14 -> 15
          border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
        ),
        child: Text(
          label,
          style: GoogleFonts.fraunces(
            fontSize: 14, // 13 -> 14
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: textColor,
          ),
        ),
      ),
    );
  }
}