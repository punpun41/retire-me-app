import 'package:flutter/material.dart';

class ContinueButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool hasArrow;

  const ContinueButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.hasArrow = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0C1325),
        minimumSize: const Size(double.infinity, 58),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Fraunces',
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (hasArrow)
            Positioned(
              right: 4,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFD6C4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_outward,
                  color: Color(0xFF11141E),
                  size: 20,
                ),
              ),
            ),
        ],
      ),
    );
  }
}