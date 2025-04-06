import 'dart:async';

import 'package:barcode_based_billing_system/firebase/shop_owner_document_id_manage.dart';
import 'package:barcode_based_billing_system/methods/otp_auth.dart';
import 'package:barcode_based_billing_system/screens/common/login_screen.dart';
import 'package:barcode_based_billing_system/widgets/custom_button_widget.dart';
import 'package:barcode_based_billing_system/widgets/custom_input_field_widget.dart';
import 'package:barcode_based_billing_system/widgets/custom_toast_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ShopOwnerRegisterScreen extends StatefulWidget
{
  @override
  State<StatefulWidget> createState(){
    return ShopOwnerRegisterScreenState();
  }
}

class ShopOwnerRegisterScreenState extends State<ShopOwnerRegisterScreen>
{
  CustomButtonWidget buttonWidget= CustomButtonWidget();
  CustomInputFieldWidget inputFieldWidget= CustomInputFieldWidget();
  CustomToastWidget toastWidget = CustomToastWidget();
  ShopOwnerDocumentIdManage documentIdManage= ShopOwnerDocumentIdManage();
  OtpAuth otpAuth= OtpAuth();

  TextEditingController firstName= TextEditingController();
  TextEditingController lastName= TextEditingController();
  TextEditingController userName= TextEditingController();
  TextEditingController password= TextEditingController();
  TextEditingController confirmPassword= TextEditingController();
  TextEditingController phoneNumber= TextEditingController();
  TextEditingController email= TextEditingController();


  String firstNameMssg="";
  String lastNameMssg="";
  String userNameMssg="";
  String passwordMssg="";
  String confirmPasswordMssg="";
  String phoneNumberMssg="";
  String emailMssg="";


  bool passwordVisibility=true;
  bool confirmPasswordVisibility=true;


  Color firstNameMssgColor=Colors.red;
  Color lastNameMssgColor=Colors.red;
  Color userNameMssgColor=Colors.red;
  Color passwordMssgColor=Colors.red;
  Color passwordVisibilityColor=Colors.green;
  Color confirmPasswordMssgColor=Colors.red;
  Color confirmPasswordVisibilityColor=Colors.green;
  Color phoneNumberMssgColor=Colors.red;
  Color emailMssgColor=Colors.red;

  bool firstNameVerification=false;
  bool lastNameVerification=false;
  bool userNameVerification=false;
  bool passwordVerification=false;
  bool confirmPasswordVerification=false;
  bool phoneNumberVerification=false;
  bool emailVerification=false;

  //Email Otp Credential
  TextEditingController emailOtp= TextEditingController();
  bool emailOtpVerification=false;
  bool emailDisabled=true;
  bool emailSendOtpVisibility=true;
  bool emailVerifyOtpVisibility=false;
  bool isEmailTimerActive=true;
  bool emailVerifiedEnabledDisabled=false;
  String emailOtpMssg="";
  String emailOtpSuffixText="Send OTP";
  String emailGeneratedOTP="";
  int emailTimerSeconds = 60;
  late Timer _emailTimer;
  Duration emailOtpValidityDuration = Duration(minutes: 2);
  DateTime? emailOtpGeneratedTime;
  Color emailOtpMssgColor=Colors.green;

  //Phone Number Credential
  TextEditingController phoneNumberOtp= TextEditingController();
  bool phoneNumberOtpVerification=false;
  bool phoneNumberDisabled=true;
  bool phoneNumberSendOtpVisibility=true;
  bool phoneNumberVerifyOtpVisibility=false;
  bool isPhoneNumberTimerActive=true;
  bool phoneNumberVerifiedEnabledDisabled=false;
  String phoneNumberOtpMssg="";
  String phoneNumberOtpSuffixText="Send OTP";
  String phoneNumberGeneratedOTP="";
  String verificationId="";
  int phoneNumberTimerSeconds = 60;
  late Timer _phoneNumberTimer;
  Duration phoneNumberOtpValidityDuration = Duration(minutes: 2);
  DateTime? phoneNumberOtpGeneratedTime;
  Color phoneNumberOtpMssgColor=Colors.green;

  @override
  Widget build(BuildContext context){
     return PopScope(
       canPop: false,
       child: Scaffold(
         body: Padding(
           padding: EdgeInsets.only(left: 25,right: 25,top: 50),
           child: SingleChildScrollView(
             scrollDirection: Axis.vertical,
             child: Column(
               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
               crossAxisAlignment: CrossAxisAlignment.center,
               children: [
                 SizedBox(height: 10),
                 Text(
                   "Register",
                   style: TextStyle(
                     fontWeight: FontWeight.bold,
                     fontSize: MediaQuery.of(context).size.height * 0.04,
                   ),
                 ),
                 SizedBox(height: 50),

                 //First Name Input
                 inputFieldWidget.NormalInputFieldWithOnChange(
                     context,
                     firstName,
                     "E.g, Nadim",
                     Icon(Icons.person),
                     TextInputType.text,
                     Icon(Icons.verified_user,color: firstNameMssgColor),
                     (value)
                     {
                       print(value);
                       if(value.isEmpty)
                       {
                         firstNameVerification=false;
                         firstNameMssgColor=Colors.red;
                         firstNameMssg="First name is required";
                       }
                       else
                       {
                         RegExp regExp= RegExp(r'^[A-Z][a-z]*$');
                         bool match = regExp.hasMatch(value);
                         if(match)
                         {
                           firstNameVerification=true;
                           firstNameMssgColor=Colors.green;
                           firstNameMssg="";
                         }
                         else
                         {
                           firstNameVerification=false;
                           firstNameMssgColor=Colors.red;
                           firstNameMssg="It should start with a capital letter and the rest must be lowercase";
                         }
                       }
                       setState(() {

                       });
                     },
                   true,
                   50,
                   "First Name"
                 ),
                 SizedBox(height: 5),
                 Padding(
                   padding: const EdgeInsets.only(left: 35.0,right: 35.0),
                   child: Text(
                     firstNameMssg,
                     style: TextStyle(
                       color: firstNameMssgColor,
                       fontWeight: FontWeight.bold,
                       fontSize: MediaQuery.of(context).size.height * 0.018,
                     ),
                   ),
                 ),
                 SizedBox(height: 25),

                 //Last Name Input
                 inputFieldWidget.NormalInputFieldWithOnChange(
                     context,
                     lastName,
                     "E.g, Shaikh",
                     Icon(Icons.person),
                     TextInputType.text,
                     Icon(Icons.verified_user,color: lastNameMssgColor),
                     (value)
                     {
                       print(value);
                       if(value.isEmpty)
                       {
                         lastNameVerification=false;
                         lastNameMssgColor=Colors.red;
                         lastNameMssg="Last Name is required";
                       }
                       else
                       {
                         RegExp regExp= RegExp(r'^[A-Z][a-z]*$');
                         bool match = regExp.hasMatch(value);
                         if(match)
                         {
                           lastNameVerification=true;
                           lastNameMssgColor=Colors.green;
                           lastNameMssg="";
                         }
                         else
                         {
                           lastNameVerification=false;
                           lastNameMssgColor=Colors.red;
                           lastNameMssg="It should start with a capital letter and the rest must be lowercase";
                         }
                       }
                       setState(() {

                       });
                     },
                   true,
                   50,
                   "Last Name"
                 ),
                 SizedBox(height: 5),
                 Padding(
                   padding: const EdgeInsets.only(left: 35.0,right: 35.0),
                   child: Text(
                     lastNameMssg,
                     style: TextStyle(
                       color: lastNameMssgColor,
                       fontWeight: FontWeight.bold,
                       fontSize: MediaQuery.of(context).size.height * 0.018,
                     ),
                   ),
                 ),
                 SizedBox(height: 25),

                 //Username Input
                 inputFieldWidget.NormalInputFieldWithOnChange(
                   context,
                   userName,
                   "E.g, ABCD123",
                   Icon(Icons.supervised_user_circle),
                   TextInputType.text,
                   Icon(Icons.verified_user, color: userNameMssgColor),
                   (value) async
                   {
                     print(value);
                     if(value.isEmpty)
                     {
                       userNameVerification=false;
                       userNameMssgColor=Colors.red;
                       userNameMssg="Username is required";
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
                           userNameVerification=false;
                           userNameMssgColor=Colors.red;
                           userNameMssg="Username already exists";
                         }
                         else
                         {
                           userNameVerification=true;
                           userNameMssgColor=Colors.green;
                           userNameMssg="";
                         }
                       }
                       else
                       {
                         userNameVerification=false;
                         userNameMssgColor=Colors.red;
                         userNameMssg="It must be at least 6 characters long and contain only letters and numbers without spaces";
                       }
                     }
                     setState(() {

                     });
                   },
                   true,
                   50,
                   "Username"
                 ),
                 SizedBox(height: 5),
                 Padding(
                   padding: const EdgeInsets.only(left: 35.0,right: 35.0),
                   child: Text(
                     userNameMssg,
                     style: TextStyle(
                         color: userNameMssgColor,
                         fontWeight: FontWeight.bold,
                         fontSize: MediaQuery.of(context).size.height * 0.018
                     ),
                   ),
                 ),
                 SizedBox(height: 25),

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

                 //Phone Number Input
                 inputFieldWidget.NormalInputFieldWithOnChange(
                     context,
                     phoneNumber,
                     "E.g, 1234567890",
                     Icon(Icons.phone),
                     TextInputType.phone,
                     Icon(Icons.verified_user, color: phoneNumberMssgColor),
                     (value) async
                     {
                       print(value);
                       phoneNumberOtpMssg="";
                       phoneNumberOtpSuffixText="Send OTP";
                       phoneNumberGeneratedOTP="";
                       phoneNumberSendOtpVisibility=true;
                       phoneNumberVerifyOtpVisibility=false;
                       isPhoneNumberTimerActive=true;
                       phoneNumberTimerSeconds = 120;
                       phoneNumberOtp.text="";
                       phoneNumberOtpVerification=false;
                       phoneNumberOtpGeneratedTime=null;
                       if(phoneNumberOtpVerification)
                       {
                         phoneNumberOtpMssg="";
                         phoneNumberOtpSuffixText="Send OTP";
                         phoneNumberGeneratedOTP="";
                         phoneNumberSendOtpVisibility=true;
                         phoneNumberVerifyOtpVisibility=false;
                         isPhoneNumberTimerActive=true;
                         phoneNumberTimerSeconds = 120;
                         phoneNumberOtp.text="";
                         phoneNumberOtpVerification=false;
                         phoneNumberOtpGeneratedTime=null;
                       }

                       if(value.isEmpty)
                       {
                         phoneNumberVerification=false;
                         phoneNumberMssgColor=Colors.red;
                         phoneNumberMssg="Field is required";
                       }
                       else
                       {
                         RegExp regExp = RegExp(r'^\d{10}$');
                         bool match = regExp.hasMatch(value);

                         if(match)
                         {
                           QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("shopowner").where("phonenumber", isEqualTo: value).get();

                           if(snapshot.docs.isNotEmpty)
                           {
                             phoneNumberVerification=false;
                             phoneNumberMssgColor=Colors.red;
                             phoneNumberMssg="Phone Number already exists";
                           }
                           else
                           {
                             phoneNumberVerification=true;
                             phoneNumberMssgColor=Colors.green;
                             phoneNumberMssg="";
                             this.phoneNumberGeneratedOTP= otpAuth.generateOTP();
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
                   phoneNumberDisabled,
                   10,
                   "Phone number"
                 ),
                 SizedBox(height: 5),
                 Padding(
                   padding: const EdgeInsets.only(left: 35.0,right: 35.0),
                   child: Text(
                     phoneNumberMssg,
                     style: TextStyle(
                       color: phoneNumberMssgColor,
                         fontWeight: FontWeight.bold,
                         fontSize: MediaQuery.of(context).size.height * 0.018
                     ),
                   ),
                 ),
                 if(phoneNumberVerifiedEnabledDisabled) TextButton(
                   onPressed: (){

                     setState(() {
                       phoneNumber.text="";
                       phoneNumberOtp.text="";

                       phoneNumberMssg="";
                       phoneNumberOtpMssg="";
                       phoneNumberMssgColor=Colors.red;

                       phoneNumberOtpSuffixText="Send OTP";
                       phoneNumberGeneratedOTP="";

                       phoneNumberSendOtpVisibility=true;
                       phoneNumberVerifyOtpVisibility=false;
                       isPhoneNumberTimerActive=true;
                       phoneNumberVerifiedEnabledDisabled=false;

                       phoneNumberVerification=false;
                       phoneNumberOtpVerification=false;
                       phoneNumberDisabled=true;

                       phoneNumberTimerSeconds = 120;
                       phoneNumberOtpGeneratedTime=null;
                       phoneNumberOtpMssgColor=Colors.green;
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
                 if(phoneNumberVerification && !phoneNumberVerifiedEnabledDisabled) inputFieldWidget.otpInputField(
                   context,
                   phoneNumberOtp,
                   "OTP",
                   TextInputType.number,
                   TextButton(
                     onPressed: () async{
                       if(phoneNumberSendOtpVisibility==true && phoneNumberVerifyOtpVisibility==false)
                       {
                         //Send Otp Code
                         phoneNumberOtpMssgColor=Colors.green;
                         phoneNumberOtpMssg="Processing....";

                         bool sendOTP= await otpAuth.sendPhoneOTP(this.phoneNumber.text.toString(), this.phoneNumberGeneratedOTP);

                         if(sendOTP)
                         {
                           phoneNumberOtpGeneratedTime= DateTime.now();
                           phoneNumberSendOtpVisibility=false;
                           phoneNumberVerifyOtpVisibility=true;
                           phoneNumberOtpSuffixText="Verify OTP";
                           phoneNumberOtpMssgColor=Colors.green;
                           phoneNumberOtpMssg="OTP send on your phone number";
                           phoneNumberTimerSeconds=120;
                           isPhoneNumberTimerActive=true;
                           _phoneNumberTimer = Timer.periodic(Duration(seconds: 1), (timer) {
                             setState(() {
                               if (phoneNumberTimerSeconds > 0) {
                                 phoneNumberTimerSeconds--;
                               } else {
                                 isPhoneNumberTimerActive = false;
                                 timer.cancel();
                               }
                             });
                           });
                           phoneNumberOtpVerification=false;
                         }
                         else
                         {
                           phoneNumberSendOtpVisibility=true;
                           phoneNumberVerifyOtpVisibility=false;
                           phoneNumberOtpSuffixText="Send OTP";
                           phoneNumberOtpMssgColor=Colors.red;
                           phoneNumberOtpMssg="Try Again";
                           phoneNumberOtpVerification=false;
                         }

                       }
                       else if(phoneNumberSendOtpVisibility==false && phoneNumberVerifyOtpVisibility==true)
                       {
                         phoneNumberOtpMssgColor=Colors.green;
                         phoneNumberOtpMssg="Wait....";
                         if((DateTime.now().difference(phoneNumberOtpGeneratedTime!))<=phoneNumberOtpValidityDuration)
                         {
                           bool verifyOTP = otpAuth.verifyOTP(this.phoneNumberGeneratedOTP, phoneNumberOtp.text.toString());

                           if (verifyOTP)
                           {
                             phoneNumberOtpSuffixText = "Verified";
                             phoneNumberOtpMssgColor=Colors.green;
                             phoneNumberOtpMssg = "";
                             phoneNumberSendOtpVisibility = true;
                             phoneNumberOtpVerification = true;
                             phoneNumberDisabled = false;
                             phoneNumberVerifiedEnabledDisabled = true;
                           }
                           else
                           {
                             phoneNumberSendOtpVisibility = false;
                             phoneNumberVerifyOtpVisibility = true;
                             phoneNumberOtpSuffixText = "Verify OTP";
                             phoneNumberOtpMssgColor=Colors.red;
                             phoneNumberOtpMssg = "Invalid OTP";
                             phoneNumberOtpVerification = false;
                           }
                         }
                         else
                         {
                           phoneNumberOtpMssgColor=Colors.red;
                           phoneNumberOtpMssg="OTP verification timeout. Try Again!";
                         }
                       }
                       else
                       {

                       }
                       setState(() {

                       });
                     },
                     child: Text(
                       phoneNumberOtpSuffixText,
                       style: TextStyle(
                         color: Colors.green,
                         fontWeight: FontWeight.bold,
                       ),
                     ),
                   ),
                 ),
                 if(phoneNumberVerification && !phoneNumberVerifiedEnabledDisabled) SizedBox(height: 5),
                 if(phoneNumberSendOtpVisibility==false && !phoneNumberVerifiedEnabledDisabled) Align(
                   alignment: Alignment.centerRight,
                   child: isPhoneNumberTimerActive
                       ? Text(
                     "Resend OTP in $phoneNumberTimerSeconds seconds",
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

                       phoneNumberOtpMssgColor=Colors.green;
                       phoneNumberOtpMssg="Processing....";

                       this.phoneNumberGeneratedOTP= otpAuth.generateOTP();
                       bool sendOTP= await otpAuth.sendPhoneOTP(this.phoneNumber.text.toString(), this.phoneNumberGeneratedOTP);

                       if(sendOTP)
                       {
                         phoneNumberOtpGeneratedTime= DateTime.now();
                         phoneNumberOtpMssgColor=Colors.green;
                         phoneNumberOtpMssg="OTP resend on your phone number";
                         phoneNumberTimerSeconds=120;
                         isPhoneNumberTimerActive=true;
                         _phoneNumberTimer = Timer.periodic(Duration(seconds: 1), (timer) {
                           setState(() {
                             if (phoneNumberTimerSeconds > 0) {
                               phoneNumberTimerSeconds--;
                             } else {
                               isPhoneNumberTimerActive = false;
                               timer.cancel();
                             }
                           });
                         });
                       }
                       else
                       {
                         isPhoneNumberTimerActive = false;
                         phoneNumberOtpMssgColor=Colors.red;
                         phoneNumberOtpMssg="Try Again";
                       }

                     },
                   ),
                 ),
                 if(phoneNumberVerification && !phoneNumberVerifiedEnabledDisabled) SizedBox(height: 5),
                 if(phoneNumberVerification && !phoneNumberVerifiedEnabledDisabled) Padding(
                   padding: const EdgeInsets.only(left: 35.0,right: 35.0),
                   child: Text(
                     phoneNumberOtpMssg,
                     style: TextStyle(
                         color: phoneNumberOtpMssgColor,
                         fontWeight: FontWeight.bold,
                         fontSize: MediaQuery.of(context).size.height * 0.018
                     ),
                   ),
                 ),
                 if(phoneNumberVerification && !phoneNumberVerifiedEnabledDisabled) SizedBox(height: 25),


                 //Email Input
                 inputFieldWidget.NormalInputFieldWithOnChange(
                     context,
                     email,
                     "E.g, user@example.com",
                     Icon(Icons.email),
                     TextInputType.emailAddress,
                     Icon(Icons.verified_user, color: emailMssgColor),
                     (value) async
                     {
                       print(value);

                       emailOtpMssg="";
                       emailOtpSuffixText="Send OTP";
                       emailGeneratedOTP="";
                       emailSendOtpVisibility=true;
                       emailVerifyOtpVisibility=false;
                       isEmailTimerActive=true;
                       emailTimerSeconds = 120;
                       emailOtp.text="";
                       emailOtpVerification=false;
                       emailOtpGeneratedTime=null;
                       emailOtpMssgColor=Colors.green;
                       if(emailOtpVerification)
                       {
                         emailOtpMssg="";
                         emailOtpSuffixText="Send OTP";
                         emailGeneratedOTP="";
                         emailSendOtpVisibility=true;
                         emailVerifyOtpVisibility=false;
                         isEmailTimerActive=true;
                         emailTimerSeconds = 120;
                         emailOtp.text="";
                         emailOtpVerification=false;
                         emailOtpGeneratedTime=null;
                         emailOtpMssgColor=Colors.green;
                       }


                       if(value.isEmpty)
                       {
                         emailVerification=false;
                         emailMssgColor=Colors.red;
                         emailMssg="Field is required";
                       }
                       else
                       {
                         RegExp regExp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                         bool match = regExp.hasMatch(value);

                         if(match)
                         {
                           QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("shopowner").where("email", isEqualTo: value).get();

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
                             this.emailGeneratedOTP= otpAuth.generateOTP();
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
                   emailDisabled,
                   100,
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
                         fontSize: MediaQuery.of(context).size.height * 0.018
                     ),
                   ),
                 ),
                 if(emailVerifiedEnabledDisabled) TextButton(
                     onPressed: (){

                       setState(() {
                         email.text="";
                         emailOtp.text="";

                         emailMssg="";
                         emailOtpMssg="";
                         emailMssgColor=Colors.red;

                         emailOtpSuffixText="Send OTP";
                         emailGeneratedOTP="";

                         emailSendOtpVisibility=true;
                         emailVerifyOtpVisibility=false;
                         isEmailTimerActive=true;
                         emailVerifiedEnabledDisabled=false;

                         emailVerification=false;
                         emailOtpVerification=false;
                         emailDisabled=true;

                         emailTimerSeconds = 120;
                         emailOtpGeneratedTime=null;
                         emailOtpMssgColor=Colors.green;
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
                 if(emailVerification && !emailVerifiedEnabledDisabled) inputFieldWidget.otpInputField(
                     context,
                     emailOtp,
                     "OTP",
                     TextInputType.number,
                     TextButton(
                         onPressed: () async{
                           if(emailSendOtpVisibility==true && emailVerifyOtpVisibility==false)
                           {
                             emailOtpMssgColor=Colors.green;
                             emailOtpMssg="Processing....";
                             //Send Otp Code

                             bool sendOTP= await otpAuth.sendEmailOTP(this.email.text.toString(), this.emailGeneratedOTP);

                             if(sendOTP)
                             {
                               emailOtpGeneratedTime= DateTime.now();
                               emailSendOtpVisibility=false;
                               emailVerifyOtpVisibility=true;
                               emailOtpSuffixText="Verify OTP";
                               emailOtpMssgColor=Colors.green;
                               emailOtpMssg="OTP send on your email";
                               emailTimerSeconds=120;
                               isEmailTimerActive=true;
                               _emailTimer = Timer.periodic(Duration(seconds: 1), (timer) {
                                 setState(() {
                                   if (emailTimerSeconds > 0) {
                                     emailTimerSeconds--;
                                   } else {
                                     isEmailTimerActive = false;
                                     timer.cancel();
                                   }
                                 });
                               });
                               emailOtpVerification=false;
                             }
                             else
                             {
                               emailSendOtpVisibility=true;
                               emailVerifyOtpVisibility=false;
                               emailOtpSuffixText="Send OTP";
                               emailOtpMssgColor=Colors.red;
                               emailOtpMssg="Try Again";
                               emailOtpVerification=false;
                             }

                           }
                           else if(emailSendOtpVisibility==false && emailVerifyOtpVisibility==true)
                           {
                             //verify otp code
                             if((DateTime.now().difference(emailOtpGeneratedTime!))<=emailOtpValidityDuration)
                             {
                               bool verifyOTP = otpAuth.verifyOTP(this.emailGeneratedOTP, emailOtp.text.toString());

                               if (verifyOTP)
                               {
                                 emailOtpSuffixText = "Verified";
                                 emailOtpMssgColor=Colors.green;
                                 emailOtpMssg = "";
                                 emailSendOtpVisibility = true;
                                 emailOtpVerification = true;
                                 emailDisabled = false;
                                 emailVerifiedEnabledDisabled = true;
                               }
                               else
                               {
                                 emailSendOtpVisibility = false;
                                 emailVerifyOtpVisibility = true;
                                 emailOtpSuffixText = "Verify OTP";
                                 emailOtpMssgColor=Colors.red;
                                 emailOtpMssg = "Invalid OTP";
                                 emailOtpVerification = false;
                               }
                             }
                             else
                             {
                               emailOtpMssgColor=Colors.red;
                               emailOtpMssg="OTP verification timeout. Try Again!";
                             }
                           }
                           else
                           {

                           }
                           setState(() {

                           });
                         },
                         child: Text(
                           emailOtpSuffixText,
                           style: TextStyle(
                             color: Colors.green,
                             fontWeight: FontWeight.bold,
                           ),
                         ),
                     ),
                 ),
                 if(emailVerification && !emailVerifiedEnabledDisabled) SizedBox(height: 5),
                 if(emailSendOtpVisibility==false && !emailVerifiedEnabledDisabled) Align(
                   alignment: Alignment.centerRight,
                   child: isEmailTimerActive
                   ? Text(
                     "Resend OTP in $emailTimerSeconds seconds",
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
                       emailOtpMssgColor=Colors.green;
                       emailOtpMssg="Processing....";
                       this.emailGeneratedOTP= otpAuth.generateOTP();
                       bool sendOTP= await otpAuth.sendEmailOTP(this.email.text.toString(), this.emailGeneratedOTP);

                       if(sendOTP)
                       {
                         emailOtpGeneratedTime= DateTime.now();
                         emailOtpMssgColor=Colors.green;
                         emailOtpMssg="OTP resend on your email";
                         emailTimerSeconds=120;
                         isEmailTimerActive=true;
                         _emailTimer = Timer.periodic(Duration(seconds: 1), (timer) {
                           setState(() {
                             if (emailTimerSeconds > 0) {
                               emailTimerSeconds--;
                             } else {
                               isEmailTimerActive = false;
                               timer.cancel();
                             }
                           });
                         });
                       }
                       else
                       {
                         isEmailTimerActive = false;
                         emailOtpMssgColor=Colors.red;
                         emailOtpMssg="Try Again";
                       }
                     },
                   ),
                 ),
                 if(emailVerification && !emailVerifiedEnabledDisabled) SizedBox(height: 5),
                 if(emailVerification && !emailVerifiedEnabledDisabled) Padding(
                   padding: const EdgeInsets.only(left: 35.0,right: 35.0),
                   child: Text(
                     emailOtpMssg,
                     style: TextStyle(
                         color: emailOtpMssgColor,
                         fontWeight: FontWeight.bold,
                         fontSize: MediaQuery.of(context).size.height * 0.018
                     ),
                   ),
                 ),
                 if(emailVerification && !emailVerifiedEnabledDisabled) SizedBox(height: 25),

                 //Register Button
                 buttonWidget.ButtonField(
                   context,
                   "Register",
                   () async{
                       if(firstNameVerification==true && lastNameVerification==true && userNameVerification==true
                       && passwordVerification==true && confirmPasswordVerification==true && phoneNumberVerification==true
                       && emailVerification==true && emailOtpVerification==true && phoneNumberOtpVerification==true)
                       {
                         String firstName = this.firstName.text.toString();
                         String lastName = this.lastName.text.toString();
                         String userName = this.userName.text.toString();
                         String password = this.confirmPassword.text.toString();
                         String phoneNumber = this.phoneNumber.text.toString();
                         String email = this.email.text.toString();

                         String id = documentIdManage.generateOwnerDocumentId(userName, phoneNumber, email);

                         Map<String, dynamic> data = {

                           "firstname":firstName,
                           "lastname":lastName,
                           "username":userName,
                           "password":password,
                           "phonenumber":phoneNumber,
                           "email":email
                         };



                         try
                         {
                           await FirebaseFirestore.instance.collection("shopowner").doc(id).set(data);

                           toastWidget.showToast("Account Created!");

                           setState(() {

                             this.firstName.text="";
                             this.lastName.text="";
                             this.userName.text="";
                             this.password.text="";
                             this.confirmPassword.text="";
                             this.phoneNumber.text="";
                             this.email.text="";

                             this.firstNameMssg="";
                             this.lastNameMssg="";
                             this.userNameMssg="";
                             this.passwordMssg="";
                             this.confirmPasswordMssg="";
                             this.phoneNumberMssg="";
                             this.emailMssg="";

                             this.passwordVisibility=true;
                             this.confirmPasswordVisibility=false;

                             this.firstNameMssgColor=Colors.red;
                             this.lastNameMssgColor=Colors.red;
                             this.userNameMssgColor=Colors.red;
                             this.passwordMssgColor=Colors.green;
                             this.confirmPasswordMssgColor=Colors.red;
                             this.phoneNumberMssgColor=Colors.red;
                             this.emailMssgColor=Colors.red;

                             this.firstNameVerification=false;
                             this.lastNameVerification=false;
                             this.userNameVerification=false;
                             this.passwordVerification=false;
                             this.confirmPasswordVerification=false;
                             this.phoneNumberVerification=false;
                             this.emailVerification=false;

                             this.emailOtp.text="";
                             this.emailOtpVerification=false;
                             this.emailDisabled=true;
                             this.emailSendOtpVisibility=true;
                             this.emailVerifyOtpVisibility=false;
                             this.isEmailTimerActive=true;
                             this.emailVerifiedEnabledDisabled=false;
                             this.emailOtpMssg="";
                             this.emailOtpSuffixText="Send OTP";
                             this.emailGeneratedOTP="";
                             this.emailTimerSeconds = 120;
                             this._emailTimer;
                             this.emailOtpValidityDuration = Duration(minutes: 2);
                             this.emailOtpGeneratedTime;
                             this.emailOtpMssgColor=Colors.green;

                             this.phoneNumberOtp.text= "";
                             this.phoneNumberOtpVerification=false;
                             this.phoneNumberDisabled=true;
                             this.phoneNumberSendOtpVisibility=true;
                             this.phoneNumberVerifyOtpVisibility=false;
                             this.isPhoneNumberTimerActive=true;
                             this.phoneNumberVerifiedEnabledDisabled=false;
                             this.phoneNumberOtpMssg="";
                             this.phoneNumberOtpSuffixText="Send OTP";
                             this.phoneNumberGeneratedOTP="";
                             this.verificationId="";
                             this.phoneNumberTimerSeconds = 120;
                             this._phoneNumberTimer;
                             this.phoneNumberOtpValidityDuration = Duration(minutes: 2);
                             this.phoneNumberOtpGeneratedTime;
                             this.phoneNumberOtpMssgColor=Colors.green;
                           });
                         }
                         catch(e)
                         {
                           toastWidget.showToast(e.toString());
                         }

                       }
                       else
                       {
                         toastWidget.showToast("Try Again! Check inputs.");
                       }
                     },
                 ),
                 SizedBox(height: 30),

                 //Already have an account
                 InkWell(
                   child: Text(
                     "Already have an account?",
                     ),
                   onTap:(){
                     Navigator.pushReplacement(
                         context,
                         MaterialPageRoute(
                             builder: (context)=>LoginScreen(),
                         ));
                   },
                 ),
                 SizedBox(height: 25),
               ],
             ),
           ),
         )
       ),
     );
  }
}