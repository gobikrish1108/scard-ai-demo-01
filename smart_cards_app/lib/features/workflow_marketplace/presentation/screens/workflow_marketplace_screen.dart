import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_status_bar.dart';
import '../../../../core/widgets/app_three_dot_menu.dart';
import '../../../../core/widgets/bottom_nav_bar.dart';
import '../providers/workflow_provider.dart';

class WorkflowMarketplaceScreen extends ConsumerWidget {
  const WorkflowMarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workflows = ref.watch(workflowProvider);
    final wfNotifier = ref.read(workflowProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.backgroundPeach,
      body: SafeArea(
        child: Column(
          children: [
            const AppStatusBar(),
            // Header
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
                        '10 Turnkey Workflows',
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

            // Subtitle banner
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: const Row(
                children: [
                  Icon(Icons.bolt_rounded, color: Colors.deepOrange, size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Pre-configured autonomous pipelines. Triggers operate across Voice, WhatsApp, Email, GST & Calendar.',
                      style: TextStyle(fontSize: 11, color: AppColors.textDark, height: 1.3),
                    ),
                  ),
                ],
              ),
            ),

            // Workflows List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                itemCount: workflows.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final wf = workflows[index];
                  final isRunning = wf.isRunning;

                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isRunning ? Colors.deepOrange : AppColors.borderLight,
                        width: isRunning ? 1.5 : 1.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.deepOrange.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    wf.number,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.deepOrange,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    wf.category,
                                    style: const TextStyle(
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Switch.adaptive(
                              value: wf.isEnabled,
                              onChanged: (val) => wfNotifier.toggleWorkflow(wf.id),
                              activeColor: Colors.deepOrange,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          wf.title,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          wf.description,
                          style: const TextStyle(fontSize: 11, color: AppColors.textMuted, height: 1.3),
                        ),
                        const SizedBox(height: 10),
                        const Divider(height: 1, color: AppColors.borderLight),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Executed ${wf.runCount} times • ${wf.lastRunAt}',
                              style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                            ),
                            ElevatedButton(
                              onPressed: isRunning || !wf.isEnabled
                                  ? null
                                  : () {
                                      wfNotifier.triggerWorkflow(wf.id);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Triggered pipeline: "${wf.title}"!'),
                                          backgroundColor: Colors.deepOrange,
                                        ),
                                      );
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepOrange,
                                foregroundColor: Colors.white,
                                disabledBackgroundColor: Colors.deepOrange.withValues(alpha: 0.3),
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                minimumSize: const Size(0, 30),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              child: isRunning
                                  ? const SizedBox(
                                      width: 12,
                                      height: 12,
                                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                    )
                                  : const Text('Run Now', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const BottomNavBar(currentRoute: '/marketplace'),
          ],
        ),
      ),
    );
  }
}
