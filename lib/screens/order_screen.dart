// ignore_for_file: unused_local_variable, unnecessary_to_list_in_spreads

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
    // Get the screen width and height
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Orders"),
      ),
      body: FutureBuilder(
        future: FirebaseFirestoreHelper.instance.getUserOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(child: Text("No Orders yet"));
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
                      side: BorderSide(color: Colors.white, width: 2.3),
                    ),
                    shape: const RoundedRectangleBorder(
                      side:
                          BorderSide(color: Colors.lightBlueAccent, width: 2.3),
                    ),
                    title: Row(
                      children: [
                        // Responsive image size based on screen width
                        Container(
                          height: screenWidth * 0.3,
                          width: screenWidth * 0.3,
                          color: Colors.white.withOpacity(0.5),
                          child: Image.network(orderModel.products[0].image),
                        ),
                        const SizedBox(width: 12), // Add some spacing
                        Expanded(
                          flex: 2,
                          child: FittedBox(
                            child: Container(
                              color: Colors.white.withOpacity(0.5),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(orderModel.products[0].name,
                                        style: const TextStyle(
                                            color: Colors.black)),
                                    const SizedBox(height: 2.0),
                                    Text(
                                      "Rs: ${orderModel.totalPrice}",
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                    const SizedBox(height: 2.0),
                                    Text(
                                      "Status: ${orderModel.status}",
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                    const SizedBox(height: 2.0),
                                    if (orderModel.products.length == 1) ...[
                                      Text(
                                        "Quantity: ${orderModel.products[0].qty}",
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                      const SizedBox(height: 12.0),
                                      if (orderModel.status == 'pending' ||
                                          orderModel.status == 'delivered')
                                        ElevatedButton(
                                          onPressed: () {
                                            FirebaseFirestoreHelper.instance
                                                .updateOrder(
                                                    orderModel, 'Canceled');
                                            setState(() {});
                                          },
                                          child: const Text('Cancel Order'),
                                        ),
                                      if (orderModel.status == 'delivery')
                                        ElevatedButton(
                                          onPressed: () {
                                            FirebaseFirestoreHelper.instance
                                                .updateOrder(
                                                    orderModel, 'Delivered');
                                            setState(() {});
                                          },
                                          child: const Text('Order Delivered'),
                                        ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    children: orderModel.products.length > 1
                        ? [
                            const Text("Order Details"),
                            const Divider(color: Colors.lightBlueAccent),
                            ...orderModel.products.map((singleProduct) {
                              return Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: screenWidth * 0.2,
                                          width: screenWidth * 0.2,
                                          color: Colors.white.withOpacity(0.5),
                                          child: Image.network(
                                              singleProduct.image),
                                        ),
                                        const SizedBox(
                                            width: 12), // Add some spacing
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            color:
                                                Colors.white.withOpacity(0.5),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(singleProduct.name,
                                                      style: const TextStyle(
                                                          color: Colors.black)),
                                                  const SizedBox(height: 2.0),
                                                  Text(
                                                    "Rs: ${singleProduct.price}",
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                  const SizedBox(height: 2.0),
                                                  Text(
                                                    "Quantity: ${singleProduct.qty}",
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }).toList()
                          ]
                        : [],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
