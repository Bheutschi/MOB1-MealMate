import 'package:flutter/material.dart';

import '../models/category.dart';
import '../models/meal.dart';
import '../services/api_service.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/meal_card.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key, required this.category});

  final Category category;

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final ApiService _api = ApiService();

  bool _isLoading = true;
  String? _errorMessage;
  List<Meal> _meals = [];

  @override
  void initState() {
    super.initState();
    _loadMeals();
  }

  Future<void> _loadMeals() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final meals = await _api.getMealsByCategory(widget.category.name);
      setState(() {
        _meals = meals;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage =
            'Impossible de charger les recettes. Vérifie ta connexion.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category.name)),
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
        onActionPressed: _loadMeals,
      );
    }

    if (_meals.isEmpty) {
      return const EmptyState(
        icon: Icons.no_food_outlined,
        message: 'Aucune recette dans cette catégorie.',
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
