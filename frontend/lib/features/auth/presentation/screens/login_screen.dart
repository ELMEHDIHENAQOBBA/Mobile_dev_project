import 'package:flutter/material.dart';
import 'package:guideme/features/auth/providers/auth_providers.dart';
import 'package:guideme/router/navigation_service.dart';
import 'package:guideme/router/routes.dart';
import 'package:guideme/shared/widgets/loading_overlay.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isGuideMode = false;
  bool _obscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_isGuideMode) {
        await ref.read(authNotifierProvider.notifier)
            .signInAsGuide(_emailController.text, _passwordController.text);
      } else {
        await ref.read(authNotifierProvider.notifier)
            .signIn(_emailController.text, _passwordController.text);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = const Color(0xFF2E86C1);

    ref.listen(authNotifierProvider, (previous, next) {
      next.maybeWhen(
        authenticated: (_) => NavigationService.goToHome(context),
        authenticatedAsGuide: (_) => context.go(Routes.guideDashboard),
        error: (message) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        ),
        orElse: () {},
      );
    });

    final isLoading = ref.watch(authNotifierProvider).maybeWhen(
      loading: () => true, orElse: () => false,
    );

    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(children: [
              const SizedBox(height: 40),
              Icon(Icons.explore_rounded, size: 80, color: color),
              const SizedBox(height: 16),
              const Text('Tourist Guide', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const Text('Find your perfect local guide', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 40),

              // Toggle Touriste / Guide
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(children: [
                  Expanded(child: GestureDetector(
                    onTap: () => setState(() => _isGuideMode = false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: !_isGuideMode ? color : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text('Tourist', textAlign: TextAlign.center,
                          style: TextStyle(
                            color: !_isGuideMode ? Colors.white : Colors.grey,
                            fontWeight: FontWeight.w600,
                          )),
                    ),
                  )),
                  Expanded(child: GestureDetector(
                    onTap: () => setState(() => _isGuideMode = true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _isGuideMode ? color : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text('Guide', textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _isGuideMode ? Colors.white : Colors.grey,
                            fontWeight: FontWeight.w600,
                          )),
                    ),
                  )),
                ]),
              ),
              const SizedBox(height: 32),

              Form(
                key: _formKey,
                child: Column(children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.email_outlined),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: color, width: 2),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Email is required';
                      if (!v.contains('@')) return 'Invalid email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscure,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock_outline),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: color, width: 2),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Password is required';
                      if (v.length < 6) return 'At least 6 characters';
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity, height: 52,
                    child: ElevatedButton(
                      onPressed: _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color, foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        _isGuideMode ? 'Login as Guide' : 'Login as Tourist',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  if (!_isGuideMode) TextButton(
                    onPressed: () => NavigationService.push(context, '/register'),
                    child: const Text("Don't have an account? Register"),
                  ),
                ]),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
