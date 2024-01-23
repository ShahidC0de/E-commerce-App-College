import 'package:flutter/cupertino.dart';
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
    productModelList.shuffle(); // for random randering..
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
    return Scaffold(
      body: SingleChildScrollView(
        child: isLoading
            ? Center(
                child: Container(
                  height: 100,
                  width: 100,
                  alignment: Alignment.topCenter,
                  child: const CircularProgressIndicator(),
                ),
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: kToolbarHeight - 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              "Home",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 23.0,
                                color: Colors.lightBlueAccent,
                              ),
                            ),
                            const SizedBox(
                              width: 12.0,
                            ),
                            SizedBox(
                              height: 50, //size of textformfield,
                              width: 200,
                              child: TextFormField(
                                controller: search,
                                onChanged: (String value) {
                                  searchProducts(value);
                                },
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                    //decoration of textformfield.
                                    //EMAIL TEXTFORM FILED
                                    hintText: "Search..",
                                    hintStyle: const TextStyle(
                                      color: Colors.lightBlueAccent,
                                    ),
                                    prefixIcon: const Icon(
                                      //putting an icon.
                                      Icons.search,
                                      color: Colors.lightBlueAccent,
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Colors.lightBlueAccent,
                                      ),
                                      borderRadius: BorderRadius.circular(40.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        width: 2,
                                        color: Colors.lightBlueAccent,
                                      ),
                                      borderRadius: BorderRadius.circular(40.0),
                                    )),
                              ),
                            ),
                            const SizedBox(
                              width: 12.0,
                            ),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.card_travel,
                                  color: Colors.lightBlueAccent,
                                  size: 35,
                                ))
                          ],
                        ),
                        //CATEGORYLIST.MAP((E)=>NULL).TO LIST, organized in a way in which images in the database is been uploaded in the card widget, although it is in padding to look more good, but its card widget.
                        categoriesList1.isEmpty
                            ? const Center(
                                child: Text("List is not available"),
                              )
                            : SingleChildScrollView(
                                scrollDirection: Axis
                                    .horizontal, //use to scroll in the left/right direction.
                                //normally single child scroll view scroll from top to bottom,bottom to top whatever....
                                child: Row(
                                  // in a row...
                                  children: categoriesList1
                                      //children in a row.. mapping into cards which are placed in row structure.
                                      .map((e) => Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: CupertinoButton(
                                              onPressed: () {
                                                Routes.instance.push(
                                                    CategoryView(
                                                        categoryModel: e),
                                                    context);
                                              },
                                              child: Card(
                                                color: Colors.white,
                                                elevation: 3.0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ),
                                                child: SizedBox(
                                                  //the space given to a single card.
                                                  height: 80,
                                                  width: 80,
                                                  child: Image.network(e.image),
                                                  //the child of card which is image/image.network is use to access internet for the link.
                                                ),
                                              ),
                                            ),
                                          ))
                                      .toList(), //to a list.....
                                ),
                              ),

                        const Text(
                          "Products",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 23.0,
                            color: Colors.lightBlueAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  search.text.isNotEmpty && searchList.isEmpty
                      ? const Center(
                          child: Text("No Product Found"),
                        )
                      : searchList.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: GridView.builder(
                                  padding: const EdgeInsets.only(bottom: 50.0),
                                  shrinkWrap: true,
                                  primary: false,
                                  itemCount: searchList.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisSpacing: 20,
                                          mainAxisSpacing: 20,
                                          childAspectRatio: 0.9,
                                          crossAxisCount: 2),
                                  itemBuilder: (ctx, index) {
                                    ProductModel singleProduct =
                                        searchList[index];
                                    return Container(
                                      color: Colors.white,
                                      child: Column(
                                        children: [
                                          Image.network(
                                            singleProduct.image,
                                            height: 60,
                                            width: 60,
                                          ),
                                          const SizedBox(
                                            height: 12.0,
                                          ),
                                          Text(
                                            singleProduct.name,
                                            style: const TextStyle(
                                              fontSize: 10.0,
                                              color: Colors.lightBlueAccent,
                                            ),
                                          ),
                                          Text("Rs: ${singleProduct.price}"),
                                          const SizedBox(
                                            height: 6.0,
                                          ),
                                          OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                  side: const BorderSide(
                                                color: Colors.lightBlueAccent,
                                              )),
                                              onPressed: () {
                                                Routes().push(
                                                    ProductDetails(
                                                        singleProduct:
                                                            singleProduct),
                                                    context);
                                              },
                                              child: const Text(
                                                "Buy",
                                                style: TextStyle(
                                                  color: Colors.lightBlueAccent,
                                                ),
                                              ))
                                        ],
                                      ),
                                    );
                                  }),
                            )
                          : productModelList.isEmpty
                              ? const Center(
                                  child: Text("No products available"),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: GridView.builder(
                                      padding:
                                          const EdgeInsets.only(bottom: 50.0),
                                      shrinkWrap: true,
                                      primary: false,
                                      itemCount: productModelList.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisSpacing: 20,
                                              mainAxisSpacing: 20,
                                              childAspectRatio: 0.9,
                                              crossAxisCount: 2),
                                      itemBuilder: (ctx, index) {
                                        ProductModel singleProduct =
                                            productModelList[index];
                                        return Container(
                                          color: Colors.white,
                                          child: Column(
                                            children: [
                                              Image.network(
                                                singleProduct.image,
                                                height: 60,
                                                width: 60,
                                              ),
                                              const SizedBox(
                                                height: 12.0,
                                              ),
                                              Text(
                                                singleProduct.name,
                                                style: const TextStyle(
                                                  fontSize: 10.0,
                                                  color: Colors.lightBlueAccent,
                                                ),
                                              ),
                                              Text(
                                                  "Rs: ${singleProduct.price}"),
                                              const SizedBox(
                                                height: 6.0,
                                              ),
                                              OutlinedButton(
                                                  style:
                                                      OutlinedButton.styleFrom(
                                                          side:
                                                              const BorderSide(
                                                    color:
                                                        Colors.lightBlueAccent,
                                                  )),
                                                  onPressed: () {
                                                    Routes().push(
                                                        ProductDetails(
                                                            singleProduct:
                                                                singleProduct),
                                                        context);
                                                  },
                                                  child: const Text(
                                                    "Buy",
                                                    style: TextStyle(
                                                      color: Colors
                                                          .lightBlueAccent,
                                                    ),
                                                  ))
                                            ],
                                          ),
                                        );
                                      }),
                                )
                ],
              ),
      ),
    );
  }
}

//products list
// List<ProductModel> products = [
//   ProductModel(
//       image:
//           "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQG9_nT235vTvNx0b6W7se0liR3DyevIa3Axw&usqp=CAU",
//       id: "1",
//       name: "Dell Laptop",
//       price: 12000,
//       description:
//           "One of the dominating company Dell new core i5 8th generation",
//       isFavourate: false), //Laptop
//   ProductModel(
//       image:
//           "https://fattanicomputers.com/wp-content/uploads/2023/11/hp-laptops.png",
//       id: "2",
//       name: "hp Laptop",
//       price: 13000,
//       description: "hp new laptop...",
//       isFavourate: false), //Laptop
//   ProductModel(
//       image:
//           "https://mistore.pk/cdn/shop/products/Xiaomi65WGaNCharger_Type-A_Type-C_grande.png?v=1661769873",
//       id: "3",
//       name: "Redmi Fast Charger",
//       price: 3500,
//       description: "charge the phone in 30 minutes",
//       isFavourate: false), //chargers
//   ProductModel(
//       image:
//           "https://shahalami.pk/cdn/shop/products/Untitled-1_d0b0ecbe-3aef-462d-a468-197aa6ce4317_992x.png?v=1675679681",
//       id: "4",
//       name: "Charger",
//       price: 1200,
//       description: "compartable charger",
//       isFavourate: false), //chargers
//   ProductModel(
//       image:
//           "https://i01.appmifile.com/v1/MI_18455B3E4DA706226CF7535A58E875F0267/pms_1666350161.25983265.png",
//       id: "5",
//       name: "Redmi Note 11",
//       price: 50000,
//       description: "Announcing new note 11 phone redmi",
//       isFavourate: false), //phones
//   ProductModel(
//       image:
//           "https://www.pakmobizone.pk/wp-content/uploads/2020/07/OnePlus-8-Peo-Glacial-Green-1.png",
//       id: "6",
//       name: "Oneplus",
//       price: 80000,
//       description: "octacore processor with 8gb of ram",
//       isFavourate: false), //phones
// ];
