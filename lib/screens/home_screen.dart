import 'package:flutter/material.dart';
import 'package:mealmate/models/meal.dart';
import 'package:provider/provider.dart';

import '../providers/favorites_provider.dart';
import '../widgets/meal_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _api = ApiService();

  bool _isLoading = true;
  String? _errorMessage;
  List<Category> _categories = [];
  Meal? _randomMeal;

  @override
  void initState() {
    super.initState();
    _loadHomeData();
  }

  Future<void> _loadHomeData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final results = await Future.wait([
        _api.getCategories(),
        _api.getRandomMeal(),
      ]);

      setState(() {
        _categories = results[0] as List<Category>;
        _randomMeal = results[1] as Meal?;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Impossible de charger les données. Vérifie ta connexion.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoritesCount = context.watch<FavoritesProvider>().count;
    return Scaffold(
      appBar: AppBar(
        title: const Text('MealMate'),
        actions: [
          IconButton(
            icon: Badge(
              label: Text('$favoritesCount'),
              isLabelVisible: favoritesCount > 0,
              child: const Icon(Icons.favorite),
            ),
            onPressed: () {
            },
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 16),
            Text(_errorMessage!),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _loadHomeData,
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (_randomMeal != null) ...[
          Text(
            'Découverte du jour',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: mockMeals.length,
        itemBuilder: (context, index) {
          final meal = mockMeals[index];
          return MealCard(meal: meal);
        },
      ),
    );
  }
}
