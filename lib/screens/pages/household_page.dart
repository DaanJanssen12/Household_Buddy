import 'package:flutter/material.dart';

class HouseholdPage extends StatelessWidget {
  final Map<String, dynamic>? household; // Receive household data

  const HouseholdPage({super.key, required this.household});

  @override
  Widget build(BuildContext context) {
    if (household == null) {
      return Center(
        child: Text(
          'No household data available.',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      );
    }

    final String buddyName = household!['buddyName'];
    final int buddyId = household!['buddyId'];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Household card with buddy greeting
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Hello!',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/Images/buddy$buddyId.png',
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '$buddyName is here to help you with everything.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // You can add more playful UI elements below
        ],
      ),
    );
  }
}
