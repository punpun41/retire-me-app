import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const OnboardingProgressBar({
    super.key,
    required this.currentStep,
    this.totalSteps = 3,
  });

  @override
  Widget build(BuildContext context) {
    // Menghitung persentase progres (0.0 hingga 1.0)
    final double progress = currentStep / totalSteps;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$currentStep/$totalSteps',
          style: GoogleFonts.fraunces(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFFF935D), // Warna Oranye
          ),
        ),
        const SizedBox(width: 12),
        // Wadah untuk bar progress
        Container(
          height: 10,
          width: 150,
          decoration: BoxDecoration(
            color: Colors.grey.shade200, // Warna abu-abu latar
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 10,
                // Lebar disesuaikan dengan persentase
                width: 150 * progress,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF935D), // Warna Oranye
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}