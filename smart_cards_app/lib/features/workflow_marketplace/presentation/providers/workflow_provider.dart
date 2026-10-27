import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkflowItem {
  final String id;
  final String number;
  final String title;
  final String description;
  final String category;
  final bool isEnabled;
  final int runCount;
  final String lastRunAt;
  final bool isRunning;

  const WorkflowItem({
    required this.id,
    required this.number,
    required this.title,
    required this.description,
    required this.category,
    this.isEnabled = true,
    this.runCount = 42,
    this.lastRunAt = '10m ago',
    this.isRunning = false,
  });

  WorkflowItem copyWith({
    String? id,
    String? number,
    String? title,
    String? description,
    String? category,
    bool? isEnabled,
    int? runCount,
    String? lastRunAt,
    bool? isRunning,
  }) {
    return WorkflowItem(
      id: id ?? this.id,
      number: number ?? this.number,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      isEnabled: isEnabled ?? this.isEnabled,
      runCount: runCount ?? this.runCount,
      lastRunAt: lastRunAt ?? this.lastRunAt,
      isRunning: isRunning ?? this.isRunning,
    );
  }
}

class WorkflowNotifier extends Notifier<List<WorkflowItem>> {
  @override
  List<WorkflowItem> build() => [
        const WorkflowItem(
          id: 'wf_1',
          number: '01',
          title: 'VIP Inbound Email Escalation',
          description: 'Auto-drafts reply with Prompt Injection check & sends priority push notification.',
          category: 'Email & Triage',
          runCount: 128,
          lastRunAt: '4m ago',
        ),
        const WorkflowItem(
          id: 'wf_2',
          number: '02',
          title: 'Automated GST Invoice & WhatsApp Dispatch',
          description: 'Calculates 18% GST (CGST 9% + SGST 9%) and delivers encrypted PDF link via WhatsApp.',
          category: 'Finance',
          runCount: 84,
          lastRunAt: '25m ago',
        ),
        const WorkflowItem(
          id: 'wf_3',
          number: '03',
          title: 'Urgent Calendar Telephony Escalation',
          description: 'Triggers automated SIP outbound call 15 mins before critical high-priority events.',
          category: 'Telephony',
          runCount: 36,
          lastRunAt: '2h ago',
        ),
        const WorkflowItem(
          id: 'wf_4',
          number: '04',
          title: 'Multi-Workspace Context Isolation Filter',
          description: 'Air-gaps Personal vs Work vs Business memory embeddings to prevent data leakage.',
          category: 'Security',
          runCount: 512,
          lastRunAt: '1m ago',
        ),
        const WorkflowItem(
          id: 'wf_5',
          number: '05',
          title: 'Tamil Voice Prompt to English Task',
          description: 'Whisper STT converts spoken Tamil audio to English action items with date parsing.',
          category: 'Voice AI',
          runCount: 92,
          lastRunAt: '18m ago',
        ),
        const WorkflowItem(
          id: 'wf_6',
          number: '06',
          title: 'Document Vault Pre-Meeting RAG Briefing',
          description: 'Extracts key deliverables & past invoices 30 minutes before any scheduled client call.',
          category: 'Document RAG',
          runCount: 45,
          lastRunAt: '3h ago',
        ),
        const WorkflowItem(
          id: 'wf_7',
          number: '07',
          title: 'Team Expense Reimbursement Pipeline',
          description: 'Auto-approves receipts under ₹5,000 and routes higher amounts to Admin approval queue.',
          category: 'Team Collab',
          runCount: 29,
          lastRunAt: '5h ago',
        ),
        const WorkflowItem(
          id: 'wf_8',
          number: '08',
          title: 'Pomodoro Focus Session Telemetry Sync',
          description: 'Logs completed 25m focus blocks to local SQLite database and updates habit streak count.',
          category: 'Productivity',
          runCount: 160,
          lastRunAt: '42m ago',
        ),
        const WorkflowItem(
          id: 'wf_9',
          number: '09',
          title: 'QR & NFC Scan Lead Enrichment',
          description: 'When NFC digital card is tapped, captures visitor telemetry and logs to CRM contacts.',
          category: 'Digital Cards',
          runCount: 210,
          lastRunAt: '12m ago',
        ),
        const WorkflowItem(
          id: 'wf_10',
          number: '10',
          title: 'GDPR Privacy Scrubbing & Memory Purge',
          description: 'Purges cached transient vectors and unpinned temporary audio memo logs every 24 hours.',
          category: 'Compliance',
          runCount: 60,
          lastRunAt: 'Yesterday',
        ),
      ];

  void toggleWorkflow(String id) {
    state = [
      for (final wf in state)
        if (wf.id == id) wf.copyWith(isEnabled: !wf.isEnabled) else wf
    ];
  }

  void triggerWorkflow(String id) {
    state = [
      for (final wf in state)
        if (wf.id == id) wf.copyWith(isRunning: true) else wf
    ];

    Timer(const Duration(seconds: 2), () {
      state = [
        for (final wf in state)
          if (wf.id == id)
            wf.copyWith(
              isRunning: false,
              runCount: wf.runCount + 1,
              lastRunAt: 'Just now',
            )
          else
            wf
      ];
    });
  }
}

final workflowProvider =
    NotifierProvider<WorkflowNotifier, List<WorkflowItem>>(WorkflowNotifier.new);
