import 'package:flutter/cupertino.dart';
import 'package:mealmate/services/storage_service.dart';

import '../models/meal.dart';

class FavoritesProvider extends ChangeNotifier {
  final StorageService _storage = StorageService();
  final List<Meal> _favorites = [];
  bool _isLoading = true;

  FavoritesProvider() {
    _loadFromStorage();
  }

  List<Meal> get favorites => List.unmodifiable(_favorites);

  bool get isLoading => _isLoading;
  int get count => _favorites.length;

  bool isFavorite(Meal meal) {
    return _favorites.any((m) => m.id == meal.id);
  }

  Future<void> toggle(Meal meal) async {
    if (isFavorite(meal)) {
      _favorites.removeWhere((m) => m.id == meal.id);
    } else {
      _favorites.add(meal);
    }
    notifyListeners();
    await _storage.saveFavorites(_favorites);
  }

  Future<void> _loadFromStorage() async {
    final loaded = await _storage.loadFavorites();
    _favorites.addAll(loaded);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> clearAll() async {
    _favorites.clear();
    notifyListeners();
    await _storage.clearFavorites();
  }
}