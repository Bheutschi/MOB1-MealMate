import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/meal.dart';
import '../providers/favorites_provider.dart';
import '../services/api_service.dart';

class MealDetailScreen extends StatefulWidget {
  const MealDetailScreen({super.key, required this.meal});

  final Meal meal;

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  final ApiService _api = ApiService();

  bool _isLoading = true;
  String? _errorMessage;
  Meal? _fullMeal;

  @override
  void initState() {
    super.initState();
    _loadFullMeal();
  }

  Future<void> _loadFullMeal() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final full = await _api.getMealById(widget.meal.id);
      setState(() {
        _fullMeal = full;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Impossible de charger les détails. Vérifie ta connexion.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final meal = _fullMeal ?? widget.meal;
    final favorites = context.watch<FavoritesProvider>();
    final isFav = favorites.isFavorite(meal);

    return Scaffold(
      appBar: AppBar(
        title: Text(meal.name),
        actions: [
          IconButton(
            icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              final messenger = ScaffoldMessenger.of(context);
              context.read<FavoritesProvider>().toggle(meal);
              messenger.removeCurrentSnackBar();
              messenger.showSnackBar(
                SnackBar(
                  content: Text(
                    isFav ? 'Retiré des favoris' : 'Ajouté aux favoris',
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: _buildBody(meal),
    );
  }

  Widget _buildBody(Meal meal) {
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
              onPressed: _loadFullMeal,
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }

    return ListView(
      children: [
        Image.network(
          meal.imageUrl,
          height: 250,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                meal.name,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  if (meal.category.isNotEmpty)
                    Chip(label: Text(meal.category)),
                  if (meal.country.isNotEmpty)
                    Chip(label: Text(meal.country)),
                ],
              ),
              const SizedBox(height: 16),
              if (meal.ingredients.isNotEmpty) ...[
                Text(
                  'Ingrédients',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                ...List.generate(meal.ingredients.length, (i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text('• ${meal.measures[i]} ${meal.ingredients[i]}'),
                  );
                }),
                const SizedBox(height: 16),
              ],
              Text(
                'Instructions',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(meal.instructions),
            ],
          ),
        ),
      ],
    );
  }
}