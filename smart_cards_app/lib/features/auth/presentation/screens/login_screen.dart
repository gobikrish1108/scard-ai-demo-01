import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_status_bar.dart';
import '../../../../core/widgets/app_three_dot_menu.dart';
import '../../../../core/widgets/bottom_nav_bar.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _phoneController =
      TextEditingController(text: '98401 23456');

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final authNotifier = ref.read(authProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.backgroundPeach,
      body: SafeArea(
        child: Column(
          children: [
            // Status Bar matching Image 1
            const AppStatusBar(),

            // Top Header: Brand Logo & 3-Dot Menu Button (Image 1)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.crimson600,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.crimson600.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.smart_toy_rounded,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SMART',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: AppColors.crimson600,
                              height: 1.0,
                            ),
                          ),
                          Text(
                            'CARDS',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: AppColors.crimson600,
                              height: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // 3-Dot Screens Navigator Menu
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.borderLight),
                        ),
                        child: Row(
                          children: [
                            const Text(
                              'Screens',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.crimson700,
                              ),
                            ),
                            const SizedBox(width: 2),
                            AppThreeDotMenu(iconColor: AppColors.crimson700),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Content Area with Constellation Mesh & Login Form (Image 1)
            Expanded(
              child: Stack(
                children: [
                  // Constellation Nodes Custom Paint (Image 1)
                  CustomPaint(
                    size: Size.infinite,
                    painter: _ConstellationPainter(),
                  ),

                  // Login Form Scrollable Content
                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        const Text(
                          'USER ACCESS',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                            color: AppColors.crimson700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textDark,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Login Card Container (Image 1)
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.95),
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(color: AppColors.borderLight),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.crimson600.withOpacity(0.08),
                                blurRadius: 25,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Mobile label & WhatsApp toggle (Image 1)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Mobile Number',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: authNotifier.toggleWhatsApp,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF1F5F9),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 24,
                                            height: 24,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFF10B981),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Center(
                                              child: Icon(
                                                Icons.chat_bubble_rounded,
                                                color: Colors.white,
                                                size: 13,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Container(
                                            width: 14,
                                            height: 14,
                                            decoration: BoxDecoration(
                                              color: authState.isWhatsAppEnabled
                                                  ? AppColors.emeraldSuccess
                                                  : Colors.grey.shade400,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Country code picker & Phone input (Image 1)
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(color: const Color(0xFFE2E8F0)),
                                ),
                                child: Row(
                                  children: [
                                    // Country Dropdown Button
                                    GestureDetector(
                                      onTap: () => _showCountryPicker(context, authNotifier),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 12),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(color: const Color(0xFFE2E8F0)),
                                        ),
                                        child: Row(
                                          children: [
                                            Text(authState.countryFlag, style: const TextStyle(fontSize: 16)),
                                            const SizedBox(width: 4),
                                            Text(
                                              authState.countryCode,
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.textDark,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: Colors.grey),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),

                                    // Phone Number Input Field
                                    Expanded(
                                      child: TextField(
                                        controller: _phoneController,
                                        keyboardType: TextInputType.phone,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textDark,
                                        ),
                                        decoration: const InputDecoration(
                                          hintText: 'Enter 10-digit number',
                                          hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.symmetric(horizontal: 8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),

                              // Warning note (Image 1)
                              const Row(
                                children: [
                                  Icon(Icons.info_outline_rounded, size: 13, color: AppColors.crimson600),
                                  SizedBox(width: 4),
                                  Text(
                                    '* Please ensure phone is reachable for OTP.',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.crimson600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),

                              // Send OTP Button
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {
                                    authNotifier.sendOtp();
                                    _showOtpBottomSheet(context, authNotifier, authState);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.crimson600,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 4,
                                    shadowColor: AppColors.crimson600.withOpacity(0.4),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Send Secure OTP',
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(Icons.arrow_forward_rounded, size: 16, color: Colors.white),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Instant 1-Click Demo Login
                              SizedBox(
                                width: double.infinity,
                                height: 42,
                                child: OutlinedButton(
                                  onPressed: () {
                                    authNotifier.instantDemoLogin();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Instant Demo Login: Welcome, Remakanth!'),
                                        backgroundColor: AppColors.crimson700,
                                      ),
                                    );
                                    context.go('/card');
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.crimson700,
                                    side: const BorderSide(color: AppColors.borderLight),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    backgroundColor: AppColors.crimson50,
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.bolt_rounded, size: 16, color: AppColors.amberWarning),
                                      SizedBox(width: 6),
                                      Text(
                                        '1-Click Instant Demo Login',
                                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Privacy Note
                        const Center(
                          child: Text(
                            'By proceeding you agree to encrypted access & privacy policies.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Navigation Bar
            const BottomNavBar(currentRoute: '/login'),
          ],
        ),
      ),
    );
  }

  void _showCountryPicker(BuildContext context, AuthNotifier notifier) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        final countries = [
          {'flag': '🇮🇳', 'code': '+91', 'name': 'India'},
          {'flag': '🇦🇪', 'code': '+971', 'name': 'UAE'},
          {'flag': '🇺🇸', 'code': '+1', 'name': 'United States'},
          {'flag': '🇬🇧', 'code': '+44', 'name': 'United Kingdom'},
          {'flag': '🇸🇬', 'code': '+65', 'name': 'Singapore'},
          {'flag': '🇸🇦', 'code': '+966', 'name': 'Saudi Arabia'},
        ];

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'SELECT COUNTRY',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMuted,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 10),
              ...countries.map((c) => ListTile(
                    leading: Text(c['flag']!, style: const TextStyle(fontSize: 22)),
                    title: Text(c['name']!, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                    trailing: Text(c['code']!, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.crimson600)),
                    onTap: () {
                      notifier.setCountry(c['flag']!, c['code']!, c['name']!);
                      Navigator.pop(context);
                    },
                  )),
            ],
          ),
        );
      },
    );
  }

  void _showOtpBottomSheet(BuildContext context, AuthNotifier notifier, AuthState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'TWO-FACTOR AUTHENTICATION',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      color: AppColors.crimson600,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Text(
                'Verify Mobile Number',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark),
              ),
              const SizedBox(height: 4),
              Text(
                'Enter 6-digit code sent to ${state.countryCode} ${_phoneController.text}',
                style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
              const SizedBox(height: 20),

              // 6 OTP Digit Boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: ['7', '3', '9', '2', '0', '4'].map((digit) {
                  return Container(
                    width: 44,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: Center(
                      child: Text(
                        digit,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    notifier.verifyOtpAndLogin();
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('2FA Authentication Successful! Welcome, Remakanth'),
                        backgroundColor: AppColors.crimson700,
                      ),
                    );
                    context.go('/card');
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle_outline_rounded, size: 18, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Verify & Enter Platform', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }
}

// Geometric Constellation SVG painter matching Image 1
class _ConstellationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintLine = Paint()
      ..color = AppColors.crimson500.withOpacity(0.35)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final paintNode = Paint()
      ..color = AppColors.crimson600
      ..style = PaintingStyle.fill;

    final p1 = Offset(size.width * 0.1, size.height * 0.85);
    final p2 = Offset(size.width * 0.3, size.height * 0.70);
    final p3 = Offset(size.width * 0.5, size.height * 0.82);
    final p4 = Offset(size.width * 0.8, size.height * 0.65);
    final p5 = Offset(size.width * 0.9, size.height * 0.78);
    final p6 = Offset(size.width * 0.45, size.height * 0.52);
    final p7 = Offset(size.width * 0.7, size.height * 0.48);

    canvas.drawLine(p1, p2, paintLine);
    canvas.drawLine(p2, p3, paintLine);
    canvas.drawLine(p3, p4, paintLine);
    canvas.drawLine(p4, p5, paintLine);
    canvas.drawLine(p2, p6, paintLine);
    canvas.drawLine(p6, p7, paintLine);
    canvas.drawLine(p7, p4, paintLine);
    canvas.drawLine(p3, p6, paintLine);

    canvas.drawCircle(p1, 4.0, paintNode);
    canvas.drawCircle(p2, 4.5, paintNode);
    canvas.drawCircle(p3, 4.0, paintNode);
    canvas.drawCircle(p4, 4.5, paintNode);
    canvas.drawCircle(p5, 4.0, paintNode);
    canvas.drawCircle(p6, 5.0, paintNode);
    canvas.drawCircle(p7, 4.0, paintNode);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
