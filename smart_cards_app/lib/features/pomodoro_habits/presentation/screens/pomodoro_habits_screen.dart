import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_status_bar.dart';
import '../../../../core/widgets/app_three_dot_menu.dart';
import '../../../../core/widgets/bottom_nav_bar.dart';
import '../providers/pomodoro_provider.dart';

class PomodoroHabitsScreen extends ConsumerWidget {
  const PomodoroHabitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pomodoro = ref.watch(pomodoroProvider);
    final notifier = ref.read(pomodoroProvider.notifier);

    final mins = (pomodoro.remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final secs = (pomodoro.remainingSeconds % 60).toString().padLeft(2, '0');

    // Calculate progress for circular border
    int totalSecs = 25 * 60;
    if (pomodoro.mode == PomodoroMode.shortBreak) totalSecs = 5 * 60;
    if (pomodoro.mode == PomodoroMode.longBreak) totalSecs = 15 * 60;
    final progress = totalSecs > 0 ? (totalSecs - pomodoro.remainingSeconds) / totalSecs : 0.0;

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
                        'Focus & Habit Coach',
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
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    // Mode selector pills
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Row(
                        children: [
                          _buildModePill(
                            title: 'Focus (25m)',
                            isSelected: pomodoro.mode == PomodoroMode.focus,
                            onTap: () => notifier.setMode(PomodoroMode.focus),
                          ),
                          _buildModePill(
                            title: 'Break (5m)',
                            isSelected: pomodoro.mode == PomodoroMode.shortBreak,
                            onTap: () => notifier.setMode(PomodoroMode.shortBreak),
                          ),
                          _buildModePill(
                            title: 'Long (15m)',
                            isSelected: pomodoro.mode == PomodoroMode.longBreak,
                            onTap: () => notifier.setMode(PomodoroMode.longBreak),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Circular Timer with dynamic ring
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 210,
                          height: 210,
                          child: CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 9,
                            backgroundColor: AppColors.indigoFocus.withValues(alpha: 0.15),
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.indigoFocus),
                          ),
                        ),
                        Container(
                          width: 188,
                          height: 188,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.indigoFocus.withValues(alpha: 0.12),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                pomodoro.mode == PomodoroMode.focus ? 'DEEP WORK BLOCK' : 'RECHARGE BREAK',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.indigoFocus,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '$mins:$secs',
                                style: const TextStyle(
                                  fontSize: 42,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.textDark,
                                  letterSpacing: -1,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Session ${pomodoro.sessionCount} of ${pomodoro.totalSessions}',
                                style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () => notifier.toggleTimer(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.indigoFocus,
                            foregroundColor: Colors.white,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(18),
                            elevation: 4,
                          ),
                          child: Icon(
                            pomodoro.isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          onPressed: () => notifier.resetTimer(),
                          icon: const Icon(Icons.rotate_right_rounded, size: 30, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // Daily Habits Tracker
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: AppColors.borderLight),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
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
                                'Daily Habit Streaks',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textDark,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.amberWarning.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '🔥 ${pomodoro.streakDays} Day Streak',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.amberWarning,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: pomodoro.habits.length,
                            separatorBuilder: (context, index) => const Divider(height: 16, color: Color(0xFFF1F5F9)),
                            itemBuilder: (context, index) {
                              final habit = pomodoro.habits[index];
                              return InkWell(
                                onTap: () => notifier.toggleHabit(habit.id),
                                borderRadius: BorderRadius.circular(8),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            habit.isCompleted ? Icons.check_circle_rounded : Icons.circle_outlined,
                                            size: 20,
                                            color: habit.isCompleted ? AppColors.indigoFocus : AppColors.textMuted,
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            habit.title,
                                            style: TextStyle(
                                              fontSize: 12.5,
                                              fontWeight: FontWeight.w500,
                                              color: habit.isCompleted ? AppColors.textMuted : AppColors.textDark,
                                              decoration: habit.isCompleted ? TextDecoration.lineThrough : null,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        habit.isCompleted ? '${habit.streakDays}d done' : 'Pending',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: habit.isCompleted ? AppColors.emeraldSuccess : AppColors.textMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            const BottomNavBar(currentRoute: '/focus'),
          ],
        ),
      ),
    );
  }

  Widget _buildModePill({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.indigoFocus : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : AppColors.textDark,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
