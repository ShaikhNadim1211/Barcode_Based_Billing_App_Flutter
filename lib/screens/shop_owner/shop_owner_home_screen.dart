import 'package:barcode_based_billing_system/screens/common/login_screen.dart';
import 'package:barcode_based_billing_system/screens/shop_owner/bill_manage/shop_owner_manage_bill_screen.dart';
import 'package:barcode_based_billing_system/screens/shop_owner/customer_insights/shop_owner_customer_insights_manage_screen.dart';
import 'package:barcode_based_billing_system/screens/shop_owner/customer_manage/shop_owner_manage_customer_screen.dart';
import 'package:barcode_based_billing_system/screens/shop_owner/inventory_manage/shop_owner_inventory_manage_screen.dart';
import 'package:barcode_based_billing_system/screens/shop_owner/product_manage/shop_owner_manage_product_screen.dart';
import 'package:barcode_based_billing_system/screens/shop_owner/profile_manage/shop_owner_profile_manage_screen.dart';
import 'package:barcode_based_billing_system/screens/shop_owner/sales_insights/shop_owner_sales_insights_manage_screen.dart';
import 'package:barcode_based_billing_system/screens/shop_owner/scan_bill/shop_owner_barcode_scan_screen.dart';
import 'package:barcode_based_billing_system/screens/shop_owner/shop_manage/shop_owner_manage_shop_screen.dart';
import 'package:barcode_based_billing_system/screens/shop_owner/worker_manage/shop_owner_manage_worker_screen.dart';
import 'package:barcode_based_billing_system/widgets/custom_toast_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../methods/random_quote_generate.dart';

class ShopOwnerHomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ShopOwnerHomeScreenState();
  }
}

class ShopOwnerHomeScreenState extends State {
  String quote = "Fetching an inspirational quote...";
  String author = "";


  final RandomQuoteGenerate randomQuoteGenerator = RandomQuoteGenerate();
  CustomToastWidget toastWidget = CustomToastWidget();

  final List<Map<String, String>> ownerItems = [
    {'title': 'Shop', 'icon': 'store'},
    {'title': 'Worker', 'icon': 'person'},
    {'title': 'Product', 'icon': 'add_box'},
    {'title': 'Inventory', 'icon': 'inventory'},
    {'title': 'Customer', 'icon': 'people'},
    {'title': 'Bill', 'icon': 'receipt'},
    {'title': 'Sales Insights', 'icon': 'analytics'},
    {'title': 'Customer Sales Insights', 'icon': 'analytics'}
  ];

  @override
  void initState() {
    super.initState();
    fetchQuote();
  }

  Future<void> fetchQuote() async {
    final fetchedQuote = await randomQuoteGenerator.getQuote();
    setState(() {
      quote = fetchedQuote['quote'] ?? "An error occurred. Try again.";
      author = fetchedQuote['author'] ?? "Unknown";
    });
  }

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'store':
        return Icons.store;
      case 'person':
        return Icons.person_add;
      case 'add_box':
        return Icons.add_box;
      case 'inventory':
        return Icons.inventory;
      case 'people':
        return Icons.people;
      case 'receipt':
        return Icons.receipt;
      case 'analytics':
        return Icons.analytics;
      default:
        return Icons.help;
    }
  }

  void _handleNavigation(BuildContext context, String title) async{
    switch (title) {
      case 'Shop':
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ShopOwnerManageShopScreen()));
        break;
      case 'Worker':
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context)=>ShopOwnerManageWorkerScreen()
            )
        );
        break;
      case 'Product':
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context)=>ShopOwnerManageProductScreen()
            )
        );
        break;
      case 'Inventory':
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context)=>ShopOwnerInventoryManageScreen()
            )
        );
        break;
      case 'Customer':
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context)=>ShopOwnerManageCustomerScreen()
            )
        );
        break;
      case 'Bill':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context)=>ShopOwnerManageBillScreen()
          ),
        );
        break;
      case 'Sales Insights':
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context)=>ShopOwnerSalesInsightsManageScreen()
            )
        );
        break;
      case 'Customer Sales Insights':
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context)=>ShopOwnerCustomerInsightsManageScreen()
            )
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "Dashboard",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.person_pin_outlined,
                color: Colors.black,
              ),
              onPressed: (){
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context)=>ShopOwnerProfileManageScreen()
                    )
                );
              },
            ),
            //Logout
            IconButton(
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();

                  prefs.setBool("logIn", false);
                  prefs.setBool("ownerLogIn", false);
                  prefs.setBool("workerLogIn", false);
                  prefs.remove("username");
                  prefs.clear();

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                icon: Icon(
                  Icons.logout,
                  color: Colors.black,
                )
            ),
          ],
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Quote
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.25,
                  decoration: BoxDecoration(
                    color: Color(0xFFC8EFD1),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: Offset(0, 4),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '"$quote"',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.025,
                          fontStyle: FontStyle.italic,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '- $author',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.02,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              //GridView
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Two columns
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: ownerItems.length,
                  itemBuilder: (context, index) {
                    final item = ownerItems[index];
                    return GestureDetector(
                      onTap: () {
                        // Handle navigation based on the title
                        _handleNavigation(context, item['title']!);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 5,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _getIcon(item['icon']!),
                              size: 40,
                              color: const Color(0xFFA2E9C1),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              item['title']!,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () async
          {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ShopOwnerBarcodeScanScreen(),
              ),
            );
          },
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(
              Icons.qr_code_scanner,
              color: Colors.black,
              size: 30
          ),
        ),
      ),
    );
  }
}
