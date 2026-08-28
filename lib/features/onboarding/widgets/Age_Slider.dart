import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AgeSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const AgeSlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: const Color(0xFF7C5BFF), // Ungu gelap
            inactiveTrackColor: const Color(0xFFDCD2FF), // Ungu terang
            thumbColor: const Color(0xFF7C5BFF),
            overlayColor: const Color(0xFF7C5BFF).withOpacity(0.2),
            valueIndicatorColor: const Color(0xFF7C5BFF),
            valueIndicatorTextStyle: GoogleFonts.fraunces(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          child: Slider(
            value: value,
            min: 30,
            max: 70,
            divisions: 40, // 70 - 30 (agar bergeser per 1 angka)
            label: value.round().toString(), // Tooltip angka di atas slider
            onChanged: onChanged,
          ),
        ),
        // Label angka 30 dan 70 di ujung slider
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '30',
                style: GoogleFonts.fraunces(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0C1325),
                ),
              ),
              Text(
                '70',
                style: GoogleFonts.fraunces(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0C1325),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}