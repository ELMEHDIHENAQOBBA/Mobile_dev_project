import 'package:flutter/material.dart';
import 'package:guideme/features/auth/providers/auth_notifier.dart';
import 'package:guideme/features/auth/providers/auth_providers.dart';
import 'package:guideme/router/routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      next.when(
        initial: () {},
        loading: () {},
        authenticated: (_) => context.go(Routes.home),
        authenticatedAsGuide: (_) => context.go(Routes.guideDashboard),
        unauthenticated: () => context.go(Routes.login),
        error: (_) => context.go(Routes.login),
      );
    });

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
