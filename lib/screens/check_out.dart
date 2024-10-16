// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_trove_shop/Firebase/firebase_firestore.dart';
import 'package:tech_trove_shop/constants/routes.dart';
import 'package:tech_trove_shop/models/product_model.dart';
import 'package:tech_trove_shop/provider/app_provider.dart';
import 'package:tech_trove_shop/screens/custom_bottom_bar.dart';

class CheckOut extends StatefulWidget {
  final ProductModel singleProduct;
  const CheckOut({super.key, required this.singleProduct});

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  int groupValue = 1;

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);

    // Responsive dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonWidth = screenWidth * 0.8; // 80% of screen width

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Checkout"),
        backgroundColor: Colors.lightBlueAccent, // Consistent color
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20.0),
            const Text(
              "Select Payment Method",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87, // Consistent color
              ),
            ),
            const SizedBox(height: 24.0),

            // Cash on Delivery Option
            _buildPaymentOption(
              icon: Icons.money,
              text: "Cash On Delivery",
              value: 1,
            ),

            const SizedBox(height: 16.0),

            // Pay Online Option
            _buildPaymentOption(
              icon: Icons.payment_outlined,
              text: "Pay Online",
              value: 2,
            ),

            const SizedBox(height: 24.0),

            Center(
              child: SizedBox(
                width: buttonWidth,
                height: 60,
                child: ElevatedButton(
                  onPressed: () async {
                    appProvider.clearBuyProduct();
                    appProvider.addBuyProduct(widget.singleProduct);
                    bool value = await FirebaseFirestoreHelper.instance
                        .uploadOrderedProductFirebase(
                            appProvider.getBuyProductList,
                            context,
                            groupValue == 1 ? "Cash On Delivery" : "paid");
                    if (value) {
                      Future.delayed(const Duration(seconds: 2), () {
                        Routes.instance.push(
                          const CustomBottomBar(),
                          context,
                        );
                      });
                    }
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption({
    required IconData icon,
    required String text,
    required int value,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          groupValue = value;
        });
      },
      child: Container(
        height: 80.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40.0),
          border: Border.all(color: Colors.lightBlueAccent, width: 3.0),
        ),
        child: Row(
          children: [
            Radio(
              value: value,
              groupValue: groupValue,
              onChanged: (newValue) {
                setState(() {
                  groupValue = newValue!;
                });
              },
            ),
            const SizedBox(width: 12.0),
            Icon(icon, color: Colors.lightBlueAccent), // Icon color consistency
            const SizedBox(width: 24.0),
            Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
