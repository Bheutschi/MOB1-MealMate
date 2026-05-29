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
