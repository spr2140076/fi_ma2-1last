import 'dart:ffi';

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
  late List<Map<String, dynamic>> dailyNecessitiesExpense;
  late List<Map<String, dynamic>> clothingExpense;
  late List<Map<String, dynamic>> medicalExpense;
  late List<Map<String, dynamic>> enterExpense;
  late List<Map<String, dynamic>> etcExpense;
  late String strTotal;
  late String strFoodTotal;
  late int foodTotal;
  late String strTrafficTotal;
  late int trafficTotal;
  late String strFixedCostTotal;
  late int fixedCostTotal;
  late String strEntertainmentTotal;
  late int entertainmentTotal;
  late String strDailyNecessitiesTotal;
  late int dailyNecessitiesTotal;
  late String strClothingTotal;
  late int clothingTotal;
  late String strMedicalTotal;
  late int medicalTotal;
  late String strEnterTotal;
  late int enterTotal;
  late String strEtcTotal;
  late int etcTotal;
  bool isLoading = false;
  late DateTime nowResult;
  late DateTime _now;
  late DateTime rresult;
  late String? oneWeek;
  late String? oneWeekDate;
  late String aa;
  late DateTime tes;

  @override
  void initState() {
    super.initState() ;
    totalExpense = [];
    foodExpense = [];
    trafficExpense = [];
    fixedCostExpense = [];
    entertainmentExpense = [];
    dailyNecessitiesExpense = [];
    clothingExpense = [];
    medicalExpense = [];
    enterExpense = [];
    etcExpense = [];
    strTotal = '';
    strFoodTotal = '';
    foodTotal = 0;
    strTrafficTotal = '';
    trafficTotal = 0;
    strFixedCostTotal = '';
    fixedCostTotal = 0;
    strEntertainmentTotal = '';
    entertainmentTotal = 0;
    strDailyNecessitiesTotal = '';
    dailyNecessitiesTotal = 0;
    strClothingTotal = '';
    clothingTotal = 0;
    strMedicalTotal = '';
    medicalTotal = 0;
    strEnterTotal = '';
    enterTotal = 0;
    strEtcTotal = '';
    etcTotal = 0;
    _now = DateTime.now();
    oneWeek = '1週間以内の後払いはありません';
    oneWeekDate = '';
    // nowResult = DateTime(_now.year, _now.month);
    // rresult = DateTime(_now.year, _now.month + 1, 1).add(Duration(days: -1));
    // print(_now.month);
    // print(rresult);
    getExpenseData();
    getFoodData();
    getTrafficData();
    getFixedCostData();
    getEntertainmentData();
    getDailyNecessitiesData();
    getOneWeekData();
    getClothingData();
    getMedicalData();
    getEnterData();
    getEtcData();
    // print(totalExpense.runtimeType);
  }

  DateTime getStartWeek(DateTime date) {
    var startweek = _now.subtract(Duration(days: date.weekday - 1));
    return startweek;
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

    int total = 0;

    for(int i = 0; i < result.length; i++) {
      int sum = result[i]['expense_amount_including_tax'];
      total += sum;
    }

    final formatter = NumberFormat("#,###");
    strTotal = formatter.format(total);

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

    final formatter = NumberFormat("#,###");
    strFoodTotal = formatter.format(foodTotal);
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

    final formatter = NumberFormat("#,###");
    strTrafficTotal = formatter.format(trafficTotal);
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
    final formatter = NumberFormat("#,###");
    strFixedCostTotal = formatter.format(fixedCostTotal);
    setState(() => isLoading = false);
  }

  Future getDailyNecessitiesData() async {
    setState(() => isLoading = true);
    final db = await ExpenseDbHelper.expenseinstance.expensedatabase;
    final String sql = "SELECT expense_amount_including_tax FROM Expenses WHERE expense_category_code = '日用品'";
    final List<Map<String, dynamic>> result = await db.rawQuery(sql);

    dailyNecessitiesExpense = result;

    for(int i = 0; i < dailyNecessitiesExpense.length; i++) {
      int sum = result[i]['expense_amount_including_tax'];
      dailyNecessitiesTotal += sum;
    }
    final formatter = NumberFormat("#,###");
    strDailyNecessitiesTotal = formatter.format(dailyNecessitiesTotal);
    setState(() => isLoading = false);
  }

  Future getClothingData() async {
    setState(() => isLoading = true);
    final db = await ExpenseDbHelper.expenseinstance.expensedatabase;
    final String sql = "SELECT expense_amount_including_tax FROM Expenses WHERE expense_category_code = '衣服'";
    final List<Map<String, dynamic>> result = await db.rawQuery(sql);

    clothingExpense = result;

    for(int i = 0; i < clothingExpense.length; i++) {
      int sum = result[i]['expense_amount_including_tax'];
      clothingTotal += sum;
    }
    final formatter = NumberFormat("#,###");
    strClothingTotal = formatter.format(clothingTotal);
    setState(() => isLoading = false);
  }

  Future getMedicalData() async {
    setState(() => isLoading = true);
    final db = await ExpenseDbHelper.expenseinstance.expensedatabase;
    final String sql = "SELECT expense_amount_including_tax FROM Expenses WHERE expense_category_code = '医療費'";
    final List<Map<String, dynamic>> result = await db.rawQuery(sql);

    medicalExpense = result;

    for(int i = 0; i < medicalExpense.length; i++) {
      int sum = result[i]['expense_amount_including_tax'];
      medicalTotal += sum;
    }
    final formatter = NumberFormat("#,###");
    strMedicalTotal = formatter.format(medicalTotal);
    setState(() => isLoading = false);
  }

  Future getEnterData() async {
    setState(() => isLoading = true);
    final db = await ExpenseDbHelper.expenseinstance.expensedatabase;
    final String sql = "SELECT expense_amount_including_tax FROM Expenses WHERE expense_category_code = '娯楽'";
    final List<Map<String, dynamic>> result = await db.rawQuery(sql);

    enterExpense = result;

    for(int i = 0; i < enterExpense.length; i++) {
      int sum = result[i]['expense_amount_including_tax'];
      enterTotal += sum;
    }
    final formatter = NumberFormat("#,###");
    strEnterTotal = formatter.format(enterTotal);
    setState(() => isLoading = false);
  }

  Future getEtcData() async {
    setState(() => isLoading = true);
    final db = await ExpenseDbHelper.expenseinstance.expensedatabase;
    final String sql = "SELECT expense_amount_including_tax FROM Expenses WHERE expense_category_code = '娯楽'";
    final List<Map<String, dynamic>> result = await db.rawQuery(sql);

    etcExpense = result;

    for(int i = 0; i < etcExpense.length; i++) {
      int sum = result[i]['expense_amount_including_tax'];
      etcTotal += sum;
    }
    final formatter = NumberFormat("#,###");
    strEtcTotal = formatter.format(etcTotal);
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
    final formatter = NumberFormat("#,###");
    strEntertainmentTotal = formatter.format(entertainmentTotal);
    setState(() => isLoading = false);
  }

  // Future<List<Expenses>> selectDefExpenses() async {
  //   final db = await expenseinstance.expensedatabase;
  //   DateTime _now = DateTime.now();
  //   var dtFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  //   String strDate = dtFormat.format(_now);
  //   final String sql = "SELECT * FROM Expenses WHERE expense_datetime >= '$strDate'";
  //   final expensesData = await db.rawQuery(sql);         // 条件指定しないでcatsテーブルを読み込む
  //
  //   return expensesData.map((json) => Expenses.fromJson(json)).toList();    // 読み込んだテーブルデータをListにパースしてreturn
  // }

  Future getOneWeekData() async {
    setState(() => isLoading = true);
    final db = await ExpenseDbHelper.expenseinstance.expensedatabase;
    DateTime _now = DateTime.now();
    int dateRange = 7;
    final endDate = _now.add(Duration(days: dateRange));
    var dtFormat = DateFormat("yyyy-MM-dd");
    var dttFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    String strDate = dtFormat.format(_now);
    String strEndDate = dttFormat.format(endDate);
    final String sql = "SELECT expense_amount_including_tax, expense_datetime FROM Expenses WHERE expense_genre_code = '後払い' AND expense_datetime BETWEEN '$strDate' AND '$strEndDate' ORDER BY expense_datetime ASC";
    final List<Map<String, dynamic>> result = await db.rawQuery(sql);
    Map<String, dynamic> oneWeekDataResult = result[0];
    var one = oneWeekDataResult['expense_amount_including_tax'];
    final formatter = NumberFormat("#,###");
    oneWeek = formatter.format(one);
    oneWeekDate = oneWeekDataResult['expense_datetime'];
    DateTime week = DateTime.parse('$oneWeekDate');
    oneWeekDate = DateFormat("yyyy年MM月dd日￥").format(week);


    entertainmentExpense = result;
    setState(() => isLoading = false);
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        title: Text('Fi-MA', style: TextStyle(fontSize: 25),),
        backgroundColor: Colors.orange[300],
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
            Text('後払い', style: TextStyle(fontSize: 20, color: Colors.black),),
            Container(
              width: double.infinity,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 400,
                    height: 40,
                    //color: Colors.cyan,
                    child: Text(oneWeekDate! + oneWeek!, style: TextStyle(fontSize: 25, color: Colors.black,), textAlign: TextAlign.center,),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 220,
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
                                  color: Colors.orange[100],
                                  title: "食費",
                                  value: foodTotal.toDouble(),
                                  radius: 50,
                                  // titlePositionPercentageOffset: 0.5,
                                ),
                                PieChartSectionData(
                                  borderSide: BorderSide(color: Colors.black, width: 1),
                                  color: Colors.green[100],
                                  title: "交通費",
                                  value: trafficTotal.toDouble(),
                                  radius: 50,
                                ),
                                PieChartSectionData(
                                  borderSide: BorderSide(color: Colors.black, width: 1),
                                  color: Colors.yellow[100],
                                  title: "固定費",
                                  value: fixedCostTotal.toDouble(),
                                  radius: 50,
                                ),
                                PieChartSectionData(
                                  borderSide: BorderSide(color: Colors.black, width: 1),
                                  color: Colors.red[100],
                                  title: "交際費",
                                  value: entertainmentTotal.toDouble(),
                                  radius: 50,
                                ),
                                PieChartSectionData(
                                  borderSide: BorderSide(color: Colors.black, width: 1),
                                  color: Colors.lightBlue[100],
                                  title: "日用品",
                                  value: dailyNecessitiesTotal.toDouble(),
                                  radius: 50,
                                ),
                                PieChartSectionData(
                                  borderSide: BorderSide(color: Colors.black, width: 1),
                                  color: Colors.purple[100],
                                  title: "衣服",
                                  value: clothingTotal.toDouble(),
                                  radius: 50,
                                ),
                                PieChartSectionData(
                                  borderSide: BorderSide(color: Colors.black, width: 1),
                                  color: Colors.white,
                                  title: "医療費",
                                  value: medicalTotal.toDouble(),
                                  radius: 50,
                                ),
                                PieChartSectionData(
                                  borderSide: BorderSide(color: Colors.black, width: 1),
                                  color: Colors.pinkAccent[50],
                                  title: "娯楽",
                                  value: enterTotal.toDouble(),
                                  radius: 50,
                                ),
                                PieChartSectionData(
                                  borderSide: BorderSide(color: Colors.black, width: 1),
                                  color: Colors.grey[150],
                                  title: "その他",
                                  value: etcTotal.toDouble(),
                                  radius: 50,
                                ),
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
                  SizedBox(width: 25,),
                  Text('合計金額:', style: TextStyle(fontSize: 30),),
                  SizedBox(width: 15,),
                  Text('￥' + strTotal,style: TextStyle(fontSize: 35, ),),
                ],
              ),
            ),
            SizedBox(height: 10,),
            Container(
              height: 155,
              width: 355,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: 35,
                      // color: Colors.yellowAccent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('食費', style: TextStyle(fontSize: 25),),
                          SizedBox(width: 40,),
                          Text('￥' + strFoodTotal, style: TextStyle(fontSize: 30),)
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 35,
                      // color: Colors.yellowAccent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('交通費', style: TextStyle(fontSize: 25),),
                          SizedBox(width: 15,),
                          Text('￥' + strTrafficTotal, style: TextStyle(fontSize: 30),)
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 35,
                      // color: Colors.yellowAccent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('固定費', style: TextStyle(fontSize: 25),),
                          SizedBox(width: 15,),
                          Text('￥' + strFixedCostTotal, style: TextStyle(fontSize: 30),)
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 35,
                      // color: Colors.yellowAccent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('交際費', style: TextStyle(fontSize: 25),),
                          SizedBox(width: 15,),
                          Text('￥' + strEntertainmentTotal, style: TextStyle(fontSize: 30),)
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 35,
                      // color: Colors.yellowAccent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('日用品', style: TextStyle(fontSize: 25),),
                          SizedBox(width: 15,),
                          Text('￥' + strDailyNecessitiesTotal, style: TextStyle(fontSize: 30),)
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 35,
                      // color: Colors.yellowAccent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('衣服', style: TextStyle(fontSize: 25),),
                          SizedBox(width: 40,),
                          Text('￥' + strClothingTotal, style: TextStyle(fontSize: 30),)
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 35,
                      // color: Colors.yellowAccent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('医療費', style: TextStyle(fontSize: 25),),
                          SizedBox(width: 15,),
                          Text('￥' + strMedicalTotal, style: TextStyle(fontSize: 30),)
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 35,
                      // color: Colors.yellowAccent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('娯楽', style: TextStyle(fontSize: 25),),
                          SizedBox(width: 40,),
                          Text('￥' + strEnterTotal, style: TextStyle(fontSize: 30),)
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 35,
                      // color: Colors.yellowAccent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('その他', style: TextStyle(fontSize: 25),),
                          SizedBox(width: 15,),
                          Text('￥' + strEtcTotal, style: TextStyle(fontSize: 30),)
                        ],
                      ),
                    ),
                  ],
                ),
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
        backgroundColor: Colors.orange,
      ),
    );
  }
}