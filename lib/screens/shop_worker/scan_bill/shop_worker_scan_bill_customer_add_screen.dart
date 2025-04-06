import 'package:barcode_based_billing_system/firebase/shop_owner_document_id_manage.dart';
import 'package:barcode_based_billing_system/methods/otp_auth.dart';
import 'package:barcode_based_billing_system/widgets/custom_button_widget.dart';
import 'package:barcode_based_billing_system/widgets/custom_input_field_widget.dart';
import 'package:barcode_based_billing_system/widgets/custom_toast_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShopWorkerScanBillCustomerAddScreen extends StatefulWidget
{
  final String ownerId;
  final String shopId;
  final String workerId;

  ShopWorkerScanBillCustomerAddScreen(this.ownerId, this.shopId, this.workerId);
  @override
  State<StatefulWidget> createState()
  {
    return ShopWorkerScanBillCustomerAddScreenState();
  }
}

class ShopWorkerScanBillCustomerAddScreenState extends State<ShopWorkerScanBillCustomerAddScreen>
{
  CustomInputFieldWidget inputFieldWidget =CustomInputFieldWidget();
  CustomButtonWidget buttonWidget = CustomButtonWidget();
  CustomToastWidget toastWidget = CustomToastWidget();
  OtpAuth otpAuth = OtpAuth();
  ShopOwnerDocumentIdManage documentIdManage = ShopOwnerDocumentIdManage();

  TextEditingController customerName = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController address = TextEditingController();

  String customerNameMssg = "";
  String phoneNumberMssg = "";
  String emailMssg = "";
  String addressMssg = "";

  Color customerNameMssgColor = Colors.red;
  Color phoneNumberMssgColor = Colors.red;
  Color emailMssgColor = Colors.red;
  Color addressMssgColor = Colors.red;

  bool customerNameVerification = false;
  bool phoneNumberVerification = true;
  bool emailVerification = false;
  bool addressVerification = false;

  String ownerId = "";
  String shopId = "";
  String workerId = "";

  bool sendIdIsChecked = false;

  @override
  void initState()
  {
    super.initState();
    this.ownerId = widget.ownerId.toString();
    this.shopId = widget.shopId.toString();
    this.workerId = widget.workerId.toString();
  }

  @override
  Widget build(BuildContext context)
  {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Add Customer",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
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

                SizedBox(height: 50),

                //Customer Name
                inputFieldWidget.NormalInputFieldWithOnChange(
                    context,
                    customerName,
                    "E.g, Shaikh Nadim",
                    Icon(Icons.people),
                    TextInputType.text,
                    Icon(Icons.verified_user,color: customerNameMssgColor),
                        (value)
                    {
                      print(value);
                      if(value.isEmpty)
                      {
                        customerNameVerification=false;
                        customerNameMssgColor=Colors.red;
                        customerNameMssg="Customer name is required";
                      }
                      else
                      {
                        RegExp regExp= RegExp(r'^[A-Za-z\s]{3,}$');
                        bool match = regExp.hasMatch(value.trim());
                        if(match)
                        {
                          customerNameVerification=true;
                          customerNameMssgColor=Colors.green;
                          customerNameMssg="";
                        }
                        else
                        {
                          customerNameVerification=false;
                          customerNameMssgColor=Colors.red;
                          customerNameMssg="Invalid customer name. The name must contain at least 3 characters and can only include letters and spaces.";
                        }
                      }
                      setState(() {

                      });
                    },
                    true,
                    50,
                    "Customer Name"
                ),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 35.0,right: 35.0),
                  child: Text(
                    customerNameMssg,
                    style: TextStyle(
                      color: customerNameMssgColor,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.height * 0.018,
                    ),
                  ),
                ),
                SizedBox(height: 20),

                //Phone Number
                inputFieldWidget.NormalInputFieldWithOnChange(
                    context,
                    phoneNumber,
                    "E.g, 1234567890",
                    Icon(Icons.phone),
                    TextInputType.phone,
                    Icon(null),
                        (value) async
                    {
                      print(value);
                      if(value.isEmpty)
                      {
                        phoneNumberVerification=true;
                        phoneNumberMssgColor=Colors.green;
                        phoneNumberMssg="";
                      }
                      else
                      {
                        RegExp regExp= RegExp(r'^\d{10}$');
                        bool match = regExp.hasMatch(value.trim());
                        if(match)
                        {
                          QuerySnapshot  snapshot = await FirebaseFirestore.instance.collection("customer")
                              .where("ownerid", isEqualTo: this.ownerId)
                              .where("shopid", isEqualTo: this.shopId)
                              .where("phonenumber", isEqualTo: value.trim().toString())
                              .get();
                          if(snapshot.docs.isNotEmpty)
                          {
                            phoneNumberVerification=false;
                            phoneNumberMssgColor=Colors.red;
                            phoneNumberMssg="Phone number already exists";
                          }
                          else
                          {
                            phoneNumberVerification=true;
                            phoneNumberMssgColor=Colors.green;
                            phoneNumberMssg="";
                          }
                        }
                        else
                        {
                          phoneNumberVerification=false;
                          phoneNumberMssgColor=Colors.red;
                          phoneNumberMssg="It must be exactly 10 digits without spaces or special characters";
                        }
                      }
                      setState(() {

                      });
                    },
                    true,
                    10,
                    "Phone Number"
                ),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 35.0,right: 35.0),
                  child: Text(
                    phoneNumberMssg,
                    style: TextStyle(
                      color: phoneNumberMssgColor,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.height * 0.018,
                    ),
                  ),
                ),
                SizedBox(height: 20),

                //Email
                inputFieldWidget.NormalInputFieldWithOnChange(
                    context,
                    email,
                    "E.g, user@example.com",
                    Icon(Icons.email),
                    TextInputType.emailAddress,
                    Icon(Icons.verified_user, color: emailMssgColor,),
                        (value) async
                    {
                      print(value);
                      if(value.isEmpty)
                      {
                        emailVerification=false;
                        emailMssgColor=Colors.red;
                        emailMssg="Field is Required";
                      }
                      else
                      {
                        RegExp regExp= RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                        bool match = regExp.hasMatch(value.trim());
                        if(match)
                        {
                          QuerySnapshot  snapshot = await FirebaseFirestore.instance.collection("customer")
                              .where("ownerid", isEqualTo: this.ownerId)
                              .where("shopid", isEqualTo: this.shopId)
                              .where("email", isEqualTo: value.trim().toString())
                              .get();
                          if(snapshot.docs.isNotEmpty)
                          {
                            emailVerification=false;
                            emailMssgColor=Colors.red;
                            emailMssg="Email already exists";
                          }
                          else
                          {
                            emailVerification=true;
                            emailMssgColor=Colors.green;
                            emailMssg="";
                          }
                        }
                        else
                        {
                          emailVerification=false;
                          emailMssgColor=Colors.red;
                          emailMssg="Enter a valid email like user@example.com";
                        }
                      }
                      setState(() {

                      });
                    },
                    true,
                    50,
                    "Email"
                ),
                SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: sendIdIsChecked,
                      checkColor: Colors.green,
                      activeColor: Colors.white,

                      onChanged: (bool? newValue) {
                        setState(() {
                          sendIdIsChecked = newValue!;
                        });
                      },
                    ),
                    Text(
                      "Send Customer ID.",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.02,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3),
                Padding(
                  padding: const EdgeInsets.only(left: 35.0,right: 35.0),
                  child: Text(
                    emailMssg,
                    style: TextStyle(
                      color: emailMssgColor,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.height * 0.018,
                    ),
                  ),
                ),
                SizedBox(height: 20),

                //Address
                inputFieldWidget.MultilineInputFieldWithOnChange(
                    context,
                    address,
                    "E.g, 501 Sunshine Tower...etc",
                    Icon(Icons.location_city),
                    TextInputType.streetAddress,
                    Icon(Icons.verified_user,color: addressMssgColor),
                        (value)
                    {
                      print(value);
                      if(value.isEmpty)
                      {
                        addressVerification=false;
                        addressMssgColor=Colors.red;
                        addressMssg="Address is Required";
                      }
                      else
                      {
                        RegExp regExp= RegExp(r'^[a-zA-Z0-9\s,.-]{10,}(?:\s*,\s*[a-zA-Z0-9\s]+)*$');
                        bool match = regExp.hasMatch(value.trim());
                        if(match)
                        {
                          addressVerification=true;
                          addressMssgColor=Colors.green;
                          addressMssg="";
                        }
                        else
                        {
                          addressVerification=false;
                          addressMssgColor=Colors.red;
                          addressMssg="Address must be at least 10 characters long and can only include letters, numbers, spaces, and the special characters , . -";
                        }
                      }
                      setState(() {

                      });
                    },
                    true,
                    200,
                    "Address"
                ),
                SizedBox(height: 2),
                Padding(
                  padding: const EdgeInsets.only(left: 35.0,right: 35.0),
                  child: Text(
                    addressMssg,
                    style: TextStyle(
                      color: addressMssgColor,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.height * 0.018,
                    ),
                  ),
                ),
                SizedBox(height: 20),

                //Add
                this.buttonWidget.ButtonField(
                    context,
                    "Add",
                        () async{
                      String customerID = "";
                      String customerName = "";
                      String phoneNumber = "";
                      String email = "";
                      String address = "";

                      if(this.customerNameVerification && this.phoneNumberVerification && this.emailVerification
                          && this.addressVerification)
                      {
                        customerName = this.customerName.text.toString().trim();
                        phoneNumber = this.phoneNumber.text.toString().trim();
                        email = this.email.text.toString().trim();
                        address = this.address.text.toString().trim();

                        try
                        {
                          customerID = documentIdManage.getCustomerId();
                          Map<String, String> data={
                            "customerid" : customerID,
                            "customername" : customerName,
                            "phonenumber" : phoneNumber,
                            "email" : email,
                            "address" : address,
                            "ownerid" : this.ownerId,
                            "shopid" : this.shopId,
                            "addedby" : this.workerId,
                            "updatedby" : ""
                          };

                          await Future.delayed(Duration(milliseconds: 300));
                          this.toastWidget.showToast("Processing...");

                          await FirebaseFirestore.instance.collection("customer").add(data);

                          if(this.sendIdIsChecked)
                          {
                            bool sendEmailOTP= await otpAuth.sendCustomerId(email, customerID);
                          }

                          await Future.delayed(Duration(milliseconds: 300));
                          this.toastWidget.showToast("Added");

                          Navigator.pop(context);

                        }
                        catch(e)
                        {
                          await Future.delayed(Duration(milliseconds: 300));
                          this.toastWidget.showToast("Try again");
                        }
                      }
                      else
                      {
                        await Future.delayed(Duration(milliseconds: 300));
                        this.toastWidget.showToast("Invalid Credential");
                      }

                      setState(() {

                      });
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