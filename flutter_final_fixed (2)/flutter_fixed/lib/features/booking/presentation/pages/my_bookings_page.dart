import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/features/booking/domain/entities/booking_entity.dart';
import 'package:flutter_clean_architecture/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:flutter_clean_architecture/router/routes.dart';
import 'package:go_router/go_router.dart';

class MyBookingsPage extends StatefulWidget {
  const MyBookingsPage({super.key});

  @override
  State<MyBookingsPage> createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBookingsPage> {
  @override
  void initState() {
    super.initState();
    context.read<BookingCubit>().loadMyBookings();
  }

  Color _statusColor(String status) {
    return switch (status) {
      'PENDING' => Colors.orange,
      'CONFIRMED' => Colors.blue,
      'COMPLETED' => Colors.green,
      'CANCELLED' => Colors.red,
      _ => Colors.grey,
    };
  }

  IconData _statusIcon(String status) {
    return switch (status) {
      'PENDING' => Icons.hourglass_empty_rounded,
      'CONFIRMED' => Icons.check_circle_outline_rounded,
      'COMPLETED' => Icons.done_all_rounded,
      'CANCELLED' => Icons.cancel_outlined,
      _ => Icons.info_outline,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Bookings'), centerTitle: true),
      body: BlocBuilder<BookingCubit, BookingState>(
        builder: (ctx, state) {
          if (state is BookingLoading) return const Center(child: CircularProgressIndicator());
          if (state is BookingError) return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
          if (state is BookingsLoaded) {
            if (state.bookings.isEmpty) {
              return Center(
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.calendar_today_outlined, size: 64, color: Colors.grey.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  const Text('No bookings yet', style: TextStyle(fontSize: 18, color: Colors.grey)),
                  const SizedBox(height: 8),
                  const Text('Find a guide and book your first tour!', style: TextStyle(color: Colors.grey)),
                ]),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.bookings.length,
              itemBuilder: (_, i) => _BookingCard(
                booking: state.bookings[i],
                onPay: () => ctx.push(Routes.payment, extra: state.bookings[i]),
                onReview: () => ctx.push(Routes.review, extra: state.bookings[i]),
                onCancel: () => _showCancelDialog(ctx, state.bookings[i]),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  void _showCancelDialog(BuildContext ctx, BookingEntity booking) {
    final reasonCtrl = TextEditingController();
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('Are you sure you want to cancel this booking?'),
          const SizedBox(height: 12),
          TextField(controller: reasonCtrl, decoration: const InputDecoration(hintText: 'Reason (optional)', border: OutlineInputBorder())),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('No')),
          ElevatedButton(
            onPressed: () {
              ctx.read<BookingCubit>().cancelBooking(booking.id, reason: reasonCtrl.text.isEmpty ? null : reasonCtrl.text);
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Yes, cancel', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final BookingEntity booking;
  final VoidCallback onPay;
  final VoidCallback onReview;
  final VoidCallback onCancel;

  const _BookingCard({required this.booking, required this.onPay, required this.onReview, required this.onCancel});

  Color get _color => switch (booking.status) {
    'PENDING' => Colors.orange,
    'CONFIRMED' => Colors.blue,
    'COMPLETED' => Colors.green,
    'CANCELLED' => Colors.red,
    _ => Colors.grey,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.cardColor, borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: _color.withOpacity(0.1),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Row(children: [
            Icon(Icons.circle, color: _color, size: 10),
            const SizedBox(width: 8),
            Text(booking.status, style: TextStyle(color: _color, fontWeight: FontWeight.bold, fontSize: 13)),
            const Spacer(),
            Text('#${booking.id}', style: const TextStyle(color: Colors.grey, fontSize: 13)),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              CircleAvatar(radius: 24, backgroundImage: booking.guideProfileImage.isNotEmpty
                  ? NetworkImage(booking.guideProfileImage) : null,
                child: booking.guideProfileImage.isEmpty ? const Icon(Icons.person) : null),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(booking.guideName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(booking.guideCity, style: const TextStyle(color: Colors.grey, fontSize: 13)),
              ])),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text('${booking.totalPrice.round()} MAD',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2E86C1))),
              ]),
            ]),
            const Divider(height: 24),
            Row(children: [
              const Icon(Icons.calendar_today_rounded, size: 16, color: Colors.grey),
              const SizedBox(width: 6),
              Text(booking.visitDate, style: const TextStyle(fontSize: 13)),
              const SizedBox(width: 16),
              const Icon(Icons.access_time_rounded, size: 16, color: Colors.grey),
              const SizedBox(width: 6),
              Text('${booking.durationHours}h', style: const TextStyle(fontSize: 13)),
              const SizedBox(width: 16),
              const Icon(Icons.people_rounded, size: 16, color: Colors.grey),
              const SizedBox(width: 6),
              Text('${booking.numberOfPeople}', style: const TextStyle(fontSize: 13)),
            ]),
            if (booking.specialRequest != null && booking.specialRequest!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('Note: ${booking.specialRequest}', style: const TextStyle(fontSize: 13, color: Colors.grey, fontStyle: FontStyle.italic)),
            ],
            const SizedBox(height: 16),
            Row(children: [
              if (booking.isConfirmed)
                Expanded(child: ElevatedButton.icon(
                  onPressed: onPay,
                  icon: const Icon(Icons.payment_rounded, size: 18),
                  label: const Text('Pay Now'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                )),
              if (booking.isCompleted)
                Expanded(child: ElevatedButton.icon(
                  onPressed: onReview,
                  icon: const Icon(Icons.star_rounded, size: 18),
                  label: const Text('Leave Review'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                )),
              if (booking.isPending || booking.isConfirmed) ...[
                if (booking.isConfirmed) const SizedBox(width: 8),
                Expanded(child: OutlinedButton.icon(
                  onPressed: onCancel,
                  icon: const Icon(Icons.close_rounded, size: 18, color: Colors.red),
                  label: const Text('Cancel', style: TextStyle(color: Colors.red)),
                  style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                )),
              ],
            ]),
          ]),
        ),
      ]),
    );
  }
}
