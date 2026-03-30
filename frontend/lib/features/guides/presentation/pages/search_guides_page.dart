import 'package:flutter/material.dart';
import 'package:guideme/features/guides/providers/guides_providers.dart';
import 'package:guideme/router/routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SearchGuidesPage extends ConsumerStatefulWidget {
  const SearchGuidesPage({super.key});

  @override
  ConsumerState<SearchGuidesPage> createState() => _SearchGuidesPageState();
}

class _SearchGuidesPageState extends ConsumerState<SearchGuidesPage> {
  String _selectedCity = 'All';
  RangeValues _budgetRange = const RangeValues(100, 1500);
  String _selectedLanguage = 'All';
  bool _transportAvailable = false;
  double _minRating = 0.0;

  final List<String> _cities = ['All', 'Marrakech', 'Fez', 'Casablanca', 'Chefchaouen'];
  final List<String> _languages = ['All', 'Arabic', 'French', 'English', 'Spanish', 'German', 'Italian'];

  final Color _primaryColor = const Color(0xFF2E86C1);

  void _onSearch() {
    ref.read(guidesNotifierProvider.notifier).searchGuides(
          city: _selectedCity,
          minBudget: _budgetRange.start,
          maxBudget: _budgetRange.end,
          language: _selectedLanguage,
          transportAvailable: _transportAvailable,
          minRating: _minRating,
        );
    context.push(Routes.guidesList);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 200.0,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Find Your Guide',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.white,
                    shadows: const [Shadow(color: Colors.black45, blurRadius: 4)],
                  ),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      'https://images.unsplash.com/photo-1539020140153-e479b8c22e70?auto=format&fit=crop&q=80',
                      fit: BoxFit.cover,
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.black54, Colors.transparent],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('Destination'),
                    const SizedBox(height: 12),
                    _buildDropdown(
                      value: _selectedCity,
                      items: _cities,
                      onChanged: (val) => setState(() => _selectedCity = val!),
                      icon: Icons.location_city_rounded,
                    ),
                    const SizedBox(height: 24),
                    _buildSectionHeader('Budget Range (MAD)'),
                    const SizedBox(height: 12),
                    _buildBudgetSlider(),
                    const SizedBox(height: 24),
                    _buildSectionHeader('Language'),
                    const SizedBox(height: 12),
                    _buildDropdown(
                      value: _selectedLanguage,
                      items: _languages,
                      onChanged: (val) => setState(() => _selectedLanguage = val!),
                      icon: Icons.language_rounded,
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Transport Available', style: TextStyle(fontWeight: FontWeight.w500)),
                        subtitle: const Text('Guides with an included vehicle'),
                        value: _transportAvailable,
                        activeColor: _primaryColor,
                        onChanged: (val) => setState(() => _transportAvailable = val),
                        secondary: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _primaryColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.directions_car_rounded, color: _primaryColor),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _onSearch,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_rounded),
                            SizedBox(width: 8),
                            Text(
                              'Search Guides',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
    required IconData icon,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Row(
                children: [
                  Icon(icon, size: 20, color: _primaryColor),
                  const SizedBox(width: 12),
                  Text(item, style: const TextStyle(fontWeight: FontWeight.w500)),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildBudgetSlider() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${_budgetRange.start.round()} MAD', style: const TextStyle(fontWeight: FontWeight.bold)),
              Text('${_budgetRange.end.round()} MAD', style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: _primaryColor,
              inactiveTrackColor: _primaryColor.withOpacity(0.2),
              thumbColor: _primaryColor,
              overlayColor: _primaryColor.withOpacity(0.1),
              trackHeight: 6,
            ),
            child: RangeSlider(
              values: _budgetRange,
              min: 50,
              max: 2000,
              divisions: 39,
              labels: RangeLabels(
                '${_budgetRange.start.round()} MAD',
                '${_budgetRange.end.round()} MAD',
              ),
              onChanged: (RangeValues values) {
                setState(() => _budgetRange = values);
              },
            ),
          ),
        ],
      ),
    );
  }
}
