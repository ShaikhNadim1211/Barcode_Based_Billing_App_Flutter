import 'package:barcode_based_billing_system/screens/shop_owner/customer_insights/shop_owner_customer_insights_manage_screen.dart';
import 'package:barcode_based_billing_system/widgets/custom_toast_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

class ShopOwnerCustomerInsightsDisplayScreen extends StatefulWidget
{
  final String ownerId;
  final String shopId;
  final String customerId;
  final String customerEmail;

  ShopOwnerCustomerInsightsDisplayScreen(this.ownerId, this.shopId, this.customerId, this.customerEmail);

  @override
  State<StatefulWidget> createState()
  {
    return ShopOwnerCustomerInsightsDisplayScreenState();
  }
}

class ShopOwnerCustomerInsightsDisplayScreenState extends State<ShopOwnerCustomerInsightsDisplayScreen>
{
  String ownerId = "";
  String shopId = "";
  String customerId = "";
  String customerEmail = "";

  CustomToastWidget toastWidget = CustomToastWidget();

  late Stream<QuerySnapshot> billStream;

  String selectedYearOfYearSalesBarChart = "";
  List<String> availableYearOfYearSalesBarChart = [];
  Map<int, double> monthlySalesYearSalesBarChart = {};

  String selectedYearOfMonthTransactionSalesPieChart = "";
  String selectedMonthOfMonthTransactionSalesPieChart = "";
  List<String> availableYearOfMonthTransactionSalesPieChart = [];
  List<String> availableMonthOfMonthTransactionSalesPieChart = [];
  Map<String,List<String>> availablePeriodOfMonthTransactionSalesPieChart = {};
  Map<String, double> salesOfMonthTransactionSalesPieChart = {};

  Future<void> _fetchBill() async
  {
    if (widget.ownerId.isNotEmpty && widget.shopId.isNotEmpty && widget.customerId.isNotEmpty && widget.customerEmail.isNotEmpty)
    {
      setState(() {
        this.billStream = FirebaseFirestore.instance
            .collection('invoice')
            .where('ownerid', isEqualTo: widget.ownerId)
            .where('shopid', isEqualTo: widget.shopId)
            .where('customerid', isEqualTo: widget.customerId)
            .where('customeremail', isEqualTo: widget.customerEmail)
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

      if (data.containsKey('date') && data.containsKey('totalamount'))
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

      if (data.containsKey('date') && data.containsKey('totalamount') && data.containsKey('paymenttype'))
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

  @override
  void initState()
  {
    super.initState();
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
            "Customer Sales Insights",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => ShopOwnerCustomerInsightsManageScreen()));
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
              SizedBox(height: 30),

              //Top 10 Product Sales
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

                          List<MapEntry<String, int>> sortedProducts = productSales.entries.toList()
                            ..sort((a, b) => b.value.compareTo(a.value));

                          List<MapEntry<String, int>> productList = sortedProducts.take(5).toList();

                          if(productList.isNotEmpty)
                          {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [

                                SizedBox(height: 10,),
                                //Header
                                Text(
                                  "Top 5 Buyed Products",
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
                                                "Total Buyed: ",
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

              //Month Transaction Sales PieChart
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

            ],
          ),
        ),
      ),
    );
  }
}