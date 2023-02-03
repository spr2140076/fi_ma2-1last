import 'package:fi_ma/model/register/expense_db_helper.dart';
import 'package:fi_ma/view/register/exin_detail_edit.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {

  late List<Map<String, dynamic>> totalExpense;
  late List<Map<String, dynamic>> foodExpense;
  late List<Map<String, dynamic>> trafficExpense;
  late List<Map<String, dynamic>> fixedCostExpense;
  late List<Map<String, dynamic>> entertainmentExpense;
  late int total;
  late int foodTotal;
  late int trafficTotal;
  late int fixedCostTotal;
  late int entertainmentTotal;
  bool isLoading = false;
  late DateTime nowResult;
  late DateTime _now;
  late DateTime rresult;

  @override
  void initState() {
    super.initState() ;
    totalExpense = [];
    foodExpense = [];
    trafficExpense = [];
    fixedCostExpense = [];
    entertainmentExpense = [];
    total = 0;
    foodTotal = 0;
    trafficTotal = 0;
    fixedCostTotal = 0;
    entertainmentTotal = 0;
    _now = DateTime.now();
    // nowResult = DateTime(_now.year, _now.month);
    // rresult = DateTime(_now.year, _now.month + 1, 1).add(Duration(days: -1));
    // print(_now.month);
    // print(rresult);
    getExpenseData();
    getFoodData();
    getTrafficData();
    getFixedCostData();
    getEntertainmentData();
    // print(totalExpense.runtimeType);
  }

  Future getExpenseData() async {
    setState(() => isLoading = true);
    // _now = DateTime.now();
    var dtFormat = DateFormat("yy-MM");
    String strDate = dtFormat.format(_now);
    final db = await ExpenseDbHelper.expenseinstance.expensedatabase;
    final String sql = "SELECT expense_amount_including_tax FROM Expenses WHERE expense_datetime LIKE '%$strDate%'";
    final List<Map<String, dynamic>> result = await db.rawQuery(sql);
    totalExpense = result;

    for(int i = 0; i < result.length; i++) {
      int sum = result[i]['expense_amount_including_tax'];
      total += sum;
    }
    setState(() => isLoading = false);
}

  Future getFoodData() async {
    setState(() => isLoading = true);
    final db = await ExpenseDbHelper.expenseinstance.expensedatabase;
    final String sql = "SELECT expense_amount_including_tax FROM Expenses WHERE expense_category_code = '食費'";
    final List<Map<String, dynamic>> result = await db.rawQuery(sql);

    foodExpense = result;

    for(int i = 0; i < foodExpense.length; i++) {
      int sum = result[i]['expense_amount_including_tax'];
      foodTotal += sum;
    }
    setState(() => isLoading = false);
  }

  Future getTrafficData() async {
    setState(() => isLoading = true);
    final db = await ExpenseDbHelper.expenseinstance.expensedatabase;
    final String sql = "SELECT expense_amount_including_tax FROM Expenses WHERE expense_category_code = '交通費'";
    final List<Map<String, dynamic>> result = await db.rawQuery(sql);

    trafficExpense = result;

    for(int i = 0; i < trafficExpense.length; i++) {
      int sum = result[i]['expense_amount_including_tax'];
      trafficTotal += sum;
    }
    setState(() => isLoading = false);
  }

  Future getFixedCostData() async {
    setState(() => isLoading = true);
    final db = await ExpenseDbHelper.expenseinstance.expensedatabase;
    final String sql = "SELECT expense_amount_including_tax FROM Expenses WHERE expense_category_code = '固定費'";
    final List<Map<String, dynamic>> result = await db.rawQuery(sql);

    fixedCostExpense = result;

    for(int i = 0; i < fixedCostExpense.length; i++) {
      int sum = result[i]['expense_amount_including_tax'];
      fixedCostTotal += sum;
    }
    setState(() => isLoading = false);
  }

  Future getEntertainmentData() async {
    setState(() => isLoading = true);
    final db = await ExpenseDbHelper.expenseinstance.expensedatabase;
    final String sql = "SELECT expense_amount_including_tax FROM Expenses WHERE expense_category_code = '交際費'";
    final List<Map<String, dynamic>> result = await db.rawQuery(sql);

    entertainmentExpense = result;

    for(int i = 0; i < entertainmentExpense.length; i++) {
      int sum = result[i]['expense_amount_including_tax'];
      entertainmentTotal += sum;
    }
    setState(() => isLoading = false);
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fi-MA', style: TextStyle(fontSize: 25),),
        centerTitle: true,
      ),
      body: isLoading
      ? const Center(
        child: CircularProgressIndicator(),
      ):
       Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 10,),
            Container(
              width: double.infinity,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 300,
                    height: 40,
                    child: Text('一週間以内未払い請求書', style: TextStyle(fontSize: 25, color: Colors.orange),),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 250,
              //color: Colors.lightGreen,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: 200,
                    height: 200,
                    //color: Colors.cyan,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,children: [
                      Expanded(
                        child: PieChart(
                          PieChartData(
                              // centerSpaceRadius: 60,
                              startDegreeOffset: 300,  //要検討
                              sections: [
                                PieChartSectionData(
                                  borderSide: BorderSide(color: Colors.black, width: 1),
                                  color: Colors.red,
                                  title: "食費",
                                  value: foodTotal.toDouble(),
                                  radius: 50,
                                  // titlePositionPercentageOffset: 0.5,
                                ),
                                PieChartSectionData(
                                  borderSide: BorderSide(color: Colors.black, width: 1),
                                  color: Colors.purple,
                                  title: "交通費",
                                  value: trafficTotal.toDouble(),
                                  radius: 50,
                                ),
                                PieChartSectionData(
                                  borderSide: BorderSide(color: Colors.black, width: 1),
                                  color: Colors.blueAccent,
                                  title: "固定費",
                                  value: fixedCostTotal.toDouble(),
                                  radius: 50,
                                ),
                                PieChartSectionData(
                                  borderSide: BorderSide(color: Colors.black, width: 1),
                                  color: Colors.orange,
                                  title: "交際費",
                                  value: entertainmentTotal.toDouble(),
                                  radius: 50,
                                ),
                                // PieChartSectionData(
                                //   borderSide: BorderSide(color: Colors.black, width: 1),
                                //   color: Colors.green,
                                // ),
                                // PieChartSectionData(
                                //   borderSide: BorderSide(color: Colors.black, width: 1),
                                //   color: Colors.yellow,
                                // ),
                              ]
                          ),
                        ),
                      ),
                    ],
                    ),
                  ),
                  Container(
                    //color: Colors.blue,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('今月の予算', style: TextStyle(fontSize: 30),),
                        SizedBox(height: 30,),
                        Text('￥100,000', style: TextStyle(fontSize: 30, decoration: TextDecoration.underline),),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            Container(
              child: Row(
                children: [
                  Text('合計金額:', style: TextStyle(fontSize: 30),),
                  SizedBox(width: 15,),
                  Text(total.toString(),style: TextStyle(fontSize: 35, decoration: TextDecoration.underline),),
                ],
              ),
            ),
            SizedBox(height: 10,),
            Container(
              width: double.infinity,
              height: 30,
              // color: Colors.yellowAccent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('食費', style: TextStyle(fontSize: 25),),
                  SizedBox(width: 15,),
                  Text(foodTotal.toString(), style: TextStyle(fontSize: 25),)
                ],
              ),
            ),
            SizedBox(height: 10,),
            Container(
              width: double.infinity,
              height: 30,
              // color: Colors.yellowAccent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('交通費', style: TextStyle(fontSize: 25),),
                  SizedBox(width: 15,),
                  Text(trafficTotal.toString(), style: TextStyle(fontSize: 25),)
                ],
              ),
            ),
            SizedBox(height: 10,),
            Container(
              width: double.infinity,
              height: 30,
              // color: Colors.yellowAccent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('固定費', style: TextStyle(fontSize: 25),),
                  SizedBox(width: 15,),
                  Text(fixedCostTotal.toString(), style: TextStyle(fontSize: 25),)
                ],
              ),
            ),
            SizedBox(height: 10,),
            Container(
              width: double.infinity,
              height: 30,
              // color: Colors.yellowAccent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('交際費', style: TextStyle(fontSize: 25),),
                  SizedBox(width: 15,),
                  Text(entertainmentTotal.toString(), style: TextStyle(fontSize: 25),)
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {                                       // ＋ボタンを押したときの処理を設定
          await Navigator.of(context).push(                         // ページ遷移をNavigatorで設定
            MaterialPageRoute(
                builder: (context) => const ExpenseDetailEdit()           // 詳細更新画面（元ネタがないから新規登録）を表示するcat_detail_edit.dartへ遷移
            ),
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}