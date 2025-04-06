import 'package:barcode_based_billing_system/firebase/shop_owner_document_id_manage.dart';
import 'package:barcode_based_billing_system/screens/shop_owner/shop_manage/shop_owner_manage_shop_screen.dart';
import 'package:barcode_based_billing_system/widgets/custom_button_widget.dart';
import 'package:barcode_based_billing_system/widgets/custom_input_field_widget.dart';
import 'package:barcode_based_billing_system/widgets/custom_toast_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopOwnerAddShopScreen extends StatefulWidget
{
  @override
  State<StatefulWidget> createState()
  {
    return ShopOwnerAddShopScreenState();
  }
}

class ShopOwnerAddShopScreenState extends State
{
  CustomInputFieldWidget inputFieldWidget = CustomInputFieldWidget();
  CustomButtonWidget buttonWidget = CustomButtonWidget();
  ShopOwnerDocumentIdManage documentIdManage = ShopOwnerDocumentIdManage();
  CustomToastWidget toastWidget = CustomToastWidget();

  TextEditingController shopName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController alternateNumber = TextEditingController();
  TextEditingController telephoneNumber = TextEditingController();
  TextEditingController gst = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController description = TextEditingController();


  String shopNameMssg = "";
  String emailMssg = "";
  String phoneNumberMssg = "";
  String telephoneNumberMssg = "";
  String alternateNumberMssg = "";
  String addressMssg = "";
  String gstMssg = "";
  String descriptionMssg = "";

  Color shopNameMssgColor = Colors.red;
  Color emailMssgColor = Colors.red;
  Color phoneNumberMssgColor = Colors.red;
  Color alternateNumberMssgColor = Colors.red;
  Color telephoneNumberMssgColor = Colors.red;
  Color addressMssgColor = Colors.red;
  Color gstMssgColor = Colors.red;
  Color descriptionMssgColor = Colors.red;

  bool shopNameVerification = false;
  bool emailVerification = false;
  bool phoneNumberVerification = false;
  bool alternateNumberVerification = true;
  bool telephoneNumberVerification = true;
  bool addressVerification = false;
  bool gstVerification = true;
  bool descriptionVerification = true;

  bool emailVisibility = true;
  bool phoneNumberVisibility = true;

  bool emailIsChecked = false;
  bool phoneNumberIsChecked = false;

  String message ="";

  Future<String> getUsername() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString("username").toString();
    return username;
  }


  @override
  Widget build(BuildContext context)
  {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Add Shop",
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
                    Icon(Icons.verified_user,color: shopNameMssgColor),
                    (value) async
                    {
                      print(value);
                      if(value.isEmpty)
                      {
                        shopNameVerification=false;
                        shopNameMssgColor=Colors.red;
                        shopNameMssg="Shop name is required";
                      }
                      else
                      {
                        RegExp regExp= RegExp(r"^[a-zA-Z0-9\s\.\-&']{3,50}$");
                        bool match = regExp.hasMatch(value.trim());
                        if(match)
                        {
                          String username = await getUsername();
                          QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("shop").where("ownerid", isEqualTo: username).where("shopname", isEqualTo: value).get();

                          if(snapshot.docs.isNotEmpty)
                          {
                            shopNameVerification=false;
                            shopNameMssgColor=Colors.red;
                            shopNameMssg="Shop name exists, Choose another for uniquely identifying";
                          }
                          else
                          {
                            shopNameVerification=true;
                            shopNameMssgColor=Colors.green;
                            shopNameMssg="";
                          }
                        }
                        else
                        {
                          shopNameVerification=false;
                          shopNameMssgColor=Colors.red;
                          shopNameMssg="Shop name must be 3-50 characters long and can only include letters, numbers, spaces, and the characters . - & '";
                        }
                      }
                      setState(() {

                      });
                    },
                    true,
                    50,
                    "Shop Name"
                ),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 35.0,right: 35.0),
                  child: Text(
                    shopNameMssg,
                    style: TextStyle(
                      color: shopNameMssgColor,
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
                    emailVisibility,
                    50,
                    "Email"
                ),
                SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: emailIsChecked,
                      checkColor: Colors.green,
                      activeColor: Colors.white,

                      onChanged: (bool? newValue) {
                        setState(() {
                          emailIsChecked = newValue!;
                          if(emailIsChecked)
                          {
                            emailVisibility = false;
                            emailVerification=true;
                            emailMssgColor=Colors.green;
                            emailMssg="";
                            email.text="";
                          }
                          else
                          {
                            emailVisibility = true;
                            emailVerification=false;
                            emailMssgColor=Colors.red;
                            emailMssg="";
                          }
                        });
                      },
                    ),
                    Text(
                      "Same as registered email.",
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
                SizedBox(height: 10),

                //Phone Number
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
                    phoneNumberVisibility,
                    10,
                    "Phone Number"
                ),
                SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: phoneNumberIsChecked,
                      checkColor: Colors.green,
                      activeColor: Colors.white,

                      onChanged: (bool? newValue) {
                        setState(() {
                          phoneNumberIsChecked = newValue!;
                          if(phoneNumberIsChecked)
                          {
                            phoneNumberVisibility = false;
                            phoneNumberVerification=true;
                            phoneNumberMssgColor=Colors.green;
                            phoneNumberMssg="";
                            phoneNumber.text = "";
                          }
                          else
                          {
                            phoneNumberVisibility = true;
                            phoneNumberVerification=false;
                            phoneNumberMssgColor=Colors.red;
                            phoneNumberMssg="";
                          }
                        });
                      },
                    ),
                    Text(
                      "Same as registered Phone Number.",
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
                    phoneNumberMssg,
                    style: TextStyle(
                      color: phoneNumberMssgColor,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.height * 0.018,
                    ),
                  ),
                ),
                SizedBox(height: 10),

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
                    "GSTIN"
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
                    "E.g, 501 Sunshine Tower",
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

                //Add Button
                buttonWidget.ButtonField(
                    context,
                    "Add",
                    () async{

                      String shopName="";
                      String email="";
                      String phoneNumber="";
                      String? alternateNumber="";
                      String address="";
                      String? telephoneNumber="";
                      String? gst="";
                      String? description = "";
                      String username = await getUsername();

                      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("shopowner").where("username",isEqualTo: username).get();

                      if(this.shopNameVerification && this.emailVerification && this.phoneNumberVerification
                          && this.alternateNumberVerification && this.telephoneNumberVerification
                          && this.gstVerification && this.addressVerification && this.descriptionVerification)
                      {
                        shopName = this.shopName.text.toString().trim();

                        if(emailIsChecked && !emailVisibility)
                        {
                          if(snapshot.docs.isNotEmpty)
                          {
                            var document = snapshot.docs.first;
                            email = document["email"].toString();
                          }
                          else
                          {
                            this.message += "Unable to get the email! ";
                          }
                        }
                        else
                        {
                          email = this.email.text.toString().trim();
                        }

                        if(phoneNumberIsChecked && !phoneNumberVisibility)
                        {
                          if(snapshot.docs.isNotEmpty)
                          {
                            var document = snapshot.docs.first;
                            phoneNumber = document["phonenumber"];
                          }
                          else
                          {
                            this.message += "Unable to get the phone number! ";
                          }
                        }
                        else
                        {
                          phoneNumber = this.phoneNumber.text.toString().trim();
                        }

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

                        address = this.address.text.toString().trim();

                        if(shopName.isNotEmpty && email.isNotEmpty && phoneNumber.isNotEmpty
                            && address.isNotEmpty)
                        {
                          final String _shopId = documentIdManage.generateShopDocumentId(username, shopName);
                          Map<String, String> data = {
                            'shopid': _shopId,
                            'shopname':shopName,
                            'email':email,
                            'phonenumber': phoneNumber,
                            'alternatenumber':alternateNumber ?? "",
                            'telephonenumber': telephoneNumber ?? "",
                            'gstin': gst ?? "",
                            'address': address,
                            "description" : description ?? "",
                            'ownerid': username
                          };
                          try
                          {
                            await FirebaseFirestore.instance.collection("shop").add(data);

                            this.shopName.text = "";
                            this.email.text = "";
                            this.phoneNumber.text = "";
                            this.alternateNumber.text = "";
                            this.telephoneNumber.text = "";
                            this.gst.text = "";
                            this.address.text = "";
                            this.description.text = "";


                            this.shopNameMssg = "";
                            this.emailMssg = "";
                            this.phoneNumberMssg = "";
                            this.alternateNumberMssg = "";
                            this.telephoneNumberMssg = "";
                            this.gstMssg = "";
                            this.addressMssg = "";
                            this.descriptionMssg = "";

                            this.shopNameMssgColor = Colors.red;
                            this.emailMssgColor = Colors.red;
                            this.phoneNumberMssgColor = Colors.red;
                            this.alternateNumberMssgColor = Colors.red;
                            this.telephoneNumberMssgColor = Colors.red;
                            this.gstMssgColor = Colors.red;
                            this.addressMssgColor = Colors.red;
                            this.descriptionMssgColor = Colors.red;

                            this.shopNameVerification = false;
                            this.emailVerification = false;
                            this.phoneNumberVerification = false;
                            this.alternateNumberVerification = true;
                            this.telephoneNumberVerification = true;
                            this.gstVerification = true;
                            this.addressVerification = false;
                            this.descriptionVerification = true;

                            this.emailVisibility = true;
                            this.phoneNumberVisibility = true;

                            this.emailIsChecked = false;
                            this.phoneNumberIsChecked = false;

                            this.message += "Shop Added";
                          }
                          catch(e)
                          {
                            this.message += "Try Again!";
                          }
                        }
                        else
                        {
                          this.message += "Try Again!";
                        }
                      }
                      else
                      {
                        this.message += "Check Credential!";
                      }
                      toastWidget.showToast(this.message);
                      setState(() {
                        this.message = "";
                      });
                    }
                ),
                SizedBox(height: 30)
              ],
            ),
          ),
        ),
      ),
    );
  }

}