import 'package:flutter/cupertino.dart';

import '../models/meal.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<Meal> _favorites = [];

  List<Meal> get favorites => List.unmodifiable(_favorites);

  int get count => _favorites.length;

  bool isFavorite(Meal meal) {
    return _favorites.any((m) => m.id == meal.id);
  }

  void toggle(Meal meal) {
    if (isFavorite(meal)) {
      _favorites.removeWhere((m) => m.id == meal.id);
    } else {
      _favorites.add(meal);
    }
    notifyListeners();
  }
}