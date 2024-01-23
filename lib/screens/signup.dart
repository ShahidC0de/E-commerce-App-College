// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:tech_trove_shop/Firebase/firebase_auth.dart';
import 'package:tech_trove_shop/constants/constants.dart';
import 'package:tech_trove_shop/constants/routes.dart';
import 'package:tech_trove_shop/screens/custom_bottom_bar.dart';
import 'package:tech_trove_shop/screens/home.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController email = TextEditingController();
    //allow user to manipulate and listen to changes when user try to give values in textformfield.
    TextEditingController password = TextEditingController();
    TextEditingController name = TextEditingController();

    TextEditingController confirmPassword = TextEditingController();
    TextEditingController streetAddress = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.blue,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              const SizedBox(
                height: kToolbarHeight + 24,
              ),
              const Text(
                "Signup",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              const SizedBox(
                height: 24.0,
              ),
              SizedBox(
                height: 60,
                width: 300,
                child: TextFormField(
                  controller: name,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                      hintText: "Full Name",
                      hintStyle: const TextStyle(
                        color: Colors.white,
                      ),
                      prefixIcon: const Icon(
                        Icons.person_outline,
                        color: Colors.lightBlueAccent,
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.lightBlueAccent,
                        ),
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 2,
                          color: Colors.lightBlueAccent,
                        ),
                        borderRadius: BorderRadius.circular(40.0),
                      )),
                ),
              ),
              const SizedBox(
                height: 24.0,
              ),
              SizedBox(
                height: 60,
                width: 300,
                child: TextFormField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      hintText: "Email Address",
                      hintStyle: const TextStyle(
                        color: Colors.white,
                      ),
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: Colors.lightBlueAccent,
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.lightBlueAccent,
                        ),
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 2,
                          color: Colors.lightBlueAccent,
                        ),
                        borderRadius: BorderRadius.circular(40.0),
                      )),
                ),
              ),
              const SizedBox(
                height: 24.0,
              ),
              SizedBox(
                height: 60,
                width: 300,
                child: TextFormField(
                  controller: streetAddress,
                  keyboardType: TextInputType.streetAddress,
                  decoration: InputDecoration(
                      hintText: " Street Address",
                      hintStyle: const TextStyle(
                        color: Colors.white,
                      ),
                      prefixIcon: const Icon(
                        Icons.abc,
                        color: Colors.lightBlueAccent,
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.lightBlueAccent,
                        ),
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 2,
                          color: Colors.lightBlueAccent,
                        ),
                        borderRadius: BorderRadius.circular(40.0),
                      )),
                ),
              ),
              const SizedBox(
                height: 24.0,
              ),
              SizedBox(
                height: 60,
                width: 300,
                child: TextFormField(
                  controller: password,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                      hintText: "Password",
                      hintStyle: const TextStyle(
                        color: Colors.white,
                      ),
                      prefixIcon: const Icon(
                        Icons.password_rounded,
                        color: Colors.lightBlueAccent,
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.lightBlueAccent,
                        ),
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 2,
                          color: Colors.lightBlueAccent,
                        ),
                        borderRadius: BorderRadius.circular(40.0),
                      )),
                ),
              ),
              const SizedBox(
                height: 24.0,
              ),
              SizedBox(
                height: 60,
                width: 300,
                child: TextFormField(
                  controller: confirmPassword,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                      hintText: " Confirm Password",
                      hintStyle: const TextStyle(
                        color: Colors.white,
                      ),
                      prefixIcon: const Icon(
                        Icons.password_rounded,
                        color: Colors.lightBlueAccent,
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.lightBlueAccent,
                        ),
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 2,
                          color: Colors.lightBlueAccent,
                        ),
                        borderRadius: BorderRadius.circular(40.0),
                      )),
                ),
              ),
              const SizedBox(
                height: 24.0,
              ),
              SizedBox(
                height: 60,
                width: 200,
                child: ElevatedButton(
                    onPressed: () async {
                      bool isValidated = signUpValidation(
                          name.text,
                          email.text,
                          streetAddress.text,
                          password.text,
                          confirmPassword.text);
                      if (isValidated) {
                        //means both fields are texted.
                        bool isSignedIn = await FirebaseAuthHelper.instance
                            //then call the login function where i initialized the firebase sign in service. and storing this state in is logined which can be ture or false.
                            .signUp(email.text, password.text, name.text,
                                streetAddress.text, context);
                        if (isSignedIn) {
                          //means the firebase service is been called so navigate to homepage.
                          Routes().pushAndRemoveUntil(
                              const CustomBottomBar(), context);
                          //push and remove until means navigate to next screen but comming back is not possible.
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    child: const Text(
                      "Signup",
                      style: TextStyle(
                        color: Colors.lightBlueAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
              ),
              const SizedBox(
                height: 40.0,
              ),
              TextButton(
                onPressed: () {
                  Routes().pushAndRemoveUntil(const HomePage(), context);
                },
                child: const Text(
                  "Already have an account?",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
