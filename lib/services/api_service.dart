import 'dart:convert';

import 'package:http/http.dart' as http;


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
}
