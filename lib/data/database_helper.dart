import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:my_first_app/data/models/category.dart';
import 'package:my_first_app/data/models/transaction.dart';
import 'package:my_first_app/data/models/budget.dart';

class DatabaseHelper {
  static const _databaseName = "budgetTrackerDB.db";
  static const _databaseVersion = 1;

  static const tableCategories = 'categories';
  static const tableTransactions = 'transactions';
  static const tableBudgets = 'budgets';

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  // SQL code to create the database tables.
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableCategories (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        icon INTEGER NOT NULL,
        color INTEGER NOT NULL,
        type INTEGER NOT NULL
      )
      ''');

    await db.execute('''
      CREATE TABLE $tableTransactions (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        amount REAL NOT NULL,
        categoryId TEXT NOT NULL,
        date TEXT NOT NULL,
        note TEXT,
        FOREIGN KEY (categoryId) REFERENCES $tableCategories (id) ON DELETE CASCADE
      )
      ''');

    await db.execute('''
      CREATE TABLE $tableBudgets (
        id TEXT PRIMARY KEY,
        categoryId TEXT NOT NULL,
        budgetLimit REAL NOT NULL,
        period TEXT NOT NULL,
        spent REAL NOT NULL,
        FOREIGN KEY (categoryId) REFERENCES $tableCategories (id) ON DELETE CASCADE
      )
      ''');
  }

  // Helper methods

  // Insert a category
  Future<int> insertCategory(BudgetCategory category) async {
    Database db = await instance.database;
    return await db.insert(tableCategories, category.toMap());
  }

  // Get all categories
  Future<List<BudgetCategory>> getCategories() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(tableCategories);
    return List.generate(maps.length, (i) {
      return BudgetCategory.fromMap(maps[i]);
    });
  }

  // Insert a transaction
  Future<int> insertTransaction(BudgetTransaction transaction) async {
    Database db = await instance.database;
    return await db.insert(tableTransactions, transaction.toMap());
  }

  // Get all transactions
  Future<List<BudgetTransaction>> getTransactions() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableTransactions,
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) {
      return BudgetTransaction.fromMap(maps[i]);
    });
  }

  // Delete transaction
  Future<int> deleteTransaction(String id) async {
    Database db = await instance.database;
    return await db.delete(
      tableTransactions,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Insert/Update a budget
  Future<int> insertOrUpdateBudget(Budget budget) async {
    Database db = await instance.database;
    return await db.insert(
      tableBudgets,
      budget.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Budget>> getBudgets() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(tableBudgets);
    return List.generate(maps.length, (i) {
      return Budget.fromMap(maps[i]);
    });
  }
}
