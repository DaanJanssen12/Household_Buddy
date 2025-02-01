import 'package:flutter/material.dart';
import 'package:household_buddy/services/auth_service.dart';
import 'package:household_buddy/services/household_service.dart';

class BuddySelectionScreen extends StatefulWidget {
  final String householdName;
  final HouseholdService householdService;
  final AuthService authService;
  const BuddySelectionScreen(
      {super.key,
      required this.householdName,
      required this.householdService,
      required this.authService});

  @override
  _BuddySelectionScreenState createState() => _BuddySelectionScreenState();
}

class _BuddySelectionScreenState extends State<BuddySelectionScreen> {
  int _selectedBuddyIndex = 0;
  final TextEditingController _buddyNameController = TextEditingController();

  // List of available buddies
  final List<Map<String, String>> buddies = [
    {"id": "1", "image": "assets/Images/buddy1.png"},
    {"id": "2", "image": "assets/Images/buddy2.png"},
    {"id": "3", "image": "assets/Images/buddy3.png"},
    {"id": "4", "image": "assets/Images/buddy4.png"},
  ];

  void _nextBuddy() {
    setState(() {
      _selectedBuddyIndex = (_selectedBuddyIndex + 1) % buddies.length;
      _buddyNameController.clear(); // Clear the name field when switching buddy
    });
  }

  void _previousBuddy() {
    setState(() {
      _selectedBuddyIndex =
          (_selectedBuddyIndex - 1 + buddies.length) % buddies.length;
      _buddyNameController.clear(); // Clear the name field when switching buddy
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedBuddy = buddies[_selectedBuddyIndex];

    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFAD961),
              Color(0xFFF76B1C)
            ], // Warm playful gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Step Indicator
            const Text(
              "Step 2 of 2",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70),
            ),
            const SizedBox(height: 10),

            // Title
            Text(
              "Meet Your New Buddy!",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            // Buddy Image
            SizedBox(
              height: 200,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Left Arrow Button
                  Positioned(
                    left: 0,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios,
                          color: Colors.white, size: 30),
                      onPressed: _previousBuddy,
                    ),
                  ),

                  // Buddy Image with Animated Fade-In
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Image.asset(
                      selectedBuddy["image"]!,
                      key: ValueKey(selectedBuddy["image"]),
                      height: 180,
                    ),
                  ),

                  // Right Arrow Button
                  Positioned(
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios,
                          color: Colors.white, size: 30),
                      onPressed: _nextBuddy,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // TextField for naming the buddy
            TextField(
              controller: _buddyNameController,
              decoration: InputDecoration(
                labelText: "Give your buddy a name",
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),

            // Confirm Button
            ElevatedButton(
              onPressed: () async {
                if (_buddyNameController.text.isNotEmpty) {
                  final buddyName = _buddyNameController.text;
                  var user = await widget.authService.getUser();
                  await widget.householdService.createHousehold(user.$id,
                      widget.householdName, _selectedBuddyIndex + 1, buddyName);
                  Navigator.pushNamed(context, '/home'); // Adjust to your route
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text("Adopt Buddy",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
