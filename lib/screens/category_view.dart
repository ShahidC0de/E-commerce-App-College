import 'package:flutter/material.dart';
import 'package:tech_trove_shop/Firebase/firebase_firestore.dart';
import 'package:tech_trove_shop/constants/routes.dart';
import 'package:tech_trove_shop/models/category_model.dart';
import 'package:tech_trove_shop/models/product_model.dart';
import 'package:tech_trove_shop/screens/product_details.dart';

class CategoryView extends StatefulWidget {
  final CategoryModel categoryModel;
  const CategoryView({super.key, required this.categoryModel});

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  List<ProductModel> productModelList = [];

  bool isLoading = false;
  void getCategoriesList1() async {
    setState(() {
      isLoading = true;
    });
    productModelList = await FirebaseFirestoreHelper.instance
        .getCategoryViewProduct(widget.categoryModel.id);
    productModelList.shuffle(); //to access random items.

    productModelList.shuffle();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getCategoriesList1();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: Container(
                height: 100,
                width: 100,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: kToolbarHeight,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const BackButton(),
                        Text(
                          widget.categoryModel.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18.0),
                        ),
                      ],
                    ),
                  ),
                  productModelList.isEmpty
                      ? const Center(
                          child: Text("No product available"),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 12.0, left: 12.0),
                          child: GridView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: productModelList.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisSpacing: 20.0,
                                      mainAxisSpacing: 20.0,
                                      childAspectRatio: 0.7,
                                      crossAxisCount: 2),
                              itemBuilder: (ctx, index) {
                                ProductModel singleproduct =
                                    productModelList[index];
                                return Container(
                                  color: Colors.white.withOpacity(0.3),
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 12.0,
                                      ),
                                      Image.network(
                                        singleproduct.image,
                                        height: 60,
                                        width: 60,
                                      ),
                                      const SizedBox(
                                        height: 12.0,
                                      ),
                                      Text(
                                        singleproduct.name,
                                        style: const TextStyle(
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(" Rs : ${singleproduct.price}"),
                                      const SizedBox(
                                        height: 6.0,
                                      ),
                                      SizedBox(
                                          height: 45,
                                          width: 100,
                                          child: OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                  side: const BorderSide(
                                                color: Colors.blue,
                                                width: 1.7,
                                              )),
                                              onPressed: () {
                                                Routes().push(
                                                    ProductDetails(
                                                      singleProduct:
                                                          singleproduct,
                                                    ),
                                                    context);
                                                // Navigator.of(context).push(
                                                //     MaterialPageRoute(
                                                //         builder: (ctx) =>
                                                //             ProductDetails(
                                                //               singleProduct:
                                                //                   singleproduct,
                                                //             )));
                                              },
                                              child: const Text("Buy")))
                                    ],
                                  ),
                                );
                              }),
                        ),
                  const SizedBox(
                    height: 12.0,
                  )
                ],
              ),
            ),
    );
  }
}
