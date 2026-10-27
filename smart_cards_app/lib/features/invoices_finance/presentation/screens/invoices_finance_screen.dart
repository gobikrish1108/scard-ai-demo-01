import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_status_bar.dart';
import '../../../../core/widgets/app_three_dot_menu.dart';
import '../../../../core/widgets/bottom_nav_bar.dart';
import '../providers/invoices_provider.dart';

class InvoicesFinanceScreen extends ConsumerWidget {
  const InvoicesFinanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoices = ref.watch(invoicesProvider);
    final invoicesNotifier = ref.read(invoicesProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.backgroundPeach,
      body: SafeArea(
        child: Column(
          children: [
            const AppStatusBar(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_rounded),
                        onPressed: () => context.go('/dashboard'),
                      ),
                      const Text(
                        'Invoices & Finance',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _showCreateInvoiceDialog(context, invoicesNotifier),
                        icon: const Icon(Icons.add_rounded, size: 14),
                        label: const Text('Create', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.emeraldSuccess,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const AppThreeDotMenu(),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Financial Metric Cards
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.borderLight)),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('TOTAL INVOICED', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.textMuted)),
                                SizedBox(height: 4),
                                Text('₹ 4,85,000', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.textDark)),
                                SizedBox(height: 2),
                                Text('+18% vs Last Month', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.emeraldSuccess)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.borderLight)),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('PENDING COLLECTION', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.textMuted)),
                                SizedBox(height: 4),
                                Text('₹ 1,20,000', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.crimson600)),
                                SizedBox(height: 2),
                                Text('1 Overdue Invoice', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.crimson600)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    const Text('RECENT INVOICES (AUTO-GST 18%)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textMuted)),
                    const SizedBox(height: 10),

                    // Invoices List
                    ...invoices.map((inv) => Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.borderLight)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(inv.invoiceNumber, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: inv.status == 'Paid' ? const Color(0xFFECFDF5) : AppColors.crimson50,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      inv.status,
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                        color: inv.status == 'Paid' ? AppColors.emeraldSuccess : AppColors.crimson600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Client: ${inv.clientName}', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                                  Text('₹ ${inv.totalAmount.toStringAsFixed(0)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.textDark)),
                                ],
                              ),
                              const Divider(height: 16, color: Color(0xFFF1F5F9)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Due: ${inv.dueDate}', style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
                                  Row(
                                    children: [
                                      TextButton.icon(
                                        onPressed: () {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Dispatched to client WhatsApp!'), backgroundColor: AppColors.emeraldSuccess),
                                          );
                                        },
                                        icon: const Icon(Icons.send_rounded, size: 12, color: AppColors.emeraldSuccess),
                                        label: const Text('WhatsApp', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.emeraldSuccess)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            const BottomNavBar(currentRoute: '/invoices'),
          ],
        ),
      ),
    );
  }

  void _showCreateInvoiceDialog(BuildContext context, InvoicesNotifier notifier) {
    final clientCtrl = TextEditingController();
    final amountCtrl = TextEditingController(text: '50000');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Create New GST Invoice', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: clientCtrl, decoration: const InputDecoration(labelText: 'Client Name')),
            const SizedBox(height: 8),
            TextField(controller: amountCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Base Amount (₹)')),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(10)),
              child: const Column(
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('CGST (9%):', style: TextStyle(fontSize: 11)), Text('Auto-computed', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))]),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('SGST (9%):', style: TextStyle(fontSize: 11)), Text('Auto-computed', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))]),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final base = double.tryParse(amountCtrl.text) ?? 50000;
              notifier.createInvoice(clientName: clientCtrl.text.isNotEmpty ? clientCtrl.text : 'Client Partner', baseAmount: base);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Invoice created with 18% GST!'), backgroundColor: AppColors.emeraldSuccess),
              );
            },
            child: const Text('Generate Invoice'),
          ),
        ],
      ),
    );
  }
}
