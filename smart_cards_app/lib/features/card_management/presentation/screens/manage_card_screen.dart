import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_status_bar.dart';
import '../../../../core/widgets/app_three_dot_menu.dart';
import '../../../../core/widgets/bottom_nav_bar.dart';
import '../providers/card_provider.dart';

class ManageCardScreen extends ConsumerWidget {
  const ManageCardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardState = ref.watch(cardProvider);
    final cardNotifier = ref.read(cardProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.backgroundPeach,
      body: SafeArea(
        child: Column(
          children: [
            // Dark Crimson Status Bar matching Image 2
            Container(
              color: AppColors.crimsonDeep,
              child: const AppStatusBar(isDark: true),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Deep Rich Red Gradient Header Banner (Image 2)
                    Container(
                      padding: const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 28),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.crimsonDeep,
                            AppColors.crimson700,
                            AppColors.crimson600,
                          ],
                        ),
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 15,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Header Nav: Back Button, Title, 3-Dot Menu, Avatar
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                                onPressed: () => context.go('/dashboard'),
                              ),
                              const Text(
                                'Manage Card Details',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              Row(
                                children: [
                                  const AppThreeDotMenu(iconColor: Colors.white),
                                  const SizedBox(width: 4),
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.amber, width: 2),
                                      image: DecorationImage(
                                        image: NetworkImage(cardState.avatarUrl),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Profile Avatar with Camera Upload Badge (Image 2)
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Container(
                                width: 84,
                                height: 84,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 3.5),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 10,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                  image: DecorationImage(
                                    image: NetworkImage(cardState.avatarUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Container(
                                width: 26,
                                height: 26,
                                decoration: BoxDecoration(
                                  color: AppColors.crimson600,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 13),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Person Name & Role
                          Text(
                            cardState.fullName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            cardState.designation,
                            style: const TextStyle(
                              color: Color(0xFFFFE4DE),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Body Cards (Image 2)
                    Transform.translate(
                      offset: const Offset(0, -16),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            // 1. Company Logo Badge Card (Image 2)
                            _buildCardContainer(
                              child: Column(
                                children: [
                                  Stack(
                                    clipBehavior: Clip.none,
                                    alignment: Alignment.bottomRight,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF8FAFC),
                                          borderRadius: BorderRadius.circular(14),
                                          border: Border.all(color: const Color(0xFFF1F5F9)),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              width: 14,
                                              height: 14,
                                              decoration: const BoxDecoration(
                                                color: AppColors.crimson600,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Center(
                                                child: Icon(Icons.wifi, size: 9, color: Colors.white),
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            const Text(
                                              'antz',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w900,
                                                color: AppColors.textDark,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            const Text(
                                              'MEDIA',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.crimson600,
                                                letterSpacing: 1.2,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        right: -6,
                                        bottom: -4,
                                        child: Container(
                                          width: 22,
                                          height: 22,
                                          decoration: BoxDecoration(
                                            color: AppColors.crimson600,
                                            shape: BoxShape.circle,
                                            border: Border.all(color: Colors.white, width: 2),
                                          ),
                                          child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 11),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    cardState.organisation,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),

                            // 2. Professional Details Card with Edit Pill (Image 2)
                            _buildCardContainer(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'PROFESSIONAL DETAILS',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.textMuted,
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                                      _buildEditButton(
                                        context,
                                        onTap: () => _showEditProfessionalDialog(context, cardNotifier, cardState),
                                      ),
                                    ],
                                  ),
                                  const Divider(height: 20, color: Color(0xFFF1F5F9)),
                                  _buildDetailRow(
                                    icon: Icons.business_rounded,
                                    label: 'Organisation',
                                    value: cardState.organisation,
                                  ),
                                  const Divider(height: 16, color: Color(0xFFF8FAFC)),
                                  _buildDetailRow(
                                    icon: Icons.work_outline_rounded,
                                    label: 'Designation',
                                    value: cardState.designation,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),

                            // 3. Professional Address Card with Edit Pill (Image 2)
                            _buildCardContainer(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'PROFESSIONAL ADDRESS',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.textMuted,
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                                      _buildEditButton(
                                        context,
                                        onTap: () => _showEditAddressDialog(context, cardNotifier, cardState),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 36,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF1F5F9),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: const Icon(Icons.location_on_rounded, size: 18, color: AppColors.crimson600),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          cardState.address,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.textDark,
                                            height: 1.4,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),

                            // 4. NFC Smart Card Connected Card (Image 2)
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.crimson50,
                                    AppColors.crimson100.withOpacity(0.4),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: AppColors.borderLight),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'NFC Smart Card Connected',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.crimsonDeep,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'ID: ${cardState.nfcCardId} • Tap-to-Share Ready',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: AppColors.textMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () => _showShareCardModal(context, cardState),
                                    icon: const Icon(Icons.qr_code_rounded, size: 16),
                                    label: const Text('Share Card', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.crimson600,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Navigation Bar matching Image 2
            const BottomNavBar(currentRoute: '/card'),
          ],
        ),
      ),
    );
  }

  Widget _buildCardContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: AppColors.crimson600.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildEditButton(BuildContext context, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.edit_rounded, size: 11, color: AppColors.textDark),
            SizedBox(width: 4),
            Text(
              'Edit',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: AppColors.textDark),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ],
        ),
        const Icon(Icons.chevron_right_rounded, size: 18, color: Color(0xFFCBD5E1)),
      ],
    );
  }

  void _showEditProfessionalDialog(
    BuildContext context,
    CardNotifier notifier,
    CardState state,
  ) {
    final orgCtrl = TextEditingController(text: state.organisation);
    final desigCtrl = TextEditingController(text: state.designation);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Edit Professional Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: orgCtrl,
              decoration: const InputDecoration(labelText: 'Organisation'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: desigCtrl,
              decoration: const InputDecoration(labelText: 'Designation'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              notifier.updateProfessionalDetails(
                organisation: orgCtrl.text,
                designation: desigCtrl.text,
              );
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Professional details updated successfully!'),
                  backgroundColor: AppColors.crimson700,
                ),
              );
            },
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }

  void _showEditAddressDialog(
    BuildContext context,
    CardNotifier notifier,
    CardState state,
  ) {
    final addrCtrl = TextEditingController(text: state.address);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Edit Professional Address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        content: TextField(
          controller: addrCtrl,
          maxLines: 3,
          decoration: const InputDecoration(labelText: 'Full Address'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              notifier.updateAddress(addrCtrl.text);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Address updated!'),
                  backgroundColor: AppColors.crimson700,
                ),
              );
            },
            child: const Text('Save Address'),
          ),
        ],
      ),
    );
  }

  void _showShareCardModal(BuildContext context, CardState state) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'SHARE SMART CARD',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  color: AppColors.crimson600,
                ),
              ),
              const SizedBox(height: 14),
              // Dynamic QR Code using qr_flutter
              Container(
                width: 140,
                height: 140,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: QrImageView(
                  data: 'https://smartcards.ai/remakanth-antzmedia',
                  version: QrVersions.auto,
                  size: 130.0,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '${state.fullName} • ${state.organisation}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const Text('Scan with phone camera or tap via NFC', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Copied link: https://smartcards.ai/remakanth')),
                        );
                      },
                      icon: const Icon(Icons.link_rounded, size: 16),
                      label: const Text('Copy Link'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Simulated NFC Beam: Contact transmitted!'),
                            backgroundColor: AppColors.crimson700,
                          ),
                        );
                      },
                      icon: const Icon(Icons.nfc_rounded, size: 16),
                      label: const Text('Tap NFC'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
