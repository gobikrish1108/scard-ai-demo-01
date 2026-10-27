import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';

class AppThreeDotMenu extends StatelessWidget {
  final Color iconColor;

  const AppThreeDotMenu({super.key, this.iconColor = AppColors.textDark});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert_rounded, color: iconColor),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.borderLight),
      ),
      color: Colors.white,
      onSelected: (route) => context.go(route),
      itemBuilder: (context) => [
        _buildHeader('Core Screens', '14 Modules'),
        _buildItem('/login', Icons.lock_outline_rounded, '1. Login Screen', 'Img 1', AppColors.crimson600),
        _buildItem('/card', Icons.badge_outlined, '2. Manage Card Details', 'Img 2', AppColors.crimson600),
        _buildItem('/dashboard', Icons.dashboard_outlined, '3. Executive Dashboard', 'Hub', AppColors.crimson700),
        
        const PopupMenuDivider(),
        _buildHeader('AI & Speech', 'Sec 16'),
        _buildItem('/agents', Icons.hub_outlined, '4. 10 AI Agents Mesh', 'Mesh', AppColors.purpleAgent),
        _buildItem('/voice', Icons.mic_none_rounded, '5. Voice AI (EN / தமிழ்)', 'TTS', AppColors.crimson600),

        const PopupMenuDivider(),
        _buildHeader('Productivity', 'Daily'),
        _buildItem('/calendar', Icons.calendar_month_outlined, '6. Calendar & Tasks', 'Agenda', AppColors.crimson600),
        _buildItem('/emails', Icons.mark_email_unread_outlined, '7. Smart Inbox Triage', 'VIP', AppColors.amberWarning),
        _buildItem('/vault', Icons.folder_shared_outlined, '8. Document Vault & RAG', 'OCR', AppColors.blueAccent),
        _buildItem('/focus', Icons.timer_outlined, '9. Pomodoro Focus & Habits', '25:00', AppColors.indigoFocus),

        const PopupMenuDivider(),
        _buildHeader('Business OS', 'Automations'),
        _buildItem('/invoices', Icons.receipt_long_outlined, '10. Invoices & Finance', 'GST', AppColors.emeraldSuccess),
        _buildItem('/marketplace', Icons.auto_mode_outlined, '11. 10 Workflows', 'Auto', Colors.deepOrange),
        _buildItem('/team', Icons.group_outlined, '12. Team & Approvals', 'Collab', Colors.teal),
        _buildItem('/phonecall', Icons.phone_in_talk_outlined, '13. Telephony Simulator', 'Live', AppColors.crimson500),
        _buildItem('/settings', Icons.settings_outlined, '14. Settings & Privacy', 'GDPR', Colors.blueGrey),
      ],
    );
  }

  PopupMenuEntry<String> _buildHeader(String title, String badge) {
    return PopupMenuItem<String>(
      enabled: false,
      height: 28,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: AppColors.textMuted,
              letterSpacing: 0.8,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(
              color: AppColors.crimson50,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              badge,
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: AppColors.crimson700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  PopupMenuItem<String> _buildItem(
    String route,
    IconData icon,
    String title,
    String badge,
    Color color,
  ) {
    return PopupMenuItem<String>(
      value: route,
      height: 38,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              badge,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
