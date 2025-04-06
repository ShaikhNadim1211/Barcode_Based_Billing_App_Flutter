import 'package:barcode_based_billing_system/methods/bill_print.dart';
import 'package:barcode_based_billing_system/methods/otp_auth.dart';
import 'package:barcode_based_billing_system/screens/shop_owner/bill_manage/shop_owner_manage_bill_screen.dart';
import 'package:barcode_based_billing_system/widgets/custom_button_widget.dart';
import 'package:barcode_based_billing_system/widgets/custom_toast_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';

class ShopOwnerViewBillScreen extends StatefulWidget
{
  final String ownerId;
  final String shopId;
  final String customerId;
  final String customerEmail;
  final Map<String, Map<String, dynamic>> productDetail;
  final String totalAmount;
  final String extraDiscount;
  final String extraCharges;
  final String paymentType;
  final String timeStamp;
  final String invoiceId;
  final String date;
  final String time;

  ShopOwnerViewBillScreen(this.ownerId, this.shopId, this.customerId, this.customerEmail, this.productDetail
      , this.totalAmount, this.extraDiscount, this.extraCharges, this.paymentType, this.timeStamp,
      this.invoiceId, this.date, this.time);

  @override
  State<StatefulWidget> createState()
  {

    return ShopOwnerViewBillScreenState();
  }
}

class ShopOwnerViewBillScreenState extends State<ShopOwnerViewBillScreen>
{
  CustomButtonWidget buttonWidget = CustomButtonWidget();
  CustomToastWidget toastWidget = CustomToastWidget();
  BillPrint billPrint = BillPrint();
  OtpAuth otpAuth = OtpAuth();

  String ownerId = "";
  String shopId = "";
  String customerId = "";
  String customerEmail = "";
  Map<String, Map<String, dynamic>> productDetail = {};
  String totalAmount = "";
  String extraDiscount = "";
  String extraCharges = "";
  String paymentType = "";
  String timeStamp = "";
  String invoiceId = "";
  String date = "";
  String time = "";

  Map<String, dynamic> shopDetails = {};
  Map<String, dynamic> customerDetails = {};

  late Future<Map<String, dynamic>> billData;

  bool displayBillFlag = false;

  final List<String> pdfTypes = [
    'A4',
    'Roll On',
    'Roll On Small',
  ];
  String? selectedPdfType;

  Future<Map<String, dynamic>> fetchBillData() async
  {

    // Fetch Shop Details using `shopId`
    QuerySnapshot shopSnapshot = await FirebaseFirestore.instance
        .collection("shop")
        .where("ownerid", isEqualTo: widget.ownerId)
        .where("shopname", isEqualTo: widget.shopId)
        .get();

    if (shopSnapshot.docs.isEmpty) {
      throw Exception('Shop not found');
    }

    setState(() {
      this.shopDetails = shopSnapshot.docs.first.data() as Map<String, dynamic>;
    });

    // Fetch Customer Details using `customerId`
    QuerySnapshot customerSnapshot = await FirebaseFirestore.instance
        .collection('customer')
        .where("ownerid", isEqualTo: widget.ownerId)
        .where("shopid",isEqualTo: widget.shopId)
        .where('customerid', isEqualTo: widget.customerId)
        .where("email", isEqualTo: widget.customerEmail)
        .get();

    if (customerSnapshot.docs.isEmpty) {
      throw Exception('Customer not found');
    }

    setState(() {
      this.customerDetails = customerSnapshot.docs.first.data() as Map<String, dynamic>;
    });


    // Return combined data
    return {
      'shop': this.shopDetails,
      'customer': this.customerDetails,
      'product': widget.productDetail,
    };
  }

  @override
  void initState()
  {
    super.initState();
    this.ownerId = widget.ownerId;
    this.shopId = widget.shopId;
    this.customerId = widget.customerId;
    this.customerEmail = widget.customerEmail;
    this.productDetail = widget.productDetail;
    this.totalAmount = widget.totalAmount;
    this.extraDiscount = widget.extraDiscount;
    this.extraCharges = widget.extraCharges;
    this.paymentType = widget.paymentType;
    this.timeStamp = widget.timeStamp;
    this.invoiceId = widget.invoiceId;
    this.date = widget.date;
    this.time = widget.time;

    billData = fetchBillData();
  }

  @override
  Widget build(BuildContext context)
  {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Bill Data",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                MaterialPageRoute(
                    builder: (context)=>ShopOwnerManageBillScreen()
                )
              );
            },
            icon: Icon(Icons.arrow_back),
          ),
        ),

        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Container(
                  height: MediaQuery.of(context).size.height * 0.45,
                  decoration: BoxDecoration(
                    color: Color(0xFFC8EFD1).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Scrollbar(
                    thumbVisibility: false,
                    child: FutureBuilder<Map<String, dynamic>>(
                      future: billData,
                      builder: (context, snapshot) {

                        if (snapshot.connectionState == ConnectionState.waiting)
                        {
                          this.displayBillFlag = false;
                          return Center(
                              child: CircularProgressIndicator()
                          );
                        }
                        else if (snapshot.hasError)
                        {
                          this.displayBillFlag = false;
                          return Center(
                            child: Text(
                              'Error: ${snapshot.error}',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: MediaQuery.of(context).size.height * 0.04,
                              ),
                            ),
                          );
                        }
                        else if (snapshot.hasData)
                        {

                          var data = snapshot.data!;
                          var shopDetails = data['shop'];
                          var customerDetails = data['customer'];
                          var productDetails = data['product'];


                          this.displayBillFlag = true;

                          return ListView(
                            padding: const EdgeInsets.all(10),
                            children: [

                              // Shop Details
                              Text(
                                'Shop: ${shopDetails['shopname']}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Email: ${shopDetails['email']}',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Phone Number: ${shopDetails['phonenumber']}',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Address: ${shopDetails['address']}',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 2),
                              Divider(color: Colors.black),

                              // Customer Details
                              Text(
                                'Customer ID: ${customerDetails['customerid']}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Customer Name: ${customerDetails['customername']}',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Email: ${customerDetails['email']}',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Address: ${customerDetails['address']}',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 2),
                              Divider(color: Colors.black,),

                              // Product Details
                              Text(
                                'Product Details:',
                                style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.height * 0.025,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black
                                ),
                              ),
                              SizedBox(height: 5),
                              // Table for Products
                              Table(
                                border: TableBorder.all(
                                  color: Colors.black,
                                  style: BorderStyle.solid,
                                  width: 1,
                                ),
                                children: [

                                  // Table Headers
                                  TableRow(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                    ),
                                    children: [

                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Product Name',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Price x Quantity',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  // Product Rows
                                  for (var product in productDetails.values)
                                    TableRow(
                                      children: [
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              product['productname'],
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              '${product['finalprice']} Rs x ${product['itemquantity']} = ${double.parse(product['finalprice'].toString()) * double.parse(product['itemquantity'])}',
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                              SizedBox(height: 2),
                              Divider(color: Colors.black,),

                              // Extra Charges and Discounts
                              Text(
                                'Extra Charges: ${widget.extraCharges.toString()} Rs',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Extra Discount: ${widget.extraDiscount.toString()} Rs',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 2),
                              Divider(color: Colors.black,),

                              //Payment Type
                              Text(
                                'Payment Type: ${widget.paymentType.toString()}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 2),
                              Divider(color: Colors.black,),

                              // Total Amount
                              Text(
                                'Total: ${widget.totalAmount} Rs',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: MediaQuery.of(context).size.height * 0.025,
                                ),
                              ),
                            ],
                          );
                        }
                        else
                        {
                          this.displayBillFlag = false;
                          return Center(
                              child: Text(
                                'No Data Found',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: MediaQuery.of(context).size.height * 0.04,
                                ),
                              )
                          );
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),

                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [


                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black54, width: 2),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedPdfType,
                          hint: Text(
                            "Select PDF Print Type",
                            style: TextStyle(color: Colors.black),
                          ),
                          items: pdfTypes.map((String type) {
                            return DropdownMenuItem<String>(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                          dropdownColor: Theme.of(context).cardColor,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedPdfType = newValue;
                            });
                          },
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),

                    //Send
                    this.buttonWidget.ButtonField(
                        context,
                        "Send",
                        () async
                        {
                          await Future.delayed(Duration(milliseconds: 300));
                          toastWidget.showToast("Processing..");

                          bool sendEmail = await otpAuth.sendInvoiceBill(
                              invoiceId,
                              date,
                              time,
                              shopDetails,
                              customerDetails,
                              productDetail,
                              extraCharges,
                              extraDiscount,
                              paymentType,
                              totalAmount
                          );

                          if(sendEmail)
                          {
                            await Future.delayed(Duration(milliseconds: 300));
                            toastWidget.showToast("Send..");
                          }
                          else
                          {
                            await Future.delayed(Duration(milliseconds: 300));
                            toastWidget.showToast("Try again");
                          }

                        }
                    ),
                    SizedBox(height: 15),

                    //Print
                    this.buttonWidget.ButtonField(
                        context,
                        "Print",
                        () async
                        {
                          if(this.selectedPdfType!=null && this.selectedPdfType!.isNotEmpty)
                          {
                            if(this.selectedPdfType=="A4")
                            {
                              billPrint.printBillA4Bill(
                                  this.invoiceId,
                                  this.date,
                                  this.time,
                                  this.shopDetails,
                                  this.customerDetails,
                                  this.productDetail,
                                  this.extraCharges,
                                  this.extraDiscount,
                                  this.paymentType,
                                  this.totalAmount
                              );
                            }
                            if(this.selectedPdfType=="Roll On")
                            {
                              billPrint.printBillRollOnBill(
                                  this.invoiceId,
                                  this.date,
                                  this.time,
                                  this.shopDetails,
                                  this.customerDetails,
                                  this.productDetail,
                                  this.extraCharges,
                                  this.extraDiscount,
                                  this.paymentType,
                                  this.totalAmount,
                                  PdfPageFormat.roll80
                              );
                            }
                            if(this.selectedPdfType=="Roll On Small")
                            {
                              billPrint.printBillRollOnBill(
                                  this.invoiceId,
                                  this.date,
                                  this.time,
                                  this.shopDetails,
                                  this.customerDetails,
                                  this.productDetail,
                                  this.extraCharges,
                                  this.extraDiscount,
                                  this.paymentType,
                                  this.totalAmount,
                                  PdfPageFormat.roll57
                              );
                            }
                          }
                          else
                          {
                            await Future.delayed(Duration(milliseconds: 300));
                            toastWidget.showToast("Select PDF Print Type");
                          }
                        }
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              ],
            ),
          ),
        ),

      ),
    );
  }
}