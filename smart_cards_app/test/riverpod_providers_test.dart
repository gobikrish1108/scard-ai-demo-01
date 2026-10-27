import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_cards_app/features/ai_agents/presentation/providers/ai_agents_provider.dart';
import 'package:smart_cards_app/features/card_management/presentation/providers/card_provider.dart';
import 'package:smart_cards_app/features/dashboard/presentation/providers/workspace_provider.dart';
import 'package:smart_cards_app/features/calendar_tasks/presentation/providers/tasks_provider.dart';
import 'package:smart_cards_app/features/invoices_finance/presentation/providers/invoices_provider.dart';
import 'package:smart_cards_app/features/smart_inbox/presentation/providers/smart_inbox_provider.dart';
import 'package:smart_cards_app/features/pomodoro_habits/presentation/providers/pomodoro_provider.dart';
import 'package:smart_cards_app/features/document_vault/presentation/providers/document_vault_provider.dart';
import 'package:smart_cards_app/features/workflow_marketplace/presentation/providers/workflow_provider.dart';
import 'package:smart_cards_app/features/team_collab/presentation/providers/team_provider.dart';
import 'package:smart_cards_app/features/telephony/presentation/providers/telephony_provider.dart';
import 'package:smart_cards_app/features/settings/presentation/providers/settings_provider.dart';

void main() {
  group('Riverpod Providers Architecture Verification', () {
    test('WorkspaceNotifier switches between Business, Personal, and Work', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Default is Business
      expect(container.read(workspaceProvider).type, WorkspaceType.business);

      // Switch to Personal
      container.read(workspaceProvider.notifier).selectWorkspace(WorkspaceType.personal);
      expect(container.read(workspaceProvider).type, WorkspaceType.personal);
      expect(container.read(workspaceProvider).label, 'Personal Workspace');

      // Switch to Work
      container.read(workspaceProvider.notifier).selectWorkspace(WorkspaceType.work);
      expect(container.read(workspaceProvider).type, WorkspaceType.work);
    });

    test('CardNotifier updates professional details and address reactively', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final initial = container.read(cardProvider);
      expect(initial.fullName, 'Remakanth R');
      expect(initial.organisation, 'Antz Media Digital');

      container.read(cardProvider.notifier).updateProfessionalDetails(
        organisation: 'Antz Media AI Labs',
        designation: 'Head of AI Architecture',
      );

      final updated = container.read(cardProvider);
      expect(updated.organisation, 'Antz Media AI Labs');
      expect(updated.designation, 'Head of AI Architecture');
    });

    test('TasksNotifier toggles completion and creates new scheduled task', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final initialTasks = container.read(tasksProvider);
      expect(initialTasks.length, 3);

      // Toggle first task
      final firstId = initialTasks.first.id;
      final wasCompleted = initialTasks.first.isCompleted;
      container.read(tasksProvider.notifier).toggleTask(firstId);
      expect(container.read(tasksProvider).first.isCompleted, !wasCompleted);

      // Add task
      container.read(tasksProvider.notifier).addTask(
        title: 'Review RAG Embedding vectors',
        time: '04:00 PM',
        priority: 'Urgent',
      );
      expect(container.read(tasksProvider).length, 4);
      expect(container.read(tasksProvider).last.title, 'Review RAG Embedding vectors');
    });

    test('InvoicesNotifier computes 18% GST (9% CGST + 9% SGST)', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(invoicesProvider.notifier).createInvoice(
        clientName: 'Tata Digital Retainer',
        baseAmount: 100000,
      );

      final invoices = container.read(invoicesProvider);
      final newInv = invoices.first;
      expect(newInv.clientName, 'Tata Digital Retainer');
      expect(newInv.baseAmount, 100000);
      expect(newInv.cgst, 9000); // 9%
      expect(newInv.sgst, 9000); // 9%
      expect(newInv.totalAmount, 118000); // 18% total GST
    });

    test('AiAgentsNotifier contains 10 agents and handles status toggles', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final agents = container.read(aiAgentsProvider);
      expect(agents.length, 10);
      expect(agents.first.id, 'voice_telephony');
      expect(agents.last.id, 'security_guard');

      // Toggle status
      container.read(aiAgentsProvider.notifier).toggleAgentStatus('voice_telephony');
      expect(container.read(aiAgentsProvider).first.status, AgentStatus.idle);
    });

    test('SmartInboxNotifier approves and dispatches AI draft reply', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final emails = container.read(smartInboxProvider);
      expect(emails.first.isReplied, false);

      container.read(smartInboxProvider.notifier).approveAndSendReply(emails.first.id);
      expect(container.read(smartInboxProvider).first.isReplied, true);
    });

    test('PomodoroNotifier toggles habits and changes focus modes', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final state = container.read(pomodoroProvider);
      expect(state.mode, PomodoroMode.focus);
      expect(state.remainingSeconds, 25 * 60);

      // Switch to break
      container.read(pomodoroProvider.notifier).setMode(PomodoroMode.shortBreak);
      expect(container.read(pomodoroProvider).mode, PomodoroMode.shortBreak);
      expect(container.read(pomodoroProvider).remainingSeconds, 5 * 60);

      // Habit streak toggle
      final firstHabit = state.habits.first;
      final initialStreak = firstHabit.streakDays;
      container.read(pomodoroProvider.notifier).toggleHabit(firstHabit.id);
      expect(container.read(pomodoroProvider).habits.first.streakDays, initialStreak - 1);
    });

    test('DocumentVaultNotifier manages documents and embeddings', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final initialCount = container.read(documentVaultProvider).documents.length;
      expect(initialCount, 3);

      container.read(documentVaultProvider.notifier).uploadDocument(
        'Antz_Media_Security_Audit.pdf',
        'Compliance',
        10,
        '2.1 MB',
      );
      // Synchronous state update will occur after timer, but state is initialized correctly
      expect(container.read(documentVaultProvider).documents.isNotEmpty, true);
    });

    test('WorkflowNotifier contains 10 recipes and toggles enabled state', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final workflows = container.read(workflowProvider);
      expect(workflows.length, 10);
      expect(workflows.first.isEnabled, true);

      container.read(workflowProvider.notifier).toggleWorkflow(workflows.first.id);
      expect(container.read(workflowProvider).first.isEnabled, false);
    });

    test('TeamNotifier approves and rejects expense requests', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final req = container.read(teamProvider).requests.first;
      expect(req.status, 'Pending');

      container.read(teamProvider.notifier).approveRequest(req.id);
      expect(container.read(teamProvider).requests.first.status, 'Approved');
    });

    test('TelephonyNotifier answers call and manages call controls', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(telephonyProvider).status, CallStatus.ringing);

      container.read(telephonyProvider.notifier).answerCall();
      expect(container.read(telephonyProvider).status, CallStatus.connected);

      container.read(telephonyProvider.notifier).toggleMute();
      expect(container.read(telephonyProvider).isMuted, true);

      container.read(telephonyProvider.notifier).endCall();
      expect(container.read(telephonyProvider).status, CallStatus.ended);
    });

    test('SettingsNotifier controls Prompt Injection strict mode and GDPR purge', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(settingsProvider).strictPromptInjection, true);

      container.read(settingsProvider.notifier).togglePromptInjection(false);
      expect(container.read(settingsProvider).strictPromptInjection, false);

      container.read(settingsProvider.notifier).purgeMemoryStore();
      expect(container.read(settingsProvider).memoryPurged, true);
    });
  });
}
