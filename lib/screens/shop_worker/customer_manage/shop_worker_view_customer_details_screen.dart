import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShopWorkerViewCustomerDetailsScreen extends StatelessWidget
{
  final String customerId;
  final String customerName;
  final String email;
  final String? phoneNumber;
  final String address;

  ShopWorkerViewCustomerDetailsScreen({
    required this.customerId,
    required this.customerName,
    required this.email,
    this.phoneNumber,
    required this.address,
  });
  @override
  Widget build(BuildContext context)
  {
    return AlertDialog(
      backgroundColor: Theme.of(context).cardColor,
      title: Text(
        "Customer Details",
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Customer ID: $customerId", style: TextStyle(color: Colors.black),),
            SizedBox(height: 8),
            Text("Customer Name: $customerName", style: TextStyle(color: Colors.black),),
            SizedBox(height: 8),
            Text("Email: $email", style: TextStyle(color: Colors.black),),
            SizedBox(height: 8),
            Text("Phone Number: ${phoneNumber ?? 'N/A'}", style: TextStyle(color: Colors.black),),
            SizedBox(height: 8),
            Text("Address: $address", style: TextStyle(color: Colors.black),),
            SizedBox(height: 8),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Close", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),),
        ),
      ],
    );
  }
}