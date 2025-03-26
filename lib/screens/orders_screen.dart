import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Orders")),
      body: user == null
          ? const Center(child: Text("Please login to view orders"))
          : StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users') // 🔹 Access users collection
            .doc(user!.uid) // 🔹 Get logged-in user's document
            .collection('orders') // 🔹 Access their orders subcollection
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No orders found"));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var order = snapshot.data!.docs[index];

              String orderId = order.id;
              double totalAmount = order.data().toString().contains('totalAmount')
                  ? order['totalAmount'].toDouble()
                  : 0.0;

              String status = order.data().toString().contains('status')
                  ? order['status']
                  : "Pending";

              List<dynamic> items = order.data().toString().contains('items')
                  ? order['items']
                  : [];

              return Card(
                margin: const EdgeInsets.all(10),
                elevation: 3,
                child: ExpansionTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Order ID: $orderId"),
                      const SizedBox(height: 5),
                      Text(
                        "₹${totalAmount.toStringAsFixed(2)}", // ✅ Ensure 2 decimal places
                        style: const TextStyle(
                          fontSize: 18, // ✅ Bigger font size
                          fontWeight: FontWeight.bold,
                          color: Colors.green, // ✅ Total Amount in Green
                        ),
                      ),
                    ],
                  ),
                  trailing: Text(
                    status,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: status.toLowerCase() == "pending"
                          ? Colors.red // ✅ Pending in Red
                          : Colors.green, // ✅ Others in Green
                    ),
                  ),
                  children: [
                    const Divider(),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Ordered Items:",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    Column(
                      children: items.map((item) {
                        String itemName = item['name'] ?? "Unknown Item";
                        int quantity = (item['quantity'] ?? 0).toInt();
                        double price = (item['price'] ?? 0).toDouble();

                        return ListTile(
                          leading: const Icon(Icons.shopping_cart),
                          title: Text(itemName),
                          subtitle: Text("Quantity: $quantity"),
                          trailing: Text("₹${price.toStringAsFixed(2)}"),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
