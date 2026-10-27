import 'package:flutter_riverpod/flutter_riverpod.dart';

enum WorkspaceType { personal, work, business }

class WorkspaceState {
  final WorkspaceType type;
  final String label;
  final String briefing;
  final int scheduledTasks;
  final int actionableEmails;
  final String pendingAction;

  const WorkspaceState({
    required this.type,
    required this.label,
    required this.briefing,
    required this.scheduledTasks,
    required this.actionableEmails,
    required this.pendingAction,
  });
}

class WorkspaceNotifier extends Notifier<WorkspaceState> {
  static const _businessState = WorkspaceState(
    type: WorkspaceType.business,
    label: 'Business Workspace',
    briefing: 'Antz Media has 3 critical follow-ups, 1 vendor invoice due Nov 15, and 2 inbound VIP emails awaiting approval.',
    scheduledTasks: 4,
    actionableEmails: 2,
    pendingAction: 'Submit Antz Media Quarterly Report (2:30 PM)',
  );

  static const _personalState = WorkspaceState(
    type: WorkspaceType.personal,
    label: 'Personal Workspace',
    briefing: 'You have 1 gym routine, household grocery restock, and 1 electricity bill due this week.',
    scheduledTasks: 2,
    actionableEmails: 0,
    pendingAction: 'Evening Gym Routine (05:00 PM)',
  );

  static const _workState = WorkspaceState(
    type: WorkspaceType.work,
    label: 'Work Workspace',
    briefing: 'Sprint planning at 5:00 PM. 2 PR reviews pending on GitHub, and 1 client email to review.',
    scheduledTasks: 3,
    actionableEmails: 1,
    pendingAction: 'GitHub PR Review & Sprint Alignment',
  );

  @override
  WorkspaceState build() => _businessState;

  void selectWorkspace(WorkspaceType type) {
    switch (type) {
      case WorkspaceType.personal:
        state = _personalState;
        break;
      case WorkspaceType.work:
        state = _workState;
        break;
      case WorkspaceType.business:
        state = _businessState;
        break;
    }
  }
}

final workspaceProvider = NotifierProvider<WorkspaceNotifier, WorkspaceState>(WorkspaceNotifier.new);
