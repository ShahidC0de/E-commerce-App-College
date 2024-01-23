import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_trove_shop/constants/constants.dart';
import 'package:tech_trove_shop/constants/routes.dart';

import 'package:tech_trove_shop/provider/app_provider.dart';
import 'package:tech_trove_shop/screens/cart_checkout.dart';

import 'package:tech_trove_shop/widget/single_cart_item.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int qty = 1;
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
        // ignore: sized_box_for_whitespace
        bottomNavigationBar: Container(
          height: 180.0,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Rs${appProvider.totalPrice().toString()}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                SizedBox(
                  height: 50,
                  width: 350,
                  child: ElevatedButton(
                    onPressed: () {
                      appProvider.clearBuyProduct();
                      appProvider.addBuyProductCartList();
                      appProvider.clearCart();
                      if (appProvider.getBuyProductList.isEmpty) {
                        showMessage("Cart is Empty");
                      } else {
                        Routes().push(const CartItemCheckOut(), context);
                      }
                    },
                    child: const Text("checkout"),
                  ),
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          //appbar a flat border on the top of screen, and one back button with it;
          title: const Text(
            //title of the screen on appbar;
            "Cart ",
            style: TextStyle(
              color: Colors.lightBlueAccent, //color of text;
            ),
          ),
          backgroundColor: Colors.white, //color of appbar;
        ),
        body: appProvider.getCartProductList.isEmpty
            ? const Center(
                child: Text(
                  "Cart is Empty",
                  style: TextStyle(color: Colors.lightBlueAccent),
                ),
              )
            : ListView.builder(
                //use to render a list of items on screen;
                itemCount: appProvider.getCartProductList
                    .length, //the number of items to be listed;
                padding: const EdgeInsets.all(12.0),
                itemBuilder: (ctx, index) {
                  return SingleCartItem(
                    singleProduct: appProvider.getCartProductList[index],
                  );
                }));
  }
}
