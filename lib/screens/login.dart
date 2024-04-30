// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tech_trove_shop/Firebase/firebase_auth.dart';
import 'package:tech_trove_shop/constants/constants.dart';
import 'package:tech_trove_shop/constants/routes.dart';
import 'package:tech_trove_shop/screens/home.dart';
import 'package:tech_trove_shop/screens/signup.dart';
import 'package:tech_trove_shop/widget/custom_textfield.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  //allow user to manipulate and listen to changes when user try to give values in textformfield.
  TextEditingController password = TextEditingController(); //
  bool isShowPassword = true;
  //a bool value, which is true, it is used in password textformfield to hide user values.
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Scaffold(
        body: SingleChildScrollView(
          //singlechildscrollview enable user to scroll on page.
          child: Column(
            children: [
              const SizedBox(
                height: kToolbarHeight,
              ),
              Image.asset("assets/images/welcome.png"),
              //importing an image.
              const Text(
                //title of the page.
                "Login",
                style: TextStyle(
                    //to change style of text.
                    color: Colors.lightBlueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
              const SizedBox(
                // use for leaving space among widgets.
                height: 12.0,
              ),
              //textformfield is use to get values from user.
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
                height: 8.0,
              ),
              //PASSWORD TEXTFORM FIELD;
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(40),
                ),
                height: 60,
                width: 300,
                child: TextFormField(
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  controller: password,
                  obscureText:
                      isShowPassword, //obsecuretext is true, is showpassword is true,
                  decoration: InputDecoration(
                      hintText: "Password",
                      hintStyle: const TextStyle(
                        color: Colors.white,
                      ),
                      suffixIcon: CupertinoButton(
                        onPressed: () {
                          setState(() {
                            //to change state an icon/widget etc..
                            isShowPassword =
                                !isShowPassword; //whatever the isShowpassword is, just change its state by pressing the icon.
                          });
                        },
                        child: const Icon(
                          Icons.visibility,
                          color: Colors.lightBlueAccent,
                        ),
                      ),
                      prefixIcon: const Icon(
                        Icons.password_outlined,
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
                height: 12.0,
              ),
              SizedBox(
                //Login button
                width: 200,
                height: 60,
                child: ElevatedButton(
                  onPressed: () async {
                    //validated is a function in constant file, where the user can get an error message if some textfield are empty
                    bool isValidated =
                        loginValidation(email.text, password.text);
                    if (isValidated) {
                      //means both fields are texted.
                      bool isLogined = await FirebaseAuthHelper.instance
                          //then call the login function where i initialized the firebase sign in service. and storing this state in is logined which can be ture or false.
                          .login(email.text, password.text, context);
                      if (isLogined) {
                        //means the firebase service is been called so navigate to homepage.
                        Routes().pushAndRemoveUntil(const HomePage(),
                            context); //push and remove until means navigate to next screen but comming back is not possible.
                      }
                    }
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
                height: 40.0,
              ),
              TextButton(
                onPressed: () {
                  Routes().push(const SignUp(), context);
                },
                child: const Text(
                  "Create an account", // for signup page navigation.
                  style: TextStyle(
                    color: Colors.lightBlueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
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
