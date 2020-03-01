/**
 * author:heqian
 * date  :20-2-29 下午6:02
 * email :wskfjtheqian@163.com
 **/

import 'package:flutter/material.dart';

import '../chinese_calendar.dart';

final _weekTexts = const ["日", "一", "二", "三", "四", "五", "六"];

///带有农历的日历
class CalendarView extends StatefulWidget {
  ///初妈时间
  final DateTime initDateTime;

  ///开始时间
  final DateTime startDateTime;

  ///结束时间
  final DateTime endDateTime;

  final TextStyle dayStyle;
  final TextStyle garyStyle;
  final EdgeInsetsGeometry contentPadding;
  final TextStyle titleStyle;
  final CalendarUtils calendarUtils;

  final Widget Function(CalendarInfo info, Widget child) builderItem;
  final Widget Function(DateTime dateTime) onChange;

  const CalendarView({
    Key key,
    this.initDateTime,
    this.contentPadding = const EdgeInsets.only(),
    this.dayStyle = const TextStyle(color: Color(0xff000000)),
    this.garyStyle = const TextStyle(color: Color(0xffdddddd)),
    this.builderItem,
    this.startDateTime,
    this.endDateTime,
    this.titleStyle = const TextStyle(color: Color(0xff000000)),
    this.calendarUtils,
    this.onChange,
  })  : assert(null != initDateTime),
        assert(null != contentPadding),
        assert(null != dayStyle),
        assert(null != garyStyle),
        super(key: key);

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  DateTime _dateTime;
  DateTime _startDateTime;
  DateTime _endDateTime;
  PageController _controller;
  CalendarInfo _info;
  CalendarUtils _calendarUtils;
  var _weekKey = GlobalKey();

  set dateTime(DateTime value) {
    _dateTime = value;
    _info = _calendarUtils.getInfo(value);
  }

  @override
  void initState() {
    super.initState();
    _calendarUtils = widget.calendarUtils ?? CalendarUtils();
    dateTime = widget.initDateTime ?? DateTime.now();
    _startDateTime = widget.startDateTime ?? DateTime(1900);
    _endDateTime = widget.endDateTime ?? DateTime(3000);
    _controller = PageController(initialPage: (_dateTime.year - _startDateTime.year) * 12 + _dateTime.month - (_startDateTime.month - 1));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 380,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          StatefulBuilder(
            key: _weekKey,
            builder: (context, state) {
              return _CalenderTitle(
                titleStyle: widget.titleStyle,
                dateTime: _dateTime,
                onChange: _onChanged,
                info: _info,
              );
            },
          ),
          Expanded(
            child: Padding(
              padding: widget.contentPadding,
              child: PageView.builder(
                controller: _controller,
                itemCount: (_endDateTime.year - _startDateTime.year) * 12 + (_endDateTime.month + 1) - (_startDateTime.month - 1),
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) {
                  return _CalenderContent(
                    dayStyle: widget.dayStyle,
                    garyStyle: widget.garyStyle,
                    builderItem: widget.builderItem,
                    dateTime: DateTime(_startDateTime.year + index ~/ 12, index % 12),
                    calendarUtils: _calendarUtils,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onChanged(int value) {
    _controller.animateToPage((_controller.page + value).toInt(), duration: Duration(milliseconds: 300), curve: ElasticInOutCurve());
  }

  void _onPageChanged(int index) {
    _weekKey.currentState.setState(() {
      dateTime = DateTime(_startDateTime.year + index ~/ 12, index % 12);
    });
    if (null != widget.onChange) {
      widget.onChange(_dateTime);
    }
  }
}

class _CalenderContent extends StatelessWidget {
  final DateTime dateTime;
  final Widget Function(CalendarInfo info, Widget child) builderItem;
  final TextStyle dayStyle;
  final TextStyle garyStyle;
  CalendarUtils calendarUtils;

  _CalenderContent({
    Key key,
    this.dateTime,
    this.builderItem,
    this.dayStyle,
    this.garyStyle,
    this.calendarUtils,
  })  : assert(null != dateTime),
        assert(null != dayStyle),
        assert(null != garyStyle),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var temp = DateTime(dateTime.year, dateTime.month);
    int start = 7 == temp.weekday ? 0 : -temp.weekday;

    return LayoutBuilder(
      builder: (context, constraints) {
        var width = constraints.biggest.width / 7;
        var height = constraints.biggest.height / 7;
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _weekTexts.map((item) {
                return SizedBox(
                  width: width,
                  height: height,
                  child: Center(
                    child: Text(item),
                  ),
                );
              }).toList(),
            ),
          ]..addAll(List.generate(6, (i) => i).map((c) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(7, (i) => i).map((r) {
                  var dayDate = temp.add(Duration(days: start + c * 7 + r));

                  var info = calendarUtils.getInfo(dayDate);
                  Widget child = Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        dayDate.day.toString().padLeft(2, "0"),
                        style: dateTime.month == dayDate.month ? dayStyle : garyStyle,
                      ),
                      Text(
                        info.lunarFestival ?? info.festival ?? info.term ?? info.lunarDayName,
                        style: garyStyle.copyWith(fontSize: 10),
                        overflow: TextOverflow.clip,
                      ),
                    ],
                  );
                  if (null != builderItem) {
                    child = builderItem(info, child);
                  }
                  return Container(
                    width: width,
                    height: height,
                    padding: EdgeInsets.symmetric(vertical: 3),
                    child: child,
                  );
                }).toList(),
              );
            }).toList()),
        );
      },
    );
  }
}

class _CalenderTitle extends StatelessWidget {
  final DateTime dateTime;
  final void Function(int number) onChange;
  final TextStyle titleStyle;
  final CalendarInfo info;

  const _CalenderTitle({
    Key key,
    this.dateTime,
    this.onChange,
    this.titleStyle,
    this.info,
  })  : assert(null != dateTime),
        assert(null != onChange),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
              child: Icon(Icons.first_page),
              onTap: () => onChange(-12),
            ),
            InkWell(
              child: Icon(Icons.keyboard_arrow_left),
              onTap: () => onChange(-1),
            ),
          ],
        ),
        Text.rich(
          TextSpan(
              text: "${dateTime.year.toString().padLeft(4, "0")}年${dateTime.month.toString().padLeft(2, "0")}月\u3000"
                  "${info.gzYear}${info.animal}年"),
          style: titleStyle,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
              child: Icon(Icons.keyboard_arrow_right),
              onTap: () => onChange(1),
            ),
            InkWell(
              child: Icon(Icons.last_page),
              onTap: () => onChange(12),
            ),
          ],
        ),
      ],
    );
  }
}
