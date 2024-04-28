import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_trove_shop/constants/constants.dart';
import 'package:tech_trove_shop/models/product_model.dart';
import 'package:tech_trove_shop/provider/app_provider.dart';

class SingleCartItem extends StatefulWidget {
  final ProductModel singleProduct;
  const SingleCartItem({super.key, required this.singleProduct});

  @override
  State<SingleCartItem> createState() => _SingleCartItemState();
}

class _SingleCartItemState extends State<SingleCartItem> {
  int qty = 1;
  @override
  void initState() {
    super.initState();

    qty = widget.singleProduct.qty ??
        1; // making sure that cart item quantity must be one;
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Row(
        children: [
          //the image part of item in listview.

          Expanded(
              child: Container(
                  height: 140,
                  color: Colors.white.withOpacity(0.5),
                  child: Image.network(widget.singleProduct.image))),
          //the rest space of listview.
          Expanded(
            flex: 2,
            child: FittedBox(
              child: Container(
                height: 160,
                color: Colors.white.withOpacity(0.5),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 40.0,
                              ),
                              Row(
                                children: [
                                  CupertinoButton(
                                    onPressed: () {
                                      if (qty > 1) {
                                        setState(() {
                                          qty--;
                                        });
                                        appProvider.updateQty(
                                            widget.singleProduct, qty);
                                      }
                                    },
                                    padding: EdgeInsets.zero,
                                    child: const CircleAvatar(
                                      maxRadius: 15,
                                      backgroundColor: Colors.lightBlueAccent,
                                      child: Icon(
                                        Icons.remove,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    qty.toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10.0,
                                    ),
                                  ),
                                  CupertinoButton(
                                    onPressed: () {
                                      setState(() {
                                        qty++;
                                      });
                                      appProvider.updateQty(
                                          widget.singleProduct, qty);
                                    },
                                    padding: EdgeInsets.zero,
                                    child: const CircleAvatar(
                                      maxRadius: 15,
                                      backgroundColor: Colors.lightBlueAccent,
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  if (!appProvider.getFavourateProductList
                                      .contains(widget.singleProduct)) {
                                    appProvider.addFavourateProductList(
                                        widget.singleProduct);
                                    showMessage("Added to Wishlist");
                                  } else {
                                    appProvider.removeFavourateProductList(
                                        widget.singleProduct);
                                    showMessage("Removed from Wishlist");
                                  }
                                },
                                child: Text(
                                  appProvider.getFavourateProductList
                                          .contains(widget.singleProduct)
                                      ? "Remove from Wishlist"
                                      : "Add to Wishlist",
                                  style: const TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "Rs: ${widget.singleProduct.price.toString()}",
                            style: const TextStyle(
                              fontSize: 15.0,
                              color: Colors.lightBlueAccent,
                            ),
                          ),
                        ],
                      ),
                      CupertinoButton(
                          child: const CircleAvatar(
                            backgroundColor: Colors.lightBlueAccent,
                            maxRadius: 13,
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            // widget.singleProduct.copyWith(qty: qty);
                            appProvider
                                .removeCartProductList(widget.singleProduct);
                            showMessage("Removed from Cart");
                          })
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
