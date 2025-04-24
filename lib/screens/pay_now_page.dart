import 'package:dairy_delivery_3/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
// import 'home_screen.dart'

class PayNowPage extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;
  final String address;
  final String deliveryDate;
  final String deliveryTime;

  PayNowPage({
    required this.cartItems,
    required this.address,
    required this.deliveryDate,
    required this.deliveryTime,
  });

  // Calculate total order amount
  double calculateTotal() {
    return cartItems.fold(0.0, (total, item) {
      double price = (item["price"] as num).toDouble();
      double quantity = (item["quantity"] as num).toDouble();
      return total + (price * quantity);
    });
  }

  // Calculate total number of items
  double calculateTotalItems() {
    return cartItems.fold(0.0, (total, item) {
      double quantity = (item["quantity"] as num).toDouble();
      return total + quantity;
    });
  }

  // Function to save order in Firebase Firestore
  void saveOrder(BuildContext context) async {
    String orderId = Uuid().v4(); // Generate unique order ID
    String userId = FirebaseAuth.instance.currentUser!.uid; // Get current user ID
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    Map<String, dynamic> orderData = {
      "orderId": orderId,
      "userId": userId,
      "items": cartItems.map((item) => {
        "name": item["name"],
        "price": item["price"],
        "quantity": item["quantity"]
      }).toList(),
      "totalAmount": calculateTotal(),
      "totalItems": calculateTotalItems(),
      "address": address,
      "deliveryDate": deliveryDate,
      "deliveryTime": deliveryTime,
      "status": "Pending",
      "timestamp": FieldValue.serverTimestamp()
    };

    try {
      await firestore
          .collection("users")
          .doc(userId)
          .collection("orders")
          .doc(orderId)
          .set(orderData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Order Confirmed! 🎉"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
            (route) => false,
      );
      // Navigate back after order placement
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Order failed: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Confirm Order")),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  var item = cartItems[index];
                  double price = (item["price"] as num).toDouble();
                  double quantity = (item["quantity"] as num).toDouble();
                  double totalPrice = price * quantity;

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                    elevation: 3,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        child: Text(quantity.toStringAsFixed(1),
                            style: TextStyle(color: Colors.white, fontSize: 14)),
                      ),
                      title: Text(item["name"], style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        "₹${price.toStringAsFixed(2)} x ${quantity.toStringAsFixed(1)} = ₹${totalPrice.toStringAsFixed(2)}",
                      ),
                    ),
                  );
                },
              ),
            ),
            Divider(thickness: 2),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  Text(
                    "Total Items: ${calculateTotalItems().toStringAsFixed(1)}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Total Amount: ₹${calculateTotal().toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  SizedBox(height: 10),
                  Text("Address: $address", style: TextStyle(fontSize: 16)),
                  Text("Delivery Date: $deliveryDate", style: TextStyle(fontSize: 16)),
                  Text("Delivery Time: $deliveryTime", style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => saveOrder(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
              ),
              child: Text("Confirm Order", style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
