import 'package:flutter/widgets.dart';

/**
 * author:heqian
 * date  :20-3-1 下午10:27
 * email :wskfjtheqian@163.com
 **/

class CalenderTheme extends InheritedWidget {
  const CalenderTheme({
    Key key,
    @required Widget child,
  })  : assert(child != null),
        super(key: key, child: child);

  static CalenderTheme of(BuildContext context) {
    return context.findAncestorWidgetOfExactType<CalenderTheme>();
  }

  @override
  bool updateShouldNotify(CalenderTheme old) {
    return;
  }
}
