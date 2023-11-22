import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as Path;
import 'dart:async';

class Model {
  Database? _database;
  
  Future<Database> get database async {
    if (_database != null) return _database!;

    return await initDB();
  }
  
  initDB() async {
    String path = Path.join(await getDatabasesPath(), 'ddtest.db');
    
    return await openDatabase(
      path,
      version: 1,  // DB의 업그레이드와 다운그레이드를 수행하기 위해 사용된다.
      onCreate: _onCreate,  // DB에 해당 테이블이 없으면 생성해준다.
      onUpgrade: _onUpgrade  // 이전 version과 업데이트 된 version을 비교하여 다를 경우 새로 업데이트 된 내용이 적용된다.
    );
  }
}

FutureOr<void> _onCreate(Database db, int version) {
  String sql = '''
  CREATE TABLE ddtest(
    seq INTEGER PRIMARY KEY AUTOINCREMENT,
    sum INTEGER default 0,
    preSum INTEGER default 0,
    i TEXT,
    u TEXT default "땃쥐2")
  ''';

  db.execute(sql);
}

FutureOr<void> _onUpgrade(Database db, int oldVersion, int newVersion) {}


// Widget _buttonView() {
//   return SizedBox(
//     height: 100,
//     child: Row(
//       children: [
//         OutlinedButton(
//           onPressed: () {
//             var db = _model.database;
//           },
//           child: Text('DB 생성')
//         )
//       ],
//     ),
//   );
// }

// Future<void> iInsert(String i) async {
//   var db = await database;
//   await db.update(
//     'ddtest',
//     {'i':i},
//     where: 'seq = ?',
//     whereArgs: [1]
//   );
// }

// final _model = SqliteTestModel();
