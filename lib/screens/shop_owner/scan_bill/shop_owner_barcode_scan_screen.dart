import 'package:barcode_based_billing_system/screens/shop_owner/scan_bill/shop_owner_scan_bill_customer_select_screen.dart';
import 'package:barcode_based_billing_system/screens/shop_owner/shop_owner_home_screen.dart';
import 'package:barcode_based_billing_system/widgets/custom_button_widget.dart';
import 'package:barcode_based_billing_system/widgets/custom_toast_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class ShopOwnerBarcodeScanScreen extends StatefulWidget
{
  @override
  State<StatefulWidget> createState()
  {
    return ShopOwnerBarcodeScanScreenState();
  }
}

class ShopOwnerBarcodeScanScreenState extends State<ShopOwnerBarcodeScanScreen>
{
  CustomButtonWidget buttonWidget = CustomButtonWidget();
  CustomToastWidget toastWidget = CustomToastWidget();

  String selectedShop = "";
  String ownerId = "";

  late Stream<QuerySnapshot> productStream;
  late Stream<QuerySnapshot> selectShopStream;

  bool shopFetch = false;
  bool shopFetchError = false;

  bool isLoading = true;

  late CameraController controller;
  late Future<void> initializeControllerFuture;
  final BarcodeScanner barcodeScanner = BarcodeScanner();
  List<Barcode> scannedProducts = [];
  int scannedItemCount = 0;
  bool showItemCountPopup = false;
  Map<String, int> scannedQuantity = {};
  Map<String, Map<String, dynamic>> productDetails = {};

  Future<void> _initializeScreen() async
  {
    try
    {
      await Future.wait([
        _fetchOwnerId(),
        _fetchSelectedShops(),
        _fetchShop(),
        _fetchProduct(),
        _initializeCamera(),
      ]);
    }
    catch (e)
    {
      print("Error during initialization: $e");
    }
    finally
    {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchOwnerId() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ownerId = prefs.getString("username") ?? "";
    if(ownerId.isNotEmpty)
    {
      setState(() {
        this.ownerId = ownerId;
      });
    }
    print(this.ownerId.toString());
  }

  Future<void> _fetchSelectedShops() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String select = prefs.getString("scanBarcodeSelectedShop") ?? "";
    String username = prefs.getString("username") ?? "";
    if(select.isNotEmpty && username.isNotEmpty)
    {
      setState(() {
        this.selectedShop = select;
        this.ownerId = username;
      });
    }
    print(this.selectedShop.toString());
  }

  Future<void> _fetchShop() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.ownerId = prefs.getString("username") ?? "";

    if(this.ownerId.isNotEmpty)
    {
      setState(() {
        this.selectShopStream = FirebaseFirestore.instance
            .collection('shop')
            .where('ownerid', isEqualTo: this.ownerId)
            .snapshots();
      });
    }
  }

  Future<void> _fetchProduct() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username') ?? '';

    if (username.isNotEmpty)
    {
      setState(() {
        this.productStream = FirebaseFirestore.instance
            .collection('product')
            .where('ownerid', isEqualTo: username)
            .snapshots();
      });
    }
  }

  Future<void> _initializeCamera() async
  {
    try
    {
      final cameras = await availableCameras();
      final firstCamera = cameras.first;

      setState(() {
        this.controller = CameraController(firstCamera, ResolutionPreset.high);
        this.initializeControllerFuture = this.controller.initialize();
      });
    }
    catch (e)
    {
      print('Camera initialization error: $e');
    }
  }

  Future<void> _scanImage() async
  {
    try
    {
      await this.initializeControllerFuture;

      final Directory extDir = await getTemporaryDirectory();
      final String dirPath = '${extDir.path}/Pictures/barcode_scanner';
      await Directory(dirPath).create(recursive: true);
      final String filePath = path.join(dirPath, '${DateTime.now().millisecondsSinceEpoch}.jpg');

      await this.controller.takePicture().then((XFile file) {
        file.saveTo(filePath);
      });

      final inputImage = InputImage.fromFilePath(filePath);

      // Process the image and detect barcodes
      final List<Barcode> barcodes = await this.barcodeScanner.processImage(inputImage);

      if (!mounted) return;

      setState(() {
        if (barcodes.isNotEmpty)
        {
          for (var barcode in barcodes)
          {
            String barcodeValue = barcode.displayValue ?? "";

            FirebaseFirestore.instance
                .collection('product')
                .where("ownerid", isEqualTo: this.ownerId)
                .where('shopid', isEqualTo: this.selectedShop)
                .where('barcodenumber', isEqualTo: barcodeValue)
                .get()
                .then((querySnapshot) {

                  if (querySnapshot.docs.isNotEmpty)
                  {
                    var product = querySnapshot.docs.first;

                    List<String> optionalField = List<String>.from(product['optionalField']);
                    Map<String, String> optionalFieldValue = Map<String, String>.from(product['optionalFieldValue']);

                    // Check the current stock quantity for the product
                    int stockQuantity = int.parse(product['quantity'] ?? "0");
                    int scannedCount = scannedQuantity[barcodeValue] ?? 0;

                    if(stockQuantity > scannedCount)
                    {
                      if(optionalField.contains("Expiring Date"))
                      {
                        DateTime expiryDate = DateTime.parse(optionalFieldValue["Expiring Date"].toString());
                        DateTime currentDate = DateTime.now();

                        if(currentDate.isAfter(expiryDate))
                        {
                          toastWidget.showToast("${product['productname']} is Expired");
                        }
                        else
                        {
                          if (!scannedProducts.any((item) => item.displayValue == barcodeValue))
                          {
                            scannedProducts.add(barcode);
                          }
                          setState(() {
                            scannedQuantity[barcodeValue] = (scannedQuantity[barcodeValue] ?? 0) + 1;
                            scannedItemCount += 1;
                          });

                          int updatedStockQuantity = stockQuantity - (scannedCount + 1);
                          productDetails[barcodeValue] = {
                            'productid': product['productid'],
                            'productname': product['productname'],
                            'buyingprice': product['buyingprice'],
                            'sellingprice': product['sellingprice'],
                            'barcodenumber': barcodeValue,
                            'quantity': product["quantity"],
                            'finalprice': product['finalprice'],
                            'optionalField': List<String>.from(product['optionalField']),
                            'optionalFieldValue': Map<String, String>.from(product['optionalFieldValue']),
                            'scannedCount': (scannedCount + 1).toString(),
                            'finalStockQuantity': updatedStockQuantity.toString(),
                          };
                        }
                      }
                      else
                      {
                        if (!scannedProducts.any((item) => item.displayValue == barcodeValue))
                        {
                          scannedProducts.add(barcode);
                        }
                        setState(() {
                          scannedQuantity[barcodeValue] = (scannedQuantity[barcodeValue] ?? 0) + 1;
                          scannedItemCount += 1;
                        });

                        int updatedStockQuantity = stockQuantity - (scannedCount + 1);
                        productDetails[barcodeValue] = {
                          'productid': product['productid'],
                          'productname': product['productname'],
                          'buyingprice': product['buyingprice'],
                          'sellingprice': product['sellingprice'],
                          'barcodenumber': barcodeValue,
                          'quantity': product["quantity"],
                          'finalprice': product['finalprice'],
                          'optionalField': List<String>.from(product['optionalField']),
                          'optionalFieldValue': Map<String, String>.from(product['optionalFieldValue']),
                          'scannedCount': (scannedCount + 1).toString(),
                          'finalStockQuantity': updatedStockQuantity.toString(),
                        };
                      }
                    }
                    else
                    {
                      toastWidget.showToast("Insufficient stock for ${product['productname']}");
                    }
                  }
            });
          }
          showItemCountPopup = true;
        }
      });


      final File imageFile = File(filePath);

      if (await imageFile.exists())
      {
        await imageFile.delete();
      }

      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          this.showItemCountPopup = false;
        });
      });
    }
    catch (e)
    {
      print('Error scanning image: $e');
    }
  }
  bool permission = false;

  Future<void> checkPermission() async
  {
    if(await Permission.camera.isDenied || await Permission.camera.isPermanentlyDenied
    || await Permission.microphone.isDenied || await Permission.microphone.isPermanentlyDenied)
    {
      setState(() {
        this.permission = false;
      });
    }

    if(await Permission.camera.isGranted && await Permission.microphone.isGranted)
    {
      setState(() {
        this.permission = true;
      });
    }
  }
  
  @override
  void initState()
  {
    super.initState();
    _initializeScreen();
    checkPermission();
  }

  @override
  void dispose()
  {
    this.controller.dispose();
    this.barcodeScanner.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Scan Barcode",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => ShopOwnerHomeScreen()));
            },
            icon: Icon(Icons.arrow_back),
          ),
        ),

        body: isLoading
        ? Center(child: CircularProgressIndicator())
        : permission ?
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            //Shop Drop Down
            StreamBuilder<QuerySnapshot>(
              stream: selectShopStream,
              builder: (context, snapshot){
                if (snapshot.connectionState == ConnectionState.waiting)
                {
                  return Center(child: CircularProgressIndicator(color: Theme.of(context).cardColor,));
                }
                else if(snapshot.hasError)
                {
                  this.shopFetchError = true;
                  return Center(
                    child: Text(
                      "Some error occurred",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.height * 0.04,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
                else if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
                {
                  this.shopFetchError = true;
                  return Center(
                    child: Text(
                      'No shops available',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.height * 0.04,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
                else if(snapshot.hasData)
                {
                  this.shopFetchError = false;

                  List<String> shopNames = snapshot.data!.docs
                      .map((doc) => doc['shopname'].toString())
                      .toList();

                  return shopNames.isEmpty
                      ? Center(
                    child: Text(
                      'No shops available',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.height * 0.04,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                      : Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Container(
                        child: DropdownButton<String>(
                          value: this.selectedShop.isNotEmpty ? this.selectedShop : null,
                          hint: Text("Select Shop"),
                          onChanged: (newShop) async {
                            setState(() {
                              this.selectedShop = newShop.toString();
                            });
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.setString("scanBarcodeSelectedShop", this.selectedShop);

                          },
                          items: shopNames.map((shop) {
                            return DropdownMenuItem<String>(
                              value: shop,
                              child: Text(shop),
                            );
                          }).toList(),
                          icon: Icon(Icons.arrow_drop_down, color: Colors.black, size: 30),

                          style: TextStyle(color: Colors.black, fontSize: 16,),
                          dropdownColor: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  );
                }
                else
                {
                  this.shopFetchError = true;
                  return Center(
                    child: Text(
                      'No shops available',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.height * 0.04,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
              },
            ),
            SizedBox(height: 10),

            if(this.selectedShop.isEmpty && this.shopFetchError==false)
            Center(
              child: Text(
                'Select the shop',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: MediaQuery.of(context).size.height * 0.04,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),


            // Camera preview fixed at the top with 40% height
            if(this.selectedShop.isNotEmpty)
            FutureBuilder<void>(
              future: this.initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done)
                {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: MediaQuery.of(context).size.width,
                    child: CameraPreview(this.controller),
                  );
                }
                else
                {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),

            // Floating button or text showing scanned item count
            if (showItemCountPopup)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    color: Theme.of(context).primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Text(
                      'Scanned Items: $scannedItemCount',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: MediaQuery.of(context).size.height * 0.025,
                      ),
                    ),
                  ),
                ),
              ),


            if(this.selectedShop.isNotEmpty) SizedBox(height: 20),
            if(this.selectedShop.isNotEmpty) buttonWidget.ButtonField(
                context,
                "Capture and Scan",
                ()
                {
                  _scanImage();
                }
            ),
            if(this.selectedShop.isNotEmpty) SizedBox(height: 20),

            // StreamBuilder to display the product based on scanned barcode
            if (this.selectedShop.isNotEmpty)
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: productStream,
                  builder: (context, snapshot) {

                    if (snapshot.connectionState == ConnectionState.waiting)
                    {
                      return Center();
                    }
                    else if (snapshot.hasError)
                    {
                      return Center(
                        child: Text(
                          "Error: ${snapshot.error}",
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
                      var products = snapshot.data!.docs;

                      var filteredProducts = products.where((product) {
                        String bNumber = product['barcodenumber'];
                        String sShop = product['shopid'];
                        return sShop == this.selectedShop &&
                            scannedProducts.any((barcode) => barcode.displayValue == bNumber);
                      }).toList();

                      if (filteredProducts.isEmpty)
                      {
                        return Center(
                          child: Text(
                            "No products found",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: MediaQuery.of(context).size.height * 0.04,
                            ),
                          ),
                        );
                      }
                      else
                      {
                        return ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: filteredProducts.length,
                          itemBuilder: (context, index) {
                            var product = filteredProducts[index];

                            String productName = product["productname"];
                            String barcodenumber = product["barcodenumber"];
                            String finalPrice = product["finalprice"];

                            // Fetch the scanned quantity for the product barcode
                            int scannedProductCount = scannedQuantity[barcodenumber] ?? 0;

                            return Card(
                              color: Theme.of(context).cardColor,
                              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                              child: ListTile(
                                title: Text(
                                  productName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: MediaQuery.of(context).size.height * 0.025,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Price: $finalPrice", style: TextStyle(color: Colors.black)),
                                    Text("Barcode Number: $barcodenumber", style: TextStyle(color: Colors.black)),
                                    Text("Item Quantity: $scannedProductCount", style: TextStyle(color: Colors.black)),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [

                                    //Increment
                                    IconButton(
                                      onPressed: (){

                                        Map<String, dynamic> product = this.productDetails[barcodenumber]!;

                                        if(product.isNotEmpty)
                                        {
                                          // Check the current stock quantity for the product
                                          int stockQuantity = int.parse(product['quantity'] ?? "0");
                                          int scannedCount = int.parse(product["scannedCount"] ?? "0");

                                          if(stockQuantity > scannedCount)
                                          {
                                            setState(() {
                                              scannedQuantity[barcodenumber] = (scannedQuantity[barcodenumber] ?? 0) + 1;
                                              scannedItemCount += 1;
                                            });

                                            int updatedStockQuantity = stockQuantity - (scannedCount + 1);
                                            productDetails[barcodenumber] = {
                                              'productid': product['productid'],
                                              'productname': product['productname'],
                                              'buyingprice': product['buyingprice'],
                                              'sellingprice': product['sellingprice'],
                                              'barcodenumber': barcodenumber,
                                              'quantity': product["quantity"],
                                              'finalprice': product['finalprice'],
                                              'optionalField': List<String>.from(product['optionalField']),
                                              'optionalFieldValue': Map<String, String>.from(product['optionalFieldValue']),
                                              'scannedCount': (scannedCount + 1).toString(),
                                              'finalStockQuantity': updatedStockQuantity.toString(),
                                            };
                                          }
                                          else
                                          {
                                            toastWidget.showToast("Insufficient stock for ${product['productname']}");
                                          }
                                        }
                                      },
                                      icon: Icon(Icons.add, color: Colors.black),
                                    ),

                                    //Decrement
                                    IconButton(
                                      onPressed: (){

                                        Map<String, dynamic> product = this.productDetails[barcodenumber]!;

                                        if(product.isNotEmpty)
                                        {
                                          // Check the current stock quantity for the product
                                          int stockQuantity = int.parse(product['quantity'] ?? "0");
                                          int scannedCount = int.parse(product["scannedCount"] ?? "0");

                                          if(scannedCount > 1)
                                          {
                                            setState(() {
                                              scannedQuantity[barcodenumber] = (scannedQuantity[barcodenumber] ?? 0) - 1;
                                              scannedItemCount -= 1;
                                            });

                                            int updatedStockQuantity = stockQuantity - (scannedCount - 1);
                                            productDetails[barcodenumber] = {
                                              'productid': product['productid'],
                                              'productname': product['productname'],
                                              'buyingprice': product['buyingprice'],
                                              'sellingprice': product['sellingprice'],
                                              'barcodenumber': barcodenumber,
                                              'quantity': product["quantity"],
                                              'finalprice': product['finalprice'],
                                              'optionalField': List<String>.from(product['optionalField']),
                                              'optionalFieldValue': Map<String, String>.from(product['optionalFieldValue']),
                                              'scannedCount': (scannedCount - 1).toString(),
                                              'finalStockQuantity': updatedStockQuantity.toString(),
                                            };
                                          }
                                          else
                                          {
                                            setState(() {
                                              Barcode itemToRemove = scannedProducts.firstWhere(
                                                    (item) => item.displayValue == barcodenumber,
                                              );
                                              if (Barcode!=null)
                                              {
                                                scannedProducts.remove(itemToRemove);
                                              }
                                              // Remove the product from productDetails and barcodeNumberAndQuantity
                                              productDetails.remove(barcodenumber);
                                              scannedQuantity.remove(barcodenumber);
                                              scannedItemCount -= 1;
                                            });
                                          }
                                        }

                                      },
                                      icon: Icon(Icons.remove),
                                    ),

                                    //Remove
                                    IconButton(
                                      onPressed: ()
                                      {
                                        setState(() {
                                          Barcode itemToRemove = scannedProducts.firstWhere(
                                                (item) => item.displayValue == barcodenumber,
                                          );
                                          if (Barcode!=null)
                                          {
                                            scannedProducts.remove(itemToRemove);
                                          }
                                          // Remove the product from productDetails and barcodeNumberAndQuantity
                                          productDetails.remove(barcodenumber);
                                          scannedQuantity.remove(barcodenumber);
                                          scannedItemCount -= scannedProductCount;
                                        });
                                      },
                                      icon: Icon(Icons.delete, color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                    }
                    else
                    {
                      return Center(
                        child: Text(
                          "No products found",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.height * 0.04,
                          ),
                        ),
                      );
                    }
                  },
                ),
              )

          ],
        ): Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Allow camera and microphone access",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.height * 0.04,
              ),
            ),
          ],
        ),
        floatingActionButton: permission ? FloatingActionButton(
          onPressed: () async {

            if(this.selectedShop.isNotEmpty && this.scannedProducts.isNotEmpty && this.productDetails.isNotEmpty)
            {
              print(this.productDetails.toString());
              print(this.scannedQuantity.toString());
              //Navigate
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ShopOwnerScanBillCustomerSelectScreen(this.ownerId, this.selectedShop, this.scannedQuantity, this.productDetails)
                  )
              );
            }
            else
            {
              await Future.delayed(Duration(milliseconds: 300));
              toastWidget.showToast("Try again");
            }
          },
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(Icons.navigate_next, color: Colors.black, size: 40,)
        ): null,
      ),
    );
  }

}