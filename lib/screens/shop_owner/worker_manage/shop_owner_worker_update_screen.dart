import 'package:barcode_based_billing_system/firebase/shop_owner_document_id_manage.dart';
import 'package:barcode_based_billing_system/screens/shop_owner/worker_manage/shop_owner_manage_worker_screen.dart';
import 'package:barcode_based_billing_system/widgets/custom_button_widget.dart';
import 'package:barcode_based_billing_system/widgets/custom_input_field_widget.dart';
import 'package:barcode_based_billing_system/widgets/custom_toast_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class ShopOwnerWorkerUpdateScreen extends StatefulWidget
{
  final String ownerId;
  final String shopId;
  final String workerId;
  final String workerName;
  final String phoneNumber;
  final String email;
  final String address;
  final String description;
  final String password;
  final Map<String, List<String>> accessField;

  ShopOwnerWorkerUpdateScreen(this.ownerId, this.shopId, this.workerId, this.workerName,
      this.phoneNumber, this.email, this.address, this.description, this.accessField, this.password);

  @override
  State<StatefulWidget> createState()
  {
    return ShopOwnerWorkerUpdateScreenState();
  }
}
class ShopOwnerWorkerUpdateScreenState extends State<ShopOwnerWorkerUpdateScreen>
{
  CustomInputFieldWidget inputFieldWidget =CustomInputFieldWidget();
  CustomButtonWidget buttonWidget = CustomButtonWidget();
  CustomToastWidget toastWidget = CustomToastWidget();
  ShopOwnerDocumentIdManage documentIdManage = ShopOwnerDocumentIdManage();

  String ownerId = "";
  String shopId = "";
  String workerId = "";

  List<String> accessField = ["Product", "Customer", "Scan Bill", "Bill", "Inventory"];
  List<String> selectedAccessField = [];

  List<String> productAccessField = ["Add Product", "Update Product", "View Product", "Delete Product"];
  List<String> customerAccessField = ["Add Customer", "Update Customer", "View Customer", "Delete Customer"];
  List<String> billAccessField = ["View Bill", "Delete Bill"];

  List<String> selectedProductAccessField = [];
  List<String> selectedCustomerAccessField = [];
  List<String> selectedBillAccessField = [];

  TextEditingController workerName = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  String workerNameMssg = "";
  String phoneNumberMssg = "";
  String emailMssg = "";
  String addressMssg = "";
  String descriptionMssg = "";
  String passwordMssg = "";
  String confirmPasswordMssg = "";

  Color workerNameMssgColor = Colors.green;
  Color phoneNumberMssgColor = Colors.green;
  Color emailMssgColor = Colors.green;
  Color addressMssgColor = Colors.green;
  Color descriptionMssgColor = Colors.green;
  Color passwordMssgColor = Colors.green;
  Color confirmPasswordMssgColor = Colors.green;

  bool workerNameVerification = true;
  bool phoneNumberVerification = true;
  bool emailVerification = true;
  bool addressVerification = true;
  bool descriptionVerification = true;
  bool passwordVerification = true;
  bool confirmPasswordVerification = true;

  Color passwordVisibilityColor = Colors.green;
  bool passwordVisibility = true;

  Color confirmPasswordVisibilityColor = Colors.green;
  bool confirmPasswordVisibility = true;

  @override
  void initState()
  {
    super.initState();
    this.ownerId = widget.ownerId;
    this.shopId = widget.shopId;
    this.workerId = widget.workerId;
    this.workerName.text = widget.workerName;
    this.phoneNumber.text = widget.phoneNumber;
    this.email.text = widget.email;
    this.address.text = widget.address;
    this.description.text = widget.description;
    this.password.text = widget.password;
    this.confirmPassword.text = widget.password;
    widget.accessField.forEach((key, value) {
      this.selectedAccessField.add(key);
      if(key=="Product")
      {
        this.selectedProductAccessField.addAll(value);
      }
      if(key=="Customer")
      {
        this.selectedCustomerAccessField.addAll(value);
      }
      if(key=="Bill")
      {
        this.selectedBillAccessField.addAll(value);
      }
    });
  }

  @override
  Widget build(BuildContext context)
  {
    return PopScope(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Update Worker",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
              onPressed: (){
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context)=>ShopOwnerManageWorkerScreen()
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

                SizedBox(height: 15),
                //Optional Product Field List
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: MultiSelectDialogField(
                      items: accessField
                          .map((product) => MultiSelectItem<String>(product, product))
                          .toList(),
                      title: Text("Allow Access"),
                      selectedColor: Colors.green,
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).primaryColor),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      initialValue: this.selectedAccessField,
                      buttonIcon: Icon(Icons.arrow_drop_down, color: Colors.black, size: 30,),
                      buttonText: Text("Access Permission", style: TextStyle(color: Colors.black, fontSize: 16),),
                      onConfirm: (selected) async{
                        setState((){
                          this.selectedAccessField = List<String>.from(selected);
                          print(this.selectedAccessField.toString());
                        });
                      },
                      chipDisplay: MultiSelectChipDisplay.none(),
                      backgroundColor: Colors.white,
                      dialogHeight: MediaQuery.of(context).size.height * 0.3,
                    ),
                  ),
                ),
                SizedBox(height: 30),

                //Worker Name
                inputFieldWidget.NormalInputFieldWithOnChange(
                    context,
                    workerName,
                    "E.g, Shaikh Nadim",
                    Icon(Icons.person),
                    TextInputType.text,
                    Icon(Icons.verified_user, color: workerNameMssgColor,),
                        (value)
                    {
                      if(value.isEmpty)
                      {
                        workerNameVerification = false;
                        workerNameMssgColor = Colors.red;
                        workerNameMssg = "Field is required";
                      }
                      else
                      {
                        RegExp regExp= RegExp(r'^[A-Za-z\s]{3,}$');
                        bool match = regExp.hasMatch(value.trim());

                        if(match)
                        {
                          workerNameVerification = true;
                          workerNameMssgColor = Colors.green;
                          workerNameMssg = "";
                        }
                        else
                        {
                          workerNameVerification = false;
                          workerNameMssgColor = Colors.red;
                          workerNameMssg = "Invalid worker name. The name must contain at least 3 characters and can only include letters and spaces.";
                        }
                      }
                      setState(() {

                      });
                    },
                    true,
                    30,
                    "Worker Name"
                ),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 35.0,right: 35.0),
                  child: Text(
                    workerNameMssg,
                    style: TextStyle(
                      color: workerNameMssgColor,
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
                    Icon(Icons.verified_user, color: phoneNumberMssgColor,),
                        (value) async
                    {
                      print(value);
                      if(value.isEmpty)
                      {
                        phoneNumberVerification=false;
                        phoneNumberMssgColor=Colors.red;
                        phoneNumberMssg="Field is required.";
                      }
                      else
                      {
                        RegExp regExp= RegExp(r'^\d{10}$');
                        bool match = regExp.hasMatch(value.trim());
                        if(match)
                        {
                          QuerySnapshot  snapshot = await FirebaseFirestore.instance.collection("worker")
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
                          QuerySnapshot  snapshot = await FirebaseFirestore.instance.collection("worker")
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
                SizedBox(height: 5),
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

                //Description
                inputFieldWidget.MultilineInputFieldWithOnChange(
                    context,
                    description,
                    "",
                    Icon(Icons.description),
                    TextInputType.text,
                    Icon(null),
                        (value)
                    {
                      if(value.isEmpty)
                      {
                        descriptionVerification = true;
                        descriptionMssgColor = Colors.green;
                        descriptionMssg = "";
                      }
                      else
                      {
                        RegExp regExp = RegExp(r"^[a-zA-Z0-9\s.,!?@#$%^&*()_+=-]{10,}$");

                        bool match = regExp.hasMatch(value.trim());

                        if(match)
                        {
                          descriptionVerification = true;
                          descriptionMssgColor = Colors.green;
                          descriptionMssg = "";
                        }
                        else
                        {
                          descriptionVerification = false;
                          descriptionMssgColor = Colors.red;
                          descriptionMssg = "Description must be at least 10 characters and may include letters, numbers, spaces, and certain symbols";
                        }
                      }
                      setState(() {

                      });
                    },
                    true,
                    100,
                    "Description"
                ),
                SizedBox(height: 5),
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

                //Password Input
                inputFieldWidget.PasswordInputFieldWithOnChange(
                  context,
                  password,
                  "",
                  Icon(Icons.password),
                  passwordVisibility,
                  IconButton(
                    icon: Icon(Icons.remove_red_eye, color: passwordVisibilityColor),
                    onPressed: (){
                      if(passwordVisibility==true)
                      {
                        passwordVisibility=false;
                        passwordVisibilityColor=Colors.red;
                      }
                      else
                      {
                        passwordVisibility=true;
                        passwordVisibilityColor=Colors.green;
                      }
                      setState(() {

                      });
                    },
                  ),
                  (value)
                  {
                    print(value);
                    if(value.isEmpty)
                    {
                      passwordVerification=false;
                      passwordMssgColor=Colors.red;
                      passwordMssg="Password is required";
                    }
                    else
                    {
                      RegExp regExp = RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)(?=.*[@_])[a-zA-Z\d@_]{6,}$');
                      bool match = regExp.hasMatch(value);
                      if(match)
                      {
                        passwordVerification=true;
                        passwordMssgColor=Colors.green;
                        passwordMssg="";
                      }
                      else
                      {
                        passwordVerification=false;
                        passwordMssgColor=Colors.red;
                        passwordMssg="Must have at least one letter, one number, one special character (@ or _), and no spaces";
                      }
                    }
                    setState(() {

                    });
                  },
                  "Password"
                ),
                SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.only(left: 35.0,right: 35.0),
                  child: Text(
                    passwordMssg,
                    style: TextStyle(
                        color: passwordMssgColor,
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.height * 0.018
                    ),
                  ),
                ),
                SizedBox(height: 20),

                //Confirm Password Input
                inputFieldWidget.PasswordInputFieldWithOnChange(
                  context,
                  confirmPassword,
                  "Confirm Password",
                  Icon(Icons.password),
                  confirmPasswordVisibility,
                  IconButton(
                    icon: Icon(Icons.remove_red_eye, color: confirmPasswordVisibilityColor),
                    onPressed: (){
                      if(confirmPasswordVisibility==true)
                      {
                        confirmPasswordVisibility=false;
                        confirmPasswordVisibilityColor=Colors.red;
                      }
                      else
                      {
                        confirmPasswordVisibility=true;
                        confirmPasswordVisibilityColor=Colors.green;
                      }
                      setState(() {

                      });
                    },
                  ),
                      (value)
                  {
                    print(value);

                    if(value.isEmpty)
                    {
                      confirmPasswordVerification=false;
                      confirmPasswordMssgColor=Colors.red;
                      confirmPasswordMssg="Field is required";
                    }
                    else
                    {
                      if(password.text.toString()==confirmPassword.text.toString())
                      {
                        confirmPasswordVerification=true;
                        confirmPasswordMssgColor=Colors.green;
                        confirmPasswordMssg="";
                      }
                      else
                      {
                        confirmPasswordVerification=false;
                        confirmPasswordMssgColor=Colors.red;
                        confirmPasswordMssg="Passwords do not match. Ensure both fields are the same";
                      }
                    }
                    setState(() {

                    });
                  },
                  "Confirm Password"
                ),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 35.0,right: 35.0),
                  child: Text(
                    confirmPasswordMssg,
                    style: TextStyle(
                        color: confirmPasswordMssgColor,
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.height * 0.018
                    ),
                  ),
                ),
                SizedBox(height: 25),

                //Product Access
                if(this.selectedAccessField.contains("Product")) Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: MultiSelectDialogField(
                    items: productAccessField
                        .map((product) => MultiSelectItem<String>(product, product))
                        .toList(),
                    title: Text("Allow Product Access"),
                    selectedColor: Colors.green,
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    initialValue: this.selectedProductAccessField,
                    buttonIcon: Icon(Icons.arrow_drop_down, color: Colors.black, size: 30,),
                    buttonText: Text("Product Access", style: TextStyle(color: Colors.black, fontSize: 16),),
                    onConfirm: (selected) async{
                      setState((){
                        this.selectedProductAccessField = List<String>.from(selected);
                        print(this.selectedProductAccessField.toString());
                      });
                    },
                    chipDisplay: MultiSelectChipDisplay.none(),
                    backgroundColor: Colors.white,
                    dialogHeight: MediaQuery.of(context).size.height * 0.3,
                  ),
                ),
                if(this.selectedAccessField.contains("Product")) SizedBox(height: 5),
                if(this.selectedProductAccessField.isEmpty && this.selectedAccessField.contains("Product")) Padding(
                  padding: const EdgeInsets.only(left: 35.0,right: 35.0),
                  child: Text(
                    "Select the Product Access",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.height * 0.018,
                    ),
                  ),
                ),
                if(this.selectedAccessField.contains("Product")) SizedBox(height: 20),

                //Customer Access
                if(this.selectedAccessField.contains("Customer")) Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: MultiSelectDialogField(
                    items: customerAccessField
                        .map((product) => MultiSelectItem<String>(product, product))
                        .toList(),
                    title: Text("Allow Customer Access"),
                    selectedColor: Colors.green,
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    initialValue: this.selectedCustomerAccessField,
                    buttonIcon: Icon(Icons.arrow_drop_down, color: Colors.black, size: 30,),
                    buttonText: Text("Customer Access", style: TextStyle(color: Colors.black, fontSize: 16),),
                    onConfirm: (selected) async{
                      setState((){
                        this.selectedCustomerAccessField = List<String>.from(selected);
                        print(this.selectedCustomerAccessField.toString());
                      });
                    },
                    chipDisplay: MultiSelectChipDisplay.none(),
                    backgroundColor: Colors.white,
                    dialogHeight: MediaQuery.of(context).size.height * 0.3,
                  ),
                ),
                if(this.selectedAccessField.contains("Customer")) SizedBox(height: 5),
                if(this.selectedCustomerAccessField.isEmpty && this.selectedAccessField.contains("Customer")) Padding(
                  padding: const EdgeInsets.only(left: 35.0,right: 35.0),
                  child: Text(
                    "Select the Customer Access",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.height * 0.018,
                    ),
                  ),
                ),
                if(this.selectedAccessField.contains("Customer")) SizedBox(height: 20),

                //Bill Access
                if(this.selectedAccessField.contains("Bill")) Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: MultiSelectDialogField(
                    items: billAccessField
                        .map((product) => MultiSelectItem<String>(product, product))
                        .toList(),
                    title: Text("Allow Bill Access"),
                    selectedColor: Colors.green,
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    initialValue: this.selectedBillAccessField,
                    buttonIcon: Icon(Icons.arrow_drop_down, color: Colors.black, size: 30,),
                    buttonText: Text("Bill Access", style: TextStyle(color: Colors.black, fontSize: 16),),
                    onConfirm: (selected) async{
                      setState((){
                        this.selectedBillAccessField = List<String>.from(selected);
                        print(this.selectedBillAccessField.toString());
                      });
                    },
                    chipDisplay: MultiSelectChipDisplay.none(),
                    backgroundColor: Colors.white,
                    dialogHeight: MediaQuery.of(context).size.height * 0.3,
                  ),
                ),
                if(this.selectedAccessField.contains("Bill")) SizedBox(height: 5),
                if(this.selectedBillAccessField.isEmpty && this.selectedAccessField.contains("Bill")) Padding(
                  padding: const EdgeInsets.only(left: 35.0,right: 35.0),
                  child: Text(
                    "Select the Bill Access",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.height * 0.018,
                    ),
                  ),
                ),
                if(this.selectedAccessField.contains("Bill")) SizedBox(height: 20),

                //Update Button
                buttonWidget.ButtonField(
                    context,
                    "Update",
                    () async
                    {
                      String workerName = "";
                      String phoneNumber = "";
                      String email = "";
                      String address = "";
                      String description = "";
                      Map<String, List<String>> accessField = {};
                      String password = "";
                      String confirmPassword = "";

                      if(this.workerNameVerification && this.phoneNumberVerification
                          && this.emailVerification && this.passwordVerification
                          && this.confirmPasswordVerification
                          && this.addressVerification && this.descriptionVerification
                          && this.selectedAccessField.isNotEmpty)
                      {
                        workerName = this.workerName.text.toString().trim();
                        phoneNumber = this.phoneNumber.text.toString().trim();
                        email = this.email.text.toString().trim();
                        address = this.address.text.toString().trim();

                        if(this.description.text.toString().trim().isNotEmpty)
                        {
                          description = this.description.text.toString().trim();
                        }
                        else
                        {
                          description = "";
                        }

                        if(this.password.text.toString().trim()==this.confirmPassword.text.toString().trim())
                        {
                          password = this.password.text.toString().trim();
                          confirmPassword = this.confirmPassword.text.toString().trim();
                        }
                        else
                        {
                          await Future.delayed(Duration(milliseconds: 200));
                          this.toastWidget.showToast("Password not match");
                          return;
                        }

                        if(this.selectedAccessField.contains("Product"))
                        {
                          if(this.selectedProductAccessField.isEmpty)
                          {
                            await Future.delayed(Duration(milliseconds: 200));
                            this.toastWidget.showToast("Select the Product Access");
                            return;
                          }
                          else
                          {
                            accessField["Product"] = List<String>.from(this.selectedProductAccessField);
                          }
                        }

                        if(this.selectedAccessField.contains("Customer"))
                        {
                          if(this.selectedCustomerAccessField.isEmpty)
                          {
                            await Future.delayed(Duration(milliseconds: 200));
                            this.toastWidget.showToast("Select the Customer Access");
                            return;
                          }
                          else
                          {
                            accessField["Customer"] = List<String>.from(this.selectedCustomerAccessField);
                          }
                        }

                        if(this.selectedAccessField.contains("Scan Bill"))
                        {
                          accessField["Scan Bill"] = List<String>.from(["Scan Bill"]);
                        }

                        if(this.selectedAccessField.contains("Bill"))
                        {
                          if(this.selectedBillAccessField.isEmpty)
                          {
                            await Future.delayed(Duration(milliseconds: 200));
                            this.toastWidget.showToast("Select the Bill Access");
                            return;
                          }
                          else
                          {
                            accessField["Bill"] = List<String>.from(this.selectedBillAccessField);
                          }
                        }

                        if(this.selectedAccessField.contains("Inventory"))
                        {
                          accessField["Inventory"] = List<String>.from(["Inventory"]);
                        }

                        try
                        {
                          Map<String, dynamic> data = {
                            "workername" : workerName,
                            "phonenumber" : phoneNumber,
                            "email" : email,
                            "address" : address,
                            "description" : description,
                            "accessField" : accessField,
                            "password" : confirmPassword,
                            "isupdate" : "1"
                          };

                          await Future.delayed(Duration(milliseconds: 300));
                          this.toastWidget.showToast("Processing...");

                          QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("worker")
                              .where("ownerid",isEqualTo: this.ownerId)
                              .where("shopid",isEqualTo: this.shopId)
                              .where("workerid", isEqualTo: this.workerId)
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
                                    builder: (context)=>ShopOwnerManageWorkerScreen()
                                )
                            );
                          }
                          else
                          {
                            await Future.delayed(Duration(milliseconds: 300));
                            toastWidget.showToast("Try Again");
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context)=>ShopOwnerManageWorkerScreen()
                                )
                            );
                          }
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
                SizedBox(height: 30,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}