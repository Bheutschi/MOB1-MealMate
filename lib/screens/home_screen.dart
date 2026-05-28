import 'package:flutter/material.dart';
import 'package:mealmate/models/meal.dart';
import 'package:provider/provider.dart';

import '../providers/favorites_provider.dart';
import '../widgets/meal_card.dart';

class HomeScreen extends StatelessWidget {
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
        title: Text('MealMate'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Badge(
              label: Text('$favoritesCount'),
              isLabelVisible: favoritesCount > 0,
              child: const Icon(Icons.favorite),
            ),
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
