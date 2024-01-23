// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:tech_trove_shop/Firebase/firebase_firestore.dart';
import 'package:tech_trove_shop/Firebase/firebase_storage_helper.dart';
import 'package:tech_trove_shop/constants/constants.dart';
import 'package:tech_trove_shop/models/product_model.dart';
import 'package:tech_trove_shop/models/user_model.dart';

class AppProvider with ChangeNotifier {
  //CART WORK
  final List<ProductModel> _cartProductList = [];
  final List<ProductModel> _buyProductList = [];

  UserModel? _userModel;
  UserModel get getUserInformation => _userModel!;
  void addCartProductList(ProductModel productModel) {
    _cartProductList.add(productModel);
    notifyListeners();
  }

  void removeCartProductList(ProductModel productModel) {
    _cartProductList.remove(productModel);
    notifyListeners();
  }

  List<ProductModel> get getCartProductList => _cartProductList;
  // FAVOURATE WORK
  final List<ProductModel> _favourateProductList = [];
  void addFavourateProductList(ProductModel productModel) {
    _favourateProductList.add(productModel);
    notifyListeners();
  }

  void removeFavourateProductList(ProductModel productModel) {
    _favourateProductList.remove(productModel);
    notifyListeners();
  }

  List<ProductModel> get getFavourateProductList => _favourateProductList;
  ////USER INFORMATION;
  void getUserInfoFirebase() async {
    _userModel = await FirebaseFirestoreHelper.instance.getUserInformation();
    notifyListeners();
  }

  void updateUserInfor(BuildContext context, userModel, File? file) async {
    if (file == null) {
      showLoaderDialog(context);
      _userModel = userModel;
      await FirebaseFirestore.instance
          .collection("users")
          .doc(_userModel!.id)
          .set(_userModel!.toJson());

      Navigator.of(context, rootNavigator: true).pop();
      Navigator.of(context).pop();
    } else {
      showLoaderDialog(context);
      String imageUrl =
          await FirebaseStorageHelper.instance.uploadUserImage(file);
      _userModel = userModel.copyWith(image: imageUrl);
      await FirebaseFirestore.instance
          .collection("users")
          .doc(_userModel!.id)
          .set(_userModel!.toJson());

      Navigator.of(context, rootNavigator: true).pop();
      Navigator.of(context).pop();
    }
    showMessage("Profile Updated");
    notifyListeners();
  }

  //TOTAL PRICE;
  double totalPrice() {
    double totalPrice = 0.0;
    for (var element in _cartProductList) {
      totalPrice += element.price * element.qty!;
    }
    return totalPrice;
  }

  /// UPDATE TOTAL WITH INCREASING QUANTITY OF PRODUCT IN CART SCREEN;
  void updateQty(ProductModel productModel, int qty) {
    int index = _cartProductList.indexOf(productModel);
    _cartProductList[index].qty = qty;
    notifyListeners();
  }

  void addBuyProduct(ProductModel model) {
    _buyProductList.add(model);
    notifyListeners();
  }

  void addBuyProductCartList() {
    _buyProductList.addAll(_cartProductList);
    notifyListeners();
  }

  void clearCart() {
    _cartProductList.clear();
    notifyListeners();
  }

  void clearBuyProduct() {
    _buyProductList.clear();
    notifyListeners();
  }

  ///   BUY PRODUCT....
  List<ProductModel> get getBuyProductList => _buyProductList;
}
