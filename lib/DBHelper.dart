import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
 
class DBHelper {
  static final DBHelper _instance = DBHelper._(); // DBHelper의 싱글톤 객체 생성
  static Database? _database; // 데이터베이스 인스턴스를 저장하는 변수
 
  DBHelper._(); // DBHelper 생성자(private)
 
  factory DBHelper() => _instance; // DBHelper 인스턴스 반환 메소드
 
  // 데이터베이스 인스턴스를 가져오는 메소드
  Future<Database> get database async {
    if (_database != null) {
      // 인스턴스가 이미 존재한다면
      return _database!; // 저장된 데이터베이스 인스턴스를 반환
    }
    _database = await _initDB(); // 데이터베이스 초기화
    return _database!; // 초기화된 데이터베이스 인스턴스 반환
  }
 
  // 데이터베이스 초기화 메소드
  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath(); // 데이터베이스 경로 가져오기
    final path = join(dbPath, 'ddutch.db'); // 데이터베이스 파일 경로 생성
    return await openDatabase(
      path, // 데이터베이스 파일 경로
      version: 1, // 데이터베이스 버전
      onCreate: (db, version) async {
        await db.execute(
          // SQL 쿼리를 실행하여 데이터베이스 테이블 생성
          'CREATE TABLE ddutch(seq INTEGER PRIMARY KEY AUTOINCREMENT, sum INTEGER default 0, preSum INTEGER default 0, i TEXT default "땃쥐1", u TEXT default "땃쥐2")',
        );
      },
    );
  }


// 내 닉네임 입력 및 수정, 상대 닉 업데이트
// 금액 입력 및 되돌리기
// 초기화는 없음


  // 데이터 추가 메소드
  Future<void> insertMyName(String i) async {
    final db = await database; // 데이터베이스 인스턴스 가져오기
    await db.insert(
      'ddutch', // 데이터를 추가할 테이블 이름
      {
        'i': i,
      }, // 추가할 데이터
      conflictAlgorithm: ConflictAlgorithm.replace, // 중복 데이터 처리 방법 설정
    );
  }
 
   // 사용자 이름 수정 메소드
  Future<void> updateMyName(int seq, String i) async {
    final db = await database; // 데이터베이스 인스턴스 가져오기
    await db.update(
      'ddutch', // 데이터를 추가할 테이블 이름
      {
        'i': i,
      }, // 추가할 데이터
      where: 'seq = ?', // 수정할 데이터의 조건 설정
      whereArgs: [seq], // 수정할 데이터의 조건 값
      conflictAlgorithm: ConflictAlgorithm.replace, // 중복 데이터 처리 방법 설정
    );
  }
 
   // 상대 이름 수정 메소드
  Future<void> updateOppopnentName(int seq, String u) async {
    final db = await database; // 데이터베이스 인스턴스 가져오기
    await db.update(
      'ddutch', // 데이터를 추가할 테이블 이름
      {
        'u': u,
      }, // 추가할 데이터
      where: 'seq = ?', // 수정할 데이터의 조건 설정
      whereArgs: [seq], // 수정할 데이터의 조건 값
      conflictAlgorithm: ConflictAlgorithm.replace, // 중복 데이터 처리 방법 설정
    );
  }


   // 가격 입력 메소드
  Future<void> updatePrice(int seq, int price, int prePrice) async {
    final db = await database; // 데이터베이스 인스턴스 가져오기
    await db.update(
      'ddutch', // 데이터를 추가할 테이블 이름
      {
        'sum': prePrice+price,
        'preSum': prePrice,
      }, // 추가할 데이터
      where: 'seq = ?', // 수정할 데이터의 조건 설정
      whereArgs: [seq], // 수정할 데이터의 조건 값
      conflictAlgorithm: ConflictAlgorithm.replace, // 중복 데이터 처리 방법 설정
    );
  }

   // 이전 금액으로 되돌리기 메소드: 이전 금액은 그대로 둘까 0으로 바꿀까?
  Future<void> updatePrePrice(int seq, int prePrice) async {
    final db = await database; // 데이터베이스 인스턴스 가져오기
    await db.update(
      'ddutch', // 데이터를 추가할 테이블 이름
      {
        'sum': prePrice,
      }, // 추가할 데이터
      where: 'seq = ?', // 수정할 데이터의 조건 설정
      whereArgs: [seq], // 수정할 데이터의 조건 값
      conflictAlgorithm: ConflictAlgorithm.replace, // 중복 데이터 처리 방법 설정
    );
  }


  // 데이터 조회 메소드
  Future<List<Map<String, dynamic>>> selectData() async {
    final db = await database; // 데이터베이스 인스턴스 가져오기
    return await db.query('example'); // 데이터베이스에서 모든 데이터 조회
    // return await db.query('ddutch'); // 데이터베이스에서 모든 데이터 조회
  }
 


}