import 'package:flutter/material.dart';
import 'cart_page.dart';

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> cartItems = [];

  final List<Map<String, dynamic>> products = [
    {"name": "Fresh Milk", "image": "assets/images/milk.webp", "price": 50, "unit": "/L", "quantity": "Select"},
    {"name": "Cheddar Cheese", "image": "assets/images/cheese.webp", "price": 300, "unit": "/kg", "quantity": "Select"},
    {"name": "Organic Butter", "image": "assets/images/butter.webp", "price": 250, "unit": "/kg", "quantity": "Select"},
    {"name": "Greek Yogurt", "image": "assets/images/yogurt.webp", "price": 200, "unit": "/kg", "quantity": "Select"},
    {"name": "Homemade Paneer", "image": "assets/images/paneer.webp", "price": 400, "unit": "/kg", "quantity": "Select"},
  ];

  void _showQuantityDialog(int index) {
    TextEditingController quantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Enter Quantity"),
          content: TextField(
            controller: quantityController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              hintText: "e.g., 1, 2.5, 3.75",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close dialog
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                String input = quantityController.text;
                if (RegExp(r'^\d*\.?\d*$').hasMatch(input) && input.isNotEmpty) {
                  setState(() {
                    products[index]["quantity"] = input;
                  });
                  Navigator.pop(context); // Close dialog
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please enter a valid quantity")),
                  );
                }
              },
              child: Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  void addToCart(Map<String, dynamic> product) {
    if (product["quantity"] == "Select") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a quantity before adding to cart")),
      );
      return;
    }

    double quantity = double.tryParse(product["quantity"]) ?? 0;
    if (quantity > 0) {
      setState(() {
        cartItems.add({...product, "quantity": quantity});
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Enter a valid quantity")),
      );
    }
  }

  int getTotalCartItems() {
    return cartItems.fold(0, (total, item) => total + (item["quantity"] as num).toInt());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: "Search products...",
            border: InputBorder.none,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage(cartItems: cartItems)),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(bottom: cartItems.isNotEmpty ? 60 : 0),  // Prevents overlap with bottom bar
        child: GridView.builder(
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.8,
          ),
          itemBuilder: (context, index) {
            return Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Image.asset(
                      products[index]["image"],
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Text(products[index]["name"], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text("₹${products[index]["price"]} ${products[index]["unit"]}", style: TextStyle(color: Colors.grey)),
                        SizedBox(height: 5),

                        // Select Quantity Button
                        ElevatedButton(
                          onPressed: () => _showQuantityDialog(index),
                          child: Text(products[index]["quantity"]),
                        ),

                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            addToCart(products[index]);
                          },
                          child: Text("Add to Cart"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),

      /// **Bottom Cart Section**
      bottomNavigationBar: cartItems.isNotEmpty
          ? Container(
        color: Colors.blueAccent,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// **Cart Summary**
            Text(
              "Items in Cart: ${getTotalCartItems()}",
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),

            /// **Go to Cart Button**
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartPage(cartItems: cartItems)),
                );
              },
              icon: Icon(Icons.shopping_cart),
              label: Text("Go to Cart"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blueAccent,
              ),
            ),
          ],
        ),
      )
          : null, // Hide bottom bar if cart is empty
    );
  }
}
