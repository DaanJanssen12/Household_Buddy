import 'package:flutter/material.dart';
import 'package:household_buddy/services/household_service.dart';
import 'package:household_buddy/services/auth_service.dart';

class SettingsPage extends StatefulWidget {
  final AuthService authService;
  final HouseholdService householdService;
  final Map<String, dynamic>? householdData;

  const SettingsPage({
    super.key,
    required this.authService,
    required this.householdService,
    required this.householdData,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool _isDarkMode;
  late Map<String, dynamic> _householdData;

  @override
  void initState() {
    super.initState();
    // Initialize the theme setting
    _isDarkMode = Theme.of(context).brightness == Brightness.dark;
    _householdData = widget.householdData ?? new Map<String, dynamic>();
  }

  // Toggle Dark Mode
  void _toggleDarkMode(bool value) {
    setState(() {
      _isDarkMode = value;
    });
    // You can update the app's theme mode globally here if you are using a theme manager
    final newThemeMode = value ? ThemeMode.dark : ThemeMode.light;
    // This is where you'd update the theme using a ThemeProvider or similar method
    // Example: Provider.of<ThemeProvider>(context, listen: false).setTheme(newThemeMode);
  }

  // Show delete confirmation dialog
  void _deleteHousehold() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Do you really want to delete this household? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                // Call the service to delete the household
                try {
                  await widget.householdService.deleteHousehold(_householdData['id']);
                  // Provide feedback and navigate back
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Household deleted')));
                  Navigator.of(context).pop(); // Or navigate to a different page
                } catch (e) {
                  print('Error deleting household: $e');
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error deleting household')));
                }
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dark Mode Toggle
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: _isDarkMode,
              onChanged: _toggleDarkMode,
            ),
            const Divider(),
            // Delete Household Button
            ListTile(
              title: const Text('Delete Household'),
              onTap: _deleteHousehold,
              tileColor: Colors.redAccent,
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
