import 'package:barcode_based_billing_system/methods/barcode_number_generator.dart';
import 'package:barcode_based_billing_system/methods/date_picker.dart';
import 'package:barcode_based_billing_system/screens/shop_owner/product_manage/shop_owner_manage_product_screen.dart';
import 'package:barcode_based_billing_system/widgets/custom_button_widget.dart';
import 'package:barcode_based_billing_system/widgets/custom_toast_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import '../../../widgets/custom_input_field_widget.dart';

class ShopOwnerProductUpdateScreen extends StatefulWidget
{
  final String ownerId;
  final String shopId;
  final String productId;
  final String productName;
  final String buyingPrice;
  final String sellingPrice;
  final String barcodenumber;
  final String quantity;
  final String finalPrice;
  final List<String> optionalField;
  final Map<String, String> optionalFieldValue;

  ShopOwnerProductUpdateScreen(this.ownerId, this.shopId, this.productId, this.productName, this.buyingPrice, this.sellingPrice, this.barcodenumber, this.quantity, this.optionalField, this.optionalFieldValue, this.finalPrice);

  @override
  State<StatefulWidget> createState()
  {
    return ShopOwnerProductUpdateScreenState();
  }
}

class ShopOwnerProductUpdateScreenState extends State<ShopOwnerProductUpdateScreen>
{
  CustomInputFieldWidget inputFieldWidget =CustomInputFieldWidget();
  CustomButtonWidget buttonWidget = CustomButtonWidget();
  CustomToastWidget toastWidget = CustomToastWidget();
  BarcodeNumberGenerator barcodeNumberGenerator = BarcodeNumberGenerator();
  DatePicker datePicker = DatePicker();

  String ownerId = "";
  String shopId = "";
  String productId = "";

  List<String> optionalField = ["Discount","Size", "Colour", "GST", "Category", "Description", "Manufacturing Date", "Expiring Date"];
  List<String> selectedOptionalField = [];
  Map<String, String> optionalFieldValue ={};

  TextEditingController productName = TextEditingController();
  TextEditingController buyingPrice = TextEditingController();
  TextEditingController sellingPrice = TextEditingController();
  TextEditingController quantity = TextEditingController();
  TextEditingController barcodeNumber = TextEditingController();
  TextEditingController discount = TextEditingController();
  TextEditingController size = TextEditingController();
  TextEditingController colour = TextEditingController();
  TextEditingController gst = TextEditingController();
  TextEditingController category = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController manufacturingDate = TextEditingController();
  TextEditingController expiringDate = TextEditingController();

  String productNameMssg = "";
  String buyingPriceMssg = "";
  String sellingPriceMssg = "";
  String quantityMssg = "";
  String barcodeNumberMssg = "";
  String discountMssg = "";
  String sizeMssg = "";
  String colourMssg = "";
  String gstMssg = "";
  String categoryMssg = "";
  String descriptionMssg = "";
  String manufacturingDateMssg = "";
  String expiringDateMssg = "";

  Color productNameMssgColor = Colors.green;
  Color buyingPriceMssgColor = Colors.green;
  Color sellingPriceMssgColor = Colors.green;
  Color quantityMssgColor = Colors.green;
  Color barcodeNumberMssgColor = Colors.green;
  Color discountMssgColor = Colors.red;
  Color sizeMssgColor = Colors.red;
  Color colourMssgColor = Colors.red;
  Color gstMssgColor = Colors.red;
  Color categoryMssgColor = Colors.red;
  Color descriptionMssgColor = Colors.red;
  Color manufacturingDateMssgColor = Colors.red;
  Color expiringDateMssgColor = Colors.red;

  bool productNameVerification = true;
  bool buyingPriceVerification = true;
  bool sellingPriceVerification = true;
  bool quantityVerification = true;
  bool barcodeNumberVerification = true;
  bool discountVerification = false;
  bool sizeVerification = false;
  bool colourVerification = false;
  bool gstVerification = false;
  bool categoryVerification = false;
  bool descriptionVerification = false;
  bool manufacturingDateVerification = false;
  bool expiringDateVerification = false;

  bool barcodeNumberVisibility = false;

  DateFormat _format = DateFormat("yyyy-MM-dd");

  DateTime manufacturingIntialDate = DateTime.now().subtract(Duration(days: 1));
  DateTime manufacturingFirstdate = DateTime.now().subtract(Duration(days: 365 * 20));
  DateTime manufacturingLastDate = DateTime.now().subtract(Duration(days: 1));

  DateTime expiringIntialDate = DateTime.now().add(Duration(days: 1));
  DateTime expiringFirstdate = DateTime.now().add(Duration(days: 1));
  DateTime expiringLastDate = DateTime.now().add(Duration(days: 365 * 20));

  @override
  void initState()
  {
    super.initState();
    this.ownerId = widget.ownerId;
    this.shopId = widget.shopId;
    this.productId = widget.productId;
    this.productName.text = widget.productName;
    this.buyingPrice.text = widget.buyingPrice;
    this.sellingPrice.text = widget.sellingPrice;
    this.barcodeNumber.text = widget.barcodenumber;
    this.quantity.text = widget.quantity;
    this.selectedOptionalField = widget.optionalField;
    this.optionalFieldValue = widget.optionalFieldValue;

    for(var s in widget.optionalField)
    {
      switch(s)
      {
        case "Discount":
          this.discount.text = widget.optionalFieldValue["Discount"].toString();
          this.discountMssgColor = Colors.green;
          this.discountVerification = true;
          break;
        case "Size":
          this.size.text = widget.optionalFieldValue["Size"].toString();
          this.sizeMssgColor = Colors.green;
          this.sizeVerification = true;
          break;
        case "Colour":
          this.colour.text = widget.optionalFieldValue["Colour"].toString();
          this.colourMssgColor = Colors.green;
          this.colourVerification = true;
          break;
        case "GST":
          this.gst.text = widget.optionalFieldValue["GST"].toString();
          this.gstMssgColor = Colors.green;
          this.gstVerification = true;
          break;
        case "Category":
          this.category.text = widget.optionalFieldValue["Category"].toString();
          this.categoryMssgColor = Colors.green;
          this.categoryVerification = true;
          break;
        case "Description":
          this.description.text = widget.optionalFieldValue["Description"].toString();
          this.descriptionMssgColor = Colors.green;
          this.descriptionVerification = true;
          break;
        case "Manufacturing Date":
          this.manufacturingDate.text = widget.optionalFieldValue["Manufacturing Date"].toString();
          this.manufacturingDateMssgColor = Colors.green;
          this.manufacturingDateVerification = true;
          this.manufacturingIntialDate = _format.parse(this.manufacturingDate.text.toString());
          break;
        case "Expiring Date":
          this.expiringDate.text = widget.optionalFieldValue["Expiring Date"].toString();
          this.expiringDateMssgColor = Colors.green;
          this.expiringDateVerification = true;
          this.expiringIntialDate = _format.parse(this.expiringDate.text.toString());
          break;
        default:
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context)
  {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Update Product",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
              onPressed: (){
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context)=>ShopOwnerManageProductScreen()
                    )
                );
              },
              icon: Icon(Icons.arrow_back)
          ),
        ),
        
        body: Padding(
          padding: EdgeInsets.only(left: 25,right: 25),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                SizedBox(height: 15),
                //Optional Product Field List
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: MultiSelectDialogField(
                      items: optionalField
                          .map((product) => MultiSelectItem<String>(product, product))
                          .toList(),
                      title: Text("Select Product"),
                      selectedColor: Colors.green,
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).primaryColor),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      initialValue: this.selectedOptionalField,
                      buttonIcon: Icon(Icons.arrow_drop_down, color: Colors.black, size: 30,),
                      buttonText: Text("Additional Field", style: TextStyle(color: Colors.black, fontSize: 16),),
                      onConfirm: (selected) async{
                        setState((){
                          this.selectedOptionalField = List<String>.from(selected);
                          print(this.selectedOptionalField.toString());
                        });
                      },
                      chipDisplay: MultiSelectChipDisplay.none(),
                      backgroundColor: Colors.white,
                      dialogHeight: MediaQuery.of(context).size.height * 0.3,
                    ),
                  ),
                ),
                SizedBox(height: 30),

                //Product Name
                inputFieldWidget.NormalInputFieldWithOnChange(
                    context,
                    productName,
                    "E.g, Surya A4 Note Book",
                    Icon(Icons.label),
                    TextInputType.text,
                    Icon(Icons.verified_user, color: productNameMssgColor,),
                        (value) async
                    {
                      if(value.isEmpty)
                      {
                        productNameVerification = false;
                        productNameMssgColor = Colors.red;
                        productNameMssg = "Field is required";
                      }
                      else
                      {
                        RegExp regExp = RegExp(r"^[a-zA-Z0-9\s\-_&]{5,50}$");
                        bool match = regExp.hasMatch(value.trim());

                        if(match)
                        {
                          productNameVerification = true;
                          productNameMssgColor = Colors.green;
                          productNameMssg = "";
                        }
                        else
                        {
                          productNameVerification = false;
                          productNameMssgColor = Colors.red;
                          productNameMssg = "Product name must be at least 5 characters and can include letters, numbers, spaces, and symbols (-, _, &)";
                        }
                      }
                      setState(() {

                      });
                    },
                    true,
                    50,
                    "Product Name"
                ),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 35.0,right: 35.0),
                  child: Text(
                    productNameMssg,
                    style: TextStyle(
                      color: productNameMssgColor,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.height * 0.018,
                    ),
                  ),
                ),
                SizedBox(height: 20),

                //Buying Price
                inputFieldWidget.NormalInputFieldWithOnChange(
                    context,
                    buyingPrice,
                    "E.g, 50",
                    Icon(Icons.currency_rupee),
                    TextInputType.number,
                    Icon(Icons.verified_user, color: buyingPriceMssgColor,),
                        (value)
                    {
                      if(value.isEmpty)
                      {
                        buyingPriceVerification = false;
                        buyingPriceMssgColor = Colors.red;
                        buyingPriceMssg = "Field is required";
                      }
                      else
                      {
                        RegExp regExp = RegExp(r"^\d+(\.\d{1,2})?$");
                        bool match = regExp.hasMatch(value.trim());

                        if(match)
                        {
                          buyingPriceVerification = true;
                          buyingPriceMssgColor = Colors.green;
                          buyingPriceMssg = "";
                        }
                        else
                        {
                          buyingPriceVerification = false;
                          buyingPriceMssgColor = Colors.red;
                          buyingPriceMssg = "Invalid price format. Use a number with up to two decimal places.";
                        }
                      }
                      setState(() {

                      });
                    },
                    true,
                    12,
                    "Buying Price"
                ),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 35.0,right: 35.0),
                  child: Text(
                    buyingPriceMssg,
                    style: TextStyle(
                      color: buyingPriceMssgColor,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.height * 0.018,
                    ),
                  ),
                ),
                SizedBox(height: 20),

                //Selling Price
                inputFieldWidget.NormalInputFieldWithOnChange(
                    context,
                    sellingPrice,
                    "E.g, 60",
                    Icon(Icons.currency_rupee),
                    TextInputType.number,
                    Icon(Icons.verified_user, color: sellingPriceMssgColor,),
                        (value)
                    {
                      if(value.isEmpty)
                      {
                        sellingPriceVerification = false;
                        sellingPriceMssgColor = Colors.red;
                        sellingPriceMssg = "Field is required";
                      }
                      else
                      {
                        RegExp regExp = RegExp(r"^\d+(\.\d{1,2})?$");
                        bool match = regExp.hasMatch(value.trim());

                        if(match)
                        {
                          sellingPriceVerification = true;
                          sellingPriceMssgColor = Colors.green;
                          sellingPriceMssg = "";
                        }
                        else
                        {
                          sellingPriceVerification = false;
                          sellingPriceMssgColor = Colors.red;
                          sellingPriceMssg = "Invalid price format. Use a number with up to two decimal places.";
                        }
                      }
                      setState(() {

                      });
                    },
                    true,
                    12,
                    "Selling Price"
                ),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 35.0,right: 35.0),
                  child: Text(
                    sellingPriceMssg,
                    style: TextStyle(
                      color: sellingPriceMssgColor,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.height * 0.018,
                    ),
                  ),
                ),
                SizedBox(height: 20),

                //Barcode Number
                inputFieldWidget.NormalInputFieldWithOnChange(
                    context,
                    barcodeNumber,
                    "E.g, 123456789000",
                    Icon(Icons.local_offer),
                    TextInputType.number,
                    IconButton(
                      icon: Icon(Icons.qr_code_scanner, color: Colors.black,),
                      onPressed: (){
                        }
                    ),
                    (value)
                    {

                    },
                    barcodeNumberVisibility,
                    20,
                    "Barcode Number"
                ),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 35.0,right: 35.0),
                  child: Text(
                    barcodeNumberMssg,
                    style: TextStyle(
                      color: barcodeNumberMssgColor,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.height * 0.018,
                    ),
                  ),
                ),
                SizedBox(height: 20),

                //Quantity
                inputFieldWidget.NormalInputFieldWithOnChange(
                    context,
                    quantity,
                    "E.g, 60",
                    Icon(Icons.production_quantity_limits),
                    TextInputType.number,
                    Icon(Icons.verified_user, color: quantityMssgColor,),
                        (value)
                    {
                      if(value.isEmpty)
                      {
                        quantityVerification = false;
                        quantityMssgColor = Colors.red;
                        quantityMssg = "Field is required";
                      }
                      else
                      {
                        RegExp regExp = RegExp(r"^[1-9]\d*$");
                        bool match = regExp.hasMatch(value.trim());

                        if(match)
                        {
                          quantityVerification = true;
                          quantityMssgColor = Colors.green;
                          quantityMssg = "";
                        }
                        else
                        {
                          quantityVerification = false;
                          quantityMssgColor = Colors.red;
                          quantityMssg = "Quantity must be a positive integer, no leading zeros";
                        }
                      }
                      setState(() {

                      });
                    },
                    true,
                    10,
                    "Stock Quantity"
                ),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 35.0,right: 35.0),
                  child: Text(
                    quantityMssg,
                    style: TextStyle(
                      color: quantityMssgColor,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.height * 0.018,
                    ),
                  ),
                ),
                SizedBox(height: 20),

                //Optional Field

                //Discount Field
                if(this.selectedOptionalField.contains("Discount")) inputFieldWidget.NormalInputFieldWithOnChange(
                    context,
                    discount,
                    "E.g, 2 (in Percentage)",
                    Icon(Icons.discount),
                    TextInputType.number,
                    Icon(Icons.verified_user, color: discountMssgColor,),
                        (value)
                    {
                      if(value.isEmpty)
                      {
                        discountVerification = false;
                        discountMssgColor = Colors.red;
                        discountMssg = "Field is required";
                      }
                      else
                      {
                        RegExp regExp = RegExp(r"^(100(?:\.0{1,2})?|[1-9]?\d(?:\.\d{1,2})?)$");
                        bool match = regExp.hasMatch(value.trim());

                        if(match)
                        {
                          discountVerification = true;
                          discountMssgColor = Colors.green;
                          discountMssg = "";
                        }
                        else
                        {
                          discountVerification = false;
                          discountMssgColor = Colors.red;
                          discountMssg = "Discount must be between 0 and 100, with up to two decimal places.";
                        }
                      }
                      setState(() {

                      });
                    },
                    true,
                    5,
                    "Discount"
                ),
                if(this.selectedOptionalField.contains("Discount")) SizedBox(height: 5),
                if(this.selectedOptionalField.contains("Discount")) Padding(
                  padding: const EdgeInsets.only(left: 35.0,right: 35.0),
                  child: Text(
                    discountMssg,
                    style: TextStyle(
                      color: discountMssgColor,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.height * 0.018,
                    ),
                  ),
                ),
                if(this.selectedOptionalField.contains("Discount")) SizedBox(height: 20),

                //Size Field
                if(this.selectedOptionalField.contains("Size")) inputFieldWidget.NormalInputFieldWithOnChange(
                    context,
                    size,
                    "E.g, Medium",
                    Icon(Icons.straighten),
                    TextInputType.text,
                    Icon(Icons.verified_user, color: sizeMssgColor,),
                        (value)
                    {
                      if(value.isEmpty)
                      {
                        sizeVerification = false;
                        sizeMssgColor = Colors.red;
                        sizeMssg = "Field is required";
                      }
                      else
                      {
                        RegExp regExp = RegExp(r"^[a-zA-Z0-9 ]+$");
                        bool match = regExp.hasMatch(value.trim());

                        if(match)
                        {
                          sizeVerification = true;
                          sizeMssgColor = Colors.green;
                          sizeMssg = "";
                        }
                        else
                        {
                          sizeVerification = false;
                          sizeMssgColor = Colors.red;
                          sizeMssg = "Size must be alphanumeric (letters and numbers only)";
                        }
                      }
                      setState(() {

                      });
                    },
                    true,
                    15,
                    "Size"
                ),
                if(this.selectedOptionalField.contains("Size")) SizedBox(height: 5),
                if(this.selectedOptionalField.contains("Size")) Padding(
                  padding: const EdgeInsets.only(left: 35.0,right: 35.0),
                  child: Text(
                    sizeMssg,
                    style: TextStyle(
                      color: sizeMssgColor,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.height * 0.018,
                    ),
                  ),
                ),
                if(this.selectedOptionalField.contains("Size")) SizedBox(height: 20),

                //Colour Field
                if(this.selectedOptionalField.contains("Colour")) inputFieldWidget.NormalInputFieldWithOnChange(
                    context,
                    colour,
                    "E.g, Green",
                    Icon(Icons.format_color_fill),
                    TextInputType.text,
                    Icon(Icons.verified_user, color: colourMssgColor,),
                        (value)
                    {
                      if(value.isEmpty)
                      {
                        colourVerification = false;
                        colourMssgColor = Colors.red;
                        colourMssg = "Field is required";
                      }
                      else
                      {
                        RegExp regExp = RegExp(r"^[a-zA-Z ]+$");
                        bool match = regExp.hasMatch(value.trim());

                        if(match)
                        {
                          colourVerification = true;
                          colourMssgColor = Colors.green;
                          colourMssg = "";
                        }
                        else
                        {
                          colourVerification = false;
                          colourMssgColor = Colors.red;
                          colourMssg = "Color must contain only letters and spaces";
                        }
                      }
                      setState(() {

                      });
                    },
                    true,
                    15,
                    "Colour"
                ),
                if(this.selectedOptionalField.contains("Colour")) SizedBox(height: 5),
                if(this.selectedOptionalField.contains("Colour")) Padding(
                  padding: const EdgeInsets.only(left: 35.0,right: 35.0),
                  child: Text(
                    colourMssg,
                    style: TextStyle(
                      color: colourMssgColor,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.height * 0.018,
                    ),
                  ),
                ),
                if(this.selectedOptionalField.contains("Colour")) SizedBox(height: 20),

                //GST Number Field
                if(this.selectedOptionalField.contains("GST")) inputFieldWidget.NormalInputFieldWithOnChange(
                    context,
                    gst,
                    "E.g, 5 (in Percentage)",
                    Icon(Icons.receipt),
                    TextInputType.number,
                    Icon(Icons.verified_user, color: gstMssgColor,),
                        (value)
                    {
                      if(value.isEmpty)
                      {
                        gstVerification = false;
                        gstMssgColor = Colors.red;
                        gstMssg = "Field is required";
                      }
                      else
                      {
                        RegExp regExp = RegExp(r"^(100(\.00?)?|[1-9]?\d(\.\d{1,2})?)$");
                        bool match = regExp.hasMatch(value.trim());

                        if(match)
                        {
                          gstVerification = true;
                          gstMssgColor = Colors.green;
                          gstMssg = "";
                        }
                        else
                        {
                          gstVerification = false;
                          gstMssgColor = Colors.red;
                          gstMssg = "GST rate must be between 0 and 100, with up to two decimal places";
                        }
                      }
                      setState(() {

                      });
                    },
                    true,
                    5,
                    "GST"
                ),
                if(this.selectedOptionalField.contains("GST")) SizedBox(height: 5),
                if(this.selectedOptionalField.contains("GST")) Padding(
                  padding: const EdgeInsets.only(left: 35.0,right: 35.0),
                  child: Text(
                    gstMssg,
                    style: TextStyle(
                      color: gstMssgColor,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.height * 0.018,
                    ),
                  ),
                ),
                if(this.selectedOptionalField.contains("GST")) SizedBox(height: 20),

                //Category Field
                if(this.selectedOptionalField.contains("Category")) inputFieldWidget.NormalInputFieldWithOnChange(
                    context,
                    category,
                    "E.g, Stationary",
                    Icon(Icons.category),
                    TextInputType.text,
                    Icon(Icons.verified_user, color: categoryMssgColor,),
                        (value)
                    {
                      if(value.isEmpty)
                      {
                        categoryVerification = false;
                        categoryMssgColor = Colors.red;
                        categoryMssg = "Field is required";
                      }
                      else
                      {
                        RegExp regExp = RegExp(r"^[a-zA-Z ]{4,}$");
                        bool match = regExp.hasMatch(value.trim());

                        if(match)
                        {
                          categoryVerification = true;
                          categoryMssgColor = Colors.green;
                          categoryMssg = "";
                        }
                        else
                        {
                          categoryVerification = false;
                          categoryMssgColor = Colors.red;
                          categoryMssg = "Category must contain at least 4 letter";
                        }
                      }
                      setState(() {

                      });
                    },
                    true,
                    20,
                    "Category"
                ),
                if(this.selectedOptionalField.contains("Category")) SizedBox(height: 5),
                if(this.selectedOptionalField.contains("Category")) Padding(
                  padding: const EdgeInsets.only(left: 35.0,right: 35.0),
                  child: Text(
                    categoryMssg,
                    style: TextStyle(
                      color: categoryMssgColor,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.height * 0.018,
                    ),
                  ),
                ),
                if(this.selectedOptionalField.contains("Category")) SizedBox(height: 20),

                //Description
                if(this.selectedOptionalField.contains("Description")) inputFieldWidget.MultilineInputFieldWithOnChange(
                    context,
                    description,
                    "",
                    Icon(Icons.description),
                    TextInputType.text,
                    Icon(Icons.verified_user, color: descriptionMssgColor,),
                        (value)
                    {
                      if(value.isEmpty)
                      {
                        descriptionVerification = false;
                        descriptionMssgColor = Colors.red;
                        descriptionMssg = "Field is required";
                      }
                      else
                      {
                        RegExp regExp = RegExp(r"^[a-zA-Z0-9\s.,!?@#$%^&*()_+=-]{10,}$");

                        bool match = regExp.hasMatch(value.trim());

                        if(match)
                        {
                          descriptionVerification = true;
                          descriptionMssgColor = Colors.green;
                          descriptionMssg = "";
                        }
                        else
                        {
                          descriptionVerification = false;
                          descriptionMssgColor = Colors.red;
                          descriptionMssg = "Description must be at least 10 characters and may include letters, numbers, spaces, and certain symbols";
                        }
                      }
                      setState(() {

                      });
                    },
                    true,
                    100,
                    "Description"
                ),
                if(this.selectedOptionalField.contains("Description")) SizedBox(height: 5),
                if(this.selectedOptionalField.contains("Description")) Padding(
                  padding: const EdgeInsets.only(left: 35.0,right: 35.0),
                  child: Text(
                    descriptionMssg,
                    style: TextStyle(
                      color: descriptionMssgColor,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.height * 0.018,
                    ),
                  ),
                ),
                if(this.selectedOptionalField.contains("Description")) SizedBox(height: 20),

                //Manufacturing Date

                if(this.selectedOptionalField.contains("Manufacturing Date")) inputFieldWidget.DateInputField(
                    context,
                    manufacturingDate,
                    "Manufacturing Date",
                    IconButton(
                      icon: Icon(Icons.edit_calendar),
                      onPressed: () async{

                        DateTime? date = await datePicker.getDate(context, this.manufacturingIntialDate, this.manufacturingFirstdate, this.manufacturingLastDate);

                        if(date.toString().isNotEmpty)
                        {
                          this.manufacturingIntialDate = date!;
                          String finalDate = DateFormat("yyyy-MM-dd").format(date);
                          manufacturingDate.text = finalDate;
                          manufacturingDateVerification = true;
                          manufacturingDateMssgColor = Colors.green;
                          manufacturingDateMssg = "";
                        }
                        else
                        {
                          manufacturingDateVerification = false;
                          manufacturingDateMssgColor = Colors.red;
                          manufacturingDate.text = "";
                          manufacturingDateMssg = "Try again";
                        }

                        setState(() {

                        });
                      },
                    ),
                    "Manufacturing Date"
                ),
                if(this.selectedOptionalField.contains("Manufacturing Date")) SizedBox(height: 5),
                if(this.selectedOptionalField.contains("Manufacturing Date")) Padding(
                  padding: const EdgeInsets.only(left: 35.0,right: 35.0),
                  child: Text(
                    manufacturingDateMssg,
                    style: TextStyle(
                      color: manufacturingDateMssgColor,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.height * 0.018,
                    ),
                  ),
                ),
                if(this.selectedOptionalField.contains("Manufacturing Date")) SizedBox(height: 20),

                //Expiring Date
                if(this.selectedOptionalField.contains("Expiring Date")) inputFieldWidget.DateInputField(
                    context,
                    expiringDate,
                    "Expiring Date",
                    IconButton(
                      icon: Icon(Icons.edit_calendar),
                      onPressed: () async{

                        DateTime? date = await datePicker.getDate(context, this.expiringIntialDate, this.expiringFirstdate, this.expiringLastDate);

                        if(date.toString().isNotEmpty)
                        {
                          this.expiringIntialDate = date!;
                          String finalDate = DateFormat("yyyy-MM-dd").format(date);
                          expiringDate.text = finalDate;
                          expiringDateVerification = true;
                          expiringDateMssgColor = Colors.green;
                          expiringDateMssg = "";
                        }
                        else
                        {
                          expiringDateVerification = false;
                          expiringDateMssgColor = Colors.red;
                          expiringDate.text = "";
                          expiringDateMssg = "Try again";
                        }

                        setState(() {

                        });
                      },
                    ),
                    "Expiring Date"
                ),
                if(this.selectedOptionalField.contains("Expiring Date")) SizedBox(height: 5),
                if(this.selectedOptionalField.contains("Expiring Date")) Padding(
                  padding: const EdgeInsets.only(left: 35.0,right: 35.0),
                  child: Text(
                    expiringDateMssg,
                    style: TextStyle(
                      color: expiringDateMssgColor,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.height * 0.018,
                    ),
                  ),
                ),
                if(this.selectedOptionalField.contains("Expiring Date")) SizedBox(height: 20),

                //Update Button
                buttonWidget.ButtonField(
                    context,
                    "Update",
                     () async
                    {
                      String productName = "";
                      String buyingPrice = "";
                      String sellingprice = "";
                      String barcodeNumber = "";
                      String quantity = "";
                      String discount = "";
                      String size = "";
                      String colour = "";
                      String gst = "";
                      String category = "";
                      String description = "";
                      String manufacturingDate = "";
                      String expiringDate = "";

                      bool optionalFieldVerification = false;
                      bool flag = false;


                      if(this.selectedOptionalField.isEmpty)
                      {
                        optionalFieldVerification = true;
                      }
                      else
                      {
                        for(String s in this.selectedOptionalField)
                        {
                          switch(s)
                          {
                            case "Discount":
                              if(this.discountVerification)
                              {
                                optionalFieldVerification = true;
                                flag = false;
                              }
                              else
                              {
                                optionalFieldVerification = false;
                                flag = true;
                              }
                              break;
                            case "Size":
                              if(this.sizeVerification)
                              {
                                optionalFieldVerification = true;
                                flag = false;
                              }
                              else
                              {
                                optionalFieldVerification = false;
                                flag = true;
                              }
                              break;
                            case "Colour":
                              if(this.colourVerification)
                              {
                                optionalFieldVerification = true;
                                flag = false;
                              }
                              else
                              {
                                optionalFieldVerification = false;
                                flag = true;
                              }
                              break;
                            case "GST":
                              if(this.gstVerification)
                              {
                                optionalFieldVerification = true;
                                flag = false;
                              }
                              else
                              {
                                optionalFieldVerification = false;
                                flag = true;
                              }
                              break;
                            case "Category":
                              if(this.categoryVerification)
                              {
                                optionalFieldVerification = true;
                                flag = false;
                              }
                              else
                              {
                                optionalFieldVerification = false;
                                flag = true;
                              }
                              break;
                            case "Description":
                              if(this.descriptionVerification)
                              {
                                optionalFieldVerification = true;
                                flag = false;
                              }
                              else
                              {
                                optionalFieldVerification = false;
                                flag = true;
                              }
                              break;
                            case "Manufacturing Date":
                              if(this.manufacturingDateVerification)
                              {
                                optionalFieldVerification = true;
                                flag = false;
                              }
                              else
                              {
                                optionalFieldVerification = false;
                                flag = true;
                              }
                              break;
                            case "Expiring Date":
                              if(this.expiringDateVerification)
                              {
                                optionalFieldVerification = true;
                                flag = false;
                              }
                              else
                              {
                                optionalFieldVerification = false;
                                flag = true;
                              }
                              break;
                            default:
                              optionalFieldVerification = false;
                              flag = false;
                          }
                          if(flag)
                          {
                            break;
                          }
                        }
                      }

                      if(this.productNameVerification && this.buyingPriceVerification && this.sellingPriceVerification
                          && this.barcodeNumberVerification && this.quantityVerification && optionalFieldVerification)
                      {
                        //Further Logic
                        productName = this.productName.text.toString().trim();
                        buyingPrice = this.buyingPrice.text.toString().trim();
                        sellingprice = this.sellingPrice.text.toString().trim();

                        if(double.parse(buyingPrice)>=double.parse(sellingprice))
                        {
                          this.toastWidget.showToast("Invalid Buying and Selling Amount");
                        }
                        else
                        {
                          barcodeNumber = this.barcodeNumber.text.toString().trim();
                          quantity = this.quantity.text.toString().trim();

                          bool discountFlag = false;
                          if(this.selectedOptionalField.contains("Discount"))
                          {
                            double finalAmount = double.parse(sellingprice) - (double.parse(sellingprice) * (double.parse(this.discount.text.toString().trim()) / 100));
                            if(double.parse(buyingPrice)>=finalAmount)
                            {
                              discountFlag = true;
                            }
                            else
                            {
                              discountFlag = false;
                            }
                          }
                          if(discountFlag)
                          {
                            this.toastWidget.showToast("Invalid Discount Percentage");
                          }
                          else
                          {
                            discount = this.discount.text.toString().trim();
                            //["Discount","Size", "Colour", "GST", "Category", "Description", "Manufacturing Date", "Expiring Date"]
                            Map<String, String> optionalFieldValue = {};

                            for(String s in this.selectedOptionalField)
                            {
                              switch(s)
                              {
                                case "Discount":
                                  optionalFieldValue["Discount"] = discount;
                                  break;
                                case "Size":
                                  size = this.size.text.toString().trim();
                                  optionalFieldValue["Size"] = size;
                                  break;
                                case "Colour":
                                  colour = this.colour.text.toString().trim();
                                  optionalFieldValue["Colour"] = colour;
                                  break;
                                case "GST":
                                  gst = this.gst.text.toString().trim();
                                  optionalFieldValue["GST"] = gst;
                                  break;
                                case "Category":
                                  category = this.category.text.toString().trim();
                                  optionalFieldValue["Category"] = category;
                                  break;
                                case "Description":
                                  description = this.description.text.toString().trim();
                                  optionalFieldValue["Description"] = description;
                                  break;
                                case "Manufacturing Date":
                                  manufacturingDate = this.manufacturingDate.text.toString().trim();
                                  optionalFieldValue["Manufacturing Date"] = manufacturingDate;
                                  break;
                                case "Expiring Date":
                                  expiringDate = this.expiringDate.text.toString().trim();
                                  optionalFieldValue["Expiring Date"] = expiringDate;
                                  break;
                                default:
                                  break;
                              }
                            }

                            double finalPrice = 0.0;

                            if(this.selectedOptionalField.contains("Discount") && this.selectedOptionalField.contains("GST"))
                            {
                              finalPrice = double.parse(sellingprice) - (double.parse(sellingprice) * (double.parse(this.discount.text.toString().trim()) / 100));
                              finalPrice = finalPrice + (finalPrice * (double.parse(this.gst.text.toString().trim()) / 100));
                            }
                            else if(this.selectedOptionalField.contains("Discount") && !this.selectedOptionalField.contains("GST"))
                            {
                              finalPrice = double.parse(sellingprice) - (double.parse(sellingprice) * (double.parse(this.discount.text.toString().trim()) / 100));
                            }
                            else if(!this.selectedOptionalField.contains("Discount") && this.selectedOptionalField.contains("GST"))
                            {
                              finalPrice = double.parse(sellingprice) + (double.parse(sellingprice) * (double.parse(this.gst.text.toString().trim()) / 100));
                            }
                            else
                            {
                              finalPrice = double.parse(sellingprice);
                            }

                            try
                            {
                              Map<String, dynamic> data = {
                                "productname" : productName,
                                "buyingprice" : buyingPrice,
                                "sellingprice" : sellingprice,
                                "quantity" : quantity,
                                "finalprice" : finalPrice.toStringAsFixed(2),
                                "optionalField" : selectedOptionalField,
                                "optionalFieldValue" : optionalFieldValue,
                                "updatedby" : "Admin",
                              };

                              QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("product")
                                  .where("ownerid",isEqualTo: this.ownerId)
                                  .where("shopid",isEqualTo: this.shopId)
                                  .where("productid", isEqualTo: this.productId)
                                  .get();
                              if(snapshot.docs.isNotEmpty)
                              {
                                var document = snapshot.docs.first.reference;

                                await document.update(data);

                                await Future.delayed(Duration(milliseconds: 300));
                                toastWidget.showToast("Updated");
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context)=>ShopOwnerManageProductScreen()
                                    )
                                );
                              }
                              else
                              {
                                await Future.delayed(Duration(milliseconds: 300));
                                toastWidget.showToast("Try Again");
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context)=>ShopOwnerManageProductScreen()
                                    )
                                );
                              }
                            }
                            catch(e)
                            {
                              await Future.delayed(Duration(milliseconds: 300));
                              this.toastWidget.showToast("Try again");
                            }
                          }
                        }
                      }
                      else
                      {
                        await Future.delayed(Duration(milliseconds: 300));
                        this.toastWidget.showToast("Invalid Credential");
                      }
                      setState(() {

                      });
                    }
                ),
                SizedBox(height: 30),

              ],
            ),
          ),
        ),
      ),
    );
  }
}