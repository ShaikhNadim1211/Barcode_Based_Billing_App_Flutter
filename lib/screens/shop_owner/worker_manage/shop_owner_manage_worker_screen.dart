import 'package:barcode_based_billing_system/screens/shop_owner/shop_owner_home_screen.dart';
import 'package:barcode_based_billing_system/screens/shop_owner/worker_manage/shop_owner_add_worker_screen.dart';
import 'package:barcode_based_billing_system/screens/shop_owner/worker_manage/shop_owner_view_worker_details_screen.dart';
import 'package:barcode_based_billing_system/screens/shop_owner/worker_manage/shop_owner_worker_update_screen.dart';
import 'package:barcode_based_billing_system/widgets/custom_input_field_widget.dart';
import 'package:barcode_based_billing_system/widgets/custom_toast_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopOwnerManageWorkerScreen extends StatefulWidget
{
  @override
  State<StatefulWidget> createState()
  {
    return ShopOwnerManageWorkerScreenState();
  }
}

class ShopOwnerManageWorkerScreenState extends State<ShopOwnerManageWorkerScreen>
{
  CustomInputFieldWidget inputFieldWidget = CustomInputFieldWidget();
  CustomToastWidget toastWidget = CustomToastWidget();

  late Stream<QuerySnapshot> workerStream;
  late Stream<QuerySnapshot> selectShopStream;

  TextEditingController search = TextEditingController();

  String searchQuery = "";

  String username = "";
  String selectedShop = "";

  Future<void> _fetchWorker() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username') ?? '';

    if (username.isNotEmpty)
    {
      setState(() {
        this.workerStream = FirebaseFirestore.instance
            .collection('worker')
            .where('ownerid', isEqualTo: username)
            .snapshots();
      });
    }
  }
  Future<void> _fetchSelectedShops() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String select = prefs.getString("workerSelectedShop") ?? "";
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
    _fetchWorker();
  }

  @override
  Widget build(BuildContext context)
  {
    return PopScope(
      canPop: false,
      child: Scaffold(

        appBar: AppBar(
          title: const Text(
            "Worker",
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
                              prefs.setString("workerSelectedShop", this.selectedShop);
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

              if(this.selectedShop.isEmpty)
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

              //List of Worker
              if(this.selectedShop.isNotEmpty)
                StreamBuilder<QuerySnapshot>(
                  stream: workerStream,
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
                      var workers = snapshot.data!.docs;

                      // Filter the shops based on search query
                      var filteredWorkers = workers.where((worker) {
                        String wName = worker['workername'];
                        String wphoneNumber = worker['phonenumber'];
                        String sShop = worker['shopid'];
                        String wEmail = worker["email"];
                        return sShop==this.selectedShop && (wName.toLowerCase().contains(searchQuery.toLowerCase()) ||
                            wphoneNumber.toLowerCase().contains(searchQuery.toLowerCase()) || wEmail.toLowerCase().contains(searchQuery.toLowerCase())
                        );
                      }).toList();

                      if (filteredWorkers.isEmpty)
                      {
                        return Center(
                          child: Text(
                            "No workers found",
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
                          itemCount: filteredWorkers.length,
                          itemBuilder: (context, index) {

                            var worker = filteredWorkers[index];
                            String ownerId = worker["ownerid"];
                            String shopId = worker["shopid"];
                            String workerId = worker["workerid"];
                            String workerName = worker["workername"];
                            String phoneNumber = worker["phonenumber"];
                            String email = worker["email"];
                            String address = worker["address"];
                            String password = worker["password"];
                            String firstLogin = worker["firstlogin"];
                            String loggedIn = worker["loggedin"];
                            String description = worker["description"];
                            Map<String, List<String>> accessField = {};
                            var data = worker["accessField"] as Map<String, dynamic>;
                            data.forEach((key, value) {
                              accessField[key] = List<String>.from(value);
                            });

                            return Card(
                              color: Theme.of(context).cardColor,
                              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                              child: ListTile(
                                title: Text(
                                  workerName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: MediaQuery.of(context).size.height * 0.025,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Phone Number: $phoneNumber",style: TextStyle(color: Colors.black),),
                                    Text("Email: $email",style: TextStyle(color: Colors.black),),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.remove_red_eye_outlined),
                                      onPressed: (){
                                        print(workerName);

                                        Navigator.pushReplacement(
                                            context, 
                                            MaterialPageRoute(
                                                builder: (context)=>ShopOwnerViewWorkerDetailsScreen(ownerId, shopId, workerId, workerName, phoneNumber, email, address, description, accessField, password, firstLogin, loggedIn)
                                            )
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        print(workerName);
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context)=>ShopOwnerWorkerUpdateScreen(ownerId, shopId, workerId, workerName, phoneNumber, email, address, description, accessField, password)
                                            )
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () async{
                                        print(workerName);

                                        try
                                        {
                                          QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("worker")
                                              .where("ownerid",isEqualTo: ownerId)
                                              .where("shopid",isEqualTo: shopId)
                                              .where("workerid", isEqualTo: workerId)
                                              .where("email", isEqualTo: email)
                                              .where("phonenumber", isEqualTo: phoneNumber)
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
                          "No workers found",
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
                      builder: (context) => ShopOwnerAddWorkerScreen(this.username, this.selectedShop)
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