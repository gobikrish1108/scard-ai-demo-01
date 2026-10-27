import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PomodoroMode { focus, shortBreak, longBreak }

class HabitItem {
  final String id;
  final String title;
  final bool isCompleted;
  final int streakDays;

  const HabitItem({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.streakDays = 1,
  });

  HabitItem copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    int? streakDays,
  }) {
    return HabitItem(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      streakDays: streakDays ?? this.streakDays,
    );
  }
}

class PomodoroState {
  final PomodoroMode mode;
  final int remainingSeconds;
  final bool isRunning;
  final int sessionCount;
  final int totalSessions;
  final int streakDays;
  final List<HabitItem> habits;

  const PomodoroState({
    this.mode = PomodoroMode.focus,
    this.remainingSeconds = 25 * 60,
    this.isRunning = false,
    this.sessionCount = 1,
    this.totalSessions = 4,
    this.streakDays = 14,
    this.habits = const [
      HabitItem(id: '1', title: 'Morning Cardio (45 mins)', isCompleted: true, streakDays: 14),
      HabitItem(id: '2', title: 'Read 20 pages AI Architecture', isCompleted: false, streakDays: 7),
      HabitItem(id: '3', title: 'Hydration: Drink 3L Water', isCompleted: true, streakDays: 21),
      HabitItem(id: '4', title: 'Zero Inbox VIP Triage', isCompleted: false, streakDays: 5),
    ],
  });

  PomodoroState copyWith({
    PomodoroMode? mode,
    int? remainingSeconds,
    bool? isRunning,
    int? sessionCount,
    int? totalSessions,
    int? streakDays,
    List<HabitItem>? habits,
  }) {
    return PomodoroState(
      mode: mode ?? this.mode,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isRunning: isRunning ?? this.isRunning,
      sessionCount: sessionCount ?? this.sessionCount,
      totalSessions: totalSessions ?? this.totalSessions,
      streakDays: streakDays ?? this.streakDays,
      habits: habits ?? this.habits,
    );
  }
}

class PomodoroNotifier extends Notifier<PomodoroState> {
  Timer? _timer;

  @override
  PomodoroState build() {
    ref.onDispose(() {
      _timer?.cancel();
    });
    return const PomodoroState();
  }

  void setMode(PomodoroMode mode) {
    _timer?.cancel();
    int secs = 25 * 60;
    if (mode == PomodoroMode.shortBreak) secs = 5 * 60;
    if (mode == PomodoroMode.longBreak) secs = 15 * 60;

    state = state.copyWith(
      mode: mode,
      remainingSeconds: secs,
      isRunning: false,
    );
  }

  void toggleTimer() {
    if (state.isRunning) {
      _timer?.cancel();
      state = state.copyWith(isRunning: false);
    } else {
      state = state.copyWith(isRunning: true);
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (state.remainingSeconds > 0) {
          state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
        } else {
          timer.cancel();
          // Advance session
          final nextCount = state.sessionCount >= state.totalSessions ? 1 : state.sessionCount + 1;
          state = state.copyWith(
            isRunning: false,
            sessionCount: nextCount,
            mode: PomodoroMode.shortBreak,
            remainingSeconds: 5 * 60,
          );
        }
      });
    }
  }

  void resetTimer() {
    _timer?.cancel();
    int secs = 25 * 60;
    if (state.mode == PomodoroMode.shortBreak) secs = 5 * 60;
    if (state.mode == PomodoroMode.longBreak) secs = 15 * 60;

    state = state.copyWith(
      isRunning: false,
      remainingSeconds: secs,
    );
  }

  void toggleHabit(String id) {
    state = state.copyWith(
      habits: [
        for (final habit in state.habits)
          if (habit.id == id)
            habit.copyWith(
              isCompleted: !habit.isCompleted,
              streakDays: habit.isCompleted ? habit.streakDays - 1 : habit.streakDays + 1,
            )
          else
            habit
      ],
    );
  }

  void addHabit(String title) {
    final newHabit = HabitItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      streakDays: 1,
    );
    state = state.copyWith(habits: [...state.habits, newHabit]);
  }
}

final pomodoroProvider =
    NotifierProvider<PomodoroNotifier, PomodoroState>(PomodoroNotifier.new);
