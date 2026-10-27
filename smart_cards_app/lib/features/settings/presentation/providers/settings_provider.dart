import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsState {
  final String timezone;
  final String voiceLanguage;
  final String subscriptionTier;
  final int voiceMinutesUsed;
  final int voiceMinutesLimit;
  final bool strictPromptInjection;
  final bool offlineDataSync;
  final bool memoryPurged;
  final String renewDate;

  const SettingsState({
    this.timezone = 'Asia/Kolkata (IST +5:30)',
    this.voiceLanguage = 'Bilingual (EN / தமிழ்)',
    this.subscriptionTier = 'PRO PLAN',
    this.voiceMinutesUsed = 1420,
    this.voiceMinutesLimit = 5000,
    this.strictPromptInjection = true,
    this.offlineDataSync = true,
    this.memoryPurged = false,
    this.renewDate = 'Nov 26, 2026',
  });

  SettingsState copyWith({
    String? timezone,
    String? voiceLanguage,
    String? subscriptionTier,
    int? voiceMinutesUsed,
    int? voiceMinutesLimit,
    bool? strictPromptInjection,
    bool? offlineDataSync,
    bool? memoryPurged,
    String? renewDate,
  }) {
    return SettingsState(
      timezone: timezone ?? this.timezone,
      voiceLanguage: voiceLanguage ?? this.voiceLanguage,
      subscriptionTier: subscriptionTier ?? this.subscriptionTier,
      voiceMinutesUsed: voiceMinutesUsed ?? this.voiceMinutesUsed,
      voiceMinutesLimit: voiceMinutesLimit ?? this.voiceMinutesLimit,
      strictPromptInjection: strictPromptInjection ?? this.strictPromptInjection,
      offlineDataSync: offlineDataSync ?? this.offlineDataSync,
      memoryPurged: memoryPurged ?? this.memoryPurged,
      renewDate: renewDate ?? this.renewDate,
    );
  }
}

class SettingsNotifier extends Notifier<SettingsState> {
  @override
  SettingsState build() => const SettingsState();

  void togglePromptInjection(bool val) {
    state = state.copyWith(strictPromptInjection: val);
  }

  void toggleOfflineSync(bool val) {
    state = state.copyWith(offlineDataSync: val);
  }

  void purgeMemoryStore() {
    state = state.copyWith(
      memoryPurged: true,
      voiceMinutesUsed: 0,
    );
  }

  void updateLanguage(String lang) {
    state = state.copyWith(voiceLanguage: lang);
  }

  void upgradePlan(String planTier) {
    state = state.copyWith(
      subscriptionTier: planTier,
      voiceMinutesLimit: planTier == 'ENTERPRISE' ? 25000 : 5000,
    );
  }
}

final settingsProvider =
    NotifierProvider<SettingsNotifier, SettingsState>(SettingsNotifier.new);
