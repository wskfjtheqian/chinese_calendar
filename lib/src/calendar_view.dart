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
  final Widget Function(CalendarInfo info, Widget child) builderItem;
  final Widget Function(DateTime dateTime) onChange;
  final TextStyle titleStyle;
  final CalendarUtils calendarUtils;

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
  DateTime dateTime;
  DateTime startDateTime;
  DateTime endDateTime;
  PageController _controller;

  var _weekKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    dateTime = widget.initDateTime ?? DateTime.now();
    startDateTime = widget.startDateTime ?? DateTime(1900);
    endDateTime = widget.endDateTime ?? DateTime(3000);
    _controller = PageController(initialPage: (dateTime.year - startDateTime.year) * 12 + dateTime.month - (startDateTime.month - 1));
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
                dateTime: dateTime,
                onChange: _onChanged,
              );
            },
          ),
          Expanded(
            child: Padding(
              padding: widget.contentPadding,
              child: PageView.builder(
                controller: _controller,
                itemCount: (endDateTime.year - startDateTime.year) * 12 + (endDateTime.month + 1) - (startDateTime.month - 1),
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) {
                  return _CalenderContent(
                    dayStyle: widget.dayStyle,
                    garyStyle: widget.garyStyle,
                    builderItem: widget.builderItem,
                    dateTime: DateTime(startDateTime.year + index ~/ 12, index % 12),
                    calendarUtils: widget.calendarUtils,
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
      dateTime = DateTime(startDateTime.year + index ~/ 12, index % 12);
    });
    if (null != widget.onChange) {
      widget.onChange(dateTime);
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
        super(key: key) {
    calendarUtils ??= CalendarUtils();
  }

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
                    padding: EdgeInsets.all(4),
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

  const _CalenderTitle({
    Key key,
    this.dateTime,
    this.onChange,
    this.titleStyle,
  })  : assert(null != dateTime),
        assert(null != onChange),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        InkWell(
          child: Icon(Icons.keyboard_arrow_left),
          onTap: () => onChange(-1),
        ),
        Text.rich(
          TextSpan(text: "${dateTime.year.toString().padLeft(4, "0")}年${dateTime.month.toString().padLeft(2, "0")}月"),
          style: titleStyle,
        ),
        InkWell(
          child: Icon(Icons.keyboard_arrow_right),
          onTap: () => onChange(1),
        ),
      ],
    );
  }
}
