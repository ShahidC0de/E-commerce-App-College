import 'package:flutter/material.dart';
import 'package:tech_trove_shop/constants/routes.dart';
import 'package:tech_trove_shop/screens/login.dart';
import 'package:tech_trove_shop/screens/signup.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: kToolbarHeight + 20,
          ),
          Image.asset(
            "assets/images/welcome.png",
            // ImagesIcons.instance.welcomeimage

            scale: 0.1,
          ),
          const SizedBox(
            height: 12.0,
          ),
          const Text(
            "TechTrove",
            style: TextStyle(
                color: Colors.lightBlueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 35),
          ),
          const Text(
            "Thank You For Selecting us!",
            style: TextStyle(color: Colors.grey, fontSize: 10),
          ),
          const SizedBox(
            height: 30.0,
          ),
          SizedBox(
            width: 200,
            height: 60,
            child: ElevatedButton(
              onPressed: () {
                Routes().push(const Login(), context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent,
              ),
              child: const Text(
                "Login",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          SizedBox(
            height: 60,
            width: 200,
            child: ElevatedButton(
                onPressed: () {
                  Routes().push(const SignUp(), context);
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
            height: 24.0,
          ),
          const Text(
            "Sign up using",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
