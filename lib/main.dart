import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// DB
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as Path;
import 'model.dart' as model;
import 'package:ddutch/DBHelper.dart';

const Color darkBlue = Color.fromARGB(255, 18, 32, 47);

void main() {
  runApp(MyApp());
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SetName(title: 'DD의 땃쥐페이'), 
    ),
    
    GoRoute(
      name: 'homePage',
      path: '/homePage',
      builder: (context, state) => const HomePage(title: 'DD의 땃쥐'), 
      routes: [
        GoRoute(
          name: 'studentA',
          path : 'studentA', 
          builder: (context, state) => StudentA(title: 'DB check'),   
        ),
        
      ],
    ),
    
    GoRoute(
      name : 'classB',
      path: '/classB',
      builder: (context, state) => ClassB(), 
      routes : [
        GoRoute(
          name: 'studentB', 
          path: 'studentB',
          builder: (context, state) => StudentB(), 
          
        ),
      ],
    ),
  ],
  // loginState 상태를 지켜본다.
  // refreshListenable: loginState,
  // 개발시 디버그하기, 앱출시에는 false 로 변경해야한다.
  debugLogDiagnostics: true,
);

class ddutch {
  final int? seq;
  final int? sum;
  final int? preSum;
  final String? i;
  final String? u;

  ddutch({
    this.seq,
    this.sum,
    this.preSum,
    this.i,
    this.u
  });

  Map<String, dynamic> toMap(){
    return {
      'seq' : this.seq,
      'sum': this.sum,
      'preSum': this.preSum,
      'i' : this.i,
      'u' : this.u,
    };
  }

}

List<ddutch> _dataList = [];
// List<Map<String, dynamic>> _dataList = [];
int seq = 1;
// DB에서 데이터 꺼내로기
void getData() async {
  _dataList = (await DBHelper().selectData());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // theme: ThemeData.dark().copyWith(
      //   scaffoldBackgroundColor: darkBlue,
      // ),
      debugShowCheckedModeBanner: false,
      title: 'Go router',
    );
  }
}

class SetName extends StatefulWidget {
  const SetName({super.key, required this.title});
  final String title;
  @override
  State<SetName> createState() => _SetNameState();
}

class _SetNameState extends State<SetName> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final TextEditingController _textFieldController = TextEditingController();
  // 텍스트 필드 null 체크
  bool _validate = false;
  // final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar : AppBar (
        title: const Text('DD\'s 땃쥐페이'),
      ),
      body : Center(
        child : Column(
          mainAxisAlignment : MainAxisAlignment.center,
          children: <Widget>[
            // input 창
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                controller: _textFieldController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '이름을 입력해주세요.',
                  errorText: _validate ? '값을 입력하세요.' : null,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                // 텍스트 필드 null값이면
                setState(() {
                  _textFieldController.text.isEmpty? _validate = true : _validate = false;
                });
                if(!_validate){
                  //dd
                  // await DBHelper().insertMyName(_textFieldController.text);
                  await DBHelper().updateMyName(seq, _textFieldController.text);
                  context.go('/homePage');
                }
                // 텍스트 필드 초기화
                _textFieldController.clear();
              },
              child: const Text('set name'),
            ),
            const SizedBox(height: 20), 
            ElevatedButton(
              onPressed: () => context.pushNamed('homePage'),
              child: const Text('home'),
            ),
            ElevatedButton(
              onPressed: () => context.pushNamed('classB'),
              child: const Text('classB'),
            ),
          ],  
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar : AppBar (
        title: const Text('homePage'),
      ),
      body : Center(
        child : Column(
          mainAxisAlignment : MainAxisAlignment.center,
          children: [
            // Text(_dataList[0]['i']),
            ElevatedButton(
              onPressed: () => context.go('/homePage/studentA'),
              child: Text('homePage'),
            ),
          ],    
        ),
      ),
    );
  }
}

class StudentA extends StatefulWidget {
  const StudentA({super.key, required this.title});
  final String title;
  @override
  State<StudentA> createState() => _StudentA();
}

class _StudentA extends State<StudentA> {
  @override
  Widget build(BuildContext context) {
    // 데이터 로딩
    // var dataList = DBHelper().selectData() as List<Map<String, dynamic>>;
    // var dataList = DBHelper().selectData();
    getData();
    return Scaffold(
      appBar : AppBar (
        title: const Text('StudentA'),
      ),
      body : Center(
        child : Column(
          mainAxisAlignment : MainAxisAlignment.center,
          children: [
            Text(_dataList[0].u.toString()),
            const Text(selectionColor: Colors.teal,'This is Student A'),
          ],
        ),
      ),
    );
  }
}

class ClassB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar : AppBar (
        title: const Text('ClassB'),
      ),
      body : Center(
        child : Column(
          mainAxisAlignment : MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => context.pushNamed('studentB'),
              child: const Text('studentB'),
            ),
          ],    
        ),
      ),
    );
  }
}

class StudentB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar : AppBar (
        title: const Text('StudentB'),
      ),
      body : Center(
        child : Column(
          mainAxisAlignment : MainAxisAlignment.center,
          children: [
            const Text('This is Student B'),
          ],    
        ),
      ),
    );
  }
}
