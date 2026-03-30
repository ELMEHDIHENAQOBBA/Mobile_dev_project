import 'package:flutter/material.dart';
import 'package:guideme/features/booking/domain/entities/booking_entity.dart';
import 'package:guideme/features/auth/providers/auth_providers.dart';
import 'package:guideme/features/payment/providers/payment_providers.dart';
import 'package:guideme/router/routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PaymentPage extends ConsumerStatefulWidget {
  final BookingEntity booking;
  const PaymentPage({super.key, required this.booking});

  @override
  ConsumerState<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends ConsumerState<PaymentPage> {
  bool _loading = false;
  bool _paid = false;
  String? _transactionRef;
  String _selectedMethod = 'Credit Card';
  final List<String> _methods = ['Credit Card', 'Debit Card', 'Mobile Pay'];

  Future<void> _pay() async {
    setState(() => _loading = true);
    try {
      final ds = ref.read(paymentDataSourceProvider);
      final payment = await ds.processPayment(widget.booking.id);
      setState(() { _loading = false; _paid = true; _transactionRef = payment.transactionRef; });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment failed: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = const Color(0xFF2E86C1);
    return Scaffold(
      appBar: AppBar(title: const Text('Payment'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: _paid ? _buildSuccess(color) : _buildPayForm(color),
      ),
    );
  }

  Widget _buildPayForm(Color color) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Summary card
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(children: [
          Row(children: [
            CircleAvatar(radius: 28, backgroundImage: widget.booking.guideProfileImage.isNotEmpty
                ? NetworkImage(widget.booking.guideProfileImage) : null),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(widget.booking.guideName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text('${widget.booking.visitDate} · ${widget.booking.durationHours}h · ${widget.booking.numberOfPeople} person(s)',
                  style: const TextStyle(color: Colors.grey, fontSize: 13)),
            ])),
          ]),
          const Divider(height: 24),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Total Amount', style: TextStyle(fontSize: 16)),
            Text('${widget.booking.totalPrice.round()} MAD',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          ]),
        ]),
      ),
      const SizedBox(height: 32),

      const Text('Payment Method', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      ..._methods.map((m) => RadioListTile<String>(
        value: m, groupValue: _selectedMethod,
        title: Text(m),
        onChanged: (v) => setState(() => _selectedMethod = v!),
        activeColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: _selectedMethod == m ? color.withOpacity(0.05) : null,
      )),

      const SizedBox(height: 32),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange.withOpacity(0.3)),
        ),
        child: const Row(children: [
          Icon(Icons.info_outline_rounded, color: Colors.orange),
          SizedBox(width: 12),
          Expanded(child: Text('This is a simulated payment for MVP purposes. No real transaction will occur.',
              style: TextStyle(fontSize: 13, color: Colors.orange))),
        ]),
      ),
      const SizedBox(height: 32),
      SizedBox(
        width: double.infinity, height: 56,
        child: ElevatedButton(
          onPressed: _loading ? null : _pay,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green, foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: _loading
              ? const CircularProgressIndicator(color: Colors.white)
              : Text('Pay ${widget.booking.totalPrice.round()} MAD',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      ),
    ]);
  }

  Widget _buildSuccess(Color color) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const SizedBox(height: 40),
      Container(
        width: 100, height: 100,
        decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
        child: const Icon(Icons.check_rounded, color: Colors.white, size: 60),
      ),
      const SizedBox(height: 24),
      const Text('Payment Successful!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      Text('Transaction: $_transactionRef', style: const TextStyle(color: Colors.grey, fontSize: 13)),
      const SizedBox(height: 32),
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.green.withOpacity(0.08), borderRadius: BorderRadius.circular(16)),
        child: Column(children: [
          _row('Guide', widget.booking.guideName),
          const Divider(),
          _row('Date', widget.booking.visitDate),
          const Divider(),
          _row('Amount', '${widget.booking.totalPrice.round()} MAD'),
          const Divider(),
          _row('Status', 'PAID'),
        ]),
      ),
      const SizedBox(height: 32),
      SizedBox(
        width: double.infinity, height: 56,
        child: ElevatedButton(
          onPressed: () => context.go(Routes.myBookings),
          style: ElevatedButton.styleFrom(
            backgroundColor: color, foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: const Text('View My Bookings', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ),
    ]);
  }

  Widget _row(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: const TextStyle(color: Colors.grey)),
      Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
    ]),
  );
}
