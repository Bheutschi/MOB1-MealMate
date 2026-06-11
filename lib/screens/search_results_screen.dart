import 'package:flutter/material.dart';

import '../models/meal.dart';
import '../services/api_service.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/meal_card.dart';

class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({super.key, required this.query});

  final String query;

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  final ApiService _api = ApiService();

  bool _isLoading = true;
  String? _errorMessage;
  List<Meal> _meals = [];

  @override
  void initState() {
    super.initState();
    _runSearch();
  }

  Future<void> _runSearch() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final meals = await _api.searchMeals(widget.query);
      setState(() {
        _meals = meals;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage =
            'Impossible de lancer la recherche. Vérifie ta connexion.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Résultats : "${widget.query}"')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) return const LoadingIndicator();

    if (_errorMessage != null) {
      return EmptyState(
        icon: Icons.error_outline,
        message: _errorMessage!,
        actionLabel: 'Réessayer',
        onActionPressed: _runSearch,
      );
    }

    if (_meals.isEmpty) {
      return EmptyState(
        icon: Icons.search_off,
        message: 'Aucune recette trouvée pour "${widget.query}".',
        actionLabel: 'Retour',
        onActionPressed: () => Navigator.pop(context),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: _meals.length,
      itemBuilder: (context, index) => MealCard(meal: _meals[index]),
    );
  }
}
