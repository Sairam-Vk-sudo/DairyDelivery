import 'package:flutter/material.dart';

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

  double calculateTotal() {
    return cartItems.fold(0, (total, item) {
      double price = (item["price"] ?? 0).toDouble();
      int quantity = (item["quantity"] ?? 1).toInt();
      return total + (price * quantity);
    });
  }

  int calculateTotalItems() {
    return cartItems.fold(0, (total, item) => total + ((item["quantity"] ?? 1) as int));
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

                  double price = (item["price"] ?? 0).toDouble();
                  int quantity = (item["quantity"] ?? 1).toInt();
                  double totalPrice = price * quantity;

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                    elevation: 3,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        child: Text(quantity.toString(), style: TextStyle(color: Colors.white)),
                      ),
                      title: Text(item["name"], style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("₹${price.toStringAsFixed(2)} x $quantity = ₹${totalPrice.toStringAsFixed(2)}"),
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
                  Text("Total Items: ${calculateTotalItems()}",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  SizedBox(height: 5),
                  Text("Total Amount: ₹${calculateTotal().toStringAsFixed(2)}",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green)),
                  SizedBox(height: 10),
                  Text("Address: $address", style: TextStyle(fontSize: 16)),
                  Text("Delivery Date: $deliveryDate", style: TextStyle(fontSize: 16)),
                  Text("Delivery Time: $deliveryTime", style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Order Confirmed!"),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context);
              },
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
