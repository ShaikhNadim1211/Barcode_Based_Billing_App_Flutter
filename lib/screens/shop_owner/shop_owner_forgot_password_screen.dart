import 'dart:async';

import 'package:barcode_based_billing_system/firebase/shop_owner_document_id_manage.dart';
import 'package:barcode_based_billing_system/methods/otp_auth.dart';
import 'package:barcode_based_billing_system/screens/common/login_screen.dart';
import 'package:barcode_based_billing_system/screens/shop_owner/shop_owner_password_change_screen.dart';
import 'package:barcode_based_billing_system/widgets/custom_button_widget.dart';
import 'package:barcode_based_billing_system/widgets/custom_input_field_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/custom_toast_widget.dart';

class ShopOwnerForgotPasswordScreen extends StatefulWidget
{
  @override
  State<StatefulWidget> createState()
  {
    return ShopOwnerForgotPasswordScreenState();
  }
}

class ShopOwnerForgotPasswordScreenState extends State
{
  CustomInputFieldWidget inputFieldWidget= CustomInputFieldWidget();
  CustomButtonWidget buttonWidget= CustomButtonWidget();
  CustomToastWidget toastWidget = CustomToastWidget();
  OtpAuth otpAuth= OtpAuth();

  TextEditingController username= TextEditingController();

  String usernameMssg="";

  Color usernameMssgColor=Colors.red;

  bool usernameVerification=false;

  TextEditingController usernameOtp= TextEditingController();
  bool usernameOtpVerification=false;
  bool usernameDisabled=true;
  bool usernameSendOtpVisibility=true;
  bool usernameVerifyOtpVisibility=false;
  bool isUsernameTimerActive=true;
  bool usernameVerifiedEnabledDisabled=false;
  String usernameOtpMssg="";
  String usernameOtpSuffixText="Send OTP";
  String usernameGeneratedOTP="";
  String email="",phoneNumber="";
  int usernameTimerSeconds = 60;
  late Timer _usernameTimer;
  Duration usernameOtpValidityDuration = Duration(minutes: 2);
  DateTime? usernameOtpGeneratedTime;
  Color usernameOtpMssgColor=Colors.green;

  @override
  Widget build(BuildContext context)
  {
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
                        "Forgot Password",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.height * 0.04,
                        ),
                      ),
                      SizedBox(height: 50),

                      inputFieldWidget.NormalInputFieldWithOnChange(
                          context,
                          username,
                          "E.g, ABCD123",
                          Icon(Icons.supervised_user_circle),
                          TextInputType.text,
                          Icon(Icons.verified_user, color: usernameMssgColor),
                          (value) async
                          {
                            print(value);
                            usernameMssg="";
                            usernameOtpSuffixText="Send OTP";
                            usernameGeneratedOTP="";
                            usernameSendOtpVisibility=true;
                            usernameVerifyOtpVisibility=false;
                            isUsernameTimerActive=true;
                            usernameTimerSeconds = 120;
                            usernameOtp.text="";
                            usernameOtpVerification=false;
                            usernameOtpGeneratedTime=null;
                            usernameOtpMssgColor=Colors.green;
                            usernameOtpMssg="";

                            if(usernameOtpVerification)
                            {
                              usernameOtpMssg="";
                              usernameOtpSuffixText="Send OTP";
                              usernameGeneratedOTP="";
                              usernameSendOtpVisibility=true;
                              usernameVerifyOtpVisibility=false;
                              isUsernameTimerActive=true;
                              usernameTimerSeconds = 120;
                              usernameOtp.text="";
                              usernameOtpVerification=false;
                              usernameOtpGeneratedTime=null;
                              usernameOtpMssgColor=Colors.green;
                            }

                            if(value.isEmpty)
                            {
                              usernameVerification=false;
                              usernameMssgColor=Colors.red;
                              usernameMssg="Field is required";
                            }
                            else
                            {
                              RegExp regExp= RegExp(r'^[a-zA-Z0-9]{6,}$');
                              bool match = regExp.hasMatch(value);

                              if(match)
                              {
                                QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("shopowner").where("username", isEqualTo: value).get();

                                if(snapshot.docs.isNotEmpty)
                                {
                                  //username found
                                  usernameVerification=true;
                                  usernameMssgColor=Colors.green;
                                  usernameMssg="";
                                  this.usernameGeneratedOTP=otpAuth.generateOTP();
                                  var document= snapshot.docs.first;
                                  this.email=document["email"];
                                  this.phoneNumber=document["phonenumber"];
                                }
                                else
                                {
                                  usernameVerification=false;
                                  usernameMssgColor=Colors.red;
                                  usernameMssg="Invalid Username";
                                }
                              }
                              else
                              {
                                usernameVerification=false;
                                usernameMssgColor=Colors.red;
                                usernameMssg="Invalid Username";
                              }
                            }
                            setState(() {

                            });
                          },
                          usernameDisabled,
                          100,
                          "Username"
                      ),
                      SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.only(left: 35.0,right: 35.0),
                        child: Text(
                          usernameMssg,
                          style: TextStyle(
                              color: usernameMssgColor,
                              fontWeight: FontWeight.bold,
                              fontSize: MediaQuery.of(context).size.height * 0.018
                          ),
                        ),
                      ),
                      if(usernameVerifiedEnabledDisabled) TextButton(
                        onPressed: (){

                          setState(() {
                            username.text="";
                            usernameOtp.text="";

                            usernameMssg="";
                            usernameOtpMssg="";
                            usernameMssgColor=Colors.red;

                            usernameOtpSuffixText="Send OTP";
                            usernameGeneratedOTP="";

                            usernameSendOtpVisibility=true;
                            usernameVerifyOtpVisibility=false;
                            isUsernameTimerActive=true;
                            usernameVerifiedEnabledDisabled=false;

                            usernameVerification=false;
                            usernameOtpVerification=false;
                            usernameDisabled=true;

                            usernameTimerSeconds = 120;
                            usernameOtpGeneratedTime=null;
                            usernameOtpMssgColor=Colors.green;
                          });
                        },
                        child: Text(
                          "Change/Re-verify OTP",
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: MediaQuery.of(context).size.height * 0.02,
                          ),
                        ),
                      ),
                      SizedBox(height: 25),
                      if(usernameVerification && !usernameVerifiedEnabledDisabled) inputFieldWidget.otpInputField(
                        context,
                        usernameOtp,
                        "OTP",
                        TextInputType.number,
                        TextButton(
                          onPressed: () async{

                            if(usernameSendOtpVisibility==true && usernameVerifyOtpVisibility==false)
                            {
                              usernameOtpMssgColor=Colors.green;
                              usernameOtpMssg="Processing....";
                              //Send Otp Code

                              bool sendEmailOTP= await otpAuth.sendEmailOTP(this.email, this.usernameGeneratedOTP);
                              bool sendPhoneOTP=await otpAuth.sendPhoneOTP(this.phoneNumber, this.usernameGeneratedOTP);

                              if(sendEmailOTP || sendPhoneOTP)
                              {
                                usernameOtpGeneratedTime= DateTime.now();
                                usernameSendOtpVisibility=false;
                                usernameVerifyOtpVisibility=true;
                                usernameOtpSuffixText="Verify OTP";
                                usernameOtpMssgColor=Colors.green;
                                usernameOtpMssg="OTP send";
                                usernameTimerSeconds=120;
                                isUsernameTimerActive=true;
                                _usernameTimer = Timer.periodic(Duration(seconds: 1), (timer) {
                                  setState(() {
                                    if (usernameTimerSeconds > 0) {
                                      usernameTimerSeconds--;
                                    } else {
                                      isUsernameTimerActive = false;
                                      timer.cancel();
                                    }
                                  });
                                });
                                usernameOtpVerification=false;
                              }
                              else
                              {
                                usernameSendOtpVisibility=true;
                                usernameVerifyOtpVisibility=false;
                                usernameOtpSuffixText="Send OTP";
                                usernameOtpMssgColor=Colors.red;
                                usernameOtpMssg="Try Again";
                                usernameOtpVerification=false;
                              }

                            }
                            else if(usernameSendOtpVisibility==false && usernameVerifyOtpVisibility==true)
                            {
                              //verify otp code
                              if((DateTime.now().difference(usernameOtpGeneratedTime!))<=usernameOtpValidityDuration)
                              {
                                bool verifyOTP = otpAuth.verifyOTP(this.usernameGeneratedOTP, usernameOtp.text.toString());

                                if (verifyOTP)
                                {
                                  usernameOtpSuffixText = "Verified";
                                  usernameOtpMssgColor=Colors.green;
                                  usernameOtpMssg = "";
                                  usernameSendOtpVisibility = true;
                                  usernameOtpVerification = true;
                                  usernameDisabled = false;
                                  usernameVerifiedEnabledDisabled = true;
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context)=>ShopOwnerPasswordChangeScreen(username.text.toString())
                                    ),
                                  );
                                }
                                else
                                {
                                  usernameSendOtpVisibility = false;
                                  usernameVerifyOtpVisibility = true;
                                  usernameOtpSuffixText = "Verify OTP";
                                  usernameOtpMssgColor=Colors.red;
                                  usernameOtpMssg = "Invalid OTP";
                                  usernameOtpVerification = false;
                                }
                              }
                              else
                              {
                                usernameOtpMssgColor=Colors.red;
                                usernameOtpMssg="OTP verification timeout. Try Again!";
                              }
                            }
                            else
                            {

                            }
                            setState(() {

                            });
                          },
                          child: Text(
                            usernameOtpSuffixText,
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      if(usernameVerification && !usernameVerifiedEnabledDisabled) SizedBox(height: 5),
                      if(usernameSendOtpVisibility==false && !usernameVerifiedEnabledDisabled) Align(
                        alignment: Alignment.centerRight,
                        child: isUsernameTimerActive
                            ? Text(
                          "Resend OTP in $usernameTimerSeconds seconds",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: MediaQuery.of(context).size.height * 0.02,
                          ),
                        )
                            : TextButton(
                          child: Text(
                            "Resend OTP",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: MediaQuery.of(context).size.height * 0.02,
                            ),
                          ),
                          onPressed: () async{
                            usernameOtpMssgColor=Colors.green;
                            usernameOtpMssg="Processing....";
                            this.usernameGeneratedOTP= otpAuth.generateOTP();

                            bool sendEmailOTP=await otpAuth.sendEmailOTP(this.email, this.usernameGeneratedOTP);
                            bool sendPhoneOTP= await otpAuth.sendPhoneOTP(this.phoneNumber, this.usernameGeneratedOTP);
                            if(sendEmailOTP || sendPhoneOTP)
                            {
                              usernameOtpGeneratedTime= DateTime.now();
                              usernameOtpMssgColor=Colors.green;
                              usernameOtpMssg="OTP resend";
                              usernameTimerSeconds=120;
                              isUsernameTimerActive=true;
                              _usernameTimer = Timer.periodic(Duration(seconds: 1), (timer) {
                                setState(() {
                                  if (usernameTimerSeconds > 0) {
                                    usernameTimerSeconds--;
                                  } else {
                                    isUsernameTimerActive = false;
                                    timer.cancel();
                                  }
                                });
                              });
                            }
                            else
                            {
                              isUsernameTimerActive = false;
                              usernameOtpMssgColor=Colors.red;
                              usernameOtpMssg="Try Again";
                            }
                          },
                        ),
                      ),
                      if(usernameVerification && !usernameVerifiedEnabledDisabled) SizedBox(height: 5),
                      if(usernameVerification && !usernameVerifiedEnabledDisabled) Padding(
                        padding: const EdgeInsets.only(left: 35.0,right: 35.0),
                        child: Text(
                          usernameOtpMssg,
                          style: TextStyle(
                              color: usernameOtpMssgColor,
                              fontWeight: FontWeight.bold,
                              fontSize: MediaQuery.of(context).size.height * 0.018
                          ),
                        ),
                      ),
                      if(usernameVerification && !usernameVerifiedEnabledDisabled) SizedBox(height: 25),
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