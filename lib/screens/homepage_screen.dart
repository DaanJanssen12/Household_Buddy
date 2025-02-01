// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io' show File; // Import for mobile platforms
import 'package:flutter/material.dart';
import 'package:household_buddy/services/auth_service.dart';
import 'package:household_buddy/services/household_service.dart';
import 'package:appwrite/appwrite.dart';
import 'package:household_buddy/utils/image_utils.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  final Client client; // Pass the Appwrite Client
  const HomePage({super.key, required this.client});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _householdNameController =
      TextEditingController();
  late AuthService? _authService;
  late HouseholdService _householdService;
  String? _userEmail;
  List<Map<String, dynamic>> _households = [];
  File? _selectedImage; // Variable to store selected image file

  _HomePageState() : _authService = null;

  @override
  void initState() {
    super.initState();
    _authService = AuthService(widget.client);
    _householdService = HouseholdService(widget.client);
    _fetchUserDetails();
    _fetchHouseholds();
  }

  // Fetch User Email
  Future<void> _fetchUserDetails() async {
    try {
      final user = await _authService?.account.get();
      setState(() {
        _userEmail = user?.email;
      });
    } catch (e) {
      print('Error fetching user details: $e');
    }
  }

  // Fetch Households
  Future<void> _fetchHouseholds() async {
    try {
      final user = await _authService?.account.get();
      if (user == null) return;
      final households = await _householdService.getHouseholds(user.$id);
      setState(() {
        _households = households
            .map((doc) => {
                  'id': doc.$id,
                  'name': doc.data['householdName'],
                  'image': doc.data['image'],
                })
            .toList();
      });
    } catch (e) {
      print('Error fetching households: $e');
    }
  }

  // Pick Image
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      //print("Picked image: ${pickedFile.path}"); // Check the path
      setState(() {
        _selectedImage = File(pickedFile.path);
        print("Picked image: ${_selectedImage?.path}");
      });
    } else {
      print("No image selected");
    }
  }

  // Create Household
  Future<void> _createHousehold() async {
    final name = _householdNameController.text.trim();
    if (name.isEmpty) return;

    try {
      final user = await _authService?.account.get();
      if (user == null) return;

      // Convert image to Base64 if an image is selected
      String? base64Image;
      if (_selectedImage != null) {
        base64Image = await convertImageToBase64(_selectedImage!);
      }

      await _householdService.createHousehold(
        user.$id,
        name,
        base64Image, // Pass Base64 encoded image
      );
      _householdNameController.clear();
      setState(() {
        _selectedImage = null; // Reset image selection
      });
      _fetchHouseholds(); // Refresh households
      Navigator.pop(getContext()); // Close the bottom sheet
    } catch (e) {
      print('Error creating household: $e');
    }
  }

  BuildContext getContext() {
    return context;
  }

  // Sign Out
  Future<void> _signOut() async {
    try {
      await _authService?.logout();
      Navigator.of(getContext())
          .pushReplacementNamed('/login'); // Navigate back to login
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  // Show the bottom sheet to create a household
  void _showCreateHouseholdSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _householdNameController,
                decoration: const InputDecoration(
                  labelText: 'Household Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Pick Image'),
              ),
              if (_selectedImage != null) ...[
                // If the image is selected, display it
                //print("Displaying image: ${_selectedImage!.path}"),
                Image.file(
                  _selectedImage!,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ] else ...[
                // If no image is selected, display a message
                const Text('No image selected'),
              ],
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _createHousehold,
                child: const Text('Create Household'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Household Buddy'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_userEmail != null)
              Text('Welcome, $_userEmail',
                  style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _showCreateHouseholdSheet,
              child: const Text('Create Household'),
            ),
            const SizedBox(height: 16),
            const Text('Your Households:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: _households.length,
                itemBuilder: (context, index) {
                  final household = _households[index];
                  return ListTile(
                    leading: household['image'] != null
                        ? Image.memory(
                            base64Decode(household['image']),
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                          )
                        : null,
                    title: Text(household['name']),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await _householdService
                            .deleteHousehold(household['id']);
                        _fetchHouseholds(); // Refresh households
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
