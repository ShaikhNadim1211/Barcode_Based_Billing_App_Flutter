import 'package:barcode_based_billing_system/screens/shop_owner/product_manage/shop_owner_add_product_screen.dart';
import 'package:barcode_based_billing_system/screens/shop_owner/product_manage/shop_owner_product_update_screen.dart';
import 'package:barcode_based_billing_system/screens/shop_owner/product_manage/shop_owner_view_product_details_screen.dart';
import 'package:barcode_based_billing_system/widgets/custom_input_field_widget.dart';
import 'package:barcode_based_billing_system/widgets/custom_toast_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../shop_owner_home_screen.dart';

class ShopOwnerManageProductScreen extends StatefulWidget
{
  @override
  State<StatefulWidget> createState()
  {
    return ShopOwnerManageProductScreenState();
  }
}

class ShopOwnerManageProductScreenState extends State<ShopOwnerManageProductScreen>
{
  CustomInputFieldWidget inputFieldWidget = CustomInputFieldWidget();
  CustomToastWidget toastWidget = CustomToastWidget();

  late Stream<QuerySnapshot> productStream;
  late Stream<QuerySnapshot> selectShopStream;

  TextEditingController search = TextEditingController();

  String searchQuery = "";

  String username = "";
  String selectedShop = "";

  bool shopFetch = false;
  bool shopFetchError = false;


  Future<void> _fetchProduct() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username') ?? '';

    if (username.isNotEmpty)
    {
      setState(() {
        this.productStream = FirebaseFirestore.instance
            .collection('product')
            .where('ownerid', isEqualTo: username)
            .snapshots();
      });
    }
  }

  Future<void> _fetchSelectedShops() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String select = prefs.getString("productSelectedShop") ?? "";
    String username = prefs.getString("username") ?? "";
    if(select.isNotEmpty)
    {
      setState(() {
        this.selectedShop = select;
        this.username = username;
      });
    }
    print(this.selectedShop.toString());
  }
  Future<void> _fetchShop() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.username = prefs.getString("username") ?? "";

    if(this.username.isNotEmpty)
    {
      setState(() {
        this.selectShopStream = FirebaseFirestore.instance
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
    _fetchSelectedShops();
    _fetchShop();
    _fetchProduct();
  }
  @override
  Widget build(BuildContext context)
  {
    return PopScope(
      canPop: false,
      child: Scaffold(

        appBar: AppBar(
          title: const Text(
            "Product",
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

              //Shop Drop Down
              StreamBuilder<QuerySnapshot>(
                stream: selectShopStream,
                builder: (context, snapshot){
                  if (snapshot.connectionState == ConnectionState.waiting)
                  {
                    return Center(child: CircularProgressIndicator(color: Theme.of(context).cardColor,));
                  }
                  else if(snapshot.hasError)
                  {
                    this.shopFetchError = true;
                    return Center(
                      child: Text(
                        "Some error occurred",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: MediaQuery.of(context).size.height * 0.04,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }
                  else if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
                  {
                    this.shopFetchError = true;
                    return Center(
                      child: Text(
                        'No shops available',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: MediaQuery.of(context).size.height * 0.04,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }
                  else if(snapshot.hasData)
                  {
                    this.shopFetchError = false;
                    List<String> shopNames = snapshot.data!.docs
                        .map((doc) => doc['shopname'].toString())
                        .toList();

                    return shopNames.isEmpty
                        ? Center(
                      child: Text(
                        'No shops available',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: MediaQuery.of(context).size.height * 0.04,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                        : Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Container(
                          child: DropdownButton<String>(
                            value: this.selectedShop.isNotEmpty ? this.selectedShop : null,
                            hint: Text("Select Shop"),
                            onChanged: (newShop) async {
                              setState(() {
                                this.selectedShop = newShop.toString();
                              });
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              prefs.setString("productSelectedShop", this.selectedShop);
                            },
                            items: shopNames.map((shop) {
                              return DropdownMenuItem<String>(
                                value: shop,
                                child: Text(shop),
                              );
                            }).toList(),
                            icon: Icon(Icons.arrow_drop_down, color: Colors.black, size: 30),

                            style: TextStyle(color: Colors.black, fontSize: 16,),
                            dropdownColor: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    );
                  }
                  else
                  {
                    this.shopFetchError = true;
                    return Center(
                      child: Text(
                        'No shops available',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: MediaQuery.of(context).size.height * 0.04,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: 10),

              if(this.selectedShop.isEmpty && this.shopFetchError==false)
               Center(
                child: Text(
                  'Select the shop',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: MediaQuery.of(context).size.height * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              //List Product
              if(this.selectedShop.isNotEmpty)
                StreamBuilder<QuerySnapshot>(
                  stream: productStream,
                  builder: (context, snapshot) {

                    if (snapshot.connectionState == ConnectionState.waiting)
                    {
                      return Center(
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
                      var products = snapshot.data!.docs;

                      // Filter the shops based on search query
                      var filteredProducts = products.where((product) {
                        String pName = product['productname'];
                        String bNumber = product['barcodenumber'];
                        String sShop = product['shopid'];
                        String aBy = product["addedby"];
                        String uBy = product["updatedby"] ?? "";
                        String stock = product["quantity"];
                        return sShop==this.selectedShop && (pName.toLowerCase().contains(searchQuery.toLowerCase()) ||
                            bNumber.toLowerCase().contains(searchQuery.toLowerCase()) || aBy.toLowerCase().contains(searchQuery.toLowerCase())
                        || uBy.toLowerCase().contains(searchQuery.toLowerCase()) || stock.toLowerCase().contains(searchQuery.toLowerCase()));
                      }).toList();

                      if (filteredProducts.isEmpty)
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
                          itemCount: filteredProducts.length,
                          itemBuilder: (context, index) {

                            var product = filteredProducts[index];
                            String ownerId = product["ownerid"];
                            String shopId = product["shopid"];
                            String productId = product["productid"];
                            String productName = product["productname"];
                            String buyingPrice = product["buyingprice"];
                            String sellingPrice = product["sellingprice"];
                            String barcodenumber = product["barcodenumber"];
                            String quantity = product["quantity"];
                            String finalPrice = product["finalprice"];
                            List<String> optionalField= List<String>.from(product["optionalField"]);
                            Map<String, String> optionalFieldValue = Map<String, String>.from(product["optionalFieldValue"]);
                            String addedBy = product["addedby"];
                            String updatedBy = product["updatedby"] ?? "";

                            return Card(
                              color: Theme.of(context).cardColor,
                              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                              child: ListTile(
                                title: Text(
                                  productName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: MediaQuery.of(context).size.height * 0.025,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Stock Quantity: $quantity",style: TextStyle(color: Colors.black),),
                                    Text("Barcode Number: $barcodenumber",style: TextStyle(color: Colors.black),),
                                    Text("Added By: $addedBy",style: TextStyle(color: Colors.black),),
                                    Text("Updated By: $updatedBy",style: TextStyle(color: Colors.black),),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.remove_red_eye_outlined),
                                      onPressed: (){
                                        print(productName);

                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context)=>ShopOwnerViewProductDetailsScreen(ownerId, shopId, productId, productName, buyingPrice, sellingPrice, barcodenumber, quantity, optionalField, optionalFieldValue, finalPrice, addedBy, updatedBy)
                                            )
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        print(productName);

                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context)=>ShopOwnerProductUpdateScreen(ownerId, shopId, productId, productName, buyingPrice, sellingPrice, barcodenumber, quantity, optionalField, optionalFieldValue, finalPrice)
                                            )
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () async{
                                        print(productName);

                                        try
                                        {
                                          QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("product")
                                              .where("ownerid",isEqualTo: ownerId)
                                              .where("shopid",isEqualTo: shopId)
                                              .where("productid", isEqualTo: productId)
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

        floatingActionButton: FloatingActionButton(
          onPressed: () async {

            if(this.selectedShop.isNotEmpty)
            {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ShopOwnerAddProductScreen(this.username, this.selectedShop)
                  )
              );
            }
            else
            {
              await Future.delayed(Duration(milliseconds: 300));
              toastWidget.showToast("Select the shop");
            }
          },
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(Icons.add, color: Colors.black, size: 40),
        ),
      ),
    );
  }
}