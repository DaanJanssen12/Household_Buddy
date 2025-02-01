import 'package:flutter/material.dart';

// A simple provider to manage gold amount
class GoldProvider with ChangeNotifier {
  int _gold = 0;

  int get gold => _gold;

  void addGold(int amount) {
    _gold += amount;
    notifyListeners(); // Notifies UI to update
  }
}