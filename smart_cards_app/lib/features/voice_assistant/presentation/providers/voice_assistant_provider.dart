import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../calendar_tasks/presentation/providers/tasks_provider.dart';

class VoiceMessage {
  final bool isUser;
  final String text;
  final String timestamp;
  final String? intent;

  const VoiceMessage({
    required this.isUser,
    required this.text,
    required this.timestamp,
    this.intent,
  });
}

class VoiceAssistantState {
  final bool isListening;
  final bool isProcessing;
  final String language; // 'en' or 'ta'
  final String transcript;
  final String identifiedAction;
  final String identifiedTime;
  final double confidence;
  final List<double> soundWaves;
  final List<VoiceMessage> history;

  const VoiceAssistantState({
    this.isListening = false,
    this.isProcessing = false,
    this.language = 'en',
    this.transcript = 'Remind me to call Rajesh tomorrow at 10 AM regarding contract review',
    this.identifiedAction = 'Task Creation: Call Rajesh',
    this.identifiedTime = 'Tomorrow 10:00 AM',
    this.confidence = 0.99,
    this.soundWaves = const [12, 18, 25, 14, 28, 16, 10],
    this.history = const [
      VoiceMessage(
        isUser: true,
        text: 'Review my agenda for today',
        timestamp: '11:15 AM',
        intent: 'Agenda Summary',
      ),
      VoiceMessage(
        isUser: false,
        text: 'You have 3 tasks today: Email Rules at 9 AM, Quarterly Financials at 2:30 PM, and AI Sprint at 5 PM.',
        timestamp: '11:15 AM',
      ),
    ],
  });

  VoiceAssistantState copyWith({
    bool? isListening,
    bool? isProcessing,
    String? language,
    String? transcript,
    String? identifiedAction,
    String? identifiedTime,
    double? confidence,
    List<double>? soundWaves,
    List<VoiceMessage>? history,
  }) {
    return VoiceAssistantState(
      isListening: isListening ?? this.isListening,
      isProcessing: isProcessing ?? this.isProcessing,
      language: language ?? this.language,
      transcript: transcript ?? this.transcript,
      identifiedAction: identifiedAction ?? this.identifiedAction,
      identifiedTime: identifiedTime ?? this.identifiedTime,
      confidence: confidence ?? this.confidence,
      soundWaves: soundWaves ?? this.soundWaves,
      history: history ?? this.history,
    );
  }
}

class VoiceAssistantNotifier extends Notifier<VoiceAssistantState> {
  Timer? _waveTimer;

  @override
  VoiceAssistantState build() {
    ref.onDispose(() {
      _waveTimer?.cancel();
    });
    return const VoiceAssistantState();
  }

  void setLanguage(String lang) {
    if (lang == 'ta') {
      state = state.copyWith(
        language: 'ta',
        transcript: 'நாளைக்கு மாலை 5 மணிக்கு ஜிம் ஞாபகப்படுத்து',
        identifiedAction: 'நினைவூட்டல் (Gym)',
        identifiedTime: 'நாளை 5:00 PM',
      );
    } else {
      state = state.copyWith(
        language: 'en',
        transcript: 'Remind me to call Rajesh tomorrow at 10 AM regarding contract review',
        identifiedAction: 'Task Creation: Call Rajesh',
        identifiedTime: 'Tomorrow 10:00 AM',
      );
    }
  }

  void toggleListening() {
    if (state.isListening) {
      _stopListening();
    } else {
      _startListening();
    }
  }

  void _startListening() {
    _waveTimer?.cancel();
    state = state.copyWith(
      isListening: true,
      transcript: state.language == 'ta' ? 'கேட்கிறது... பேசுங்கள்...' : 'Listening... Speak now...',
    );

    int tick = 0;
    _waveTimer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
      tick++;
      final waves = [
        10.0 + (tick % 4) * 8,
        15.0 + ((tick + 1) % 5) * 7,
        25.0 + ((tick + 2) % 6) * 6,
        35.0 + ((tick + 3) % 4) * 10,
        22.0 + ((tick + 4) % 5) * 8,
        14.0 + ((tick + 5) % 3) * 6,
        12.0 + ((tick + 6) % 4) * 5,
      ];
      state = state.copyWith(soundWaves: waves);
    });
  }

  void _stopListening() {
    _waveTimer?.cancel();
    state = state.copyWith(
      isListening: false,
      isProcessing: true,
      soundWaves: const [12, 14, 12, 16, 14, 12, 10],
    );

    // Simulate Whisper STT and NLP intent extraction
    Timer(const Duration(milliseconds: 800), () {
      final isTa = state.language == 'ta';
      final text = isTa
          ? 'நாளைக்கு காலை 10 மணிக்கு ராஜேஷ் உடனான சந்திப்பை அமை'
          : 'Schedule meeting with Rajesh tomorrow at 10 AM';
      final action = isTa ? 'சந்திப்பு அமைத்தல் (Rajesh)' : 'Calendar: Meeting with Rajesh';
      final time = isTa ? 'நாளை 10:00 AM' : 'Tomorrow 10:00 AM';

      final userMsg = VoiceMessage(
        isUser: true,
        text: text,
        timestamp: DateTime.now().toIso8601String().substring(11, 16),
        intent: action,
      );

      final aiMsg = VoiceMessage(
        isUser: false,
        text: isTa
            ? 'ராஜேஷ் உடனான சந்திப்பு வெற்றிகரமாக திட்டமிடப்பட்டது.'
            : 'Scheduled meeting with Rajesh tomorrow at 10:00 AM. Added to agenda.',
        timestamp: DateTime.now().toIso8601String().substring(11, 16),
      );

      state = state.copyWith(
        isProcessing: false,
        transcript: text,
        identifiedAction: action,
        identifiedTime: time,
        confidence: 0.985,
        history: [...state.history, userMsg, aiMsg],
      );
    });
  }

  void createCalendarTaskFromIntent() {
    final title = state.identifiedAction;
    final time = state.identifiedTime;
    // Dispatch to tasksProvider directly!
    ref.read(tasksProvider.notifier).addTask(
      title: title,
      time: time,
      priority: 'Urgent',
    );
  }
}

final voiceAssistantProvider =
    NotifierProvider<VoiceAssistantNotifier, VoiceAssistantState>(VoiceAssistantNotifier.new);
