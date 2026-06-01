import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/favorites_provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final favoritesCount = context.watch<FavoritesProvider>().count;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Paramètres')),
      body: ListView(
        children: [
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode_outlined),
            title: const Text('Mode sombre'),
            subtitle: const Text('Bascule entre thème clair et sombre'),
            value: themeProvider.isDarkMode,
            onChanged: (_) => themeProvider.toggle(),
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.delete_outline, color: colorScheme.error),
            title: Text(
              'Effacer tous mes favoris',
              style: TextStyle(color: colorScheme.error),
            ),
            subtitle: Text(
              favoritesCount == 0
                  ? 'Aucun favori à effacer'
                  : '$favoritesCount recette(s) seront supprimée(s)',
            ),
            enabled: favoritesCount > 0,
            onTap: () => _confirmClearFavorites(context),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'À propos',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const ListTile(
            leading: Icon(Icons.restaurant_menu),
            title: Text('MealMate'),
            subtitle: Text('Version 1.0.0'),
          ),
          const ListTile(
            leading: Icon(Icons.cloud_outlined),
            title: Text('Données des recettes'),
            subtitle: Text('Fournies par TheMealDB'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmClearFavorites(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Effacer tous les favoris ?'),
        content: const Text(
          'Cette action est irréversible. Toutes tes recettes favorites seront supprimées.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Effacer'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await context.read<FavoritesProvider>().clearAll();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tous les favoris ont été effacés'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }
}
