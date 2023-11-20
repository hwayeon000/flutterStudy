import 'package:flutter/material.dart';

class NextScreen extends StatelessWidget{
  const NextScreen({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.teal,
            title: Text('Navi'),
          ),
          body: TabBarView(
            children: [
              Center(
                child: Text("home"),
              ),
              Center(
                child: Text("music"),
              ),
              Center(
                child: Text("apps"),
              ),
              Center(
                child: Text("settings"),
              ),
            ],
          ),
          extendBodyBehindAppBar: true, // add this line

          bottomNavigationBar: Container(
            color: Colors.white, //색상
            child: Container(
              height: 70,
              padding: EdgeInsets.only(bottom: 10, top: 5),
              child: const TabBar(
                //tab 하단 indicator size -> .label = label의 길이
                //tab 하단 indicator size -> .tab = tab의 길이
                indicatorSize: TabBarIndicatorSize.label,
                //tab 하단 indicator color
                indicatorColor: Colors.teal,
                //tab 하단 indicator weight
                indicatorWeight: 2,
                //label color
                labelColor: Colors.teal,
                //unselected label color
                unselectedLabelColor: Colors.black38,
                labelStyle: TextStyle(
                  fontSize: 13,
                ),
                tabs: [
                  Tab(
                    icon: Icon(
                      Icons.home_outlined,
                    ),
                    text: 'Home',
                  ),
                  Tab(
                    icon: Icon(Icons.music_note),
                    text: 'Music',
                  ),
                  Tab(
                    icon: Icon(
                      Icons.apps,
                    ),
                    text: 'Apps',
                  ),
                  Tab(
                    icon: Icon(
                      Icons.settings,
                    ),
                    text: 'Settings',
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

//     return MaterialApp(
//       // home: Text('안녕')
//       // home: Icon(Icons.star)
//       // home: Image.asset('2.png') // 원래 경로는 이게 맞음 'assets/2.png'
//       // home: Center(
//       //   child: Container( width: 50, height: 50, color: Colors.blue)  // 50LP == 1.2cm , LP는 flutter 단위,
//       // ),
//       home: Scaffold( // app 상 중 하 나눠 주는 Layout
//         appBar: AppBar(
//           title: Text('앱임'),
//         ), // 상단
//         body: Container(
//
//           child: Text('안녕'),
//
//         ),  // 중앙
//         bottomNavigationBar: Row(  // Column 세로 정렬, Row 가로 정렬
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,  // 가로축 정렬
//           // crossAxisAlignment: CrossAxisAlignment.center, // 세로축 정렬
//           children: [
//           Icon(Icons.phone),
//           Icon(Icons.message),
//           Icon(Icons.contact_page),
//         ],
//         ), // 하단
//       ),
//
//       );
//
//   }
}
