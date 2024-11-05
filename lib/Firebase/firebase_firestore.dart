// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

import 'package:tech_trove_shop/constants/constants.dart';
import 'package:tech_trove_shop/models/category_model.dart';
import 'package:tech_trove_shop/models/order_model.dart';
import 'package:tech_trove_shop/models/product_model.dart';
import 'package:tech_trove_shop/models/user_model.dart';

class FirebaseFirestoreHelper {
  static FirebaseFirestoreHelper instance = FirebaseFirestoreHelper();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  Future<List<CategoryModel>> getCategories1() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore.collection("categories1").get();
      List<CategoryModel> categoriesList1 = querySnapshot.docs
          .map((e) => CategoryModel.fronJson(e.data()))
          .toList();

      return categoriesList1;
    } catch (e) {
      showMessage(e.toString());
      return [];
    }
  }

  Future<List<ProductModel>> getProducts() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore.collectionGroup("products").get();
      List<ProductModel> productModelList = querySnapshot.docs
          .map((e) => ProductModel.fronJson(e.data()))
          .toList();

      return productModelList;
    } catch (e) {
      showMessage(e.toString());
      return [];
    }
  }

  Future<List<ProductModel>> getCategoryViewProduct(String id) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore
              .collection("categories1")
              .doc(id)
              .collection("products")
              .get();
      List<ProductModel> productModelList = querySnapshot.docs
          .map((e) => ProductModel.fronJson(e.data()))
          .toList();

      return productModelList;
    } catch (e) {
      showMessage(e.toString());
      return [];
    }
  }

  Future<UserModel> getUserInformation() async {
    DocumentSnapshot<Map<String, dynamic>> querySnapshot =
        await _firebaseFirestore
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .get();

    return UserModel.fromJson(querySnapshot.data()!);
  }

  Future<bool> uploadOrderedProductFirebase(
    List<ProductModel> list,
    BuildContext context,
    String payment,
  ) async {
    try {
      showLoaderDialog(context);
      double totalPrice = 0.0;
      for (var element in list) {
        totalPrice += element.price * element.qty!;
      }

      DocumentReference documentReference = _firebaseFirestore
          .collection("usersOrders")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("orders")
          .doc();
      DocumentReference admin =
          _firebaseFirestore.collection("orders").doc(documentReference.id);
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await _firebaseFirestore.collection('users').doc(uid).get();
      Map<String, dynamic> userData = documentSnapshot.data()!;
      UserModel user = UserModel.fromJson((userData));

      admin.set({
        "products": list.map((e) => e.toJson()).toList(),
        "status": "pending",
        "userId": uid,
        "totalPrice": totalPrice,
        "payment": payment,
        "orderId": admin.id,
        "orderAddress": user.streetAddress,
      });
      documentReference.set({
        "userId": uid,
        "products": list.map((e) => e.toJson()),
        "status": "pending",
        "totalPrice": totalPrice,
        "payment": payment,
        "orderId": documentReference.id,
        "orderAddress": user.streetAddress,
      });
      Navigator.of(context, rootNavigator: true).pop();
      showMessage("Ordered Successfully");
      return true;
    } catch (e) {
      showMessage(e.toString());
      Navigator.of(context, rootNavigator: true).pop();
      return false;
    }
  }

  /// GET USERS ORDERS;
  Future<List<OrderModel>> getUserOrders() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore
              .collection("usersOrders")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection("orders")
              .get();
      List<OrderModel> orderList = querySnapshot.docs
          .map((element) => OrderModel.fronJson(element.data()))
          .toList();
      return orderList;
    } catch (e) {
      showMessage(e.toString());
      return [];
    }
  }

  void updateTokenFromFirebase() async {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      await _firebaseFirestore
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        "notification token": token,
      });
    }
  }

  Future<void> updateOrder(OrderModel orderModel, String update) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('usersOrders')
        .doc(uid)
        .collection('orders')
        .doc(orderModel.orderId)
        .update({
      'status': update,
    });
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(orderModel.orderId)
        .update({
      'status': update,
    });
  }

  Future<void> saveRatingAndComment({
    required int rating,
    required String comment,
  }) async {
    DocumentSnapshot documentSnapshot = await _firebaseFirestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (documentSnapshot.exists) {
      // Get the data as a Map<String, dynamic>
      Map<String, dynamic> jsonData =
          documentSnapshot.data() as Map<String, dynamic>;

      // Now you can create a UserModel instance
      UserModel userModel = userModelFromJson(jsonData);

      // Now you can use userModel as needed
      // For example, saving rating and comment
      await _firebaseFirestore.collection('ratings').add({
        'userId': userModel.id, // or however you identify the user
        'name': userModel.name,
        'rating': rating,
        'comment': comment,
      });
      debugPrint("successfully uploaded");
    } else {
      debugPrint('User document does not exist');
    }
  }
}
