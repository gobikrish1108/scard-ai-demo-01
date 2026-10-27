import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  final String phoneNumber;
  final String countryCode;
  final String countryFlag;
  final String countryName;
  final bool isWhatsAppEnabled;
  final bool isAuthenticated;
  final bool isOtpSent;

  const AuthState({
    this.phoneNumber = '98401 23456',
    this.countryCode = '+91',
    this.countryFlag = '🇮🇳',
    this.countryName = 'India',
    this.isWhatsAppEnabled = false,
    this.isAuthenticated = false,
    this.isOtpSent = false,
  });

  AuthState copyWith({
    String? phoneNumber,
    String? countryCode,
    String? countryFlag,
    String? countryName,
    bool? isWhatsAppEnabled,
    bool? isAuthenticated,
    bool? isOtpSent,
  }) {
    return AuthState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      countryCode: countryCode ?? this.countryCode,
      countryFlag: countryFlag ?? this.countryFlag,
      countryName: countryName ?? this.countryName,
      isWhatsAppEnabled: isWhatsAppEnabled ?? this.isWhatsAppEnabled,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isOtpSent: isOtpSent ?? this.isOtpSent,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState();

  void setPhoneNumber(String number) {
    state = state.copyWith(phoneNumber: number);
  }

  void setCountry(String flag, String code, String name) {
    state = state.copyWith(
      countryFlag: flag,
      countryCode: code,
      countryName: name,
    );
  }

  void toggleWhatsApp() {
    state = state.copyWith(isWhatsAppEnabled: !state.isWhatsAppEnabled);
  }

  void sendOtp() {
    state = state.copyWith(isOtpSent: true);
  }

  void cancelOtp() {
    state = state.copyWith(isOtpSent: false);
  }

  void verifyOtpAndLogin() {
    state = state.copyWith(isAuthenticated: true, isOtpSent: false);
  }

  void instantDemoLogin() {
    state = state.copyWith(isAuthenticated: true, isOtpSent: false);
  }

  void logout() {
    state = const AuthState();
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
