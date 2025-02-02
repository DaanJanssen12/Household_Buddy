import 'package:flutter/material.dart';
import 'package:household_buddy/models/recipe.dart';
import 'package:household_buddy/screens/pages/recipe/create_recipe.dart';
import 'package:household_buddy/screens/pages/recipe/recipe_details.dart';

class RecipesPage extends StatefulWidget {
  @override
  _RecipesPageState createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  List<Recipe> recipes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipes'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              // Navigate to the "Create Recipe" page
              final newRecipe = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CreateRecipePage()),
              );
              if (newRecipe != null) {
                setState(() {
                  recipes.add(newRecipe);
                });
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return ListTile(
            title: Text(recipe.name),
            subtitle: Text(recipe.description),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RecipeDetailPage(recipe: recipe),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
