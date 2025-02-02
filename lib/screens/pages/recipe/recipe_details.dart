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
            // Tags positioned at the top-right
            Align(
              alignment: Alignment.topRight,
              child: Wrap(
                spacing: 4,
                children: recipe.tags.map((tag) {
                  return Chip(
                    label: Text(tag),
                    labelStyle: TextStyle(fontSize: 10), // Smaller tags
                    backgroundColor: Colors.blueAccent.withOpacity(0.1),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 16),
            // Description
            Text(
              recipe.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 16),
            // Ingredients List
            Text("Ingredients:", style: Theme.of(context).textTheme.titleMedium),
            ...recipe.ingredients.map((ingredient) {
              return Text('${ingredient.name}: ${ingredient.quantity}');
            }).toList(),
          ],
        ),
      ),
    );
  }
}
