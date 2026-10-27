import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskItem {
  final String id;
  final String title;
  final String time;
  final String priority;
  final bool isCompleted;
  final bool hasAutoCall;

  const TaskItem({
    required this.id,
    required this.title,
    required this.time,
    required this.priority,
    this.isCompleted = false,
    this.hasAutoCall = false,
  });

  TaskItem copyWith({
    String? id,
    String? title,
    String? time,
    String? priority,
    bool? isCompleted,
    bool? hasAutoCall,
  }) {
    return TaskItem(
      id: id ?? this.id,
      title: title ?? this.title,
      time: time ?? this.time,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      hasAutoCall: hasAutoCall ?? this.hasAutoCall,
    );
  }
}

class TasksNotifier extends Notifier<List<TaskItem>> {
  @override
  List<TaskItem> build() => [
        const TaskItem(
          id: '1',
          title: 'Review VIP Email Rules & Inbox Events',
          time: '09:00 AM',
          priority: 'Medium',
          isCompleted: true,
        ),
        const TaskItem(
          id: '2',
          title: 'Submit Antz Media Quarterly Financials',
          time: '02:30 PM',
          priority: 'Urgent',
          hasAutoCall: true,
        ),
        const TaskItem(
          id: '3',
          title: 'AI Sprint Review & Roadmap Alignment',
          time: '05:00 PM',
          priority: 'Medium',
        ),
      ];

  void toggleTask(String id) {
    state = [
      for (final task in state)
        if (task.id == id) task.copyWith(isCompleted: !task.isCompleted) else task
    ];
  }

  void addTask({
    required String title,
    required String time,
    required String priority,
  }) {
    final newTask = TaskItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      time: time,
      priority: priority,
    );
    state = [...state, newTask];
  }
}

final tasksProvider = NotifierProvider<TasksNotifier, List<TaskItem>>(TasksNotifier.new);
