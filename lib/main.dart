import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:household_buddy/screens/homepage_screen.dart';
import 'package:household_buddy/screens/login/login_screen.dart';
import 'package:household_buddy/services/auth_service.dart';

// Appwrite client initialization
final Client client = Client();

void main() {
  // Set up the Appwrite client
  client
      .setEndpoint("https://cloud.appwrite.io/v1")
      .setProject('679918610031cafdf11a');

  final AuthService authService = AuthService(client);

  runApp(MyApp(client: client, authService: authService));
}

class MyApp extends StatelessWidget {
  final Client client;
  final AuthService authService;

  const MyApp({Key? key, required this.client, required this.authService})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Household Buddy',
      theme: ThemeData().copyWith(
          colorScheme:
              ThemeData().colorScheme.copyWith(primary: HexColor("#8d8d8d"))),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(authService),
        '/home': (context) => HomePage(client: client),
      },
    );
  }
}
