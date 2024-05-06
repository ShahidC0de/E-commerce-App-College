// ignore_for_file: use_build_context_synchronously

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
    await Future.delayed(const Duration(seconds: 30));
    _auth.currentUser!.reload();
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
    //build context is taking blueprint of something like next screen or something etc..
    //using try and catch method.
    try {
      showLoaderDialog(context);
      UserCredential? userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      UserModel userModel = UserModel(
          id: userCredential.user!.uid,
          name: name,
          email: email,
          streetAddress: streetAddress,
          image: null);
      _firestore.collection("users").doc(userModel.id).set(userModel.toJson());
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
