import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/meal.dart';

class StorageService {
  static const String _favoritesKey = 'favorites_v1';
  static const String _darkModeKey = 'dark_mode';
  static const String _discoveryKey = 'discovery_v1';

  Future<List<Meal>> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_favoritesKey);
    if (raw == null) return [];

    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map((json) => Meal.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveFavorites(List<Meal> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(favorites.map((m) => m.toJson()).toList());
    await prefs.setString(_favoritesKey, raw);
  }

  Future<void> clearFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_favoritesKey);
  }

  Future<bool> loadDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_darkModeKey) ?? false;
  }

  Future<void> saveDarkMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, isDark);
  }

  Future<Meal?> loadDiscoveryOfTheDay() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_discoveryKey);
    if (raw == null) return null;

    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final dateString = decoded['date'] as String?;
      if (dateString == null) return null;

      final cachedDate = DateTime.parse(dateString);
      final now = DateTime.now();

      final isSameDay =
          cachedDate.year == now.year &&
          cachedDate.month == now.month &&
          cachedDate.day == now.day;
      if (!isSameDay) return null;
      return Meal.fromJson(decoded['meal'] as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveDiscoveryOfTheDay(Meal meal) async {
    final prefs = await SharedPreferences.getInstance();
    final data = {
      'date': DateTime.now().toIso8601String(),
      'meal': meal.toJson(),
    };
    await prefs.setString(_discoveryKey, jsonEncode(data));
  }
}
