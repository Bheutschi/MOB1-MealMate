import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category.dart';
import '../models/meal.dart';
import '../providers/favorites_provider.dart';
import '../services/api_service.dart';
import 'category_screen.dart';
import 'meal_detail_screen.dart';

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
        _errorMessage =
            'Impossible de charger les données. Vérifie ta connexion.';
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
            onPressed: () {},
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
          const SizedBox(height: 8),
          _buildRandomMealCard(_randomMeal!),
          const SizedBox(height: 24),
        ],
        Text('Catégories', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemCount: _categories.length,
          itemBuilder: (context, index) =>
              _buildCategoryCard(_categories[index]),
        ),
      ],
    );
  }

  Widget _buildRandomMealCard(Meal meal) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => MealDetailScreen(meal: meal)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              meal.imageUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                meal.name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(Category category) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CategoryScreen(category: category),
            ),
          );
        },
        child: Column(
          children: [
            Expanded(
              child: Image.network(
                category.thumbnail,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                category.name,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
