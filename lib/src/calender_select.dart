import 'package:chinese_calendar/chinese_calendar.dart';
import 'package:flutter/material.dart';

/**
 * author:heqian
 * date  :20-3-1 上午11:46
 * email :wskfjtheqian@163.com
 **/

///选择日期
class CalenderSelect extends StatefulWidget {
  ///初妈时间
  final DateTime initDateTime;

  ///开始时间
  final DateTime startDateTime;

  ///结束时间
  final DateTime endDateTime;

  final EdgeInsetsGeometry contentPadding;
  final CalendarUtils calendarUtils;
  final void Function(DateTime start, DateTime end) onSelect;

  ///是否选择范围
  final bool isRange;

  ///显示非当前月的天
  final bool showOtherDay;

  ///选择非当前月的天
  final bool selectOtherDay;

  ///显示农历
  final bool showLunary;

  CalenderSelect({
    Key key,
    this.initDateTime,
    this.contentPadding = const EdgeInsets.only(),
    this.startDateTime,
    this.endDateTime,
    this.calendarUtils,
    this.onSelect,
    this.isRange = true,
    this.showOtherDay,
    this.showLunary,
    this.selectOtherDay,
  })  : assert(null != initDateTime),
        super(key: key);

  @override
  _CalenderSelectState createState() => _CalenderSelectState();
}

class _CalenderSelectState extends State<CalenderSelect> {
  final Radius _radius = Radius.circular(50);
  TextStyle _dayStyle;
  TextStyle _garyStyle;
  TextStyle _lunarDayStyle;
  DateTime _start;
  DateTime _end;
  Color _selectColor;
  Color _selectTextColor;
  bool _lunary;
  bool _selectOtherDay;

  @override
  Widget build(BuildContext context) {
    CalenderThemeData theme = CalenderTheme.of(context);
    _dayStyle = theme?.dayStyle ?? TextStyle(color: Color(0xff000000));
    _garyStyle = theme?.garyStyle ?? TextStyle(color: Color(0xffcccccc));
    _lunarDayStyle = theme?.lunarDayStyle ?? TextStyle(color: Color(0xffcccccc), fontSize: 10);
    _selectColor = theme?.selectColor ?? Theme.of(context).primaryColor;
    _selectTextColor = theme?.selectTextColor ?? Colors.white;
    _lunary = widget.showLunary ?? theme?.showLunary ?? true;
    _selectOtherDay = widget.selectOtherDay ?? theme?.selectOtherDay ?? false;

    return Material(
      child: CalendarView(
        initDateTime: widget.initDateTime,
        startDateTime: widget.startDateTime,
        endDateTime: widget.endDateTime,
        contentPadding: widget.contentPadding,
        calendarUtils: widget.calendarUtils,
        builderItem: (info, child, month) => _builderItem(context, info, child, month),
        showOtherDay: widget.showOtherDay,
        showLunary: widget.showLunary,
      ),
    );
  }

  Widget _builderItem(BuildContext context, CalendarInfo info, Widget child, int month) {
    int start = CalendarUtils.compareDate(info.solarDate, _start);
    int end = CalendarUtils.compareDate(info.solarDate, _end);
    if (0 == start && null == end) {
      child = DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(_radius),
          color: _selectColor.withOpacity(0.8),
        ),
        child: _buildSelectChild(context, info, month),
      );
    } else if (0 == start && null != end) {
      child = DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: _radius, bottomLeft: _radius),
          color: _selectColor.withOpacity(0.8),
        ),
        child: _buildSelectChild(context, info, month),
      );
    } else if (0 == end && null == start) {
      child = DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(_radius),
          color: _selectColor.withOpacity(0.8),
        ),
        child: _buildSelectChild(context, info, month),
      );
    } else if (0 == end && null != start) {
      child = DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topRight: _radius, bottomRight: _radius),
          color: _selectColor.withOpacity(0.8),
        ),
        child: _buildSelectChild(context, info, month),
      );
    } else if (1 == start && -1 == end && (month == info.solarDate.month || _selectOtherDay)) {
      child = DecoratedBox(
        decoration: BoxDecoration(
          color: _selectColor.withOpacity(0.2),
        ),
        child: child,
      );
    }

    return month == info.solarDate.month || _selectOtherDay
        ? InkWell(
            child: child,
            onTap: () {
              setState(() {
                if (null != _start && null != _end) {
                  _start = _end = null;
                }

                if (null == _start || true != widget.isRange) {
                  _start = info.solarDate;
                } else {
                  int temp = CalendarUtils.compareDate(info.solarDate, _start);
                  if (0 == temp) {
                    return;
                  }
                  if (-1 == temp) {
                    _end = _start;
                    _start = info.solarDate;
                  } else {
                    _end = info.solarDate;
                  }
                }
                if (null != widget.onSelect) {
                  widget.onSelect(_start, _end);
                }
              });
            },
          )
        : child;
  }

  _buildSelectChild(BuildContext context, CalendarInfo info, int month) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          info.solarDate.day.toString().padLeft(2, "0"),
          style: month == month ? _dayStyle.copyWith(color: _selectTextColor) : _garyStyle.copyWith(color: _selectTextColor),
        ),
      ]..addAll(_lunary
          ? [
              Text(
                info.lunarFestival ?? info.festival ?? info.term ?? info.lunarDayName,
                style: _lunarDayStyle.copyWith(color: _selectTextColor),
                overflow: TextOverflow.clip,
              )
            ]
          : []),
    );
  }
}

Future<List<DateTime>> showDateRangePicker({
  BuildContext context,

  ///是否选择范围
  bool isRange = true,

  ///初妈时间
  DateTime initDateTime,

  ///开始时间
  DateTime startDateTime,

  ///结束时间
  DateTime endDateTime,
  CalendarUtils calendarUtils,

  ///显示非当前月的天
  bool showOtherDay,

  ///选择非当前月的天
  bool selectOtherDay,

  ///显示农历
  bool showLunary,
}) {
  assert(null != context);
  assert(null != initDateTime);
  return showDialog(
    context: context,
    builder: (context) {
      List<DateTime> _list = [];
      return Center(
        child: SizedBox(
          width: 334,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            child: Material(
              child: Container(
                padding: EdgeInsets.only(top: 24, left: 12, bottom: 12, right: 12),
                child: StatefulBuilder(builder: (context, state) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      CalenderSelect(
                        initDateTime: initDateTime,
                        isRange: isRange,
                        startDateTime: startDateTime,
                        endDateTime: endDateTime,
                        calendarUtils: calendarUtils,
                        showOtherDay: showOtherDay,
                        selectOtherDay: selectOtherDay,
                        showLunary: showLunary,
                        onSelect: (start, end) {
                          state(() {
                            _list = [];
                            if (null != start) {
                              _list.add(start);
                            }
                            if (null != end) {
                              _list.add(end);
                            }
                          });
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            FlatButton(
                              child: Text("取消"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            SizedBox(width: 12),
                            RaisedButton(
                              color: Theme.of(context).primaryColor,
                              child: Text(
                                "确定",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: (isRange ? 2 == _list.length : 1 == _list.length)
                                  ? () {
                                      Navigator.of(context).pop(_list);
                                    }
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ),
      );
    },
  );
}
