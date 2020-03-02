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

  final EdgeInsetsGeometry contentPadding;
  final CalendarUtils calendarUtils;

  final Widget Function(CalendarInfo info, Widget child, int month) builderItem;
  final Widget Function(DateTime dateTime) onChange;

  ///显示非当前月的天
  final bool showOtherDay;

  ///显示农历
  final bool showLunary;

  const CalendarView({
    Key key,
    this.initDateTime,
    this.contentPadding = const EdgeInsets.only(),
    this.builderItem,
    this.startDateTime,
    this.endDateTime,
    this.calendarUtils,
    this.onChange,
    this.showOtherDay,
    this.showLunary,
  })  : assert(null != initDateTime),
        assert(null != contentPadding),
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
  CalendarInfo _toDayInfo;

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
    _endDateTime = widget.endDateTime ?? DateTime(2100);
    _controller = PageController(initialPage: (_dateTime.year - _startDateTime.year) * 12 + _dateTime.month - (_startDateTime.month - 1));
    _toDayInfo = _calendarUtils.getInfo(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 370,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          StatefulBuilder(
            key: _weekKey,
            builder: (context, state) {
              return _CalenderTitle(
                dateTime: _dateTime,
                onChange: _onChanged,
                info: _info,
                showLunary: widget.showLunary,
              );
            },
          ),
          _buildToDay(context),
          Expanded(
            child: Padding(
              padding: widget.contentPadding,
              child: PageView.builder(
                controller: _controller,
                itemCount: (_endDateTime.year - _startDateTime.year) * 12 + (_endDateTime.month + 1) - (_startDateTime.month - 1),
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) {
                  return _CalenderContent(
                    builderItem: widget.builderItem,
                    dateTime: DateTime(_startDateTime.year + index ~/ 12, index % 12),
                    calendarUtils: _calendarUtils,
                    showOtherDay: widget.showOtherDay,
                    showLunary: widget.showLunary,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void toDay() {
    var now = DateTime.now();
    var index = (now.year - _startDateTime.year) * 12 + now.month - (_startDateTime.month - 1);
    _controller.animateToPage(index.toInt(), duration: Duration(milliseconds: 300), curve: ElasticInOutCurve());
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

  _buildToDay(BuildContext context) {
    CalenderThemeData theme = CalenderTheme.of(context);
    var style = theme?.todayStyle ?? TextStyle(color: Theme.of(context).accentColor, fontSize: 12);
    return Padding(
      padding: EdgeInsets.only(top: 6, right: 4),
      child: Align(
        alignment: Alignment.centerRight,
        child: InkWell(
          child: Text(
            "今天 "
            "${_toDayInfo.solarDate.month.toString().padLeft(2, "0")}月"
            "${_toDayInfo.solarDate.day.toString().padLeft(2, "0")}日"
            "\u3000${_toDayInfo.astro}"
            "\u3000${_toDayInfo.lunarMonthName}${_toDayInfo.lunarDayName}",
            style: style,
          ),
          onTap: toDay,
        ),
      ),
    );
  }
}

class _CalenderContent extends StatelessWidget {
  final DateTime dateTime;
  final Widget Function(CalendarInfo info, Widget child, int month) builderItem;
  CalendarUtils calendarUtils;
  final bool showOtherDay;
  final bool showLunary;

  _CalenderContent({
    Key key,
    this.dateTime,
    this.builderItem,
    this.calendarUtils,
    this.showOtherDay,
    this.showLunary,
  })  : assert(null != dateTime),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var temp = DateTime(dateTime.year, dateTime.month);
    int start = 7 == temp.weekday ? 0 : -temp.weekday;
    CalenderThemeData theme = CalenderTheme.of(context);
    TextStyle dayStyle = theme?.dayStyle ?? TextStyle(color: Color(0xff000000));
    TextStyle weekStyle = theme?.weekStyle ?? TextStyle(color: Color(0xff000000), fontSize: 16);
    TextStyle garyStyle = theme?.garyStyle ?? TextStyle(color: Color(0xffcccccc));
    TextStyle lunarDayStyle = theme?.lunarDayStyle ?? TextStyle(color: Color(0xffcccccc), fontSize: 10);
    bool otherDay = showOtherDay ?? theme?.showOtherDay ?? false;
    bool lunary = showLunary ?? theme?.showLunary ?? true;
    DateTime now = DateTime.now();
    Color todayColor = theme?.todayColor ?? Colors.orange;
    Color todayTextColor = theme?.todayTextColor ?? Colors.white;

    return LayoutBuilder(
      builder: (context, constraints) {
        var width = constraints.biggest.width / 7;
        var height = (constraints.biggest.height - 6) / 7;
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              padding: EdgeInsets.only(top: 18, bottom: 6),
              margin: EdgeInsets.only(bottom: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _weekTexts.map((item) {
                  return SizedBox(
                    width: width,
                    child: Center(
                      child: Text(item, style: weekStyle),
                    ),
                  );
                }).toList(),
              ),
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor))),
            ),
          ]..addAll(List.generate(6, (i) => i).map((c) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(7, (i) => i).map((r) {
                  var dayDate = temp.add(Duration(days: start + c * 7 + r));

                  var info = calendarUtils.getInfo(dayDate);
                  bool isToday = 0 == CalendarUtils.compareDate(now, info.solarDate);
                  Widget child;
                  if (dateTime.month == dayDate.month || otherDay) {
                    child = Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          dayDate.day.toString().padLeft(2, "0"),
                          style: dateTime.month == dayDate.month
                              ? (isToday ? dayStyle.copyWith(color: todayTextColor) : dayStyle)
                              : (isToday ? garyStyle.copyWith(color: todayTextColor) : garyStyle),
                        ),
                      ]..addAll(lunary
                          ? [
                              Text(
                                info.lunarFestival ?? info.festival ?? info.term ?? info.lunarDayName,
                                style: (isToday ? lunarDayStyle.copyWith(color: todayTextColor) : lunarDayStyle),
                                overflow: TextOverflow.clip,
                              )
                            ]
                          : []),
                    );
                    if (null != builderItem) {
                      child = builderItem(info, child, dateTime.month);
                    }
                  }

                  return Container(
                    width: width,
                    height: height - 6,
                    margin: EdgeInsets.symmetric(vertical: 3),
                    child: child,
                    decoration: (dateTime.month == dayDate.month || otherDay) && isToday
                        ? BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            color: todayColor,
                          )
                        : null,
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
  final CalendarInfo info;
  final bool showLunary;

  const _CalenderTitle({
    Key key,
    this.dateTime,
    this.onChange,
    this.info,
    this.showLunary,
  })  : assert(null != dateTime),
        assert(null != onChange),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    CalenderThemeData theme = CalenderTheme.of(context);
    TextStyle titleStyle = theme?.titleStyle ?? TextStyle(color: Color(0xff000000), fontSize: 17);
    bool lunary = showLunary ?? theme?.showLunary ?? true;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              text: "${dateTime.year.toString().padLeft(4, "0")}年${dateTime.month.toString().padLeft(2, "0")}月" +
                  (lunary ? "\u3000${info.gzYear}${info.animal}年" : "")),
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
