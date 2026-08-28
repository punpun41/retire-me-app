import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

class IconTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final IconData prefixIcon;
  final TextInputType keyboardType;
  final TextEditingController? controller; // 1. Tambahkan baris ini
  final List<TextInputFormatter>? inputFormatters;

  const IconTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.controller, // 2. Tambahkan baris ini
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.fraunces(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0C1325),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller, // 3. Sambungkan controller ke TextField bawaan
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 14,
            ),
            prefixIcon: Icon(
              prefixIcon,
              color: Colors.grey.shade500,
              size: 22,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF0C1325)),
            ),
          ),
        ),
      ],
    );
  }
}