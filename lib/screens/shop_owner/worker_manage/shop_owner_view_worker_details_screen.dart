import 'package:barcode_based_billing_system/screens/shop_owner/worker_manage/shop_owner_manage_worker_screen.dart';
import 'package:barcode_based_billing_system/widgets/custom_input_field_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShopOwnerViewWorkerDetailsScreen extends StatefulWidget
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
  final String firstLogin;
  final String loggedIn;
  Map<String, List<String>> accessField;

  ShopOwnerViewWorkerDetailsScreen(this.ownerId, this.shopId, this.workerId, this.workerName,
      this.phoneNumber, this.email, this.address, this.description, this.accessField,
      this.password, this.firstLogin, this.loggedIn);

  @override
  State<StatefulWidget> createState()
  {
    return ShopOwnerViewWorkerDetailsScreenState();
  }
}

class ShopOwnerViewWorkerDetailsScreenState extends State<ShopOwnerViewWorkerDetailsScreen>
{
  CustomInputFieldWidget inputFieldWidget = CustomInputFieldWidget();

  TextEditingController password = TextEditingController();

  Color passwordColor = Colors.green;

  bool passwordVisibility = true;

  String ownerId = "";
  String shopId = "";
  String workerId = "";
  String workerName = "";
  String phoneNumber = "";
  String email = "";
  String address = "";
  String description = "";
  String firstLogin = "";
  String loggedIn = "";
  Map<String, List<String>> accessField = {};
  String firstLoginMssg = "";
  String loggedInMssg = "";

  @override
  void initState()
  {
    super.initState();
    this.ownerId = widget.ownerId;
    this.shopId = widget.shopId;
    this.workerId = widget.workerId;
    this.workerName = widget.workerName;
    this.phoneNumber = widget.phoneNumber;
    this.email = widget.email;
    this.address = widget.address;
    this.description = widget.description;
    this.password.text = widget.password;
    this.firstLogin= widget.firstLogin;
    this.loggedIn = widget.loggedIn;
    this.accessField = widget.accessField;

    if(int.parse(widget.firstLogin.toString())==1)
    {
      this.firstLoginMssg = "Not Done";
    }
    else
    {
      this.firstLoginMssg = "Done";
    }

    if(int.parse(widget.loggedIn.toString())==1)
    {
      this.loggedInMssg = "Yes";
    }
    else
    {
      this.loggedInMssg = "No";
    }
  }


  @override
  Widget build(BuildContext context)
  {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Worker Details",
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
          padding: EdgeInsets.only(left: 25, right: 25),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                SizedBox(height: 30),

                //Password Show
                inputFieldWidget.WorkerManageDisplayPasswordInputField(
                    context,
                    password,
                    "",
                    Icon(Icons.password),
                    passwordVisibility,
                    IconButton(
                        onPressed: (){
                          if(passwordVisibility==true)
                          {
                            passwordVisibility=false;
                            passwordColor=Colors.red;
                          }
                          else
                          {
                            passwordVisibility=true;
                            passwordColor=Colors.green;
                          }
                          setState(() {

                          });
                        },
                        icon: Icon(Icons.remove_red_eye, color: passwordColor,)
                    )
                ),
                SizedBox(height: 25),

                Text(
                  "Worker Name: ${this.workerName}",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.height * 0.03,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Worker ID: ${this.workerId}",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Phone Number: ${this.phoneNumber}",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Email: ${this.email}",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Address: ${this.address}",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Description: ${this.description}",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                Text(
                  "First Login: ${this.firstLoginMssg}",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Is Logged In: ${this.loggedInMssg}",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Access Permission:",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (this.accessField.isNotEmpty)
                  ...this.accessField.entries.map((entry){
                    return Column(
                      children: [
                        Text(
                          '${entry.key}: ${entry.value}',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 5),
                      ],
                    );
                  }),
                SizedBox(height: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }
}