import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HabitCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final bool isSelected;
  final VoidCallback onTap;

  const HabitCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFE2FFD9), // Latar hijau muda
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            // Jika dipilih, border hijau tegas. Jika tidak, transparan.
            color: isSelected ? const Color(0xFF8AE06E) : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.16),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 118, // Sesuaikan ukuran
            ),
            const SizedBox(height: 1),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.fraunces(
                fontSize: 15.5,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0C1325),
              ),
            ),
            const SizedBox(height: 1),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.fraunces(
                fontSize: 11,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}