import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:household_buddy/notifiers/theme_notifier.dart';
import 'package:household_buddy/providers/gold_provider.dart';
import 'package:household_buddy/screens/homepage_screen.dart';
import 'package:household_buddy/screens/introduction/buddy_selection_screen.dart';
import 'package:household_buddy/screens/introduction/introduction_screen.dart';
import 'package:household_buddy/screens/login/login_screen.dart';
import 'package:household_buddy/services/auth_service.dart';
import 'package:household_buddy/services/household_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

// Appwrite client initialization
  final Client client = Client()
      .setEndpoint("https://cloud.appwrite.io/v1")
      .setProject('679918610031cafdf11a')
      .setSelfSigned();
  final AuthService authService = AuthService(client);
  final HouseholdService householdService = HouseholdService(client);

  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeNotifier()),
        ChangeNotifierProvider(create: (context) => GoldProvider(authService: authService, householdService: householdService)),
      ],
      child: MyApp(
          client: client,
          authService: authService,
          householdService: householdService)));
  // runApp(ChangeNotifierProvider<ThemeNotifier>(
  //     create: (_) => ThemeNotifier(),
  //     child: MyApp(
  //         client: client,
  //         authService: authService,
  //         householdService: householdService)));
}

class MyApp extends StatelessWidget {
  final Client client;
  final AuthService authService;
  final HouseholdService householdService;

  const MyApp(
      {super.key,
      required this.client,
      required this.authService,
      required this.householdService});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(builder: (context, themeNotifier, child) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Household Buddy',
        themeMode: themeNotifier.themeMode,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
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
                  : Theme(
                      data: ThemeData.light(),
                      child: LoginScreen(
                          authService: authService,
                          householdService: householdService));
            }
          },
        ),
        routes: {
          '/login': (context) => Theme(
                data: ThemeData
                    .light(), // Forces the LoginScreen to be light theme
                child: LoginScreen(
                    authService: authService,
                    householdService: householdService),
              ),
          '/home': (context) => HomePage(client: client),
          '/introduction': (context) => IntroductionScreen(client: client),
          'buddy-selection': (context) => BuddySelectionScreen(
              householdName: '',
              householdService: householdService,
              authService: authService)
        },
      );
    });
  }
}
