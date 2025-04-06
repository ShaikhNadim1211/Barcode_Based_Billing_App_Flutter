import 'dart:io';

import 'package:barcode_based_billing_system/methods/barcode_label_print.dart';
import 'package:barcode_based_billing_system/methods/download_file.dart';
import 'package:barcode_based_billing_system/screens/shop_worker/product_manage/shop_worker_manage_product_screen.dart';
import 'package:barcode_based_billing_system/widgets/custom_button_widget.dart';
import 'package:barcode_based_billing_system/widgets/custom_toast_widget.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

class ShopWorkerViewProductDetailsScreen extends StatefulWidget
{
  final String productId;
  final String productName;
  final String buyingPrice;
  final String sellingPrice;
  final String barcodenumber;
  final String quantity;
  final String finalPrice;
  final List<String> optionalField;
  final Map<String, String> optionalFieldValue;

  ShopWorkerViewProductDetailsScreen(this.productId, this.productName, this.buyingPrice, this.sellingPrice, this.barcodenumber, this.quantity, this.optionalField, this.optionalFieldValue, this.finalPrice);

  @override
  State<StatefulWidget> createState()
  {
    return ShopWorkerViewProductDetailsScreenState();
  }
}

class ShopWorkerViewProductDetailsScreenState extends State<ShopWorkerViewProductDetailsScreen>
{
  CustomButtonWidget buttonWidget = CustomButtonWidget();
  BarcodeLabelPrint labelPrint = BarcodeLabelPrint();
  CustomToastWidget toastWidget = CustomToastWidget();
  DownloadFile downloadFile = DownloadFile();
  WidgetsToImageController controller = WidgetsToImageController();

  String productId = "";
  String productName = "";
  String buyingPrice = "";
  String sellingPrice = "";
  String barcodeNumber = "";
  String quantity = "";
  String finalPrice = "";
  List<String> optionalField = [];
  Map<String, String> optionalFieldValue = {};

  final List<String> pdfTypes = [
    'A4',
    'Roll On',
    'Roll On Small',
  ];
  String? selectedPdfType;

  final List<String> imageTypes = [
    'PNG',
    'JPG',
    'BMP',
  ];
  String? selectedImageType;

  @override
  void initState()
  {
    super.initState();
    this.productId = widget.productId;
    this.productName = widget.productName;
    this.buyingPrice = widget.buyingPrice;
    this.sellingPrice = widget.sellingPrice;
    this.barcodeNumber = widget.barcodenumber;
    this.quantity = widget.quantity;
    this.finalPrice = widget.finalPrice;
    this.optionalField = widget.optionalField;
    this.optionalFieldValue = widget.optionalFieldValue;
  }
  @override
  Widget build(BuildContext context)
  {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Product Details",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
              onPressed: (){
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context)=>ShopWorkerManageProductScreen()
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
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                SizedBox(height: 30),

                Text(
                  "Product Name: ${this.productName}",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.height * 0.03,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Buying Price: ${this.buyingPrice}",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Selling Price: ${this.sellingPrice}",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Stock Quantity: ${this.quantity}",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 5),
                if (this.optionalField.isNotEmpty)
                  ...this.optionalFieldValue.entries.map((entry){
                    return Column(
                      children: [
                        Text(
                          '${entry.key}: ${entry.value}',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 5),
                      ],
                    );
                  }),
                SizedBox(height: 5),
                Text(
                  "Final Amount: ${this.finalPrice}",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),

                SizedBox(height: 30),
                Center(
                  child: Column(
                    children: [

                      Text(
                        'Barcode',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.height * 0.03,
                        ),
                      ),
                      SizedBox(height: 5),
                      WidgetsToImage(
                        controller: this.controller,
                        child: downloadFile.barcodeLabel(this.barcodeNumber, finalPrice, this.optionalFieldValue["Manufacturing Date"] ?? "", this.optionalFieldValue["Expiring Date"] ?? "", this.optionalFieldValue["Colour"] ?? "", this.optionalFieldValue["Size"] ?? ""),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),


                Center(
                  child: Container(
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
                ),
                SizedBox(height: 15),

                Center(
                  child: this.buttonWidget.ButtonField(
                      context,
                      "Print",
                          () async
                      {
                        String finalPrice = this.finalPrice;
                        String manufacturingDate = "";
                        String expiringDate = "";
                        String color = "";
                        String size = "";

                        if(this.optionalField.contains("Manufacturing Date"))
                        {
                          manufacturingDate = this.optionalFieldValue["Manufacturing Date"].toString();
                        }
                        else
                        {
                          manufacturingDate = "";
                        }

                        if(this.optionalField.contains("Expiring Date"))
                        {
                          expiringDate = this.optionalFieldValue["Expiring Date"].toString();
                        }
                        else
                        {
                          expiringDate = "";
                        }

                        if(this.optionalField.contains("Size"))
                        {
                          size = this.optionalFieldValue["Size"].toString();
                        }
                        else
                        {
                          size = "";
                        }

                        if(this.optionalField.contains("Colour"))
                        {
                          color = this.optionalFieldValue["Colour"].toString();
                        }
                        else
                        {
                          color = "";
                        }

                        if(this.selectedPdfType!=null && this.selectedPdfType!.isNotEmpty)
                        {
                          if(this.selectedPdfType=="A4")
                          {
                            this.labelPrint.printBarcodeLabelA4(this.barcodeNumber, "${this.productName}_${this.barcodeNumber}",
                                finalPrice, manufacturingDate, expiringDate, color, size);
                          }
                          if(this.selectedPdfType=="Roll On")
                          {
                            this.labelPrint.printBarcodeLabelRollOn80(this.barcodeNumber, "${this.productName}_${this.barcodeNumber}",
                                finalPrice, manufacturingDate, expiringDate, color, size);
                          }
                          if(this.selectedPdfType=="Roll On Small")
                          {
                            this.labelPrint.printBarcodeLabelRollOn57(this.barcodeNumber, "${this.productName}_${this.barcodeNumber}",
                                finalPrice, manufacturingDate, expiringDate, color, size);
                          }
                        }
                        else
                        {
                          await Future.delayed(Duration(milliseconds: 300));
                          toastWidget.showToast("Select the Print Type");
                        }
                      }
                  ),
                ),
                SizedBox(height: 30,),

                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black54, width: 2),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedImageType,
                        hint: Text(
                          "Select Image Download Type",
                          style: TextStyle(color: Colors.black),
                        ),
                        items: imageTypes.map((String type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        dropdownColor: Theme.of(context).cardColor,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedImageType = newValue;
                          });
                        },
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),

                Center(
                  child: this.buttonWidget.ButtonField(
                      context,
                      "Download",
                          () async
                      {
                        try
                        {
                          if(this.selectedImageType!=null && this.selectedImageType!.isNotEmpty)
                          {
                            bool permission = await this.downloadFile.requestPermissions();

                            if(permission)
                            {
                              Directory? directory = await this.downloadFile.getAppDirectoryBarcodeLabel();

                              if(directory != null)
                              {
                                if(this.selectedImageType=="PNG")
                                {
                                  await this.downloadFile.saveBarcodeToAppDirectoryBarcodeLabel(this.controller, "${this.productName}_${this.barcodeNumber}", "PNG");
                                }
                                if(this.selectedImageType=="JPG")
                                {
                                  await this.downloadFile.saveBarcodeToAppDirectoryBarcodeLabel(this.controller, "${this.productName}_${this.barcodeNumber}", "JPG");
                                }
                                if(this.selectedImageType=="BMP")
                                {
                                  await this.downloadFile.saveBarcodeToAppDirectoryBarcodeLabel(this.controller, "${this.productName}_${this.barcodeNumber}", "BMP");
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
                              toastWidget.showToast("Allow access from the app settings");
                            }

                          }
                          else
                          {
                            await Future.delayed(Duration(milliseconds: 300));
                            toastWidget.showToast("Select the Download Type");
                          }
                        }
                        catch(e)
                        {
                          print(e.toString());
                          await Future.delayed(Duration(milliseconds: 300));
                          toastWidget.showToast("Try again");
                        }
                      }
                  ),
                ),
                SizedBox(height: 30,),

              ],
            ),
          ),
        ),
      ),
    );
  }
}