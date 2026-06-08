import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
        _errorMessage =
            'Impossible de charger les détails. Vérifie ta connexion.';
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
      padding: const EdgeInsets.all(16),
      children: [
        Image.network(
          meal.imageUrl,
          height: 220,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        const SizedBox(height: 16),
        Text(
          meal.name,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            if (meal.category.isNotEmpty) Chip(label: Text(meal.category)),
            if (meal.country.isNotEmpty) Chip(label: Text(meal.country)),
          ],
        ),
        if (meal.youtubeUrl != null && meal.youtubeUrl!.isNotEmpty) ...[
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => _openYoutube(meal.youtubeUrl!),
              icon: const Icon(Icons.play_circle_outline),
              label: const Text('Voir la vidéo'),
            ),
          ),
        ],
        if (meal.ingredients.isNotEmpty) ...[
          const SizedBox(height: 24),
          _buildSectionHeader(
            context,
            Icons.shopping_basket_outlined,
            'Ingrédients',
          ),
          const SizedBox(height: 12),
          ...List.generate(meal.ingredients.length, (i) {
            return _buildIngredientRow(
              context,
              meal.measures[i],
              meal.ingredients[i],
            );
          }),
        ],
        const SizedBox(height: 24),
        _buildSectionHeader(context, Icons.menu_book_outlined, 'Instructions'),
        const SizedBox(height: 12),
        ..._buildSteps(context, meal.instructions),
        const SizedBox(height: 24),
      ],
    );
  }

  Future<void> _openYoutube(String url) async {
    final messenger = ScaffoldMessenger.of(context);
    final uri = Uri.parse(url);

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && mounted) {
        messenger.showSnackBar(
          const SnackBar(content: Text("Impossible d'ouvrir la vidéo.")),
        );
      }
    } catch (_) {
      if (mounted) {
        messenger.showSnackBar(
          const SnackBar(content: Text("Impossible d'ouvrir la vidéo.")),
        );
      }
    }
  }

  Widget _buildSectionHeader(
    BuildContext context,
    IconData icon,
    String title,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, color: colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildIngredientRow(
    BuildContext context,
    String measure,
    String ingredient,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              measure.trim().isEmpty ? '—' : measure.trim(),
              style: TextStyle(
                color: colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              ingredient,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSteps(BuildContext context, String instructions) {
    final colorScheme = Theme.of(context).colorScheme;
    final steps = instructions
        .split(RegExp(r'\r?\n+'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    return List.generate(steps.length, (i) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Text(
                '${i + 1}',
                style: TextStyle(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  steps[i],
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
