import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/features/guides/presentation/cubit/guides_cubit.dart';
import 'package:flutter_clean_architecture/features/guides/presentation/cubit/guides_state.dart';
import 'package:flutter_clean_architecture/features/guides/presentation/widgets/guide_card.dart';

class GuidesListPage extends StatelessWidget {
  const GuidesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Guides'),
        centerTitle: true,
      ),
      body: BlocBuilder<GuidesCubit, GuidesState>(
        builder: (context, state) {
          if (state is GuidesInitial) {
            context.read<GuidesCubit>().fetchGuides();
            return const Center(child: CircularProgressIndicator());
          } else if (state is GuidesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GuidesLoaded) {
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
          } else if (state is GuidesError) {
            return Center(
              child: Text(
                'Error: ${state.message}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
