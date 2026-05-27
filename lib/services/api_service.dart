import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/category.dart';
import '../models/meal.dart';

class ApiService {
  static const String _baseHost = 'www.themealdb.com';
  static const String _basePath = '/api/json/v1/1';
  static const Duration _timeout = Duration(seconds: 10);

  Future<Map<String, dynamic>> _get(
    String endpoint, [
    Map<String, String>? params,
  ]) async {
    final uri = Uri.https(_baseHost, '$_basePath/$endpoint', params);

    try {
      final response = await http.get(uri).timeout(_timeout);

      if (response.statusCode != 200) {
        throw Exception('Erreur HTTP ${response.statusCode}');
      }

      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Erreur réseau : $e');
    }
  }

  Future<List<Category>> getCategories() async {
    final body = await _get('categories.php');
    final list = body['categories'] as List<dynamic>? ?? [];
    return list
        .map((json) => Category.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<List<Meal>> getMealsByCategory(String category) async {
    final body = await _get('filter.php', {'c': category});
    final list = (body['meals'] as List<dynamic>?) ?? [];
    return list
        .map((json) => Meal.fromJson(json as Map<String, dynamic>))
        .toList();
  }
   Future<List<Meal>> searchMeals(String query) async {
    final body = await _get('search.php', {'s': query});
    final list = (body['meals'] as List<dynamic>?) ?? [];
    return list
        .map((json) => Meal.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
