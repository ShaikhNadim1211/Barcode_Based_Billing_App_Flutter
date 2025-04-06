import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomToastWidget
{
  Future<bool?> showToast(String message)
  {
    return Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.SNACKBAR,
      backgroundColor: Color(0xFFABE6B2),
      textColor: Colors.black,
      fontSize: 16.0,
    );
  }
}