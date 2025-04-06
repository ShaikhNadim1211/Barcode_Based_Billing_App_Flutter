import 'package:barcode_based_billing_system/screens/shop_owner/shop_owner_toggle_ui_login_screen.dart';
import 'package:barcode_based_billing_system/screens/shop_worker/shop_worker_toggle_ui_login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class LoginScreen extends StatefulWidget
{
  @override
  State<StatefulWidget> createState()
  {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen>
{
  var selectedIndex = 0;


  @override
  Widget build(BuildContext context)
  {
    return PopScope(
      canPop: false,
      child: Scaffold(
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                SizedBox(height: 70),
                ToggleSwitch(
                  minWidth: MediaQuery.of(context).size.width,
                  minHeight: MediaQuery.of(context).size.height * 0.04,
                  fontSize: MediaQuery.of(context).size.height * 0.04,
                  initialLabelIndex: selectedIndex,
                  activeBgColor: [Theme.of(context).primaryColor],
                  activeFgColor: Colors.black,
                  inactiveBgColor: Colors.white,
                  inactiveFgColor: Colors.black,
                  totalSwitches: 2,
                  labels: ['Admin', 'Worker'],
                  borderWidth: 15,
                  borderColor: [Color(0xFFC8EFD1)],
                  customTextStyles: [
                    TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                  onToggle: (index) {
                    print("My index: ${index}");
                    setState(() {
                      selectedIndex = index!;
                    });
                  },
                ),
                SizedBox(height: 100),
                Padding(
                  padding: EdgeInsets.only(left: 25, right: 25, top: 25),
                  child: Column(
                    children: [
                      if (selectedIndex == 0) ShopOwnerToggleUILoginScreen(),
                      if (selectedIndex == 1) ShopWorkerToggleUILoginScreen(),
                    ],
                  )
                ),
              ],
            ),
          ),
      ),
    );
  }
}
