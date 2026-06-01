class Meal {
  final String id;
  final String name;
  final String category;
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
    required this.country,
    required this.instructions,
    required this.imageUrl,
    this.youtubeUrl,
    this.ingredients = const [],
    this.measures = const [],
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    final ingredients = <String>[];
    final measures = <String>[];
    for (var i = 1; i <= 20; i++) {
      final ingredient = (json['strIngredient$i'] as String?)?.trim() ?? '';
      final measure = (json['strMeasure$i'] as String?)?.trim() ?? '';
      if (ingredient.isNotEmpty) {
        ingredients.add(ingredient);
        measures.add(measure);
      }
    }

    return Meal(
      id: json['idMeal'] as String? ?? '',
      name: json['strMeal'] as String? ?? '',
      imageUrl: json['strMealThumb'] as String? ?? '',
      category: json['strCategory'] as String? ?? '',
      country: json['strCountry'] as String? ?? '',
      instructions: json['strInstructions'] as String? ?? '',
      youtubeUrl: json['strYoutube'] as String?,
      ingredients: ingredients,
      measures: measures,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idMeal': id,
      'strMeal': name,
      'strMealThumb': imageUrl,
      'strCategory': category,
      'strArea': country,
      'strInstructions': instructions,
      'strYoutube': youtubeUrl,
    };
  }
}
