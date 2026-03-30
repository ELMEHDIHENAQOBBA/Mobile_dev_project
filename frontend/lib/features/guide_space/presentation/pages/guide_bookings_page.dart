import 'package:flutter/material.dart';
import 'package:guideme/features/guide_space/providers/guide_dashboard_notifier.dart';
import 'package:guideme/features/guide_space/providers/guide_dashboard_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GuideBookingsPage extends ConsumerStatefulWidget {
  const GuideBookingsPage({super.key});

  @override
  ConsumerState<GuideBookingsPage> createState() => _GuideBookingsPageState();
}

class _GuideBookingsPageState extends ConsumerState<GuideBookingsPage> {
  @override
  void initState() {
    super.initState();
    ref.read(guideDashboardNotifierProvider.notifier).loadIncomingBookings();
  }

  Color _statusColor(String status) => switch (status) {
        'PENDING' => Colors.orange,
        'CONFIRMED' => Colors.blue,
        'COMPLETED' => Colors.green,
        'CANCELLED' => Colors.red,
        _ => Colors.grey,
      };

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(guideDashboardNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Incoming Bookings'), centerTitle: true),
      body: _buildBody(context, state),
    );
  }

  Widget _buildBody(BuildContext context, GuideDashboardState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 48),
          const SizedBox(height: 16),
          Text(state.error!, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () =>
                ref.read(guideDashboardNotifierProvider.notifier).loadIncomingBookings(),
            child: const Text('Retry'),
          ),
        ]),
      );
    }

    if (state.incomingBookings.isEmpty) {
      return Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.inbox_rounded, size: 64, color: Colors.grey.withOpacity(0.5)),
        const SizedBox(height: 16),
        const Text('No bookings yet', style: TextStyle(fontSize: 18, color: Colors.grey)),
      ]));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.incomingBookings.length,
      itemBuilder: (_, i) {
        final b = state.incomingBookings[i] as Map<String, dynamic>;
        final status = b['status'] as String;
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4))
            ],
          ),
          child: Column(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: _statusColor(status).withOpacity(0.1),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(children: [
                Icon(Icons.circle, color: _statusColor(status), size: 10),
                const SizedBox(width: 8),
                Text(status,
                    style: TextStyle(
                        color: _statusColor(status), fontWeight: FontWeight.bold)),
                const Spacer(),
                Text('#${b['id']}', style: const TextStyle(color: Colors.grey, fontSize: 13)),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  const Icon(Icons.person_rounded, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text('${b['touristName']}',
                      style:
                          const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ]),
                const SizedBox(height: 8),
                Row(children: [
                  const Icon(Icons.calendar_today_rounded, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text('${b['visitDate']}', style: const TextStyle(fontSize: 13)),
                  const SizedBox(width: 16),
                  const Icon(Icons.access_time_rounded, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text('${b['durationHours']}h', style: const TextStyle(fontSize: 13)),
                  const SizedBox(width: 16),
                  const Icon(Icons.people_rounded, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text('${b['numberOfPeople']} persons',
                      style: const TextStyle(fontSize: 13)),
                ]),
                if (b['specialRequest'] != null &&
                    (b['specialRequest'] as String).isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text('Note: ${b['specialRequest']}',
                      style: const TextStyle(
                          fontSize: 13, color: Colors.grey, fontStyle: FontStyle.italic)),
                ],
                const SizedBox(height: 12),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('${(b['totalPrice'] as num).round()} MAD',
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E86C1))),
                  Row(children: [
                    if (status == 'PENDING')
                      ElevatedButton(
                        onPressed: () => ref
                            .read(guideDashboardNotifierProvider.notifier)
                            .updateBookingStatus(b['id'] as int, 'CONFIRMED'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                        ),
                        child: const Text('Confirm'),
                      ),
                    if (status == 'CONFIRMED') ...[
                      ElevatedButton(
                        onPressed: () => ref
                            .read(guideDashboardNotifierProvider.notifier)
                            .updateBookingStatus(b['id'] as int, 'COMPLETED'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                        ),
                        child: const Text('Complete'),
                      ),
                      const SizedBox(width: 8),
                    ],
                    if (status == 'PENDING' || status == 'CONFIRMED') ...[
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: () => ref
                            .read(guideDashboardNotifierProvider.notifier)
                            .updateBookingStatus(b['id'] as int, 'CANCELLED'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ],
                  ]),
                ]),
              ]),
            ),
          ]),
        );
      },
    );
  }
}
