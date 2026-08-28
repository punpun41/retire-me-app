import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RetirementStyleCard extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final bool isSelected;
  final VoidCallback onTap;

  const RetirementStyleCard({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFE8E2FF), // Warna dasar ungu muda
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF7C5BFF) : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.22),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        // ClipRRect memastikan ornamen tidak keluar dari batas sudut melengkung kartu
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            children: [
              // 1. Ornamen Lingkaran Kiri Atas
              Positioned(
                top: -30,
                left: -20,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFD6C9FF), // Ungu lebih gelap untuk ornamen
                  ),
                ),
              ),

              // 2. Ornamen Lingkaran Kanan Bawah
              Positioned(
                bottom: -50,
                right: -30,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFD6C9FF),
                  ),
                ),
              ),

              // 3. Konten Utama Kartu (Gambar dan Teks)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Image.asset(
                      imagePath,
                      width: 100,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: GoogleFonts.fraunces(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF0C1325),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            description,
                            style: GoogleFonts.fraunces(
                              fontSize: 12,
                              color: const Color(0xFF0C1325),
                              height: 1.5,
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
    );
  }
}