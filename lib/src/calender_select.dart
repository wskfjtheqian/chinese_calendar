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

  final TextStyle dayStyle;
  final TextStyle garyStyle;
  final EdgeInsetsGeometry contentPadding;
  final TextStyle titleStyle;
  final CalendarUtils calendarUtils;
  final Color selectColor;
  final void Function(DateTime start, DateTime end) onSelect;
  final bool isRange;

  CalenderSelect({
    Key key,
    this.initDateTime,
    this.contentPadding = const EdgeInsets.only(),
    this.dayStyle = const TextStyle(color: Color(0xff000000)),
    this.garyStyle = const TextStyle(color: Color(0xffdddddd)),
    this.startDateTime,
    this.endDateTime,
    this.titleStyle = const TextStyle(color: Color(0xff000000)),
    this.calendarUtils,
    this.selectColor,
    this.onSelect,
    this.isRange = true,
  })  : assert(null != initDateTime),
        super(key: key);

  @override
  _CalenderSelectState createState() => _CalenderSelectState();
}

class _CalenderSelectState extends State<CalenderSelect> {
  final Radius _radius = Radius.circular(50);
  DateTime _start;
  DateTime _end;
  Color _selectColor;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _selectColor = widget.selectColor ?? Theme.of(context).primaryColor;
    return Material(
      child: CalendarView(
        initDateTime: widget.initDateTime,
        startDateTime: widget.startDateTime,
        endDateTime: widget.endDateTime,
        garyStyle: widget.garyStyle,
        contentPadding: widget.contentPadding,
        titleStyle: widget.titleStyle,
        calendarUtils: widget.calendarUtils,
        builderItem: _builderItem,
        onChange: _onChange,
      ),
    );
  }

  Widget _builderItem(CalendarInfo info, Widget child) {
    int start = _compareDate(info.solarDate, _start);
    int end = _compareDate(info.solarDate, _end);
    if (0 == start && null == end) {
      child = DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(_radius),
          color: _selectColor,
        ),
        child: child,
      );
    } else if (0 == start && null != end) {
      child = DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: _radius, bottomLeft: _radius),
          color: _selectColor,
        ),
        child: child,
      );
    } else if (0 == end && null == start) {
      child = DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(_radius),
          color: _selectColor,
        ),
        child: child,
      );
    } else if (0 == end && null != start) {
      child = DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topRight: _radius, bottomRight: _radius),
          color: _selectColor,
        ),
        child: child,
      );
    } else if (1 == start && -1 == end) {
      child = DecoratedBox(
        decoration: BoxDecoration(
          color: _selectColor.withOpacity(0.2),
        ),
        child: child,
      );
    }

    return InkWell(
      child: child,
      onTap: () {
        setState(() {
          if (null != _start && null != _end) {
            _start = _end = null;
          }

          if (null == _start || true != widget.isRange) {
            _start = info.solarDate;
          } else {
            int temp = _compareDate(info.solarDate, _start);
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
    );
  }

  int _compareDate(DateTime date1, DateTime date2) {
    if (null == date1 || null == date2) {
      return null;
    }
    if (date1.year > date2.year) {
      return 1;
    } else if (date1.year < date2.year) {
      return -1;
    } else if (date1.month > date2.month) {
      return 1;
    } else if (date1.month < date2.month) {
      return -1;
    } else if (date1.day > date2.day) {
      return 1;
    } else if (date1.day < date2.day) {
      return -1;
    }
    return 0;
  }

  Widget _onChange(DateTime dateTime) {}
}

Future<List<DateTime>> showDateRangePicker({
  BuildContext context,
  DateTime initDateTime,
  bool isRange = true,
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
                        padding: EdgeInsets.only(top: 12),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 12),
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
