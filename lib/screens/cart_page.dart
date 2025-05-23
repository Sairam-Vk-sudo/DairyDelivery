import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'pay_now_page.dart';

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;

  CartPage({required this.cartItems});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late List<Map<String, dynamic>> _localCartItems;
  TextEditingController _addressController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  List<TimeOfDay> availableTimeSlots = [];

  @override
  void initState() {
    super.initState();
    _localCartItems = List<Map<String, dynamic>>.from(widget.cartItems);
  }

  void removeFromCart(int index) {
    setState(() {
      _localCartItems.removeAt(index);
    });
  }

  double calculateTotal() {
    return _localCartItems.fold(0.0, (total, item) {
      double price = (item["price"] as num).toDouble();
      double quantity = (item["quantity"] as num).toDouble();
      return total + (price * quantity);
    });
  }

  double calculateTotalItems() {
    return _localCartItems.fold(0.0, (total, item) {
      double quantity = (item["quantity"] as num).toDouble();
      return total + quantity;
    });
  }

  void _pickDate() async {
    DateTime now = DateTime.now();
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(Duration(days: 7)),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _selectedTime = null;
        _generateAvailableTimeSlots();
      });
    }
  }

  void _generateAvailableTimeSlots() {
    availableTimeSlots.clear();
    for (int hour = 6; hour < 22; hour++) {
      availableTimeSlots.add(TimeOfDay(hour: hour, minute: 0));
      availableTimeSlots.add(TimeOfDay(hour: hour, minute: 30));
    }
  }

  void _pickTime() async {
    if (availableTimeSlots.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a delivery date first")),
      );
      return;
    }

    TimeOfDay? picked = await showDialog<TimeOfDay>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text("Select Delivery Time"),
          children: availableTimeSlots
              .map((time) => SimpleDialogOption(
            child: Text(time.format(context)),
            onPressed: () => Navigator.pop(context, time),
          ))
              .toList(),
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _proceedToPay() {
    if (_addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter a delivery address")));
      return;
    }
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please select a delivery date")));
      return;
    }
    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please select a delivery time slot")));
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PayNowPage(
          cartItems: _localCartItems,
          address: _addressController.text,
          deliveryDate: DateFormat('yyyy-MM-dd').format(_selectedDate!),
          deliveryTime: _selectedTime!.format(context),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cart")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _localCartItems.length,
                  itemBuilder: (context, index) {
                    var item = _localCartItems[index];
                    double price = (item["price"] as num).toDouble();
                    double quantity = (item["quantity"] as num).toDouble();
                    double totalPrice = price * quantity;

                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      elevation: 3,
                      child: ListTile(
                        leading: Image.asset(item["image"], width: 50, height: 50),
                        title: Text(item["name"], style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("₹${price.toStringAsFixed(2)} x ${quantity.toStringAsFixed(1)} = ₹${totalPrice.toStringAsFixed(2)}"),
                        trailing: IconButton(
                          icon: Icon(Icons.remove_circle, color: Colors.red),
                          onPressed: () => removeFromCart(index),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Divider(thickness: 2),
              Card(
                margin: EdgeInsets.symmetric(vertical: 10),
                elevation: 3,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _addressController,
                        decoration: InputDecoration(
                          labelText: "Delivery Address",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.location_on),
                        ),
                      ),
                      SizedBox(height: 15),
                      ListTile(
                        leading: Icon(Icons.calendar_today, color: Colors.blue),
                        title: Text(
                          _selectedDate == null
                              ? "Select Delivery Date"
                              : "Delivery Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}",
                        ),
                        trailing: Icon(Icons.arrow_forward_ios, size: 18),
                        onTap: _pickDate,
                      ),
                      ListTile(
                        leading: Icon(Icons.access_time, color: Colors.blue),
                        title: Text(
                          _selectedTime == null
                              ? "Select Delivery Time"
                              : "Delivery Time: ${_selectedTime!.format(context)}",
                        ),
                        trailing: Icon(Icons.arrow_forward_ios, size: 18),
                        onTap: _pickTime,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Column(
                  children: [
                    Text(
                      "Total: ₹${calculateTotal().toStringAsFixed(2)}",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: _proceedToPay,
                      icon: Icon(Icons.payment),
                      label: Text("Proceed to Pay", style: TextStyle(fontSize: 18)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
