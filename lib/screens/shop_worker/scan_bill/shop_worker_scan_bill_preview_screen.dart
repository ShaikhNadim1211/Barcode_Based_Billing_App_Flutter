import 'package:barcode_based_billing_system/firebase/shop_owner_document_id_manage.dart';
import 'package:barcode_based_billing_system/methods/bill_print.dart';
import 'package:barcode_based_billing_system/methods/otp_auth.dart';
import 'package:barcode_based_billing_system/screens/shop_worker/shop_worker_home_screen.dart';
import 'package:barcode_based_billing_system/widgets/custom_button_widget.dart';
import 'package:barcode_based_billing_system/widgets/custom_toast_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:intl/intl.dart';

class ShopWorkerScanBillPreviewScreen extends StatefulWidget
{
  final String ownerId;
  final String shopId;
  final String workerId;
  final Map<String, int> barcodeNumberAndQuantity;
  final Map<String, Map<String, dynamic>> productDetails;
  final String customerId;
  final String customerEmail;
  final String extraCharges;
  final String extraDiscount;
  final String paymentType;

  ShopWorkerScanBillPreviewScreen(this.ownerId, this.shopId, this.barcodeNumberAndQuantity, this.productDetails, this.customerId, this.customerEmail, this.extraCharges, this.extraDiscount, this.paymentType, this.workerId);

  @override
  State<StatefulWidget> createState()
  {
    return ShopWorkerScanBillPreviewScreenState();
  }
}

class ShopWorkerScanBillPreviewScreenState extends State<ShopWorkerScanBillPreviewScreen>
{
  CustomButtonWidget buttonWidget = CustomButtonWidget();
  CustomToastWidget toastWidget = CustomToastWidget();
  ShopOwnerDocumentIdManage documentIdManage = ShopOwnerDocumentIdManage();
  BillPrint billPrint = BillPrint();
  OtpAuth otpAuth = OtpAuth();

  String ownerId = "";
  String shopId = "";
  String workerId = "";
  Map<String, int> barcodeNumberAndQuantity = {};
  Map<String, Map<String, dynamic>> productDetails = {};
  String customerId = "";
  String customerEmail = "";
  String extraCharges = "";
  String extraDiscount = "";
  String paymentType = "";

  Map<String, dynamic> shopDetails = {};
  Map<String, dynamic> customerDetails = {};

  late Future<Map<String, dynamic>> billData;

  bool displayBillFlag = false;
  bool saveBillFlag = false;

  String totalAmount = "";
  String invoiceId = "";
  String date = "";
  String time = "";

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
      'product': widget.productDetails,
    };
  }


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
    this.extraCharges = widget.extraCharges;
    this.extraDiscount = widget.extraDiscount;
    this.paymentType = widget.paymentType;

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
              if(this.saveBillFlag)
              {

              }
              else
              {
                Navigator.pop(context);
              }
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

                          double totalAmount = 0;

                          productDetails.forEach((key, product) {

                            double finalPrice = double.parse(product['finalprice'].toString());
                            int quantity = int.parse(product['scannedCount'].toString());
                            totalAmount += finalPrice * quantity;

                          });


                          double extraCharges = double.parse(widget.extraCharges.toString());
                          double extraDiscount = double.parse(widget.extraDiscount.toString());
                          totalAmount += extraCharges - extraDiscount;

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
                                              '${product['finalprice']} Rs x ${product['scannedCount']} = ${double.parse(product['finalprice'].toString()) * double.parse(product['scannedCount'])}',
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
                                'Total: ${totalAmount.toStringAsFixed(2)} Rs',
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

                    //Save
                    if(this.saveBillFlag==false)
                      this.buttonWidget.ButtonField(
                          context,
                          "Save",
                              () async
                          {
                            String ownerId = widget.ownerId;
                            String shopId = widget.shopId;
                            String customerId = widget.customerId;
                            String customerEmail = widget.customerEmail;
                            double totalAmount = 0;

                            Map<String, Map<String, dynamic>> simplifiedProductDetails = {};
                            Map<String, Map<String, String>> productQuantityManage = {};

                            widget.productDetails.forEach((barcode, details) {
                              simplifiedProductDetails[barcode] = {
                                'productid': details['productid'],
                                'productname': details['productname'],
                                'buyingprice': details['buyingprice'],
                                'sellingprice': details['sellingprice'],
                                'barcodenumber': details['barcodenumber'],
                                'finalprice': details['finalprice'],
                                'itemquantity': details['scannedCount'],
                                'gst' : details['optionalFieldValue']['GST'] ?? "0",
                                'discount' : details['optionalFieldValue']['Discount'] ?? "0"
                              };

                              productQuantityManage[barcode] = {
                                "finalStockQuantity" : details["finalStockQuantity"],
                                "productid" : details["productid"]
                              };

                              double finalPrice = double.parse(details['finalprice'].toString());
                              int quantity = int.parse(details['scannedCount'].toString());
                              totalAmount += finalPrice * quantity;

                            });

                            double extraCharges = double.parse(widget.extraCharges.toString());
                            double extraDiscount = double.parse(widget.extraDiscount.toString());
                            totalAmount += extraCharges - extraDiscount;

                            String paymentType = widget.paymentType;
                            FieldValue timeStamp = FieldValue.serverTimestamp();
                            String invoiceId = documentIdManage.getInvoiceId();
                            String time = (DateFormat("hh:mm:ss a").format(DateTime.now())).toString();
                            String date = (DateFormat("dd-MM-yyyy").format(DateTime.now())).toString();

                            setState(() {
                              this.totalAmount = totalAmount.toStringAsFixed(2);
                              this.invoiceId = invoiceId;
                              this.date = date;
                              this.time = time;
                            });

                            if(ownerId.isNotEmpty && shopId.isNotEmpty && customerId.isNotEmpty && customerEmail.isNotEmpty
                                && simplifiedProductDetails.isNotEmpty && totalAmount.toString().isNotEmpty &&
                                extraCharges.toString().isNotEmpty && extraDiscount.toString().isNotEmpty && paymentType.isNotEmpty
                                && timeStamp.toString().isNotEmpty && invoiceId.isNotEmpty && time.isNotEmpty && date.isNotEmpty
                                && productQuantityManage.isNotEmpty)
                            {
                              Map<String, dynamic> data = {
                                "ownerid" : ownerId,
                                "shopid" : shopId,
                                "customerid" : customerId,
                                "customeremail" : customerEmail,
                                "productDetail" : simplifiedProductDetails,
                                "totalamount" : totalAmount.toStringAsFixed(2),
                                "extradiscount" : extraDiscount.toString(),
                                "extracharges" : extraCharges.toString(),
                                "paymenttype" : paymentType,
                                "timestamp" : timeStamp,
                                "invoiceid" : invoiceId,
                                "date" : date,
                                "time" :time,
                                "addedby" : widget.workerId
                              };

                              try
                              {
                                await FirebaseFirestore.instance.collection("invoice").add(data);

                                QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("product")
                                    .where("ownerid", isEqualTo: ownerId)
                                    .where("shopid", isEqualTo: shopId)
                                    .get();

                                if(snapshot.docs.isNotEmpty)
                                {
                                  for(var doc in snapshot.docs)
                                  {
                                    Map<String, dynamic> productData = doc.data() as Map<String, dynamic>;
                                    String barcode = productData["barcodenumber"];

                                    if (widget.productDetails.containsKey(barcode))
                                    {
                                      await FirebaseFirestore.instance.collection("product")
                                          .doc(doc.id)
                                          .update({
                                        'quantity': widget.productDetails[barcode]!["finalStockQuantity"],
                                      });
                                    }
                                  }
                                }

                                this.saveBillFlag = true;

                                await Future.delayed(Duration(milliseconds: 300));
                                toastWidget.showToast("Saved");
                              }
                              catch(e)
                              {
                                this.saveBillFlag = false;
                                await Future.delayed(Duration(milliseconds: 300));
                                toastWidget.showToast("Try again");
                              }

                            }
                            else
                            {
                              this.saveBillFlag = false;
                              await Future.delayed(Duration(milliseconds: 300));
                              toastWidget.showToast("Try again");
                            }
                            setState(() {

                            });
                          }
                      ),
                    SizedBox(height: 15),

                    if(this.saveBillFlag)
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
                    if(this.saveBillFlag)
                      this.buttonWidget.ButtonField(
                          context,
                          "Send",
                              () async
                          {
                            await Future.delayed(Duration(milliseconds: 300));
                            toastWidget.showToast("Processing..");

                            bool sendEmail = await otpAuth.sendInvoice(
                                invoiceId,
                                date,
                                time,
                                shopDetails,
                                customerDetails,
                                productDetails,
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
                    if(this.saveBillFlag)
                      this.buttonWidget.ButtonField(
                          context,
                          "Print",
                              () async
                          {
                            if(this.selectedPdfType!=null && this.selectedPdfType!.isNotEmpty)
                            {
                              if(this.selectedPdfType=="A4")
                              {
                                billPrint.printBillA4(
                                    this.invoiceId,
                                    this.date,
                                    this.time,
                                    this.shopDetails,
                                    this.customerDetails,
                                    this.productDetails,
                                    this.extraCharges,
                                    this.extraDiscount,
                                    this.paymentType,
                                    this.totalAmount
                                );
                              }
                              if(this.selectedPdfType=="Roll On")
                              {
                                billPrint.printBillRollOn(
                                    this.invoiceId,
                                    this.date,
                                    this.time,
                                    this.shopDetails,
                                    this.customerDetails,
                                    this.productDetails,
                                    this.extraCharges,
                                    this.extraDiscount,
                                    this.paymentType,
                                    this.totalAmount,
                                    PdfPageFormat.roll80
                                );
                              }
                              if(this.selectedPdfType=="Roll On Small")
                              {
                                billPrint.printBillRollOn(
                                    this.invoiceId,
                                    this.date,
                                    this.time,
                                    this.shopDetails,
                                    this.customerDetails,
                                    this.productDetails,
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

                    //Go to Dashboard
                    if(this.saveBillFlag)
                      this.buttonWidget.GoToDashboardButtonField(
                          context,
                          "Go to Dashboard",
                              ()
                          {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ShopWorkerHomeScreen()
                              ),
                            );
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