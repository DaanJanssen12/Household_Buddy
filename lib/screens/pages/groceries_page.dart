import 'package:flutter/material.dart';

class GroceryItem {
  String name;
  String quantity; // For variable quantities (e.g., "500g", "3 sachets")
  
  GroceryItem({required this.name, required this.quantity});
}

class GroceriesPage extends StatefulWidget {
  @override
  _GroceriesPageState createState() => _GroceriesPageState();
}

class _GroceriesPageState extends State<GroceriesPage> with SingleTickerProviderStateMixin {
  List<String> shoppingList = [];
  List<GroceryItem> pantryList = [];
  TextEditingController itemController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  // Add a TabController
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Initialize TabController with 2 tabs
    _tabController = TabController(length: 2, vsync: this);
  }

  void _addItemToShoppingList() {
    if (itemController.text.isNotEmpty) {
      setState(() {
        shoppingList.add(itemController.text);
        itemController.clear();
      });
    }
  }

  void _moveToPantry(int index) {
    // Prompt for quantity input when moving to the pantry
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Set Quantity for ${shoppingList[index]}'),
          content: TextField(
            controller: quantityController,
            decoration: InputDecoration(hintText: "Enter quantity (e.g., '500g', '3 sachets')"),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (quantityController.text.isNotEmpty) {
                  setState(() {
                    pantryList.add(GroceryItem(name: shoppingList[index], quantity: quantityController.text));
                    shoppingList.removeAt(index);
                    quantityController.clear();
                  });
                }
                Navigator.pop(context);
              },
              child: Text('Add to Pantry'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _removeFromPantry(int index) {
    setState(() {
      pantryList.removeAt(index);
    });
  }

  void _increaseQuantity(int index) {
    setState(() {
      int currentQuantity = int.tryParse(pantryList[index].quantity.split(' ')[0]) ?? 0;
      currentQuantity++;
      pantryList[index].quantity = "$currentQuantity ${pantryList[index].quantity.split(' ')[1]}"; // Increases quantity by 1
    });
  }

  void _decreaseQuantity(int index) {
    setState(() {
      int currentQuantity = int.tryParse(pantryList[index].quantity.split(' ')[0]) ?? 0;
      if (currentQuantity > 1) {
        currentQuantity--;
        pantryList[index].quantity = "$currentQuantity ${pantryList[index].quantity.split(' ')[1]}"; // Decreases quantity by 1
      }
    });
  }

  void _addAllToPantry() {
    setState(() {
      for (var item in shoppingList) {
        pantryList.add(GroceryItem(name: item, quantity: "1 unit"));
      }
      shoppingList.clear();
    });
  }

  // Function to add items directly to the pantry
  void _addItemToPantry() {
    if (itemController.text.isNotEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Set Quantity for ${itemController.text}'),
            content: TextField(
              controller: quantityController,
              decoration: InputDecoration(hintText: "Enter quantity (e.g., '500g', '3 sachets')"),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  if (quantityController.text.isNotEmpty) {
                    setState(() {
                      pantryList.add(GroceryItem(name: itemController.text, quantity: quantityController.text));
                      itemController.clear();
                      quantityController.clear();
                    });
                  }
                  Navigator.pop(context);
                },
                child: Text('Add to Pantry'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Groceries"),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: "Shopping List"),
            Tab(text: "Pantry"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Shopping List Tab
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: itemController,
                        decoration: InputDecoration(hintText: "Add a grocery item"),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add, color: Colors.blue),
                      onPressed: _addItemToShoppingList,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: _addAllToPantry,
                child: Text("Move All to Pantry"),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: shoppingList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                      child: ListTile(
                        title: Text(shoppingList[index]),
                        trailing: IconButton(
                          icon: Icon(Icons.check, color: Colors.green),
                          onPressed: () => _moveToPantry(index),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          // Pantry Tab
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: itemController,
                        decoration: InputDecoration(hintText: "Add directly to pantry"),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add, color: Colors.blue),
                      onPressed: _addItemToPantry,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: pantryList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                      child: ListTile(
                        title: Text(pantryList[index].name),
                        subtitle: Text("Quantity: ${pantryList[index].quantity}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove, color: Colors.red),
                              onPressed: () => _decreaseQuantity(index),
                            ),
                            IconButton(
                              icon: Icon(Icons.add, color: Colors.green),
                              onPressed: () => _increaseQuantity(index),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removeFromPantry(index),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
