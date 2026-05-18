class Meal {
  final String id;
  final String name;
  final String category;
  final String area;
  final String country;
  final String instructions;
  final String imageUrl;
  final String? youtubeUrl;
  final List<String> ingredients;
  final List<String> measures;

  const Meal({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.country,
    required this.instructions,
    required this.imageUrl,
    this.youtubeUrl,
    this.ingredients = const [],
    this.measures = const [],
  });
}