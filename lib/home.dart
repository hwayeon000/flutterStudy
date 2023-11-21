import 'package:ddutch/next_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// intro
import 'package:flutter_native_splash/flutter_native_splash.dart';
// DB
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as Path;
import 'package:flutter/services.dart';
import 'myPage.dart' as mp;


void main() {
  // intro
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const mp.MyPage(),
      home: const MyHomePage(title: 'DD의 땃쥐페이'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final TextEditingController _textFieldController = TextEditingController();
  // 텍스트 필드 null 체크
  bool _validate = false;
  // final myController = TextEditingController();
  List<Map<String, dynamic>> _dataList = [];

  // 데이터베이스 초기화 및 데이터 로딩
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // 데이터베이스 초기화
  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = Path.join(dbPath, 'ddutch.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          // 'CREATE TABLE example(id INTEGER PRIMARY KEY, name TEXT)',
          'CREATE TABLE ddutch(seq INTEGER PRIMARY KEY AUTOINCREMENT, sum INTEGER default 0, preSum INTEGER default 0, i TEXT default "땃쥐1", u TEXT default "땃쥐2")',
        );
      },
    );
  }

  // 데이터 로딩
  Future<void> _loadData() async {
    final db = await _initDB();
    final dataList = await db.query('ddutch');
    setState(() {
      _dataList = dataList;
    });
  }


  int _counter = 0;
  // 나중에 DB값 가져와 셋팅 변경
  int price=0;
  int prePrice=0;
  // the initText method, and clean it up in the dispose method.
  late FocusNode myFocusNode;

  void _calPrice(int n) {
    setState(() {
      // _counter++;
      if (n < 5){
        prePrice=price;
        price += (int.parse(_textFieldController.text) * n);
      } else{
        price =prePrice;
      }
    });
  } 

  // 자동 텍스트 필드 포커스
  @override
  void initText() {
    super.initState();
    myFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              '현재까지 금액:',
            ),
            Text(
              // '$_counter',
              '$price',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            // input 창
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                // 텍스트 필드 포커스 사용
                autofocus: true,
                controller: _textFieldController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '금액 입력',
                  errorText: _validate ? '값을 입력해주세요.' : null,
                ),
                // 숫자만 입력 되도록 제한
                keyboardType: TextInputType.number,
                // inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
          ],
        ),
      ),

      // 플로팅 버튼 2개
      floatingActionButton: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment(
              Alignment.bottomRight.x, Alignment.bottomRight.y -0.4),
              child: FloatingActionButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    // 페이지 이동
                    MaterialPageRoute(builder: (context)=>const NextScreen()),
                    );
                },
                tooltip: '새로고침',
                child: Icon(Icons.refresh, color: Colors.deepPurple[900]),
                ),
          ),
          
          Align(
            alignment: Alignment(
              Alignment.bottomRight.x, Alignment.bottomRight.y -0.2),
              child: FloatingActionButton(
                onPressed: (){
                  // 텍스트 필드 null값이면
                  setState(() {
                    _textFieldController.text.isEmpty? _validate = true : _validate = false;
                  });

                  if (!_validate){
                    // 상대 동의 얻을 방법 고민해보기
                    // 동의 얻은 후 진행해야 함
                    _calPrice(1);

                    // 스낵바
                    final snackBar = SnackBar(
                      content: const Text('입력중입니다.'),
                      action: SnackBarAction(label: '취소',
                      onPressed: () {
                        // 취소 하면 진행할 것 넣어..
                        _calPrice(10);
                      },),
                    );
                    // 스낵바 보여주기
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);

                    // 텍스트 필드 초기화
                    _textFieldController.clear();
                  }
                },  
              tooltip: '값 보여주기',
              child: Icon(Icons.add, color: Colors.deepPurple[900]),
            ),
          ),

          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              onPressed: (){
                // 텍스트 필드 null값이면
                setState(() {
                  _textFieldController.text.isEmpty? _validate = true : _validate = false;
                });

                if (!_validate){
                  // 상대 동의 얻을 방법 고민해보기
                  // 동의 얻은 후 진행해야 함
                  _calPrice(-1);

                  // 스낵바
                  final snackBar = SnackBar(
                    content: const Text('입력중입니다.'),
                    action: SnackBarAction(label: '취소',
                    onPressed: () {
                      // 취소 하면 진행할 것 넣어..
                      _calPrice(10);
                    },),
                  );
                  // 스낵바 보여주기
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                  // 텍스트 필드 초기화
                  _textFieldController.clear();
                }

              },
              tooltip: '값 보여주기',
              child: Icon(Icons.minimize, color: Colors.deepPurple[900]),
            ),
          )],
      ),

    );
  }
}


