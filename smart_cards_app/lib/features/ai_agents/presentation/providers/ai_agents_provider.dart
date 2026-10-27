import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AgentStatus { idle, running, active, error }

class AgentLog {
  final String timestamp;
  final String message;
  final String level; // INFO, SUCCESS, WARN, SEC

  const AgentLog({
    required this.timestamp,
    required this.message,
    required this.level,
  });
}

class AgentItem {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final AgentStatus status;
  final int executionCount;
  final String lastActive;
  final List<AgentLog> logs;

  const AgentItem({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    this.status = AgentStatus.active,
    this.executionCount = 142,
    this.lastActive = 'Just now',
    this.logs = const [],
  });

  AgentItem copyWith({
    String? id,
    String? name,
    String? description,
    IconData? icon,
    Color? color,
    AgentStatus? status,
    int? executionCount,
    String? lastActive,
    List<AgentLog>? logs,
  }) {
    return AgentItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      status: status ?? this.status,
      executionCount: executionCount ?? this.executionCount,
      lastActive: lastActive ?? this.lastActive,
      logs: logs ?? this.logs,
    );
  }
}

class AiAgentsNotifier extends Notifier<List<AgentItem>> {
  @override
  List<AgentItem> build() {
    return [
      const AgentItem(
        id: 'voice_telephony',
        name: 'Voice & Telephony Agent',
        description: 'Bilingual STT/TTS (Tamil & English)',
        icon: Icons.phone_in_talk_rounded,
        color: Color(0xFFC0151E),
        executionCount: 284,
        lastActive: '1m ago',
        logs: [
          AgentLog(timestamp: '15:42:01', message: 'Inbound SIP audio stream decoded (Tamil-EN mixed)', level: 'INFO'),
          AgentLog(timestamp: '15:42:04', message: 'Whisper STT transcript generated with 98.4% confidence', level: 'SUCCESS'),
        ],
      ),
      const AgentItem(
        id: 'email_triage',
        name: 'Email & Inbox Triage Agent',
        description: 'Contextual draft reply generation & VIP filtering',
        icon: Icons.mark_email_unread_rounded,
        color: Color(0xFFF59E0B),
        executionCount: 512,
        lastActive: '4m ago',
        logs: [
          AgentLog(timestamp: '15:38:12', message: 'Triaged 14 incoming IMAP messages', level: 'INFO'),
          AgentLog(timestamp: '15:38:15', message: 'Drafted reply for Rajesh Enterprises proposal', level: 'SUCCESS'),
        ],
      ),
      const AgentItem(
        id: 'doc_rag',
        name: 'Document RAG & Vault Agent',
        description: 'pgvector semantic search & OCR pipeline',
        icon: Icons.folder_shared_rounded,
        color: Color(0xFF2563EB),
        executionCount: 198,
        lastActive: '12m ago',
        logs: [
          AgentLog(timestamp: '15:30:20', message: 'Indexed GST_Certificate_AntzMedia.pdf (768d embeddings)', level: 'INFO'),
        ],
      ),
      const AgentItem(
        id: 'calendar_escalation',
        name: 'Calendar & Escalation Agent',
        description: 'Conflict resolution & auto-call alerts',
        icon: Icons.calendar_today_rounded,
        color: Color(0xFFC0151E),
        executionCount: 165,
        lastActive: '18m ago',
        logs: [
          AgentLog(timestamp: '15:24:10', message: 'Quarterly review conflict resolved with team lead', level: 'SUCCESS'),
        ],
      ),
      const AgentItem(
        id: 'invoice_expense',
        name: 'Invoicing & Expense Agent',
        description: 'GST 18% calculation & WhatsApp distribution',
        icon: Icons.receipt_long_rounded,
        color: Color(0xFF10B981),
        executionCount: 340,
        lastActive: '25m ago',
        logs: [
          AgentLog(timestamp: '15:17:02', message: 'Generated #INV-2026-090 with 18% GST (CGST 9% + SGST 9%)', level: 'SUCCESS'),
        ],
      ),
      const AgentItem(
        id: 'pomodoro_coach',
        name: 'Pomodoro & Habit Coach',
        description: 'Focus cycles, telemetry & streak alerts',
        icon: Icons.timer_rounded,
        color: Color(0xFF4F46E5),
        executionCount: 89,
        lastActive: '42m ago',
        logs: [
          AgentLog(timestamp: '15:00:00', message: 'Cycle #3 completed (25m focus). 5m break triggered', level: 'INFO'),
        ],
      ),
      const AgentItem(
        id: 'team_collab',
        name: 'Team Collab & Approvals Agent',
        description: 'Multi-tenant delegation & expense approvals',
        icon: Icons.groups_rounded,
        color: Colors.teal,
        executionCount: 76,
        lastActive: '1h ago',
        logs: [
          AgentLog(timestamp: '14:40:22', message: 'Reimbursement ₹4,500 approved by Admin', level: 'SUCCESS'),
        ],
      ),
      const AgentItem(
        id: 'universal_search',
        name: 'Universal Search Agent',
        description: 'Hybrid BM25 keyword & vector retrieval',
        icon: Icons.search_rounded,
        color: Colors.blueGrey,
        executionCount: 420,
        lastActive: '8m ago',
        logs: [
          AgentLog(timestamp: '15:34:11', message: 'Matched 3 documents and 2 calendar entries for query', level: 'INFO'),
        ],
      ),
      const AgentItem(
        id: 'workflow_auto',
        name: 'Workflow Automation Agent',
        description: '10 prebuilt automated operational pipelines',
        icon: Icons.auto_mode_rounded,
        color: Colors.deepOrange,
        executionCount: 630,
        lastActive: '3m ago',
        logs: [
          AgentLog(timestamp: '15:39:00', message: 'Triggered cron: Daily Business Briefing compilation', level: 'SUCCESS'),
        ],
      ),
      const AgentItem(
        id: 'security_guard',
        name: 'Security & Privacy Guard',
        description: 'Prompt injection containment & audit trail',
        icon: Icons.shield_rounded,
        color: Colors.red,
        executionCount: 890,
        lastActive: 'Just now',
        logs: [
          AgentLog(timestamp: '15:43:00', message: 'Sanitized 2 untrusted email payloads via XML boundaries', level: 'SEC'),
        ],
      ),
    ];
  }

  void triggerAgent(String agentId) {
    state = [
      for (final agent in state)
        if (agent.id == agentId)
          agent.copyWith(
            status: AgentStatus.running,
            executionCount: agent.executionCount + 1,
            lastActive: 'Running now...',
          )
        else
          agent
    ];

    // Simulate agent async completion
    Timer(const Duration(seconds: 2), () {
      state = [
        for (final agent in state)
          if (agent.id == agentId)
            agent.copyWith(
              status: AgentStatus.active,
              lastActive: 'Just now',
              logs: [
                AgentLog(
                  timestamp: DateTime.now().toIso8601String().substring(11, 19),
                  message: 'Manual pipeline execution completed successfully with 0 errors.',
                  level: 'SUCCESS',
                ),
                ...agent.logs,
              ],
            )
          else
            agent
      ];
    });
  }

  void toggleAgentStatus(String agentId) {
    state = [
      for (final agent in state)
        if (agent.id == agentId)
          agent.copyWith(
            status: agent.status == AgentStatus.idle ? AgentStatus.active : AgentStatus.idle,
            lastActive: agent.status == AgentStatus.idle ? 'Resumed' : 'Paused',
          )
        else
          agent
    ];
  }
}

final aiAgentsProvider = NotifierProvider<AiAgentsNotifier, List<AgentItem>>(AiAgentsNotifier.new);
