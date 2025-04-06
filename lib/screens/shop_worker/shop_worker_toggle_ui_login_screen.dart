import 'package:barcode_based_billing_system/screens/shop_worker/shop_worker_first_login_otp_screen.dart';
import 'package:barcode_based_billing_system/screens/shop_worker/shop_worker_home_screen.dart';
import 'package:barcode_based_billing_system/widgets/custom_toast_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:barcode_based_billing_system/widgets/custom_button_widget.dart';
import 'package:barcode_based_billing_system/widgets/custom_input_field_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopWorkerToggleUILoginScreen extends StatefulWidget
{
  @override
  State<StatefulWidget> createState()
  {
    return ShopWorkerToggleUILoginScreenState();
  }
}

class ShopWorkerToggleUILoginScreenState extends State<ShopWorkerToggleUILoginScreen>
{

  CustomInputFieldWidget inputFieldWidget = CustomInputFieldWidget();
  CustomButtonWidget buttonWidget = CustomButtonWidget();
  CustomToastWidget toastWidget = CustomToastWidget();

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  bool passwordVisibility = true;
  Color passwordVisibilityColor = Colors.green;

  @override
  Widget build(BuildContext context) {
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
              "Email/Phonenumber"
          ),
          SizedBox(height: 30),
          inputFieldWidget.PasswordInputField(
            context,
            password,
            "",
            Icon(Icons.password),
            passwordVisibility,
            IconButton(
                onPressed: () {
                  setState(() {
                    if (passwordVisibility == false)
                    {
                      passwordVisibility = true;
                      passwordVisibilityColor = Colors.green;
                    }
                    else
                    {
                      passwordVisibility = false;
                      passwordVisibilityColor = Colors.red;
                    }
                  });
                },
                icon: Icon(Icons.remove_red_eye, color: passwordVisibilityColor,)),
            "Password"
          ),
          SizedBox(height: 30),
          buttonWidget.ButtonField(
              context,
              "Login",
                () async
                {
                print("Login Clicked");

                try
                {
                  String username=this.username.text.toString().trim();
                  String password=this.password.text.toString().trim();

                  if(username.isEmpty || password.isEmpty)
                  {
                    //invalid
                    await Future.delayed(Duration(milliseconds: 300));
                    toastWidget.showToast("Invalid Credential");
                  }
                  else
                  {
                    RegExp regExpEmail= RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                    bool matchEmail = regExpEmail.hasMatch(username);

                    RegExp regExpPhoneNumber= RegExp(r'^\d{10}$');
                    bool matchPhoneNumber = regExpPhoneNumber.hasMatch(username);

                    if(matchEmail || matchPhoneNumber)
                    {
                      late QuerySnapshot snapshot;
                      if(matchEmail)
                      {
                        snapshot= await FirebaseFirestore.instance.collection("worker").where("email",isEqualTo: username).get();
                      }
                      if(matchPhoneNumber)
                      {
                        snapshot= await FirebaseFirestore.instance.collection("worker").where("phonenumber",isEqualTo: username).get();
                      }

                      if(snapshot.docs.isNotEmpty)
                      {
                        var document= snapshot.docs.first;
                        String u = "";
                        String p = document['password'];
                        String ownerId = document["ownerid"];
                        String shopId = document["shopid"];
                        String firstLogin = document["firstlogin"];
                        String workerId = document["workerid"];
                        String email = document["email"];
                        String phoneNumber = document["phonenumber"];
                        String loggedIn = document["loggedin"];

                        Map<String, List<String>> accessField = {};
                        var data = document["accessField"] as Map<String, dynamic>;
                        data.forEach((key, value) {
                          accessField[key] = List<String>.from(value);
                        });

                        if(matchEmail)
                        {
                          u = document["email"];
                        }
                        if(matchPhoneNumber)
                        {
                          u = document["phonenumber"];
                        }

                        if(username==u && password==p)
                        {
                          int i = 0;

                          if(ownerId.isNotEmpty && shopId.isNotEmpty && workerId.isNotEmpty
                          && email.isNotEmpty && phoneNumber.isNotEmpty && p.isNotEmpty
                          && firstLogin.isNotEmpty && loggedIn.isNotEmpty && accessField.isNotEmpty)
                          {
                            if(loggedIn.toString()=="1")
                            {
                              await Future.delayed(Duration(milliseconds: 300));
                              toastWidget.showToast("Already Logged In");
                            }
                            else
                            {
                              if(firstLogin.toString()=="1")
                              {
                                i = 1;
                              }
                              else
                              {
                                i = 0;
                              }

                              if(i==1)
                              {
                                //First Login Code
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context)=>ShopWorkerFirstLoginOtpScreen(ownerId, shopId, workerId, password, email, phoneNumber)
                                    )
                                );
                              }

                              if(i==0)
                              {
                                //Direct Login
                                Map<String, dynamic> data = {
                                  "loggedin" : "1",
                                  "isupdate" : "0"
                                };
                                var document = snapshot.docs.first.reference;
                                await document.update(data);
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                prefs.setBool("logIn", true);
                                prefs.setBool("ownerLogIn", false);
                                prefs.setBool("workerLogIn", true);
                                prefs.setString("ownerId", ownerId);
                                prefs.setString("shopId", shopId);
                                prefs.setString("workerId", workerId);
                                prefs.setStringList("Product", accessField["Product"] ?? []);
                                prefs.setStringList("Customer", accessField["Customer"] ?? []);
                                prefs.setStringList("Bill", accessField["Bill"] ?? []);
                                prefs.setStringList("Inventory", accessField["Inventory"] ?? []);
                                prefs.setStringList("Scan Bill", accessField["Scan Bill"] ?? []);

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context)=>ShopWorkerHomeScreen()
                                  ),
                                );
                              }
                            }
                          }
                          else
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
                      else
                      {
                        await Future.delayed(Duration(milliseconds: 300));
                        toastWidget.showToast("Invalid Credential");
                      }
                    }
                    else
                    {
                      await Future.delayed(Duration(milliseconds: 300));
                      toastWidget.showToast("Invalid Credential");
                    }
                  }
                }
                catch(e)
                {
                  await Future.delayed(Duration(milliseconds: 300));
                  toastWidget.showToast("Invalid Credential");
                }

                }
              ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
