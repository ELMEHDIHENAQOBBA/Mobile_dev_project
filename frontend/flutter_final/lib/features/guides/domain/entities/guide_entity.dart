class GuideEntity {
  final int id;
  final String name;
  final List<String> languages;
  final double priceMin;
  final double priceMax;
  final double rating;
  final String city;
  final bool transportAvailable;
  final String description;
  final String profileImage;
  final int reviewsCount;

  const GuideEntity({
    required this.id,
    required this.name,
    required this.languages,
    required this.priceMin,
    required this.priceMax,
    required this.rating,
    required this.city,
    required this.transportAvailable,
    required this.description,
    required this.profileImage,
    required this.reviewsCount,
  });
}
