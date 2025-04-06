import 'dart:io';

import 'package:barcode_based_billing_system/screens/common/login_screen.dart';
import 'package:barcode_based_billing_system/screens/common/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
      ));
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget
{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(

      title: 'QWIKBILL',

      theme: ThemeData(

        fontFamily: 'Roboto',

        primaryColor: Color(0xFFABE6B2), // Light green primary color

        scaffoldBackgroundColor: Color(0xFFFFFFFF), // Background color

        appBarTheme: AppBarTheme(
          color: Color(0xFFABE6B2), // App bar color
          iconTheme: IconThemeData(color: Colors.black), // Icon color
        ),

        buttonTheme: ButtonThemeData(
          buttonColor: Color(0xFFABE6B2), // Button color
          textTheme: ButtonTextTheme.primary,
        ),

        textTheme: TextTheme(
          bodyLarge: TextStyle(
              color: Colors.black,
              fontSize: MediaQuery.of(context).size.height * 0.02), // Main text color
          bodyMedium: TextStyle(
              color: Colors.black,
              fontSize: MediaQuery.of(context).size.height * 0.02), // Secondary text color
        ),

        cardColor: Color(0xFFC8EFD1), // Card background color or lighter green accent

        dividerColor: Color(0xFF2A2A2A), // Divider color

        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Color(0xFFABE6B2), // Cursor color
          selectionColor: Color(0xFFABE6B2), // Highlight color when selecting text
          selectionHandleColor: Color(0xFFABE6B2), // Color of the selection handle
        ),

        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: Color(0xFFC8EFD1),
        )
      ),

      debugShowCheckedModeBanner: false,

      home: const SplashScreen()
    );
  }
}