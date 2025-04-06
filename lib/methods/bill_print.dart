import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';


class BillPrint
{
  Future<Uint8List> loadAssetImage(String assetPath) async
  {
    final byteData = await rootBundle.load(assetPath);
    return byteData.buffer.asUint8List();
  }

  List<List<dynamic>> getProductTableData(Map<String, Map<String, dynamic>> productDetails)
  {
    return productDetails.values.map((product)
    {
      double total = double.parse(product["finalprice"].toString()) * double.parse(product["scannedCount"].toString());
      return [
        product['productid'],
        product['productname'],
        product['sellingprice'].toString(),
        product["gst"] ?? "",
        product["discount"] ?? "",
        product['scannedCount'].toString(),
        total.toStringAsFixed(2),
      ];
    }).toList();
  }
  List<List<dynamic>> getProductTableDataBill(Map<String, Map<String, dynamic>> productDetails)
  {
    return productDetails.values.map((product)
    {
      double total = double.parse(product["finalprice"].toString()) * double.parse(product["itemquantity"].toString());
      return [
        product['productid'],
        product['productname'],
        product['sellingprice'].toString(),
        product["gst"] ?? "",
        product["discount"] ?? "",
        product['itemquantity'].toString(),
        total.toStringAsFixed(2),
      ];
    }).toList();
  }

  Future<void> printBillA4(String invoiceId, String date, String time, Map<String, dynamic> shopDetails, Map<String, dynamic> customerDetails, Map<String, Map<String, dynamic>> productDetails
      ,String extraCharges, String extraDiscount, String paymentType, String totalAmount) async
  {

    final imageBytes = await loadAssetImage("assets/image/launch_icon.png");
    final pdf = pw.Document();
    final productTableData = getProductTableData(productDetails);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {

          return pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [

              //Logo and Invoice Date Time
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [

                  pw.Align(
                    alignment: pw.Alignment.topLeft,
                    child: pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Image(
                          pw.MemoryImage(imageBytes),
                          width: 70,
                          height: 70,
                        ),
                      ],
                    ),
                  ),

                  pw.Align(
                    alignment: pw.Alignment.topRight,
                    child: pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.TableHelper.fromTextArray(
                          data: [
                            ['Invoice ID', invoiceId],
                            ['Date', date],
                            ['Time', time],
                          ],
                          border: pw.TableBorder.all(
                              width: 1,
                              color: PdfColors.black
                          ),
                          cellAlignment: pw.Alignment.center,
                          headerStyle: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ]
              ),
              pw.SizedBox(height: 15),

              //Shop and Customer Details
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [

                  //Shop
                  pw.Container(
                    width: 200,
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromHex("C8EFD1"),
                      borderRadius: pw.BorderRadius.circular(10.0),
                    ),
                    child: pw.Padding(
                      padding: pw.EdgeInsets.all(8.0),
                      child: pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [

                            pw.Text(
                              shopDetails["shopname"],
                              style: pw.TextStyle(
                                color: PdfColors.black,
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),

                            pw.Text(
                              shopDetails["address"],
                              style: pw.TextStyle(
                                color: PdfColors.black,
                                fontSize: 16,
                              ),
                            ),

                            pw.Text(
                              "Phone Number: ${shopDetails["phonenumber"]}",
                              style: pw.TextStyle(
                                color: PdfColors.black,
                                fontSize: 16,
                              ),
                            ),

                            pw.Text(
                              "Email: ${shopDetails["email"]}",
                              style: pw.TextStyle(
                                color: PdfColors.black,
                                fontSize: 16,
                              ),
                            ),

                            if(shopDetails["alternatenumber"].toString().isNotEmpty)
                            pw.Text(
                              "Alternate Number: ${shopDetails["alternatenumber"]}",
                              style: pw.TextStyle(
                                color: PdfColors.black,
                                fontSize: 16,
                              ),
                            ),

                            if(shopDetails["telephonenumber"].toString().isNotEmpty)
                            pw.Text(
                              "Telephone Number: ${shopDetails["telephonenumber"]}",
                              style: pw.TextStyle(
                                color: PdfColors.black,
                                fontSize: 16,
                              ),
                            ),

                            if(shopDetails["gstin"].toString().isNotEmpty)
                            pw.Text(
                              "Telephone Number: ${shopDetails["telephonenumber"]}",
                              style: pw.TextStyle(
                                color: PdfColors.black,
                                fontSize: 16,
                              ),
                            ),
                          ]
                      ),
                    ),
                  ),

                  //Customer
                  pw.Container(
                    width: 200,
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromHex("C8EFD1"),
                      borderRadius: pw.BorderRadius.circular(10.0),
                    ),
                    child: pw.Padding(
                      padding: pw.EdgeInsets.all(8.0),
                      child: pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [

                            pw.Text(
                              customerDetails["customername"],
                              style: pw.TextStyle(
                                color: PdfColors.black,
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),

                            pw.Text(
                              customerDetails["customerid"],
                              style: pw.TextStyle(
                                color: PdfColors.black,
                                fontSize: 16,
                              ),
                            ),

                            pw.Text(
                              customerDetails["address"],
                              style: pw.TextStyle(
                                color: PdfColors.black,
                                fontSize: 16,
                              ),
                            ),

                            if(customerDetails["phonenumber"].toString().isNotEmpty)
                            pw.Text(
                              "Phone Number: ${customerDetails["phonenumber"]}",
                              style: pw.TextStyle(
                                color: PdfColors.black,
                                fontSize: 16,
                              ),
                            ),

                            pw.Text(
                              "Email: ${customerDetails["email"]}",
                              style: pw.TextStyle(
                                color: PdfColors.black,
                                fontSize: 16,
                              ),
                            ),
                          ]
                      ),
                    ),
                  ),
                ]
              ),
              pw.SizedBox(height: 15),

              //Product Details
              pw.TableHelper.fromTextArray(
                headers: ['Product ID', 'Product Name', 'Price (Rs)','GST (%)','Discount (%)','Quantity', 'Total (Rs)'],
                data: productTableData,
                border: pw.TableBorder.all(
                    width: 1,
                    color: PdfColors.black
                ),
                cellAlignment: pw.Alignment.center,
                headerStyle: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold
                ),
              ),
              pw.SizedBox(height: 15),

              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Align(
                      alignment: pw.Alignment.topLeft,
                      child: pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.TableHelper.fromTextArray(
                            data: [
                              ['Payment Type', paymentType],
                              ['Extra Charges', extraCharges],
                              ['Extra Discount', extraDiscount],
                              ['Total Amount', totalAmount],
                            ],
                            border: pw.TableBorder.all(
                                width: 1,
                                color: PdfColors.black
                            ),
                            cellAlignment: pw.Alignment.center,
                            headerCount: 0,
                          ),
                        ],
                      ),
                    ),
                  ]
              ),
              pw.SizedBox(height: 15),

              //Description
              if(shopDetails["description"].toString().isNotEmpty)
              pw.Text(
                shopDetails["description"].toString(),
                style: pw.TextStyle(
                  color: PdfColors.black,
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 13,
                )
              ),
            ]
          );
        }
      ),
    );


    //Print
    await Printing.layoutPdf(
      name: "${invoiceId}_${customerDetails["customername"]}",
      usePrinterSettings: true,
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
  Future<void> printBillA4Bill(String invoiceId, String date, String time, Map<String, dynamic> shopDetails, Map<String, dynamic> customerDetails, Map<String, Map<String, dynamic>> productDetails
      ,String extraCharges, String extraDiscount, String paymentType, String totalAmount) async
  {

    final imageBytes = await loadAssetImage("assets/image/launch_icon.png");
    final pdf = pw.Document();
    final productTableData = getProductTableDataBill(productDetails);

    pdf.addPage(
      pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {

            return pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [

                  //Logo and Invoice Date Time
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [

                        pw.Align(
                          alignment: pw.Alignment.topLeft,
                          child: pw.Column(
                            mainAxisAlignment: pw.MainAxisAlignment.start,
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Image(
                                pw.MemoryImage(imageBytes),
                                width: 70,
                                height: 70,
                              ),
                            ],
                          ),
                        ),

                        pw.Align(
                          alignment: pw.Alignment.topRight,
                          child: pw.Column(
                            mainAxisAlignment: pw.MainAxisAlignment.start,
                            crossAxisAlignment: pw.CrossAxisAlignment.end,
                            children: [
                              pw.TableHelper.fromTextArray(
                                data: [
                                  ['Invoice ID', invoiceId],
                                  ['Date', date],
                                  ['Time', time],
                                ],
                                border: pw.TableBorder.all(
                                    width: 1,
                                    color: PdfColors.black
                                ),
                                cellAlignment: pw.Alignment.center,
                                headerStyle: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]
                  ),
                  pw.SizedBox(height: 15),

                  //Shop and Customer Details
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [

                        //Shop
                        pw.Container(
                          width: 200,
                          decoration: pw.BoxDecoration(
                            color: PdfColor.fromHex("C8EFD1"),
                            borderRadius: pw.BorderRadius.circular(10.0),
                          ),
                          child: pw.Padding(
                            padding: pw.EdgeInsets.all(8.0),
                            child: pw.Column(
                                mainAxisAlignment: pw.MainAxisAlignment.start,
                                crossAxisAlignment: pw.CrossAxisAlignment.center,
                                children: [

                                  pw.Text(
                                    shopDetails["shopname"],
                                    style: pw.TextStyle(
                                      color: PdfColors.black,
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),

                                  pw.Text(
                                    shopDetails["address"],
                                    style: pw.TextStyle(
                                      color: PdfColors.black,
                                      fontSize: 16,
                                    ),
                                  ),

                                  pw.Text(
                                    "Phone Number: ${shopDetails["phonenumber"]}",
                                    style: pw.TextStyle(
                                      color: PdfColors.black,
                                      fontSize: 16,
                                    ),
                                  ),

                                  pw.Text(
                                    "Email: ${shopDetails["email"]}",
                                    style: pw.TextStyle(
                                      color: PdfColors.black,
                                      fontSize: 16,
                                    ),
                                  ),

                                  if(shopDetails["alternatenumber"].toString().isNotEmpty)
                                    pw.Text(
                                      "Alternate Number: ${shopDetails["alternatenumber"]}",
                                      style: pw.TextStyle(
                                        color: PdfColors.black,
                                        fontSize: 16,
                                      ),
                                    ),

                                  if(shopDetails["telephonenumber"].toString().isNotEmpty)
                                    pw.Text(
                                      "Telephone Number: ${shopDetails["telephonenumber"]}",
                                      style: pw.TextStyle(
                                        color: PdfColors.black,
                                        fontSize: 16,
                                      ),
                                    ),

                                  if(shopDetails["gstin"].toString().isNotEmpty)
                                    pw.Text(
                                      "Telephone Number: ${shopDetails["telephonenumber"]}",
                                      style: pw.TextStyle(
                                        color: PdfColors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                ]
                            ),
                          ),
                        ),

                        //Customer
                        pw.Container(
                          width: 200,
                          decoration: pw.BoxDecoration(
                            color: PdfColor.fromHex("C8EFD1"),
                            borderRadius: pw.BorderRadius.circular(10.0),
                          ),
                          child: pw.Padding(
                            padding: pw.EdgeInsets.all(8.0),
                            child: pw.Column(
                                mainAxisAlignment: pw.MainAxisAlignment.start,
                                crossAxisAlignment: pw.CrossAxisAlignment.center,
                                children: [

                                  pw.Text(
                                    customerDetails["customername"],
                                    style: pw.TextStyle(
                                      color: PdfColors.black,
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),

                                  pw.Text(
                                    customerDetails["customerid"],
                                    style: pw.TextStyle(
                                      color: PdfColors.black,
                                      fontSize: 16,
                                    ),
                                  ),

                                  pw.Text(
                                    customerDetails["address"],
                                    style: pw.TextStyle(
                                      color: PdfColors.black,
                                      fontSize: 16,
                                    ),
                                  ),

                                  if(customerDetails["phonenumber"].toString().isNotEmpty)
                                    pw.Text(
                                      "Phone Number: ${customerDetails["phonenumber"]}",
                                      style: pw.TextStyle(
                                        color: PdfColors.black,
                                        fontSize: 16,
                                      ),
                                    ),

                                  pw.Text(
                                    "Email: ${customerDetails["email"]}",
                                    style: pw.TextStyle(
                                      color: PdfColors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ]
                            ),
                          ),
                        ),
                      ]
                  ),
                  pw.SizedBox(height: 15),

                  //Product Details
                  pw.TableHelper.fromTextArray(
                    headers: ['Product ID', 'Product Name', 'Price (Rs)','GST (%)','Discount (%)','Quantity', 'Total (Rs)'],
                    data: productTableData,
                    border: pw.TableBorder.all(
                        width: 1,
                        color: PdfColors.black
                    ),
                    cellAlignment: pw.Alignment.center,
                    headerStyle: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold
                    ),
                  ),
                  pw.SizedBox(height: 15),

                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Align(
                          alignment: pw.Alignment.topLeft,
                          child: pw.Column(
                            mainAxisAlignment: pw.MainAxisAlignment.start,
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.TableHelper.fromTextArray(
                                data: [
                                  ['Payment Type', paymentType],
                                  ['Extra Charges', extraCharges],
                                  ['Extra Discount', extraDiscount],
                                  ['Total Amount', totalAmount],
                                ],
                                border: pw.TableBorder.all(
                                    width: 1,
                                    color: PdfColors.black
                                ),
                                cellAlignment: pw.Alignment.center,
                                headerCount: 0,
                              ),
                            ],
                          ),
                        ),
                      ]
                  ),
                  pw.SizedBox(height: 15),

                  //Description
                  if(shopDetails["description"].toString().isNotEmpty)
                    pw.Text(
                        shopDetails["description"].toString(),
                        style: pw.TextStyle(
                          color: PdfColors.black,
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 13,
                        )
                    ),
                ]
            );
          }
      ),
    );


    //Print
    await Printing.layoutPdf(
      name: "${invoiceId}_${customerDetails["customername"]}",
      usePrinterSettings: true,
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  Future<void> printBillRollOn(String invoiceId, String date, String time, Map<String, dynamic> shopDetails, Map<String, dynamic> customerDetails, Map<String, Map<String, dynamic>> productDetails
      ,String extraCharges, String extraDiscount, String paymentType, String totalAmount, PdfPageFormat pdfPageFormat) async
  {

    final imageBytes = await loadAssetImage("assets/image/launch_icon.png");
    final pdf = pw.Document();
    final productTableData = getProductTableData(productDetails);

    pdf.addPage(
      pw.Page(
          pageFormat: pdfPageFormat,
          build: (pw.Context context) {

            return pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [

                  //Logo
                  pw.Image(
                    pw.MemoryImage(imageBytes),
                    width: 70,
                    height: 70,
                  ),
                  pw.SizedBox(height: 15),

                  //Invoice Date Time
                  pw.TableHelper.fromTextArray(
                    data: [
                      ['Invoice ID', invoiceId],
                      ['Date', date],
                      ['Time', time],
                    ],
                    border: pw.TableBorder.all(
                        width: 1,
                        color: PdfColors.black
                    ),
                    cellAlignment: pw.Alignment.center,
                    headerStyle: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 15),

                  //Shop
                  pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [

                        pw.Text(
                          shopDetails["shopname"],
                          style: pw.TextStyle(
                            color: PdfColors.black,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),

                        pw.Text(
                          shopDetails["address"],
                          style: pw.TextStyle(
                            color: PdfColors.black,
                          ),
                        ),

                        pw.Text(
                          "Phone Number: ${shopDetails["phonenumber"]}",
                          style: pw.TextStyle(
                            color: PdfColors.black,
                          ),
                        ),

                        pw.Text(
                          "Email: ${shopDetails["email"]}",
                          style: pw.TextStyle(
                            color: PdfColors.black,
                          ),
                        ),

                        if(shopDetails["alternatenumber"].toString().isNotEmpty)
                          pw.Text(
                            "Alternate Number: ${shopDetails["alternatenumber"]}",
                            style: pw.TextStyle(
                              color: PdfColors.black,
                            ),
                          ),

                        if(shopDetails["telephonenumber"].toString().isNotEmpty)
                          pw.Text(
                            "Telephone Number: ${shopDetails["telephonenumber"]}",
                            style: pw.TextStyle(
                              color: PdfColors.black,
                            ),
                          ),

                        if(shopDetails["gstin"].toString().isNotEmpty)
                          pw.Text(
                            "Telephone Number: ${shopDetails["telephonenumber"]}",
                            style: pw.TextStyle(
                              color: PdfColors.black,
                            ),
                          ),
                      ]
                  ),
                  pw.SizedBox(height: 15),

                  //Customer
                  pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [

                        pw.Text(
                          customerDetails["customername"],
                          style: pw.TextStyle(
                            color: PdfColors.black,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),

                        pw.Text(
                          customerDetails["customerid"],
                          style: pw.TextStyle(
                            color: PdfColors.black,
                          ),
                        ),

                        pw.Text(
                          customerDetails["address"],
                          style: pw.TextStyle(
                            color: PdfColors.black,
                          ),
                        ),

                        if(customerDetails["phonenumber"].toString().isNotEmpty)
                          pw.Text(
                            "Phone Number: ${customerDetails["phonenumber"]}",
                            style: pw.TextStyle(
                              color: PdfColors.black,
                            ),
                          ),

                        pw.Text(
                          "Email: ${customerDetails["email"]}",
                          style: pw.TextStyle(
                            color: PdfColors.black,
                          ),
                        ),
                      ]
                  ),
                  pw.SizedBox(height: 15),

                  //Product Details
                  pw.Table(
                    border: pw.TableBorder.all(width: 1, color: PdfColors.black),
                    children: [
                      pw.TableRow(
                        children: [
                          pw.Expanded(child: pw.Text('Product ID', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                          pw.Expanded(child: pw.Text('Product Name', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                          pw.Expanded(child: pw.Text('Price (Rs)', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                          pw.Expanded(child: pw.Text('GST (%)', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                          pw.Expanded(child: pw.Text('Discount (%)', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                          pw.Expanded(child: pw.Text('Quantity', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                          pw.Expanded(child: pw.Text('Total (Rs)', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                        ],
                      ),
                      ...productTableData.map(
                            (dataRow) => pw.TableRow(
                          children: dataRow.map((cell) => pw.Expanded(child: pw.Text(cell))).toList(),
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 15),

                  pw.TableHelper.fromTextArray(
                    data: [
                      ['Payment Type', paymentType],
                      ['Extra Charges', extraCharges],
                      ['Extra Discount', extraDiscount],
                      ['Total Amount', totalAmount],
                    ],
                    border: pw.TableBorder.all(
                        width: 1,
                        color: PdfColors.black
                    ),
                    cellAlignment: pw.Alignment.center,
                    headerCount: 0,
                  ),
                  pw.SizedBox(height: 15),

                  //Description
                  if(shopDetails["description"].toString().isNotEmpty)
                    pw.Text(
                        shopDetails["description"].toString(),
                        style: pw.TextStyle(
                          color: PdfColors.black,
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 13,
                        )
                    ),
                ]
            );
          }
      ),
    );


    //Print
    await Printing.layoutPdf(
      name: "${invoiceId}_${customerDetails["customername"]}",
      usePrinterSettings: true,
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  Future<void> printBillRollOnBill(String invoiceId, String date, String time, Map<String, dynamic> shopDetails, Map<String, dynamic> customerDetails, Map<String, Map<String, dynamic>> productDetails
      ,String extraCharges, String extraDiscount, String paymentType, String totalAmount, PdfPageFormat pdfPageFormat) async
  {

    final imageBytes = await loadAssetImage("assets/image/launch_icon.png");
    final pdf = pw.Document();
    final productTableData = getProductTableDataBill(productDetails);

    pdf.addPage(
      pw.Page(
          pageFormat: pdfPageFormat,
          build: (pw.Context context) {

            return pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [

                  //Logo
                  pw.Image(
                    pw.MemoryImage(imageBytes),
                    width: 70,
                    height: 70,
                  ),
                  pw.SizedBox(height: 15),

                  //Invoice Date Time
                  pw.TableHelper.fromTextArray(
                    data: [
                      ['Invoice ID', invoiceId],
                      ['Date', date],
                      ['Time', time],
                    ],
                    border: pw.TableBorder.all(
                        width: 1,
                        color: PdfColors.black
                    ),
                    cellAlignment: pw.Alignment.center,
                    headerStyle: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 15),

                  //Shop
                  pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [

                        pw.Text(
                          shopDetails["shopname"],
                          style: pw.TextStyle(
                            color: PdfColors.black,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),

                        pw.Text(
                          shopDetails["address"],
                          style: pw.TextStyle(
                            color: PdfColors.black,
                          ),
                        ),

                        pw.Text(
                          "Phone Number: ${shopDetails["phonenumber"]}",
                          style: pw.TextStyle(
                            color: PdfColors.black,
                          ),
                        ),

                        pw.Text(
                          "Email: ${shopDetails["email"]}",
                          style: pw.TextStyle(
                            color: PdfColors.black,
                          ),
                        ),

                        if(shopDetails["alternatenumber"].toString().isNotEmpty)
                          pw.Text(
                            "Alternate Number: ${shopDetails["alternatenumber"]}",
                            style: pw.TextStyle(
                              color: PdfColors.black,
                            ),
                          ),

                        if(shopDetails["telephonenumber"].toString().isNotEmpty)
                          pw.Text(
                            "Telephone Number: ${shopDetails["telephonenumber"]}",
                            style: pw.TextStyle(
                              color: PdfColors.black,
                            ),
                          ),

                        if(shopDetails["gstin"].toString().isNotEmpty)
                          pw.Text(
                            "Telephone Number: ${shopDetails["telephonenumber"]}",
                            style: pw.TextStyle(
                              color: PdfColors.black,
                            ),
                          ),
                      ]
                  ),
                  pw.SizedBox(height: 15),

                  //Customer
                  pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [

                        pw.Text(
                          customerDetails["customername"],
                          style: pw.TextStyle(
                            color: PdfColors.black,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),

                        pw.Text(
                          customerDetails["customerid"],
                          style: pw.TextStyle(
                            color: PdfColors.black,
                          ),
                        ),

                        pw.Text(
                          customerDetails["address"],
                          style: pw.TextStyle(
                            color: PdfColors.black,
                          ),
                        ),

                        if(customerDetails["phonenumber"].toString().isNotEmpty)
                          pw.Text(
                            "Phone Number: ${customerDetails["phonenumber"]}",
                            style: pw.TextStyle(
                              color: PdfColors.black,
                            ),
                          ),

                        pw.Text(
                          "Email: ${customerDetails["email"]}",
                          style: pw.TextStyle(
                            color: PdfColors.black,
                          ),
                        ),
                      ]
                  ),
                  pw.SizedBox(height: 15),

                  //Product Details
                  pw.Table(
                    border: pw.TableBorder.all(width: 1, color: PdfColors.black),
                    children: [
                      pw.TableRow(
                        children: [
                          pw.Expanded(child: pw.Text('Product ID', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                          pw.Expanded(child: pw.Text('Product Name', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                          pw.Expanded(child: pw.Text('Price (Rs)', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                          pw.Expanded(child: pw.Text('GST (%)', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                          pw.Expanded(child: pw.Text('Discount (%)', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                          pw.Expanded(child: pw.Text('Quantity', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                          pw.Expanded(child: pw.Text('Total (Rs)', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                        ],
                      ),
                      ...productTableData.map(
                            (dataRow) => pw.TableRow(
                          children: dataRow.map((cell) => pw.Expanded(child: pw.Text(cell))).toList(),
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 15),

                  pw.TableHelper.fromTextArray(
                    data: [
                      ['Payment Type', paymentType],
                      ['Extra Charges', extraCharges],
                      ['Extra Discount', extraDiscount],
                      ['Total Amount', totalAmount],
                    ],
                    border: pw.TableBorder.all(
                        width: 1,
                        color: PdfColors.black
                    ),
                    cellAlignment: pw.Alignment.center,
                    headerCount: 0,
                  ),
                  pw.SizedBox(height: 15),

                  //Description
                  if(shopDetails["description"].toString().isNotEmpty)
                    pw.Text(
                        shopDetails["description"].toString(),
                        style: pw.TextStyle(
                          color: PdfColors.black,
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 13,
                        )
                    ),
                ]
            );
          }
      ),
    );


    //Print
    await Printing.layoutPdf(
      name: "${invoiceId}_${customerDetails["customername"]}",
      usePrinterSettings: true,
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

}