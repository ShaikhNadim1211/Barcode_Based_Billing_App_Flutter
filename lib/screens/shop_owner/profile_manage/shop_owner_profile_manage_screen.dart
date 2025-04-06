import 'package:barcode_based_billing_system/screens/shop_owner/profile_manage/shop_owner_profile_name_change_screen.dart';
import 'package:barcode_based_billing_system/screens/shop_owner/shop_owner_home_screen.dart';
import 'package:barcode_based_billing_system/widgets/custom_button_widget.dart';
import 'package:barcode_based_billing_system/widgets/custom_input_field_widget.dart';
import 'package:barcode_based_billing_system/widgets/custom_toast_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopOwnerProfileManageScreen extends StatefulWidget
{
  @override
  State<StatefulWidget> createState()
  {
    return ShopOwnerProfileManageScreenState();
  }
}

class ShopOwnerProfileManageScreenState extends State<ShopOwnerProfileManageScreen>
{
  CustomInputFieldWidget inputFieldWidget = CustomInputFieldWidget();
  CustomToastWidget toastWidget = CustomToastWidget();
  CustomButtonWidget buttonWidget = CustomButtonWidget();

  late Stream<QuerySnapshot> ownerStream;

  String username = "";

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();

  Future<void> _fetchUsername() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString("username") ?? "";
    if(username.isNotEmpty)
    {
      setState(() {
        this.username = username;
      });
    }
  }
  Future<void> _fetchUserDetails() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.username = prefs.getString("username") ?? "";

    if(this.username.isNotEmpty)
    {
      setState(() {
        this.ownerStream = FirebaseFirestore.instance
            .collection('shopowner')
            .where('username', isEqualTo: username)
            .snapshots();
      });
    }
  }
  @override
  void initState()
  {
    super.initState();
    _fetchUsername();
    _fetchUserDetails();
  }
  @override
  Widget build(BuildContext context)
  {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Profile",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
              onPressed: (){
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context)=>ShopOwnerHomeScreen()
                    )
                );
              },
              icon: Icon(Icons.arrow_back)
          ),
        ),

        body: Padding(
          padding: EdgeInsets.only(left: 25,right: 25),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                StreamBuilder<QuerySnapshot>(
                  stream: ownerStream,
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
                          'Try again',
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
                      var owner = snapshot.data!.docs;

                      if(owner.isEmpty)
                      {
                        return Center(
                          child: Text(
                            'Try again',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: MediaQuery.of(context).size.height * 0.04,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }
                      else
                      {
                        var document= owner.first;

                        String firstName = document["firstname"];
                        String lastName = document["lastname"];
                        String userName = document["username"];
                        String password = document["password"];
                        String email = document["email"];
                        String phoneNumber = document["phonenumber"];

                        if(firstName.isNotEmpty && lastName.isNotEmpty && userName.isNotEmpty
                        && password.isNotEmpty && email.isNotEmpty && phoneNumber.isNotEmpty)
                        {
                          this.name.text = firstName+" "+lastName;
                          this.email.text = email;
                          this.phoneNumber.text = phoneNumber;
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [

                              SizedBox(height: 30),

                              //Name
                              inputFieldWidget.NormalInputFieldReadOnly(
                                  context,
                                  this.name,
                                  "Name",
                                  Icon(Icons.person),
                                  "Name"
                              ),
                              SizedBox(height: 5,),
                              InkWell(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [

                                    Icon(
                                      Icons.edit,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                    SizedBox(width: 10,),
                                    Text(
                                      "Change Name",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: MediaQuery.of(context).size.height * 0.02,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: (){
                                  //Navigate to Change Name
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context)=>ShopOwnerProfileNameChangeScreen(userName, firstName, lastName)
                                      )
                                  );
                                },
                              ),
                              SizedBox(height: 25,),

                              //Email
                              inputFieldWidget.NormalInputFieldReadOnly(
                                  context,
                                  this.email,
                                  "Email",
                                  Icon(Icons.email),
                                  "Email"
                              ),
                              SizedBox(height: 25,),

                              //Phonenumber
                              inputFieldWidget.NormalInputFieldReadOnly(
                                  context,
                                  this.phoneNumber,
                                  "Phone Number",
                                  Icon(Icons.phone),
                                  "Phone Number"
                              ),
                              SizedBox(height: 25,),

                              Text(
                                "Note: For change of email and phone number please contact our support team.",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 50,),

                            ],
                          );
                        }
                        else
                        {
                          return Center(
                            child: Text(
                              'Try again',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: MediaQuery.of(context).size.height * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }

                      }
                    }
                    else
                    {
                      return Center(
                        child: Text(
                          'Try again',
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

              ],
            ),
          ),
        ),
      ),
    );
  }
}