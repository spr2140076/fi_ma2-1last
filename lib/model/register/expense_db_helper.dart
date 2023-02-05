import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'expenses.dart';

const String columnExpenseId = '_expense_id';
const String columnExpenseCategoryCode = 'expense_category_code';
const String columnExpenseGenreCode = 'expense_genre_code';
const String columnPaymentMethodId = 'payment_method_id';
const String columnExpenseTotalMoney = 'expense_total_money';
const String columnExpenseConsumptionTax = 'expense_consumption_tax';
const String columnExpenseAmountIncludingTax = 'expense_amount_including_tax';
const String columnExpenseDateTime = 'expense_datetime';
const String columnExpenseMemo = 'expense_memo';
const String columnExpenseCreatedAt = 'expense_created_at';
const String columnExpenseUpdatedAt = 'expense_updated_at';


const List<String> expensecolumns = [
  columnExpenseId,
  columnExpenseCategoryCode,
  columnExpenseGenreCode,
  columnPaymentMethodId,
  columnExpenseTotalMoney,
  columnExpenseConsumptionTax,
  columnExpenseAmountIncludingTax,
  columnExpenseDateTime,
  columnExpenseMemo,
  columnExpenseCreatedAt,
  columnExpenseUpdatedAt,
];

class ExpenseDbHelper {
  // DbHelperをinstance化する
  static final ExpenseDbHelper expenseinstance = ExpenseDbHelper._createInstance();
  static Database? _expensedatabase;

  ExpenseDbHelper._createInstance();

  // databaseをオープンしてインスタンス化する
  Future<Database> get expensedatabase async {
    return _expensedatabase ??= await _initDB(); // 初回だったら_initDB()=DBオープンする
  }

  // データベースをオープンする
  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'expenses.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onExpenseCreate, // cats.dbがなかった時の処理を指定する（DBは勝手に作られる）
    );
  }

  Future _onExpenseCreate(Database database, int version) async {
    //catsテーブルをcreateする
    await database.execute('''
      CREATE TABLE expenses(
        _expense_id INTEGER PRIMARY KEY AUTOINCREMENT,
        expense_category_code TEXT,
        expense_genre_code TEXT,
        payment_method_id TEXT,
        expense_total_money INTEGER,
        expense_consumption_tax INTEGER,
        expense_amount_including_tax INTEGER,
        expense_datetime INTEGER,
        expense_memo TEXT,
        expense_created_at TEXT,
        expense_updated_at TEXT
      )
    ''');
  }

  Future<List<Expenses>> selectAllExpenses() async {
    final db = await expenseinstance.expensedatabase;
    final String sql = "SELECT * FROM Expenses ORDER BY expense_datetime DESC";
    final expensesData = await db.rawQuery(sql);          // 条件指定しないでcatsテーブルを読み込む

    return expensesData.map((json) => Expenses.fromJson(json)).toList();    // 読み込んだテーブルデータをListにパースしてreturn
  }

  Future<List<Expenses>> selectDefExpenses() async {
    final db = await expenseinstance.expensedatabase;
    DateTime _now = DateTime.now();
    var dtFormat = DateFormat("yyyy-MM-dd");
    String strDate = dtFormat.format(_now);
    final String sql = "SELECT * FROM Expenses WHERE expense_datetime >= '$strDate' ORDER BY expense_datetime ASC";
    final expensesData = await db.rawQuery(sql);         // 条件指定しないでcatsテーブルを読み込む

    return expensesData.map((json) => Expenses.fromJson(json)).toList();    // 読み込んだテーブルデータをListにパースしてreturn
  }

  Future<List<Expenses>> selectToMonthExpenses() async {
    final db = await expenseinstance.expensedatabase;
    DateTime _now = DateTime.now();
    var dtFormat = DateFormat("yyyy-MM");
    String strDate = dtFormat.format(_now);
    // print(strDate);
    final String sql = "SELECT * FROM Expenses WHERE expense_datetime LIKE '$strDate%' ORDER BY expense_datetime DESC";
    final expensesData = await db.rawQuery(sql);         // 条件指定しないでcatsテーブルを読み込む

    return expensesData.map((json) => Expenses.fromJson(json)).toList();    // 読み込んだテーブルデータをListにパースしてreturn
  }

  Future<Expenses> expenseData(int id) async {
    final db = await expenseinstance.expensedatabase;
    var expense = [];
    expense = await db.query(
      'expenses',
      columns: expensecolumns,
      where: '_expense_id = ?',                     // 渡されたidをキーにしてcatsテーブルを読み込む
      whereArgs: [id],
    );
    return Expenses.fromJson(expense.first);      // 1件だけなので.toListは不要
  }

  Future expenseinsert(Expenses expenses) async {
    final db = await expensedatabase;
    return await db.insert(
        'expenses',
        expenses.toJson()                         // cats.dartで定義しているtoJson()で渡されたcatsをパースして書き込む
    );
  }

  Future expenseupdate(Expenses expenses) async {
    final db = await expensedatabase;
    return await db.update(
      'expenses',
      expenses.toJson(),
      where: '_expense_id = ?',                   // idで指定されたデータを更新する
      whereArgs: [expenses.expense_id],
    );
  }

  Future expensedelete(int id) async {
    final db = await expenseinstance.expensedatabase;
    return await db.delete(
      'expenses',
      where: '_expense_id = ?',                   // idで指定されたデータを削除する
      whereArgs: [id],
    );
  }
}