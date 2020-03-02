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
                return BasePage();
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

class BasePage extends StatefulWidget {
  @override
  _BasePageState createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  CalendarInfo _clickInfo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(24),
            child: CalendarView(
              initDateTime: DateTime.now(),
              builderItem: _builderItem,
            ),
          ),
          Text(""),
          Text("${_clickInfo?.solarDate?.toString()?.substring(0, 10)}"),
          Text("${_clickInfo?.lunarYearName}年${_clickInfo?.lunarMonthName}${_clickInfo?.lunarDayName}"),
          Text("${_clickInfo?.animal}"),
          Text("${_clickInfo?.astro}"),
          Text("${_clickInfo?.term}"),
          Text("${_clickInfo?.festival}"),
          Text("${_clickInfo?.lunarFestival}"),
        ],
      ),
    );
  }

  Widget _builderItem(CalendarInfo info, Widget child, int month) {
    if (null != _clickInfo && 0 == CalendarUtils.compareDate(_clickInfo.solarDate, info.solarDate)) {
      child = DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).accentColor),
        ),
        child: child,
      );
    }

    return InkWell(
      child: child,
      onTap: () {
        setState(() {
          _clickInfo = info;
        });
      },
    );
  }
}

class SelelctDatePage extends StatefulWidget {
  @override
  _SelelctDatePageState createState() => _SelelctDatePageState();
}

class _SelelctDatePageState extends State<SelelctDatePage> {
  DateTime _start;
  DateTime _end;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(24),
            child: CalenderSelect(
              initDateTime: DateTime.now(),
              showOtherDay: true,
              showLunary: false,
              onSelect: (start, end) {
                setState(() {
                  _start = start;
                  _end = end;
                });
              },
            ),
          ),
          Text(""),
          Text("开始 ${_start?.toString()?.substring(0, 10)}"),
          Text("结束 ${_end?.toString()?.substring(0, 10)}"),
        ],
      ),
    );
  }
}
