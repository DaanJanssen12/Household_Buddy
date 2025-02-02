import 'package:flutter/material.dart';
import 'package:household_buddy/models/recipe.dart';

class RecipeDetailPage extends StatelessWidget {
  final Recipe recipe;

  RecipeDetailPage({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(recipe.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              recipe.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 16),
            Text('Ingredients:', style: Theme.of(context).textTheme.headlineSmall),
            ...recipe.ingredients.map((ingredient) {
              return Text('${ingredient.name}: ${ingredient.quantity}');
            }).toList(),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Add all ingredients to grocery list
                // Assuming you have a method to update your grocery list
                // groceryList.addAll(recipe.ingredients);
                Navigator.pop(context);
              },
              child: Text('Add All Ingredients to Grocery List'),
            ),
          ],
        ),
      ),
    );
  }
}
