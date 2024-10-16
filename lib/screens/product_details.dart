// ignore_for_file: use_super_parameters

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_trove_shop/constants/constants.dart';
import 'package:tech_trove_shop/models/product_model.dart';
import 'package:tech_trove_shop/provider/app_provider.dart';
import 'package:tech_trove_shop/screens/cart_screen.dart';

class ProductDetails extends StatefulWidget {
  final ProductModel singleProduct;
  const ProductDetails({Key? key, required this.singleProduct})
      : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int qty = 1;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartScreen()),
                  );
                },
                icon: const Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                ),
              )
            ],
          ),
          extendBodyBehindAppBar: true,
          body: Container(
            width: screenWidth, // Make the background cover the entire width
            height: screenHeight, // Full screen height for background
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.lightBlueAccent,
                  Colors.blueAccent,
                ],
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05, // Adjust horizontal padding
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Image.network(
                          widget.singleProduct.image,
                          height:
                              screenHeight * 0.4, // 40% of the screen height
                          width: screenWidth * 0.8, // 80% of the screen width
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.singleProduct.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    screenWidth * 0.05, // Scalable font size
                                color: Colors.white,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                widget.singleProduct.isFavourate =
                                    !widget.singleProduct.isFavourate;
                              });
                              if (widget.singleProduct.isFavourate) {
                                appProvider.addFavourateProductList(
                                    widget.singleProduct);
                              } else {
                                appProvider.removeFavourateProductList(
                                    widget.singleProduct);
                              }
                            },
                            icon: Icon(appProvider.getFavourateProductList
                                    .contains(widget.singleProduct)
                                ? Icons.favorite
                                : Icons.favorite_border),
                            color: Colors.white,
                          ),
                        ],
                      ),
                      Text(
                        widget.singleProduct.description,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize:
                              screenWidth * 0.04, // Scalable description font
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CupertinoButton(
                            onPressed: () {
                              if (qty >= 1) {
                                setState(() {
                                  qty == 1 ? qty = qty : qty--;
                                });
                              }
                            },
                            padding: EdgeInsets.zero,
                            child: const CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.remove,
                                color: Colors.lightBlueAccent,
                              ),
                            ),
                          ),
                          const SizedBox(width: 30.0),
                          Text(
                            qty.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth *
                                  0.05, // Scalable font for quantity
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 30.0),
                          CupertinoButton(
                            onPressed: () {
                              setState(() {
                                qty++;
                              });
                            },
                            padding: EdgeInsets.zero,
                            child: const CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.add,
                                color: Colors.lightBlueAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 60.0),
                      Column(
                        children: [
                          SizedBox(
                            height: 48,
                            width: screenWidth *
                                0.9, // Button width scales to 90% of screen
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                              ),
                              onPressed: () {
                                ProductModel productModel =
                                    widget.singleProduct.copyWith(qty: qty);
                                appProvider.addCartProductList(productModel);
                                showMessage("Added to Cart");
                              },
                              child: Text(
                                "Add to Cart",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth *
                                      0.05, // Scalable button text
                                  color: Colors.lightBlueAccent,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
