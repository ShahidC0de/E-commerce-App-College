import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showMessage(String message) {
  Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      fontSize: 16.0);
}

showLoaderDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: Builder(builder: (context) {
      return SizedBox(
        width: 100.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              color: Colors.blue,
            ),
            const SizedBox(
              height: 18.0,
            ),
            Container(
                margin: const EdgeInsets.only(left: 7),
                child: const Text("Loading...")),
          ],
        ),
      );
    }),
  );
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      });
}

String getMessageFromErrorCode(String errorCode) {
  switch (errorCode) {
    case "ERROR-EMAIL-ALREADY-IN USE":
      return "Email is already used. Go to login page.";
    case "account-exists-with-different-credentials":
      return "Email is already used. Go to login page.";
    case "email-already-in-use":
      return "Email is already used. Go to login page.";
    case "ERROR-WRONG-PASSWORD":
    case "Wrong password":
      return "Wrong password.";
    case "ERROR-USER-NOT-FOUND":
      return "No user found with this email.";
    case "User not found":
      return "No user found with this email.";
    case "ERROR-USER-DISABLED":
      return "User disabled.";
    case "ERROR-TOO-MANY-REQUESTS":
      return "Too many requests to log into this account.";
    case "operation not allowed":
      return "Too many requests to log into this account.";
    case "ERROR-OPERATION-NOT-ALLOWED":
      return "Too many requests to log into this account.";
    case "ERROR_INVALID_EMAIL":
      return "Email address is invalid.";
    case "invalid-email":
      return "Email address is invalid.";
    case "invalid-email && invalid-password":
      return "Email and password are invalid";
    default:
      return "Login failed. Please try again.";
  }
}

bool loginValidation(String email, String password) {
  if (email.isEmpty && password.isEmpty) {
    showMessage("Email and password, both are empty");
    return false;
  } else if (password.isEmpty) {
    showMessage("password is empty");
    return false;
  } else if (email.isEmpty) {
    showMessage("Email is empty");
    return false;
  } else {
    return true;
  }
}

bool signUpValidation(
  String email,
  String password,
  String fullname,
  String confirmPassword,
  String streetAddress,
) {
  if (email.isEmpty &&
      password.isEmpty &&
      fullname.isEmpty &&
      streetAddress.isEmpty &&
      confirmPassword.isEmpty) {
    showMessage("All fields are empty");
    return false;
  } else if (fullname.isEmpty) {
    showMessage("Name is empty");
    return false;
  } else if (email.isEmpty) {
    showMessage("Email is empty");
    return false;
  } else if (streetAddress.isEmpty) {
    showMessage("Address  is empty");
    return false;
  } else if (password.isEmpty) {
    showMessage("password is empty");
    return false;
  } else if (confirmPassword.isEmpty) {
    showMessage("password is not confirmed");
    return false;
  } else {
    return true;
  }
}
