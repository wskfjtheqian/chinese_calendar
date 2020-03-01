import 'package:chinese_calendar/chinese_calendar.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text("日历控件"),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return;
              }));
            },
          ),
          ListTile(
            title: Text("选择日期范围"),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return SelelctDatePage();
              }));
            },
          ),
          ListTile(
            title: Text("选择日期对话框"),
            onTap: () {
              showDateRangePicker(context: context, initDateTime: DateTime.now());
            },
          ),
        ],
      ),
    );
  }
}

//class MyHomePage extends StatefulWidget {
//  @override
//  _MyHomePageState createState() => _MyHomePageState();
//}
//
//class _MyHomePageState extends State<MyHomePage> {
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(),
//      body: Center(
//        child: Container(
//          child: CalendarView(
//            initDateTime: DateTime.now(),
//          ),
//        ),
//      ),
//    );
//  }
//}

class SelelctDatePage extends StatefulWidget {
  @override
  _SelelctDatePageState createState() => _SelelctDatePageState();
}

class _SelelctDatePageState extends State<SelelctDatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: CalenderSelect(
            initDateTime: DateTime.now(),
          ),
        ),
      ),
    );
  }
}
