import 'package:flutter/material.dart';

class MiniMissionCard extends StatelessWidget {
  final String imagePath;
  final Color iconColor;
  final String title;
  final String subtitle;
  final int expReward;
  final bool isCompleted;
  final bool isSelected;
  final VoidCallback onTap;

  const MiniMissionCard({
    super.key,
    required this.imagePath,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.expReward = 10,
    required this.isCompleted,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    Color borderColor = isCompleted
        ? iconColor.withOpacity(0.5)
        : (isSelected ? iconColor : Colors.grey.shade200);

    IconData checkIcon = (isCompleted || isSelected)
        ? Icons.check_circle
        : Icons.radio_button_unchecked;

    Color checkColor = (isCompleted || isSelected)
        ? iconColor
        : Colors.grey.shade400;

    return GestureDetector(
      onTap: isCompleted ? null : onTap, // Kunci klik jika sudah disave (Completed)
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isCompleted ? Colors.grey.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: (isSelected || isCompleted) ? 1.5 : 1.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Image.asset(imagePath, width: 24, height: 24, color: iconColor),
            ),
            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: isCompleted ? Colors.grey.shade500 : const Color(0xFF131B2A),
                      decoration: isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            // Badge EXP & Checkbox
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isCompleted ? Colors.grey.shade200 : iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "+ $expReward exp",
                    style: TextStyle(
                      fontSize: 12,
                      color: isCompleted ? Colors.grey.shade500 : iconColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  checkIcon,
                  color: checkColor,
                  size: 24,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}