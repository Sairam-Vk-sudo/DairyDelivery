import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../widgets/subscription_box.dart';
import '../components/bottom_nav.dart';
import 'products_page.dart';
import 'login_screen.dart'; // Ensure this exists

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final PageController _pageController = PageController();
  
  String username = "Guest";
  bool hasSubscription = false;
  String subscriptionName = "";

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  /// Fetch user details including username and subscription details
  Future<void> _fetchUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await FirebaseFirestore.instance.collection("users").doc(user.uid).get();

      if (userDoc.exists && mounted) {  
        setState(() {
          username = userDoc.data()?["name"] ?? "Customer";
          hasSubscription = userDoc.data()?["hasSubscription"] ?? false;
          subscriptionName = userDoc.data()?["subscriptionName"] ?? "";
        });
      }
    }
  }

  /// Logout function
  void _logout() async {
    await _auth.signOut();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()), // Ensure LoginScreen exists
      );
    }
  }

  /// Open the subscription selection dialog
  void _handleSubscriptionUpdate() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String selectedPackage = "Package 1 (Monthly Milk)";
        DateTime? selectedDate;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Choose Subscription Plan"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    value: selectedPackage,
                    items: [
                      "Package 1 (Monthly Milk)",
                      "Package 2 (Quarterly Milk)",
                      "Package 3 (Annual Milk)"
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedPackage = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() {
                          selectedDate = picked;
                        });
                      }
                    },
                    child: Text(selectedDate == null
                        ? "Select Start Date"
                        : "Selected Date: ${selectedDate!.toLocal()}".split(' ')[0]),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    User? user = _auth.currentUser;
                    if (user != null) {
                      await FirebaseFirestore.instance.collection("users").doc(user.uid).update({
                        "hasSubscription": true,
                        "subscriptionName": selectedPackage,
                      });
                      setState(() {
                        hasSubscription = true;
                        subscriptionName = selectedPackage;
                      });
                    }
                    Navigator.pop(context);
                  },
                  child: const Text("Confirm"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Customer Home",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: "Logout",
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildWelcomeCard(),
            const SizedBox(height: 20),
            SubscriptionBox(
              hasActiveSubscription: hasSubscription,
              subscriptionName: subscriptionName,
              onEditAdd: _handleSubscriptionUpdate,
            ),
            const SizedBox(height: 20),
            _buildMarqueeSlider(),
            const SizedBox(height: 20),
            _buildSectionTitle("Offers"),
            _buildOffers(),
            const SizedBox(height: 20),
            _buildSectionTitle("Our Products"),
            _buildProducts(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProductsPage()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: "Products"),
        ],
      ),
    );
  }

  /// Build welcome card
  Widget _buildWelcomeCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundColor: Colors.blue,
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "Welcome, $username",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: _handleSubscriptionUpdate,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: const Text("Edit/Add"),
          ),
        ],
      ),
    );
  }

  /// Build Marquee Slider
  Widget _buildMarqueeSlider() {
    return Column(
      children: [
        SizedBox(
          height: 120,
          child: PageView(
            controller: _pageController,
            children: List.generate(
              3,
              (index) => _buildMarqueeItem("assets/images/test.jpg"),
            ),
          ),
        ),
        const SizedBox(height: 8),
        SmoothPageIndicator(
          controller: _pageController,
          count: 3,
          effect: const WormEffect(
            dotHeight: 8,
            dotWidth: 8,
            activeDotColor: Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildMarqueeItem(String imagePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width * 0.8,
        ),
      ),
    );
  }

  Widget _buildOffers() => _buildMarqueeSlider();

  Widget _buildProducts() {
    return ElevatedButton(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProductsPage()),
      ),
      child: const Text("View Products"),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
      child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
    );
  }
}
