import 'package:ddutch/next_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// 블투
import 'package:flutter_native_splash/flutter_native_splash.dart';
// DB
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';


void main() {
  // 블투 2줄, 안됨..
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
  int _counter = 0;
  // 나중에 DB값 가져와 셋팅 변경
  int price=0;
  int prePrice=0;
  // the initState method, and clean it up in the dispose method.
  late FocusNode myFocusNode;


  void _calPrice(int n) {
    setState(() {
      // _counter++;
      if (n==0){
        prePrice=price;
        price += int.parse(myController.text);
      } else{
        price =prePrice;
      }
    });
  } 
  


  
  // 텍스트 팝업? 위한 함수
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final myController = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    setState(() {
      // 입력값 숫자 형변환 후 금액 셋팅
      // _counter=int.parse(myController.text);
      price = int.parse(myController.text);
    });
    super.dispose();
  } // 팝업



  // 자동 텍스트 필드 포커스
  @override
  void initState() {
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
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: TextField(
                // 텍스트 필드 포커스 사용
                autofocus: true,
                controller: myController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '금액 입력',
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
              Alignment.bottomRight.x, Alignment.bottomRight.y -0.2),
              child: FloatingActionButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    // 페이지 이동
                    MaterialPageRoute(builder: (context)=>const NextScreen()),
                    );
                },
                tooltip: '새로고침',
                child: Icon(Icons.refresh),
                ),
          ),
          
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              onPressed: (){
                
                // 상대 동의 얻을 방법 고민해보기
                // 동의 얻은 후 진행해야 함
                _calPrice(0);

                // 스낵바
                final snackBar = SnackBar(
                  content: const Text('입력중입니다.'),
                  action: SnackBarAction(label: '취소',
                  onPressed: () {
                    // 취소 하면 진행할 것 넣어..
                    _calPrice(1);
                  },),
                );
                // 스낵바 보여주기
                ScaffoldMessenger.of(context).showSnackBar(snackBar);

                // 텍스트 필드 초기화
                myController.clear();

                // showDialog(
                //   context: context,
                //   builder: (context) {
                //     return AlertDialog(
                //       // 금액 입력 후 누를 버튼
                //       content: Text(myController.text),
                //     );
                //   },
                // );
              },
              tooltip: '값 보여주기',
              child: Icon(Icons.add),
            ),
          )],
      ),

    );
  }
}


