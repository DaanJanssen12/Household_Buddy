import 'package:flutter/material.dart';
import 'package:household_buddy/notifiers/theme_notifier.dart';
import 'package:household_buddy/services/auth_service.dart';
import 'package:household_buddy/services/household_service.dart';
import 'package:provider/provider.dart';

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
  late Map<String, dynamic>? _householdData;

  @override
  void initState() {
    super.initState();
    _householdData = widget.householdData;
  }

  // Toggle Dark Mode
  void _toggleDarkMode(bool value) {
    // Update theme state globally using ThemeNotifier
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    themeNotifier.toggleTheme();
    setState(() {
      _isDarkMode = value;
    });
  }

  // Show delete confirmation dialog
  void _deleteHousehold() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text(
              'Do you really want to delete this household? This action cannot be undone. You will be logged out after this action.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog

                try {
                  // Delete the household
                  await widget.householdService
                      .deleteHousehold(_householdData?['id']);
                  // Log the user out
                  await widget.authService.logout();

                  // Ensure the widget is still mounted before navigating
                  if (mounted) {
                    // Pop all screens and navigate to login screen
                    Navigator.popUntil(context, (route) => route.isFirst);
                    Navigator.pushReplacementNamed(context, '/login');
                  }
                } catch (e) {
                  print('Error deleting household: $e');
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
    // Initialize theme mode directly in the build method to avoid flickering
    _isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
