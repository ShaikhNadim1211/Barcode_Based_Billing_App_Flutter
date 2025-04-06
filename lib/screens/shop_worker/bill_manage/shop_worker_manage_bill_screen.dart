import 'package:barcode_based_billing_system/screens/shop_worker/bill_manage/shop_worker_view_bill_screen.dart';
import 'package:barcode_based_billing_system/screens/shop_worker/shop_worker_home_screen.dart';
import 'package:barcode_based_billing_system/widgets/custom_input_field_widget.dart';
import 'package:barcode_based_billing_system/widgets/custom_toast_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopWorkerManageBillScreen extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() 
  {
    return ShopWorkerManageBillScreenState();
  }
}

class ShopWorkerManageBillScreenState extends State<ShopWorkerManageBillScreen>
{
  CustomInputFieldWidget inputFieldWidget = CustomInputFieldWidget();
  CustomToastWidget toastWidget = CustomToastWidget();

  late Stream<QuerySnapshot> billStream;

  TextEditingController search = TextEditingController();
  String searchQuery = "";

  String ownerId = "";
  String shopId = "";
  List<String> billAccess = [];

  Future<void> _fetchBill() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ownerId = prefs.getString('ownerId') ?? '';
    String shopId = prefs.getString('shopId') ?? '';
    List<String> bill = prefs.getStringList('Bill') ?? [];
    if (ownerId.isNotEmpty && shopId.isNotEmpty && bill.isNotEmpty)
    {
      setState(() {
        this.billStream = FirebaseFirestore.instance
            .collection('invoice')
            .where('ownerid', isEqualTo: ownerId)
            .where('shopid', isEqualTo: shopId)
            .snapshots();
        this.ownerId = ownerId;
        this.shopId = shopId;
        this.billAccess = bill;
      });
    }
  }

  @override
  void initState()
  {
    super.initState();
    _fetchBill();
  }
  
  @override
  Widget build(BuildContext context) 
  {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Bill",
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
              
              //List of Bill
              StreamBuilder<QuerySnapshot>(
                stream: billStream,
                builder: (context, snapshot) {

                  if (snapshot.connectionState == ConnectionState.waiting)
                  {
                    return Center(
                      child: CircularProgressIndicator(color: Theme.of(context).cardColor,),
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
                    var bills = snapshot.data!.docs;


                    // Filter the shops based on search query
                    var filteredBills = bills.where((bill) {
                      String bId = bill['invoiceid'];
                      String cId = bill['customerid'];
                      String cEmail = bill['customeremail'];
                      String date = bill['date'];
                      return (bId.toLowerCase().contains(searchQuery.toLowerCase()) ||
                          cId.toLowerCase().contains(searchQuery.toLowerCase()) || cEmail.toLowerCase().contains(searchQuery.toLowerCase())
                          || date.toLowerCase().contains(searchQuery.toLowerCase()));
                    }).toList();

                    if (filteredBills.isEmpty)
                    {
                      return Center(
                        child: Text(
                          "No products found",
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
                        itemCount: filteredBills.length,
                        itemBuilder: (context, index) {

                          var bill = filteredBills[index];
                          String ownerId = bill["ownerid"];
                          String shopId = bill["shopid"];
                          String customerId = bill["customerid"];
                          String customerEmail = bill["customeremail"];
                          Map<String, Map<String, dynamic>> productDetail = Map<String, Map<String, dynamic>>.from(bill["productDetail"]);
                          String totalAmount = bill["totalamount"];
                          String extraDiscount = bill["extradiscount"];
                          String extraCharges = bill["extracharges"];
                          String paymentType = bill["paymenttype"];
                          String timeStamp = bill["timestamp"].toString();
                          String invoiceId = bill["invoiceid"];
                          String date = bill["date"];
                          String time = bill["time"];

                          return Card(
                            color: Theme.of(context).cardColor,
                            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            child: ListTile(
                              title: Text(
                                invoiceId,
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
                                  Text("Customer Email: $customerEmail",style: TextStyle(color: Colors.black),),
                                  Text("Date: $date",style: TextStyle(color: Colors.black),),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if(this.billAccess.contains("View Bill")) IconButton(
                                    icon: Icon(Icons.remove_red_eye_outlined),
                                    onPressed: () async
                                    {
                                      if(ownerId.isNotEmpty && shopId.isNotEmpty && customerId.isNotEmpty && customerEmail.isNotEmpty && productDetail.isNotEmpty && totalAmount.isNotEmpty && extraDiscount.isNotEmpty && extraCharges.isNotEmpty && paymentType.isNotEmpty && timeStamp.isNotEmpty && invoiceId.isNotEmpty && date.isNotEmpty && time.isNotEmpty)
                                      {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context)=>ShopWorkerViewBillScreen(ownerId, shopId, customerId, customerEmail, productDetail, totalAmount, extraDiscount, extraCharges, paymentType, timeStamp, invoiceId, date, time)
                                          ),
                                        );
                                      }
                                      else
                                      {
                                        await Future.delayed(Duration(milliseconds: 300));
                                        toastWidget.showToast("Try again");
                                      }

                                    },
                                  ),
                                  if(this.billAccess.contains("Delete Bill")) IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () async
                                    {
                                      print(invoiceId);
                                      try
                                      {
                                        QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("invoice")
                                            .where("ownerid",isEqualTo: ownerId)
                                            .where("shopid",isEqualTo: shopId)
                                            .where("invoiceid", isEqualTo: invoiceId)
                                            .where("customeremail", isEqualTo: customerEmail)
                                            .where("customerid", isEqualTo: customerId)
                                            .get();

                                        if(snapshot.docs.isNotEmpty)
                                        {
                                          var document = snapshot.docs.first;
                                          var documentRef = snapshot.docs.first.reference;

                                          WriteBatch batch = FirebaseFirestore.instance.batch();

                                          for(var barcode in productDetail.keys)
                                          {
                                            Map<String, dynamic> product = Map<String, dynamic>.from(productDetail[barcode]!);

                                            int quantitySold = int.parse(product['itemquantity'].toString());
                                            String productId = product['productid'].toString();

                                            QuerySnapshot productSnapshot = await FirebaseFirestore.instance
                                                .collection('product')
                                                .where('ownerid', isEqualTo: ownerId)
                                                .where("shopid", isEqualTo: shopId)
                                                .where("productid", isEqualTo: productId)
                                                .where("barcodenumber", isEqualTo: barcode)
                                                .get();

                                            if (productSnapshot.docs.isNotEmpty)
                                            {
                                              var productDoc = productSnapshot.docs.first;
                                              var productDocRef = productSnapshot.docs.first.reference;

                                              int quantity = int.parse(productDoc['quantity'].toString());

                                              batch.update(productDocRef, {
                                                "quantity": (quantity+quantitySold).toString(),
                                              });
                                            }
                                          }

                                          await documentRef.delete();
                                          await batch.commit();

                                          await Future.delayed(Duration(milliseconds: 300));
                                          toastWidget.showToast("Bill deleted");
                                        }
                                        else
                                        {
                                          await Future.delayed(Duration(milliseconds: 300));
                                          toastWidget.showToast("Try again!");
                                        }

                                        /*if(snapshot.docs.isNotEmpty)
                                          {
                                            var document = snapshot.docs.first.reference;
                                            await document.delete();

                                            await Future.delayed(Duration(milliseconds: 300));
                                            toastWidget.showToast("Please update the product stock!");
                                          }
                                          else
                                          {
                                            await Future.delayed(Duration(milliseconds: 300));
                                            toastWidget.showToast("Try Again!");
                                          }*/
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
                        "No products found",
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
      ),
    );
  }
}