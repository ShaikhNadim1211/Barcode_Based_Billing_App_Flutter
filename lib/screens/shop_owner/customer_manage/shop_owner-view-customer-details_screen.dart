import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShopOwnerViewCustomerDetailsScreen extends StatelessWidget
{
  final String customerId;
  final String customerName;
  final String email;
  final String? phoneNumber;
  final String address;
  final String addedBy;
  final String updatedBy;

  ShopOwnerViewCustomerDetailsScreen({
    required this.customerId,
    required this.customerName,
    required this.email,
    this.phoneNumber,
    required this.address,
    required this.addedBy,
    required this.updatedBy
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
            Text("Added By: $addedBy", style: TextStyle(color: Colors.black),),
            SizedBox(height: 8),
            Text("Updated By: $updatedBy", style: TextStyle(color: Colors.black),),
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
