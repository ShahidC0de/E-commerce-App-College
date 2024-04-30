// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:tech_trove_shop/Firebase/firebase_auth.dart';
import 'package:tech_trove_shop/constants/constants.dart';
import 'package:tech_trove_shop/constants/routes.dart';
import 'package:tech_trove_shop/screens/custom_bottom_bar.dart';
import 'package:tech_trove_shop/screens/home.dart';
import 'package:tech_trove_shop/widget/custom_textfield.dart';

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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              const SizedBox(
                height: kToolbarHeight + 24,
              ),
              const Text(
                "Create an Account",
                style: TextStyle(
                    color: Colors.lightBlueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 24),
              ),
              const SizedBox(
                height: 24.0,
              ),
              CustomTextField(
                textEditingController: name,
                prefixIcon: const Icon(
                  Icons.person_2_outlined,
                  color: Colors.lightBlueAccent,
                ),
                hintText: 'Name',
                textInputType: TextInputType.name,
              ),
              const SizedBox(
                height: 24.0,
              ),
              CustomTextField(
                textEditingController: email,
                prefixIcon: const Icon(
                  Icons.email_outlined,
                  color: Colors.lightBlueAccent,
                ),
                hintText: 'Email',
                textInputType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 24.0,
              ),
              CustomTextField(
                textEditingController: streetAddress,
                prefixIcon: const Icon(
                  Icons.abc_outlined,
                  color: Color.fromRGBO(64, 196, 255, 1),
                ),
                hintText: 'Street Address',
                textInputType: TextInputType.streetAddress,
              ),
              const SizedBox(
                height: 24.0,
              ),
              CustomTextField(
                textEditingController: password,
                prefixIcon: const Icon(
                  Icons.password_outlined,
                  color: Colors.lightBlueAccent,
                ),
                hintText: 'Password',
                textInputType: TextInputType.visiblePassword,
              ),
              const SizedBox(
                height: 24.0,
              ),
              CustomTextField(
                textEditingController: confirmPassword,
                prefixIcon: const Icon(
                  Icons.password_outlined,
                  color: Colors.lightBlueAccent,
                ),
                hintText: 'Confirm Password',
                textInputType: TextInputType.visiblePassword,
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
                      backgroundColor: Colors.lightBlueAccent,
                    ),
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
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
                    color: Colors.lightBlueAccent,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
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
