import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';

class BottomNavBar extends StatelessWidget {
  final String currentRoute;

  const BottomNavBar({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: AppColors.crimson600,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context: context,
                icon: Icons.home_rounded,
                label: 'Home',
                route: '/dashboard',
                isActive: currentRoute == '/dashboard',
              ),
              _buildNavItem(
                context: context,
                icon: Icons.calendar_today_rounded,
                label: 'Agenda',
                route: '/calendar',
                isActive: currentRoute == '/calendar',
              ),
              const SizedBox(width: 48), // Spacer for center floating button
              _buildNavItem(
                context: context,
                icon: Icons.qr_code_scanner_rounded,
                label: 'Scan',
                route: '/vault',
                isActive: currentRoute == '/vault',
              ),
              _buildNavItem(
                context: context,
                icon: Icons.share_rounded,
                label: 'Share',
                route: '/card',
                isActive: currentRoute == '/card',
              ),
            ],
          ),
          // Center floating mic button matching Image 2
          Positioned(
            top: -16,
            child: GestureDetector(
              onTap: () => context.go('/voice'),
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.crimson600, width: 3),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.mic_rounded,
                    color: AppColors.crimson600,
                    size: 26,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String route,
    required bool isActive,
  }) {
    final color = isActive ? Colors.white : Colors.white70;

    return InkWell(
      onTap: () => context.go(route),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
