import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShopOwnerViewShopDetailsScreen extends StatelessWidget
{
  final String shopName;
  final String email;
  final String phoneNumber;
  final String? alternateNumber;
  final String? telephoneNumber;
  final String? gst;
  final String? description;
  final String address;

  ShopOwnerViewShopDetailsScreen({
    required this.shopName,
    required this.email,
    required this.phoneNumber,
    this.alternateNumber,
    this.telephoneNumber,
    this.gst,
    required this.address,
    this.description
  });

  @override
  Widget build(BuildContext context)
  {
    return AlertDialog(
      backgroundColor: Theme.of(context).cardColor,
      title: Text(
        "Shop Details",
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Shop Name: $shopName", style: TextStyle(color: Colors.black),),
            SizedBox(height: 8),
            Text("Email: $email", style: TextStyle(color: Colors.black),),
            SizedBox(height: 8),
            Text("Phone Number: $phoneNumber", style: TextStyle(color: Colors.black),),
            SizedBox(height: 8),
            Text("Alternate Number: ${alternateNumber ?? 'N/A'}", style: TextStyle(color: Colors.black),),
            SizedBox(height: 8),
            Text("Telephone Number: ${telephoneNumber ?? 'N/A'}", style: TextStyle(color: Colors.black),),
            SizedBox(height: 8),
            Text("GSTIN: ${gst ?? 'N/A'}", style: TextStyle(color: Colors.black),),
            SizedBox(height: 8),
            Text("Address: $address", style: TextStyle(color: Colors.black),),
            SizedBox(height: 8),
            Text("Description: ${description ?? 'N/A'}", style: TextStyle(color: Colors.black),),
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
