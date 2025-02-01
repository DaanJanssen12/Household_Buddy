import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:household_buddy/services/auth_service.dart';
import 'package:household_buddy/services/household_service.dart';
import 'buddy_selection_screen.dart'; // Import BuddySelectionScreen

class IntroductionScreen extends StatefulWidget {
  final Client client; // Pass the Appwrite Client

  const IntroductionScreen({super.key, required this.client});

  @override
  _IntroductionScreenState createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  final TextEditingController _householdNameController = TextEditingController();
  late HouseholdService _householdService;
  late AuthService _authService;

  @override
  void initState() {
    super.initState();
    _authService = AuthService(widget.client);
    _householdService = HouseholdService(widget.client);
  }

  Future<void> startBuddySelection() async {
    final householdName = _householdNameController.text.trim();
    
    if (householdName.isNotEmpty) {
      final user = await _authService.getUser();

      try {
        // Navigate to the BuddySelectionScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BuddySelectionScreen(householdName: householdName, householdService: _householdService, authService: _authService),
          ),
        );
      } catch (e) {
        print("Failed to create household: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Something went wrong. Please try again.")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a household name")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFAD961), Color(0xFFF76B1C)], // Warm playful gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title
            const Text(
              "Welcome to Household Buddy!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            // Household name input
            const Text(
              "Please enter your Household Name:",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.white70),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _householdNameController,
              decoration: InputDecoration(
                hintText: "Enter household name",
                hintStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.white.withOpacity(0.7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Next button
            ElevatedButton(
              onPressed: startBuddySelection,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                "Start",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
