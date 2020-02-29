# chinese_calendar

带有农历的日历

![输入图片说明](./readme.png?raw=true "在这里输入图片标题")

## Example

```dart

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Container(
          child: CalendarView(
            initDateTime: DateTime.now(),
          ),
        ),
      ),
    );
  }
}

```


