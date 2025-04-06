import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:barcode_based_billing_system/screens/shop_worker/shop_worker_home_screen.dart';
import 'package:barcode_based_billing_system/screens/common/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../shop_owner/shop_owner_home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  var myOpacity = 0.2;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool logIn = prefs.getBool("logIn") ?? false;
    bool ownerLogIn = prefs.getBool("ownerLogIn") ?? false;
    bool workerLogIn = prefs.getBool("workerLogIn") ?? false;
    String ownerId = prefs.getString("ownerId") ?? "";
    String shopId = prefs.getString("shopId") ?? "";
    String workerId = prefs.getString("workerId") ?? "";

    if (logIn==null || logIn==false)
    {
      Timer(Duration(seconds: 6), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
      });
    }
    else
    {
      if (ownerLogIn)
      {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ShopOwnerHomeScreen(),
          ),
        );
      }
      else if (workerLogIn)
      {
        if(ownerId.isNotEmpty && shopId.isNotEmpty && workerId.isNotEmpty)
        {
          Map<String, dynamic> data = {
            "loggedin" : "0"
          };
          QuerySnapshot snapshot= await FirebaseFirestore.instance.collection("worker")
              .where("ownerid", isEqualTo: ownerId)
              .where("shopid", isEqualTo: shopId)
              .where("workerid", isEqualTo: workerId)
              .get();
          if(snapshot.docs.isNotEmpty)
          {
            var document= snapshot.docs.first;
            String u = document['isupdate'] ?? "1";
            if(u=="0")
            {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ShopWorkerHomeScreen(),
                ),
              );
            }
            else
            {
              var document = snapshot.docs.first.reference;
              await document.update(data);
              prefs.clear();
              Timer(Duration(seconds: 6), () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              });
            }
          }
          else
          {
            prefs.clear();
            Timer(Duration(seconds: 6), () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ),
              );
            });
          }
        }
        else
        {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ShopWorkerHomeScreen(),
            ),
          );
        }
      }
      else
      {

      }
    }

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        myOpacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedOpacity(
          opacity: myOpacity,
          duration: Duration(seconds: 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                child: Image.asset("assets/image/launch_icon.png"),
              ),
              Text(
                "QWIKBILL",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "SCAN. BILL. DONE",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
