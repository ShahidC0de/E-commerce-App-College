// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:tech_trove_shop/Firebase/firebase_auth.dart';
import 'package:tech_trove_shop/constants/constants.dart';
import 'package:tech_trove_shop/constants/routes.dart';
import 'package:tech_trove_shop/screens/login.dart';
import 'package:tech_trove_shop/widget/custom_textfield.dart';
import 'package:tech_trove_shop/widget/email_verification_widget.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controllers
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();
    TextEditingController name = TextEditingController();
    TextEditingController confirmPassword = TextEditingController();
    TextEditingController streetAddress = TextEditingController();

    // Get the screen size
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.lightBlueAccent
                  .withOpacity(0.8), // Light blue accent color
              Colors.white, // Fade to white
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(size.width * 0.05),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: EdgeInsets.all(size.width * 0.1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Create an Account",
                        style: TextStyle(
                          color: Colors.lightBlueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      // Name Field
                      CustomTextField(
                        textEditingController: name,
                        prefixIcon: const Icon(Icons.person_2_outlined,
                            color: Colors.lightBlueAccent),
                        hintText: 'Name',
                        textInputType: TextInputType.name,
                      ),
                      const SizedBox(height: 16.0),
                      // Email Field
                      CustomTextField(
                        textEditingController: email,
                        prefixIcon: const Icon(Icons.email_outlined,
                            color: Colors.lightBlueAccent),
                        hintText: 'Email',
                        textInputType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16.0),
                      // Street Address Field
                      CustomTextField(
                        textEditingController: streetAddress,
                        prefixIcon: const Icon(Icons.home,
                            color: Colors.lightBlueAccent),
                        hintText: 'Street Address',
                        textInputType: TextInputType.streetAddress,
                      ),
                      const SizedBox(height: 16.0),
                      // Password Field
                      CustomTextField(
                        textEditingController: password,
                        prefixIcon: const Icon(Icons.lock_outline,
                            color: Colors.lightBlueAccent),
                        hintText: 'Password',
                        textInputType: TextInputType.visiblePassword,
                      ),
                      const SizedBox(height: 16.0),
                      // Confirm Password Field
                      CustomTextField(
                        textEditingController: confirmPassword,
                        prefixIcon: const Icon(Icons.lock_outline,
                            color: Colors.lightBlueAccent),
                        hintText: 'Confirm Password',
                        textInputType: TextInputType.visiblePassword,
                      ),
                      const SizedBox(height: 24.0),
                      // Sign Up Button
                      SizedBox(
                        height: 60,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            // Validation logic
                            bool isValidated = signUpValidation(
                              name.text,
                              email.text,
                              streetAddress.text,
                              password.text,
                              confirmPassword.text,
                            );
                            if (isValidated) {
                              bool isSignedIn =
                                  await FirebaseAuthHelper.instance.signUp(
                                      email.text,
                                      password.text,
                                      name.text,
                                      streetAddress.text,
                                      context);
                              if (isSignedIn) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const EmailSendVerificationDialog();
                                  },
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 5,
                          ),
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      // Redirect to Login
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Routes().pushAndRemoveUntil(const Login(), context);
                          },
                          child: const Text(
                            "Already have an account?",
                            style: TextStyle(
                              color: Colors.lightBlueAccent,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
