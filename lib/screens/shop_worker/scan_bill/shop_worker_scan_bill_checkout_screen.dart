import 'package:barcode_based_billing_system/screens/shop_worker/scan_bill/shop_worker_scan_bill_preview_screen.dart';
import 'package:barcode_based_billing_system/screens/shop_worker/shop_worker_home_screen.dart';
import 'package:barcode_based_billing_system/widgets/custom_button_widget.dart';
import 'package:barcode_based_billing_system/widgets/custom_input_field_widget.dart';
import 'package:barcode_based_billing_system/widgets/custom_toast_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShopWorkerScanBillCheckoutScreen extends StatefulWidget
{
  final String ownerId;
  final String shopId;
  final String workerId;
  final Map<String, int> barcodeNumberAndQuantity;
  final Map<String, Map<String, dynamic>> productDetails;
  final String customerId;
  final String customerEmail;

  ShopWorkerScanBillCheckoutScreen(this.ownerId, this.shopId, this.barcodeNumberAndQuantity, this.productDetails,this.customerId, this.customerEmail, this.workerId);

  @override
  State<StatefulWidget> createState()
  {
    return ShopWorkerScanBillCheckoutScreenState();
  }
}

class ShopWorkerScanBillCheckoutScreenState extends State<ShopWorkerScanBillCheckoutScreen>
{
  CustomButtonWidget buttonWidget = CustomButtonWidget();
  CustomInputFieldWidget inputFieldWidget = CustomInputFieldWidget();
  CustomToastWidget toastWidget = CustomToastWidget();

  String ownerId = "";
  String shopId = "";
  String workerId = "";
  Map<String, int> barcodeNumberAndQuantity = {};
  Map<String, Map<String, dynamic>> productDetails = {};
  String customerId = "";
  String customerEmail = "";

  TextEditingController extraCharges = TextEditingController();
  TextEditingController extraDiscount = TextEditingController();

  String extraChargesMssg = "";
  String extraDiscountMssg = "";

  Color extraChargesMssgColor = Colors.red;
  Color extraDiscountMssgColor = Colors.red;

  bool extraChargesVerification = true;
  bool extraDiscountVerification = true;

  final List<String> paymentTypes = [
    'Debit Card',
    'Credit Card',
    'UPI',
    'Cash',
    'Net Banking'
  ];
  String? selectedPaymentType;

  @override
  void initState()
  {
    super.initState();

    this.ownerId = widget.ownerId;
    this.shopId = widget.shopId;
    this.workerId = widget.workerId;
    this.barcodeNumberAndQuantity = widget.barcodeNumberAndQuantity;
    this.productDetails = widget.productDetails;
    this.customerId = widget.customerId;
    this.customerEmail = widget.customerEmail;
  }
  @override
  Widget build(BuildContext context)
  {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Checkout",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
          ),
        ),

        body: Padding(
          padding: EdgeInsets.only(left: 25, right: 25),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                SizedBox(height: 40),

                //Extra Charges
                inputFieldWidget.NormalInputFieldWithOnChange(
                    context,
                    extraCharges,
                    "E.g, 30 (Amount in Rs)",
                    Icon(Icons.money),
                    TextInputType.number,
                    Icon(null),
                        (value)
                    {
                      if(value.isEmpty)
                      {
                        extraChargesVerification = true;
                        extraChargesMssgColor = Colors.red;
                        extraChargesMssg = "";
                      }
                      else
                      {
                        RegExp regExp = RegExp(r"^(0|[1-9]\d*)(\.\d{1,2})?$");
                        bool match = regExp.hasMatch(value.trim());

                        if(match)
                        {
                          extraChargesVerification = true;
                          extraChargesMssgColor = Colors.green;
                          extraChargesMssg = "";
                        }
                        else
                        {
                          extraChargesVerification = false;
                          extraChargesMssgColor = Colors.red;
                          extraChargesMssg = "Please enter a valid amount. Only positive numbers up to two decimal places are allowed.";
                        }
                      }
                      setState(() {

                      });
                    },
                    true,
                    20,
                    "Extra Charges"
                ),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 35.0,right: 35.0),
                  child: Text(
                    extraChargesMssg,
                    style: TextStyle(
                      color: extraChargesMssgColor,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.height * 0.018,
                    ),
                  ),
                ),

                //Extra Discount
                inputFieldWidget.NormalInputFieldWithOnChange(
                    context,
                    extraDiscount,
                    "E.g, 15 (Amount in Rs)",
                    Icon(Icons.discount),
                    TextInputType.number,
                    Icon(null),
                        (value)
                    {
                      if(value.isEmpty)
                      {
                        extraDiscountVerification = true;
                        extraDiscountMssgColor = Colors.red;
                        extraDiscountMssg = "";
                      }
                      else
                      {
                        RegExp regExp = RegExp(r"^(0|[1-9]\d*)(\.\d{1,2})?$");
                        bool match = regExp.hasMatch(value.trim());

                        if(match)
                        {
                          extraDiscountVerification = true;
                          extraDiscountMssgColor = Colors.green;
                          extraDiscountMssg = "";
                        }
                        else
                        {
                          extraDiscountVerification = false;
                          extraDiscountMssgColor = Colors.red;
                          extraDiscountMssg = "Please enter a valid amount. Only positive numbers up to two decimal places are allowed.";
                        }
                      }
                      setState(() {

                      });
                    },
                    true,
                    20,
                    "Extra Discount"
                ),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 35.0,right: 35.0),
                  child: Text(
                    extraDiscountMssg,
                    style: TextStyle(
                      color: extraDiscountMssgColor,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.height * 0.018,
                    ),
                  ),
                ),
                SizedBox(height: 20),

                //Payment Type
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black54, width: 2),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedPaymentType,
                      hint: Text(
                        "Select Payment Type",
                        style: TextStyle(color: Colors.black),
                      ),
                      items: paymentTypes.map((String type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      dropdownColor: Theme.of(context).cardColor,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedPaymentType = newValue;
                        });
                      },
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),

                //Bill Generated
                SizedBox(height: 30),
                buttonWidget.ButtonField(
                  context,
                  "Bill Generate",
                      () async
                  {
                    String extraCharges = "";
                    String extraDiscount = "";
                    String paymentType = "";

                    if(this.extraChargesVerification && this.extraDiscountVerification)
                    {
                      if(this.selectedPaymentType==null || this.selectedPaymentType!.isEmpty)
                      {
                        await Future.delayed(Duration(milliseconds: 300));
                        toastWidget.showToast("Invalid Credential");
                      }
                      else
                      {
                        if(this.extraCharges.text.toString().trim().isEmpty)
                        {
                          extraCharges = "0";
                        }
                        else
                        {
                          extraCharges = this.extraCharges.text.toString().trim();
                        }

                        if(this.extraDiscount.text.toString().trim().isEmpty)
                        {
                          extraDiscount = "0";
                        }
                        else
                        {
                          extraDiscount = this.extraDiscount.text.toString().trim();
                        }

                        paymentType = this.selectedPaymentType!;

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ShopWorkerScanBillPreviewScreen(widget.ownerId, widget.shopId, widget.barcodeNumberAndQuantity, widget.productDetails, widget.customerId, widget.customerEmail, extraCharges, extraDiscount, paymentType, widget.workerId)
                            )
                        );
                      }
                    }
                    else
                    {
                      await Future.delayed(Duration(milliseconds: 300));
                      toastWidget.showToast("Invalid Credential");
                    }

                  },
                ),

                //Go to Dashboard
                SizedBox(height: 40),
                buttonWidget.GoToDashboardButtonField(
                    context,
                    "Go to Dashboard",
                        (){
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ShopWorkerHomeScreen()
                          )
                      );
                    }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}