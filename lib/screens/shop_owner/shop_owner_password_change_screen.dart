import 'package:barcode_based_billing_system/methods/otp_auth.dart';
import 'package:barcode_based_billing_system/screens/common/login_screen.dart';
import 'package:barcode_based_billing_system/widgets/custom_button_widget.dart';
import 'package:barcode_based_billing_system/widgets/custom_input_field_widget.dart';
import 'package:barcode_based_billing_system/widgets/custom_toast_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShopOwnerPasswordChangeScreen extends StatefulWidget {
  final String username; // Use `final` for immutable variables in widgets

  // Constructor to initialize `username`
  ShopOwnerPasswordChangeScreen(this.username);

  @override
  State<StatefulWidget> createState() {
    return ShopOwnerPasswordChangeScreenState();
  }
}

class ShopOwnerPasswordChangeScreenState extends State<ShopOwnerPasswordChangeScreen>
{
  CustomButtonWidget buttonWidget= CustomButtonWidget();
  CustomInputFieldWidget inputFieldWidget= CustomInputFieldWidget();
  CustomToastWidget toastWidget = CustomToastWidget();
  OtpAuth otpAuth= OtpAuth();

  TextEditingController password= TextEditingController();
  TextEditingController confirmPassword= TextEditingController();

  String passwordMssg="";
  String confirmPasswordMssg="";

  bool passwordVisibility=true;
  bool confirmPasswordVisibility=true;

  Color passwordMssgColor=Colors.green;
  Color passwordVisibilityColor=Colors.green;
  Color confirmPasswordMssgColor=Colors.red;
  Color confirmPasswordVisibilityColor=Colors.green;

  bool passwordVerification=false;
  bool confirmPasswordVerification=false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10.0, top: 30.0),
                child: IconButton(
                  onPressed: (){
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context)=>LoginScreen(),
                      ),
                    );
                  },
                  icon: Icon(Icons.arrow_back, size: 40.0,color: Colors.black,),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 25,right: 25,top: 30),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 10),
                      Text(
                        "Change Password",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.height * 0.04,
                        ),
                      ),
                      SizedBox(height: 50),

                      //New Password Input
                      inputFieldWidget.PasswordInputFieldWithOnChange(
                        context,
                        password,
                        "New Password",
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
                      SizedBox(height: 25),

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

                      buttonWidget.ButtonField(
                          context,
                          "Submit",
                          () async{
                            if(passwordVerification && confirmPasswordVerification)
                            {
                              String username= widget.username.toString();

                              QuerySnapshot snapshot= await FirebaseFirestore.instance.collection("shopowner").where("username",isEqualTo: username).get();

                              if(snapshot.docs.isNotEmpty)
                              {
                                var document= snapshot.docs.first;
                                var id=document.id;
                                Map<String,dynamic> data= {
                                  "password": this.confirmPassword.text.toString(),
                                };
                                try
                                {
                                  await FirebaseFirestore.instance.collection("shopowner").doc(id).update(data);
                                  toastWidget.showToast("Password Changed");
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context)=>LoginScreen()
                                      )
                                  );
                                }
                                catch(e)
                                {
                                  toastWidget.showToast(e.toString());
                                }
                              }
                              else
                              {
                                toastWidget.showToast("Try Again");
                              }
                            }
                            else
                            {
                              toastWidget.showToast("Field is Required");
                            }
                          }
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
