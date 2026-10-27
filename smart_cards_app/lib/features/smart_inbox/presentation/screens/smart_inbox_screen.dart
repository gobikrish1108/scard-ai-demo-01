import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_status_bar.dart';
import '../../../../core/widgets/app_three_dot_menu.dart';
import '../../../../core/widgets/bottom_nav_bar.dart';
import '../providers/smart_inbox_provider.dart';

class SmartInboxScreen extends ConsumerStatefulWidget {
  const SmartInboxScreen({super.key});

  @override
  ConsumerState<SmartInboxScreen> createState() => _SmartInboxScreenState();
}

class _SmartInboxScreenState extends ConsumerState<SmartInboxScreen> {
  String selectedFilter = 'VIP'; // 'All', 'VIP', 'Unreplied'

  @override
  Widget build(BuildContext context) {
    final allEmails = ref.watch(smartInboxProvider);
    final inboxNotifier = ref.read(smartInboxProvider.notifier);

    final filteredEmails = allEmails.where((e) {
      if (selectedFilter == 'VIP') return e.isVip;
      if (selectedFilter == 'Unreplied') return !e.isReplied;
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundPeach,
      body: SafeArea(
        child: Column(
          children: [
            const AppStatusBar(),
            // Top App Bar
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
                        'Smart Inbox',
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
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.crimson600.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '${allEmails.where((e) => !e.isReplied).length} Pending',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.crimson600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const AppThreeDotMenu(),
                    ],
                  ),
                ],
              ),
            ),

            // Filter Chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Row(
                children: [
                  _buildFilterChip('VIP', 'VIP Priority (${allEmails.where((e) => e.isVip).length})'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Unreplied', 'Needs Action'),
                  const SizedBox(width: 8),
                  _buildFilterChip('All', 'All Emails (${allEmails.length})'),
                ],
              ),
            ),

            // Email List
            Expanded(
              child: filteredEmails.isEmpty
                  ? const Center(
                      child: Text(
                        'No emails in this filter',
                        style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      itemCount: filteredEmails.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final email = filteredEmails[index];
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: email.isReplied ? AppColors.borderLight : AppColors.crimson600.withValues(alpha: 0.25),
                              width: email.isReplied ? 1.0 : 1.4,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 16,
                                        backgroundColor: email.isVip
                                            ? AppColors.amberWarning.withValues(alpha: 0.2)
                                            : AppColors.crimson50,
                                        child: Text(
                                          email.senderName.substring(0, 2).toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: email.isVip ? AppColors.amberWarning : AppColors.crimson600,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            email.senderName,
                                            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: AppColors.textDark),
                                          ),
                                          Text(
                                            email.receivedTime,
                                            style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      if (email.isVip)
                                        Container(
                                          margin: const EdgeInsets.only(right: 6),
                                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: AppColors.crimson50,
                                            borderRadius: BorderRadius.circular(6),
                                            border: Border.all(color: AppColors.crimson600.withValues(alpha: 0.2)),
                                          ),
                                          child: Text(
                                            email.category,
                                            style: const TextStyle(
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.crimson700,
                                            ),
                                          ),
                                        ),
                                      IconButton(
                                        icon: Icon(
                                          email.isVip ? Icons.star_rounded : Icons.star_border_rounded,
                                          size: 18,
                                          color: email.isVip ? AppColors.amberWarning : AppColors.textMuted,
                                        ),
                                        onPressed: () => inboxNotifier.toggleVip(email.id),
                                        constraints: const BoxConstraints(),
                                        padding: EdgeInsets.zero,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                email.subject,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textDark,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                email.preview,
                                style: const TextStyle(fontSize: 11.5, color: AppColors.textMuted, height: 1.3),
                              ),
                              const SizedBox(height: 12),

                              // AI Generated Draft Reply Box
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.crimson50,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: AppColors.crimson600.withValues(alpha: 0.15)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Row(
                                          children: [
                                            Icon(Icons.auto_awesome_rounded, size: 13, color: AppColors.crimson600),
                                            SizedBox(width: 5),
                                            Text(
                                              'Contextual AI Draft Reply',
                                              style: TextStyle(
                                                fontSize: 10.5,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.crimson700,
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (!email.isReplied)
                                          InkWell(
                                            onTap: () => _showEditDraftDialog(context, email, inboxNotifier),
                                            child: const Text(
                                              'Edit Draft',
                                              style: TextStyle(
                                                fontSize: 10.5,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.crimson600,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      '"${email.aiDraft}"',
                                      style: const TextStyle(
                                        fontSize: 11.5,
                                        fontStyle: FontStyle.italic,
                                        color: AppColors.textDark,
                                        height: 1.35,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Actions
                              if (email.isReplied)
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: AppColors.emeraldSuccess.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.check_circle_rounded, size: 14, color: AppColors.emeraldSuccess),
                                      SizedBox(width: 6),
                                      Text(
                                        'Replied via Secure Outbox',
                                        style: TextStyle(
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.emeraldSuccess,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              else
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          inboxNotifier.approveAndSendReply(email.id);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Dispatched AI draft to ${email.senderName}!'),
                                              backgroundColor: AppColors.emeraldSuccess,
                                            ),
                                          );
                                        },
                                        icon: const Icon(Icons.send_rounded, size: 14),
                                        label: const Text(
                                          'Approve & Send Reply',
                                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                        ),
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
                            ],
                          ),
                        );
                      },
                    ),
            ),
            const BottomNavBar(currentRoute: '/emails'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String filterKey, String label) {
    final isSelected = selectedFilter == filterKey;
    return GestureDetector(
      onTap: () => setState(() => selectedFilter = filterKey),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.crimson600 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.crimson600 : AppColors.borderLight,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : AppColors.textDark,
          ),
        ),
      ),
    );
  }

  void _showEditDraftDialog(BuildContext context, SmartEmail email, SmartInboxNotifier notifier) {
    final controller = TextEditingController(text: email.aiDraft);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Edit AI Draft Reply', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        content: TextField(
          controller: controller,
          maxLines: 4,
          style: const TextStyle(fontSize: 12),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            hintText: 'Type your reply...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              notifier.updateDraft(email.id, controller.text);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.crimson600,
              foregroundColor: Colors.white,
            ),
            child: const Text('Save Draft'),
          ),
        ],
      ),
    );
  }
}
