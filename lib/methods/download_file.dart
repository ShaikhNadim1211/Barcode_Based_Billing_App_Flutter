import 'dart:io';
import 'package:barcode_based_billing_system/widgets/custom_toast_widget.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:widgets_to_image/widgets_to_image.dart';
import 'package:image/image.dart' as img;

class DownloadFile
{
  CustomToastWidget toastWidget = CustomToastWidget();

  Future<bool> requestPermissions() async
  {
    bool flag = false;

    if (Platform.isAndroid)
    {
      if (await Permission.storage.request().isGranted ||
          await Permission.manageExternalStorage.request().isGranted)
      {
        flag = true;
      }
      else if (await Permission.storage.isPermanentlyDenied)
      {
        await openAppSettings();
      }
      else
      {
        flag = false;
      }
    }
    else if (Platform.isIOS)
    {
      if (await Permission.photosAddOnly.request().isGranted)
      {
        flag = true;
      }
      else
      {
        flag = false;
      }
    }
    else
    {
      flag = false;
    }
    return flag;
  }

  Future<Directory?> getAppDirectoryBarcodeLabel() async
  {
    Directory? directory;

    try
    {
      if (Platform.isAndroid)
      {
        directory = Directory('/storage/emulated/0/Download/QWIKBILL/Barcode Label');
        if (!await directory.exists())
        {
          await directory.create(recursive: true);
        }
      }
      else if (Platform.isIOS)
      {
        directory = await getApplicationDocumentsDirectory();
        directory = Directory('${directory.path}/QWIKBILL/Barcode Label');
        if (!await directory.exists())
        {
          await directory.create(recursive: true);
        }
      }
    }
    catch (e)
    {
      print("Error getting directory: $e");
      return null;
    }
    return directory;
  }

  Future<void> saveBarcodeToAppDirectoryBarcodeLabel(WidgetsToImageController controller, String fileName, String imageType) async
  {
    try
    {
      Directory? appDirectory = await getAppDirectoryBarcodeLabel();

      if (appDirectory != null)
      {
        final Uint8List? bytes = await controller.capture();

        if (bytes != null)
        {
          final img.Image image = img.decodeImage(Uint8List.fromList(bytes))!;

          if(imageType=="PNG")
          {
            final file = File('${appDirectory.path}/${fileName}.png');
            final pngBytes = img.encodePng(image);
            await file.writeAsBytes(pngBytes);

            await Future.delayed(Duration(milliseconds: 300));
            toastWidget.showToast("Saved!");
          }
          else if(imageType=="JPG")
          {
            final file = File('${appDirectory.path}/${fileName}.jpg');
            final pngBytes = img.encodeJpg(image);
            await file.writeAsBytes(pngBytes);

            await Future.delayed(Duration(milliseconds: 300));
            toastWidget.showToast("Saved!");
          }
          else if(imageType=="BMP")
          {
            final file = File('${appDirectory.path}/${fileName}.bmp');
            final pngBytes = img.encodeBmp(image);
            await file.writeAsBytes(pngBytes);

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
      else
      {
        await Future.delayed(Duration(milliseconds: 300));
        toastWidget.showToast("Try again");
      }
    }
    catch (e)
    {
      print("$e");
      await Future.delayed(Duration(milliseconds: 300));
      toastWidget.showToast("Try again");
    }
  }

  Future<Directory?> getAppDirectorySalesReport() async
  {
    Directory? directory;

    try
    {
      if (Platform.isAndroid)
      {
        directory = Directory('/storage/emulated/0/Download/QWIKBILL/Sales Report');
        if (!await directory.exists())
        {
          await directory.create(recursive: true);
        }
      }
      else if (Platform.isIOS)
      {
        directory = await getApplicationDocumentsDirectory();
        directory = Directory('${directory.path}/QWIKBILL/Sales Report');
        if (!await directory.exists())
        {
          await directory.create(recursive: true);
        }
      }
    }
    catch (e)
    {
      print("Error getting directory: $e");
      return null;
    }
    return directory;
  }

  Container barcodeLabel(String barcodeData, String finalPrice,
      String manufacturingDate, String expiringDate, String color, String size)
  {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          SizedBox(height: 5),

          Text(
            'Price: ${finalPrice} Rs',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),

          SizedBox(height: 5),

          BarcodeWidget(
            barcode: Barcode.code128(),
            data: barcodeData,
            width: 300,
            height: 100,
          ),

          SizedBox(height: 5),

          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(manufacturingDate.isNotEmpty) Text(
                  'MFG: ${manufacturingDate}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                if(expiringDate.isNotEmpty) Text(
                  'EXP: ${expiringDate}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ]
          ),
          SizedBox(height: 5),

          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(color.isNotEmpty) Text(
                  'Color: ${color}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,

                  ),
                ),
                if(size.isNotEmpty) Text(
                  'Size: ${size}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ]
          ),
          SizedBox(height: 5),
        ],
      ),
    );
  }
}