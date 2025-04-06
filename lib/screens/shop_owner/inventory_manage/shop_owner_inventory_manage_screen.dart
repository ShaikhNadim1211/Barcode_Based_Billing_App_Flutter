import 'package:barcode_based_billing_system/screens/shop_owner/shop_owner_home_screen.dart';
import 'package:barcode_based_billing_system/widgets/custom_input_field_widget.dart';
import 'package:barcode_based_billing_system/widgets/custom_toast_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class ShopOwnerInventoryManageScreen extends StatefulWidget
{
  @override
  State<StatefulWidget> createState()
  {
    return ShopOwnerInventoryManageScreenState();
  }
}

class ShopOwnerInventoryManageScreenState extends State<ShopOwnerInventoryManageScreen>
{
  CustomInputFieldWidget inputFieldWidget = CustomInputFieldWidget();
  CustomToastWidget toastWidget = CustomToastWidget();

  late Stream<QuerySnapshot> productStream;
  late Stream<QuerySnapshot> selectShopStream;

  TextEditingController search = TextEditingController();

  String searchQuery = "";

  String username = "";
  String selectedShop = "";

  String inventoryFilter = "All";
  List<String> inventoryOptions = ["All", "Stock Qty < 5","Stock Qty < 10","Stock Qty < 20", "Stock Qty < 30","Stock Qty < 50", "Expired"];

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
    String select = prefs.getString("inventorySelectedShop") ?? "";
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
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Inventory",
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
                              prefs.setString("inventorySelectedShop", this.selectedShop);
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

              // Inventory Dropdown
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: DropdownButton<String>(
                    value: inventoryFilter,
                    onChanged: (value) {
                      setState(() {
                        inventoryFilter = value!;
                      });
                    },
                    items: inventoryOptions.map((option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                    icon: Icon(Icons.arrow_drop_down, color: Colors.black, size: 30),
                    style: TextStyle(color: Colors.black, fontSize: 16,),
                    dropdownColor: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

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
                        String productName = product['productname'].toString().toLowerCase();
                        String productId = product["productid"].toString();
                        int stockQty = int.parse(product['quantity'].toString());
                        String barcodeNumber = product['barcodenumber'].toString();
                        String sShop = product['shopid'];
                        List<String> optionalField = List<String>.from(product["optionalField"]);
                        Map<String, String> optionalFieldValue = Map<String, String>.from(product["optionalFieldValue"]);

                        bool matchesSearch = sShop==this.selectedShop && (productName.contains(searchQuery.toLowerCase()) ||
                            barcodeNumber.contains(searchQuery.toLowerCase() )
                          || productId.contains(searchQuery));

                        DateTime now = DateTime.now();
                        DateTime? expiryDate;

                        if(optionalField.contains("Expiring Date"))
                        {
                          if(optionalFieldValue["Expiring Date"]!.isNotEmpty)
                          {
                            expiryDate = DateFormat("yyyy-MM-dd").parse(optionalFieldValue["Expiring Date"] ?? "");
                          }
                        }

                        bool isExpired = expiryDate != null && expiryDate.isBefore(now);

                        bool matchesInventory = this.inventoryFilter == "All" ||
                            (this.inventoryFilter == "Stock Qty < 5" && stockQty < 5) ||
                            (this.inventoryFilter == "Stock Qty < 10" && stockQty < 10) ||
                            (this.inventoryFilter == "Stock Qty < 20" && stockQty < 20) ||
                            (this.inventoryFilter == "Stock Qty < 30" && stockQty < 30) ||
                            (this.inventoryFilter == "Stock Qty < 50" && stockQty < 50) ||
                            (this.inventoryFilter == "Expired" && isExpired);

                        return matchesSearch && matchesInventory;

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
                                    Text("Product ID: $productId",style: TextStyle(color: Colors.black),),
                                    Text("Barcode Number: $barcodenumber",style: TextStyle(color: Colors.black),),
                                    Text("Stock Quantity: $quantity",style: TextStyle(color: Colors.black),),
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