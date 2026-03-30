import 'package:flutter/material.dart';
import 'package:guideme/features/auth/providers/auth_providers.dart';
import 'package:guideme/router/routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final color = const Color(0xFF2E86C1);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), centerTitle: true),
      body: authState.maybeWhen(
        authenticated: (user) => ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Center(child: Column(children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: color.withOpacity(0.1),
                child: Text(user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                    style: TextStyle(fontSize: 40, color: color, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 16),
              Text(user.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(user.email, style: const TextStyle(color: Colors.grey)),
            ])),
            const SizedBox(height: 40),
            _tile(Icons.calendar_today_rounded, 'My Bookings', () => context.push(Routes.myBookings), color),
            const Divider(),
            _tile(Icons.logout_rounded, 'Logout', () async {
              await ref.read(authNotifierProvider.notifier).signOut();
              if (context.mounted) context.go(Routes.login);
            }, Colors.red),
          ],
        ),
        orElse: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _tile(IconData icon, String label, VoidCallback onTap, Color color) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
        child: Icon(icon, color: color),
      ),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
      onTap: onTap,
    );
  }
}
