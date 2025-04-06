import 'package:barcode_based_billing_system/screens/common/login_screen.dart';
import 'package:barcode_based_billing_system/screens/shop_owner/shop_manage/shop_owner_add_shop_screen.dart';
import 'package:barcode_based_billing_system/screens/shop_owner/shop_manage/shop_owner_update_shop_screen.dart';
import 'package:barcode_based_billing_system/screens/shop_owner/shop_manage/shop_owner_view_shop_details_screen.dart';
import 'package:barcode_based_billing_system/screens/shop_owner/shop_owner_home_screen.dart';
import 'package:barcode_based_billing_system/widgets/custom_input_field_widget.dart';
import 'package:barcode_based_billing_system/widgets/custom_toast_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopOwnerManageShopScreen extends StatefulWidget
{
  @override
  State<StatefulWidget> createState()
  {
    return ShopOwnerManageShopScreenState();
  }
}

class ShopOwnerManageShopScreenState extends State<ShopOwnerManageShopScreen>
{
  CustomInputFieldWidget inputFieldWidget = CustomInputFieldWidget();
  CustomToastWidget toastWidget = CustomToastWidget();

  late Stream<QuerySnapshot> shopStream;

  TextEditingController search = TextEditingController();
  String searchQuery = "";

  _loadUsernameAndFetchShops() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username') ?? '';

    if (username.isNotEmpty)
    {
      setState(() {
        this.shopStream = FirebaseFirestore.instance
            .collection('shop')
            .where('ownerid', isEqualTo: username)
            .snapshots();
      });
    }
  }

  @override
  void initState()
  {
    super.initState();
    _loadUsernameAndFetchShops();
  }

  @override
  Widget build(BuildContext context)
  {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Shop",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => ShopOwnerHomeScreen()));
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

              // Search bar
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
              SizedBox(height: 30),

              // List of Shops
              StreamBuilder<QuerySnapshot>(
                stream: shopStream,
                builder: (context, snapshot) {

                  if (snapshot.connectionState == ConnectionState.waiting)
                  {
                    return Center(
                        child: CircularProgressIndicator(
                        )

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
                    var shops = snapshot.data!.docs;

                    // Filter the shops based on search query
                    var filteredShops = shops.where((shop) {
                      String shopName = shop['shopname'];
                      String address = shop['address'];
                      return shopName.toLowerCase().contains(searchQuery.toLowerCase()) ||
                          address.toLowerCase().contains(searchQuery.toLowerCase());
                    }).toList();

                    if (filteredShops.isEmpty)
                    {
                      return Center(
                        child: Text(
                          "No shops found",
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
                        itemCount: filteredShops.length,
                        itemBuilder: (context, index) {

                          var shop = filteredShops[index];
                          String shopName = shop['shopname'];
                          String email = shop['email'];
                          String phoneNumber = shop['phonenumber'];
                          String? alternateNumber = shop['alternatenumber'];
                          String? telephoneNumber = shop['telephonenumber'];
                          String? gst = shop['gstin'];
                          String address = shop['address'];
                          String description = shop["description"];

                          return Card(
                            color: Theme.of(context).cardColor,
                            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            child: ListTile(
                              title: Text(
                                shopName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: MediaQuery.of(context).size.height * 0.025,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Address: $address",style: TextStyle(color: Colors.black),),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove_red_eye_outlined),
                                    onPressed: (){
                                      showDialog(
                                        context: context,
                                        builder: (context) => ShopOwnerViewShopDetailsScreen(
                                          shopName: shopName,
                                          email: email,
                                          phoneNumber: phoneNumber,
                                          alternateNumber: alternateNumber,
                                          telephoneNumber: telephoneNumber,
                                          gst: gst,
                                          address: address,
                                          description : description,
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      print(shopName);
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context)=>ShopOwnerUpdateShopScreen(shop['ownerid'], shopName, email, phoneNumber, telephoneNumber, address, alternateNumber, gst, description )
                                          ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () async{
                                      print(shopName);
                                      String username = shop['ownerid'];
                                      String shopname = shopName;

                                      try
                                      {
                                        QuerySnapshot shopSnapshot = await FirebaseFirestore.instance.collection("shop")
                                            .where("ownerid",isEqualTo: username)
                                            .where("shopname",isEqualTo: shopname)
                                            .get();
                                        QuerySnapshot workerSnapshot = await FirebaseFirestore.instance.collection("worker")
                                            .where("ownerid",isEqualTo: username)
                                            .where("shopid",isEqualTo: shopname)
                                            .get();
                                        QuerySnapshot productSnapshot = await FirebaseFirestore.instance.collection("product")
                                            .where("ownerid",isEqualTo: username)
                                            .where("shopid",isEqualTo: shopname)
                                            .get();
                                        QuerySnapshot customerSnapshot = await FirebaseFirestore.instance.collection("customer")
                                            .where("ownerid",isEqualTo: username)
                                            .where("shopid",isEqualTo: shopname)
                                            .get();
                                        QuerySnapshot billSnapshot = await FirebaseFirestore.instance.collection("invoice")
                                            .where("ownerid",isEqualTo: username)
                                            .where("shopid",isEqualTo: shopname)
                                            .get();

                                        if(shopSnapshot.docs.isNotEmpty || workerSnapshot.docs.isNotEmpty
                                            || productSnapshot.docs.isNotEmpty || customerSnapshot.docs.isNotEmpty
                                            || billSnapshot.docs.isNotEmpty)
                                        {
                                          WriteBatch batch = FirebaseFirestore.instance.batch();

                                          // Add shop documents to batch
                                          for (var doc in shopSnapshot.docs)
                                          {
                                            batch.delete(doc.reference);
                                          }

                                          // Add worker documents to batch
                                          for (var doc in workerSnapshot.docs)
                                          {
                                            batch.delete(doc.reference);
                                          }

                                          // Add product documents to batch
                                          for (var doc in productSnapshot.docs)
                                          {
                                            batch.delete(doc.reference);
                                          }

                                          // Add customer documents to batch
                                          for (var doc in customerSnapshot.docs)
                                          {
                                            batch.delete(doc.reference);
                                          }

                                          // Add bill documents to batch
                                          for (var doc in billSnapshot.docs)
                                          {
                                            batch.delete(doc.reference);
                                          }

                                          // Commit the batch
                                          await batch.commit();

                                          SharedPreferences prefs = await SharedPreferences.getInstance();
                                          prefs.setBool("logIn", false);
                                          prefs.setBool("ownerLogIn", false);
                                          prefs.setBool("workerLogIn", false);
                                          prefs.remove("username");
                                          prefs.clear();

                                          await Future.delayed(Duration(milliseconds: 300));
                                          toastWidget.showToast("Login again!");

                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(builder: (context) => LoginScreen()),
                                          );
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
                        "No shops found",
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
              SizedBox(height: 40),
            ],
          ),
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => ShopOwnerAddShopScreen()
                )
            );
          },
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(Icons.add, color: Colors.black, size: 40),
        ),
      ),
    );
  }
}
