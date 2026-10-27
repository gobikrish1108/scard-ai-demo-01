import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum CallStatus { idle, ringing, connected, ended }

class TelephonyState {
  final CallStatus status;
  final String callerName;
  final String callerNumber;
  final String escalationReason;
  final int callDurationSeconds;
  final bool isMuted;
  final bool isSpeaker;
  final List<String> liveTranscript;

  const TelephonyState({
    this.status = CallStatus.ringing,
    this.callerName = 'Smart Cards AI Assistant',
    this.callerNumber = '+91 98400 11223',
    this.escalationReason = 'Urgent Escalation: Antz Media Financials due at 2:30 PM',
    this.callDurationSeconds = 0,
    this.isMuted = false,
    this.isSpeaker = true,
    this.liveTranscript = const [
      'AI: "Vanakkam Remakanth. This is your Smart Cards automated escalation."',
      'AI: "You have a mandatory Antz Media quarterly submission due in 15 minutes."',
    ],
  });

  TelephonyState copyWith({
    CallStatus? status,
    String? callerName,
    String? callerNumber,
    String? escalationReason,
    int? callDurationSeconds,
    bool? isMuted,
    bool? isSpeaker,
    List<String>? liveTranscript,
  }) {
    return TelephonyState(
      status: status ?? this.status,
      callerName: callerName ?? this.callerName,
      callerNumber: callerNumber ?? this.callerNumber,
      escalationReason: escalationReason ?? this.escalationReason,
      callDurationSeconds: callDurationSeconds ?? this.callDurationSeconds,
      isMuted: isMuted ?? this.isMuted,
      isSpeaker: isSpeaker ?? this.isSpeaker,
      liveTranscript: liveTranscript ?? this.liveTranscript,
    );
  }
}

class TelephonyNotifier extends Notifier<TelephonyState> {
  Timer? _timer;

  @override
  TelephonyState build() {
    ref.onDispose(() {
      _timer?.cancel();
    });
    return const TelephonyState();
  }

  void answerCall() {
    _timer?.cancel();
    state = state.copyWith(status: CallStatus.connected, callDurationSeconds: 0);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final nextSec = state.callDurationSeconds + 1;
      List<String> transcripts = [...state.liveTranscript];

      if (nextSec == 3) {
        transcripts.add('AI: "Would you like me to dispatch the preliminary draft to Priya for review?"');
      } else if (nextSec == 7) {
        transcripts.add('User: "Yes, please approve and notify the finance desk."');
      } else if (nextSec == 11) {
        transcripts.add('AI: "Done. Dispatched via WhatsApp & Email. Have a productive day!"');
      }

      state = state.copyWith(
        callDurationSeconds: nextSec,
        liveTranscript: transcripts,
      );
    });
  }

  void toggleMute() {
    state = state.copyWith(isMuted: !state.isMuted);
  }

  void toggleSpeaker() {
    state = state.copyWith(isSpeaker: !state.isSpeaker);
  }

  void endCall() {
    _timer?.cancel();
    state = state.copyWith(status: CallStatus.ended);
  }

  void resetCall() {
    _timer?.cancel();
    state = const TelephonyState(status: CallStatus.ringing);
  }
}

final telephonyProvider =
    NotifierProvider<TelephonyNotifier, TelephonyState>(TelephonyNotifier.new);
