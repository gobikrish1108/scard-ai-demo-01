import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_status_bar.dart';
import '../../../../core/widgets/app_three_dot_menu.dart';
import '../../../../core/widgets/bottom_nav_bar.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    final usageRatio = settings.voiceMinutesLimit > 0
        ? settings.voiceMinutesUsed / settings.voiceMinutesLimit
        : 0.0;

    return Scaffold(
      backgroundColor: AppColors.backgroundPeach,
      body: SafeArea(
        child: Column(
          children: [
            const AppStatusBar(),
            // Top App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textDark),
                        onPressed: () => context.go('/dashboard'),
                      ),
                      const Text(
                        'Settings & Security',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
                  const AppThreeDotMenu(),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Subscription Tier Card
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF0F172A), AppColors.crimsonDeep],
                        ),
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 12,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'SUBSCRIPTION TIER',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFFD3C7),
                                  letterSpacing: 1.0,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.amber.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.amber.withValues(alpha: 0.4)),
                                ),
                                child: Text(
                                  settings.subscriptionTier,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'AI Voice Minutes: ${settings.voiceMinutesUsed} / ${settings.voiceMinutesLimit} mins used',
                            style: const TextStyle(fontSize: 12.5, color: Colors.white, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: usageRatio,
                            backgroundColor: Colors.white24,
                            valueColor: const AlwaysStoppedAnimation(Colors.amber),
                            minHeight: 6,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Renews on ${settings.renewDate} • Auto-billing',
                                style: const TextStyle(fontSize: 10.5, color: Colors.white60),
                              ),
                              InkWell(
                                onTap: () => _showUpgradePlanDialog(context, notifier),
                                child: const Text(
                                  'Change Plan',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Regional & Language Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'REGIONAL & LOCALIZATION',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textMuted, letterSpacing: 0.5),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Default Timezone', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                              Text(settings.timezone, style: const TextStyle(fontSize: 11.5, color: AppColors.textMuted)),
                            ],
                          ),
                          const Divider(height: 20, color: Color(0xFFF1F5F9)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Voice Assistant Language', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                              Text(settings.voiceLanguage, style: const TextStyle(fontSize: 11.5, color: AppColors.crimson600, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Security & Privacy Controls
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'SECURITY & AIR-GAP AIRFLOW',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textMuted, letterSpacing: 0.5),
                          ),
                          const SizedBox(height: 10),
                          SwitchListTile.adaptive(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Prompt Injection Strict Containment', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold)),
                            subtitle: const Text('Enforce XML boundary tags <untrusted_content> on external inputs', style: TextStyle(fontSize: 10.5, color: AppColors.textMuted)),
                            value: settings.strictPromptInjection,
                            activeColor: AppColors.crimson600,
                            onChanged: (val) => notifier.togglePromptInjection(val),
                          ),
                          const Divider(height: 16, color: Color(0xFFF1F5F9)),
                          SwitchListTile.adaptive(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Offline SQLite Sync Active', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold)),
                            subtitle: const Text('Cache tasks, contacts, and invoices in local Drift DB', style: TextStyle(fontSize: 10.5, color: AppColors.textMuted)),
                            value: settings.offlineDataSync,
                            activeColor: AppColors.crimson600,
                            onChanged: (val) => notifier.toggleOfflineSync(val),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Privacy & Memory Purge (GDPR)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('PRIVACY & MEMORY PURGE (GDPR)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textMuted, letterSpacing: 0.5)),
                          const SizedBox(height: 6),
                          const Text(
                            'Permanently erase all stored conversational memory vectors and unpinned audio logs across the 10 AI Agents mesh.',
                            style: TextStyle(fontSize: 11, color: AppColors.textMuted, height: 1.3),
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                notifier.purgeMemoryStore();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Personal memory store purged! GDPR scrub complete.'),
                                    backgroundColor: AppColors.crimson700,
                                  ),
                                );
                              },
                              icon: const Icon(Icons.delete_sweep_rounded, size: 16),
                              label: const Text('Purge Personal Memory Store', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.crimson700,
                                side: const BorderSide(color: AppColors.crimson600),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            const BottomNavBar(currentRoute: '/settings'),
          ],
        ),
      ),
    );
  }

  void _showUpgradePlanDialog(BuildContext context, SettingsNotifier notifier) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Select Subscription Tier', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('PRO PLAN (5,000 mins/mo)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              subtitle: const Text('₹ 2,499/month'),
              onTap: () {
                notifier.upgradePlan('PRO PLAN');
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('ENTERPRISE PLAN (25,000 mins/mo)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              subtitle: const Text('₹ 8,999/month • Dedicated SLA & Telephony'),
              onTap: () {
                notifier.upgradePlan('ENTERPRISE');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
