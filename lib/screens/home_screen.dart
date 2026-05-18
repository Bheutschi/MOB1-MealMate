import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mealmate/models/meal.dart';

import '../widgets/meal_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<Meal> mockMeals = const [
    Meal(
        id: '1',
        name: 'Spaghetti Carbonara',
        category: 'Vegetarian',
        area: 'Italian',
        country: 'Italy',
        instructions: 'Bring a large pot of water to a boil. Add kosher salt to the boiling water, then add the pasta. Cook according to the package instructions, about 9 minutes.\r\nIn a large skillet over medium-high heat, add the olive oil and heat until the oil starts to shimmer. Add the garlic and cook, stirring, until fragrant, 1 to 2 minutes. Add the chopped tomatoes, red chile flakes, Italian seasoning and salt and pepper to taste. Bring to a boil and cook for 5 minutes. Remove from the heat and add the chopped basil.\r\nDrain the pasta and add it to the sauce. Garnish with Parmigiano-Reggiano flakes and more basil and serve warm.',
        imageUrl: 'https:\/\/www.themealdb.com\/images\/media\/meals\/ustsqw1468250014.jpg'
    ),
    Meal(
        id: '2',
        name: 'Chicken Alfredo',
        category: 'Non-Vegetarian',
        area: 'Italian',
        country: 'Italy',
        instructions: 'Cook the fettuccine according to the package instructions. Drain and set aside.\r\nIn a large skillet, melt the butter over medium heat. Add the garlic and cook until fragrant, about 1 minute. Add the heavy cream and bring to a simmer. Reduce the heat to low and stir in the Parmesan cheese until melted and smooth. Season with salt and pepper to taste.\r\nAdd the cooked fettuccine to the skillet and toss to coat in the sauce. Serve immediately, garnished with additional Parmesan cheese if desired.',
        imageUrl: 'https:\/\/www.themealdb.com\/images\/media\/meals\/sypxpx1515365095.jpg'
    ),
    Meal(
        id: '3',
        name: 'Vietnamese-style veggie hotpot',
        category: 'Vegetarian',
        area: 'Vietnamese',
        country: 'Vietnam',
        instructions: 'step 1\r\nHeat the oil in a medium-size, lidded saucepan. Add the ginger and garlic, then stir-fry for about 5 mins. Add the squash, soy sauce, sugar and stock. Cover, then simmer for 10 mins. Remove the lid, add the green beans, then cook for 3 mins more until the squash and beans are tender. Stir the spring onions through at the last minute, then sprinkle with coriander and serve with rice.',
        imageUrl: 'https:\/\/www.themealdb.com\/images\/media\/meals\/4uje7l1763762276.jpg'
    ),
    Meal(
        id: '4',
        name: 'Beef Tacos',
        category: 'Non-Vegetarian',
        area: 'Mexican',
        country: 'Mexico',
        instructions: 'In a large skillet, cook the ground beef over medium heat until browned. Drain any excess fat.\r\nAdd the taco seasoning and water to the skillet and stir to combine. Simmer for 5 minutes until the sauce has thickened.\r\nWarm the taco shells according to the package instructions. Fill each shell with the seasoned beef and top with shredded lettuce, diced tomatoes, shredded cheese, and any other desired toppings.',
        imageUrl: 'https:\/\/www.themealdb.com\/images\/media\/meals\/qtuwxu1468233098.jpg'
    ),
    Meal(
        id: '5',
        name: 'Margherita Pizza',
        category: 'Vegetarian',
        area: 'Italian',
        country: 'Italy',
        instructions: 'Preheat the oven to 475°F (245°C). Roll out the pizza dough on a floured surface to your desired thickness.\r\nTransfer the rolled-out dough to a pizza stone or baking sheet. Spread the tomato sauce evenly over the dough, leaving a small border around the edges. Sprinkle the shredded mozzarella cheese over the sauce and top with fresh basil leaves.\r\nBake in the preheated oven for 10-12 minutes, or until the crust is golden and the cheese is bubbly and slightly browned. Remove from the oven and let cool for a few minutes before slicing and serving.',
        imageUrl: 'https:\/\/www.themealdb.com\/images\/media\/meals\/x0lk931587671540.jpg'
    ),
    Meal(
        id: '6',
        name: 'Pad Thai',
        category: 'Non-Vegetarian',
        area: 'Thai',
        country: 'Thailand',
        instructions: 'Cook the rice noodles according to the package instructions. Drain and set aside.\r\nIn a large skillet or wok, heat the vegetable oil over medium-high heat. Add the garlic and cook until fragrant, about 1 minute. Add the shrimp and cook until pink and cooked through, about 2-3 minutes. Remove the shrimp from the skillet and set aside.\r\nIn the same skillet, add the beaten eggs and scramble until cooked through. Add the cooked noodles, tamarind paste, fish sauce, sugar, and red pepper flakes. Toss to combine and cook for an additional 2-3 minutes until heated through.\r\nReturn the cooked shrimp to the skillet and toss to combine. Serve immediately, garnished with chopped peanuts and fresh lime wedges.',
        imageUrl: 'https:\/\/www.themealdb.com\/images\/media\/meals\/rg9ze01763479093.jpg'
    )
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MealMate'),
      ),
      body: ListView.builder(
        itemCount: mockMeals.length,
        itemBuilder: (context, index) {
          final meal = mockMeals[index];
          return MealCard(meal: meal);
        },
      )
    );
  }

}