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
  final _tagController = TextEditingController();

  final List<FoodItem> _ingredients = [];
  final List<String> _tags = [];

  // Add an ingredient to the list
  void _addIngredient() {
    setState(() {
      _ingredients.add(FoodItem(name: '', quantity: ''));
    });
  }

  // Add a tag to the list
  void _addTag() {
    setState(() {
      _tags.add('');
    });
  }

  // Remove an ingredient
  void _removeIngredient(int index) {
    setState(() {
      _ingredients.removeAt(index);
    });
  }

  // Remove a tag
  void _removeTag(int index) {
    setState(() {
      _tags.removeAt(index);
    });
  }

  // Save the recipe
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Recipe Name'),
              ),
              SizedBox(
                  height: 16), // Add some space between name and description
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              SizedBox(height: 16),
              // Ingredients Section
              Text('Ingredients:',
                  style: Theme.of(context).textTheme.titleLarge),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: _addIngredient,
                  ),
                ],
              ),
              Column(
                children: _ingredients.map((ingredient) {
                  int index = _ingredients.indexOf(ingredient);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Ingredient name and quantity input
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: TextField(
                              controller:
                                  TextEditingController(text: ingredient.name),
                              decoration:
                                  InputDecoration(labelText: 'Ingredient Name'),
                              onChanged: (value) {
                                setState(() {
                                  _ingredients[index] = FoodItem(
                                      name: value,
                                      quantity: ingredient.quantity);
                                });
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: TextEditingController(
                                text: ingredient.quantity),
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(labelText: 'Quantity'),
                            onChanged: (value) {
                              setState(() {
                                _ingredients[index] = FoodItem(
                                    name: ingredient.name, quantity: value);
                              });
                            },
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _removeIngredient(index),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 16),
              // Tags Section
              Text('Tags:', style: Theme.of(context).textTheme.titleLarge),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: _addTag,
                  ),
                ],
              ),
              Column(
                children: _tags.map((tag) {
                  int index = _tags.indexOf(tag);
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: TextField(
                            controller: TextEditingController(
                                text: tag),
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(labelText: 'Tag'),
                            onChanged: (value) {
                              setState(() {
                                _tags[index] = value;
                              });
                            },
                          ),
                        ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _removeTag(index),
                      ),
                    ],
                  );
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
