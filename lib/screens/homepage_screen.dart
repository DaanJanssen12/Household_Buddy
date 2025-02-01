import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:household_buddy/components/bottom_nav_bar.dart';
import 'package:household_buddy/components/top_bar.dart';
import 'package:household_buddy/screens/pages/household_page.dart';
import 'package:household_buddy/screens/pages/household_tasks_page.dart';
import 'package:household_buddy/screens/pages/settings_page.dart';
import 'package:household_buddy/services/auth_service.dart';
import 'package:household_buddy/services/household_service.dart';

class HomePage extends StatefulWidget {
  final Client client; // Pass the Appwrite Client
  const HomePage({super.key, required this.client});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AuthService _authService;
  late HouseholdService _householdService;
  Map<String, dynamic>? _household;
  int _selectedIndex = 0;

  // Initialize _pages with placeholder widgets
  List<Widget> _pages = [
    const Center(child: CircularProgressIndicator()),
    const Center(child: Text('Settings Page')),
  ];

  @override
  void initState() {
    super.initState();
    _authService = AuthService(widget.client);
    _householdService = HouseholdService(widget.client);
    _fetchHousehold();
  }

  // Fetch Household
  Future<void> _fetchHousehold() async {
    try {
      final user = await _authService?.account.get();
      if (user == null) return;
      final households = await _householdService.getHouseholds(user.$id);
      if (households.isNotEmpty) {
        setState(() {
          _household = households.first.data;
          _household?.putIfAbsent('id', () => households.first.$id);
          _pages = [
            // Pass the household data directly to HouseholdPage
            HouseholdPage(household: _household),
            HouseholdTasksPage(),
            SettingsPage(
                authService: _authService,
                householdService: _householdService,
                householdData: _household),
            // Add more pages as necessary
          ];
        });
      } else {
        Navigator.of(context).pushReplacementNamed(
            '/introduction'); // Or navigate to a different page
      }
    } catch (e) {
      print('Error fetching household: $e');
    }
  }

  // Sign Out
  Future<void> _signOut() async {
    try {
      await _authService?.logout();
      Navigator.of(context)
          .pushReplacementNamed('/login'); // Navigate back to login
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_household == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Loading...'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // Household data
    final householdName = _household!['householdName'];

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('$householdName'),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.logout),
      //       onPressed: _signOut,
      //     ),
      //   ],
      // ),
      appBar: TopBar(householdName: householdName),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
