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

  List<Map<String, dynamic>> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _filteredProducts = List.from(products);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      if (query.isEmpty) {
        _filteredProducts = List.from(products);
      } else {
        _filteredProducts = products.where((product) {
          final name = product["name"].toString().toLowerCase();
          return name.contains(query);
        }).toList();
      }
    });
  }

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
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                String input = quantityController.text;
                double? quantity = double.tryParse(input);

                if (quantity != null && quantity > 0) {
                  setState(() {
                    products[index]["quantity"] = quantity.toString();
                  });
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please enter a valid quantity greater than 0")),
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

  // Counts number of distinct items in cart
  int getTotalCartItems() {
    return cartItems.length;
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
        padding: EdgeInsets.only(bottom: cartItems.isNotEmpty ? 60 : 0),
        child: GridView.builder(
          itemCount: _filteredProducts.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.8,
          ),
          itemBuilder: (context, index) {
            final product = _filteredProducts[index];
            // Find the index in original products list for quantity dialog
            final indexInOriginal = products.indexWhere((p) => p["name"] == product["name"]);

            return Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Image.asset(
                      product["image"],
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Text(product["name"], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text("₹${product["price"]} ${product["unit"]}", style: TextStyle(color: Colors.grey)),
                        SizedBox(height: 5),
                        ElevatedButton(
                          onPressed: () => _showQuantityDialog(indexInOriginal),
                          child: Text(product["quantity"]),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            addToCart(product);
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
      bottomNavigationBar: cartItems.isNotEmpty
          ? Container(
        color: Colors.blueAccent,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Items in Cart: ${getTotalCartItems()}",
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
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
          : null,
    );
  }
}
