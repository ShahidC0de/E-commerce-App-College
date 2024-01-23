import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_trove_shop/constants/constants.dart';
import 'package:tech_trove_shop/models/product_model.dart';
import 'package:tech_trove_shop/provider/app_provider.dart';

class SingleFavourateItem extends StatefulWidget {
  final ProductModel singleProduct;
  const SingleFavourateItem({super.key, required this.singleProduct});

  @override
  State<SingleFavourateItem> createState() => _SingleFavourateItem();
}

class _SingleFavourateItem extends State<SingleFavourateItem> {
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.lightBlueAccent, width: 2),
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
                              Text(
                                widget.singleProduct.name,
                                style: const TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.lightBlueAccent,
                                ),
                              ),
                              const SizedBox(
                                height: 6.0,
                              ),
                              CupertinoButton(
                                onPressed: () {
                                  appProvider.removeFavourateProductList(
                                      widget.singleProduct);
                                  showMessage("Removed from Wishlist");
                                },
                                child: const Text(
                                  "Remove from wishlist",
                                  style: TextStyle(
                                    fontSize: 10.0,
                                    color: Colors.lightBlueAccent,
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
