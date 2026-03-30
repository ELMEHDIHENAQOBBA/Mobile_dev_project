import 'package:flutter/material.dart';
import 'package:guideme/features/guides/presentation/widgets/guide_card.dart';
import 'package:guideme/features/guides/providers/guides_notifier.dart';
import 'package:guideme/features/guides/providers/guides_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GuidesListPage extends ConsumerWidget {
  const GuidesListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(guidesNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Guides'),
        centerTitle: true,
      ),
      body: _buildBody(context, ref, state),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, GuidesState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Text(
          'Error: ${state.error}',
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (state.guides.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 64, color: Colors.grey.withOpacity(0.5)),
            const SizedBox(height: 16),
            const Text(
              'No guides found.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            const Text(
              'Try adjusting your search filters.',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.guides.length,
      itemBuilder: (context, index) {
        return GuideCard(guide: state.guides[index]);
      },
    );
  }
}
