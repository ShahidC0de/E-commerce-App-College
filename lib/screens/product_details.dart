import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_trove_shop/constants/constants.dart';
import 'package:tech_trove_shop/constants/routes.dart';
import 'package:tech_trove_shop/models/product_model.dart';
import 'package:tech_trove_shop/provider/app_provider.dart';
import 'package:tech_trove_shop/screens/cart_screen.dart';
import 'package:tech_trove_shop/screens/check_out.dart';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:tech_trove_shop/constants/routes.dart';
// import 'package:tech_trove_shop/models/product_model.dart';
// import 'package:tech_trove_shop/provider/app_provider.dart';

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
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                onPressed: () {
                  Routes().push(const CartScreen(), context);
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => const CartScreen(),
                  ));
                },
                icon: const Icon(Icons.shopping_cart),
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      widget.singleProduct.image,
                      height: 300,
                      width: 300,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.singleProduct.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Colors.lightBlueAccent,
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
                          color: Colors.lightBlueAccent,
                        ),
                      ],
                    ),
                    Text(
                      widget.singleProduct.description,
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    Row(
                      children: [
                        CupertinoButton(
                          onPressed: () {
                            if (qty >= 1) {
                              setState(() {
                                qty--;
                              });
                            }
                          },
                          padding: EdgeInsets.zero,
                          child: const CircleAvatar(
                            backgroundColor: Colors.lightBlueAccent,
                            child: Icon(
                              Icons.remove,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 30.0,
                        ),
                        Text(
                          qty.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                        const SizedBox(
                          width: 30.0,
                        ),
                        CupertinoButton(
                          onPressed: () {
                            setState(() {
                              qty++;
                            });
                          },
                          padding: EdgeInsets.zero,
                          child: const CircleAvatar(
                            backgroundColor: Colors.lightBlueAccent,
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 60.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 38,
                          width: 140,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.lightBlueAccent),
                            onPressed: () {
                              ProductModel productModel =
                                  widget.singleProduct.copyWith(qty: qty);
                              appProvider.addCartProductList(productModel);
                              showMessage("Added to Cart");
                            },
                            child: const Text(
                              "Add to Cart",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 48.0,
                        ),
                        SizedBox(
                          height: 38,
                          width: 140,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.lightBlueAccent),
                            onPressed: () {
                              ProductModel productModel =
                                  widget.singleProduct.copyWith(qty: qty);
                              appProvider.addCartProductList(productModel);
                              Routes().push(
                                  CheckOut(
                                    singleProduct: productModel,
                                  ),
                                  context);
                            },
                            child: const Text(
                              "Buy",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
