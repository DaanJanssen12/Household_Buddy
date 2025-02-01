import 'package:flutter/material.dart';

class HouseholdNameScreen extends StatefulWidget {
  final Function(String) onNextStep; // Callback to pass name to next step

  const HouseholdNameScreen({super.key, required this.onNextStep});

  @override
  _HouseholdNameScreenState createState() => _HouseholdNameScreenState();
}

class _HouseholdNameScreenState extends State<HouseholdNameScreen> {
  final TextEditingController _householdController = TextEditingController();
  bool _isButtonActive = false;

  @override
  void initState() {
    super.initState();
    _householdController.addListener(() {
      setState(() {
        _isButtonActive = _householdController.text.trim().isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8EC5FC), Color(0xFFE0C3FC)], // Playful gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Step Indicator
            const Text(
              "Step 1 of 2",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white70),
            ),
            const SizedBox(height: 10),

            // Title
            const Text(
              "Choose a Household Name",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            // Text Input Field
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _householdController,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter a name...",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 30),

            // Continue Button
            ElevatedButton(
              onPressed: _isButtonActive
                  ? () => widget.onNextStep(_householdController.text.trim()) // Pass name to next step
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: _isButtonActive ? 5 : 0,
              ),
              child: const Text("Continue", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
