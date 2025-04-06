import 'package:barcode_based_billing_system/screens/shop_owner/profile_manage/shop_owner_profile_manage_screen.dart';
import 'package:barcode_based_billing_system/widgets/custom_button_widget.dart';
import 'package:barcode_based_billing_system/widgets/custom_input_field_widget.dart';
import 'package:barcode_based_billing_system/widgets/custom_toast_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShopOwnerProfileNameChangeScreen extends StatefulWidget
{
  final String username;
  final String firstName;
  final String lastName;

  ShopOwnerProfileNameChangeScreen(this.username, this.firstName, this.lastName);

  @override
  State<StatefulWidget> createState()
  {
    return ShopOwnerProfileNameChangeScreenState();
  }
}

class ShopOwnerProfileNameChangeScreenState extends State<ShopOwnerProfileNameChangeScreen>
{
  CustomButtonWidget buttonWidget= CustomButtonWidget();
  CustomInputFieldWidget inputFieldWidget= CustomInputFieldWidget();
  CustomToastWidget toastWidget = CustomToastWidget();

  TextEditingController firstName= TextEditingController();
  TextEditingController lastName= TextEditingController();

  String firstNameMssg="";
  String lastNameMssg="";

  Color firstNameMssgColor=Colors.green;
  Color lastNameMssgColor=Colors.green;

  bool firstNameVerification=true;
  bool lastNameVerification=true;

  String username = "";

  @override
  void initState()
  {
    super.initState();
    this.username = widget.username;
    this.firstName.text = widget.firstName;
    this.lastName.text = widget.lastName;
  }

  @override
  Widget build(BuildContext context)
  {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Change Name",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
              onPressed: (){
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context)=>ShopOwnerProfileManageScreen()
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
            child: this.username.isEmpty
                ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Try Again",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.height * 0.04,
                  ),
                ),
              ],
            )
            : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                SizedBox(height: 50),

                //First Name Input
                inputFieldWidget.NormalInputFieldWithOnChange(
                    context,
                    firstName,
                    "E.g, Nadim",
                    Icon(Icons.person),
                    TextInputType.text,
                    Icon(Icons.verified_user,color: firstNameMssgColor),
                        (value)
                    {
                      print(value);
                      if(value.isEmpty)
                      {
                        firstNameVerification=false;
                        firstNameMssgColor=Colors.red;
                        firstNameMssg="First name is required";
                      }
                      else
                      {
                        RegExp regExp= RegExp(r'^[A-Z][a-z]*$');
                        bool match = regExp.hasMatch(value);
                        if(match)
                        {
                          firstNameVerification=true;
                          firstNameMssgColor=Colors.green;
                          firstNameMssg="";
                        }
                        else
                        {
                          firstNameVerification=false;
                          firstNameMssgColor=Colors.red;
                          firstNameMssg="It should start with a capital letter and the rest must be lowercase";
                        }
                      }
                      setState(() {

                      });
                    },
                    true,
                    50,
                    "First Name"
                ),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 35.0,right: 35.0),
                  child: Text(
                    firstNameMssg,
                    style: TextStyle(
                      color: firstNameMssgColor,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.height * 0.018,
                    ),
                  ),
                ),
                SizedBox(height: 25),

                //Last Name Input
                inputFieldWidget.NormalInputFieldWithOnChange(
                    context,
                    lastName,
                    "E.g, Shaikh",
                    Icon(Icons.person),
                    TextInputType.text,
                    Icon(Icons.verified_user,color: lastNameMssgColor),
                        (value)
                    {
                      print(value);
                      if(value.isEmpty)
                      {
                        lastNameVerification=false;
                        lastNameMssgColor=Colors.red;
                        lastNameMssg="Last Name is required";
                      }
                      else
                      {
                        RegExp regExp= RegExp(r'^[A-Z][a-z]*$');
                        bool match = regExp.hasMatch(value);
                        if(match)
                        {
                          lastNameVerification=true;
                          lastNameMssgColor=Colors.green;
                          lastNameMssg="";
                        }
                        else
                        {
                          lastNameVerification=false;
                          lastNameMssgColor=Colors.red;
                          lastNameMssg="It should start with a capital letter and the rest must be lowercase";
                        }
                      }
                      setState(() {

                      });
                    },
                    true,
                    50,
                    "Last Name"
                ),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 35.0,right: 35.0),
                  child: Text(
                    lastNameMssg,
                    style: TextStyle(
                      color: lastNameMssgColor,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.height * 0.018,
                    ),
                  ),
                ),
                SizedBox(height: 25),

                buttonWidget.ButtonField(
                    context,
                    "Update",
                    () async{

                      if(this.firstNameVerification && this.lastNameVerification)
                      {
                        String firstName = this.firstName.text.toString().trim();
                        String lastName = this.lastName.text.toString().trim();

                        Map<String, dynamic> data = {
                          "firstname": firstName,
                          "lastname": lastName,
                        };

                        try
                        {
                          QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("shopowner")
                              .where("username", isEqualTo: this.username)
                              .get();

                          if(snapshot.docs.isNotEmpty)
                          {
                            var document = snapshot.docs.first.reference;
                            await document.update(data);

                            await Future.delayed(Duration(milliseconds: 300));
                            toastWidget.showToast("Updated");

                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context)=>ShopOwnerProfileManageScreen()
                                )
                            );

                          }
                          else
                          {
                            await Future.delayed(Duration(milliseconds: 300));
                            toastWidget.showToast("Try again");
                          }

                        }
                        catch(e)
                        {
                          await Future.delayed(Duration(milliseconds: 300));
                          toastWidget.showToast("Try again");
                        }

                      }
                      else
                      {
                        await Future.delayed(Duration(milliseconds: 300));
                        toastWidget.showToast("Invalid Credential");
                      }
                    }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}