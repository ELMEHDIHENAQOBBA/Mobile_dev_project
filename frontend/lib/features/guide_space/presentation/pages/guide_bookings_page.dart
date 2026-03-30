import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/features/guide_space/presentation/cubit/guide_dashboard_cubit.dart';

class GuideBookingsPage extends StatefulWidget {
  const GuideBookingsPage({super.key});

  @override
  State<GuideBookingsPage> createState() => _GuideBookingsPageState();
}

class _GuideBookingsPageState extends State<GuideBookingsPage> {
  @override
  void initState() {
    super.initState();
    context.read<GuideDashboardCubit>().loadIncomingBookings();
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
    return Scaffold(
      appBar: AppBar(title: const Text('Incoming Bookings'), centerTitle: true),
      body: BlocBuilder<GuideDashboardCubit, GuideDashboardState>(
        builder: (ctx, state) {
          // Tous les états gérés explicitement
          if (state is GuideDashboardInitial || state is GuideDashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is GuideDashboardError) {
            return Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(state.message, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ctx.read<GuideDashboardCubit>().loadIncomingBookings(),
                  child: const Text('Retry'),
                ),
              ]),
            );
          }
          if (state is GuideBookingsLoaded) {
            if (state.bookings.isEmpty) {
              return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.inbox_rounded, size: 64, color: Colors.grey.withOpacity(0.5)),
                const SizedBox(height: 16),
                const Text('No bookings yet', style: TextStyle(fontSize: 18, color: Colors.grey)),
              ]));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.bookings.length,
              itemBuilder: (_, i) {
                final b = state.bookings[i] as Map<String, dynamic>;
                final status = b['status'] as String;
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
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
                        Text(status, style: TextStyle(color: _statusColor(status), fontWeight: FontWeight.bold)),
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
                          Text('${b['touristName']}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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
                          Text('${b['numberOfPeople']} persons', style: const TextStyle(fontSize: 13)),
                        ]),
                        if (b['specialRequest'] != null && (b['specialRequest'] as String).isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text('Note: ${b['specialRequest']}',
                              style: const TextStyle(fontSize: 13, color: Colors.grey, fontStyle: FontStyle.italic)),
                        ],
                        const SizedBox(height: 12),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text('${(b['totalPrice'] as num).round()} MAD',
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2E86C1))),
                          Row(children: [
                            if (status == 'PENDING')
                              ElevatedButton(
                                onPressed: () => ctx.read<GuideDashboardCubit>()
                                    .updateBookingStatus(b['id'] as int, 'CONFIRMED'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green, foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                ),
                                child: const Text('Confirm'),
                              ),
                            if (status == 'CONFIRMED') ...[
                              ElevatedButton(
                                onPressed: () => ctx.read<GuideDashboardCubit>()
                                    .updateBookingStatus(b['id'] as int, 'COMPLETED'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal, foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                ),
                                child: const Text('Complete'),
                              ),
                              const SizedBox(width: 8),
                            ],
                            if (status == 'PENDING' || status == 'CONFIRMED') ...[
                              const SizedBox(width: 8),
                              OutlinedButton(
                                onPressed: () => ctx.read<GuideDashboardCubit>()
                                    .updateBookingStatus(b['id'] as int, 'CANCELLED'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red,
                                  side: const BorderSide(color: Colors.red),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
          // État GuideDashboardLoaded (du dashboard) — relancer le chargement des bookings
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
