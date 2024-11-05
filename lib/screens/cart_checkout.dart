import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_trove_shop/Firebase/firebase_firestore.dart';
import 'package:tech_trove_shop/constants/constants.dart';
import 'package:tech_trove_shop/constants/routes.dart';
import 'package:tech_trove_shop/provider/app_provider.dart';
import 'package:tech_trove_shop/screens/custom_bottom_bar.dart';
import 'package:tech_trove_shop/stripe_helper/stripe_helper.dart';

class CartItemCheckOut extends StatefulWidget {
  const CartItemCheckOut({super.key});

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
        title: const Text(
          "Checkout",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20.0),
            Text(
              "Select Payment Method",
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            buildPaymentOption(
              context,
              value: 1,
              icon: Icons.money,
              label: "Cash On Delivery",
            ),
            const SizedBox(height: 16.0),
            buildPaymentOption(
              context,
              value: 2,
              icon: Icons.payment_outlined,
              label: "Pay Online",
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () async {
                  await handlePayment(appProvider);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlueAccent,
                ),
                child: const Text(
                  "Continue",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPaymentOption(BuildContext context,
      {required int value, required IconData icon, required String label}) {
    return Container(
      height: 80.0,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: Colors.lightBlueAccent, width: 2.0),
      ),
      child: Row(
        children: [
          Radio(
            value: value,
            groupValue: groupValue,
            onChanged: (value) {
              setState(() {
                groupValue = value!;
              });
            },
          ),
          const SizedBox(width: 12.0),
          Icon(icon, color: Colors.lightBlueAccent),
          const SizedBox(width: 16.0),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> handlePayment(AppProvider appProvider) async {
    bool value = false;

    switch (groupValue) {
      case 1: // Cash on Delivery
        value =
            await FirebaseFirestoreHelper.instance.uploadOrderedProductFirebase(
          appProvider.getBuyProductList,
          context,
          "Cash On Delivery",
        );
        break;
      case 2: // Online Payment
        double totalPrice = appProvider.totalPrice() * 100;
        bool isSuccessfulPayment =
            await StripeHelper.instance.makePayment(totalPrice.toString());
        if (isSuccessfulPayment) {
          value = await FirebaseFirestoreHelper.instance
              .uploadOrderedProductFirebase(
            appProvider.getBuyProductList,
            context,
            "Paid",
          );
        }
        break;
    }

    if (value) {
      appProvider.clearBuyProduct();
      await showRatingDialog(context); // Show the rating dialog first
    }
  }

  Future<void> showRatingDialog(BuildContext context) async {
    int selectedRating = 3; // Default rating
    TextEditingController commentController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Rate Your Experience"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomRatingBar(
                rating: selectedRating,
                onRatingChanged: (rating) {
                  setState(() {
                    selectedRating = rating;
                  });
                },
              ),
              TextField(
                controller: commentController,
                decoration: const InputDecoration(
                  labelText: "Leave a comment",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => const CustomBottomBar()),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                String comment = commentController.text;
                await FirebaseFirestoreHelper.instance.saveRatingAndComment(
                  rating: selectedRating,
                  comment: comment,
                );
                showMessage('Successfully submitted');

                // Navigate to CustomBottomBar after submitting the rating
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => const CustomBottomBar()),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }
}

// Custom Rating Bar Widget
class CustomRatingBar extends StatefulWidget {
  final int rating;
  final ValueChanged<int> onRatingChanged;

  const CustomRatingBar({
    Key? key,
    required this.rating,
    required this.onRatingChanged,
  }) : super(key: key);

  @override
  State<CustomRatingBar> createState() => _CustomRatingBarState();
}

class _CustomRatingBarState extends State<CustomRatingBar> {
  int currentRating = 1;

  @override
  void initState() {
    super.initState();
    currentRating = widget.rating; // Initialize current rating
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            Icons.star,
            color: index < currentRating ? Colors.amber : Colors.grey,
          ),
          onPressed: () {
            setState(() {
              currentRating = index + 1; // Update current rating
              widget.onRatingChanged(
                  currentRating); // Notify parent of rating change
            });
          },
        );
      }),
    );
  }
}
