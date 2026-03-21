import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/features/guides/domain/entities/guide_entity.dart';
import 'package:flutter_clean_architecture/router/routes.dart';
import 'package:go_router/go_router.dart';

class GuideDetailsPage extends StatelessWidget {
  final GuideEntity guide;
  const GuideDetailsPage({super.key, required this.guide});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final color = const Color(0xFF2E86C1);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark ? Colors.black54 : Colors.white70,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back_rounded),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(children: [
              Hero(
                tag: 'guide_avatar_${guide.id}',
                child: Image.network(guide.profileImage,
                    width: double.infinity, height: 350, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(height: 350, color: Colors.grey.shade300,
                        child: const Icon(Icons.person, size: 100, color: Colors.grey))),
              ),
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [theme.scaffoldBackgroundColor, theme.scaffoldBackgroundColor.withOpacity(0.0)],
                      begin: Alignment.bottomCenter, end: Alignment.topCenter,
                    ),
                  ),
                ),
              ),
            ]),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Expanded(child: Text(guide.name,
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold))),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      const Icon(Icons.star_rounded, color: Colors.amber, size: 24),
                      const SizedBox(width: 4),
                      Text(guide.rating.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ]),
                  ),
                ]),
                const SizedBox(height: 8),
                Row(children: [
                  const Icon(Icons.location_on_rounded, size: 20, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(guide.city, style: const TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(width: 16),
                  Icon(Icons.reviews_rounded, size: 20, color: Colors.grey.shade500),
                  const SizedBox(width: 4),
                  Text('${guide.reviewsCount} reviews', style: TextStyle(color: Colors.grey.shade500)),
                ]),
                const SizedBox(height: 24),
                const Text('About Me', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(guide.description, style: const TextStyle(fontSize: 16, height: 1.5)),
                const SizedBox(height: 24),
                const Text('Languages', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12, runSpacing: 12,
                  children: guide.languages.map((lang) => Chip(
                    label: Text(lang),
                    side: BorderSide(color: color.withOpacity(0.5)),
                    backgroundColor: color.withOpacity(0.05),
                    labelStyle: TextStyle(color: color, fontWeight: FontWeight.w600),
                  )).toList(),
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                      blurRadius: 10, offset: const Offset(0, 4),
                    )],
                  ),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('Estimated Price', style: TextStyle(fontSize: 14, color: Colors.grey)),
                      const SizedBox(height: 4),
                      Text('${guide.priceMin.round()} - ${guide.priceMax.round()} MAD',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
                    ]),
                    if (guide.transportAvailable)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), shape: BoxShape.circle),
                        child: const Icon(Icons.directions_car_rounded, color: Colors.green, size: 28),
                      ),
                  ]),
                ),
                const SizedBox(height: 100),
              ]),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -4))],
        ),
        child: SizedBox(
          width: double.infinity, height: 56,
          child: ElevatedButton(
            onPressed: () => context.push(Routes.booking, extra: guide),
            style: ElevatedButton.styleFrom(
              backgroundColor: color, foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
            ),
            child: const Text('Book Guide', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}
