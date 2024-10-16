// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison, avoid_print, duplicate_ignore

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tech_trove_shop/constants/constants.dart';
import 'package:tech_trove_shop/models/user_model.dart';

class FirebaseAuthHelper {
  //creating an object of the class, to access it whenever i need it.
  static FirebaseAuthHelper instance = FirebaseAuthHelper();
  //accessing the firebase auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get getAuthChange => _auth.authStateChanges();
  //creating a function login, it can be called to an event whenever the user try to login in future.
  //SIGNING IN THE USER IF HAVE AN ALREADY AN ACCOUNT;
  Future<void> verifyTheUser() async {
    await _auth.currentUser!.sendEmailVerification();
    const maXDuration = Duration(seconds: 60);
    final sTartTime = DateTime.now();
    while (!_auth.currentUser!.emailVerified) {
      if (DateTime.now().difference(sTartTime) > maXDuration) {
        // ignore: avoid_print
        print('email verification time reached');
      }
      {
        await Future.delayed(const Duration(seconds: 1));
        await _auth.currentUser!.reload();
      }
    }
  }

  Future<bool> login(
      String email, String password, BuildContext context) async {
    //build context is taking blueprint of something like next screen or something etc..
    //using try and catch method.
    try {
      showLoaderDialog(context);
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      //when the user authentiction successfull, stop the loader dialog.
      Navigator.of(context).pop();
      return true;
      //in case of some error ...
    } on FirebaseAuthException catch (error) {
      Navigator.of(context).pop(); //stepping back
      showMessage(getMessageFromErrorCode(
          error.code.toString())); //showing exception error code
      return false;
    }
  }

  //THIS FOR CREATING A USER IN DATABASE;
  Future<bool> signUp(String email, String password, String name,
      String streetAddress, BuildContext context) async {
    try {
      showLoaderDialog(context);

      // Step 1: Attempt user authentication
      UserCredential? userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Check if userCredential is valid
      if (userCredential == null || userCredential.user == null) {
        print("Authentication failed, userCredential is null.");
        return false;
      }

      // Step 2: Create UserModel
      UserModel userModel = UserModel(
        id: userCredential.user!.uid,
        name: name,
        email: email,
        streetAddress: streetAddress,
        image: null,
      );

      // Log the UserModel before storing it
      print("UserModel to be stored: ${userModel.toJson()}");

      // Step 3: Save user data to Firestore
      await _firestore
          .collection("users")
          .doc(userModel.id)
          .set(userModel.toJson())
          .then((_) {
        print("User data successfully written to Firestore.");
      }).catchError((error) {
        print("Error writing user data to Firestore: $error");
        throw error;
      });

      // Step 4: Stop the loader and return success
      Navigator.of(context).pop();
      return true;
    } on FirebaseAuthException catch (error) {
      // Stop the loader and show error message
      Navigator.of(context).pop();
      print("FirebaseAuthException: ${error.code}");
      showMessage(getMessageFromErrorCode(error.code.toString()));
      return false;
    } catch (error) {
      // Catch any other errors
      Navigator.of(context).pop();
      print("General error: $error");
      showMessage("An error occurred. Please try again.");
      return false;
    }
  }

  void signOut() async {
    await _auth.signOut();
  }

  Future<bool> changePassword(String password, BuildContext context) async {
    //build context is taking blueprint of something like next screen or something etc..
    //using try and catch method.
    try {
      _auth.currentUser!.updatePassword(password);
      showLoaderDialog(context);
      // UserCredential? userCredential = await _auth
      //     .createUserWithEmailAndPassword(email: email, password: password);
      // UserModel userModel = UserModel(
      //     id: userCredential.user!.uid,
      //     name: name,
      //     email: email,
      //     streetAddress: streetAddress,
      //     image: null);
      // _firestore.collection("users").doc(userModel.id).set(userModel.toJson());
      //when the user authentiction successfull, stop the loader dialog.
      Navigator.of(context, rootNavigator: true).pop();
      showMessage("Password Changed");
      Navigator.of(context).pop();
      return true;
      //in case of some error ...
    } on FirebaseAuthException catch (error) {
      Navigator.of(context).pop(); //stepping back
      showMessage(getMessageFromErrorCode(
          error.code.toString())); //showing exception error code
      return false;
    }
  }
}
