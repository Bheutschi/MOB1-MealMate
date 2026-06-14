# MealMate

Application mobile Flutter de découverte de recettes, réalisée dans le cadre du projet de cours.
Les données proviennent de l'API publique [TheMealDB](https://www.themealdb.com/api.php).

L'application permet de parcourir des recettes par catégorie, d'en rechercher par nom, d'en consulter le détail (ingrédients, instructions étape par étape, vidéo YouTube) et de garder ses préférées en favoris persistés localement.

## Auteur
**Bryan Heutschi**

## Lancement

À la racine du projet :

```bash
flutter pub get
flutter run
```

Ou en sélectionnant un appareil dans device manager puis en cliquant sur run l'app (Shift + F10) 

L'application cible **Android via l'émulateur Android Studio**.
Versions requises : Flutter 3.41 ou plus, Dart 3.11.

## Dépendances

| Package | Version minimale | Rôle |
|---------|------------------|------|
| `provider` | 6.1.5+1          | Gestion d'état partagé (favoris, thème) |
| `http` | 1.6.0            | Appels REST à TheMealDB |
| `shared_preferences` | 2.5.5            | Persistance locale (favoris, mode sombre) |
| `url_launcher` | 6.3.2            | Ouverture des vidéos YouTube dans le navigateur |

Material 3 et la navigation Navigator 1.0 sont utilisés tels qu'ils sont livrés avec Flutter, sans librairie externe.

## Structure du projet

```
lib/
├── main.dart                    # MultiProvider, MaterialApp, thèmes clair/sombre
├── models/                      # Meal, Category (fromJson + toJson)
├── services/                    # ApiService, StorageService
├── providers/                   # FavoritesProvider, ThemeProvider
├── screens/                     # 6 écrans (Home, Category, SearchResults,MealDetail, Favorites, Settings)
└── widgets/                     # MealCard, LoadingIndicator
```

## Choix techniques

- L'état partagé (favoris et mode sombre) vit dans deux `ChangeNotifier` exposés par un `MultiProvider`, aucun écran ne duplique cet état localement.
- Tous les appels HTTP passent par une méthode privée `_get` d'`ApiService` qui factorise `try/catch`, `timeout` de 10 secondes, vérification du `statusCode` et décodage JSON, ce qui garantit une gestion uniforme des erreurs réseau.
- La persistance locale est encapsulée dans un `StorageService` qui sérialise les favoris en JSON avec une clé versionnée (`favorites_v1`) pour permettre des migrations futures. 
- Tous les écrans qui chargent des données externes appliquent le même patron à trois états (chargement / erreur / contenu) avec un bouton « Réessayer ». 
- L'écran de détail recharge systématiquement la recette complète via `lookup.php`, car `filter.php` ne renvoie que des données partielles. 
- La « Découverte du jour » est mise en cache pour 24 heures, ce qui correspond à sa promesse sémantique. 
- Les thèmes clair et sombre dérivent d'une unique couleur de graine via `ColorScheme.fromSeed`, garantissant la cohérence visuelle.

## Score SUS

Test SUS réalisé auprès de **3** testeur.
Score moyen obtenu : **94** / 100.

## Outils d'IA utilisés

**Claude** a été utilisé tout au long du développement comme consultant technique. En particulier :

- Conseils sur les patrons Flutter (`StatefulWidget` / `StatelessWidget`, `Provider`, distinction `context.watch` / `context.read`).
- Aide au débogage (erreurs IDE, comportements de défilement, dépréciations de l'API Flutter type `CardTheme` → `CardThemeData`).
- Recommandations sur le choix de widgets Material 3 (`Card`, `Chip`, `SwitchListTile`, `Badge`, `Dismissible`, `IconButton` avec `Badge`, `AlertDialog`).
- Aide pour la rédaction du README.