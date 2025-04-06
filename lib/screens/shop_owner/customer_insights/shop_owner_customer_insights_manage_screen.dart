import 'package:barcode_based_billing_system/screens/shop_owner/customer_insights/shop_owner_customer_insights_display_screen.dart';
import 'package:barcode_based_billing_system/screens/shop_owner/shop_owner_home_screen.dart';
import 'package:barcode_based_billing_system/widgets/custom_input_field_widget.dart';
import 'package:barcode_based_billing_system/widgets/custom_toast_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopOwnerCustomerInsightsManageScreen extends StatefulWidget
{
  @override
  State<StatefulWidget> createState()
  {
    return ShopOwnerCustomerInsightsManageScreenState();
  }
}

class ShopOwnerCustomerInsightsManageScreenState extends State<ShopOwnerCustomerInsightsManageScreen>
{
  CustomInputFieldWidget inputFieldWidget = CustomInputFieldWidget();
  CustomToastWidget toastWidget = CustomToastWidget();

  late Stream<QuerySnapshot> customerStream;
  late Stream<QuerySnapshot> selectShopStream;

  TextEditingController search = TextEditingController();

  String searchQuery = "";

  String username = "";
  String selectedShop = "";

  bool shopFetch = false;
  bool shopFetchError = false;

  Future<void> _fetchCustomer() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username') ?? '';
    if (username.isNotEmpty)
    {
      setState(() {
        this.username = username;
        this.customerStream = FirebaseFirestore.instance
            .collection('customer')
            .where('ownerid', isEqualTo: username)
            .snapshots();
      });
    }
  }
  Future<void> _fetchSelectedShops() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String select = prefs.getString("customerInsightsSelectedShop") ?? "";
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
                              prefs.setString("customerInsightsSelectedShop", this.selectedShop);
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

              //List of Customer
              if(this.selectedShop.isNotEmpty)
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
                        String sShop = customer['shopid'];
                        return sShop==this.selectedShop && (cName.toLowerCase().contains(searchQuery.toLowerCase()) ||
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

                                        if(ownerId.isNotEmpty && shopId.isNotEmpty
                                        && customerId.isNotEmpty && email.isNotEmpty)
                                        {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => ShopOwnerCustomerInsightsDisplayScreen(ownerId, shopId, customerId, email)
                                              )
                                          );
                                        }
                                        else
                                        {
                                          Future.delayed(Duration(milliseconds: 300));
                                          toastWidget.showToast("Try again");
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
      ),
    );
  }
}