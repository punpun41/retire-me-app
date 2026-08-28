import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomPopupDialog extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback onButtonPressed;
  final bool isAchievement;

  const CustomPopupDialog({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.onButtonPressed,
    this.isAchievement = false,
  });

  @override
  Widget build(BuildContext context) {
    const Color purple = Color(0xFF7C5BFF);
    const Color darkNavy = Color(0xFF0C1325);

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
                      Image.asset(
                        imagePath,
                        height: 108,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 14),
                      Text(
                        title,
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
                        subtitle,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.fraunces(
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 18),
                      // Tombol Continue — ramping (tinggi tetap 48px, pill penuh).
                      SizedBox(
                        width: double.infinity,
                        height: 46,
                        child: ElevatedButton(
                          onPressed: onButtonPressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: darkNavy,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            buttonText,
                            style: GoogleFonts.fraunces(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
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
}