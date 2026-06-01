import 'package:flutter/foundation.dart';
import '../services/storage_service.dart';

class ThemeProvider extends ChangeNotifier {
  final StorageService _storage = StorageService();

  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadFromStorage();
  }

  Future<void> toggle() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    await _storage.saveDarkMode(_isDarkMode);
  }

  Future<void> _loadFromStorage() async {
    try {
      _isDarkMode = await _storage.loadDarkMode();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading theme preference: $e');
    }
  }
}