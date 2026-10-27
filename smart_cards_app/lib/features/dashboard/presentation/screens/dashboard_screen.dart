import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_status_bar.dart';
import '../../../../core/widgets/app_three_dot_menu.dart';
import '../../../../core/widgets/bottom_nav_bar.dart';
import '../providers/workspace_provider.dart';
import '../../../calendar_tasks/presentation/providers/tasks_provider.dart';
import '../../../smart_inbox/presentation/providers/smart_inbox_provider.dart';
import '../../../ai_agents/presentation/providers/ai_agents_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wsState = ref.watch(workspaceProvider);
    final wsNotifier = ref.read(workspaceProvider.notifier);
    final tasks = ref.watch(tasksProvider);
    final emails = ref.watch(smartInboxProvider);
    final agents = ref.watch(aiAgentsProvider);

    final pendingTasksCount = tasks.where((t) => !t.isCompleted).length;
    final unrepliedEmailsCount = emails.where((e) => !e.isReplied).length;

    return Scaffold(
      backgroundColor: AppColors.backgroundPeach,
      body: SafeArea(
        child: Column(
          children: [
            const AppStatusBar(),

            // Top Header: 3-Way Workspace Selector, Search, 3-Dot Menu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Workspace 3-Way Pill Switcher (Personal | Work | Business)
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        _buildWorkspacePill(
                          label: 'Personal',
                          isSelected: wsState.type == WorkspaceType.personal,
                          onTap: () => wsNotifier.selectWorkspace(WorkspaceType.personal),
                        ),
                        _buildWorkspacePill(
                          label: 'Work',
                          isSelected: wsState.type == WorkspaceType.work,
                          onTap: () => wsNotifier.selectWorkspace(WorkspaceType.work),
                        ),
                        _buildWorkspacePill(
                          label: 'Business',
                          isSelected: wsState.type == WorkspaceType.business,
                          onTap: () => wsNotifier.selectWorkspace(WorkspaceType.business),
                        ),
                      ],
                    ),
                  ),

                  // Search & 3-Dot Screens Navigator
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.search_rounded, size: 22, color: AppColors.textDark),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Universal Search triggered (Ctrl+K)')),
                          );
                        },
                      ),
                      const AppThreeDotMenu(iconColor: AppColors.textDark),
                    ],
                  ),
                ],
              ),
            ),

            // Scrollable Dashboard Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // User Greeting
                    Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.crimson600, width: 2),
                            image: const DecorationImage(
                              image: NetworkImage('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=200&h=200&q=80'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                              decoration: BoxDecoration(
                                color: AppColors.crimson50,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: AppColors.borderLight),
                              ),
                              child: Text(
                                wsState.label.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.crimson700,
                                ),
                              ),
                            ),
                            const Text(
                              'Hello, Remakanth',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Daily Operating Briefing Card
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.crimson700, AppColors.crimsonDeep],
                        ),
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.crimson600.withOpacity(0.35),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.circle, size: 8, color: AppColors.emeraldSuccess),
                                  SizedBox(width: 6),
                                  Text(
                                    'DAILY OPERATING BRIEFING',
                                    style: TextStyle(
                                      color: Color(0xFFFFE4DE),
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                'Oct 26 • Mon',
                                style: TextStyle(color: Color(0xFFFFE4DE), fontSize: 10),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '"${wsState.briefing}"',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Speaking briefing audio via Text-to-Speech...'),
                                      backgroundColor: AppColors.crimson700,
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.volume_up_rounded, size: 14),
                                label: const Text('Listen Audio', style: TextStyle(fontSize: 11)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white.withOpacity(0.2),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                              const SizedBox(width: 8),
                              OutlinedButton(
                                onPressed: () => context.go('/calendar'),
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: AppColors.crimson700,
                                  side: BorderSide.none,
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: const Text('Agenda', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Quick Action Chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildActionChip(context, Icons.add_rounded, 'Add Task', () => context.go('/calendar')),
                          _buildActionChip(context, Icons.mic_none_rounded, 'Voice AI', () => context.go('/voice')),
                          _buildActionChip(context, Icons.receipt_long_rounded, 'New Invoice', () => context.go('/invoices')),
                          _buildActionChip(context, Icons.phone_in_talk_rounded, 'Test Call', () => context.go('/phonecall')),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Metrics Grid (Scheduled Tasks + Smart Inbox)
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => context.go('/calendar'),
                            child: _buildMetricCard(
                              title: 'SCHEDULED',
                              count: '$pendingTasksCount Tasks',
                              subtitle: tasks.isNotEmpty ? tasks.first.title : wsState.pendingAction,
                              icon: Icons.access_time_rounded,
                              iconColor: AppColors.crimson600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InkWell(
                            onTap: () => context.go('/emails'),
                            child: _buildMetricCard(
                              title: 'SMART INBOX',
                              count: '$unrepliedEmailsCount Actionable',
                              subtitle: unrepliedEmailsCount > 0 ? '$unrepliedEmailsCount Awaiting Approval' : 'All Caught Up',
                              icon: Icons.mark_email_unread_rounded,
                              iconColor: AppColors.amberWarning,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 10 AI Agents Mesh Quick Section
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '10 AI Agents Mesh',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark),
                              ),
                              GestureDetector(
                                onTap: () => context.go('/agents'),
                                child: const Text(
                                  'View All (10)',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.crimson600),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: agents.take(4).map((a) {
                              String statusText = 'Online';
                              if (a.status == AgentStatus.running) statusText = 'Running';
                              if (a.status == AgentStatus.idle) statusText = 'Idle';
                              return _buildAgentMiniBadge(
                                a.name.split(' ').first,
                                a.icon,
                                statusText,
                                a.color,
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            const BottomNavBar(currentRoute: '/dashboard'),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkspacePill({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.crimson600 : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : AppColors.textDark,
          ),
        ),
      ),
    );
  }

  Widget _buildActionChip(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: ActionChip(
        onPressed: onTap,
        avatar: Icon(icon, size: 14, color: AppColors.crimson600),
        label: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        side: const BorderSide(color: AppColors.borderLight),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String count,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.textMuted)),
              Icon(icon, size: 14, color: iconColor),
            ],
          ),
          const SizedBox(height: 6),
          Text(count, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.textDark)),
          const SizedBox(height: 2),
          Text(subtitle, style: const TextStyle(fontSize: 10, color: AppColors.textMuted), maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _buildAgentMiniBadge(String name, IconData icon, String status, Color color) {
    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(height: 4),
        Text(name, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        Text(status, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: AppColors.emeraldSuccess)),
      ],
    );
  }
}
