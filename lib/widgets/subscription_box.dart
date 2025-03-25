import 'package:flutter/material.dart';

class SubscriptionBox extends StatelessWidget {
  final bool hasActiveSubscription;
  final String subscriptionName;
  final VoidCallback onEditAdd;

  const SubscriptionBox({
    super.key,
    required this.hasActiveSubscription,
    required this.subscriptionName,
    required this.onEditAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hasActiveSubscription ? "Active Subscription" : "No Active Subscription",
                style: TextStyle(
                  color: hasActiveSubscription ? Colors.green : Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subscriptionName.isNotEmpty ? subscriptionName : "<Subscription>",
                style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              ),
            ],
          ),
          TextButton(
            onPressed: onEditAdd,
            style: TextButton.styleFrom(foregroundColor: Colors.blue),
            child: Text(hasActiveSubscription ? "Edit" : "Add"),
          ),
        ],
      ),
    );
  }
}
