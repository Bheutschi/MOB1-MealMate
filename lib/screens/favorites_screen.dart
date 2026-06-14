import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/meal.dart';
import '../providers/favorites_provider.dart';
import '../widgets/loading_indicator.dart';
import 'meal_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FavoritesProvider>();
    final favorites = provider.favorites;

    if (provider.isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Mes favoris')),
        body: const LoadingIndicator(),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Mes favoris')),
      body: favorites.isEmpty
          ? EmptyState(
              icon: Icons.favorite_border,
              message: "Aucun favori pour l'instant",
              actionLabel: 'Découvrir des recettes',
              onActionPressed: () => Navigator.pop(context),
            )
          : _buildList(context, favorites),
    );
  }

  Widget _buildList(BuildContext context, List<Meal> favorites) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListView.builder(
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final meal = favorites[index];

        final swipeBg = Container(
          color: colorScheme.errorContainer,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Icon(Icons.delete, color: colorScheme.onErrorContainer),
        );

        return Dismissible(
          key: ValueKey(meal.id),
          direction: DismissDirection.horizontal,
          background: Align(alignment: Alignment.centerLeft, child: swipeBg),
          secondaryBackground: Align(
            alignment: Alignment.centerRight,
            child: swipeBg,
          ),
          onDismissed: (_) {
            final messenger = ScaffoldMessenger.of(context);
            context.read<FavoritesProvider>().toggle(meal);
            messenger.removeCurrentSnackBar();
            messenger.showSnackBar(
              SnackBar(
                content: Text('${meal.name} retiré des favoris'),
                duration: const Duration(seconds: 1),
              ),
            );
          },
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                meal.imageUrl,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(meal.name),
            subtitle: Text('${meal.category} | ${meal.country}'),
            trailing: IconButton(
              icon: Icon(
                Icons.favorite,
                color: Theme.of(context).colorScheme.primary,
              ),
              tooltip: 'Retirer des favoris',
              onPressed: () {
                final messenger = ScaffoldMessenger.of(context);
                context.read<FavoritesProvider>().toggle(meal);
                messenger.removeCurrentSnackBar();
                messenger.showSnackBar(
                  SnackBar(
                    content: Text('${meal.name} retiré des favoris'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => MealDetailScreen(meal: meal)),
            ),
          ),
        );
      },
    );
  }
}
