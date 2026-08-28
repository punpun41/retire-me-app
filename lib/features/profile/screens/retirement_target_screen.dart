import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../home/widgets/custom_popup_dialog.dart';
import '../widgets/custom_popup_dialog.dart';

class RetirementTargetScreen extends StatefulWidget {
  const RetirementTargetScreen({super.key});

  @override
  State<RetirementTargetScreen> createState() => _RetirementTargetScreenState();
}

class _RetirementTargetScreenState extends State<RetirementTargetScreen> {
  final TextEditingController _ageController = TextEditingController();
  double _retirementAge = 42;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _ageController.text = (prefs.getInt('user_current_age') ?? 22).toString();
      _retirementAge = (prefs.getInt('user_retirement_age') ?? 42).toDouble();
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_current_age', int.tryParse(_ageController.text) ?? 22);
    await prefs.setInt('user_retirement_age', _retirementAge.toInt());

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
        title: Text("Retirement target", style: GoogleFonts.fraunces(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF0C1325))),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Planning a New\nRetirement Goal? 🌱", style: GoogleFonts.fraunces(fontSize: 28, fontWeight: FontWeight.bold, color: const Color(0xFF0C1325))),
            const SizedBox(height: 8),
            Text("Adjust your target age and keep building your dream future.", style: GoogleFonts.fraunces(fontSize: 14, color: Colors.grey.shade700)),
            const SizedBox(height: 32),

            Text("Current age", style: GoogleFonts.fraunces(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF0C1325))),
            const SizedBox(height: 8),
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
                hintText: "Input your current age...",
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade300)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade300)),
              ),
            ),
            const SizedBox(height: 32),

            Text("What age do you want to retire?", style: GoogleFonts.fraunces(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF0C1325))),
            const SizedBox(height: 16),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: const Color(0xFF8F7DF8),
                inactiveTrackColor: const Color(0xFF8F7DF8).withOpacity(0.2),
                thumbColor: const Color(0xFF8F7DF8),
                valueIndicatorColor: const Color(0xFF8F7DF8),
                valueIndicatorTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                showValueIndicator: ShowValueIndicator.always,
              ),
              child: Slider(
                value: _retirementAge,
                min: 30,
                max: 70,
                divisions: 40,
                label: _retirementAge.round().toString(),
                onChanged: (value) {
                  setState(() {
                    _retirementAge = value;
                  });
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("30", style: GoogleFonts.fraunces(fontSize: 12, color: Colors.grey.shade700)),
                Text("70", style: GoogleFonts.fraunces(fontSize: 12, color: Colors.grey.shade700)),
              ],
            ),

            const Spacer(),
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