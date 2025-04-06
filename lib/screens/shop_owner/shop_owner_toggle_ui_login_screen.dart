import 'package:barcode_based_billing_system/screens/shop_owner/shop_owner_forgot_password_screen.dart';
import 'package:barcode_based_billing_system/screens/shop_owner/shop_owner_forgot_username_screen.dart';
import 'package:barcode_based_billing_system/screens/shop_owner/shop_owner_home_screen.dart';
import 'package:barcode_based_billing_system/screens/shop_owner/shop_owner_register_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:barcode_based_billing_system/widgets/custom_button_widget.dart';
import 'package:barcode_based_billing_system/widgets/custom_input_field_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/custom_toast_widget.dart';

class ShopOwnerToggleUILoginScreen extends StatefulWidget
{
  @override
  State<StatefulWidget> createState()
  {
    return ShopOwnerToggleUILoginScreenState();
  }
}

class ShopOwnerToggleUILoginScreenState extends State<ShopOwnerToggleUILoginScreen>
{
  CustomInputFieldWidget inputFieldWidget = new CustomInputFieldWidget();
  CustomButtonWidget buttonWidget=new CustomButtonWidget();
  CustomToastWidget toastWidget = CustomToastWidget();

  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();

  bool passwordVisibility = true;
  Color passwordVisibilityColor=Colors.green;

  @override
  Widget build(BuildContext context)
  {
    return PopScope(
      canPop: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          inputFieldWidget.NormalInputField(
              context,
              username,
              "",
              Icon(Icons.supervised_user_circle),
              TextInputType.text,
              "Username"
          ),
          SizedBox(height: 30),
          inputFieldWidget.PasswordInputFieldWithOnChange(
            context,
            password,
            "Password",
            Icon(Icons.password),
            passwordVisibility,
            IconButton(
                onPressed: () {
                  setState(() {
                    if (passwordVisibility == false)
                    {
                      passwordVisibility = true;
                      passwordVisibilityColor=Colors.green;
                    }
                    else
                    {
                      passwordVisibility = false;
                      passwordVisibilityColor=Colors.red;
                    }
                  });
                },
                icon: Icon(Icons.remove_red_eye,color: passwordVisibilityColor,)
            ),
            (value){

              },
            "Password"
          ),
          SizedBox(height: 30),
          buttonWidget.ButtonField(
              context,
              "Login",
              () async{
                print("Login Clicked");

                String username=this.username.text.toString();
                String password=this.password.text.toString();

                if(username.isEmpty || password.isEmpty)
                {
                  //invalid
                  toastWidget.showToast("Invalid Credential");
                }
                else
                {
                  QuerySnapshot snapshot= await FirebaseFirestore.instance.collection("shopowner").where("username",isEqualTo: username).get();
                  if(snapshot.docs.isNotEmpty)
                  {
                    var document= snapshot.docs.first;
                    String u= document['username'];
                    String p= document['password'];

                    if(username==u && password==p)
                    {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setBool("logIn", true);
                      prefs.setBool("ownerLogIn", true);
                      prefs.setBool("workerLogIn", false);
                      prefs.setString("username", username);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context)=>ShopOwnerHomeScreen()
                          ),
                      );
                    }
                    else
                    {
                      //invalid
                      toastWidget.showToast("Invalid Credential");
                    }
                  }
                  else
                  {
                    //invalid
                    toastWidget.showToast("Invalid Credential");
                  }
                }

              }),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                child: Text("Forgot Username?"),
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context)=>ShopOwnerForgotUsernameScreen()
                      )
                  );
                },
              ),
              SizedBox(width: 10),
              InkWell(
                child: Text("Forgot Password?"),
                onTap: () {
                  print("Forgot Password Clicked");

                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context)=>ShopOwnerForgotPasswordScreen()
                      )
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 15),
          InkWell(
            child: Text("Don't have an account?"),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context)=>ShopOwnerRegisterScreen()
                  ));
            },
          ),
        ],
      ),
    );
  }
}
