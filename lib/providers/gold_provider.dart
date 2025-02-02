import 'package:flutter/material.dart';
import 'package:household_buddy/services/auth_service.dart';
import 'package:household_buddy/services/household_service.dart';

// A simple provider to manage gold amount
class GoldProvider with ChangeNotifier {
  int _gold = 0;

  int get gold => _gold;

  final HouseholdService householdService;
  final AuthService authService;
  GoldProvider({required this.authService, required this.householdService}){
    init();
  }

  Future<void> init() async{
    var user = await authService.getUser();
    if(user == null) return;

    if(!(await householdService.hasHousehold(user.$id))) return;

    var households = await householdService.getHouseholds(user.$id);   
    var gold = (households.first.data['gold'] ?? 0) as int;
    _gold += gold;
    notifyListeners();
  }

  void addGold(String householdId, int amount) async{
    _gold += amount;
    notifyListeners();

    await householdService.setGold(householdId, _gold);
  }
}