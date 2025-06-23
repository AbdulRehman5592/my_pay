import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    _database ??= await _initDB('wallet_app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 2, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Users (
        user_id TEXT PRIMARY KEY,
        email TEXT UNIQUE NOT NULL,
        phone TEXT,
        hashed_password TEXT NOT NULL,
        full_name TEXT
        
      )
    ''');

    await db.execute('''
      CREATE TABLE Wallets (
        wallet_id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        currency_code TEXT,
        balance REAL DEFAULT 0,
        is_active INTEGER DEFAULT 1,
        FOREIGN KEY(user_id) REFERENCES Users(user_id)
      )
    ''');
    await db.execute('''
CREATE TABLE Transactions (
  txn_id TEXT PRIMARY KEY,
  wallet_id TEXT NOT NULL,
  txn_type TEXT NOT NULL,            -- 'deposit', 'withdrawal', etc.
  amount REAL NOT NULL,
  status TEXT NOT NULL,              -- 'pending', 'completed', 'failed'
  description TEXT,
  reference_id TEXT,
  created_at TEXT NOT NULL,

  FOREIGN KEY (wallet_id) REFERENCES Wallets(wallet_id)
);
    ''');
    await db.execute('''
CREATE TABLE Transfers (
  transfer_id TEXT PRIMARY KEY,
  sender_wallet_id TEXT NOT NULL,
  receiver_wallet_id TEXT NOT NULL,
  amount REAL NOT NULL,
  status TEXT NOT NULL,              -- 'pending', 'completed', 'failed'
  initiated_at TEXT NOT NULL,
  completed_at TEXT,

  FOREIGN KEY (sender_wallet_id) REFERENCES wallets(wallet_id),
  FOREIGN KEY (receiver_wallet_id) REFERENCES wallets(wallet_id)
);

    ''');
    await db.execute('''
CREATE TABLE payment_methods (
  method_id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  type TEXT NOT NULL,               -- 'card', 'bank', etc.
  details TEXT NOT NULL,            -- sensitive info masked or encrypted
  added_at TEXT NOT NULL,
  is_default INTEGER NOT NULL       -- 1 for true, 0 for false
);
    ''');
  }
}
