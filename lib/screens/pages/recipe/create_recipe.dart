import 'package:flutter/material.dart';
import 'package:household_buddy/models/food_item.dart';
import 'package:household_buddy/models/recipe.dart';

class CreateRecipePage extends StatefulWidget {
  @override
  _CreateRecipePageState createState() => _CreateRecipePageState();
}

class _CreateRecipePageState extends State<CreateRecipePage> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _ingredientNameController = TextEditingController();
  final _ingredientQuantityController = TextEditingController();
  final List<FoodItem> _ingredients = [];
  final List<String> _tags = [];

  void _addIngredient() {
    final name = _ingredientNameController.text;
    final quantity = _ingredientQuantityController.text;
    if (name.isNotEmpty && quantity.isNotEmpty) {
      setState(() {
        _ingredients.add(FoodItem(name: name, quantity: quantity));
      });
    }
  }

  void _saveRecipe() {
    final name = _nameController.text;
    final description = _descriptionController.text;
    if (name.isNotEmpty && _ingredients.isNotEmpty) {
      final newRecipe = Recipe(
        name: name,
        description: description,
        ingredients: _ingredients,
        tags: _tags,
      );
      Navigator.pop(context, newRecipe);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Recipe')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Recipe Name'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _ingredientNameController,
                decoration: InputDecoration(labelText: 'Ingredient Name'),
              ),
              TextField(
                controller: _ingredientQuantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Ingredient Quantity'),
              ),
              ElevatedButton(
                onPressed: _addIngredient,
                child: Text('Add Ingredient'),
              ),
              SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _ingredients.map((ingredient) {
                  return Text('${ingredient.name}: ${ingredient.quantity}');
                }).toList(),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveRecipe,
                child: Text('Save Recipe'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
