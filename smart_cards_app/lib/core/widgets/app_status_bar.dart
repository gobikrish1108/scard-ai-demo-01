import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/app_colors.dart';

class AppStatusBar extends StatelessWidget {
  final bool isDark;

  const AppStatusBar({super.key, this.isDark = false});

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : AppColors.textDark;
    final currentTime = DateFormat('HH:mm').format(DateTime.now());

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                currentTime,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(width: 6),
              Icon(Icons.security, size: 10, color: textColor.withOpacity(0.7)),
              const SizedBox(width: 4),
              Icon(Icons.play_arrow, size: 10, color: textColor.withOpacity(0.7)),
            ],
          ),
          // Center punch hole camera
          Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
          ),
          Row(
            children: [
              Icon(Icons.signal_cellular_4_bar, size: 12, color: textColor),
              const SizedBox(width: 4),
              Icon(Icons.wifi, size: 12, color: textColor),
              const SizedBox(width: 4),
              Text(
                '94%',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(width: 2),
              Icon(Icons.battery_full, size: 13, color: textColor),
            ],
          ),
        ],
      ),
    );
  }
}
