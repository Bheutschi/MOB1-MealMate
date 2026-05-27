import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/meal.dart';
import '../providers/favorites_provider.dart';

class MealDetailScreen extends StatelessWidget {
  const MealDetailScreen({super.key, required this.meal});

  final Meal meal;

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesProvider>();
    final isFav = favorites.isFavorite(meal);

    return Scaffold(
      appBar: AppBar(
        title: Text(meal.name),
        actions: [
          IconButton(
            icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
            context.read<FavoritesProvider>().toggle(meal);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  isFav ? 'Retiré des favoris' : 'Ajouté aux favoris',
                ),
              ),
            );
          },
          ),
        ],
      ),
      body: ListView(
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
                Row(
                  children: [
                    Chip(label: Text(meal.category)),
                    const SizedBox(width: 8),
                    Chip(label: Text(meal.area)),
                  ],
                ),
                const SizedBox(height: 16),
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
      ),
    );
  }
}