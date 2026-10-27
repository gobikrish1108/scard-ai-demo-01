import 'package:flutter_riverpod/flutter_riverpod.dart';

class CardState {
  final String fullName;
  final String designation;
  final String organisation;
  final String address;
  final String phone;
  final String email;
  final String nfcCardId;
  final String avatarUrl;

  const CardState({
    this.fullName = 'Remakanth R',
    this.designation = 'Chief Evangelist',
    this.organisation = 'Antz Media Digital',
    this.address = 'Level 4, Antz Tech Hub, T. Nagar, Chennai, Tamil Nadu 600017',
    this.phone = '+91 98401 23456',
    this.email = 'remakanth@antzmedia.com',
    this.nfcCardId = 'SC-89241',
    this.avatarUrl = 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=200&h=200&q=80',
  });

  CardState copyWith({
    String? fullName,
    String? designation,
    String? organisation,
    String? address,
    String? phone,
    String? email,
    String? nfcCardId,
    String? avatarUrl,
  }) {
    return CardState(
      fullName: fullName ?? this.fullName,
      designation: designation ?? this.designation,
      organisation: organisation ?? this.organisation,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      nfcCardId: nfcCardId ?? this.nfcCardId,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}

class CardNotifier extends Notifier<CardState> {
  @override
  CardState build() => const CardState();

  void updateProfessionalDetails({
    required String organisation,
    required String designation,
  }) {
    state = state.copyWith(
      organisation: organisation,
      designation: designation,
    );
  }

  void updateAddress(String address) {
    state = state.copyWith(address: address);
  }

  void updateContact({required String phone, required String email}) {
    state = state.copyWith(phone: phone, email: email);
  }
}

final cardProvider = NotifierProvider<CardNotifier, CardState>(CardNotifier.new);
