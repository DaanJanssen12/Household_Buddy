import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:household_buddy/components/my_button.dart';
import 'package:household_buddy/components/my_textfield.dart';
import 'package:household_buddy/services/auth_service.dart';
import 'package:household_buddy/services/household_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginBodyScreen extends StatefulWidget {
  final AuthService authService;
  final HouseholdService householdService;

  // Constructor with required parameters
  const LoginBodyScreen({super.key, required this.authService, required this.householdService});

  @override
  State<LoginBodyScreen> createState() => _LoginBodyScreenState();
}

class _LoginBodyScreenState extends State<LoginBodyScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  void login() async {
    setState(() {
      isLoading = true;
    });
    try {
      validateEmail(emailController.text);
      final session = await widget.authService.login(
        emailController.text,
        passwordController.text,
      );
      if (session != null) {
        await handleLoginSuccess(session);
      }
    } catch (e) {
      handleLoginFailure(e as Exception);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> handleLoginSuccess(Session session) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("sessionToken", session.$id);
    
    var user = await widget.authService.getUser();
    final bool hasHousehold = await widget.householdService.hasHousehold(user.$id);
    if(hasHousehold){
          Navigator.pushReplacementNamed(context, '/home');
    }else{
          Navigator.pushReplacementNamed(context, '/introduction');
    }
  }

  void handleLoginFailure(Exception e) {
    showErrorMessage('Login failed. Please check your credentials.');
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(message),
        );
      },
    );
  }

  String _errorMessage = "";

  void validateEmail(String val) {
    if (val.isEmpty) {
      setState(() {
        _errorMessage = "Email is empty";
      });
    } else if (!EmailValidator.validate(val, true)) {
      setState(() {
        _errorMessage = "Email invalid";
      });
    } else {
      setState(() {
        _errorMessage = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.green,
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Image.asset(
                'assets/Images/HouseholdBuddy.png',
                width: double.infinity,
                height: MediaQuery.of(context).size.height *
                    0.45, // 40% of screen height
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.6,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: HexColor("#ffffff"),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Log In",
                        style: GoogleFonts.poppins(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: HexColor("#4f4f4f"),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 0, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Email",
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                color: HexColor("#8d8d8d"),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            MyTextField(
                              onChanged: (() {
                                validateEmail(emailController.text);
                              }),
                              controller: emailController,
                              hintText: "Email",
                              obscureText: false,
                              prefixIcon: const Icon(Icons.mail_outline),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                              child: Text(
                                _errorMessage,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Password",
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                color: HexColor("#8d8d8d"),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            MyTextField(
                              controller: passwordController,
                              hintText: "**************",
                              obscureText: true,
                              prefixIcon: const Icon(Icons.lock_outline),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            MyButton(
                              onPressed: isLoading ? null : login,
                              buttonText: 'Login',
                              isLoadingState: isLoading,
                              isLoadingWidget: SizedBox(
                                width: 5,
                                height: 5,
                                child: CircularProgressIndicator(
                                  strokeWidth: 1,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
                              child: Row(
                                children: [
                                  Text("Nog geen account?",
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        color: HexColor("#8d8d8d"),
                                      )),
                                  TextButton(
                                    child: Text(
                                      "Registreer",
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        color: HexColor("#44564a"),
                                      ),
                                    ),
                                    onPressed: () => {},
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
