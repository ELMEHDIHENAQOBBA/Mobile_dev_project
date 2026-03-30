import 'package:flutter/material.dart';
import 'package:guideme/features/guides/domain/entities/guide_entity.dart';
import 'package:guideme/router/routes.dart';
import 'package:go_router/go_router.dart';

class GuideCard extends StatelessWidget {
  final GuideEntity guide;

  const GuideCard({super.key, required this.guide});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            context.push(Routes.guideDetails, extra: guide);
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: 'guide_avatar_${guide.id}',
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: guide.profileImage.isNotEmpty
                        ? NetworkImage(guide.profileImage)
                        : null,
                    onBackgroundImageError: guide.profileImage.isNotEmpty
                        ? (_, __) {}
                        : null,
                    child: guide.profileImage.isEmpty
                        ? const Icon(Icons.person, size: 40)
                        : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              guide.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                              const SizedBox(width: 4),
                              Text(
                                guide.rating.toString(),
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on_rounded, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(guide.city, style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: guide.languages.take(3).map((lang) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: theme.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              lang,
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Est. Price', style: TextStyle(fontSize: 12, color: Colors.grey)),
                              Text(
                                '${guide.priceMin.round()} - ${guide.priceMax.round()} MAD',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: theme.primaryColor,
                                ),
                              ),
                            ],
                          ),
                          if (guide.transportAvailable)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.directions_car_rounded, size: 14, color: Colors.green),
                                  SizedBox(width: 4),
                                  Text(
                                    'Transport',
                                    style: TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
