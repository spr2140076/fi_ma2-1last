import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/register/expense_db_helper.dart';
import '../../model/register/expenses.dart';
import '../../model/register/income_db_helper.dart';
import '../../model/register/incomes.dart';

class ExpenseDetailEdit extends StatefulWidget {
  final Expenses? expenses;
  final Incomes? incomes;
  // final int tabPage;

  const ExpenseDetailEdit({Key? key, this.expenses, this.incomes,}) : super(key: key);

  @override
  _ExpenseDetailEditState createState() => _ExpenseDetailEditState();
}

class _ExpenseDetailEditState extends State<ExpenseDetailEdit> with SingleTickerProviderStateMixin{
  // late TabController _tabController;

  //expense
  late int expense_id;
  late String expense_category_code;
  late String expense_genre_code;
  late String payment_method_id;
  late int expense_total_money;
  late int expense_consumption_tax;
  late int expense_amount_including_tax;
  late DateTime expense_datetime;
  late String expense_memo;
  late DateTime expense_created_at;
  late DateTime expense_updated_at;
  final List<String> _expense_category = <String>['支出カテゴリの選択','食費', '交通費', '固定費', '交際費'];
  late String _expense_category_selected;
  final List<String> _payment= <String>['支払い方法を選択','現金', 'クレジット', '電子マネー'];
  late String _payment_selected;
  //income
  late int income_id;
  late String income_category_code;
  late int income_money;
  late DateTime income_day;
  late String income_memo;
  late DateTime income_created_at;
  late DateTime income_updated_at;
  final List<String> _income_category = <String>['収入カテゴリの選択','給与','お小遣い'];
  late String _income_category_selected;
  //共通
  String which = '通常';
  dynamic expenseDateTime;
  dynamic expenseDateFormat;
  dynamic incomeDateTime;
  dynamic incomeDateFormat;
  String? incomeItem = '収入カテゴリの選択';
// Stateのサブクラスを作成し、initStateをオーバーライドすると、wedgit作成時に処理を動かすことができる。
// ここでは、各項目の初期値を設定する
  @override
  void initState() {
    super.initState();
    // expense
    expense_id = widget.expenses?.expense_id ?? 0;
    expense_category_code = widget.expenses?.expense_category_code ?? '';
    expense_genre_code = widget.expenses?.expense_genre_code ?? '通常';
    payment_method_id = widget.expenses?.payment_method_id ?? '';
    expense_total_money = widget.expenses?.expense_total_money ?? 0;
    expense_consumption_tax = widget.expenses?.expense_consumption_tax ?? 0;
    expense_amount_including_tax = widget.expenses?.expense_amount_including_tax ?? 0;
    expense_datetime = widget.expenses?.expense_datetime ?? DateTime.now();
    expense_memo = widget.expenses?.expense_memo ?? '';
    expense_created_at = widget.expenses?.expense_created_at ?? DateTime.now();
    expense_updated_at = widget.expenses?.expense_updated_at ?? DateTime.now();
    _expense_category_selected = widget.expenses?.expense_category_code ?? '支出カテゴリの選択';
    _payment_selected = widget.expenses?.payment_method_id ?? '支払い方法を選択';
    //income
    income_id = widget.incomes?.income_id ?? 0;
    income_category_code = widget.incomes?.income_category_code ?? '';
    income_money = widget.incomes?.income_money ?? 0;
    income_day = widget.incomes?.income_day ?? DateTime.now();
    income_memo = widget.incomes?.income_memo ?? '';
    income_created_at = widget.incomes?.income_created_at ?? DateTime.now();
    income_updated_at = widget.incomes?.income_updated_at ?? DateTime.now();
    _income_category_selected = widget.incomes?.income_category_code ?? '収入カテゴリの選択';
    //共通
    expenseDateTime = DateTime.now();
    expenseDateFormat = DateFormat("yyyy年MM月dd日").format(expenseDateTime);

    incomeDateTime = DateTime.now();
    incomeDateFormat = DateFormat("yyyy年MM月dd日").format(incomeDateTime);

  }

  void _onChangedExpenseCategory(String? value) {
    setState(() {
      _expense_category_selected = value!;
      expense_category_code = _expense_category_selected;
    });
  }

  void _onChangedIncomeCategory(String? value) {
    setState(() {
      _income_category_selected = value!;
      income_category_code = _income_category_selected;
    });
  }

  void _onChangedPayment(String? value) {
    setState(() {
      _payment_selected = value!;
      payment_method_id = _payment_selected;
    });
  }

  void _onChangedGenre(String? value) {
    setState(() {
      which = value!;
      expense_genre_code = which;
    });
  }

  _expenseDatePicker(BuildContext context) async {
    final DateTime? datePicked = await showDatePicker(
        locale: const Locale("ja"),
        context: context,
        initialDate: expenseDateTime,
        firstDate: DateTime(2020),
        lastDate: DateTime(2030));
    if (datePicked != null && datePicked != expenseDateTime) {
      setState(() {
        expenseDateFormat = DateFormat("yyyy年MM月dd日").format(datePicked);
        expenseDateTime = datePicked;
        expense_datetime = expenseDateTime;
      });
    }
  }

  _incomeDatePicker(BuildContext context) async {
    final DateTime? datePicked = await showDatePicker(
        locale: const Locale("ja"),
        context: context,
        initialDate: incomeDateTime,
        firstDate: DateTime(2020),
        lastDate: DateTime(2030));
    if (datePicked != null && datePicked != incomeDateTime) {
      setState(() {
        incomeDateFormat = DateFormat("yyyy年MM月dd日").format(datePicked);
        incomeDateTime = datePicked;
        income_day = incomeDateTime;
      });
    }
  }

  void createOrUpdateExpense() async {
    final isUpdate = (widget.expenses != null);     // 画面が空でなかったら

    if (isUpdate) {
      await updateExpense();                        // updateの処理
    } else {
      await createExpense();                        // insertの処理
    }
    Navigator.of(context).pop();               // 前の画面に戻る
  }

  void createOrUpdateIncome() async {
    final isUpdate = (widget.incomes != null);
    // print(isUpdate);// 画面が空でなかったら
    if (isUpdate) {
      await updateIncome();                        // updateの処理
    } else {
      await createIncome();                        // insertの処理
    }
    Navigator.of(context).pop();                // 前の画面に戻る
  }

  // 更新処理の呼び出し
  Future updateExpense() async {
    final expense = widget.expenses!.copy(              // 画面の内容をcatにセット
      expense_category_code: expense_category_code,
      expense_genre_code: expense_genre_code,
      payment_method_id: payment_method_id,
      expense_amount_including_tax: expense_amount_including_tax,
      expense_datetime: expense_datetime,
      expense_memo: expense_memo,
      expense_updated_at: expense_updated_at,
    );

    await ExpenseDbHelper.expenseinstance.expenseupdate(expense);        // catの内容で更新する
  }

  Future updateIncome() async {
    final income = widget.incomes!.copy(              // 画面の内容をcatにセット
      income_category_code: income_category_code,
      income_money: income_money,
      income_day: income_day,
      income_memo: income_memo,
      income_updated_at: income_updated_at,
    );

    await IncomeDbHelper.incomeinstance.incomeupdate(income);        // catの内容で更新する
  }

  // db処理メソッド
  Future createExpense() async {
    final expense = Expenses(                           // 入力された内容をcatにセット
      expense_id: expense_id,
      expense_category_code: expense_category_code,
      expense_genre_code: expense_genre_code,
      payment_method_id: payment_method_id,
      expense_total_money: 0,
      expense_consumption_tax: 0,
      expense_amount_including_tax: expense_amount_including_tax,
      expense_datetime: expense_datetime,
      expense_memo: expense_memo,
      expense_created_at: expense_created_at,
      expense_updated_at: expense_updated_at,
    );
    await ExpenseDbHelper.expenseinstance.expenseinsert(expense);        // catの内容で追加する
  }

  Future createIncome() async {
    final income = Incomes(                           // 入力された内容をcatにセット
      income_id: income_id,
      income_category_code: income_category_code,
      income_money: income_money,
      income_day: income_day,
      income_memo: income_memo,
      income_created_at: income_created_at,
      income_updated_at: income_updated_at,
    );
    await IncomeDbHelper.incomeinstance.incomeinsert(income);        // catの内容で追加する
  }

// 詳細編集画面を表示する
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 50,),
          onPressed: () => Navigator.of(context).pop(),  // 遷移元のページをpop
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DefaultTabController(
              length: 2,
              // initialIndex: 0,
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
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
                    height: 480,
                    child: TabBarView(
                      children: <Widget>[

                        Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children:[
                                    Radio(
                                        value: '通常',
                                        groupValue: which,
                                        onChanged: _onChangedGenre
                                    ),
                                    const Text('通常', style: TextStyle(fontSize: 25),),
                                    Radio(
                                        value: '後払い',
                                        groupValue: which,
                                        onChanged: _onChangedGenre
                                    ),
                                    const Text('後払い', style: TextStyle(fontSize: 25),),
                                  ],
                                ),
                              ),
                              Container(
                                width:280,
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(color: Colors.black)
                                    )
                                ),
                                child: Center(
                                  child: TextFormField(
                                      initialValue: expense_amount_including_tax.toString(), style: const TextStyle(fontSize: 35),
                                      textAlign: TextAlign.right,
                                      keyboardType: TextInputType.number,
                                      onChanged: (change_expense_money) => setState(() => expense_amount_including_tax = int.parse(change_expense_money))
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20,),
                              Container(
                                child: OutlinedButton(
                                    child:Text(expenseDateFormat),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.black,
                                    ),
                                    onPressed: () {
                                      _expenseDatePicker(context);
                                    }),
                              ),
                              const SizedBox(height: 10,),
                              Container(
                                width: 220,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(),
                                  ),
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: 220,
                                      height: 50,
                                      child: DropdownButton<String>(
                                        items: _expense_category.map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                        value: _expense_category_selected,
                                        onChanged: _onChangedExpenseCategory,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10,),
                              Container(
                                width: 220,
                                child: Row(
                                  children: <Widget>[
                                    DropdownButton<String>(
                                      items: _payment.map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      value: _payment_selected,
                                      onChanged: _onChangedPayment,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: const Align(
                                  alignment: Alignment(-0.7,0),
                                  child: Text('メモ', style: TextStyle(fontSize: 25),),
                                ),
                              ),
                              Container(
                                width: 280,
                                child: TextFormField(
                                  initialValue: expense_memo,
                                  decoration: const InputDecoration(
                                      hintText: 'メモを入力してください',
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width: 2),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 10,
                                      )
                                  ),
                                  onChanged: (expense_change_memo) => setState(() => this.expense_memo = expense_change_memo),
                                ),
                              ),
                              const SizedBox(height: 20,),
                              Container(
                                height: 50,
                                width: 100,
                                child: ElevatedButton(
                                  child: const Text('登録', style: TextStyle(fontSize: 20),),
                                  onPressed: createOrUpdateExpense,
                                ),
                              ),
                            ],
                          ),
                        ),



































                        //ここから収入
                        Container(
                          child: Column(
                            children: <Widget>[
                              const SizedBox(height: 50,),
                              Container(
                                width:280,
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(color: Colors.black)
                                    )
                                ),
                                child: Center(
                                  child: TextFormField(
                                      initialValue: income_money.toString(), style: const TextStyle(fontSize: 35),
                                      textAlign: TextAlign.right,
                                      keyboardType: TextInputType.number,
                                      onChanged: (change_income_money) => setState(() => income_money = int.parse(change_income_money))
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10,),
                              Container(
                                child: OutlinedButton(
                                    child:Text(incomeDateFormat),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.black,
                                    ),
                                    onPressed: () {
                                      _incomeDatePicker(context);
                                    }),
                              ),
                              const SizedBox(height: 10,),
                              Container(
                                width: 220,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(),
                                  ),
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: 220,
                                      height: 50,
                                      child: DropdownButton<String>(
                                        items: _income_category.map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                        value: _income_category_selected,
                                        onChanged: _onChangedIncomeCategory,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20,),
                              Container(
                                child: const Align(
                                  alignment: Alignment(-0.7,0),
                                  child: Text('メモ', style: TextStyle(fontSize: 25),),
                                ),
                              ),
                              Container(
                                width: 280,
                                child: TextFormField(
                                  initialValue: income_memo,
                                  decoration: const InputDecoration(
                                      hintText: 'メモを入力してください',
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width: 2),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 10,
                                      )
                                  ),
                                  onChanged: (income_change_memo) => setState(() => this.income_memo = income_change_memo),
                                ),
                              ),
                              const SizedBox(height: 20,),
                              Container(
                                height: 50,
                                width: 100,
                                child: ElevatedButton(
                                  child: const Text('登録', style: TextStyle(fontSize: 20),),
                                  onPressed: createOrUpdateIncome,
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
          ],
        ),
      ),
    );
  }
}