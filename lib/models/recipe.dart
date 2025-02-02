import 'package:household_buddy/models/food_item.dart';

class Recipe {
  final String name;
  final String description;
  final List<FoodItem> ingredients;
  final List<String> tags;

  Recipe({
    required this.name,
    required this.description,
    required this.ingredients,
    this.tags = const [],
  });
}
