import 'package:flutter/material.dart';
import 'package:household_buddy/providers/gold_provider.dart';
import 'package:provider/provider.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final String householdName;
  const TopBar({super.key, required this.householdName});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor, // Uses the app bar background color from the theme
      title: Text(
        householdName,
        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ), // Uses headlineLarge text style from the theme
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Icon(
                Icons.monetization_on,
                color: Color(0xFFFFD700), // Uses icon color from the theme
                size: 28,
              ),
              const SizedBox(width: 5),
              Consumer<GoldProvider>(
                builder: (context, goldProvider, child) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) => ScaleTransition(
                      scale: animation,
                      child: child,
                    ),
                    child: Text(
                      goldProvider.gold.toString(),
                      key: ValueKey<int>(goldProvider.gold),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ), // Uses bodyLarge text style from the theme
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
