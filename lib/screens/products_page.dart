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
    {"name": "Fresh Milk", "image": "assets/images/test.jpg", "price": 50, "unit": "/L", "quantity": "Select"},
    {"name": "Cheddar Cheese", "image": "assets/images/test.jpg", "price": 300, "unit": "/kg", "quantity": "Select"},
    {"name": "Organic Butter", "image": "assets/images/test.jpg", "price": 250, "unit": "/kg", "quantity": "Select"},
    {"name": "Greek Yogurt", "image": "assets/images/test.jpg", "price": 200, "unit": "/kg", "quantity": "Select"},
    {"name": "Homemade Paneer", "image": "assets/images/test.jpg", "price": 400, "unit": "/kg", "quantity": "Select"},
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
        padding: EdgeInsets.all(10),
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
    );
  }
}
