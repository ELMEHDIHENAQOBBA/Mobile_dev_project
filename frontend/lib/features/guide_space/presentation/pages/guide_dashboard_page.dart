import 'package:flutter/material.dart';
import 'package:guideme/features/guide_space/presentation/pages/guide_bookings_page.dart';
import 'package:guideme/features/guide_space/providers/guide_dashboard_notifier.dart';
import 'package:guideme/features/guide_space/providers/guide_dashboard_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GuideDashboardPage extends ConsumerStatefulWidget {
  const GuideDashboardPage({super.key});

  @override
  ConsumerState<GuideDashboardPage> createState() => _GuideDashboardPageState();
}

class _GuideDashboardPageState extends ConsumerState<GuideDashboardPage> {
  @override
  void initState() {
    super.initState();
    ref.read(guideDashboardNotifierProvider.notifier).loadDashboard();
  }

  void _goToBookings() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const GuideBookingsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(guideDashboardNotifierProvider);
    final color = const Color(0xFF2E86C1);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Guide Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month_rounded),
            onPressed: _goToBookings,
            tooltip: 'My Bookings',
          ),
        ],
      ),
      body: _buildBody(context, state, color),
    );
  }

  Widget _buildBody(BuildContext context, GuideDashboardState state, Color color) {
    if (state.isLoading || state.dashboardData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.error_outline, color: Colors.red, size: 48),
        const SizedBox(height: 12),
        Text(state.error!, style: const TextStyle(color: Colors.red)),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () =>
              ref.read(guideDashboardNotifierProvider.notifier).loadDashboard(),
          child: const Text('Retry'),
        ),
      ]));
    }

    final data = state.dashboardData!;
    final profile = data['profile'] as Map<String, dynamic>? ?? {};

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Row(children: [
            CircleAvatar(
              radius: 36,
              backgroundImage: (profile['profileImage'] != null &&
                      (profile['profileImage'] as String).isNotEmpty)
                  ? NetworkImage(profile['profileImage'] as String)
                  : null,
              backgroundColor: color.withOpacity(0.2),
              child: (profile['profileImage'] == null ||
                      (profile['profileImage'] as String).isEmpty)
                  ? Icon(Icons.person, size: 36, color: color)
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
                child:
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(profile['name'] as String? ?? 'Guide',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text(profile['city'] as String? ?? '',
                  style: const TextStyle(color: Colors.grey)),
              Row(children: [
                const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                const SizedBox(width: 4),
                Text('${profile['rating'] ?? 0}',
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(width: 8),
                Text('(${profile['reviewsCount'] ?? 0} reviews)',
                    style: const TextStyle(color: Colors.grey, fontSize: 13)),
              ]),
            ])),
          ]),
        ),
        const SizedBox(height: 24),
        const Text('Overview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.4,
          children: [
            _StatCard('Total Bookings', '${data['totalBookings'] ?? 0}',
                Icons.calendar_today_rounded, Colors.blue),
            _StatCard('Pending', '${data['pendingBookings'] ?? 0}',
                Icons.hourglass_empty_rounded, Colors.orange),
            _StatCard('Confirmed', '${data['confirmedBookings'] ?? 0}',
                Icons.check_circle_outline_rounded, Colors.green),
            _StatCard('Completed', '${data['completedBookings'] ?? 0}',
                Icons.done_all_rounded, Colors.teal),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.green.withOpacity(0.3)),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Total Earnings',
                style: TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 8),
            Text('${(data['totalEarnings'] as num?)?.round() ?? 0} MAD',
                style: const TextStyle(
                    fontSize: 32, fontWeight: FontWeight.bold, color: Colors.green)),
            const Text('From completed bookings',
                style: TextStyle(color: Colors.grey, fontSize: 13)),
          ]),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: _goToBookings,
            icon: const Icon(Icons.list_alt_rounded),
            label:
                const Text('View Incoming Bookings', style: TextStyle(fontSize: 16)),
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ]),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _StatCard(this.label, this.value, this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: color, size: 28),
        const Spacer(),
        Text(value,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ]),
    );
  }
}
