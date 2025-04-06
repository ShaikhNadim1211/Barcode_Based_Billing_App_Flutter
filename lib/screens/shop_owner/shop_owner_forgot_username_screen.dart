
import 'dart:async';

import 'package:barcode_based_billing_system/screens/common/login_screen.dart';
import 'package:barcode_based_billing_system/widgets/custom_button_widget.dart';
import 'package:barcode_based_billing_system/widgets/custom_input_field_widget.dart';
import 'package:barcode_based_billing_system/widgets/custom_toast_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../firebase/shop_owner_document_id_manage.dart';
import '../../methods/otp_auth.dart';

class ShopOwnerForgotUsernameScreen extends StatefulWidget
{
  @override
  State<StatefulWidget> createState()
  {
    return ShopOwnerForgotUsernameScreenState();
  }
}

class ShopOwnerForgotUsernameScreenState extends State
{

  CustomInputFieldWidget inputFieldWidget= CustomInputFieldWidget();
  CustomButtonWidget buttonWidget= CustomButtonWidget();
  CustomToastWidget toastWidget = CustomToastWidget();
  OtpAuth otpAuth= OtpAuth();

  TextEditingController emailOrPhone= TextEditingController();

  String emailOrPhoneMssg="";

  Color emailOrPhoneMssgColor=Colors.red;

  bool emailOrPhoneVerification=false;

  TextEditingController emailOrPhoneOtp= TextEditingController();
  bool emailOrPhoneOtpVerification=false;
  bool emailOrPhoneDisabled=true;
  bool emailOrPhoneSendOtpVisibility=true;
  bool emailOrPhoneVerifyOtpVisibility=false;
  bool isEmailOrPhoneTimerActive=true;
  bool emailOrPhoneVerifiedEnabledDisabled=false;
  bool emailVerified=false;
  bool phoneVerified=false;
  String emailOrPhoneOtpMssg="";
  String emailOrPhoneOtpSuffixText="Send OTP";
  String emailOrPhoneGeneratedOTP="";
  int emailOrPhoneTimerSeconds = 60;
  late Timer _emailOrPhoneTimer;
  Duration emailOrPhoneOtpValidityDuration = Duration(minutes: 2);
  DateTime? emailOrPhoneOtpGeneratedTime;
  Color emailOrPhoneOtpMssgColor=Colors.green;


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
                        "Forgot Username",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.height * 0.04,
                        ),
                      ),
                      SizedBox(height: 50),

                      Center(
                        child: Text(
                          "Enter the credential to get the Username!",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.height * 0.02,
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      inputFieldWidget.NormalInputFieldWithOnChange(
                          context,
                          emailOrPhone,
                          "",
                          Icon(null),
                          TextInputType.emailAddress,
                          Icon(Icons.verified_user, color: emailOrPhoneMssgColor),
                          (value) async
                          {
                            print(value);
                            emailOrPhoneOtpMssg="";
                            emailOrPhoneOtpSuffixText="Send OTP";
                            emailOrPhoneGeneratedOTP="";
                            emailOrPhoneSendOtpVisibility=true;
                            emailOrPhoneVerifyOtpVisibility=false;
                            isEmailOrPhoneTimerActive=true;
                            emailOrPhoneTimerSeconds = 120;
                            emailOrPhoneOtp.text="";
                            emailOrPhoneOtpVerification=false;
                            emailOrPhoneOtpGeneratedTime=null;
                            emailOrPhoneOtpMssgColor=Colors.green;
                            emailVerified=false;
                            phoneVerified=false;

                            if(emailOrPhoneOtpVerification)
                            {
                              emailOrPhoneOtpMssg="";
                              emailOrPhoneOtpSuffixText="Send OTP";
                              emailOrPhoneGeneratedOTP="";
                              emailOrPhoneSendOtpVisibility=true;
                              emailOrPhoneVerifyOtpVisibility=false;
                              isEmailOrPhoneTimerActive=true;
                              emailOrPhoneTimerSeconds = 120;
                              emailOrPhoneOtp.text="";
                              emailOrPhoneOtpVerification=false;
                              emailOrPhoneOtpGeneratedTime=null;
                              emailOrPhoneOtpMssgColor=Colors.green;
                              emailVerified=false;
                              phoneVerified=false;
                            }


                            if(value.isEmpty)
                            {
                              emailOrPhoneVerification=false;
                              emailVerified=false;
                              phoneVerified=false;
                              emailOrPhoneMssgColor=Colors.red;
                              emailOrPhoneMssg="Field is required";
                            }
                            else
                            {
                              RegExp emailRegExp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                              bool emailMatch = emailRegExp.hasMatch(value);

                              RegExp phoneRegExp = RegExp(r'^\d{10}$');
                              bool phoneMatch = phoneRegExp.hasMatch(value);

                              if(emailMatch || phoneMatch)
                              {
                                if(emailMatch)
                                {
                                  emailOrPhoneVerification=true;
                                  emailVerified=true;
                                  phoneVerified=false;
                                  emailOrPhoneMssgColor=Colors.green;
                                  emailOrPhoneMssg="";
                                  this.emailOrPhoneGeneratedOTP= otpAuth.generateOTP();
                                }
                                if(phoneMatch)
                                {
                                  emailOrPhoneVerification=true;
                                  emailVerified=false;
                                  phoneVerified=true;
                                  emailOrPhoneMssgColor=Colors.green;
                                  emailOrPhoneMssg="";
                                  this.emailOrPhoneGeneratedOTP= otpAuth.generateOTP();
                                }
                              }
                              else
                              {
                                emailOrPhoneVerification=false;
                                emailVerified=false;
                                phoneVerified=false;
                                emailOrPhoneMssgColor=Colors.red;
                                emailOrPhoneMssg="Enter a valid email or phone number";
                              }
                            }
                            setState(() {

                            });
                          },
                          emailOrPhoneDisabled,
                          100,
                          "Email or Phone Number"
                      ),
                      SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.only(left: 35.0,right: 35.0),
                        child: Text(
                          emailOrPhoneMssg,
                          style: TextStyle(
                              color: emailOrPhoneMssgColor,
                              fontWeight: FontWeight.bold,
                              fontSize: MediaQuery.of(context).size.height * 0.018
                          ),
                        ),
                      ),
                      if(emailOrPhoneVerifiedEnabledDisabled) TextButton(
                        onPressed: (){

                          setState(() {
                            emailOrPhone.text="";
                            emailOrPhoneOtp.text="";

                            emailOrPhoneMssg="";
                            emailOrPhoneOtpMssg="";
                            emailOrPhoneMssgColor=Colors.red;

                            emailOrPhoneOtpSuffixText="Send OTP";
                            emailOrPhoneGeneratedOTP="";

                            emailOrPhoneSendOtpVisibility=true;
                            emailOrPhoneVerifyOtpVisibility=false;
                            isEmailOrPhoneTimerActive=true;
                            emailOrPhoneVerifiedEnabledDisabled=false;

                            emailOrPhoneVerification=false;
                            emailOrPhoneOtpVerification=false;
                            emailOrPhoneDisabled=true;

                            emailOrPhoneTimerSeconds = 120;
                            emailOrPhoneOtpGeneratedTime=null;
                            emailOrPhoneOtpMssgColor=Colors.green;
                            emailVerified=false;
                            phoneVerified=false;
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
                      if(emailOrPhoneVerification && !emailOrPhoneVerifiedEnabledDisabled) inputFieldWidget.otpInputField(
                        context,
                        emailOrPhoneOtp,
                        "OTP",
                        TextInputType.number,
                        TextButton(
                          onPressed: () async{
                            late bool sendOTP;
                            if(emailOrPhoneSendOtpVisibility==true && emailOrPhoneVerifyOtpVisibility==false)
                            {
                              emailOrPhoneOtpMssgColor=Colors.green;
                              emailOrPhoneOtpMssg="Processing....";
                              //Send Otp Code

                              if(emailVerified)
                              {
                                sendOTP= await otpAuth.sendEmailOTP(this.emailOrPhone.text.toString(), this.emailOrPhoneGeneratedOTP);
                              }
                              if(phoneVerified)
                              {
                                sendOTP= await otpAuth.sendPhoneOTP(this.emailOrPhone.text.toString(), this.emailOrPhoneGeneratedOTP);
                              }

                              if(sendOTP)
                              {
                                emailOrPhoneOtpGeneratedTime= DateTime.now();
                                emailOrPhoneSendOtpVisibility=false;
                                emailOrPhoneVerifyOtpVisibility=true;
                                emailOrPhoneOtpSuffixText="Verify OTP";
                                emailOrPhoneOtpMssgColor=Colors.green;
                                emailOrPhoneOtpMssg="OTP send";
                                emailOrPhoneTimerSeconds=120;
                                isEmailOrPhoneTimerActive=true;
                                _emailOrPhoneTimer = Timer.periodic(Duration(seconds: 1), (timer) {
                                  setState(() {
                                    if (emailOrPhoneTimerSeconds > 0) {
                                      emailOrPhoneTimerSeconds--;
                                    } else {
                                      isEmailOrPhoneTimerActive = false;
                                      timer.cancel();
                                    }
                                  });
                                });
                                emailOrPhoneOtpVerification=false;
                              }
                              else
                              {
                                emailOrPhoneSendOtpVisibility=true;
                                emailOrPhoneVerifyOtpVisibility=false;
                                emailOrPhoneOtpSuffixText="Send OTP";
                                emailOrPhoneOtpMssgColor=Colors.red;
                                emailOrPhoneOtpMssg="Try Again";
                                emailOrPhoneOtpVerification=false;
                              }

                            }
                            else if(emailOrPhoneSendOtpVisibility==false && emailOrPhoneVerifyOtpVisibility==true)
                            {
                              //verify otp code
                              if((DateTime.now().difference(emailOrPhoneOtpGeneratedTime!))<=emailOrPhoneOtpValidityDuration)
                              {
                                bool verifyOTP = otpAuth.verifyOTP(this.emailOrPhoneGeneratedOTP, emailOrPhoneOtp.text.toString());

                                if (verifyOTP)
                                {
                                  emailOrPhoneOtpSuffixText = "Verified";
                                  emailOrPhoneOtpMssgColor=Colors.green;
                                  emailOrPhoneOtpMssg = "";
                                  emailOrPhoneSendOtpVisibility = true;
                                  emailOrPhoneOtpVerification = true;
                                  emailOrPhoneDisabled = false;
                                  emailOrPhoneVerifiedEnabledDisabled = true;
                                  toastWidget.showToast("Processing....");
                                  if(emailVerified && emailOrPhoneOtpVerification)
                                  {
                                    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("shopowner").where("email", isEqualTo: emailOrPhone.text.toString()).get();
                                    if(snapshot.docs.isNotEmpty)
                                    {
                                      var document= snapshot.docs.first;
                                      String username=document['username'];

                                      bool sendMssg= await otpAuth.sendEmailUsernameMessage(emailOrPhone.text.toString(),username);
                                      if(sendMssg)
                                      {
                                        toastWidget.showToast("If Registeration found then the Username will be send on your verified credential");
                                      }
                                      else
                                      {
                                        toastWidget.showToast("If Registeration found then the Username will be send on your verified credential");
                                      }
                                    }
                                    else
                                    {
                                      toastWidget.showToast("If Registeration found then the Username will be send on your verified credential");
                                    }
                                  }
                                  if(phoneVerified && emailOrPhoneOtpVerification)
                                  {
                                    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("shopowner").where("phonenumber", isEqualTo: emailOrPhone.text.toString()).get();
                                    if(snapshot.docs.isNotEmpty)
                                    {
                                      var document= snapshot.docs.first;
                                      String username=document['username'];

                                      bool sendMssg= await otpAuth.sendPhoneMessage(this.emailOrPhone.text.toString(), "Your Username is $username");
                                      if(sendMssg)
                                      {
                                        toastWidget.showToast("If Registeration found then the Username will be send on your verified credential");
                                      }
                                      else
                                      {
                                        toastWidget.showToast("If Registeration found then the Username will be send on your verified credential");
                                      }
                                    }
                                    else
                                    {
                                      toastWidget.showToast("If Registeration found then the Username will be send on your verified credential");
                                    }
                                  }
                                }
                                else
                                {
                                  emailOrPhoneSendOtpVisibility = false;
                                  emailOrPhoneVerifyOtpVisibility = true;
                                  emailOrPhoneOtpSuffixText = "Verify OTP";
                                  emailOrPhoneOtpMssgColor=Colors.red;
                                  emailOrPhoneOtpMssg = "Invalid OTP";
                                  emailOrPhoneOtpVerification = false;
                                }
                              }
                              else
                              {
                                emailOrPhoneOtpMssgColor=Colors.red;
                                emailOrPhoneOtpMssg="OTP verification timeout. Try Again!";
                              }
                            }
                            else
                            {

                            }
                            setState(() {

                            });
                          },
                          child: Text(
                            emailOrPhoneOtpSuffixText,
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      if(emailOrPhoneVerification && !emailOrPhoneVerifiedEnabledDisabled) SizedBox(height: 5),
                      if(emailOrPhoneSendOtpVisibility==false && !emailOrPhoneVerifiedEnabledDisabled) Align(
                        alignment: Alignment.centerRight,
                        child: isEmailOrPhoneTimerActive
                            ? Text(
                          "Resend OTP in $emailOrPhoneTimerSeconds seconds",
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
                            late bool sendOTP;
                            emailOrPhoneOtpMssgColor=Colors.green;
                            emailOrPhoneOtpMssg="Processing....";
                            this.emailOrPhoneGeneratedOTP= otpAuth.generateOTP();

                            if(emailVerified)
                            {
                              sendOTP= await otpAuth.sendEmailOTP(this.emailOrPhone.text.toString(), this.emailOrPhoneGeneratedOTP);
                            }
                            if(phoneVerified)
                            {
                              sendOTP= await otpAuth.sendPhoneOTP(this.emailOrPhone.text.toString(), this.emailOrPhoneGeneratedOTP);
                            }

                            if(sendOTP)
                            {
                              emailOrPhoneOtpGeneratedTime= DateTime.now();
                              emailOrPhoneOtpMssgColor=Colors.green;
                              emailOrPhoneOtpMssg="OTP resend";
                              emailOrPhoneTimerSeconds=120;
                              isEmailOrPhoneTimerActive=true;
                              _emailOrPhoneTimer = Timer.periodic(Duration(seconds: 1), (timer) {
                                setState(() {
                                  if (emailOrPhoneTimerSeconds > 0) {
                                    emailOrPhoneTimerSeconds--;
                                  } else {
                                    isEmailOrPhoneTimerActive = false;
                                    timer.cancel();
                                  }
                                });
                              });
                            }
                            else
                            {
                              isEmailOrPhoneTimerActive = false;
                              emailOrPhoneOtpMssgColor=Colors.red;
                              emailOrPhoneOtpMssg="Try Again";
                            }
                          },
                        ),
                      ),
                      if(emailOrPhoneVerification && !emailOrPhoneVerifiedEnabledDisabled) SizedBox(height: 5),
                      if(emailOrPhoneVerification && !emailOrPhoneVerifiedEnabledDisabled) Padding(
                        padding: const EdgeInsets.only(left: 35.0,right: 35.0),
                        child: Text(
                          emailOrPhoneOtpMssg,
                          style: TextStyle(
                              color: emailOrPhoneOtpMssgColor,
                              fontWeight: FontWeight.bold,
                              fontSize: MediaQuery.of(context).size.height * 0.018
                          ),
                        ),
                      ),
                      if(emailOrPhoneVerification && !emailOrPhoneVerifiedEnabledDisabled) SizedBox(height: 25),
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