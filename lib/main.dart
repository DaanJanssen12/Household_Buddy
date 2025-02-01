import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:household_buddy/screens/homepage_screen.dart';
import 'package:household_buddy/screens/introduction/buddy_selection_screen.dart';
import 'package:household_buddy/screens/introduction/introduction_screen.dart';
import 'package:household_buddy/screens/login/login_screen.dart';
import 'package:household_buddy/services/auth_service.dart';
import 'package:household_buddy/services/household_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

// Appwrite client initialization
  final Client client = Client()
      .setEndpoint("https://cloud.appwrite.io/v1")
      .setProject('679918610031cafdf11a')
      .setSelfSigned();
  final AuthService authService = AuthService(client);
  final HouseholdService householdService = HouseholdService(client);
  runApp(MyApp(client: client, authService: authService, householdService: householdService));
}

class MyApp extends StatelessWidget {
  final Client client;
  final AuthService authService;
  final HouseholdService householdService;

  const MyApp({super.key, required this.client, required this.authService, required this.householdService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Household Buddy',
      theme: ThemeData().copyWith(
        colorScheme: ThemeData().colorScheme.copyWith(primary: HexColor("#8d8d8d")),
      ),
      home: FutureBuilder<bool>(
        future: authService.checkIfLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ); // Loading screen
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(child: Text("Error: ${snapshot.error}")),
            );
          } else {
            bool isLoggedIn = snapshot.data ?? false;
            return isLoggedIn 
              ? HomePage(client: client) 
              : LoginScreen(authService: authService, householdService: householdService);
          }
        },
      ),
      routes: {
        '/login': (context) => LoginScreen(authService: authService, householdService: householdService),
        '/home': (context) => HomePage(client: client),
        '/introduction': (context) => IntroductionScreen(client: client),
        'buddy-selection': (context) => BuddySelectionScreen(householdName: '')
      },
    );
  }
}
