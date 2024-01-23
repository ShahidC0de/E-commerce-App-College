// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_trove_shop/Firebase/firebase_firestore.dart';
import 'package:tech_trove_shop/constants/routes.dart';

import 'package:tech_trove_shop/provider/app_provider.dart';
import 'package:tech_trove_shop/screens/custom_bottom_bar.dart';
import 'package:tech_trove_shop/stripe_helper/stripe_helper.dart';

class CartItemCheckOut extends StatefulWidget {
  const CartItemCheckOut({
    super.key,
  });

  @override
  State<CartItemCheckOut> createState() => _CartItemCheckOutState();
}

class _CartItemCheckOutState extends State<CartItemCheckOut> {
  int groupValue = 1;
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Checkout"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const SizedBox(
              height: 36.0,
            ),
            Container(
              height: 80.0,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40.0),
                border: Border.all(color: Colors.lightBlueAccent, width: 3.0),
              ),
              child: Row(
                children: [
                  Radio(
                    value: 1,
                    groupValue: groupValue,
                    onChanged: (value) {
                      setState(() {
                        groupValue = value!;
                      });
                    },
                  ),
                  const SizedBox(
                    width: 12.0,
                  ),
                  const Icon(Icons.money),
                  const SizedBox(
                    width: 24.0,
                  ),
                  const Text(
                    "Cash On Delievery",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 24.0,
            ),
            Container(
              height: 80.0,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40.0),
                border: Border.all(color: Colors.lightBlueAccent, width: 3.0),
              ),
              child: Row(
                children: [
                  Radio(
                    value: 2,
                    groupValue: groupValue,
                    onChanged: (value) {
                      setState(() {
                        groupValue = value!;
                      });
                    },
                  ),
                  const SizedBox(
                    width: 12.0,
                  ),
                  const Icon(Icons.payment_outlined),
                  const SizedBox(
                    width: 24.0,
                  ),
                  const Text(
                    "Pay Online",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 24.0,
            ),
            SizedBox(
              width: 200,
              height: 60,
              child: ElevatedButton(
                onPressed: () async {
                  switch (groupValue) {
                    case 1:
                      bool value = await FirebaseFirestoreHelper.instance
                          .uploadOrderedProductFirebase(
                              appProvider.getBuyProductList,
                              context,
                              "Cash On Delievery");
                      appProvider.clearBuyProduct();
                      if (value) {
                        Future.delayed(const Duration(seconds: 4), () {
                          Routes.instance.push(
                            const CustomBottomBar(),
                            context,
                          );
                        });
                      }

                      break;
                    case 2:
                      double totalprice = appProvider.totalPrice() * 100;
                      bool isSuccessfullyPayment = await StripeHelper.instance
                          .makePayment(totalprice.toString());
                      if (isSuccessfullyPayment) {
                        bool value = await FirebaseFirestoreHelper.instance
                            .uploadOrderedProductFirebase(
                                appProvider.getBuyProductList, context, "paid");
                        appProvider.clearBuyProduct();
                        if (value) {
                          Future.delayed(const Duration(seconds: 2), () {
                            Routes.instance
                                .push(const CustomBottomBar(), context);
                          });
                        }
                      }
                      break;

                    default:
                  }
                  // if (groupValue == 1) {
                  //   bool value = await FirebaseFirestoreHelper.instance
                  //       .uploadOrderedProductFirebase(
                  //           appProvider.getBuyProductList,
                  //           context,
                  //           "Cash On Delievery");
                  //   appProvider.clearBuyProduct();
                  //   if (value) {
                  //     Future.delayed(const Duration(seconds: 4), () {
                  //       Routes.instance.push(
                  //         const CustomBottomBar(),
                  //         context,
                  //       );
                  //     });
                  //   } else {
                  //     print("hello");
                  //     double totalprice = appProvider.totalPrice() * 100;
                  //     bool isSuccessfullyPayment = await StripeHelper.instance
                  //         .makePayment(totalprice.toString());
                  //     if (isSuccessfullyPayment) {
                  //       bool value = await FirebaseFirestoreHelper.instance
                  //           .uploadOrderedProductFirebase(
                  //               appProvider.getBuyProductList, context, "paid");
                  //       appProvider.clearBuyProduct();
                  //       if (value) {
                  //         Future.delayed(const Duration(seconds: 2), () {
                  //           Routes.instance
                  //               .push(const CustomBottomBar(), context);
                  //         });
                  //       }
                  //     }
                  //   }
                  // }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlueAccent,
                ),
                child: const Text(
                  "Continue",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
