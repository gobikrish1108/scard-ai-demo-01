import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_status_bar.dart';
import '../../../../core/widgets/app_three_dot_menu.dart';
import '../../../../core/widgets/bottom_nav_bar.dart';
import '../providers/ai_agents_provider.dart';

class AiAgentsScreen extends ConsumerWidget {
  const AiAgentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agents = ref.watch(aiAgentsProvider);
    final agentsNotifier = ref.read(aiAgentsProvider.notifier);

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
                        '10 AI Agents Mesh',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.emeraldSuccess.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.emeraldSuccess.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 7,
                              height: 7,
                              decoration: const BoxDecoration(
                                color: AppColors.emeraldSuccess,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              '10 Online',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.emeraldSuccess,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const AppThreeDotMenu(),
                    ],
                  ),
                ],
              ),
            ),

            // Security Containment Banner (BRD Section 19)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.crimson600.withValues(alpha: 0.2)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.crimsonDeep.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.crimson600.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.shield_outlined, color: AppColors.crimson600, size: 18),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Prompt Injection Containment Active: All untrusted inputs isolated via <untrusted_content> boundary blocks.',
                      style: TextStyle(fontSize: 10.5, color: AppColors.textDark, height: 1.3),
                    ),
                  ),
                ],
              ),
            ),

            // Agents List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                itemCount: agents.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final a = agents[index];
                  final isRunning = a.status == AgentStatus.running;

                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isRunning ? a.color : AppColors.borderLight,
                        width: isRunning ? 1.5 : 1.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: a.color.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(a.icon, size: 22, color: a.color),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          a.name,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textDark,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      _buildStatusBadge(a.status),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    a.description,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textMuted,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Divider(height: 1, color: AppColors.borderLight),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Executions: ${a.executionCount} • ${a.lastActive}',
                              style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () => _showTelemetryLogs(context, a),
                                  borderRadius: BorderRadius.circular(8),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    child: Row(
                                      children: [
                                        Icon(Icons.terminal_rounded, size: 14, color: a.color),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Logs',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: a.color,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: isRunning ? null : () => agentsNotifier.triggerAgent(a.id),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: a.color,
                                    foregroundColor: Colors.white,
                                    disabledBackgroundColor: a.color.withValues(alpha: 0.4),
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                    minimumSize: const Size(0, 30),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                  child: isRunning
                                      ? const SizedBox(
                                          width: 12,
                                          height: 12,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                          ),
                                        )
                                      : const Text(
                                          'Run Now',
                                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                        ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const BottomNavBar(currentRoute: '/agents'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(AgentStatus status) {
    Color bg;
    Color fg;
    String label;

    switch (status) {
      case AgentStatus.running:
        bg = AppColors.amberWarning.withValues(alpha: 0.15);
        fg = AppColors.amberWarning;
        label = 'Running';
        break;
      case AgentStatus.active:
        bg = AppColors.emeraldSuccess.withValues(alpha: 0.15);
        fg = AppColors.emeraldSuccess;
        label = 'Active';
        break;
      case AgentStatus.idle:
        bg = Colors.grey.withValues(alpha: 0.15);
        fg = Colors.grey.shade700;
        label = 'Idle';
        break;
      case AgentStatus.error:
        bg = Colors.red.withValues(alpha: 0.15);
        fg = Colors.red;
        label = 'Error';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: fg),
      ),
    );
  }

  void _showTelemetryLogs(BuildContext context, AgentItem agent) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Color(0xFF0F172A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(color: agent.color, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${agent.name} - Telemetry',
                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.white70),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white12),
                ),
                child: agent.logs.isEmpty
                    ? const Center(
                        child: Text(
                          'No telemetry logs recorded yet.',
                          style: TextStyle(color: Colors.white38, fontSize: 11, fontFamily: 'monospace'),
                        ),
                      )
                    : ListView.builder(
                        itemCount: agent.logs.length,
                        itemBuilder: (context, idx) {
                          final log = agent.logs[idx];
                          Color logColor = Colors.white70;
                          if (log.level == 'SUCCESS') logColor = AppColors.emeraldSuccess;
                          if (log.level == 'WARN') logColor = AppColors.amberWarning;
                          if (log.level == 'SEC') logColor = AppColors.crimson400;

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
                                children: [
                                  TextSpan(
                                    text: '[${log.timestamp}] [${log.level}] ',
                                    style: TextStyle(color: logColor, fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text: log.message,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
