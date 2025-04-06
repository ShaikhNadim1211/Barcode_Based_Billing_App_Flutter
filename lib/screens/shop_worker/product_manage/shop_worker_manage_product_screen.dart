import 'package:barcode_based_billing_system/screens/shop_worker/product_manage/shop_worker_add_product_screen.dart';
import 'package:barcode_based_billing_system/screens/shop_worker/product_manage/shop_worker_update_product_screen.dart';
import 'package:barcode_based_billing_system/screens/shop_worker/product_manage/shop_worker_view_product_details_screen.dart';
import 'package:barcode_based_billing_system/screens/shop_worker/shop_worker_home_screen.dart';
import 'package:barcode_based_billing_system/widgets/custom_input_field_widget.dart';
import 'package:barcode_based_billing_system/widgets/custom_toast_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopWorkerManageProductScreen extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() 
  {
    return ShopWorkerManageProductScreenState();
  }
}
class ShopWorkerManageProductScreenState extends State<ShopWorkerManageProductScreen>
{
  CustomInputFieldWidget inputFieldWidget = CustomInputFieldWidget();
  CustomToastWidget toastWidget = CustomToastWidget();

  late Stream<QuerySnapshot> productStream;

  TextEditingController search = TextEditingController();
  String searchQuery = "";

  String ownerId = "";
  String shopId = "";
  String workerId = "";
  List<String> productAccess = [];

  Future<void> _fetchProduct() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ownerId = prefs.getString("ownerId") ?? '';
    String shopId = prefs.getString("shopId") ?? '';
    String workerId = prefs.getString("workerId") ?? '';
    List<String> product = prefs.getStringList("Product") ?? [];

    if (ownerId.isNotEmpty && shopId.isNotEmpty
        && workerId.isNotEmpty && product.isNotEmpty)
    {
      setState(() {
        this.productStream = FirebaseFirestore.instance
            .collection('product')
            .where('ownerid', isEqualTo: ownerId)
            .where("shopid", isEqualTo: shopId)
            .snapshots();
        this.ownerId = ownerId;
        this.shopId = shopId;
        this.workerId = workerId;
        this.productAccess = product;
      });
    }
  }

  @override
  void initState()
  {
    super.initState();
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

              //List of Product
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
                      String stock = product["quantity"];
                      return (pName.toLowerCase().contains(searchQuery.toLowerCase()) ||
                          bNumber.toLowerCase().contains(searchQuery.toLowerCase()) || 
                          stock.toLowerCase().contains(searchQuery.toLowerCase()));
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
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if(this.productAccess.contains("View Product")) IconButton(
                                    icon: Icon(Icons.remove_red_eye_outlined),
                                    onPressed: (){
                                      print(productName);

                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context)=>ShopWorkerViewProductDetailsScreen(productId, productName, buyingPrice, sellingPrice, barcodenumber, quantity, optionalField, optionalFieldValue, finalPrice)
                                          )
                                      );
                                    },
                                  ),
                                  if(this.productAccess.contains("Update Product")) IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      print(productName);

                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context)=>ShopWorkerUpdateProductScreen(ownerId, shopId, productId, productName, buyingPrice, sellingPrice, barcodenumber, quantity, optionalField, optionalFieldValue, finalPrice, this.workerId)
                                          )
                                      );
                                    },
                                  ),
                                  if(this.productAccess.contains("Delete Product")) IconButton(
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

        floatingActionButton: this.productAccess.contains("Add Product") ? FloatingActionButton(
          onPressed: () async {

            if(this.ownerId.isNotEmpty && this.shopId.isNotEmpty && this.workerId.isNotEmpty)
            {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ShopWorkerAddProductScreen(this.ownerId, this.shopId, this.workerId)
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
        )
        : null,
        
      ),
    );
  }
}