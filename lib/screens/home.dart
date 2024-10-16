import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_trove_shop/Firebase/firebase_firestore.dart';
import 'package:tech_trove_shop/constants/routes.dart';
import 'package:tech_trove_shop/models/category_model.dart';
import 'package:tech_trove_shop/models/product_model.dart';
import 'package:tech_trove_shop/provider/app_provider.dart';
import 'package:tech_trove_shop/screens/category_view.dart';
import 'package:tech_trove_shop/screens/product_details.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CategoryModel> categoriesList1 = [];
  List<ProductModel> productModelList = [];
  bool isLoading = false;

  @override
  void initState() {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.getUserInfoFirebase();
    getCategories1();
    super.initState();
  }

  void getCategories1() async {
    setState(() {
      isLoading = true;
    });
    FirebaseFirestoreHelper.instance.updateTokenFromFirebase();
    categoriesList1 = await FirebaseFirestoreHelper.instance.getCategories1();
    productModelList = await FirebaseFirestoreHelper.instance.getProducts();
    productModelList.shuffle(); // Randomize products for better user experience
    setState(() {
      isLoading = false;
    });
  }

  TextEditingController search = TextEditingController();
  List<ProductModel> searchList = [];

  void searchProducts(String value) {
    searchList = productModelList
        .where((element) =>
            element.name.toLowerCase().contains(value.toLowerCase()))
        .toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Get the width of the screen
    double screenWidth = MediaQuery.of(context).size.width;

    // Determine the number of columns for the grid based on the screen width
    int crossAxisCount = screenWidth > 600
        ? 3
        : 2; // 3 columns for tablets and above, 2 for phones

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.lightBlueAccent,
              Colors.blueAccent,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: isLoading
              ? Center(
                  child: Container(
                    height: 100,
                    width: 100,
                    alignment: Alignment.topCenter,
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: kToolbarHeight - 15),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.4),
                                            spreadRadius: 2,
                                            blurRadius: 10,
                                          ),
                                        ],
                                        gradient: const LinearGradient(
                                          colors: [
                                            Colors.lightBlueAccent,
                                            Colors.blueAccent,
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: TextFormField(
                                        style: const TextStyle(
                                            color: Colors.white),
                                        controller: search,
                                        onChanged: (String value) {
                                          searchProducts(value);
                                        },
                                        keyboardType: TextInputType.name,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.all(8),
                                          hintText: "Search...",
                                          hintStyle: const TextStyle(
                                            color: Colors.white70,
                                          ),
                                          prefixIcon: const Icon(
                                            Icons.search,
                                            color: Colors.white,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            borderSide: BorderSide.none,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            borderSide: BorderSide.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),

                          // Category List with Cards
                          categoriesList1.isEmpty
                              ? const Center(
                                  child: Text("Categories not available"))
                              : SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: categoriesList1
                                        .map((category) => Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  Routes.instance.push(
                                                      CategoryView(
                                                          categoryModel:
                                                              category),
                                                      context);
                                                },
                                                child: Card(
                                                  color: Colors.white,
                                                  elevation: 5.0,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                  ),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    width: 90,
                                                    height: 90,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Image.network(
                                                            category.image,
                                                            height: 50),
                                                        const SizedBox(
                                                            height: 5),
                                                        Text(
                                                          category.name,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.black87,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                ),

                          const SizedBox(height: 10),
                          const Text(
                            "Products",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 23.0,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    search.text.isNotEmpty && searchList.isEmpty
                        ? const Center(child: Text("No Product Found"))
                        : searchList.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: GridView.builder(
                                  padding: const EdgeInsets.only(bottom: 50.0),
                                  shrinkWrap: true,
                                  primary: false,
                                  itemCount: searchList.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisSpacing: 15,
                                    mainAxisSpacing: 15,
                                    childAspectRatio: 0.8,
                                    crossAxisCount: crossAxisCount,
                                  ),
                                  itemBuilder: (ctx, index) {
                                    ProductModel singleProduct =
                                        searchList[index];
                                    return InkWell(
                                      onTap: () {
                                        Routes().push(
                                            ProductDetails(
                                                singleProduct: singleProduct),
                                            context);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.2),
                                              spreadRadius: 2,
                                              blurRadius: 5,
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.network(singleProduct.image,
                                                height: 120, width: 120),
                                            const SizedBox(height: 10),
                                            Text(
                                              singleProduct.name,
                                              style: const TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              "Rs: ${singleProduct.price}",
                                              style: const TextStyle(
                                                color: Colors.black87,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : productModelList.isEmpty
                                ? const Center(
                                    child: Text("No products available"))
                                : Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: GridView.builder(
                                      padding:
                                          const EdgeInsets.only(bottom: 50.0),
                                      shrinkWrap: true,
                                      primary: false,
                                      itemCount: productModelList.length,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisSpacing: 15,
                                        mainAxisSpacing: 15,
                                        childAspectRatio: 0.8,
                                        crossAxisCount: crossAxisCount,
                                      ),
                                      itemBuilder: (ctx, index) {
                                        ProductModel singleProduct =
                                            productModelList[index];
                                        return InkWell(
                                          onTap: () {
                                            Routes().push(
                                                ProductDetails(
                                                    singleProduct:
                                                        singleProduct),
                                                context);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.2),
                                                  spreadRadius: 2,
                                                  blurRadius: 5,
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.network(
                                                    singleProduct.image,
                                                    height: 120,
                                                    width: 120),
                                                const SizedBox(height: 10),
                                                Text(
                                                  singleProduct.name,
                                                  style: const TextStyle(
                                                    fontSize: 14.0,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  "Rs: ${singleProduct.price}",
                                                  style: const TextStyle(
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                  ],
                ),
        ),
      ),
    );
  }
}
