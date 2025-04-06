import 'package:barcode_based_billing_system/screens/shop_owner/shop_owner_home_screen.dart';
import 'package:barcode_based_billing_system/widgets/custom_input_field_widget.dart';
import 'package:barcode_based_billing_system/widgets/custom_toast_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DataOfYearSalesBarChart
{
  final String month;
  final double sales;
  DataOfYearSalesBarChart(this.month, this.sales);
}
class DataOfMonthTransactionSalesPieChart
{
  final String paymentType;
  final double sales;
  DataOfMonthTransactionSalesPieChart(this.paymentType, this.sales);
}
class DataOfMonthTransactionByAttributePieChart
{
  final String attributeType;
  final double sales;
  DataOfMonthTransactionByAttributePieChart(this.attributeType, this.sales);
}
class DataOfCompareMonthlySales
{
  final int day;
  final double sales;
  DataOfCompareMonthlySales(this.day, this.sales);
}
class DataOfYearSalesBarChartByPaymentType
{
  final String x;
  final double debitCard;
  final double creditCard;
  final double upi;
  final double cash;
  final double netBanking;

  DataOfYearSalesBarChartByPaymentType({
    required this.x,
    required this.debitCard,
    required this.creditCard,
    required this.upi,
    required this.cash,
    required this.netBanking,
  });
}


class ShopOwnerSalesInsightsManageScreen extends StatefulWidget
{
  @override
  State<StatefulWidget> createState()
  {
    return ShopOwnerSalesInsightsManageScreenState();
  }
}

class ShopOwnerSalesInsightsManageScreenState extends State<ShopOwnerSalesInsightsManageScreen>
{
  CustomInputFieldWidget inputFieldWidget = CustomInputFieldWidget();
  CustomToastWidget toastWidget = CustomToastWidget();

  late Stream<QuerySnapshot> billStream;
  late Stream<QuerySnapshot> selectShopStream;

  String username = "";
  String selectedShop = "";

  bool shopFetch = false;
  bool shopFetchError = false;

  String selectedYearOfYearSalesBarChart = "";
  List<String> availableYearOfYearSalesBarChart = [];
  Map<int, double> monthlySalesYearSalesBarChart = {};

  String selectedYearOfMonthTransactionSalesPieChart = "";
  String selectedMonthOfMonthTransactionSalesPieChart = "";
  List<String> availableYearOfMonthTransactionSalesPieChart = [];
  List<String> availableMonthOfMonthTransactionSalesPieChart = [];
  Map<String,List<String>> availablePeriodOfMonthTransactionSalesPieChart = {};
  Map<String, double> salesOfMonthTransactionSalesPieChart = {};

  String selectedYearOfMonthTransactionByAttributePieChart = "";
  String selectedMonthOfMonthTransactionByAttributePieChart = "";
  List<String> availableYearOfMonthTransactionByAttributePieChart = [];
  List<String> availableMonthOfMonthTransactionByAttributePieChart = [];
  Map<String,List<String>> availablePeriodOfMonthTransactionByAttributePieChart = {};
  Map<String, double> salesOfMonthTransactionByAttributePieChart = {};

  String selectedFirstYearOfCompareMonthlySales = "";
  String selectedFirstMonthOfCompareMonthlySales = "";
  String selectedSecondYearOfCompareMonthlySales = "";
  String selectedSecondMonthOfCompareMonthlySales = "";
  List<String> availableYearOfCompareMonthlySales = [];
  List<String> availableMonthOfCompareMonthlySales = [];
  Map<String,List<String>> availablePeriodOfCompareMonthlySales = {};
  Map<int, double> salesOfFirstMonthCompareMonthlySales = {};
  Map<int, double> salesOfSecondMonthCompareMonthlySales = {};

  String selectedYearOfYearSalesBarChartByPaymentType = "";
  List<String> availableYearOfYearSalesBarChartByPaymentType = [];
  Map<int, Map<String, double>> monthlySalesYearSalesBarChartByPaymentType = {};

  Future<void> _fetchBill() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username') ?? '';

    if (username.isNotEmpty)
    {
      setState(() {
        this.username = username;
        this.billStream = FirebaseFirestore.instance
            .collection('invoice')
            .where('ownerid', isEqualTo: username)
            .snapshots();
      });
    }
  }

  Future<void> _fetchSelectedShops() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String select = prefs.getString("salesInsightsSelectedShop") ?? "";
    String username = prefs.getString("username") ?? "";
    if(select.isNotEmpty)
    {
      setState(() {
        this.selectedShop = select;
        this.username = username;
      });
    }
    print(this.selectedShop.toString());
  }

  Future<void> _fetchShop() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.username = prefs.getString("username") ?? "";

    if(this.username.isNotEmpty)
    {
      setState(() {
        this.selectShopStream = FirebaseFirestore.instance
            .collection('shop')
            .where('ownerid', isEqualTo: username)
            .snapshots();
      });
    }
  }

  void _processBillDataOfYearSalesBarChart(QuerySnapshot snapshot)
  {
    Set<String> years = {};
    Map<int, double> salesMap = {for (int i = 1; i <= 12; i++) i: 0.0};

    for (var doc in snapshot.docs)
    {
      var data = doc.data() as Map<String, dynamic>;

      if (data.containsKey('date') && data.containsKey('totalamount') && data['shopid']==selectedShop)
      {
        DateFormat format = DateFormat("dd-MM-yyyy");
        DateTime date = format.parse(data['date']);
        double totalAmount = double.parse(data['totalamount']);

        years.add(date.year.toString());

        if (selectedYearOfYearSalesBarChart.isNotEmpty && date.year.toString() == selectedYearOfYearSalesBarChart)
        {
          salesMap[date.month] = salesMap[date.month]! + totalAmount;
        }
      }
    }
    this.availableYearOfYearSalesBarChart = years.toList();
    this.monthlySalesYearSalesBarChart = salesMap;
  }

  Widget buildYearSalesBarChart()
  {
    List<DataOfYearSalesBarChart> chartData = monthlySalesYearSalesBarChart.entries
        .map((entry) => DataOfYearSalesBarChart(
      DateFormat('MMM').format(DateTime(0, entry.key)),
      entry.value,
    )).toList();

    return SfCartesianChart(
      primaryXAxis: CategoryAxis(
      ),
      primaryYAxis: NumericAxis(
        title: AxisTitle(text: 'Sales Amount'),
      ),
      title: ChartTitle(text: 'Monthly Sales ($selectedYearOfYearSalesBarChart)'),
      legend: Legend(
        isVisible: false,
      ),
      tooltipBehavior: TooltipBehavior(
        enable: true,
      ),
      series: <BarSeries<DataOfYearSalesBarChart, String>>[
        BarSeries<DataOfYearSalesBarChart, String>(
          dataSource: chartData,
          xValueMapper: (DataOfYearSalesBarChart sales, _) => sales.month,
          yValueMapper: (DataOfYearSalesBarChart sales, _) => sales.sales,
          dataLabelSettings: DataLabelSettings(isVisible: true),
          color: Theme.of(context).primaryColor,
        ),
      ],
    );
  }

  void _processBillDataOfMonthTransactionSalesPieChart(QuerySnapshot snapshot)
  {
    Set<String> years = {};
    Set<String> months = {};
    Map<String,List<String>> year = {};
    Map<String, double> paymentTypeTotals = {
      'Debit Card': 0.0,
      'Credit Card': 0.0,
      'UPI': 0.0,
      'Cash': 0.0,
      'Net Banking': 0.0,
    };

    for (var doc in snapshot.docs)
    {
      var data = doc.data() as Map<String, dynamic>;

      if (data.containsKey('date') && data.containsKey('totalamount') && data.containsKey('paymenttype') && data['shopid']==selectedShop)
      {
        DateFormat format = DateFormat("dd-MM-yyyy");
        DateFormat monthFormat = DateFormat("MMM");
        DateTime date = format.parse(data['date']);
        double totalAmount = double.parse(data['totalamount']);
        String paymentType = data['paymenttype'];

        years.add(date.year.toString());
        months.add(monthFormat.format(date));

        if(!year.containsKey(date.year.toString()))
        {
          year[date.year.toString()] = [monthFormat.format(date)];
        }
        else
        {
          if(!year[date.year.toString()]!.contains(monthFormat.format(date)))
          {
            year[date.year.toString()]!.add(monthFormat.format(date));
          }
        }

        if (selectedYearOfMonthTransactionSalesPieChart.isNotEmpty && selectedMonthOfMonthTransactionSalesPieChart.isNotEmpty
            && date.year.toString() == selectedYearOfMonthTransactionSalesPieChart
            && monthFormat.format(date) == selectedMonthOfMonthTransactionSalesPieChart)
        {
          paymentTypeTotals[paymentType] = paymentTypeTotals[paymentType]! + totalAmount;
        }
      }
    }
    this.availableYearOfMonthTransactionSalesPieChart = years.toList();
    this.availableMonthOfMonthTransactionSalesPieChart = months.toList();
    this.salesOfMonthTransactionSalesPieChart = paymentTypeTotals;
    this.availablePeriodOfMonthTransactionSalesPieChart = year;
  }

  Widget buildMonthTransactionSalesPieChart()
  {
    List<DataOfMonthTransactionSalesPieChart> chartData = salesOfMonthTransactionSalesPieChart.entries
        .map((entry) => DataOfMonthTransactionSalesPieChart(
      entry.key, entry.value,
    )).toList();

    return SfCircularChart(
      title: ChartTitle(text: 'Total Monthly Sales by Payment Type'),
      legend: Legend(
        isVisible: true,
        position: LegendPosition.top,
        overflowMode: LegendItemOverflowMode.wrap,
      ),
      series: <CircularSeries>[
        PieSeries<DataOfMonthTransactionSalesPieChart, String>(
          dataSource: chartData,
          xValueMapper: (DataOfMonthTransactionSalesPieChart data, _) => data.paymentType,
          yValueMapper: (DataOfMonthTransactionSalesPieChart data, _) => data.sales,
          dataLabelSettings: DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }

  void _processBillDataOfCompareMonthlySales(QuerySnapshot snapshot)
  {
    Set<String> years = {};
    Set<String> months = {};
    Map<String,List<String>> year = {};
    Map<int, double> firstSales = {};
    Map<int, double> secondSales = {};

    for (var doc in snapshot.docs)
    {
      var data = doc.data() as Map<String, dynamic>;

      if (data.containsKey('date') && data.containsKey('totalamount') && data['shopid']==selectedShop)
      {
        DateFormat format = DateFormat("dd-MM-yyyy");
        DateFormat monthFormat = DateFormat("MMM");
        DateTime date = format.parse(data['date']);
        double totalAmount = double.parse(data['totalamount']);

        years.add(date.year.toString());
        months.add(monthFormat.format(date));

        if(!year.containsKey(date.year.toString()))
        {
          year[date.year.toString()] = [monthFormat.format(date)];
        }
        else
        {
          if(!year[date.year.toString()]!.contains(monthFormat.format(date)))
          {
            year[date.year.toString()]!.add(monthFormat.format(date));
          }
        }

        if (selectedFirstYearOfCompareMonthlySales.isNotEmpty && selectedFirstMonthOfCompareMonthlySales.isNotEmpty
            && date.year.toString() == selectedFirstYearOfCompareMonthlySales
            && monthFormat.format(date) == selectedFirstMonthOfCompareMonthlySales)
        {
          firstSales[date.day] = (firstSales[date.day] ?? 0) + totalAmount;
        }

        if (selectedSecondYearOfCompareMonthlySales.isNotEmpty && selectedSecondMonthOfCompareMonthlySales.isNotEmpty
            && date.year.toString() == selectedSecondYearOfCompareMonthlySales
            && monthFormat.format(date) == selectedSecondMonthOfCompareMonthlySales)
        {
          secondSales[date.day] = (secondSales[date.day] ?? 0) + totalAmount;
        }
      }
    }

    // **Sort the sales data by day**
    firstSales = Map.fromEntries(firstSales.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));
    secondSales = Map.fromEntries(secondSales.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));

    this.availableYearOfCompareMonthlySales = years.toList();
    this.availableMonthOfCompareMonthlySales = months.toList();
    this.salesOfFirstMonthCompareMonthlySales = firstSales;
    this.salesOfSecondMonthCompareMonthlySales = secondSales;
    this.availablePeriodOfCompareMonthlySales = year;
  }

  Widget buildCompareMonthlySales()
  {
    List<DataOfCompareMonthlySales> firstMonthChartData = salesOfFirstMonthCompareMonthlySales.entries
        .map((entry) => DataOfCompareMonthlySales(
      entry.key, entry.value,
    )).toList();

    List<DataOfCompareMonthlySales> secondMonthChartData = salesOfSecondMonthCompareMonthlySales.entries
        .map((entry) => DataOfCompareMonthlySales(
      entry.key, entry.value,
    )).toList();

    double dataLength = 0;

    if(firstMonthChartData.last.day>secondMonthChartData.last.day)
    {
      dataLength = double.parse(firstMonthChartData.last.day.toString());
    }
    else if(firstMonthChartData.last.day<secondMonthChartData.last.day)
    {
      dataLength = double.parse(secondMonthChartData.last.day.toString());
    }
    else
    {
      dataLength = 31;
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: 31 * 30,
        child: SfCartesianChart(
          primaryXAxis: NumericAxis(
            title: AxisTitle(text: 'Day'),
            interval: 1,
            minimum: 1,
            maximum: 31,
          ),
          primaryYAxis: NumericAxis(
            title: AxisTitle(text: 'Sales Amount'),
          ),
          legend: Legend(isVisible: true),
          series: <LineSeries<DataOfCompareMonthlySales, int>>[
            LineSeries<DataOfCompareMonthlySales, int>(
              name: selectedFirstMonthOfCompareMonthlySales,
              dataSource: firstMonthChartData,
              xValueMapper: (DataOfCompareMonthlySales data, _) => data.day,
              yValueMapper: (DataOfCompareMonthlySales data, _) => data.sales,
              dataLabelSettings: DataLabelSettings(isVisible: false),
            ),
            LineSeries<DataOfCompareMonthlySales, int>(
              name: selectedSecondMonthOfCompareMonthlySales,
              dataSource: secondMonthChartData,
              xValueMapper: (DataOfCompareMonthlySales data, _) => data.day,
              yValueMapper: (DataOfCompareMonthlySales data, _) => data.sales,
              dataLabelSettings: DataLabelSettings(isVisible: false),
            ),
          ],
        ),
      ),
    );
  }

  void _processBillDataOfYearSalesBarChartByPaymentType(QuerySnapshot snapshot)
  {
    Set<String> years = {};
    Map<int, Map<String, double>> salesMap = {
      for (int i = 1; i <= 12; i++)
        i: {
          'Debit Card': 0.0,
          'Credit Card': 0.0,
          'UPI': 0.0,
          'Cash': 0.0,
          'Net Banking': 0.0,
        }
    };

    for (var doc in snapshot.docs)
    {
      var data = doc.data() as Map<String, dynamic>;

      if (data.containsKey('date') && data.containsKey('totalamount') && data.containsKey('paymenttype') && data['shopid']==selectedShop)
      {
        DateFormat format = DateFormat("dd-MM-yyyy");
        DateTime date = format.parse(data['date']);
        double totalAmount = double.parse(data['totalamount']);
        String paymentType = data['paymenttype'];

        years.add(date.year.toString());

        if (selectedYearOfYearSalesBarChart.isNotEmpty && date.year.toString() == selectedYearOfYearSalesBarChart)
        {
          salesMap[date.month]![paymentType] = salesMap[date.month]![paymentType]! + totalAmount;
        }
      }
    }
    this.availableYearOfYearSalesBarChartByPaymentType = years.toList();
    this.monthlySalesYearSalesBarChartByPaymentType = salesMap;
  }

  Widget buildYearSalesBarChartByPaymentType()
  {
    List<DataOfYearSalesBarChartByPaymentType> chartData = monthlySalesYearSalesBarChartByPaymentType.entries.map((entry) {
      int month = entry.key;
      Map<String, double> sales = entry.value;

      return DataOfYearSalesBarChartByPaymentType(
        x: DateFormat.MMM().format(DateTime(0, month)),
        debitCard: sales['Debit Card'] ?? 0.0,
        creditCard: sales['Credit Card'] ?? 0.0,
        upi: sales['UPI'] ?? 0.0,
        cash: sales['Cash'] ?? 0.0,
        netBanking: sales['Net Banking'] ?? 0.0,
      );
    }).toList();

    return SfCartesianChart(
      plotAreaBorderWidth: 1,
      title: ChartTitle(text: 'Monthly Sales by Payment Type'),
      legend: Legend(isVisible: true),
      primaryXAxis: CategoryAxis(
        title: AxisTitle(text: 'Months'),
        labelPlacement: LabelPlacement.onTicks,
        interval: 1,
      ),
      primaryYAxis: NumericAxis(
        title: AxisTitle(text: 'Sales Amount'),
        axisLine: AxisLine(width: 0),
        labelFormat: '{value}',
        majorTickLines: MajorTickLines(size: 0),
      ),
      series: <StackedBarSeries<DataOfYearSalesBarChartByPaymentType, String>>[
        StackedBarSeries<DataOfYearSalesBarChartByPaymentType, String>(
          dataSource: chartData,
          xValueMapper: (DataOfYearSalesBarChartByPaymentType data, int index) => data.x,
          yValueMapper: (DataOfYearSalesBarChartByPaymentType data, int index) => data.debitCard,
          name: 'Debit Card',
        ),
        StackedBarSeries<DataOfYearSalesBarChartByPaymentType, String>(
          dataSource: chartData,
          xValueMapper: (DataOfYearSalesBarChartByPaymentType data, int index) => data.x,
          yValueMapper: (DataOfYearSalesBarChartByPaymentType data, int index) => data.creditCard,
          name: 'Credit Card',
        ),
        StackedBarSeries<DataOfYearSalesBarChartByPaymentType, String>(
          dataSource: chartData,
          xValueMapper: (DataOfYearSalesBarChartByPaymentType data, int index) => data.x,
          yValueMapper: (DataOfYearSalesBarChartByPaymentType data, int index) => data.upi,
          name: 'UPI',
        ),
        StackedBarSeries<DataOfYearSalesBarChartByPaymentType, String>(
          dataSource: chartData,
          xValueMapper: (DataOfYearSalesBarChartByPaymentType data, int index) => data.x,
          yValueMapper: (DataOfYearSalesBarChartByPaymentType data, int index) => data.cash,
          name: 'Cash',
        ),
        StackedBarSeries<DataOfYearSalesBarChartByPaymentType, String>(
          dataSource: chartData,
          xValueMapper: (DataOfYearSalesBarChartByPaymentType data, int index) => data.x,
          yValueMapper: (DataOfYearSalesBarChartByPaymentType data, int index) => data.netBanking,
          name: 'Net Banking',
        ),
      ],
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  void _processBillDataOfMonthTransactionByAttributePieChart(QuerySnapshot snapshot)
  {
    Set<String> years = {};
    Set<String> months = {};
    Map<String,List<String>> year = {};
    Map<String, double> attributeTypeTotals = {
      'Buying Price': 0.0,
      'Selling Price': 0.0,
      'Discount': 0.0,
      'GST': 0.0,
      'Extra Charges': 0.0,
      'Extra Discount': 0.0
    };

    for (var doc in snapshot.docs)
    {
      var data = doc.data() as Map<String, dynamic>;

      if (data.containsKey('date') && data.containsKey('totalamount') && data['shopid']==selectedShop
      && data.containsKey('productDetail') && data.containsKey('extracharges') && data.containsKey('extradiscount'))
      {
        DateFormat format = DateFormat("dd-MM-yyyy");
        DateFormat monthFormat = DateFormat("MMM");
        DateTime date = format.parse(data['date']);
        double totalAmount = double.parse(data['totalamount']);
        double extraCharges = double.parse(data['extracharges']);
        double extraDiscount = double.parse(data['extradiscount']);
        Map<String, dynamic> productDetails = Map<String, dynamic>.from(data['productDetail']);
        
        double buyingPrice = 0;
        double sellingPrice = 0;
        double discount = 0;
        double gst = 0;

        for(var barcode in productDetails.keys)
        {
          Map<String, dynamic> product = Map<String, dynamic>.from(productDetails[barcode]!);

          int quantity = int.parse(product['itemquantity'].toString());

          buyingPrice = buyingPrice + (double.parse(product['buyingprice'].toString()))*quantity;
          sellingPrice = sellingPrice + (double.parse(product['sellingprice'].toString()))*quantity;
          discount = discount + ((double.parse(product['sellingprice'].toString())*double.parse(product['discount'].toString()))/100)*quantity;
          gst = gst + (((double.parse(product['sellingprice'].toString())-(double.parse(product['sellingprice'].toString())*double.parse(product['discount'].toString()))/100)
                        * double.parse(product['gst'].toString()))/100)*quantity;

        }

        years.add(date.year.toString());
        months.add(monthFormat.format(date));

        if(!year.containsKey(date.year.toString()))
        {
          year[date.year.toString()] = [monthFormat.format(date)];
        }
        else
        {
          if(!year[date.year.toString()]!.contains(monthFormat.format(date)))
          {
            year[date.year.toString()]!.add(monthFormat.format(date));
          }
        }

        if (selectedYearOfMonthTransactionByAttributePieChart.isNotEmpty && selectedMonthOfMonthTransactionByAttributePieChart.isNotEmpty
            && date.year.toString() == selectedYearOfMonthTransactionByAttributePieChart
            && monthFormat.format(date) == selectedMonthOfMonthTransactionByAttributePieChart)
        {
          attributeTypeTotals['Buying Price'] = attributeTypeTotals['Buying Price']! + buyingPrice;
          attributeTypeTotals['Selling Price'] = attributeTypeTotals['Selling Price']! + sellingPrice;
          attributeTypeTotals['Discount'] = attributeTypeTotals['Discount']! + discount;
          attributeTypeTotals['GST'] = attributeTypeTotals['GST']! + gst;
          attributeTypeTotals['Extra Charges'] = attributeTypeTotals['Extra Charges']! + extraCharges;
          attributeTypeTotals['Extra Discount'] = attributeTypeTotals['Extra Discount']! + extraDiscount;
        }
      }
    }
    this.availableYearOfMonthTransactionByAttributePieChart = years.toList();
    this.availableMonthOfMonthTransactionByAttributePieChart = months.toList();
    this.salesOfMonthTransactionByAttributePieChart = attributeTypeTotals;
    this.availablePeriodOfMonthTransactionByAttributePieChart = year;
  }

  Widget buildMonthTransactionByAttributePieChart()
  {
    List<DataOfMonthTransactionByAttributePieChart> chartData = salesOfMonthTransactionByAttributePieChart.entries
        .map((entry) => DataOfMonthTransactionByAttributePieChart(
      entry.key, entry.value,
    )).toList();

    return SfCircularChart(
      title: ChartTitle(text: 'Total Monthly Sales by Attributes'),
      legend: Legend(
        isVisible: true,
        position: LegendPosition.top,
        overflowMode: LegendItemOverflowMode.wrap,
      ),
      series: <CircularSeries>[
        PieSeries<DataOfMonthTransactionByAttributePieChart, String>(
          dataSource: chartData,
          xValueMapper: (DataOfMonthTransactionByAttributePieChart data, _) => data.attributeType,
          yValueMapper: (DataOfMonthTransactionByAttributePieChart data, _) => data.sales,
          dataLabelSettings: DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }

  @override
  void initState()
  {
    super.initState();
    _fetchSelectedShops();
    _fetchShop();
    _fetchBill();
  }

  @override
  Widget build(BuildContext context)
  {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Sales Insights",
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

        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              SizedBox(height: 10),

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
                              prefs.setString("salesInsightsSelectedShop", this.selectedShop);
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
              SizedBox(height: 15),

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

              //Top 10 Product Sales
              if(this.selectedShop.isNotEmpty)
                Card(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  elevation: 6,
                  color: Colors.white,
                  shadowColor: Colors.grey.shade300,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: StreamBuilder<QuerySnapshot>(
                        stream: billStream,
                        builder: (context, snapshot){
                          if (snapshot.connectionState == ConnectionState.waiting)
                          {
                            return Center(
                              child: CircularProgressIndicator(color: Theme.of(context).cardColor,),
                            );
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
                          else if(snapshot.hasData)
                          {
                            Map<String, int> productSales = {};
                            Map<String, String> productNames = {};

                            for (var doc in snapshot.data!.docs)
                            {
                              Map<String, dynamic> invoice = doc.data() as Map<String, dynamic>;
                              Map<String, dynamic> productDetails = invoice['productDetail'] ?? {};
                              String shop = invoice['shopid'] ?? '';

                              if(shop==this.selectedShop)
                              {
                                for (var barcode in productDetails.keys)
                                {
                                  var productData = productDetails[barcode];

                                  if (productData is Map<String, dynamic>)
                                  {
                                    String productId = productData['productid'] ?? '';
                                    int quantity = int.tryParse(productData['itemquantity'].toString()) ?? 0;
                                    String productName = productData['productname'] ?? '';

                                    if (productId.isNotEmpty && productName.isNotEmpty)
                                    {
                                      productSales.update(productId, (value) => value + quantity, ifAbsent: () => quantity);
                                      productNames.update(productId, (value) => value, ifAbsent: ()=>productName);
                                    }
                                  }
                                }
                              }
                            }

                            List<MapEntry<String, int>> sortedProducts = productSales.entries.toList()
                              ..sort((a, b) => b.value.compareTo(a.value));

                            List<MapEntry<String, int>> productList = sortedProducts.take(10).toList();

                            if(productList.isNotEmpty)
                            {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [

                                  SizedBox(height: 10,),
                                  //Header
                                  Text(
                                    "Top 10 Sold Products",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: MediaQuery.of(context).size.height * 0.025,
                                    ),
                                  ),
                                  SizedBox(height: 10,),

                                  SingleChildScrollView(
                                    child: Container(
                                      height: 300,
                                      child: ListView.builder(
                                        itemCount: productList.length,
                                        itemBuilder: (context, index) {
                                          var product = productList[index];
                                          return ListTile(
                                            leading: CircleAvatar(
                                              backgroundColor: Theme.of(context).cardColor,
                                              child: Text(
                                                "${index + 1}",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: MediaQuery.of(context).size.height * 0.025,
                                                ),
                                              ),
                                            ),
                                            title: Text(
                                              "Product ID: ${product.key}\nProduct Name: ${productNames[product.key]}",
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                            subtitle: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Total Sold: ",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                SizedBox(width: 10,),
                                                Text(
                                                  "${product.value}",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
                            else
                            {
                              return Center(
                                child: Text(
                                  "No data found",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: MediaQuery.of(context).size.height * 0.04,
                                  ),
                                ),
                              );
                            }
                          }
                          else
                          {
                            return Center(
                              child: Text(
                                "No data found",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: MediaQuery.of(context).size.height * 0.04,
                                ),
                              ),
                            );
                          }
                        }
                    ),
                  ),
                ),
              SizedBox(height: 30,),

              //Year Sales Bar Chart
              if(this.selectedShop.isNotEmpty)
                Card(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  elevation: 6,
                  color: Colors.white,
                  shadowColor: Colors.grey.shade300,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: billStream,
                      builder: (context, snapshot) {
                        {
                          if (snapshot.connectionState == ConnectionState.waiting)
                          {
                            return Center(
                              child: CircularProgressIndicator(color: Theme.of(context).cardColor,),
                            );
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
                            _processBillDataOfYearSalesBarChart(snapshot.data!);

                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [

                                //Header
                                Text(
                                  "Year 12 Months Sales",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: MediaQuery.of(context).size.height * 0.025,
                                    color: Colors.black
                                  ),
                                ),

                                //Year Dropdown
                                if(this.availableYearOfYearSalesBarChart.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(left: 25),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: DropdownButton<String>(
                                      value: selectedYearOfYearSalesBarChart.isNotEmpty ? selectedYearOfYearSalesBarChart : null,
                                      hint: Text("Select Year"),
                                      onChanged: (newYear) {
                                        setState(() {
                                          selectedYearOfYearSalesBarChart = newYear!;
                                          _processBillDataOfYearSalesBarChart(snapshot.data!);
                                        });
                                      },
                                      items: availableYearOfYearSalesBarChart.map((year) {
                                        return DropdownMenuItem<String>(
                                          value: year,
                                          child: Text(year),
                                        );
                                      }).toList(),
                                      icon: Icon(Icons.arrow_drop_down, color: Colors.black, size: 30),
                                      style: TextStyle(color: Colors.black, fontSize: 16,),
                                      dropdownColor: Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                if(this.availableYearOfYearSalesBarChart.isNotEmpty)
                                SizedBox(height: 10,),

                                //Bar Chart
                                this.availableYearOfYearSalesBarChart.isNotEmpty
                                ? this.selectedYearOfYearSalesBarChart.isNotEmpty
                                    ? SingleChildScrollView(
                                      child: Container(
                                        width: this.monthlySalesYearSalesBarChart.length * 100,
                                        child: buildYearSalesBarChart(),
                                      ),
                                      scrollDirection: Axis.horizontal,
                                    )
                                    : Center(
                                  child: Text(
                                    "Select the year",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: MediaQuery.of(context).size.height * 0.04,
                                    ),
                                  ),
                                ) : Center(
                                  child: Text(
                                    "No data found",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: MediaQuery.of(context).size.height * 0.04,
                                    ),
                                  ),
                                ),

                              ],
                            );
                          }
                          else
                          {
                            return Center(
                              child: Text(
                                "No data found",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: MediaQuery.of(context).size.height * 0.04,
                                ),
                              ),
                            );
                          }
                        }
                      }
                    ),
                  ),
                ),
              SizedBox(height: 30,),

              //Year Sales Bar Chart by Payment Type
              if(this.selectedShop.isNotEmpty)
                Card(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  elevation: 6,
                  color: Colors.white,
                  shadowColor: Colors.grey.shade300,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: StreamBuilder<QuerySnapshot>(
                        stream: billStream,
                        builder: (context, snapshot) {
                          {
                            if (snapshot.connectionState == ConnectionState.waiting)
                            {
                              return Center(
                                child: CircularProgressIndicator(color: Theme.of(context).cardColor,),
                              );
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
                              _processBillDataOfYearSalesBarChartByPaymentType(snapshot.data!);

                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [

                                  //Header
                                  Text(
                                    "Year 12 Months Sales By Payment Type",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: MediaQuery.of(context).size.height * 0.025,
                                        color: Colors.black
                                    ),
                                  ),

                                  //Year Dropdown
                                  if(this.availableYearOfYearSalesBarChartByPaymentType.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 25),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: DropdownButton<String>(
                                        value: selectedYearOfYearSalesBarChartByPaymentType.isNotEmpty ? selectedYearOfYearSalesBarChartByPaymentType : null,
                                        hint: Text("Select Year"),
                                        onChanged: (newYear) {
                                          setState(() {
                                            selectedYearOfYearSalesBarChartByPaymentType = newYear!;
                                            _processBillDataOfYearSalesBarChartByPaymentType(snapshot.data!);
                                          });
                                        },
                                        items: availableYearOfYearSalesBarChartByPaymentType.map((year) {
                                          return DropdownMenuItem<String>(
                                            value: year,
                                            child: Text(year),
                                          );
                                        }).toList(),
                                        icon: Icon(Icons.arrow_drop_down, color: Colors.black, size: 30),
                                        style: TextStyle(color: Colors.black, fontSize: 16,),
                                        dropdownColor: Theme.of(context).cardColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  if(this.availableYearOfYearSalesBarChartByPaymentType.isNotEmpty)
                                  SizedBox(height: 10,),

                                  //Bar Chart
                                  this.availableYearOfYearSalesBarChartByPaymentType.isNotEmpty
                                      ? this.selectedYearOfYearSalesBarChartByPaymentType.isNotEmpty
                                      ? SingleChildScrollView(
                                    child: Container(
                                      width: this.monthlySalesYearSalesBarChartByPaymentType.length * 100,
                                      child: buildYearSalesBarChartByPaymentType(),
                                    ),
                                    scrollDirection: Axis.horizontal,
                                  )
                                      : Center(
                                    child: Text(
                                      "Select the year",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: MediaQuery.of(context).size.height * 0.04,
                                      ),
                                    ),
                                  ) : Center(
                                    child: Text(
                                      "No data found",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: MediaQuery.of(context).size.height * 0.04,
                                      ),
                                    ),
                                  ),

                                ],
                              );
                            }
                            else
                            {
                              return Center(
                                child: Text(
                                  "No data found",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: MediaQuery.of(context).size.height * 0.04,
                                  ),
                                ),
                              );
                            }
                          }
                        }
                    ),
                  ),
                ),
              SizedBox(height: 30,),

              //Month Transaction Sales PieChart
              if(this.selectedShop.isNotEmpty)
                Card(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  elevation: 6,
                  color: Colors.white,
                  shadowColor: Colors.grey.shade300,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: StreamBuilder<QuerySnapshot>(
                        stream: billStream,
                        builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting)
                            {
                              return Center(
                                child: CircularProgressIndicator(color: Theme.of(context).cardColor,),
                              );
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
                              _processBillDataOfMonthTransactionSalesPieChart(snapshot.data!);

                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [

                                  //Header
                                  Center(
                                    child: Text(
                                      "Monthly Sales by Payment Type",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context).size.height * 0.025,
                                          color: Colors.black
                                      ),
                                    ),
                                  ),

                                  //Year and Month Dropdown
                                  if(this.availableYearOfMonthTransactionSalesPieChart.isNotEmpty && availableMonthOfMonthTransactionSalesPieChart.isNotEmpty
                                  && this.availablePeriodOfMonthTransactionSalesPieChart.isNotEmpty)
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [

                                        //Year
                                        Padding(
                                          padding: const EdgeInsets.only(left: 35),
                                          child: DropdownButton<String>(
                                            value: selectedYearOfMonthTransactionSalesPieChart.isNotEmpty ? selectedYearOfMonthTransactionSalesPieChart : null,
                                            hint: Text("Select Year"),
                                            onChanged: (newYear) {
                                              setState(() {
                                                selectedMonthOfMonthTransactionSalesPieChart = "";
                                                selectedYearOfMonthTransactionSalesPieChart = newYear!;
                                                _processBillDataOfMonthTransactionSalesPieChart(snapshot.data!);
                                              });
                                            },
                                            items: availablePeriodOfMonthTransactionSalesPieChart.keys.map((year) {
                                              return DropdownMenuItem<String>(
                                                value: year,
                                                child: Text(year),
                                              );
                                            }).toList(),
                                            icon: Icon(Icons.arrow_drop_down, color: Colors.black, size: 30),
                                            style: TextStyle(color: Colors.black, fontSize: 16,),
                                            dropdownColor: Theme.of(context).cardColor,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),

                                        SizedBox(width: 40,),

                                        //Month
                                        if(this.selectedYearOfMonthTransactionSalesPieChart.isNotEmpty)
                                        DropdownButton<String>(
                                          value: selectedMonthOfMonthTransactionSalesPieChart.isNotEmpty ? selectedMonthOfMonthTransactionSalesPieChart : null,
                                          hint: Text("Select Month"),
                                          onChanged: (newMonth) {
                                            setState(() {
                                              selectedMonthOfMonthTransactionSalesPieChart = newMonth!;
                                              _processBillDataOfMonthTransactionSalesPieChart(snapshot.data!);
                                            });
                                          },
                                          items: availablePeriodOfMonthTransactionSalesPieChart[this.selectedYearOfMonthTransactionSalesPieChart]!.map((month) {
                                            return DropdownMenuItem<String>(
                                              value: month,
                                              child: Text(month),
                                            );
                                          }).toList(),
                                          icon: Icon(Icons.arrow_drop_down, color: Colors.black, size: 30),
                                          style: TextStyle(color: Colors.black, fontSize: 16,),
                                          dropdownColor: Theme.of(context).cardColor,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if(this.availableYearOfMonthTransactionSalesPieChart.isNotEmpty && this.availableMonthOfMonthTransactionSalesPieChart.isNotEmpty
                                      && this.availablePeriodOfMonthTransactionSalesPieChart.isNotEmpty)
                                  SizedBox(height: 10,),

                                  //Pie Chart
                                  this.availableYearOfMonthTransactionSalesPieChart.isNotEmpty && this.availableMonthOfMonthTransactionSalesPieChart.isNotEmpty
                                  && this.availablePeriodOfMonthTransactionSalesPieChart.isNotEmpty
                                      ? this.selectedYearOfMonthTransactionSalesPieChart.isNotEmpty && this.selectedMonthOfMonthTransactionSalesPieChart.isNotEmpty
                                      ? Container(
                                        child: buildMonthTransactionSalesPieChart(),
                                    )
                                      : Center(
                                    child: Text(
                                      "Select the year and month",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: MediaQuery.of(context).size.height * 0.04,
                                      ),
                                    ),
                                  ) : Center(
                                    child: Text(
                                      "No data found",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: MediaQuery.of(context).size.height * 0.04,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
                            else
                            {
                              return Center(
                                child: Text(
                                  "No data found",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: MediaQuery.of(context).size.height * 0.04,
                                  ),
                                ),
                              );
                            }
                          }
                    ),
                  ),
                ),
              SizedBox(height: 30,),

              //Month Transaction By Attributes PieChart
              if(this.selectedShop.isNotEmpty)
                Card(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  elevation: 6,
                  color: Colors.white,
                  shadowColor: Colors.grey.shade300,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: StreamBuilder<QuerySnapshot>(
                        stream: billStream,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting)
                          {
                            return Center(
                              child: CircularProgressIndicator(color: Theme.of(context).cardColor,),
                            );
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
                            _processBillDataOfMonthTransactionByAttributePieChart(snapshot.data!);

                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [

                                //Header
                                Center(
                                  child: Text(
                                    "Monthly Sales by Attribute Type",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: MediaQuery.of(context).size.height * 0.025,
                                        color: Colors.black
                                    ),
                                  ),
                                ),

                                //Year and Month Dropdown
                                if(this.availableYearOfMonthTransactionByAttributePieChart.isNotEmpty && availableMonthOfMonthTransactionByAttributePieChart.isNotEmpty
                                    && this.availablePeriodOfMonthTransactionByAttributePieChart.isNotEmpty)
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [

                                        //Year
                                        Padding(
                                          padding: const EdgeInsets.only(left: 35),
                                          child: DropdownButton<String>(
                                            value: selectedYearOfMonthTransactionByAttributePieChart.isNotEmpty ? selectedYearOfMonthTransactionByAttributePieChart : null,
                                            hint: Text("Select Year"),
                                            onChanged: (newYear) {
                                              setState(() {
                                                selectedMonthOfMonthTransactionByAttributePieChart = "";
                                                selectedYearOfMonthTransactionByAttributePieChart = newYear!;
                                                _processBillDataOfMonthTransactionByAttributePieChart(snapshot.data!);
                                              });
                                            },
                                            items: availablePeriodOfMonthTransactionByAttributePieChart.keys.map((year) {
                                              return DropdownMenuItem<String>(
                                                value: year,
                                                child: Text(year),
                                              );
                                            }).toList(),
                                            icon: Icon(Icons.arrow_drop_down, color: Colors.black, size: 30),
                                            style: TextStyle(color: Colors.black, fontSize: 16,),
                                            dropdownColor: Theme.of(context).cardColor,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),

                                        SizedBox(width: 40,),

                                        //Month
                                        if(this.selectedYearOfMonthTransactionByAttributePieChart.isNotEmpty)
                                          DropdownButton<String>(
                                            value: selectedMonthOfMonthTransactionByAttributePieChart.isNotEmpty ? selectedMonthOfMonthTransactionByAttributePieChart : null,
                                            hint: Text("Select Month"),
                                            onChanged: (newMonth) {
                                              setState(() {
                                                selectedMonthOfMonthTransactionByAttributePieChart = newMonth!;
                                                _processBillDataOfMonthTransactionByAttributePieChart(snapshot.data!);
                                              });
                                            },
                                            items: availablePeriodOfMonthTransactionByAttributePieChart[this.selectedYearOfMonthTransactionByAttributePieChart]!.map((month) {
                                              return DropdownMenuItem<String>(
                                                value: month,
                                                child: Text(month),
                                              );
                                            }).toList(),
                                            icon: Icon(Icons.arrow_drop_down, color: Colors.black, size: 30),
                                            style: TextStyle(color: Colors.black, fontSize: 16,),
                                            dropdownColor: Theme.of(context).cardColor,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                      ],
                                    ),
                                  ),
                                if(this.availableYearOfMonthTransactionByAttributePieChart.isNotEmpty && this.availableMonthOfMonthTransactionByAttributePieChart.isNotEmpty
                                    && this.availablePeriodOfMonthTransactionByAttributePieChart.isNotEmpty)
                                  SizedBox(height: 10,),

                                //Pie Chart
                                this.availableYearOfMonthTransactionByAttributePieChart.isNotEmpty && this.availableMonthOfMonthTransactionByAttributePieChart.isNotEmpty
                                    && this.availablePeriodOfMonthTransactionByAttributePieChart.isNotEmpty
                                    ? this.selectedYearOfMonthTransactionByAttributePieChart.isNotEmpty && this.selectedMonthOfMonthTransactionByAttributePieChart.isNotEmpty
                                    ? Container(
                                  child: buildMonthTransactionByAttributePieChart(),
                                )
                                    : Center(
                                  child: Text(
                                    "Select the year and month",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: MediaQuery.of(context).size.height * 0.04,
                                    ),
                                  ),
                                ) : Center(
                                  child: Text(
                                    "No data found",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: MediaQuery.of(context).size.height * 0.04,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                          else
                          {
                            return Center(
                              child: Text(
                                "No data found",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: MediaQuery.of(context).size.height * 0.04,
                                ),
                              ),
                            );
                          }
                        }
                    ),
                  ),
                ),
              SizedBox(height: 30,),

              //Compare Month Sales
              if(this.selectedShop.isNotEmpty)
                Card(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  elevation: 6,
                  color: Colors.white,
                  shadowColor: Colors.grey.shade300,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: StreamBuilder<QuerySnapshot>(
                        stream: billStream,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting)
                          {
                            return Center(
                              child: CircularProgressIndicator(color: Theme.of(context).cardColor,),
                            );
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
                            _processBillDataOfCompareMonthlySales(snapshot.data!);

                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [

                                //Header
                                Center(
                                  child: Text(
                                    "Monthly Sales Compare",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: MediaQuery.of(context).size.height * 0.025,
                                        color: Colors.black
                                    ),
                                  ),
                                ),

                                // First Year and Month Dropdown
                                if(this.availableYearOfCompareMonthlySales.isNotEmpty && this.availableMonthOfCompareMonthlySales.isNotEmpty
                                    && this.availablePeriodOfCompareMonthlySales.isNotEmpty)
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [

                                      //Year
                                      Padding(
                                        padding: const EdgeInsets.only(left: 35),
                                        child: DropdownButton<String>(
                                          value: selectedFirstYearOfCompareMonthlySales.isNotEmpty ? selectedFirstYearOfCompareMonthlySales : null,
                                          hint: Text("Select Year"),
                                          onChanged: (newYear) {
                                            setState(() {
                                              selectedFirstMonthOfCompareMonthlySales = "";
                                              selectedFirstYearOfCompareMonthlySales = newYear!;
                                              _processBillDataOfCompareMonthlySales(snapshot.data!);
                                            });
                                          },
                                          items: availablePeriodOfCompareMonthlySales.keys.map((year) {
                                            return DropdownMenuItem<String>(
                                              value: year,
                                              child: Text(year),
                                            );
                                          }).toList(),
                                          icon: Icon(Icons.arrow_drop_down, color: Colors.black, size: 30),
                                          style: TextStyle(color: Colors.black, fontSize: 16,),
                                          dropdownColor: Theme.of(context).cardColor,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),

                                      SizedBox(width: 40,),

                                      //Month
                                      if(this.selectedFirstYearOfCompareMonthlySales.isNotEmpty)
                                        DropdownButton<String>(
                                          value: selectedFirstMonthOfCompareMonthlySales.isNotEmpty ? selectedFirstMonthOfCompareMonthlySales : null,
                                          hint: Text("Select Month"),
                                          onChanged: (newMonth) {
                                            setState(() {
                                              selectedFirstMonthOfCompareMonthlySales = newMonth!;
                                              _processBillDataOfCompareMonthlySales(snapshot.data!);
                                            });
                                          },
                                          items: availablePeriodOfCompareMonthlySales[this.selectedFirstYearOfCompareMonthlySales]!.map((month) {
                                            return DropdownMenuItem<String>(
                                              value: month,
                                              child: Text(month),
                                            );
                                          }).toList(),
                                          icon: Icon(Icons.arrow_drop_down, color: Colors.black, size: 30),
                                          style: TextStyle(color: Colors.black, fontSize: 16,),
                                          dropdownColor: Theme.of(context).cardColor,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                    ],
                                  ),
                                ),
                                if(this.availableYearOfCompareMonthlySales.isNotEmpty && this.availableMonthOfCompareMonthlySales.isNotEmpty
                                    && this.availablePeriodOfCompareMonthlySales.isNotEmpty)
                                SizedBox(height: 10,),

                                if(this.availableYearOfCompareMonthlySales.isNotEmpty && this.availableMonthOfCompareMonthlySales.isNotEmpty
                                    && this.availablePeriodOfCompareMonthlySales.isNotEmpty)
                                Center(
                                  child: Text(
                                    "Vs",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: MediaQuery.of(context).size.height * 0.025
                                    ),
                                  ),
                                ),
                                if(this.availableYearOfCompareMonthlySales.isNotEmpty && this.availableMonthOfCompareMonthlySales.isNotEmpty
                                    && this.availablePeriodOfCompareMonthlySales.isNotEmpty)
                                SizedBox(height: 10,),

                                // Second Year and Month Dropdown
                                if(this.availableYearOfCompareMonthlySales.isNotEmpty && this.availableMonthOfCompareMonthlySales.isNotEmpty
                                    && this.availablePeriodOfCompareMonthlySales.isNotEmpty)
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [

                                      //Year
                                      Padding(
                                        padding: const EdgeInsets.only(left: 35),
                                        child: DropdownButton<String>(
                                          value: selectedSecondYearOfCompareMonthlySales.isNotEmpty ? selectedSecondYearOfCompareMonthlySales : null,
                                          hint: Text("Select Year"),
                                          onChanged: (newYear) {
                                            setState(() {
                                              selectedSecondMonthOfCompareMonthlySales = "";
                                              selectedSecondYearOfCompareMonthlySales = newYear!;
                                              _processBillDataOfCompareMonthlySales(snapshot.data!);
                                            });
                                          },
                                          items: availablePeriodOfCompareMonthlySales.keys.map((year) {
                                            return DropdownMenuItem<String>(
                                              value: year,
                                              child: Text(year),
                                            );
                                          }).toList(),
                                          icon: Icon(Icons.arrow_drop_down, color: Colors.black, size: 30),
                                          style: TextStyle(color: Colors.black, fontSize: 16,),
                                          dropdownColor: Theme.of(context).cardColor,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),

                                      SizedBox(width: 40,),

                                      //Month
                                      if(this.selectedSecondYearOfCompareMonthlySales.isNotEmpty)
                                        DropdownButton<String>(
                                          value: selectedSecondMonthOfCompareMonthlySales.isNotEmpty ? selectedSecondMonthOfCompareMonthlySales : null,
                                          hint: Text("Select Month"),
                                          onChanged: (newMonth) {
                                            setState(() {
                                              selectedSecondMonthOfCompareMonthlySales = newMonth!;
                                              _processBillDataOfCompareMonthlySales(snapshot.data!);
                                            });
                                          },
                                          items: availablePeriodOfCompareMonthlySales[this.selectedSecondYearOfCompareMonthlySales]!.map((month) {
                                            return DropdownMenuItem<String>(
                                              value: month,
                                              child: Text(month),
                                            );
                                          }).toList(),
                                          icon: Icon(Icons.arrow_drop_down, color: Colors.black, size: 30),
                                          style: TextStyle(color: Colors.black, fontSize: 16,),
                                          dropdownColor: Theme.of(context).cardColor,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                    ],
                                  ),
                                ),
                                if(this.availableYearOfCompareMonthlySales.isNotEmpty && this.availableMonthOfCompareMonthlySales.isNotEmpty
                                    && this.availablePeriodOfCompareMonthlySales.isNotEmpty)
                                SizedBox(height: 10,),

                                //Line Chart
                                this.availableYearOfCompareMonthlySales.isNotEmpty && this.availableMonthOfCompareMonthlySales.isNotEmpty
                                    && this.availablePeriodOfCompareMonthlySales.isNotEmpty
                                    ? this.selectedFirstYearOfCompareMonthlySales.isNotEmpty && this.selectedFirstMonthOfCompareMonthlySales.isNotEmpty
                                      && this.selectedSecondYearOfCompareMonthlySales.isNotEmpty && this.selectedSecondMonthOfCompareMonthlySales.isNotEmpty
                                    ? buildCompareMonthlySales()
                                    : Center(
                                  child: Text(
                                    "Select the year and month",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: MediaQuery.of(context).size.height * 0.04,
                                    ),
                                  ),
                                ) : Center(
                                  child: Text(
                                    "No data found",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: MediaQuery.of(context).size.height * 0.04,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                          else
                          {
                            return Center(
                              child: Text(
                                "No data found",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: MediaQuery.of(context).size.height * 0.04,
                                ),
                              ),
                            );
                          }
                        }
                    ),
                  ),
                ),
              SizedBox(height: 30,),
            ],
          ),
        ),
      ),
    );
  }
}