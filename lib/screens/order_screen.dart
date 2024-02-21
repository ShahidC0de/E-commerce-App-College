import 'package:flutter/material.dart';
import 'package:tech_trove_shop/Firebase/firebase_firestore.dart';
import 'package:tech_trove_shop/models/order_model.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Orders"),
        ),
        body: FutureBuilder(
            future: FirebaseFirestoreHelper.instance.getUserOrders(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.data!.isEmpty || snapshot.data == null) {
                return const Center(
                  child: Text("No Orders yet"),
                );
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 100),
                child: ListView.builder(
                    padding: const EdgeInsets.all(12.0),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      OrderModel orderModel = snapshot.data![index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: ExpansionTile(
                            tilePadding: EdgeInsets.zero,
                            collapsedShape: const RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Colors.lightBlueAccent, width: 2.3)),
                            shape: const RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Colors.lightBlueAccent, width: 2.3)),
                            title: Row(
                              children: [
                                //the image part of item in listview.

                                Container(
                                    height: 120,
                                    width: 120,
                                    color: Colors.white.withOpacity(0.5),
                                    child: Image.network(
                                        orderModel.products[0].image)),
                                //the rest space of listview.
                                Expanded(
                                  flex: 2,
                                  child: FittedBox(
                                    child: Container(
                                      color: Colors.white.withOpacity(0.5),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              orderModel.products[0].name,
                                              style: const TextStyle(
                                                color: Colors.lightBlueAccent,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 2.0,
                                            ),
                                            Text(
                                              "Rs: ${orderModel.totalPrice.toString()}",
                                              style: const TextStyle(
                                                color: Colors.lightBlueAccent,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 2.0,
                                            ),
                                            Text(
                                              "Status: ${orderModel.status}",
                                              style: const TextStyle(
                                                color: Colors.lightBlueAccent,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 2.0,
                                            ),
                                            orderModel.products.length > 1
                                                ? SizedBox.fromSize()
                                                : Column(
                                                    children: [
                                                      Text(
                                                        "Quantity: ${orderModel.products[0].qty.toString()}",
                                                        style: const TextStyle(
                                                          color: Colors
                                                              .lightBlueAccent,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 12.0,
                                                      ),
                                                      orderModel.status ==
                                                                  'pending' ||
                                                              orderModel
                                                                      .status ==
                                                                  'deliever'
                                                          ? ElevatedButton(
                                                              onPressed: () {
                                                                FirebaseFirestoreHelper
                                                                    .instance
                                                                    .updateOrder(
                                                                        orderModel,
                                                                        'Canceled');
                                                                setState(() {});
                                                              },
                                                              child: const Text(
                                                                  'Cancel Order'))
                                                          : SizedBox.fromSize(),
                                                      orderModel.status ==
                                                              'delivery'
                                                          ? ElevatedButton(
                                                              onPressed: () {
                                                                FirebaseFirestoreHelper
                                                                    .instance
                                                                    .updateOrder(
                                                                        orderModel,
                                                                        'Delievered');
                                                                setState(() {});
                                                              },
                                                              child: const Text(
                                                                  'Order Delivered'))
                                                          : SizedBox.fromSize(),
                                                    ],
                                                  )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            children: orderModel.products.length > 1
                                ? [
                                    const Text("Order Details"),
                                    const Divider(
                                      color: Colors.lightBlueAccent,
                                    ),
                                    ...orderModel.products.map((singleProduct) {
                                      return Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                //the image part of item in listview.

                                                Container(
                                                    height: 80,
                                                    width: 80,
                                                    color: Colors.white
                                                        .withOpacity(0.5),
                                                    child: Image.network(
                                                        singleProduct.image)),
                                                //the rest space of listview.
                                                Expanded(
                                                  flex: 2,
                                                  child: Container(
                                                    height: 200,
                                                    width: 200,
                                                    color: Colors.white
                                                        .withOpacity(0.5),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            singleProduct.name,
                                                            style:
                                                                const TextStyle(
                                                              color: Colors
                                                                  .lightBlueAccent,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 2.0,
                                                          ),
                                                          Text(
                                                            "Rs: ${singleProduct.price.toString()}",
                                                            style:
                                                                const TextStyle(
                                                              color: Colors
                                                                  .lightBlueAccent,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 2.0,
                                                          ),
                                                          Column(
                                                            children: [
                                                              Text(
                                                                "Quantity: ${singleProduct.qty.toString()}",
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .lightBlueAccent,
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList()
                                  ]
                                : []),
                      );
                    }),
              );
            }));
  }
}
// import 'package:flutter/material.dart';
// import 'package:tech_trove_shop/Firebase/firebase_firestore.dart';
// import 'package:tech_trove_shop/models/order_model.dart';

// class OrderScreen extends StatelessWidget {
//   const OrderScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Your Orders",
//           style: TextStyle(
//             color: Colors.black,
//           ),
//         ),
//       ),
//       body: FutureBuilder(
//           future: FirebaseFirestoreHelper.instance.getUserOrders(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             }
//             if (snapshot.data!.isEmpty ||
//                 snapshot.data == null ||
//                 !snapshot.hasData) {
//               return const Center(
//                 child: Text("No Order Found"),
//               );
//             }

//             return ListView.builder(
//               itemCount: snapshot.data!.length,
//               padding: const EdgeInsets.all(12.0),
//               itemBuilder: (context, index) {
//                 OrderModel orderModel = snapshot.data![index];
//                 return Padding(
//                   padding: const EdgeInsets.only(bottom: 12.0),
//                   child: ExpansionTile(
//                       tilePadding: EdgeInsets.zero,
//                       childrenPadding: EdgeInsets.zero,
//                       collapsedShape: const RoundedRectangleBorder(
//                           side: BorderSide(color: Colors.blue, width: 2.3)),
//                       title: Row(
//                         crossAxisAlignment: CrossAxisAlignment.baseline,
//                         textBaseline: TextBaseline.alphabetic,
//                         children: [
//                           Container(
//                             height: 160,
//                             width: 140,
//                             color: Colors.white.withOpacity(0.5),
//                             child: Image.network(
//                               orderModel.products[0].image,
//                             ),
//                           ),
//                           Expanded(
//                             flex: 2,
//                             child: Container(
//                               height: 140,
//                               color: Colors.white.withOpacity(0.5),
//                               child: Column(
//                                 children: [
//                                   Text(
//                                     orderModel.products[0].name,
//                                     style: const TextStyle(
//                                       fontSize: 16.0,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   const SizedBox(
//                                     height: 12.0,
//                                   ),
//                                   Text(
//                                     "Rs: ${orderModel.totalPrice.toString()}",
//                                     style: const TextStyle(
//                                       fontSize: 10.0,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   const SizedBox(
//                                     height: 12.0,
//                                   ),
//                                   orderModel.products.length > 1
//                                       ? SizedBox.fromSize()
//                                       : Column(
//                                           children: [
//                                             Text(
//                                               "Quantity: ${orderModel.products[0].qty}",
//                                               style: const TextStyle(
//                                                 fontSize: 10.0,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                             const SizedBox(
//                                               height: 8.0,
//                                             ),
//                                           ],
//                                         ),
//                                   Text(
//                                     "Status: ${orderModel.status}",
//                                     style: const TextStyle(
//                                       fontSize: 10.0,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       children: orderModel.products.length > 1
//                           ? [
//                               const Text("Order Details"),
//                               const Divider(color: Colors.lightBlueAccent),
//                               ...orderModel.products.map((singleProduct) {
//                                 return Padding(
//                                   padding: const EdgeInsets.only(
//                                       left: 12.0, top: 6.0),
//                                   child: Column(
//                                     children: [
//                                       Row(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.baseline,
//                                         textBaseline: TextBaseline.alphabetic,
//                                         children: [
//                                           Container(
//                                             height: 80,
//                                             width: 80,
//                                             color:
//                                                 Colors.white.withOpacity(0.5),
//                                             child: Image.network(
//                                               singleProduct.image,
//                                             ),
//                                           ),
//                                           Expanded(
//                                             flex: 2,
//                                             child: Container(
//                                               height: 140,
//                                               color:
//                                                   Colors.white.withOpacity(0.5),
//                                               child: Column(
//                                                 children: [
//                                                   Text(
//                                                     singleProduct.name,
//                                                     style: const TextStyle(
//                                                       fontSize: 16.0,
//                                                       fontWeight:
//                                                           FontWeight.bold,
//                                                     ),
//                                                   ),
//                                                   const SizedBox(
//                                                     height: 12.0,
//                                                   ),
//                                                   Text(
//                                                     "Rs: ${singleProduct.price.toString()}",
//                                                     style: const TextStyle(
//                                                       fontSize: 15.0,
//                                                       fontWeight:
//                                                           FontWeight.bold,
//                                                     ),
//                                                   ),
//                                                   const SizedBox(
//                                                     height: 12.0,
//                                                   ),
//                                                   Column(
//                                                     children: [
//                                                       Text(
//                                                         "Quantity: ${singleProduct.qty}",
//                                                         style: const TextStyle(
//                                                           fontSize: 15.0,
//                                                           fontWeight:
//                                                               FontWeight.bold,
//                                                         ),
//                                                       ),
//                                                       const SizedBox(
//                                                         height: 8.0,
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                                 // ignore: unnecessary_to_list_in_spreads
//                               }).toList()
//                             ]
//                           : []),
//                 );
//               },
//             );
//           }),
//     );
//   }
// }
