import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_status_bar.dart';
import '../../../../core/widgets/app_three_dot_menu.dart';
import '../../../../core/widgets/bottom_nav_bar.dart';
import '../providers/voice_assistant_provider.dart';

class VoiceAssistantScreen extends ConsumerWidget {
  const VoiceAssistantScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final voiceState = ref.watch(voiceAssistantProvider);
    final voiceNotifier = ref.read(voiceAssistantProvider.notifier);
    final isTamil = voiceState.language == 'ta';

    return Scaffold(
      backgroundColor: AppColors.backgroundPeach,
      body: SafeArea(
        child: Column(
          children: [
            const AppStatusBar(),
            // Top Nav
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textDark),
                        onPressed: () => context.go('/dashboard'),
                      ),
                      const Text(
                        'Voice Assistant',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      // Language Switcher: English vs Tamil
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.borderLight),
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => voiceNotifier.setLanguage('en'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: !isTamil ? AppColors.crimson600 : Colors.transparent,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  'EN',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: !isTamil ? Colors.white : AppColors.textDark,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => voiceNotifier.setLanguage('ta'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isTamil ? AppColors.crimson600 : Colors.transparent,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  'தமிழ்',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: isTamil ? Colors.white : AppColors.textDark,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      const AppThreeDotMenu(),
                    ],
                  ),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    // Sound wave visualizer driven by Riverpod state
                    SizedBox(
                      height: 48,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: voiceState.soundWaves
                            .map(
                              (height) => AnimatedContainer(
                                duration: const Duration(milliseconds: 120),
                                margin: const EdgeInsets.symmetric(horizontal: 3),
                                width: 5,
                                height: height,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [AppColors.crimson500, AppColors.crimsonDeep],
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Big Animated Mic Button with Pulsing Ring
                    GestureDetector(
                      onTap: () => voiceNotifier.toggleListening(),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (voiceState.isListening)
                            Container(
                              width: 110,
                              height: 110,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.crimson600.withValues(alpha: 0.2),
                              ),
                            ),
                          Container(
                            width: 86,
                            height: 86,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [AppColors.crimson500, AppColors.crimsonDeep],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.crimson600.withValues(alpha: 0.45),
                                  blurRadius: 22,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                voiceState.isListening ? Icons.stop_rounded : Icons.mic_rounded,
                                color: Colors.white,
                                size: 38,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      voiceState.isListening
                          ? (isTamil ? 'பேசுங்கள்... கேட்கிறது...' : 'Listening... Speak now')
                          : (isTamil ? 'மைக் பொத்தானைத் தட்டவும்' : 'Tap microphone to speak'),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Live Transcript Box
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.borderLight),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                isTamil ? 'நேரலை உரை (WHISPER AI)' : 'LIVE TRANSCRIPT (WHISPER AI)',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textMuted,
                                  letterSpacing: 0.8,
                                ),
                              ),
                              if (voiceState.isProcessing)
                                const Row(
                                  children: [
                                    SizedBox(
                                      width: 10,
                                      height: 10,
                                      child: CircularProgressIndicator(strokeWidth: 1.5, color: AppColors.crimson600),
                                    ),
                                    SizedBox(width: 6),
                                    Text('Parsing...', style: TextStyle(fontSize: 10, color: AppColors.crimson600)),
                                  ],
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '"${voiceState.transcript}"',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.italic,
                              color: AppColors.textDark,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Parsed Intent Box
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.crimson50,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.crimson600.withValues(alpha: 0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                isTamil ? 'அடையாளம் காணப்பட்ட செயல்' : 'IDENTIFIED INTENT & ACTION',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.crimson700,
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.check_circle_rounded, size: 12, color: AppColors.emeraldSuccess),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${(voiceState.confidence * 100).toInt()}% Confidence',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.emeraldSuccess,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: AppColors.borderLight),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(isTamil ? 'செயல்' : 'Action Type', style: const TextStyle(fontSize: 9.5, color: AppColors.textMuted)),
                                      const SizedBox(height: 2),
                                      Text(
                                        voiceState.identifiedAction,
                                        style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: AppColors.textDark),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: AppColors.borderLight),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(isTamil ? 'நேரம்' : 'Schedule', style: const TextStyle(fontSize: 9.5, color: AppColors.textMuted)),
                                      const SizedBox(height: 2),
                                      Text(
                                        voiceState.identifiedTime,
                                        style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: AppColors.textDark),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                voiceNotifier.createCalendarTaskFromIntent();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Created task: "${voiceState.identifiedAction}" in Unified Calendar!'),
                                    backgroundColor: AppColors.emeraldSuccess,
                                  ),
                                );
                              },
                              icon: const Icon(Icons.add_task_rounded, size: 16),
                              label: Text(isTamil ? 'நாட்காட்டியில் சேர்க்கவும்' : 'Confirm & Add to Calendar Tasks'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.crimson600,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Conversation History
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        isTamil ? 'முந்தைய உரையாடல்கள்' : 'CONVERSATION HISTORY',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textMuted,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: voiceState.history.length,
                      itemBuilder: (context, index) {
                        final msg = voiceState.history[index];
                        return Align(
                          alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
                            decoration: BoxDecoration(
                              color: msg.isUser ? AppColors.crimson600 : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: msg.isUser ? null : Border.all(color: AppColors.borderLight),
                            ),
                            child: Column(
                              crossAxisAlignment: msg.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                              children: [
                                Text(
                                  msg.text,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: msg.isUser ? Colors.white : AppColors.textDark,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  msg.timestamp,
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: msg.isUser ? Colors.white70 : AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            const BottomNavBar(currentRoute: '/voice'),
          ],
        ),
      ),
    );
  }
}
