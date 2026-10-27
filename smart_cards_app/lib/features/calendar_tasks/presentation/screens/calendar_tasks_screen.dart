import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_status_bar.dart';
import '../../../../core/widgets/app_three_dot_menu.dart';
import '../../../../core/widgets/bottom_nav_bar.dart';
import '../providers/tasks_provider.dart';

class CalendarTasksScreen extends ConsumerWidget {
  const CalendarTasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tasksProvider);
    final tasksNotifier = ref.read(tasksProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.backgroundPeach,
      body: SafeArea(
        child: Column(
          children: [
            const AppStatusBar(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_rounded),
                        onPressed: () => context.go('/dashboard'),
                      ),
                      const Text(
                        'Calendar & Tasks',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _showAddTaskDialog(context, tasksNotifier),
                        icon: const Icon(Icons.add_rounded, size: 14),
                        label: const Text('Add Task', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.crimson600,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const AppThreeDotMenu(),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // October 2026 Interactive Calendar Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Column(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'October 2026',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark),
                              ),
                              Row(
                                children: [
                                  Icon(Icons.chevron_left_rounded, size: 18, color: AppColors.textMuted),
                                  SizedBox(width: 8),
                                  Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.textMuted),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Days of Week
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                                .map((d) => Text(d, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textMuted)))
                                .toList(),
                          ),
                          const SizedBox(height: 8),
                          // Sample week row highlighting Oct 26 (Monday)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildDayCell('25', false),
                              _buildDayCell('26', true), // Today
                              _buildDayCell('27', false),
                              _buildDayCell('28', false),
                              _buildDayCell('29', false),
                              _buildDayCell('30', false),
                              _buildDayCell('31', false),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Smart Escalation Agenda Header
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Monday, Oct 26 Agenda',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark),
                        ),
                        Text(
                          'Smart Escalation Enabled',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.crimson600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Tasks Timeline List
                    ...tasks.map((t) => Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: t.priority == 'Urgent' ? AppColors.crimson50 : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: t.priority == 'Urgent' ? AppColors.crimson400 : AppColors.borderLight,
                            ),
                          ),
                          child: Row(
                            children: [
                              Checkbox(
                                value: t.isCompleted,
                                activeColor: AppColors.crimson600,
                                onChanged: (val) => tasksNotifier.toggleTask(t.id),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${t.time} • ${t.priority} Priority',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: t.priority == 'Urgent' ? AppColors.crimson600 : AppColors.textMuted,
                                          ),
                                        ),
                                        if (t.hasAutoCall)
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                            decoration: BoxDecoration(
                                              color: AppColors.crimson600,
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: const Text('Auto-Call', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      t.title,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textDark,
                                        decoration: t.isCompleted ? TextDecoration.lineThrough : null,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            const BottomNavBar(currentRoute: '/calendar'),
          ],
        ),
      ),
    );
  }

  Widget _buildDayCell(String day, bool isSelected) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.crimson600 : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          day,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.textDark,
          ),
        ),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context, TasksNotifier notifier) {
    final titleCtrl = TextEditingController();
    final timeCtrl = TextEditingController(text: '14:00');
    String priority = 'High';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Add Scheduled Task', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: 'Task Title'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: timeCtrl,
              decoration: const InputDecoration(labelText: 'Time (e.g. 14:00)'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              notifier.addTask(title: titleCtrl.text.isNotEmpty ? titleCtrl.text : 'New Task', time: timeCtrl.text, priority: priority);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Task scheduled!'), backgroundColor: AppColors.crimson700),
              );
            },
            child: const Text('Create Task'),
          ),
        ],
      ),
    );
  }
}
