import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_trove_shop/provider/app_provider.dart';
import 'package:tech_trove_shop/widget/single_favourate_item.dart';

class FavourateScreen extends StatelessWidget {
  const FavourateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          //appbar a flat border on the top of screen, and one back button with it;
          title: const Text(
            //title of the screen on appbar;
            "Favourates ",
            style: TextStyle(
              color: Colors.black, //color of text;
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.white, //color of appbar;
        ),
        body: appProvider.getFavourateProductList.isEmpty
            ? const Center(
                child: Text(
                  "No Favourate Products",
                  style: TextStyle(color: Colors.lightBlueAccent),
                ),
              )
            : ListView.builder(
                //use to render a list of items on screen;
                itemCount: appProvider.getFavourateProductList
                    .length, //the number of items to be listed;
                padding: const EdgeInsets.all(12.0),
                itemBuilder: (ctx, index) {
                  return SingleFavourateItem(
                    singleProduct: appProvider.getFavourateProductList[index],
                  );
                }));
  }
}
