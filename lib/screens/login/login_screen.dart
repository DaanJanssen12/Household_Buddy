import 'package:flutter/material.dart';
import 'package:household_buddy/services/auth_service.dart';
import 'package:household_buddy/services/household_service.dart';
import 'components/login_body.dart';

class LoginScreen extends StatefulWidget {
  final AuthService authService;
  final HouseholdService householdService;

  const LoginScreen({
    Key? key,
    required this.authService,
    required this.householdService,
  }) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    _checkPermissions(); // Check permissions when the app starts
  }

  Future<void> _checkPermissions() async {
    // var status = await Permission.storage.status;
    // if (!status.isGranted) {
    //   // If permission not granted, request it
    //   await Permission.manageExternalStorage.request();
    // }
  }

  @override
  Widget build(BuildContext context) {
    final authService = widget.authService;
    final householdService = widget.householdService;

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: LoginBodyScreen(authService: authService, householdService: householdService),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import '../../services/auth_service.dart';

// class LoginScreen extends StatefulWidget {
//   final AuthService authService;

//   const LoginScreen(this.authService, {super.key});

//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _nameController = TextEditingController();

//   void _login() async {
//     try {
//       await widget.authService.login(
//         _emailController.text,
//         _passwordController.text,
//       );
//       // Navigate to home screen
//       Navigator.pushReplacementNamed(context, '/home');
//     } catch (e) {
//       print('Login error: $e');
//     }
//   }

//   void _signUp() async {
//     try {
//       await widget.authService.signUp(_emailController.text,
//           _passwordController.text, _nameController.text);
//       _login(); // Log the user in after signing up
//     } catch (e) {
//       print('Sign-up error: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Login')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _emailController,
//               decoration: InputDecoration(labelText: 'Email'),
//             ),
//             TextField(
//               controller: _passwordController,
//               decoration: InputDecoration(labelText: 'Password'),
//               obscureText: true,
//             ),
//             TextField(
//               controller: _nameController,
//               decoration: InputDecoration(labelText: 'Name'),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(onPressed: _login, child: Text('Login')),
//             TextButton(onPressed: _signUp, child: Text('Sign Up')),
//           ],
//         ),
//       ),
//     );
//   }
// }
