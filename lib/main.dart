import 'dart:ffi';

import 'package:ddutch/next_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
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

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }  // 원래 예제 있던 증가 함수
  
  
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
      _counter=int.parse(myController.text);
    });
    super.dispose();
  } // 팝업


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
            // input 창
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                controller: myController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '금액 입력',
                ),
              ),
            ),
            const Text(
              '현재까지 금액:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
      floatingActionButton: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment(
              Alignment.bottomRight.x, Alignment.bottomRight.y -0.2),
              child: FloatingActionButton(
                onPressed: (){
                  Navigator.push(
                    context,
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
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      // Retrieve the text the that user has entered by using the
                      // TextEditingController.
                      content: Text(myController.text),
                    );
                  },
                );
              },
              tooltip: 'Show value',
              child: Icon(Icons.add),
            ),
          )],
          
          // Align(
          //   alignment: Alignment.bottomRight,
          //   child: FloatingActionButton(
          //     onPressed: _incrementCounter,
          //     tooltip: 'Increment',
          //     child: Icon(Icons.add),
          //   ),
          // )],
      ),

    );
  }
}


