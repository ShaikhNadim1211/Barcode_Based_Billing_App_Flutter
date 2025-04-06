import 'package:barcode_based_billing_system/screens/shop_worker/customer_manage/shop_worker_add_customer_screen.dart';
import 'package:barcode_based_billing_system/screens/shop_worker/customer_manage/shop_worker_update_customer_screen.dart';
import 'package:barcode_based_billing_system/screens/shop_worker/customer_manage/shop_worker_view_customer_details_screen.dart';
import 'package:barcode_based_billing_system/screens/shop_worker/shop_worker_home_screen.dart';
import 'package:barcode_based_billing_system/widgets/custom_input_field_widget.dart';
import 'package:barcode_based_billing_system/widgets/custom_toast_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopWorkerManageCustomerScreen extends StatefulWidget
{
  @override
  State<StatefulWidget> createState()
  {
    return ShopWorkerManageCustomerScreenState();
  }
}

class ShopWorkerManageCustomerScreenState extends State<ShopWorkerManageCustomerScreen>
{
  CustomInputFieldWidget inputFieldWidget = CustomInputFieldWidget();
  CustomToastWidget toastWidget = CustomToastWidget();

  late Stream<QuerySnapshot> customerStream;

  TextEditingController search = TextEditingController();
  String searchQuery = "";

  String ownerId = "";
  String shopId = "";
  String workerId = "";
  List<String> customerAccess = [];

  Future<void> _fetchCustomer() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ownerId = prefs.getString('ownerId') ?? '';
    String shopId = prefs.getString('shopId') ?? '';
    String workerId = prefs.getString('workerId') ?? '';
    List<String> customer = prefs.getStringList("Customer") ?? [];

    if (ownerId.isNotEmpty && shopId.isNotEmpty && workerId.isNotEmpty && customer.isNotEmpty)
    {
      setState(() {
        this.customerStream = FirebaseFirestore.instance
            .collection('customer')
            .where('ownerid', isEqualTo: ownerId)
            .where('shopid', isEqualTo: shopId)
            .snapshots();
        this.ownerId = ownerId;
        this.shopId = shopId;
        this.workerId = workerId;
        this.customerAccess = customer;
      });
    }
  }
  
  @override
  void initState()
  {
    super.initState();
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
            "Customer",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => ShopWorkerHomeScreen()));
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
                      String cEmail = customer["email"];
                      return (cName.toLowerCase().contains(searchQuery.toLowerCase()) ||
                          cId.toLowerCase().contains(searchQuery.toLowerCase()) ||
                          cEmail.toLowerCase().contains(searchQuery.toLowerCase())
                        );
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
                          String addedBy = customer["addedby"];
                          String updatedBy = customer["updatedby"] ?? "";

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
                                  Text("Email: $email",style: TextStyle(color: Colors.black),),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if(this.customerAccess.contains("View Customer")) IconButton(
                                    icon: Icon(Icons.remove_red_eye_outlined),
                                    onPressed: (){
                                      print(customerName);

                                      showDialog(
                                        context: context,
                                        builder: (context) => ShopWorkerViewCustomerDetailsScreen(
                                          customerId : customerId,
                                          customerName : customerName,
                                          email : email,
                                          phoneNumber : phoneNumber,
                                          address : address,
                                        ),
                                      );
                                    },
                                  ),
                                  if(this.customerAccess.contains("Update Customer")) IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      print(customerName);

                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context)=>ShopWorkerUpdateCustomerScreen(ownerId, shopId, customerId, customerName, phoneNumber, email, address, this.workerId)
                                          )
                                      );
                                    },
                                  ),
                                  if(this.customerAccess.contains("Delete Customer")) IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () async{
                                      print(customerName);

                                      try
                                      {
                                        QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("customer")
                                            .where("ownerid",isEqualTo: ownerId)
                                            .where("shopid",isEqualTo: shopId)
                                            .where("customerid", isEqualTo: customerId)
                                            .where("email", isEqualTo: email)
                                            .get();

                                        if(snapshot.docs.isNotEmpty)
                                        {
                                          var document = snapshot.docs.first.reference;
                                          await document.delete();

                                          await Future.delayed(Duration(milliseconds: 300));
                                          toastWidget.showToast("Deleted");
                                        }
                                        else
                                        {
                                          await Future.delayed(Duration(milliseconds: 300));
                                          toastWidget.showToast("Try Again!");
                                        }
                                      }
                                      catch(e)
                                      {
                                        await Future.delayed(Duration(milliseconds: 300));
                                        toastWidget.showToast("Try Again!");
                                      }
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
        floatingActionButton: this.customerAccess.contains("Add Customer") ? FloatingActionButton(
          onPressed: () async {

            if(this.ownerId.isNotEmpty && this.shopId.isNotEmpty && this.workerId.isNotEmpty)
            {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ShopWorkerAddCustomerScreen(this.ownerId, this.shopId, this.workerId)
                  )
              );
            }
            else
            {
              await Future.delayed(Duration(milliseconds: 300));
              toastWidget.showToast("Try again");
            }
          },
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(Icons.add, color: Colors.black, size: 40),
        ) : null,
      ),
    );
  }
}