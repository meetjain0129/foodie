import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  Database? database;

  initializeDatabase() async {
    var databasePath = await getDatabasesPath();
    String finalPath = databasePath + '/addtoCart.db';

    database = await openDatabase(finalPath, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE Cart (id INTEGER PRIMARY KEY AUTOINCREMENT, restaurantItemName TEXT, itemCounter INTEGER, itemDesp TEXT, itemPrice INTEGER, itemImg TEXT)');
    });
    print(database);
  }

  insertData(
      {required String itemName,
      required String itemDesp,
      required String itemImg,
      required int itemCounter,
      required int itemPrice}) async {
    await database?.transaction((txn) async {
      int id1 = await txn.rawInsert(
          'INSERT INTO Cart(itemImg, restaurantItemName, itemDesp, itemCounter, itemPrice) VALUES("$itemImg", "$itemName", "$itemDesp", $itemCounter, $itemPrice)');
      print('inserted1: $id1');
    });
    // getRecord();
  }

  getRecord() async {
    List cartData = [];
    if (database == null) {
      database = await initializeDatabase();
      cartData = await database!.rawQuery('SELECT * FROM Cart');
    }
    print(database);
    // if (database != null) {
    // } else {
    //   print('Database is not available');
    //   database = await initializeDatabase();
    //   print(database);
    // }

    print(cartData);
  }
}













































































// import 'package:sqflite/sqflite.dart';

// class DatabaseHelper {
//    Database? database;
// Sqflite Database
// // //   Future<Database> createDB() async {
// // //     var dbName = await openDatabase('cartData.db');
// // //     String defaultPath = await getDatabasesPath();
// // //     String dbPath = defaultPath + 'cartData.db';

// // //     database =
// // //         await openDatabase(dbPath, version: 1, onCreate: ((db, version) async {
// // //       await db
// // //           .execute(
// // //               'CREATE TABLE CartData (id INTEGER PRIMARY KEY AUTOINCREMENT, itemName TEXT, itemIMG TEXT, itemCount INTEGER, price INTEGER, itemDesp TEXT)')
// // //           .whenComplete(() => {
// // //                 print('Successfull'),
// // //               });
// // //     }));

// // //     return dbName;
// // //   }

// // //   insertData(
// // //       {required String dishName,
// // //       required String dishIMG,
// // //       required int dishCount,
// // //       required int dishPrice,
// // //       required String dishDesp}) async {
// // //     print(dishPrice.toString());
// // //     Database db = await createDB();
// // //     print('method called');
// // //     await db.transaction((txn) async {
// // //       int id = await txn
// // //           .rawInsert(
// // //               'INSERT INTO CartData(itemName, itemIMG, itemCount, price, itemDesp) VALUES ("$dishName", "$dishIMG", $dishCount, $dishPrice, "$dishDesp")')
// // //           .whenComplete(() => {
// // //                 print('Data Entered'),
// // //               });

// // //       print(id);
// // //     });

// // //     getData(db);
// // //   }

// // //   getData(Database db) async {
// // //     List cartData = await db.rawQuery('SELECT * FROM CartData');
// // //   }
// // // }

// // import 'dart:io';
// // import 'package:path/path.dart';
// // import 'package:path_provider/path_provider.dart';
// // import 'package:sqflite/sqflite.dart';

// // class DatabaseHelper {
// //   //database object create
// //   static Database? _database;

// //   //for checking
// //   Future<Database> get database async => _database ??= await _initDatabase();

// //   //for access this class easy
// //   DatabaseHelper._privateConstructor();
// //   static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

// //   // if data base is not create than it will create
// //   Future<Database> _initDatabase() async {
// //     Directory documentsDirectory = await getApplicationDocumentsDirectory();
// //     String path = join(documentsDirectory.path, 'CartData.db');
// //     return await openDatabase(
// //       path,
// //       version: 1,
// //       onCreate: _onCreate,
// //     );
// //   }

// //   //create data
// //   Future _onCreate(Database db, int version) async {
// //     await db.execute('''
// //       CREATE TABLE CartData(
// //          id INTEGER PRIMARY KEY AUTOINCREMENT, 
// //          itemName TEXT, 
// //          itemIMG TEXT, 
// //          itemCount INTEGER, 
// //          price INTEGER, 
// //          itemDesp TEXT
// //       )
// //       ''');
// //   }

// //   // for data get
// //   Future<List> getTasks() async {
// //     Database db = await instance.database;
// //     var tasks = await db.query('CartData',
// //         // where: 'id = ?',
// //         orderBy: 'id');

// //     print("Data:: $tasks");
// //     List taskList;
// //     //     tasks.isNotEmpty ? tasks.map((c) => UserModel.fromMap(c)).toList() : [];
// //     return tasks;
// //   }

// //   Future<List> getUsers() async {
// //     Database db = await instance.database;
// //     var users = await db.query('CartData', orderBy: 'id');
// //     // List<UserModel> userList =
// //     //     users.isEmpty ? [] : users.map((e) => UserModel.fromMap(e)).toList();
// //     return users;
// //   }

// //   // for add the data
// //   Future<int> add(tasks) async {
// //     Database db = await instance.database;
// //     return await db.insert('CartData', tasks);
// //   }

// //   //for removing data
// //   Future<int> remove(String id, String uid) async {
// //     Database db = await instance.database;
// //     return await db.delete('CartData', where: 'ids = ?');
// //   }

// //   //for updatee
// //   // Future<int> update(UserModel tasks) async {
// //   //   Database db = await instance.database;
// //   //   return await db.update('matche', tasks.toMap(),
// //   //       where: "id = ?", whereArgs: [tasks.id]);
// //   // }
// // }
