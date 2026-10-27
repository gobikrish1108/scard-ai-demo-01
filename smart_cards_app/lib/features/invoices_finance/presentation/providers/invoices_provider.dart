import 'package:flutter_riverpod/flutter_riverpod.dart';

class InvoiceItem {
  final String id;
  final String invoiceNumber;
  final String clientName;
  final double baseAmount;
  final double cgst;
  final double sgst;
  final double totalAmount;
  final String status;
  final String dueDate;

  const InvoiceItem({
    required this.id,
    required this.invoiceNumber,
    required this.clientName,
    required this.baseAmount,
    required this.cgst,
    required this.sgst,
    required this.totalAmount,
    required this.status,
    required this.dueDate,
  });
}

class InvoicesNotifier extends Notifier<List<InvoiceItem>> {
  @override
  List<InvoiceItem> build() => [
        const InvoiceItem(
          id: '1',
          invoiceNumber: '#INV-2026-089',
          clientName: 'Rajesh Enterprises',
          baseAmount: 72034,
          cgst: 6483,
          sgst: 6483,
          totalAmount: 85000,
          status: 'Paid',
          dueDate: 'Oct 20, 2026',
        ),
        const InvoiceItem(
          id: '2',
          invoiceNumber: '#INV-2026-090',
          clientName: 'Antz Media Digital Retainer',
          baseAmount: 101695,
          cgst: 9152,
          sgst: 9152,
          totalAmount: 120000,
          status: 'Pending',
          dueDate: 'Nov 15, 2026',
        ),
      ];

  void createInvoice({
    required String clientName,
    required double baseAmount,
  }) {
    final cgst = baseAmount * 0.09;
    final sgst = baseAmount * 0.09;
    final total = baseAmount + cgst + sgst;
    final invNumber = '#INV-2026-${100 + state.length}';

    final newInv = InvoiceItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      invoiceNumber: invNumber,
      clientName: clientName,
      baseAmount: baseAmount,
      cgst: cgst,
      sgst: sgst,
      totalAmount: total,
      status: 'Pending',
      dueDate: 'Nov 30, 2026',
    );

    state = [newInv, ...state];
  }
}

final invoicesProvider = NotifierProvider<InvoicesNotifier, List<InvoiceItem>>(InvoicesNotifier.new);
