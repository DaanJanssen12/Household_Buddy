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
  List<Recipe> filteredRecipes = [];
  List<String> availableTags = [];  // This will store tags from all recipes.
  String selectedTag = '';  // For tag filter
  
  @override
  void initState() {
    super.initState();
    filteredRecipes = recipes; // Initially show all recipes
  }

  void _filterRecipesByTag(String tag) {
    setState(() {
      selectedTag = tag;
      if (tag.isEmpty) {
        filteredRecipes = recipes; // Show all recipes if no tag is selected
      } else {
        filteredRecipes = recipes.where((recipe) => recipe.tags.contains(tag)).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipes'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              final newRecipe = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CreateRecipePage()),
              );
              if (newRecipe != null) {
                setState(() {
                  recipes.add(newRecipe);
                  availableTags.addAll(newRecipe.tags); 
                  availableTags = availableTags.toSet().toList(); // Remove duplicates
                });
                //remove current filter
                _filterRecipesByTag('');
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Tag filter dropdown
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: selectedTag.isEmpty ? null : selectedTag,
              hint: Text("Filter by Tag"),
              onChanged: (value) {
                _filterRecipesByTag(value ?? '');
              },
              items: [null, ...availableTags].map<DropdownMenuItem<String>>((String? tag) {
                return DropdownMenuItem<String>(
                  value: tag,
                  child: Text(tag ?? 'All'),
                );
              }).toList(),
            ),
          ),
          
          // Recipe List
          Expanded(
            child: ListView.builder(
              itemCount: filteredRecipes.length,
              itemBuilder: (context, index) {
                final recipe = filteredRecipes[index];
                return Stack(
                  children: [
                    Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text(recipe.name),
                        subtitle: null, // Remove the subtitle (description)
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RecipeDetailPage(recipe: recipe),
                            ),
                          );
                        },
                      ),
                    ),
                    // Tags on top-right
                    Positioned(
                      top: 10,
                      right: 10,
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
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
