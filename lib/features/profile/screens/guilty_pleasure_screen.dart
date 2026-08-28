import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../home/widgets/custom_popup_dialog.dart';
import '../../onboarding/widgets/Habit_Card.dart';

class GuiltyPleasureScreen extends StatefulWidget {
  const GuiltyPleasureScreen({super.key});

  @override
  State<GuiltyPleasureScreen> createState() => _GuiltyPleasureScreenState();
}

class _GuiltyPleasureScreenState extends State<GuiltyPleasureScreen> {
  String _selectedHabit = "";
  final TextEditingController _expenseController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedHabit = prefs.getString('user_habit') ?? "Coffee";
      _expenseController.text = (prefs.getInt('user_daily_savings') ?? 0).toString();
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_habit', _selectedHabit);
    await prefs.setInt('user_daily_savings', int.tryParse(_expenseController.text) ?? 0);

    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => CustomPopupDialog(
          imagePath: 'assets/images/data.png',
          title: "Data updated successfully!",
          subtitle: "Your information has been saved and your latest changes are now up to date.",
          buttonText: "Continue",
          onButtonPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      );
    }
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
        title: Text("Guilty Pleasure", style: GoogleFonts.fraunces(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF0C1325))),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Choose 1 daily habit that drains your wallet & health the most.", style: GoogleFonts.fraunces(fontSize: 14, color: const Color(0xFF0C1325))),
            const SizedBox(height: 24),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8,
              children: [
                HabitCard(
                  title: "Coffee & Boba", subtitle: "~25g Sugar", imagePath: 'assets/images/coffee.png',
                  isSelected: _selectedHabit.toLowerCase().contains("coffee") || _selectedHabit.toLowerCase().contains("boba"),
                  onTap: () => setState(() => _selectedHabit = "Coffee & Boba"),
                ),
                HabitCard(
                  title: "Cigarettes & Vapes", subtitle: "~10 Nicotine Sticks", imagePath: 'assets/images/cigarette.png',
                  isSelected: _selectedHabit.toLowerCase().contains("cigarette") || _selectedHabit.toLowerCase().contains("vape"),
                  onTap: () => setState(() => _selectedHabit = "Cigarettes & Vapes"),
                ),
                HabitCard(
                  title: "Junk Food", subtitle: "~500 kcal", imagePath: 'assets/images/junkfood.png',
                  isSelected: _selectedHabit.toLowerCase().contains("junk"),
                  onTap: () => setState(() => _selectedHabit = "Junk Food"),
                ),
                HabitCard(
                  title: "Impulse Buying", subtitle: "impulsive habits", imagePath: 'assets/images/impulse.png',
                  isSelected: _selectedHabit.toLowerCase().contains("impulse"),
                  onTap: () => setState(() => _selectedHabit = "Impulse Buying"),
                ),
              ],
            ),
            const SizedBox(height: 32),

            Text("Daily Spending", style: GoogleFonts.fraunces(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF0C1325))),
            const SizedBox(height: 8),
            TextField(
              controller: _expenseController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.payments_outlined, color: Colors.grey),
                hintText: "How much do you spend daily?",
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade300)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade300)),
              ),
            ),
            const SizedBox(height: 48),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _saveData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0C1325),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                ),
                child: Text("Save", style: GoogleFonts.fraunces(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}