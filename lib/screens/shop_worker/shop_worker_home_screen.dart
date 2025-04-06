import 'package:barcode_based_billing_system/methods/random_quote_generate.dart';
import 'package:barcode_based_billing_system/screens/common/login_screen.dart';
import 'package:barcode_based_billing_system/screens/shop_worker/bill_manage/shop_worker_manage_bill_screen.dart';
import 'package:barcode_based_billing_system/screens/shop_worker/customer_manage/shop_worker_manage_customer_screen.dart';
import 'package:barcode_based_billing_system/screens/shop_worker/inventory_manage/shop_worker_inventory_manage_screen.dart';
import 'package:barcode_based_billing_system/screens/shop_worker/product_manage/shop_worker_manage_product_screen.dart';
import 'package:barcode_based_billing_system/screens/shop_worker/scan_bill/shop_worker_barcode_scan_screen.dart';
import 'package:barcode_based_billing_system/widgets/custom_toast_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopWorkerHomeScreen extends StatefulWidget
{
  @override
  State<StatefulWidget> createState()
  {
    return ShopWorkerHomeScreenState();
  }
}

class ShopWorkerHomeScreenState extends State
{
  String quote = "Fetching an inspirational quote...";
  String author = "";

  final RandomQuoteGenerate randomQuoteGenerator = RandomQuoteGenerate();
  CustomToastWidget toastWidget = CustomToastWidget();

  final List<Map<String, String>> workerItems = [
    {'key': 'Product', 'title': 'Product', 'icon': 'add_box'},
    {'key': 'Inventory', 'title': 'Inventory', 'icon': 'inventory'},
    {'key': 'Customer', 'title': 'Customer', 'icon': 'people'},
    {'key': 'Scan Bill', 'title': 'Scan Bill', 'icon': 'qr_code_scanner'},
    {'key': 'Bill', 'title': 'Bill', 'icon': 'receipt'},
  ];

  late Stream<QuerySnapshot> workerStream;

  Future<void> _fetchWorker() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ownerId = prefs.getString('ownerId') ?? '';
    String shopId = prefs.getString('shopId') ?? '';
    String workerId = prefs.getString('workerId') ?? '';

    if (ownerId.isNotEmpty && shopId.isNotEmpty && workerId.isNotEmpty)
    {
      setState(() {
        this.workerStream = FirebaseFirestore.instance
            .collection('worker')
            .where('ownerid', isEqualTo: ownerId)
            .where("shopid", isEqualTo: shopId)
            .where("workerid", isEqualTo: workerId)
            .snapshots();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchQuote();
    _fetchWorker();
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
      case 'add_box':
        return Icons.add_box;
      case 'inventory':
        return Icons.inventory;
      case 'people':
        return Icons.people;
      case 'receipt':
        return Icons.receipt;
      case 'qr_code_scanner':
        return Icons.qr_code_scanner;
      default:
        return Icons.help;
    }
  }

  void _handleNavigation(BuildContext context, String title) async{
    switch (title) {
      case 'Product':
        //Navigate to product
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context)=>ShopWorkerManageProductScreen()
            )
        );
        break;
      case 'Inventory':
      //Navigate to Inventory
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context)=>ShopWorkerInventoryManageScreen()
            )
        );
        break;
      case 'Customer':
      //Navigate to customer
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context)=>ShopWorkerManageCustomerScreen()
            )
        );
        break;
      case 'Bill':
      //Navigate to bill
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context)=>ShopWorkerManageBillScreen()
            )
        );
        break;
      case 'Scan Bill':
        //Navigate to Scan bill
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context)=>ShopWorkerBarcodeScanScreen()
            )
        );
        break;
    }
  }
  @override
  Widget build(BuildContext context)
  {
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
                onPressed: () async {
                  try
                  {
                    SharedPreferences prefs = await SharedPreferences.getInstance();

                    String ownerId = prefs.getString("ownerId") ?? "";
                    String shopId = prefs.getString("shopId") ?? "";
                    String workerId = prefs.getString("workerId") ?? "";

                    if(ownerId.isNotEmpty && shopId.isNotEmpty && workerId.isNotEmpty)
                    {
                      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("worker")
                          .where("ownerid",isEqualTo: ownerId)
                          .where("shopid",isEqualTo: shopId)
                          .where("workerid", isEqualTo: workerId)
                          .get();
                      if(snapshot.docs.isNotEmpty)
                      {
                        Map<String, dynamic> data = {
                          "loggedin" : "0"
                        };
                        var document = snapshot.docs.first.reference;
                        await document.update(data);

                        prefs.setBool("logIn", false);
                        prefs.setBool("ownerLogIn", false);
                        prefs.setBool("workerLogIn", false);
                        prefs.clear();

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      }
                      else
                      {
                        await Future.delayed(Duration(milliseconds: 300));
                        toastWidget.showToast("Try again");
                      }
                    }
                    else
                    {
                      await Future.delayed(Duration(milliseconds: 300));
                      toastWidget.showToast("Try again");
                    }
                  }
                  catch(e)
                  {
                    await Future.delayed(Duration(milliseconds: 300));
                    toastWidget.showToast("Try again");
                  }
                },
                icon: Icon(
                  Icons.logout,
                  color: Colors.black,
                )),
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

              workerStream == null
                  ? Center(child: CircularProgressIndicator())
                  : StreamBuilder<QuerySnapshot>(
                  stream: workerStream,
                  builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                  {
                    return Center(
                        child: CircularProgressIndicator()
                    );
                  }
                  else if (snapshot.hasError)
                  {
                    return Center(
                        child: Text(
                          'Error fetching data',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: MediaQuery.of(context).size.height * 0.04,
                            fontWeight: FontWeight.bold
                          ),
                        )
                    );
                  }
                  else if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
                  {
                    return Center(
                        child: Text(
                          'No permissions found',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: MediaQuery.of(context).size.height * 0.04,
                              fontWeight: FontWeight.bold
                          ),
                        )
                    );
                  }
                  else if(snapshot.hasData)
                  {
                    var workerData = snapshot.data!.docs.first.data() as Map<String, dynamic>;
                    Map<String, List<String>> accessField = {};

                    if (workerData['accessField'] != null)
                    {
                      var data = workerData["accessField"] as Map<String, dynamic>;
                      data.forEach((key, value) {
                        accessField[key] = List<String>.from(value);
                      });
                    }

                    var filteredItems = workerItems.where((item) {
                      final key = item['key'];
                      return key != null && accessField.containsKey(key);
                    }).toList();

                    if (filteredItems.isEmpty) {
                      return Center(
                        child: Text(
                          'No permissions found',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: MediaQuery.of(context).size.height * 0.04,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: filteredItems.length,
                        itemBuilder: (context, index) {
                          final item = filteredItems[index];
                          return GestureDetector(
                            onTap: () {
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
                    );
                  }
                  else
                  {
                    return Center(
                        child: Text(
                          'No permissions found',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: MediaQuery.of(context).size.height * 0.04,
                              fontWeight: FontWeight.bold
                          ),
                        )
                    );
                  }

                },
              ),
            ],
          ),
        ),

      ),
    );
  }

}