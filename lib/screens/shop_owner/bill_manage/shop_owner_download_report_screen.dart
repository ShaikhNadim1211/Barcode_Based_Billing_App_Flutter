import 'dart:convert';
import 'dart:io';

import 'package:barcode_based_billing_system/methods/download_file.dart';
import 'package:barcode_based_billing_system/screens/shop_owner/bill_manage/shop_owner_manage_bill_screen.dart';
import 'package:barcode_based_billing_system/widgets/custom_button_widget.dart';
import 'package:barcode_based_billing_system/widgets/custom_input_field_widget.dart';
import 'package:barcode_based_billing_system/widgets/custom_toast_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class ShopOwnerDownloadReportScreen extends StatefulWidget
{
  final String ownerId;
  final String shopId;

  ShopOwnerDownloadReportScreen(this.ownerId, this.shopId);
  @override
  State<StatefulWidget> createState()
  {
    return ShopOwnerDownloadReportScreenState();
  }
}

class ShopOwnerDownloadReportScreenState extends State<ShopOwnerDownloadReportScreen>
{
  CustomToastWidget toastWidget = CustomToastWidget();
  CustomInputFieldWidget inputFieldWidget = CustomInputFieldWidget();
  CustomButtonWidget buttonWidget = CustomButtonWidget();
  DownloadFile downloadFile = DownloadFile();

  late Stream<QuerySnapshot> billStream;

  String ownerId = "";
  String shopId = "";

  TextEditingController date = TextEditingController();
  String dateMssg = "Maximum 30 days are allowed";
  Color dateMssgColor = Colors.green;
  bool dateVerification = false;

  late DateTime startDate;
  late DateTime endDate;

  @override
  void initState()
  {
    super.initState();
    this.ownerId = widget.ownerId;
    this.shopId = widget.shopId;
  }

  @override
  Widget build(BuildContext context)
  {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Download Report",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
            ),
          ),
          leading: IconButton(
              onPressed: (){
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context)=>ShopOwnerManageBillScreen()
                    )
                );
              },
              icon: Icon(Icons.arrow_back)
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

                SizedBox(height: 30,),

                inputFieldWidget.DateInputField(
                    context,
                    date,
                    "Date",
                    IconButton(
                        onPressed: () async{

                          DateTimeRange? pickedRange = await showDateRangePicker(
                            context: context,
                            firstDate: DateTime(2024),
                            lastDate: DateTime.now().subtract(Duration(days: 1)),
                            currentDate: DateTime.now().subtract(Duration(days: 1)),
                            builder: (BuildContext context, Widget? child) {
                              return Theme(
                                data: ThemeData.light().copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: Color(0xFFABE6B2),
                                    onPrimary: Colors.black,
                                    secondary: Color(0xFFC8EFD1),
                                    onSecondary: Colors.black,
                                    surface: Colors.white,
                                    onSurface: Colors.black,
                                  ),
                                  dialogBackgroundColor: Colors.white,
                                  textButtonTheme: TextButtonThemeData(
                                    style: ButtonStyle(
                                      foregroundColor: WidgetStateProperty.all(Colors.black),
                                    ),
                                  ),
                                  inputDecorationTheme: InputDecorationTheme(
                                    labelStyle: TextStyle(color: Colors.black),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black),
                                    ),
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );

                          if(pickedRange!=null)
                          {
                            Duration difference = pickedRange.end.difference(pickedRange.start);

                            if(difference.inDays <= 30)
                            {
                              if(pickedRange.start.toString().isNotEmpty && pickedRange.end.toString().isNotEmpty)
                              {
                                this.startDate = pickedRange.start;
                                this.endDate = pickedRange.end;

                                DateFormat format = DateFormat("dd-MM-yyyy");
                                this.date.text = "${format.format(pickedRange.start)} to ${format.format(pickedRange.end)}";

                                this.dateVerification = true;
                                this.dateMssg = "";
                                this.dateMssgColor = Colors.green;

                              }
                              else
                              {
                                this.dateVerification = false;
                                this.dateMssg = "Try again";
                                this.dateMssgColor = Colors.red;
                              }
                            }
                            else
                            {
                              this.dateVerification = false;
                              this.dateMssg = "Selected range exceeds 30 days";
                              this.dateMssgColor = Colors.red;
                            }

                          }
                          else
                          {
                            this.dateVerification = false;
                            this.dateMssg = "Select the date";
                            this.dateMssgColor = Colors.red;
                          }
                          setState(() {

                          });
                        },
                        icon: Icon(
                          Icons.calendar_month,
                          color: Colors.black,
                        )
                    ),
                    "Date"
                ),
                SizedBox(height: 5,),
                Padding(
                  padding: const EdgeInsets.only(left: 35.0,right: 35.0),
                  child: Text(
                    dateMssg,
                    style: TextStyle(
                      color: dateMssgColor,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.height * 0.018,
                    ),
                  ),
                ),
                SizedBox(height: 30,),

                //Download Button
                buttonWidget.ButtonField(
                    context,
                    "Download",
                    () async
                    {
                      if(this.dateVerification && this.startDate.toString().isNotEmpty
                      && this.endDate.toString().isNotEmpty && this.ownerId.isNotEmpty
                      && this.shopId.isNotEmpty)
                      {
                        bool permission = await this.downloadFile.requestPermissions();

                        if(permission)
                        {
                          try
                          {
                            QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("invoice")
                                .where("ownerid", isEqualTo: this.ownerId)
                                .where("shopid", isEqualTo: this.shopId)
                                .get();

                            if(snapshot.docs.isNotEmpty)
                            {
                              var excel = Excel.createExcel();
                              Sheet sheet = excel['Invoices'];

                              sheet.appendRow([
                                TextCellValue("Invoice ID"),
                                TextCellValue("Customer ID"),
                                TextCellValue("Customer Email"),
                                TextCellValue("Date"),
                                TextCellValue("Time"),
                                TextCellValue("Product Details"),
                                TextCellValue("Payment Type"),
                                TextCellValue("Extra Charges"),
                                TextCellValue("Extra Discount"),
                                TextCellValue("Total Amount"),
                              ]);

                              for (var doc in snapshot.docs)
                              {
                                Map<String, dynamic> bill = doc.data() as Map<String, dynamic>;

                                String date = bill["date"] ?? "";
                                DateFormat format = DateFormat("dd-MM-yyyy");
                                DateTime? billDate;

                                try
                                {
                                  billDate = format.parse(date);
                                }
                                catch (e)
                                {
                                  print("Invalid date format: $date");
                                  continue;
                                }

                                if(billDate.isAfter(this.startDate) && billDate.isBefore(this.endDate) ||
                                    billDate.isAtSameMomentAs(this.startDate) ||
                                    billDate.isAtSameMomentAs(this.endDate))
                                {
                                  String invoiceId = bill["invoiceid"] ?? "";
                                  String customerId = bill["customerid"] ?? "";
                                  String customerEmail = bill["customeremail"] ?? "";
                                  String date1 = bill["date"] ?? "";
                                  String time = bill["time"] ?? "";
                                  String paymentType = bill["paymenttype"] ?? "";
                                  String extraCharges = bill["extracharges"] ?? "";
                                  String extraDiscount = bill["extradiscount"] ?? "";
                                  String totalAmount = bill["totalamount"] ?? "";

                                  Map<String, Map<String, dynamic>> productDetail =
                                  Map<String, Map<String, dynamic>>.from(bill["productDetail"]);

                                  Map<String, Map<String, dynamic>> filteredProductDetail = {};

                                  productDetail.forEach((barcode, attributes) {
                                    filteredProductDetail[barcode] = {
                                      if (attributes.containsKey("productname")) "Product Name": attributes["productname"],
                                      if (attributes.containsKey("buyingprice")) "Buying Price": attributes["buyingprice"],
                                      if (attributes.containsKey("sellingprice")) "Selling Price": attributes["sellingprice"],
                                      if (attributes.containsKey("gst")) "GST": attributes["gst"],
                                      if (attributes.containsKey("discount")) "Discount": attributes["discount"],
                                      if (attributes.containsKey("finalprice")) "Final Price": attributes["finalprice"],
                                      if (attributes.containsKey("itemquantity")) "Item Count": attributes["itemquantity"],
                                    };
                                  });

                                  String productDetailsString = jsonEncode(filteredProductDetail);

                                  sheet.appendRow([
                                    TextCellValue(invoiceId),
                                    TextCellValue(customerId),
                                    TextCellValue(customerEmail),
                                    TextCellValue(date1),
                                    TextCellValue(time),
                                    TextCellValue(productDetailsString),
                                    TextCellValue(paymentType),
                                    TextCellValue(extraCharges),
                                    TextCellValue(extraDiscount),
                                    TextCellValue(totalAmount),
                                  ]);
                                }
                              }

                              Directory? directory = await this.downloadFile.getAppDirectorySalesReport();
                              DateFormat format = DateFormat("dd-MM-yyyy");

                              if(directory != null)
                              {
                                String filePath = "${directory.path}/Sales_Report_${format.format(this.startDate)}_${format.format(this.endDate)}.xlsx";
                                File(filePath)
                                  ..createSync(recursive: true)
                                  ..writeAsBytesSync(excel.save()!);

                                await Future.delayed(Duration(milliseconds: 300));
                                toastWidget.showToast("Saved!");
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
                              toastWidget.showToast("Try again");
                            }
                          }
                          catch(e)
                          {
                            await Future.delayed(Duration(milliseconds: 300));
                            toastWidget.showToast("Try again");
                          }
                        }
                        else
                        {
                          await Future.delayed(Duration(milliseconds: 300));
                          toastWidget.showToast("Allow access from the app settings");
                        }

                      }
                      else
                      {
                        await Future.delayed(Duration(milliseconds: 300));
                        toastWidget.showToast("Try again");
                      }
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