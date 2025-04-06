import 'package:barcode_based_billing_system/screens/shop_worker/scan_bill/shop_worker_scan_bill_checkout_screen.dart';
import 'package:barcode_based_billing_system/screens/shop_worker/scan_bill/shop_worker_scan_bill_customer_add_screen.dart';
import 'package:barcode_based_billing_system/widgets/custom_input_field_widget.dart';
import 'package:barcode_based_billing_system/widgets/custom_toast_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShopWorkerScanBillCustomerSelectScreen extends StatefulWidget
{
  final String ownerId;
  final String shopId;
  final String workerId;
  final Map<String, int> barcodeNumberAndQuantity;
  final Map<String, Map<String, dynamic>> productDetails;

  ShopWorkerScanBillCustomerSelectScreen(this.ownerId, this.shopId, this.barcodeNumberAndQuantity, this.productDetails, this.workerId);
  @override
  State<StatefulWidget> createState()
  {
    return ShopWorkerScanBillCustomerSelectScreenState();
  }
}

class ShopWorkerScanBillCustomerSelectScreenState extends State<ShopWorkerScanBillCustomerSelectScreen>
{
  CustomInputFieldWidget inputFieldWidget = CustomInputFieldWidget();
  CustomToastWidget toastWidget = CustomToastWidget();

  late Stream<QuerySnapshot> customerStream;

  TextEditingController search = TextEditingController();
  String searchQuery = "";

  String ownerId = "";
  String shopId = "";
  String workerId = "";
  Map<String, int> barcodeNumberAndQuantity = {};
  Map<String, Map<String, dynamic>> productDetails = {};

  Future<void> _fetchCustomer() async
  {
    print(widget.ownerId);
    print(widget.shopId);
    if (widget.ownerId.isNotEmpty)
    {
      setState(() {
        this.customerStream = FirebaseFirestore.instance
            .collection('customer')
            .where('ownerid', isEqualTo: widget.ownerId)
            .where("shopid", isEqualTo: widget.shopId)
            .snapshots();
      });
    }
  }

  @override
  void initState()
  {
    super.initState();
    this.ownerId = widget.ownerId;
    this.shopId = widget.shopId;
    this.workerId = widget.workerId;
    this.barcodeNumberAndQuantity = widget.barcodeNumberAndQuantity;
    this.productDetails = widget.productDetails;
    _fetchCustomer();
  }
  @override
  Widget build(BuildContext context)
  {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Customer Detail",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
          ),
        ),

        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              //Search Bar
              Padding(
                padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0),
                child: inputFieldWidget.SearchInputFieldWithOnChange(
                  context,
                  search,
                  "Search",
                  Icon(Icons.search),
                  TextInputType.text,
                      (value) {
                    setState(() {
                      this.searchQuery = value;
                    });
                  },
                  50,
                ),
              ),
              SizedBox(height: 10),

              //List of Customer
              if(this.ownerId.isNotEmpty && this.shopId.isNotEmpty)
                StreamBuilder<QuerySnapshot>(
                  stream: customerStream,
                  builder: (context, snapshot) {

                    if (snapshot.connectionState == ConnectionState.waiting)
                    {
                      return Center(
                          child: CircularProgressIndicator(color: Theme.of(context).cardColor,)
                      );
                    }
                    else if (snapshot.hasError)
                    {
                      return Center(
                        child: Text(
                          "Error: ${snapshot.error}",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.height * 0.04,
                          ),
                        ),
                      );
                    }
                    else if (snapshot.hasData)
                    {
                      var customers = snapshot.data!.docs;

                      // Filter the shops based on search query
                      var filteredCustomers = customers.where((customer) {
                        String cName = customer['customername'];
                        String cId = customer['customerid'];
                        String cAddress = customer['address'];
                        String cEmail = customer["email"];
                        return (cName.toLowerCase().contains(searchQuery.toLowerCase()) ||
                            cId.toLowerCase().contains(searchQuery.toLowerCase()) ||
                            cAddress.toLowerCase().contains(searchQuery.toLowerCase()) ||
                            cEmail.toLowerCase().contains(searchQuery.toLowerCase()));
                      }).toList();

                      if (filteredCustomers.isEmpty)
                      {
                        return Center(
                          child: Text(
                            "No customers found",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: MediaQuery.of(context).size.height * 0.04,
                            ),
                          ),
                        );
                      }
                      else
                      {
                        return ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: filteredCustomers.length,
                          itemBuilder: (context, index) {

                            var customer = filteredCustomers[index];
                            String ownerId = customer["ownerid"];
                            String shopId = customer["shopid"];
                            String customerId = customer["customerid"];
                            String customerName = customer["customername"];
                            String email = customer["email"];
                            String phoneNumber = customer["phonenumber"];
                            String address = customer["address"];

                            return Card(
                              color: Theme.of(context).cardColor,
                              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                              child: ListTile(
                                title: Text(
                                  customerName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: MediaQuery.of(context).size.height * 0.025,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Customer ID: $customerId",style: TextStyle(color: Colors.black),),
                                    Text("Address: $address",style: TextStyle(color: Colors.black),),
                                    Text("Email: $email",style: TextStyle(color: Colors.black),),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.check),
                                      onPressed: (){
                                        print(customerName);

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => ShopWorkerScanBillCheckoutScreen(widget.ownerId, widget.shopId, widget.barcodeNumberAndQuantity, widget.productDetails, customerId, email, widget.workerId)
                                            )
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                    } else
                    {
                      return Center(
                        child: Text(
                          "No customers found",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.height * 0.04,
                          ),
                        ),
                      );
                    }
                  },
                ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {

            if(this.ownerId.isNotEmpty && this.shopId.isNotEmpty)
            {
              //Navigate
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ShopWorkerScanBillCustomerAddScreen(this.ownerId, this.shopId, this.workerId)
                ),
              );
            }
            else
            {
              await Future.delayed(Duration(milliseconds: 300));
              toastWidget.showToast("Invalid Credential");
            }
          },
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(Icons.add, color: Colors.black, size: 40),
        ),
      ),
    );
  }
}