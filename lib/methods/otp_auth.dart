import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class OtpAuth
{
  final String _accountSid = 'YOUR_TWILIO_SID';
  final String _authToken = 'YOUR_TWILIO_AUTHTOKEN';
  final String _fromNumber = 'YOUR_TWILIO_NUMBER';

  String generateOTP()
  {
    final random = Random();
    return (random.nextInt(900000) + 100000).toString();
  }

  bool verifyOTP(String sendOTP, String userOTP)
  {
    if(userOTP==sendOTP)
    {
      return true;
    }
    else
    {
      return false;
    }
  }

  Future<bool> sendEmailOTP(String email, String otp) async {

    String emailText='''
    <!DOCTYPE html>
<html>
<head>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #F7F8FA;
        }
        .container {
            max-width: 600px;
            margin: 30px auto;
            padding: 20px;
            background-color: #FFFFFF;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            border: 1px solid #A2E9C1;
        }
        .header {
            text-align: center;
            background-color: #A2E9C1;
            padding: 15px;
            border-radius: 8px 8px 0 0;
        }
        .header h1 {
            margin: 0;
            color: #FFFFFF;
            font-size: 24px;
            letter-spacing: 1px;
        }
        .content {
            padding: 20px;
            color: #333333;
            text-align: center;
        }
        .content h2 {
            color: #666666;
            font-size: 20px;
            margin-bottom: 10px;
        }
        .otp {
            font-size: 28px;
            color: #A2E9C1;
            font-weight: bold;
            background-color: #F3F9F6;
            display: inline-block;
            padding: 10px 20px;
            border-radius: 4px;
            margin: 20px 0;
        }
        .footer {
            text-align: center;
            padding: 15px;
            background-color: #F3F9F6;
            color: #666666;
            font-size: 14px;
            border-radius: 0 0 8px 8px;
        }
        .footer a {
            color: #A2E9C1;
            text-decoration: none;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>QWIKBILL</h1>
        </div>
        <div class="content">
            <h2>Your OTP Code</h2>
            <p>Use the code below to verify your email address.</p>
            <div class="otp">$otp</div>
            <p>If you did not request this, please ignore this email.</p>
        </div>
        <div class="footer">
            <p>Need help? <a href="nscreation1211@gmail.com">Contact Support</a></p>
            <p>&copy; 2024 QWIKKBILL. All rights reserved.</p>
        </div>
    </div>
</body>
</html>

    ''';

    final String username = 'YOUR_EMAIL';
    final String password = 'YOUR_APP_PASSWORD';

    final smtpServer = gmail(username, password);

    final String generatedOTP = otp;

    final message = Message()
      ..from = Address(username, 'QWIKBILL')
      ..recipients.add(email)
      ..subject = 'Your OTP for Email Verification'
      ..html = emailText;

    try
    {
      await send(message, smtpServer);
      return true;
    }
    catch (e)
    {
      return false;
    }
  }

  Future<bool> sendWorkerEmailOTP(String email, String otp) async {

    String emailText='''
    <!DOCTYPE html>
<html>
<head>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #F7F8FA;
        }
        .container {
            max-width: 600px;
            margin: 30px auto;
            padding: 20px;
            background-color: #FFFFFF;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            border: 1px solid #A2E9C1;
        }
        .header {
            text-align: center;
            background-color: #A2E9C1;
            padding: 15px;
            border-radius: 8px 8px 0 0;
        }
        .header h1 {
            margin: 0;
            color: #FFFFFF;
            font-size: 24px;
            letter-spacing: 1px;
        }
        .content {
            padding: 20px;
            color: #333333;
            text-align: center;
        }
        .content h2 {
            color: #666666;
            font-size: 20px;
            margin-bottom: 10px;
        }
        .otp {
            font-size: 28px;
            color: #A2E9C1;
            font-weight: bold;
            background-color: #F3F9F6;
            display: inline-block;
            padding: 10px 20px;
            border-radius: 4px;
            margin: 20px 0;
        }
        .footer {
            text-align: center;
            padding: 15px;
            background-color: #F3F9F6;
            color: #666666;
            font-size: 14px;
            border-radius: 0 0 8px 8px;
        }
        .footer a {
            color: #A2E9C1;
            text-decoration: none;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>QWIKBILL</h1>
        </div>
        <div class="content">
            <h2>Your OTP Code</h2>
            <p>Use the code below to verify your account.</p>
            <div class="otp">$otp</div>
            <p>If you did not request this, please ignore this email.</p>
        </div>
        <div class="footer">
            <p>Need help? <a href="nscreation1211@gmail.com">Contact Support</a></p>
            <p>&copy; 2024 QWIKKBILL. All rights reserved.</p>
        </div>
    </div>
</body>
</html>

    ''';

    final String username = 'YOUR_EMAIL';
    final String password = 'YOUR_APP_PASSWORD';

    final smtpServer = gmail(username, password);

    final String generatedOTP = otp;

    final message = Message()
      ..from = Address(username, 'QWIKBILL')
      ..recipients.add(email)
      ..subject = 'Your OTP for Account Verification'
      ..html = emailText;

    try
    {
      await send(message, smtpServer);
      return true;
    }
    catch (e)
    {
      return false;
    }
  }


  Future<bool> sendPhoneOTP(String phonenumber, String otp) async {
    String phoneNumber = "+91"+phonenumber;

    try
    {
      final response = await http.post(
        Uri.parse('https://api.twilio.com/2010-04-01/Accounts/$_accountSid/Messages.json'),
        headers: {
          'Authorization': 'Basic ${base64Encode(utf8.encode('$_accountSid:$_authToken'))}',
        },
        body: {
          'From': _fromNumber,
          'To': phoneNumber,
          'Body': 'QWIKBILL\nYour OTP is: $otp',
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200)
      {
        return true;
      }
      else
      {
        return false;
      }
    }
    catch (e)
    {
      return false;
    }
  }

  Future<bool> sendPhoneMessage(String phonenumber, String message) async {
    String phoneNumber = "+91"+phonenumber;

    try
    {
      final response = await http.post(
        Uri.parse('https://api.twilio.com/2010-04-01/Accounts/$_accountSid/Messages.json'),
        headers: {
          'Authorization': 'Basic ${base64Encode(utf8.encode('$_accountSid:$_authToken'))}',
        },
        body: {
          'From': _fromNumber,
          'To': phoneNumber,
          'Body': 'QWIKBILL\n$message',
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200)
      {
        return true;
      }
      else
      {
        return false;
      }
    }
    catch (e)
    {
      return false;
    }
  }

  Future<bool> sendEmailUsernameMessage(String email, String Username) async {

    String emailText='''
    <!DOCTYPE html>
<html>
<head>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #F7F8FA;
        }
        .container {
            max-width: 600px;
            margin: 30px auto;
            padding: 20px;
            background-color: #FFFFFF;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            border: 1px solid #A2E9C1;
        }
        .header {
            text-align: center;
            background-color: #A2E9C1;
            padding: 15px;
            border-radius: 8px 8px 0 0;
        }
        .header h1 {
            margin: 0;
            color: #FFFFFF;
            font-size: 24px;
            letter-spacing: 1px;
        }
        .content {
            padding: 20px;
            color: #333333;
            text-align: center;
        }
        .content h2 {
            color: #666666;
            font-size: 20px;
            margin-bottom: 10px;
        }
        .username {
            font-size: 20px;
            color: #A2E9C1;
            font-weight: bold;
            background-color: #F3F9F6;
            display: inline-block;
            padding: 10px 20px;
            border-radius: 4px;
            margin: 20px 0;
        }
        .footer {
            text-align: center;
            padding: 15px;
            background-color: #F3F9F6;
            color: #666666;
            font-size: 14px;
            border-radius: 0 0 8px 8px;
        }
        .footer a {
            color: #A2E9C1;
            text-decoration: none;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>QWIKBILL</h1>
        </div>
        <div class="content">
            <h2>Your Username</h2>
            <p>Here is the username associated with your account:</p>
            <div class="username">$Username</div>
            <p>If you did not request this, please ignore this email or contact support.</p>
        </div>
        <div class="footer">
            <p>Need help? <a href="mailto:nscreation1211@gmail.com">Contact Support</a></p>
            <p>&copy; 2024 QWIKBILL. All rights reserved.</p>
        </div>
    </div>
</body>
</html>


    ''';

    final String username = 'YOUR_EMAIL';
    final String password = 'YOUR_APP_PASSWORD';

    final smtpServer = gmail(username, password);


    final message = Message()
      ..from = Address(username, 'QWIKBILL')
      ..recipients.add(email)
      ..subject = 'Your Username'
      ..html = emailText;

    try
    {
      await send(message, smtpServer);
      return true;
    }
    catch (e)
    {
      return false;
    }
  }

  Future<bool> sendCustomerId(String email, String CustomerID) async {

    String emailText='''
    <!DOCTYPE html>
<html>
<head>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #F7F8FA;
        }
        .container {
            max-width: 600px;
            margin: 30px auto;
            padding: 20px;
            background-color: #FFFFFF;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            border: 1px solid #A2E9C1;
        }
        .header {
            text-align: center;
            background-color: #A2E9C1;
            padding: 15px;
            border-radius: 8px 8px 0 0;
        }
        .header h1 {
            margin: 0;
            color: #FFFFFF;
            font-size: 24px;
            letter-spacing: 1px;
        }
        .content {
            padding: 20px;
            color: #333333;
            text-align: center;
        }
        .content h2 {
            color: #666666;
            font-size: 20px;
            margin-bottom: 10px;
        }
        .username {
            font-size: 20px;
            color: #A2E9C1;
            font-weight: bold;
            background-color: #F3F9F6;
            display: inline-block;
            padding: 10px 20px;
            border-radius: 4px;
            margin: 20px 0;
        }
        .footer {
            text-align: center;
            padding: 15px;
            background-color: #F3F9F6;
            color: #666666;
            font-size: 14px;
            border-radius: 0 0 8px 8px;
        }
        .footer a {
            color: #A2E9C1;
            text-decoration: none;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>QWIKBILL</h1>
        </div>
        <div class="content">
            <h2>Your Customer ID</h2>
            <p>Here is the Customer ID save it for futher interaction:</p>
            <div class="username">$CustomerID</div>
            <p>If you did not request this, please ignore this email or contact support.</p>
        </div>
        <div class="footer">
            <p>Need help? <a href="mailto:nscreation1211@gmail.com">Contact Support</a></p>
            <p>&copy; 2024 QWIKBILL. All rights reserved.</p>
        </div>
    </div>
</body>
</html>


    ''';

    final String username = 'YOUR_EMAIL';
    final String password = 'YOUR_APP_PASSWORD';

    final smtpServer = gmail(username, password);


    final message = Message()
      ..from = Address(username, 'QWIKBILL')
      ..recipients.add(email)
      ..subject = 'Your Customer ID'
      ..html = emailText;

    try
    {
      await send(message, smtpServer);
      return true;
    }
    catch (e)
    {
      return false;
    }
  }

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

  Future<bool> sendInvoice(String invoiceId, String date, String time, Map<String, dynamic> shopDetails, Map<String, dynamic> customerDetails, Map<String, Map<String, dynamic>> productDetails
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
                                width: 100,
                                height: 100,
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
    // Get the temporary directory
    final tempDir = await getTemporaryDirectory();
    final filePath = "${tempDir.path}/invoice.pdf";

    // Write the PDF file
    final pdfBytes = await pdf.save();
    final file = File(filePath);
    await file.writeAsBytes(pdfBytes);

    String emailText = '''
    <!DOCTYPE html>
<html>
<head>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #F7F8FA;
        }
        .container {
            max-width: 600px;
            margin: 30px auto;
            padding: 20px;
            background-color: #FFFFFF;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            border: 1px solid #A2E9C1;
        }
        .header {
            text-align: center;
            background-color: #A2E9C1;
            padding: 15px;
            border-radius: 8px 8px 0 0;
        }
        .header h1 {
            margin: 0;
            color: #FFFFFF;
            font-size: 24px;
            letter-spacing: 1px;
        }
        .content {
            padding: 20px;
            color: #333333;
            text-align: center;
        }
        .content h2 {
            color: #666666;
            font-size: 20px;
            margin-bottom: 10px;
        }
        .footer {
            text-align: center;
            padding: 15px;
            background-color: #F3F9F6;
            color: #666666;
            font-size: 14px;
            border-radius: 0 0 8px 8px;
        }
        .footer a {
            color: #A2E9C1;
            text-decoration: none;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>QWIKBILL</h1>
        </div>
        <div class="content">
            <h2>Your Invoice</h2>
            <p>Invoice ID: <strong>$invoiceId</strong></p>
            <p>Please find your invoice attached to this email.</p>
        </div>
        <div class="footer">
            <p>Need help? <a href="mailto:nscreation1211@gmail.com">Contact Support</a></p>
            <p>&copy; 2024 QWIKBILL. All rights reserved.</p>
        </div>
    </div>
</body>
</html>
    ''';

    // SMTP configuration
    final String username = 'YOUR_EMAIL';
    final String password = 'YOUR_APP_PASSWORD';
    final smtpServer = gmail(username, password);

    // Construct the email message
    final message = Message()
      ..from = Address(username, 'QWIKBILL')
      ..recipients.add(customerDetails["email"])
      ..subject = 'Your Invoice - $invoiceId'
      ..html = emailText
      ..attachments = [
        FileAttachment(file)
          ..location = Location.attachment
      ];


    try
    {
      await send(message, smtpServer);
      await file.delete();
      return true;
    }
    catch (e)
    {
      print('Error sending email: $e');
      await file.delete();
      return false;
    }
  }

  Future<bool> sendInvoiceBill(String invoiceId, String date, String time, Map<String, dynamic> shopDetails, Map<String, dynamic> customerDetails, Map<String, Map<String, dynamic>> productDetails
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
                                width: 100,
                                height: 100,
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
    // Get the temporary directory
    final tempDir = await getTemporaryDirectory();
    final filePath = "${tempDir.path}/invoice.pdf";

    // Write the PDF file
    final pdfBytes = await pdf.save();
    final file = File(filePath);
    await file.writeAsBytes(pdfBytes);

    String emailText = '''
    <!DOCTYPE html>
<html>
<head>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #F7F8FA;
        }
        .container {
            max-width: 600px;
            margin: 30px auto;
            padding: 20px;
            background-color: #FFFFFF;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            border: 1px solid #A2E9C1;
        }
        .header {
            text-align: center;
            background-color: #A2E9C1;
            padding: 15px;
            border-radius: 8px 8px 0 0;
        }
        .header h1 {
            margin: 0;
            color: #FFFFFF;
            font-size: 24px;
            letter-spacing: 1px;
        }
        .content {
            padding: 20px;
            color: #333333;
            text-align: center;
        }
        .content h2 {
            color: #666666;
            font-size: 20px;
            margin-bottom: 10px;
        }
        .footer {
            text-align: center;
            padding: 15px;
            background-color: #F3F9F6;
            color: #666666;
            font-size: 14px;
            border-radius: 0 0 8px 8px;
        }
        .footer a {
            color: #A2E9C1;
            text-decoration: none;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>QWIKBILL</h1>
        </div>
        <div class="content">
            <h2>Your Invoice</h2>
            <p>Invoice ID: <strong>$invoiceId</strong></p>
            <p>Please find your invoice attached to this email.</p>
        </div>
        <div class="footer">
            <p>Need help? <a href="mailto:nscreation1211@gmail.com">Contact Support</a></p>
            <p>&copy; 2024 QWIKBILL. All rights reserved.</p>
        </div>
    </div>
</body>
</html>
    ''';

    // SMTP configuration
    final String username = 'YOUR_EMAIL';
    final String password = 'YOUR_APP_PASSWORD';
    final smtpServer = gmail(username, password);

    // Construct the email message
    final message = Message()
      ..from = Address(username, 'QWIKBILL')
      ..recipients.add(customerDetails["email"])
      ..subject = 'Your Invoice - $invoiceId'
      ..html = emailText
      ..attachments = [
        FileAttachment(file)
          ..location = Location.attachment
      ];


    try
    {
      await send(message, smtpServer);
      await file.delete();
      return true;
    }
    catch (e)
    {
      print('Error sending email: $e');
      await file.delete();
      return false;
    }
  }

  Future<bool> sendWorkerPassword(String email, String password) async {
    // Email body with HTML styling
    String emailText = '''
    <!DOCTYPE html>
    <html>
    <head>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 0;
                padding: 0;
                background-color: #F7F8FA;
            }
            .container {
                max-width: 600px;
                margin: 30px auto;
                padding: 20px;
                background-color: #FFFFFF;
                border-radius: 8px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
                border: 1px solid #A2E9C1;
            }
            .header {
                text-align: center;
                background-color: #A2E9C1;
                padding: 15px;
                border-radius: 8px 8px 0 0;
            }
            .header h1 {
                margin: 0;
                color: #FFFFFF;
                font-size: 24px;
                letter-spacing: 1px;
            }
            .content {
                padding: 20px;
                color: #333333;
                text-align: center;
            }
            .content h2 {
                color: #666666;
                font-size: 20px;
                margin-bottom: 10px;
            }
            .password {
                font-size: 20px;
                color: #A2E9C1;
                font-weight: bold;
                background-color: #F3F9F6;
                display: inline-block;
                padding: 10px 20px;
                border-radius: 4px;
                margin: 20px 0;
            }
            .footer {
                text-align: center;
                padding: 15px;
                background-color: #F3F9F6;
                color: #666666;
                font-size: 14px;
                border-radius: 0 0 8px 8px;
            }
            .footer a {
                color: #A2E9C1;
                text-decoration: none;
                font-weight: bold;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h1>QWIKBILL</h1>
            </div>
            <div class="content">
                <h2>Welcome to QWIKBILL</h2>
                <p>Your account has been created successfully. Below is your login password:</p>
                <div class="password">$password</div>
                <p>Please keep this password secure. If you did not request this account, please contact support immediately.</p>
            </div>
            <div class="footer">
                <p>Need help? <a href="mailto:nscreation1211@gmail.com">Contact Support</a></p>
                <p>&copy; 2024 QWIKBILL. All rights reserved.</p>
            </div>
        </div>
    </body>
    </html>
  ''';

    // SMTP server credentials
    final String username = 'YOUR_EMAIL';
    final String appPassword = 'YOUR_APP_PASSWORD'; // App-specific password

    final smtpServer = gmail(username, appPassword);

    // Email message
    final message = Message()
      ..from = Address(username, 'QWIKBILL')
      ..recipients.add(email)
      ..subject = 'Your Account Password'
      ..html = emailText;

    try {
      // Send the email
      await send(message, smtpServer);
      return true;
    } catch (e) {
      print('Error: $e'); // Print error for debugging
      return false;
    }
  }
}