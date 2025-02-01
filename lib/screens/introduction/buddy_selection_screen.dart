import 'package:flutter/material.dart';

class BuddySelectionScreen extends StatefulWidget {
  final String householdName;

  const BuddySelectionScreen({super.key, required this.householdName});

  @override
  _BuddySelectionScreenState createState() => _BuddySelectionScreenState();
}

class _BuddySelectionScreenState extends State<BuddySelectionScreen> {
  int _selectedBuddyIndex = 0;

  // List of available buddies
  final List<Map<String, String>> buddies = [
    {"name": "Fuzzy", "image": "assets/buddy1.png"},
    {"name": "Sparky", "image": "assets/buddy2.png"},
    {"name": "Whiskers", "image": "assets/buddy3.png"},
    {"name": "Blinky", "image": "assets/buddy4.png"},
  ];

  void _nextBuddy() {
    setState(() {
      _selectedBuddyIndex = (_selectedBuddyIndex + 1) % buddies.length;
    });
  }

  void _previousBuddy() {
    setState(() {
      _selectedBuddyIndex = (_selectedBuddyIndex - 1 + buddies.length) % buddies.length;
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
            colors: [Color(0xFFFAD961), Color(0xFFF76B1C)], // Warm playful gradient
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
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white70),
            ),
            const SizedBox(height: 10),

            // Title
            Text(
              "Meet Your New Buddy, ${widget.householdName}!",
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
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Left Arrow Button
                  Positioned(
                    left: 10,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 30),
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
                    right: 10,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 30),
                      onPressed: _nextBuddy,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Buddy Name
            Text(
              selectedBuddy["name"]!,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 30),

            // Confirm Button
            ElevatedButton(
              onPressed: () {
                // Finalize selection (could save this info to a database)
                print("Buddy Selected: ${selectedBuddy["name"]}");
                // Navigate to home or next step
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text("Adopt Buddy", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
