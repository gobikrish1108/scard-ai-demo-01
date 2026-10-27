import 'package:flutter_riverpod/flutter_riverpod.dart';

class SmartEmail {
  final String id;
  final String senderName;
  final String senderEmail;
  final String subject;
  final String preview;
  final String receivedTime;
  final bool isVip;
  final String category; // 'Escalation', 'Finance', 'General'
  final String aiDraft;
  final bool isReplied;
  final bool isRead;

  const SmartEmail({
    required this.id,
    required this.senderName,
    required this.senderEmail,
    required this.subject,
    required this.preview,
    required this.receivedTime,
    this.isVip = false,
    required this.category,
    required this.aiDraft,
    this.isReplied = false,
    this.isRead = false,
  });

  SmartEmail copyWith({
    String? id,
    String? senderName,
    String? senderEmail,
    String? subject,
    String? preview,
    String? receivedTime,
    bool? isVip,
    String? category,
    String? aiDraft,
    bool? isReplied,
    bool? isRead,
  }) {
    return SmartEmail(
      id: id ?? this.id,
      senderName: senderName ?? this.senderName,
      senderEmail: senderEmail ?? this.senderEmail,
      subject: subject ?? this.subject,
      preview: preview ?? this.preview,
      receivedTime: receivedTime ?? this.receivedTime,
      isVip: isVip ?? this.isVip,
      category: category ?? this.category,
      aiDraft: aiDraft ?? this.aiDraft,
      isReplied: isReplied ?? this.isReplied,
      isRead: isRead ?? this.isRead,
    );
  }
}

class SmartInboxNotifier extends Notifier<List<SmartEmail>> {
  @override
  List<SmartEmail> build() => [
        const SmartEmail(
          id: '1',
          senderName: 'Rajesh Kumar',
          senderEmail: 'rajesh@rajeshenterprises.in',
          subject: 'Contract Renewal: Q4 Scope Review & Invoicing',
          preview:
              'Hi Remakanth, please review the revised Antz Media scope of work document. Can we schedule a brief call at 3:00 PM today?',
          receivedTime: '10:42 AM',
          isVip: true,
          category: 'VIP Escalation',
          aiDraft:
              'Hi Rajesh, thank you for sending this. 3:00 PM works perfectly for me. I will send over the calendar invite and updated milestone annexure shortly.',
        ),
        const SmartEmail(
          id: '2',
          senderName: 'Priya Sundaram',
          senderEmail: 'priya@antzmedia.com',
          subject: 'Vendor GST Invoice Approval (#INV-8924)',
          preview:
              'Remakanth, the cloud hosting vendor has sent the GST invoice for ₹34,200. Please confirm if approved for disbursement.',
          receivedTime: '09:15 AM',
          isVip: true,
          category: 'Finance',
          aiDraft:
              'Hi Priya, I reviewed the hosting usage logs and line items. The invoice is approved. Please proceed with the NEFT transfer.',
        ),
        const SmartEmail(
          id: '3',
          senderName: 'Karthik Raja',
          senderEmail: 'karthik@innovatetech.com',
          subject: 'Product Demo & Partnership Proposal',
          preview:
              'Greetings from InnovateTech! We saw Antz Media\'s digital cards launch and would love to explore an API integration.',
          receivedTime: 'Yesterday',
          isVip: false,
          category: 'Partnership',
          aiDraft:
              'Hi Karthik, thank you for reaching out. We would be glad to discuss API integration synergies. Let us connect early next week.',
        ),
      ];

  void approveAndSendReply(String id) {
    state = [
      for (final email in state)
        if (email.id == id) email.copyWith(isReplied: true, isRead: true) else email
    ];
  }

  void updateDraft(String id, String newDraft) {
    state = [
      for (final email in state)
        if (email.id == id) email.copyWith(aiDraft: newDraft) else email
    ];
  }

  void toggleVip(String id) {
    state = [
      for (final email in state)
        if (email.id == id) email.copyWith(isVip: !email.isVip) else email
    ];
  }
}

final smartInboxProvider =
    NotifierProvider<SmartInboxNotifier, List<SmartEmail>>(SmartInboxNotifier.new);
