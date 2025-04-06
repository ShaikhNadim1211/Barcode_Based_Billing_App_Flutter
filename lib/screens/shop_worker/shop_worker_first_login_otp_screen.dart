import 'dart:async';

import 'package:barcode_based_billing_system/methods/otp_auth.dart';
import 'package:barcode_based_billing_system/screens/common/login_screen.dart';
import 'package:barcode_based_billing_system/screens/shop_worker/shop_worker_first_login_password_change_screen.dart';
import 'package:barcode_based_billing_system/widgets/custom_button_widget.dart';
import 'package:barcode_based_billing_system/widgets/custom_input_field_widget.dart';
import 'package:barcode_based_billing_system/widgets/custom_toast_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShopWorkerFirstLoginOtpScreen extends StatefulWidget
{
  final String ownerId;
  final String shopId;
  final String workerId;
  final String email;
  final String phoneNumber;
  final String password;

  ShopWorkerFirstLoginOtpScreen(this.ownerId, this.shopId, this.workerId, this.password, this.email, this.phoneNumber);

  @override
  State<StatefulWidget> createState()
  {
    return ShopWorkerFirstLoginOtpScreenState();
  }
}

class ShopWorkerFirstLoginOtpScreenState extends State<ShopWorkerFirstLoginOtpScreen>
{
  String ownerId = "";
  String shopId = "";
  String workerId = "";
  String email = "";
  String phoneNumber = "";
  String password = "";

  CustomInputFieldWidget inputFieldWidget= CustomInputFieldWidget();
  CustomButtonWidget buttonWidget= CustomButtonWidget();
  CustomToastWidget toastWidget = CustomToastWidget();
  OtpAuth otpAuth= OtpAuth();

  TextEditingController otp= TextEditingController();
  bool otpVerification=false;
  bool sendOtpVisibility=true;
  bool verifyOtpVisibility=false;
  bool isTimerActive=true;
  String otpMssg="";
  String otpSuffixText="Send OTP";
  String generatedOTP="";
  int timerSeconds = 120;
  late Timer _timer;
  Duration otpValidityDuration = Duration(minutes: 2);
  DateTime? otpGeneratedTime;
  Color otpMssgColor=Colors.green;

  @override
  void initState()
  {
    super.initState();

    this.ownerId = widget.ownerId;
    this.shopId = widget.shopId;
    this.workerId = widget.workerId;
    this.email = widget.email;
    this.phoneNumber = widget.phoneNumber;
    this.password = widget.password;
    
    this.generatedOTP = otpAuth.generateOTP();

  }

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
                padding: EdgeInsets.only(left: 25,right: 25,),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    
                    SizedBox(height: 30,),
                    Text(
                      "Enter OTP",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.height * 0.04,
                      ),
                    ),
                    SizedBox(height: 50),
                    
                    //OTP Field
                    inputFieldWidget.otpInputField(
                      context,
                      otp,
                      "OTP",
                      TextInputType.number,
                      TextButton(
                        onPressed: () async
                        {

                          if(sendOtpVisibility==true && verifyOtpVisibility==false)
                          {
                            otpMssgColor=Colors.green;
                            otpMssg="Processing....";
                            //Send Otp Code

                            bool sendEmailOTP= await otpAuth.sendWorkerEmailOTP(this.email, this.generatedOTP);
                            bool sendPhoneOTP=await otpAuth.sendPhoneOTP(this.phoneNumber, this.generatedOTP);

                            if(sendEmailOTP || sendPhoneOTP)
                            {
                              otpGeneratedTime= DateTime.now();
                              sendOtpVisibility=false;
                              verifyOtpVisibility=true;
                              otpSuffixText="Verify OTP";
                              otpMssgColor=Colors.green;
                              otpMssg="OTP send";
                              timerSeconds=120;
                              isTimerActive=true;
                              _timer = Timer.periodic(Duration(seconds: 1), (timer) {
                                setState(() {
                                  if (timerSeconds > 0) 
                                  {
                                    timerSeconds--;
                                  } 
                                  else 
                                  {
                                    isTimerActive = false;
                                    timer.cancel();
                                  }
                                });
                              });
                              otpVerification=false;
                            }
                            else
                            {
                              sendOtpVisibility=true;
                              verifyOtpVisibility=false;
                              otpSuffixText="Send OTP";
                              otpMssgColor=Colors.red;
                              otpMssg="Try Again";
                              otpVerification=false;
                            }

                          }
                          else if(sendOtpVisibility==false && verifyOtpVisibility==true)
                          {
                            //verify otp code
                            if((DateTime.now().difference(otpGeneratedTime!))<=otpValidityDuration)
                            {
                              bool verifyOTP = otpAuth.verifyOTP(this.generatedOTP, otp.text.toString());

                              if (verifyOTP)
                              {
                                otpSuffixText = "Verified";
                                otpMssgColor=Colors.green;
                                otpMssg = "";
                                sendOtpVisibility = true;
                                otpVerification = true;
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context)=>ShopWorkerFirstLoginPasswordChangeScreen(ownerId, shopId, workerId, password, email, phoneNumber)
                                  ),
                                );
                              }
                              else
                              {
                                sendOtpVisibility = false;
                                verifyOtpVisibility = true;
                                otpSuffixText = "Verify OTP";
                                otpMssgColor=Colors.red;
                                otpMssg = "Invalid OTP";
                                otpVerification = false;
                              }
                            }
                            else
                            {
                              otpMssgColor=Colors.red;
                              otpMssg="OTP verification timeout. Try Again!";
                            }
                          }
                          else
                          {

                          }
                          setState(() {

                          });
                        },
                        child: Text(
                          otpSuffixText,
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Align(
                      alignment: Alignment.centerRight,
                      child: isTimerActive
                          ? Text(
                        "Resend OTP in $timerSeconds seconds",
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
                          otpMssgColor=Colors.green;
                          otpMssg="Processing....";
                          this.generatedOTP = otpAuth.generateOTP();

                          bool sendEmailOTP=await otpAuth.sendWorkerEmailOTP(this.email, this.generatedOTP);
                          bool sendPhoneOTP= await otpAuth.sendPhoneOTP(this.phoneNumber, this.generatedOTP);
                          
                          if(sendEmailOTP || sendPhoneOTP)
                          {
                            otpGeneratedTime= DateTime.now();
                            otpMssgColor=Colors.green;
                            otpMssg="OTP resend";
                            timerSeconds=120;
                            isTimerActive=true;
                            _timer = Timer.periodic(Duration(seconds: 1), (timer) {
                              setState(() {
                                if (timerSeconds > 0) 
                                {
                                  timerSeconds--;
                                } 
                                else 
                                {
                                  isTimerActive = false;
                                  timer.cancel();
                                }
                              });
                            });
                          }
                          else
                          {
                            isTimerActive = false;
                            otpMssgColor=Colors.red;
                            otpMssg="Try Again";
                          }
                          setState(() {
                            
                          });
                        },
                      ),
                    ), 
                    SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.only(left: 35.0,right: 35.0),
                      child: Text(
                        otpMssg,
                        style: TextStyle(
                            color: otpMssgColor,
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.height * 0.018
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}