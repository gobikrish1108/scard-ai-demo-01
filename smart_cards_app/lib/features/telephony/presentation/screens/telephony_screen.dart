import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/telephony_provider.dart';

class TelephonyScreen extends ConsumerWidget {
  const TelephonyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final call = ref.watch(telephonyProvider);
    final notifier = ref.read(telephonyProvider.notifier);

    final mins = (call.callDurationSeconds ~/ 60).toString().padLeft(2, '0');
    final secs = (call.callDurationSeconds % 60).toString().padLeft(2, '0');
    final isConnected = call.status == CallStatus.connected;
    final isEnded = call.status == CallStatus.ended;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF020617), Color(0xFF0F172A), AppColors.crimsonDeep],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Header & Caller Info
              Padding(
                padding: const EdgeInsets.only(top: 36, left: 20, right: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white70),
                          onPressed: () => context.go('/dashboard'),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text(
                            'SIP TELEPHONY BRIDGE',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Colors.white70),
                          ),
                        ),
                        const SizedBox(width: 48), // Balance spacing
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      call.callerName,
                      style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.5),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      call.callerNumber,
                      style: const TextStyle(fontSize: 13, color: Colors.white60),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      isEnded
                          ? 'Call Ended'
                          : isConnected
                              ? '$mins:$secs'
                              : 'Incoming Audio Call...',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isConnected ? AppColors.emeraldSuccess : const Color(0xFFFFD3C7),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.crimson600.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.crimson500.withValues(alpha: 0.5)),
                      ),
                      child: Text(
                        call.escalationReason,
                        style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),

              // Center Avatar or Live Transcript
              if (isConnected)
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.graphic_eq_rounded, size: 16, color: AppColors.emeraldSuccess),
                            SizedBox(width: 8),
                            Text(
                              'REAL-TIME BILINGUAL CALL TRANSCRIPT',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white60, letterSpacing: 0.8),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: ListView.separated(
                            itemCount: call.liveTranscript.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final text = call.liveTranscript[index];
                              final isAi = text.startsWith('AI:');
                              return Text(
                                text,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isAi ? const Color(0xFFFFE4DE) : Colors.white,
                                  fontStyle: isAi ? FontStyle.italic : FontStyle.normal,
                                  height: 1.35,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.crimson600,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.crimson500.withValues(alpha: 0.4),
                        blurRadius: 36,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(Icons.smart_toy_rounded, size: 54, color: Colors.white),
                  ),
                ),

              // Bottom Call Buttons
              Padding(
                padding: const EdgeInsets.only(bottom: 40, left: 30, right: 30),
                child: isConnected
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: Icon(call.isMuted ? Icons.mic_off_rounded : Icons.mic_rounded, color: Colors.white, size: 28),
                            onPressed: () => notifier.toggleMute(),
                          ),
                          FloatingActionButton(
                            heroTag: 'btn_end_active',
                            backgroundColor: Colors.red,
                            onPressed: () {
                              notifier.endCall();
                              context.go('/dashboard');
                            },
                            child: const Icon(Icons.call_end_rounded, color: Colors.white),
                          ),
                          IconButton(
                            icon: Icon(call.isSpeaker ? Icons.volume_up_rounded : Icons.volume_down_rounded, color: Colors.white, size: 28),
                            onPressed: () => notifier.toggleSpeaker(),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Decline / Back
                          Column(
                            children: [
                              FloatingActionButton(
                                heroTag: 'btn_decline',
                                backgroundColor: Colors.red,
                                onPressed: () {
                                  notifier.endCall();
                                  context.go('/dashboard');
                                },
                                child: const Icon(Icons.call_end_rounded, color: Colors.white),
                              ),
                              const SizedBox(height: 8),
                              const Text('Decline', style: TextStyle(color: Colors.white70, fontSize: 11)),
                            ],
                          ),

                          // Answer Call
                          Column(
                            children: [
                              FloatingActionButton(
                                heroTag: 'btn_answer',
                                backgroundColor: AppColors.emeraldSuccess,
                                onPressed: () => notifier.answerCall(),
                                child: const Icon(Icons.call_rounded, color: Colors.white),
                              ),
                              const SizedBox(height: 8),
                              const Text('Answer & Screen', style: TextStyle(color: Colors.white70, fontSize: 11)),
                            ],
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
