import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'incomes.dart';

const String columnIncomeId = '_income_id';
const String columnIncomeCategoryCode = 'income_category_code';
const String columnIncomeMoney = 'income_money';
const String columnIncomeDay = 'income_day';
const String columnIncomeMemo = 'income_memo';
const String columnIncomeCreatedAt = 'income_created_at';
const String columnIncomeUpdatedAt = 'income_updated_at';


const List<String> incomecolumns = [
  columnIncomeId,
  columnIncomeCategoryCode,
  columnIncomeMoney,
  columnIncomeDay,
  columnIncomeMemo,
  columnIncomeCreatedAt,
  columnIncomeUpdatedAt,
];

class IncomeDbHelper {
  // DbHelperをinstance化する
  static final IncomeDbHelper incomeinstance = IncomeDbHelper._createInstance();
  static Database? _incomedatabase;

  IncomeDbHelper._createInstance();

  // databaseをオープンしてインスタンス化する
  Future<Database> get incomedatabase async {
    return _incomedatabase ??= await _initDB(); // 初回だったら_initDB()=DBオープンする
  }

  // データベースをオープンする
  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'incomes.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onIncomeCreate, // cats.dbがなかった時の処理を指定する（DBは勝手に作られる）
    );
  }

  Future _onIncomeCreate(Database database, int version) async {
    //catsテーブルをcreateする
    await database.execute('''
      CREATE TABLE incomes(
        _income_id INTEGER PRIMARY KEY AUTOINCREMENT,
        income_category_code TEXT,
        income_money INTEGER,
        income_day INTEGER,
        income_memo TEXT,
        income_created_at TEXT,
        income_updated_at TEXT
      )
    ''');
  }

  // Future<List<Incomes>> selectAllIncomes() async {
  //   final db = await incomeinstance.incomedatabase;
  //   final String sql = "SELECT * FROM incomes ORDER BY income_day DESC";
  //   final incomesData = await db.rawQuery(sql);          // 条件指定しないでcatsテーブルを読み込む
  //
  //   return incomesData.map((json) => Incomes.fromJson(json)).toList();    // 読み込んだテーブルデータをListにパースしてreturn
  // }

  // Future<List<Incomes>> selectDefIncomes() async {
  //   final db = await incomeinstance.incomedatabase;
  //   DateTime _now = DateTime.now();
  //   var dtFormat = DateFormat("yyyy-MM-dd");
  //   String strDate = dtFormat.format(_now);
  //   final String sql = "SELECT * FROM incomes WHERE income_day >= '$strDate' ORDER BY income_day DESC";
  //   final incomesData = await db.rawQuery(sql);
  //
  //   return incomesData.map((json) => Incomes.fromJson(json)).toList();    // 読み込んだテーブルデータをListにパースしてreturn
  // }

  Future<List<Incomes>> selectToMonthIncomes() async {
    final db = await incomeinstance.incomedatabase;
    DateTime _now = DateTime.now();
    var dtFormat = DateFormat("yyyy-MM");
    String strDate = dtFormat.format(_now);
    // print(strDate);
    final String sql = "SELECT * FROM incomes WHERE income_day LIKE '$strDate%' ORDER BY income_day DESC";
    final incomesData = await db.rawQuery(sql);

    return incomesData.map((json) => Incomes.fromJson(json)).toList();
  }


  Future<Incomes> incomeData(int id) async {
    final db = await incomeinstance.incomedatabase;
    var income = [];
    income = await db.query(
      'incomes',
      columns: incomecolumns,
      where: '_income_id = ?',                     // 渡されたidをキーにしてcatsテーブルを読み込む
      whereArgs: [id],
    );
    return Incomes.fromJson(income.first);      // 1件だけなので.toListは不要
  }

  Future incomeinsert(Incomes incomes) async {
    final db = await incomedatabase;
    return await db.insert(
        'incomes',
        incomes.toJson()                         // cats.dartで定義しているtoJson()で渡されたcatsをパースして書き込む
    );
  }

  Future incomeupdate(Incomes incomes) async {
    final db = await incomedatabase;
    return await db.update(
      'incomes',
      incomes.toJson(),
      where: '_income_id = ?',                   // idで指定されたデータを更新する
      whereArgs: [incomes.income_id],
    );
  }

  Future incomedelete(int id) async {
    final db = await incomeinstance.incomedatabase;
    return await db.delete(
      'incomes',
      where: '_income_id = ?',                   // idで指定されたデータを削除する
      whereArgs: [id],
    );
  }
}