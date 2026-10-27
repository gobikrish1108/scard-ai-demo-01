import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeamMember {
  final String id;
  final String name;
  final String role;
  final String email;
  final String initials;
  final bool isOnline;
  final bool isAdmin;

  const TeamMember({
    required this.id,
    required this.name,
    required this.role,
    required this.email,
    required this.initials,
    this.isOnline = true,
    this.isAdmin = false,
  });
}

class ApprovalRequest {
  final String id;
  final String requesterName;
  final String requesterRole;
  final double amount;
  final String description;
  final String status; // 'Pending', 'Approved', 'Rejected'
  final String submittedTime;

  const ApprovalRequest({
    required this.id,
    required this.requesterName,
    required this.requesterRole,
    required this.amount,
    required this.description,
    this.status = 'Pending',
    required this.submittedTime,
  });

  ApprovalRequest copyWith({
    String? id,
    String? requesterName,
    String? requesterRole,
    double? amount,
    String? description,
    String? status,
    String? submittedTime,
  }) {
    return ApprovalRequest(
      id: id ?? this.id,
      requesterName: requesterName ?? this.requesterName,
      requesterRole: requesterRole ?? this.requesterRole,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      status: status ?? this.status,
      submittedTime: submittedTime ?? this.submittedTime,
    );
  }
}

class TeamState {
  final List<TeamMember> members;
  final List<ApprovalRequest> requests;

  const TeamState({
    this.members = const [
      TeamMember(
        id: '1',
        name: 'Remakanth R (You)',
        role: 'Chief Evangelist',
        email: 'remakanth@antzmedia.com',
        initials: 'RR',
        isAdmin: true,
      ),
      TeamMember(
        id: '2',
        name: 'Priya Sundaram',
        role: 'Marketing Lead',
        email: 'priya@antzmedia.com',
        initials: 'PS',
      ),
      TeamMember(
        id: '3',
        name: 'Karthik Raja',
        role: 'Engineering Lead',
        email: 'karthik@antzmedia.com',
        initials: 'KR',
      ),
      TeamMember(
        id: '4',
        name: 'Deepa V',
        role: 'Finance Operations',
        email: 'deepa@antzmedia.com',
        initials: 'DV',
        isOnline: false,
      ),
    ],
    this.requests = const [
      ApprovalRequest(
        id: '1',
        requesterName: 'Priya Sundaram',
        requesterRole: 'Marketing Lead',
        amount: 18500,
        description: 'Antz Media Q4 Brand & Google Ads Campaign spend',
        submittedTime: '2 hours ago',
      ),
      ApprovalRequest(
        id: '2',
        requesterName: 'Karthik Raja',
        requesterRole: 'Engineering Lead',
        amount: 4500,
        description: 'Team Cloud Architecture Certification exam vouchers',
        submittedTime: 'Yesterday',
      ),
    ],
  });

  TeamState copyWith({
    List<TeamMember>? members,
    List<ApprovalRequest>? requests,
  }) {
    return TeamState(
      members: members ?? this.members,
      requests: requests ?? this.requests,
    );
  }
}

class TeamNotifier extends Notifier<TeamState> {
  @override
  TeamState build() => const TeamState();

  void approveRequest(String id) {
    state = state.copyWith(
      requests: [
        for (final req in state.requests)
          if (req.id == id) req.copyWith(status: 'Approved') else req
      ],
    );
  }

  void rejectRequest(String id) {
    state = state.copyWith(
      requests: [
        for (final req in state.requests)
          if (req.id == id) req.copyWith(status: 'Rejected') else req
      ],
    );
  }

  void addMember(String name, String role, String email) {
    final initials = name.split(' ').map((n) => n.isNotEmpty ? n[0] : '').take(2).join().toUpperCase();
    final newMember = TeamMember(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      role: role,
      email: email,
      initials: initials,
    );
    state = state.copyWith(members: [...state.members, newMember]);
  }
}

final teamProvider = NotifierProvider<TeamNotifier, TeamState>(TeamNotifier.new);
