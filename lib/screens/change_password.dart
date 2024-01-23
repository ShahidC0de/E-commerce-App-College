import 'package:flutter/material.dart';
import 'package:tech_trove_shop/Firebase/firebase_auth.dart';
import 'package:tech_trove_shop/constants/constants.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool isShowPassword = true;
  TextEditingController newpassword = TextEditingController();
  TextEditingController confpassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Change Password",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.lightBlueAccent,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12.0),
        children: [
          SizedBox(
            height: 60, //size of textformfield,
            width: 300,
            child: TextFormField(
              controller: newpassword,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                  //decoration of textformfield.
                  //EMAIL TEXTFORM FILED
                  hintText: "New Password",
                  hintStyle: const TextStyle(
                    color: Colors.lightBlueAccent,
                  ),
                  prefixIcon: const Icon(
                    //putting an icon.
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
            height: 30.0,
          ),
          SizedBox(
            height: 60, //size of textformfield,
            width: 300,
            child: TextFormField(
              controller: confpassword,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                  //decoration of textformfield.
                  //EMAIL TEXTFORM FILED
                  hintText: "Confirm Password",
                  hintStyle: const TextStyle(
                    color: Colors.lightBlueAccent,
                  ),
                  prefixIcon: const Icon(
                    //putting an icon.
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
            height: 30.0,
          ),
          SizedBox(
            //Login button
            width: 200,
            height: 60,
            child: ElevatedButton(
              onPressed: () async {
                if (newpassword.text.isEmpty) {
                  showMessage("Please Enter your new password");
                } else if (confpassword.text.isEmpty) {
                  showMessage("Please Enter your new password");
                } else if (confpassword.text == newpassword.text) {
                  FirebaseAuthHelper.instance
                      .changePassword(newpassword.text, context);
                } else {
                  showMessage("Password doesn't match");
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent,
              ),
              child: const Text(
                "Update",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
