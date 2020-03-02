import 'package:flutter/widgets.dart';

/**
 * author:heqian
 * date  :20-3-1 下午10:27
 * email :wskfjtheqian@163.com
 **/

//日历主题
class CalenderTheme extends InheritedWidget {
  final CalenderThemeData data;

  const CalenderTheme({
    Key key,
    this.data,
    @required Widget child,
  })  : assert(child != null),
        super(key: key, child: child);

  static CalenderThemeData of(BuildContext context) {
    return context.findAncestorWidgetOfExactType<CalenderTheme>()?.data;
  }

  @override
  bool updateShouldNotify(CalenderTheme old) {
    return data != old.data;
  }
}

class CalenderThemeData {
  ///阳历每天的文字样式
  final TextStyle dayStyle;

  ///阳历非当前月每天的文字样式
  final TextStyle garyStyle;

  ///星期的文字样式
  final TextStyle weekStyle;

  ///农历每天的文字样式
  final TextStyle lunarDayStyle;

  ///标题文件样式
  final TextStyle titleStyle;

  ///标题文件样式
  final TextStyle todayStyle;

  ///选中的背景颜色
  final Color selectColor;

  ///选中的文字颜色
  final Color selectTextColor;

  ///今天的背景颜色
  final Color todayColor;

  ///今天的文字颜色
  final Color todayTextColor;

  ///显示非当前月的天
  final bool showOtherDay;

  ///显示农历
  final bool showLunary;

  ///选择非当前月的天
  final bool selectOtherDay;

  CalenderThemeData({
    this.dayStyle,
    this.weekStyle,
    this.garyStyle,
    this.lunarDayStyle,
    this.titleStyle,
    this.selectColor,
    this.selectTextColor,
    this.showOtherDay,
    this.showLunary,
    this.selectOtherDay,
    this.todayColor,
    this.todayTextColor,
    this.todayStyle,
  });
}
