import 'package:barcode_based_billing_system/screens/shop_owner/shop_manage/shop_owner_manage_shop_screen.dart';
import 'package:barcode_based_billing_system/widgets/custom_button_widget.dart';
import 'package:barcode_based_billing_system/widgets/custom_input_field_widget.dart';
import 'package:barcode_based_billing_system/widgets/custom_toast_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShopOwnerUpdateShopScreen extends StatefulWidget
{
  final String ownerid, shopname, email, phonenumber, address;
  final String? telephonenumber;
  final String? alternatenumber;
  final String? gst;
  final String? description;
  ShopOwnerUpdateShopScreen(this.ownerid, this.shopname, this.email, this.phonenumber, this.telephonenumber, this.address, this.alternatenumber, this.gst, this.description);

  @override
  State<StatefulWidget> createState()
  {
    return ShopOwnerUpdateShopScreenState();
  }
}

class ShopOwnerUpdateShopScreenState extends State<ShopOwnerUpdateShopScreen>
{
  CustomInputFieldWidget inputFieldWidget = CustomInputFieldWidget();
  CustomButtonWidget buttonWidget = CustomButtonWidget();
  CustomToastWidget toastWidget = CustomToastWidget();

  TextEditingController shopName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController alternateNumber = TextEditingController();
  TextEditingController telephoneNumber = TextEditingController();
  TextEditingController gst = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController description = TextEditingController();

  String emailMssg = "";
  String phoneNumberMssg = "";
  String alternateNumberMssg = "";
  String telephoneNumberMssg = "";
  String gstMssg = "";
  String addressMssg = "";
  String descriptionMssg = "";

  Color emailMssgColor = Colors.green;
  Color phoneNumberMssgColor = Colors.green;
  Color alternateNumberMssgColor = Colors.green;
  Color telephoneNumberMssgColor = Colors.green;
  Color gstMssgColor = Colors.green;
  Color addressMssgColor = Colors.green;
  Color descriptionMssgColor = Colors.green;

  bool shopNameVerification = true;
  bool emailVerification = true;
  bool phoneNumberVerification = true;
  bool alternateNumberVerification = true;
  bool telephoneNumberVerification = true;
  bool gstVerification = true;
  bool addressVerification = true;
  bool descriptionVerification = true;

  String message ="";


  @override
  void initState()
  {
    super.initState();
    shopName.text = widget.shopname.toString();
    email.text = widget.email.toString();
    phoneNumber.text = widget.phonenumber.toString();
    alternateNumber.text = widget.alternatenumber.toString();
    telephoneNumber.text = widget.telephonenumber.toString();
    gst.text = widget.gst.toString();
    address.text = widget.address.toString();
    description.text = widget.description.toString();
  }

  @override
  Widget build(BuildContext context)
  {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Update Shop",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
              onPressed: (){
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context)=>ShopOwnerManageShopScreen()
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                SizedBox(height: 50,),
                //Name
                inputFieldWidget.NormalInputFieldWithOnChange(
                    context,
                    shopName,
                    "E.g, NS Medical Store",
                    Icon(Icons.shop),
                    TextInputType.text,
                    Icon(Icons.verified_user,color: Colors.green),
                    (value)
                    {
                    },
                    false,
                    50,
                    "Shop Name"
                ),
                SizedBox(height: 25),

                //Email
                inputFieldWidget.NormalInputFieldWithOnChange(
                    context,
                    email,
                    "E.g, user@example.com",
                    Icon(Icons.email),
                    TextInputType.emailAddress,
                    Icon(Icons.verified_user,color: emailMssgColor),
                    (value) async
                    {
                      print(value);
                      if(value.isEmpty)
                      {
                        emailVerification=false;
                        emailMssgColor=Colors.red;
                        emailMssg="Email is required";
                      }
                      else
                      {
                        RegExp regExp= RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                        bool match = regExp.hasMatch(value.trim());
                        if(match)
                        {
                          emailVerification=true;
                          emailMssgColor=Colors.green;
                          emailMssg="";
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

                inputFieldWidget.NormalInputFieldWithOnChange(
                    context,
                    phoneNumber,
                    "E.g, 1234567890",
                    Icon(Icons.phone),
                    TextInputType.phone,
                    Icon(Icons.verified_user,color: phoneNumberMssgColor),
                    (value) async
                    {
                      print(value);
                      if(value.isEmpty)
                      {
                        phoneNumberVerification=false;
                        phoneNumberMssgColor=Colors.red;
                        phoneNumberMssg="Phone Number is required";
                      }
                      else
                      {
                        RegExp regExp= RegExp(r'^\d{10}$');
                        bool match = regExp.hasMatch(value.trim());
                        if(match)
                        {
                          phoneNumberVerification=true;
                          phoneNumberMssgColor=Colors.green;
                          phoneNumberMssg="";
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
                SizedBox(height: 2),
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

                //Alternate Number
                inputFieldWidget.NormalInputFieldWithOnChange(
                    context,
                    alternateNumber,
                    "E.g, 1234567890 (Optional)",
                    Icon(Icons.phone),
                    TextInputType.phone,
                    Icon(null),
                    (value) async
                    {
                      print(value);
                      if(value.isEmpty)
                      {
                        alternateNumberVerification=true;
                        alternateNumberMssgColor=Colors.green;
                        alternateNumberMssg="";
                      }
                      else
                      {
                        RegExp regExp= RegExp(r'^\d{10}$');
                        bool match = regExp.hasMatch(value.trim());
                        if(match)
                        {
                          alternateNumberVerification=true;
                          alternateNumberMssgColor=Colors.green;
                          alternateNumberMssg="";
                        }
                        else
                        {
                          alternateNumberVerification=false;
                          alternateNumberMssgColor=Colors.red;
                          alternateNumberMssg="It must be exactly 10 digits without spaces or special characters";
                        }
                      }
                      setState(() {

                      });
                    },
                    true,
                    10,
                    "Alternate Number"
                ),
                SizedBox(height: 2),
                Padding(
                  padding: const EdgeInsets.only(left: 35.0,right: 35.0),
                  child: Text(
                    alternateNumberMssg,
                    style: TextStyle(
                      color: alternateNumberMssgColor,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.height * 0.018,
                    ),
                  ),
                ),
                SizedBox(height: 20),

                //Telephone
                inputFieldWidget.NormalInputFieldWithOnChange(
                    context,
                    telephoneNumber,
                    "E.g, 022-123456 (Optional)",
                    Icon(Icons.phone),
                    TextInputType.phone,
                    Icon(null),
                    (value) async
                    {
                      print(value);
                      if(value.isEmpty)
                      {
                        telephoneNumberVerification=true;
                        telephoneNumberMssgColor=Colors.green;
                        telephoneNumberMssg="";
                      }
                      else
                      {
                        RegExp regExp= RegExp(r'^\d{3,5}[-\s]?\d{6,8}$');
                        bool match = regExp.hasMatch(value.trim());
                        if(match)
                        {
                          telephoneNumberVerification=true;
                          telephoneNumberMssgColor=Colors.green;
                          telephoneNumberMssg="";
                        }
                        else
                        {
                          telephoneNumberVerification=false;
                          telephoneNumberMssgColor=Colors.red;
                          telephoneNumberMssg="Please enter a valid Indian landline number (e.g., 022-1234567 or 040 12345678)";
                        }
                      }
                      setState(() {

                      });
                    },
                    true,
                    12,
                    "Telephone Number"
                ),
                SizedBox(height: 2),
                Padding(
                  padding: const EdgeInsets.only(left: 35.0,right: 35.0),
                  child: Text(
                    telephoneNumberMssg,
                    style: TextStyle(
                      color: telephoneNumberMssgColor,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.height * 0.018,
                    ),
                  ),
                ),
                SizedBox(height: 20),

                //GSTIN
                inputFieldWidget.NormalInputFieldWithOnChange(
                    context,
                    gst,
                    "E.g, 27ABCDE1234F1Z5 (Optional)",
                    Icon(Icons.numbers),
                    TextInputType.text,
                    Icon(null),
                        (value) async
                    {
                      print(value);
                      if(value.isEmpty)
                      {
                        gstVerification=true;
                        gstMssgColor=Colors.green;
                        gstMssg="";
                      }
                      else
                      {
                        RegExp regExp= RegExp(r'^\d{2}[A-Z]{5}\d{4}[A-Z]{1}[A-Z\d]{1}[Z]{1}[A-Z\d]{1}$');
                        bool match = regExp.hasMatch(value.trim());
                        if(match)
                        {
                          gstVerification=true;
                          gstMssgColor=Colors.green;
                          gstMssg="";
                        }
                        else
                        {
                          gstVerification=false;
                          gstMssgColor=Colors.red;
                          gstMssg="The GST Number entered is invalid. Ensure it is a 15-character alphanumeric code in the correct format (e.g., 27ABCDE1234F1Z5)";
                        }
                      }
                      setState(() {

                      });
                    },
                    true,
                    15,
                    "27ABCDE1234F1Z5"
                ),
                SizedBox(height: 2),
                Padding(
                  padding: const EdgeInsets.only(left: 35.0,right: 35.0),
                  child: Text(
                    gstMssg,
                    style: TextStyle(
                      color: gstMssgColor,
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
                    (value) async
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

                //Description
                inputFieldWidget.MultilineInputFieldWithOnChange(
                    context,
                    description,
                    "",
                    Icon(Icons.description),
                    TextInputType.text,
                    Icon(null),
                        (value) async
                    {
                      print(value);
                      if(value.isEmpty)
                      {
                        descriptionVerification=true;
                        descriptionMssgColor=Colors.red;
                        descriptionMssg="";
                      }
                      else
                      {
                        RegExp regExp= RegExp(r"^[a-zA-Z0-9\s.,!?@#$%^&*()_+=-]{10,}$");
                        bool match = regExp.hasMatch(value.trim());
                        if(match)
                        {
                          descriptionVerification=true;
                          descriptionMssgColor=Colors.green;
                          descriptionMssg="";
                        }
                        else
                        {
                          descriptionVerification=false;
                          descriptionMssgColor=Colors.red;
                          descriptionMssg="Description must be at least 10 characters and may include letters, numbers, spaces, and certain symbols";
                        }
                      }
                      setState(() {

                      });
                    },
                    true,
                    300,
                    "Description for Bill"
                ),
                SizedBox(height: 2),
                Padding(
                  padding: const EdgeInsets.only(left: 35.0,right: 35.0),
                  child: Text(
                    descriptionMssg,
                    style: TextStyle(
                      color: descriptionMssgColor,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.height * 0.018,
                    ),
                  ),
                ),
                SizedBox(height: 20),

                //Update Button
                buttonWidget.ButtonField(
                    context,
                    "Update",
                    () async{
                      String shopName = widget.shopname;
                      String email=this.email.text.toString().trim();
                      String phoneNumber=this.phoneNumber.text.toString().trim();
                      String address=this.address.text.toString().trim();
                      String? telephoneNumber;
                      String? alternateNumber;
                      String? description = "";
                      String? gst;

                      if(this.telephoneNumber.text.toString().trim().isEmpty)
                      {
                        telephoneNumber = null;
                      }
                      else
                      {
                        telephoneNumber = this.telephoneNumber.text.toString().trim();
                      }

                      if(this.alternateNumber.text.toString().trim().isEmpty)
                      {
                        alternateNumber = null;
                      }
                      else
                      {
                        alternateNumber = this.alternateNumber.text.toString().trim();
                      }

                      if(this.gst.text.toString().trim().isEmpty)
                      {
                        gst = null;
                      }
                      else
                      {
                        gst = this.gst.text.toString().trim();
                      }

                      if(this.description.text.toString().trim().isEmpty)
                      {
                        description = null;
                      }
                      else
                      {
                        description = this.description.text.toString().trim();
                      }

                      String ownerid = widget.ownerid;

                      if(shopNameVerification && emailVerification && phoneNumberVerification
                      && addressVerification && telephoneNumberVerification && alternateNumberVerification
                      && gstVerification && descriptionVerification)
                      {
                        Map<String, String> data = {
                          'email':email,
                          'phonenumber': phoneNumber,
                          'alternatenumber' : alternateNumber ?? "",
                          'telephonenumber': telephoneNumber ?? "",
                          'gstin' : gst ?? "",
                          "description" : description ?? "",
                          'address': address,
                        };

                        try
                        {
                          QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("shop").where("ownerid",isEqualTo: ownerid).where("shopname",isEqualTo: shopName).get();
                          if(snapshot.docs.isNotEmpty)
                          {
                            var document = snapshot.docs.first.reference;

                            await document.update(data);

                            await Future.delayed(Duration(milliseconds: 300));
                            toastWidget.showToast("Updated");
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context)=>ShopOwnerManageShopScreen()
                              )
                            );
                          }
                        }
                        catch(e)
                        {
                          await Future.delayed(Duration(milliseconds: 300));
                          toastWidget.showToast("Try again!");
                        }
                      }
                      else
                      {
                        await Future.delayed(Duration(milliseconds: 300));
                        toastWidget.showToast("Try again!");
                      }
                    }
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        )
      ),
    );
  }

}