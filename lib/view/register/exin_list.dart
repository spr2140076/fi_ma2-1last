import 'package:flutter/material.dart';
import '../../model/register/expense_db_helper.dart';
import '../../model/register/expenses.dart';
import '../../model/register/income_db_helper.dart';
import '../../model/register/incomes.dart';
import 'exin_detail_edit.dart';
import 'expense_detail.dart';
import 'income_detail.dart';


// catテーブルの内容全件を一覧表示するクラス
class ExpenseList extends StatefulWidget {
  const ExpenseList({Key? key}) : super(key: key);

  @override
  State<ExpenseList> createState() => _ExpenseListPageState();
}

class _ExpenseListPageState extends State<ExpenseList> {
  List<Expenses> expenseList = [];  //catsテーブルの全件を保有する
  List<Incomes> incomeList = [];
  bool isLoading = false;
  dynamic calendarDateTime;//テーブル読み込み中の状態を保有する

// Stateのサブクラスを作成し、initStateをオーバーライドすると、wedgit作成時に処理を動かすことができる。
// ここでは、初期処理としてCatsの全データを取得する。
  @override
  void initState() {
    super.initState();
    getExpensesList();
    getIncomesList();
    calendarDateTime = DateTime.now();
  }

// initStateで動かす処理。
// catsテーブルに登録されている全データを取ってくる
  Future getExpensesList() async {
    setState(() => isLoading = true);                   //テーブル読み込み前に「読み込み中」の状態にする
    expenseList = await ExpenseDbHelper.expenseinstance.selectAllExpenses(); //catsテーブルを全件読み込む
    setState(() => isLoading = false);                  //「読み込み済」の状態にする
  }

  Future getIncomesList() async {
    setState(() => isLoading = true);
    incomeList = await IncomeDbHelper.incomeinstance.selectAllIncomes();
    setState(() => isLoading = false);
  }

  _calendarDatePicker(BuildContext context)  {
    showDatePicker(
      locale: const Locale("ja"),
      context: context,
      initialDate: calendarDateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              _calendarDatePicker(context);
            },
            icon: const Icon(Icons.calendar_month))
        ],
        title: const Text('収支一覧', style: TextStyle(fontSize: 25),),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DefaultTabController(
              length: 2,
              initialIndex: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children:[
                  Container(
                    child: const TabBar(
                      labelColor: Colors.orange,
                      unselectedLabelColor: Colors.black,
                      tabs: [
                        Tab(text: '支出'),
                        Tab(text: '収入'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20,),

                  Container(
                    height: 450,
                    child: TabBarView(
                      children: <Widget>[

                        Container(
                          child: SizedBox(
                            child: ListView.builder(              // 取得したcatsテーブル全件をリスト表示する
                              itemCount: expenseList.length, // 取得したデータの件数を取得
                              itemBuilder: (BuildContext context, int index) {
                                final expense = expenseList[index];       // 1件分のデータをcatに取り出す
                                return Card(                      // ここで1件分のデータを表示
                                  child: InkWell(                 // cardをtapしたときにそのcardの詳細画面に遷移させる
                                    child: Padding(               // cardのpadding設定
                                      padding: const EdgeInsets.all(15.0),
                                      child: Row(                 // cardの中身をRowで設定
                                          children: <Widget>[               // Rowの中身を設定
                                            Text('￥',style: const TextStyle(fontSize: 30),),
                                            Text(expense.expense_amount_including_tax.toString() ,style: const TextStyle(fontSize: 30),),     // catのnameを表示
                                          ]
                                      ),
                                    ),
                                    onTap: () async {                     // cardをtapしたときの処理を設定
                                      await Navigator.of(context).push(   // ページ遷移をNavigatorで設定
                                        MaterialPageRoute(
                                          builder: (context) => ExpenseDetail(id: expense.expense_id!),   // cardのデータの詳細を表示するcat_detail.dartへ遷移
                                        ),
                                      );
                                      getExpensesList();    // データが更新されているかもしれないので、catsテーブル全件読み直し
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        Container(
                          child: SizedBox(
                            child: ListView.builder(              // 取得したcatsテーブル全件をリスト表示する
                              itemCount: incomeList.length,          // 取得したデータの件数を取得
                              itemBuilder: (BuildContext context, int index) {
                                final income = incomeList[index];       // 1件分のデータをcatに取り出す
                                return Card(                      // ここで1件分のデータを表示
                                  child: InkWell(                 // cardをtapしたときにそのcardの詳細画面に遷移させる
                                    child: Padding(               // cardのpadding設定
                                      padding: const EdgeInsets.all(15.0),
                                      child: Row(                 // cardの中身をRowで設定
                                          children: <Widget>[               // Rowの中身を設定
                                            Text('￥',style: const TextStyle(fontSize: 30),),
                                            Text(income.income_money.toString() ,style: const TextStyle(fontSize: 30),),     // catのnameを表示
                                          ]
                                      ),
                                    ),
                                    onTap: () async {                     // cardをtapしたときの処理を設定
                                      await Navigator.of(context).push(   // ページ遷移をNavigatorで設定
                                        MaterialPageRoute(
                                          builder: (context) => IncomeDetail(id: income.income_id!),   // cardのデータの詳細を表示するcat_detail.dartへ遷移
                                        ),
                                      );
                                      getIncomesList();    // データが更新されているかもしれないので、catsテーブル全件読み直し
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(                   // ＋ボタンを下に表示する
        child: const Icon(Icons.add),                               // ボタンの形を指定
        onPressed: () async {
          // print(expenseList.length);// ＋ボタンを押したときの処理を設定
          await Navigator.of(context).push(                         // ページ遷移をNavigatorで設定
            MaterialPageRoute(
                builder: (context) => const ExpenseDetailEdit()           // 詳細更新画面（元ネタがないから新規登録）を表示するcat_detail_edit.dartへ遷移
            ),
          );
          getExpensesList();
          getIncomesList();// 新規登録されているので、catテーブル全件読み直し
        },
      ),
      // bottomNavigationBar: Footer(),
    );
  }
}
