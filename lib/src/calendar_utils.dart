/**
 * author:heqian
 * date  :20-2-29 下午6:00
 * email :wskfjtheqian@163.com
 **/

///农历和阳历转换工具
class CalendarUtils {
  /// 农历1900-2100的润大小信息表
  /// @Array Of Property
  /// @return Hex
  List<int> _lunarInfo = [
    0x04bd8, 0x04ae0, 0x0a570, 0x054d5, 0x0d260, 0x0d950, 0x16554, 0x056a0, 0x09ad0, 0x055d2, //1900-1909
    0x04ae0, 0x0a5b6, 0x0a4d0, 0x0d250, 0x1d255, 0x0b540, 0x0d6a0, 0x0ada2, 0x095b0, 0x14977, //1910-1919
    0x04970, 0x0a4b0, 0x0b4b5, 0x06a50, 0x06d40, 0x1ab54, 0x02b60, 0x09570, 0x052f2, 0x04970, //1920-1929
    0x06566, 0x0d4a0, 0x0ea50, 0x06e95, 0x05ad0, 0x02b60, 0x186e3, 0x092e0, 0x1c8d7, 0x0c950, //1930-1939
    0x0d4a0, 0x1d8a6, 0x0b550, 0x056a0, 0x1a5b4, 0x025d0, 0x092d0, 0x0d2b2, 0x0a950, 0x0b557, //1940-1949
    0x06ca0, 0x0b550, 0x15355, 0x04da0, 0x0a5b0, 0x14573, 0x052b0, 0x0a9a8, 0x0e950, 0x06aa0, //1950-1959
    0x0aea6, 0x0ab50, 0x04b60, 0x0aae4, 0x0a570, 0x05260, 0x0f263, 0x0d950, 0x05b57, 0x056a0, //1960-1969
    0x096d0, 0x04dd5, 0x04ad0, 0x0a4d0, 0x0d4d4, 0x0d250, 0x0d558, 0x0b540, 0x0b6a0, 0x195a6, //1970-1979
    0x095b0, 0x049b0, 0x0a974, 0x0a4b0, 0x0b27a, 0x06a50, 0x06d40, 0x0af46, 0x0ab60, 0x09570, //1980-1989
    0x04af5, 0x04970, 0x064b0, 0x074a3, 0x0ea50, 0x06b58, 0x05ac0, 0x0ab60, 0x096d5, 0x092e0, //1990-1999
    0x0c960, 0x0d954, 0x0d4a0, 0x0da50, 0x07552, 0x056a0, 0x0abb7, 0x025d0, 0x092d0, 0x0cab5, //2000-2009
    0x0a950, 0x0b4a0, 0x0baa4, 0x0ad50, 0x055d9, 0x04ba0, 0x0a5b0, 0x15176, 0x052b0, 0x0a930, //2010-2019
    0x07954, 0x06aa0, 0x0ad50, 0x05b52, 0x04b60, 0x0a6e6, 0x0a4e0, 0x0d260, 0x0ea65, 0x0d530, //2020-2029
    0x05aa0, 0x076a3, 0x096d0, 0x04afb, 0x04ad0, 0x0a4d0, 0x1d0b6, 0x0d250, 0x0d520, 0x0dd45, //2030-2039
    0x0b5a0, 0x056d0, 0x055b2, 0x049b0, 0x0a577, 0x0a4b0, 0x0aa50, 0x1b255, 0x06d20, 0x0ada0, //2040-2049
    /**Add By JJonline@JJonline.Cn**/
    0x14b63, 0x09370, 0x049f8, 0x04970, 0x064b0, 0x168a6, 0x0ea50, 0x06b20, 0x1a6c4, 0x0aae0, //2050-2059
    0x0a2e0, 0x0d2e3, 0x0c960, 0x0d557, 0x0d4a0, 0x0da50, 0x05d55, 0x056a0, 0x0a6d0, 0x055d4, //2060-2069
    0x052d0, 0x0a9b8, 0x0a950, 0x0b4a0, 0x0b6a6, 0x0ad50, 0x055a0, 0x0aba4, 0x0a5b0, 0x052b0, //2070-2079
    0x0b273, 0x06930, 0x07337, 0x06aa0, 0x0ad50, 0x14b55, 0x04b60, 0x0a570, 0x054e4, 0x0d160, //2080-2089
    0x0e968, 0x0d520, 0x0daa0, 0x16aa6, 0x056d0, 0x04ae0, 0x0a9d4, 0x0a2d0, 0x0d150, 0x0f252, //2090-2099
    0x0d520
  ]; //2100

  /// 公历每个月份的天数普通表
  /// @Array Of Property
  /// @return Number
  List<int> _solarMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

  /// 天干地支之天干速查表
  /// @return Cn string
  List<String> _gan = ["甲", "乙", "丙", "丁", "戊", "己", "庚", "辛", "壬", "癸"];

  /// 天干地支之地支速查表
  /// @Array Of Property
  /// @return Cn string
  List<String> _zhi = ["子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥"];

  /// 天干地支之地支速查表<=>生肖
  /// @Array Of Property
  /// @return Cn string
  List<String> _animals = ["鼠", "牛", "虎", "兔", "龙", "蛇", "马", "羊", "猴", "鸡", "狗", "猪"];

  /// 阳历节日
  Map<String, String> _festival = {
    '1-1': '元旦节',
    '2-14': '情人节',
    '5-1': '劳动节',
    '5-4': '青年节',
    '6-1': '儿童节',
    '9-10': '教师节',
    '10-1': '国庆节',
    '12-25': '圣诞节',
    '3-8': '妇女节',
    '3-12': '植树节',
    '4-1': '愚人节',
    '5-12': '护士节',
    '7-1': '建党节',
    '8-1': '建军节',
    '12-24': '平安夜',
  };

  /// 农历节日
  Map<String, String> _lfestival = {
    '12-30': '除夕',
    '1-1': '春节',
    '1-15': '元宵节',
    '5-5': '端午节',
    '8-15': '中秋节',
    '9-9': '重阳节',
  };

  /// 24节气速查表
  /// @Array Of Property
  /// @return Cn string
  List<String> _solarTerm = [
    "小寒",
    "大寒",
    "立春",
    "雨水",
    "惊蛰",
    "春分",
    "清明",
    "谷雨",
    "立夏",
    "小满",
    "芒种",
    "夏至",
    "小暑",
    "大暑",
    "立秋",
    "处暑",
    "白露",
    "秋分",
    "寒露",
    "霜降",
    "立冬",
    "小雪",
    "大雪",
    "冬至"
  ];

  /// 1900-2100各年的24节气日期速查表
  /// @Array Of Property
  /// @return 0x string For splice
  List<String> _sTermInfo = [
    '9778397bd097c36b0b6fc9274c91aa',
    '97b6b97bd19801ec9210c965cc920e',
    '97bcf97c3598082c95f8c965cc920f',
    '97bd0b06bdb0722c965ce1cfcc920f',
    'b027097bd097c36b0b6fc9274c91aa',
    '97b6b97bd19801ec9210c965cc920e',
    '97bcf97c359801ec95f8c965cc920f',
    '97bd0b06bdb0722c965ce1cfcc920f',
    'b027097bd097c36b0b6fc9274c91aa',
    '97b6b97bd19801ec9210c965cc920e',
    '97bcf97c359801ec95f8c965cc920f',
    '97bd0b06bdb0722c965ce1cfcc920f',
    'b027097bd097c36b0b6fc9274c91aa',
    '9778397bd19801ec9210c965cc920e',
    '97b6b97bd19801ec95f8c965cc920f',
    '97bd09801d98082c95f8e1cfcc920f',
    '97bd097bd097c36b0b6fc9210c8dc2',
    '9778397bd197c36c9210c9274c91aa',
    '97b6b97bd19801ec95f8c965cc920e',
    '97bd09801d98082c95f8e1cfcc920f',
    '97bd097bd097c36b0b6fc9210c8dc2',
    '9778397bd097c36c9210c9274c91aa',
    '97b6b97bd19801ec95f8c965cc920e',
    '97bcf97c3598082c95f8e1cfcc920f',
    '97bd097bd097c36b0b6fc9210c8dc2',
    '9778397bd097c36c9210c9274c91aa',
    '97b6b97bd19801ec9210c965cc920e',
    '97bcf97c3598082c95f8c965cc920f',
    '97bd097bd097c35b0b6fc920fb0722',
    '9778397bd097c36b0b6fc9274c91aa',
    '97b6b97bd19801ec9210c965cc920e',
    '97bcf97c3598082c95f8c965cc920f',
    '97bd097bd097c35b0b6fc920fb0722',
    '9778397bd097c36b0b6fc9274c91aa',
    '97b6b97bd19801ec9210c965cc920e',
    '97bcf97c359801ec95f8c965cc920f',
    '97bd097bd097c35b0b6fc920fb0722',
    '9778397bd097c36b0b6fc9274c91aa',
    '97b6b97bd19801ec9210c965cc920e',
    '97bcf97c359801ec95f8c965cc920f',
    '97bd097bd097c35b0b6fc920fb0722',
    '9778397bd097c36b0b6fc9274c91aa',
    '97b6b97bd19801ec9210c965cc920e',
    '97bcf97c359801ec95f8c965cc920f',
    '97bd097bd07f595b0b6fc920fb0722',
    '9778397bd097c36b0b6fc9210c8dc2',
    '9778397bd19801ec9210c9274c920e',
    '97b6b97bd19801ec95f8c965cc920f',
    '97bd07f5307f595b0b0bc920fb0722',
    '7f0e397bd097c36b0b6fc9210c8dc2',
    '9778397bd097c36c9210c9274c920e',
    '97b6b97bd19801ec95f8c965cc920f',
    '97bd07f5307f595b0b0bc920fb0722',
    '7f0e397bd097c36b0b6fc9210c8dc2',
    '9778397bd097c36c9210c9274c91aa',
    '97b6b97bd19801ec9210c965cc920e',
    '97bd07f1487f595b0b0bc920fb0722',
    '7f0e397bd097c36b0b6fc9210c8dc2',
    '9778397bd097c36b0b6fc9274c91aa',
    '97b6b97bd19801ec9210c965cc920e',
    '97bcf7f1487f595b0b0bb0b6fb0722',
    '7f0e397bd097c35b0b6fc920fb0722',
    '9778397bd097c36b0b6fc9274c91aa',
    '97b6b97bd19801ec9210c965cc920e',
    '97bcf7f1487f595b0b0bb0b6fb0722',
    '7f0e397bd097c35b0b6fc920fb0722',
    '9778397bd097c36b0b6fc9274c91aa',
    '97b6b97bd19801ec9210c965cc920e',
    '97bcf7f1487f531b0b0bb0b6fb0722',
    '7f0e397bd097c35b0b6fc920fb0722',
    '9778397bd097c36b0b6fc9274c91aa',
    '97b6b97bd19801ec9210c965cc920e',
    '97bcf7f1487f531b0b0bb0b6fb0722',
    '7f0e397bd07f595b0b6fc920fb0722',
    '9778397bd097c36b0b6fc9274c91aa',
    '97b6b97bd19801ec9210c9274c920e',
    '97bcf7f0e47f531b0b0bb0b6fb0722',
    '7f0e397bd07f595b0b0bc920fb0722',
    '9778397bd097c36b0b6fc9210c91aa',
    '97b6b97bd197c36c9210c9274c920e',
    '97bcf7f0e47f531b0b0bb0b6fb0722',
    '7f0e397bd07f595b0b0bc920fb0722',
    '9778397bd097c36b0b6fc9210c8dc2',
    '9778397bd097c36c9210c9274c920e',
    '97b6b7f0e47f531b0723b0b6fb0722',
    '7f0e37f5307f595b0b0bc920fb0722',
    '7f0e397bd097c36b0b6fc9210c8dc2',
    '9778397bd097c36b0b70c9274c91aa',
    '97b6b7f0e47f531b0723b0b6fb0721',
    '7f0e37f1487f595b0b0bb0b6fb0722',
    '7f0e397bd097c35b0b6fc9210c8dc2',
    '9778397bd097c36b0b6fc9274c91aa',
    '97b6b7f0e47f531b0723b0b6fb0721',
    '7f0e27f1487f595b0b0bb0b6fb0722',
    '7f0e397bd097c35b0b6fc920fb0722',
    '9778397bd097c36b0b6fc9274c91aa',
    '97b6b7f0e47f531b0723b0b6fb0721',
    '7f0e27f1487f531b0b0bb0b6fb0722',
    '7f0e397bd097c35b0b6fc920fb0722',
    '9778397bd097c36b0b6fc9274c91aa',
    '97b6b7f0e47f531b0723b0b6fb0721',
    '7f0e27f1487f531b0b0bb0b6fb0722',
    '7f0e397bd097c35b0b6fc920fb0722',
    '9778397bd097c36b0b6fc9274c91aa',
    '97b6b7f0e47f531b0723b0b6fb0721',
    '7f0e27f1487f531b0b0bb0b6fb0722',
    '7f0e397bd07f595b0b0bc920fb0722',
    '9778397bd097c36b0b6fc9274c91aa',
    '97b6b7f0e47f531b0723b0787b0721',
    '7f0e27f0e47f531b0b0bb0b6fb0722',
    '7f0e397bd07f595b0b0bc920fb0722',
    '9778397bd097c36b0b6fc9210c91aa',
    '97b6b7f0e47f149b0723b0787b0721',
    '7f0e27f0e47f531b0723b0b6fb0722',
    '7f0e397bd07f595b0b0bc920fb0722',
    '9778397bd097c36b0b6fc9210c8dc2',
    '977837f0e37f149b0723b0787b0721',
    '7f07e7f0e47f531b0723b0b6fb0722',
    '7f0e37f5307f595b0b0bc920fb0722',
    '7f0e397bd097c35b0b6fc9210c8dc2',
    '977837f0e37f14998082b0787b0721',
    '7f07e7f0e47f531b0723b0b6fb0721',
    '7f0e37f1487f595b0b0bb0b6fb0722',
    '7f0e397bd097c35b0b6fc9210c8dc2',
    '977837f0e37f14998082b0787b06bd',
    '7f07e7f0e47f531b0723b0b6fb0721',
    '7f0e27f1487f531b0b0bb0b6fb0722',
    '7f0e397bd097c35b0b6fc920fb0722',
    '977837f0e37f14998082b0787b06bd',
    '7f07e7f0e47f531b0723b0b6fb0721',
    '7f0e27f1487f531b0b0bb0b6fb0722',
    '7f0e397bd097c35b0b6fc920fb0722',
    '977837f0e37f14998082b0787b06bd',
    '7f07e7f0e47f531b0723b0b6fb0721',
    '7f0e27f1487f531b0b0bb0b6fb0722',
    '7f0e397bd07f595b0b0bc920fb0722',
    '977837f0e37f14998082b0787b06bd',
    '7f07e7f0e47f531b0723b0b6fb0721',
    '7f0e27f1487f531b0b0bb0b6fb0722',
    '7f0e397bd07f595b0b0bc920fb0722',
    '977837f0e37f14998082b0787b06bd',
    '7f07e7f0e47f149b0723b0787b0721',
    '7f0e27f0e47f531b0b0bb0b6fb0722',
    '7f0e397bd07f595b0b0bc920fb0722',
    '977837f0e37f14998082b0723b06bd',
    '7f07e7f0e37f149b0723b0787b0721',
    '7f0e27f0e47f531b0723b0b6fb0722',
    '7f0e397bd07f595b0b0bc920fb0722',
    '977837f0e37f14898082b0723b02d5',
    '7ec967f0e37f14998082b0787b0721',
    '7f07e7f0e47f531b0723b0b6fb0722',
    '7f0e37f1487f595b0b0bb0b6fb0722',
    '7f0e37f0e37f14898082b0723b02d5',
    '7ec967f0e37f14998082b0787b0721',
    '7f07e7f0e47f531b0723b0b6fb0722',
    '7f0e37f1487f531b0b0bb0b6fb0722',
    '7f0e37f0e37f14898082b0723b02d5',
    '7ec967f0e37f14998082b0787b06bd',
    '7f07e7f0e47f531b0723b0b6fb0721',
    '7f0e37f1487f531b0b0bb0b6fb0722',
    '7f0e37f0e37f14898082b072297c35',
    '7ec967f0e37f14998082b0787b06bd',
    '7f07e7f0e47f531b0723b0b6fb0721',
    '7f0e27f1487f531b0b0bb0b6fb0722',
    '7f0e37f0e37f14898082b072297c35',
    '7ec967f0e37f14998082b0787b06bd',
    '7f07e7f0e47f531b0723b0b6fb0721',
    '7f0e27f1487f531b0b0bb0b6fb0722',
    '7f0e37f0e366aa89801eb072297c35',
    '7ec967f0e37f14998082b0787b06bd',
    '7f07e7f0e47f149b0723b0787b0721',
    '7f0e27f1487f531b0b0bb0b6fb0722',
    '7f0e37f0e366aa89801eb072297c35',
    '7ec967f0e37f14998082b0723b06bd',
    '7f07e7f0e47f149b0723b0787b0721',
    '7f0e27f0e47f531b0723b0b6fb0722',
    '7f0e37f0e366aa89801eb072297c35',
    '7ec967f0e37f14998082b0723b06bd',
    '7f07e7f0e37f14998083b0787b0721',
    '7f0e27f0e47f531b0723b0b6fb0722',
    '7f0e37f0e366aa89801eb072297c35',
    '7ec967f0e37f14898082b0723b02d5',
    '7f07e7f0e37f14998082b0787b0721',
    '7f07e7f0e47f531b0723b0b6fb0722',
    '7f0e36665b66aa89801e9808297c35',
    '665f67f0e37f14898082b0723b02d5',
    '7ec967f0e37f14998082b0787b0721',
    '7f07e7f0e47f531b0723b0b6fb0722',
    '7f0e36665b66a449801e9808297c35',
    '665f67f0e37f14898082b0723b02d5',
    '7ec967f0e37f14998082b0787b06bd',
    '7f07e7f0e47f531b0723b0b6fb0721',
    '7f0e36665b66a449801e9808297c35',
    '665f67f0e37f14898082b072297c35',
    '7ec967f0e37f14998082b0787b06bd',
    '7f07e7f0e47f531b0723b0b6fb0721',
    '7f0e26665b66a449801e9808297c35',
    '665f67f0e37f1489801eb072297c35',
    '7ec967f0e37f14998082b0787b06bd',
    '7f07e7f0e47f531b0723b0b6fb0721',
    '7f0e27f1487f531b0b0bb0b6fb0722'
  ];

  List<String> _nStr1 = ['日', '一', '二', '三', '四', '五', '六', '七', '八', '九', '十'];

  List<String> _nStr2 = ['初', '十', '廿', '卅'];
  List<String> _nStr3 = ['正', '一', '二', '三', '四', '五', '六', '七', '八', '九', '十', '冬', '腊'];
  List<String> _nStr4 = ['魔羯', '水瓶', '双鱼', '白羊', '金牛', '双子', '巨蟹', '狮子', '处女', '天秤', '天蝎', '射手', '魔羯'];

  /// 返回农历y年一整年的总天数
  int lYearDays(int year) {
    var i, sum = 348;
    for (i = 0x8000; i > 0x8; i >>= 1) {
      sum += (0 != (_lunarInfo[year - 1900] & i) ? 1 : 0);
    }
    return (sum + leapDays(year));
  }

  /// 返回农历y年闰月是哪个月；若y年没有闰月 则返回0
  int leapMonth(int year) {
    return (this._lunarInfo[year - 1900] & 0xf);
  }

  /// 返回农历y年闰月的天数 若该年没有闰月则返回0
  int leapDays(int year, [int month]) {
    if (0 != leapMonth(year)) {
      return (0 != (_lunarInfo[year - 1900] & 0x10000) ? 30 : 29);
    }
    return 0;
  }

  /// 返回农历y年m月（非闰月）的总天数，计算m为闰月时的天数请使用leapDays方法
  int monthDays(int year, int month) {
    if (month > 12 || month < 1) {
      return -1;
    }
    return (0 != (_lunarInfo[year - 1900] & (0x10000 >> month)) ? 30 : 29);
  }

  /// 返回公历(!)y年m月的天数
  int _solarDays(int year, int month) {
    if (month > 12 || month < 1) {
      return -1;
    }
    var ms = month - 1;
    if (ms == 1) {
      return (((year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0)) ? 29 : 28);
    } else {
      return (this._solarMonth[ms]);
    }
  }

  /// 农历年份转换为干支纪年
  String toGanZhiYear(int lYear) {
    var ganKey = (lYear - 3) % 10;
    var zhiKey = (lYear - 3) % 12;
    if (ganKey == 0) ganKey = 10; //如果余数为0则为最后一个天干
    if (zhiKey == 0) zhiKey = 12; //如果余数为0则为最后一个地支
    return this._gan[ganKey - 1] + this._zhi[zhiKey - 1];
  }

  /// 公历月、日判断所属星座
  String toAstro(int cMonth, int cDay) {
    var arr = [20, 19, 21, 21, 21, 22, 23, 23, 23, 23, 22, 22];
    return _nStr4[cMonth - (cDay < arr[cMonth - 1] ? 1 : 0)] + "座";
  }

  /// 传入offset偏移量返回干支
  String toGanZhi(int offset) {
    return this._gan[offset % 10] + this._zhi[offset % 12];
  }

  /// 传入公历(!)y年获得该年第n个节气的公历日期
  int getTerm(int year, int n) {
    if (year < 1900 || year > 2100) {
      return -1;
    }
    if (n < 1 || n > 24) {
      return -1;
    }
    var _table = this._sTermInfo[year - 1900];
    var _info = [
      int.parse(_table.substring(0, 5), radix: 16).toString(),
      int.parse(_table.substring(5, 10), radix: 16).toString(),
      int.parse(_table.substring(10, 15), radix: 16).toString(),
      int.parse(_table.substring(15, 20), radix: 16).toString(),
      int.parse(_table.substring(20, 25), radix: 16).toString(),
      int.parse(_table.substring(25, 30), radix: 16).toString()
    ];
    var _calday = [
      _info[0].substring(0, 1),
      _info[0].substring(1, 3),
      _info[0].substring(3, 4),
      _info[0].substring(4, 6),
      _info[1].substring(0, 1),
      _info[1].substring(1, 3),
      _info[1].substring(3, 4),
      _info[1].substring(4, 6),
      _info[2].substring(0, 1),
      _info[2].substring(1, 3),
      _info[2].substring(3, 4),
      _info[2].substring(4, 6),
      _info[3].substring(0, 1),
      _info[3].substring(1, 3),
      _info[3].substring(3, 4),
      _info[3].substring(4, 6),
      _info[4].substring(0, 1),
      _info[4].substring(1, 3),
      _info[4].substring(3, 4),
      _info[4].substring(4, 6),
      _info[5].substring(0, 1),
      _info[5].substring(1, 3),
      _info[5].substring(3, 4),
      _info[5].substring(4, 6),
    ];
    return int.parse(_calday[n - 1]);
  }

  /// 传入农历数字月份返回汉语通俗表示法
  String toChinaMonth(int month) {
    if (month > 12 || month < 1) {
      return null;
    }
    var s = this._nStr3[month];
    s += "月";
    return s;
  }

  /// 传入农历日期数字返回汉字表示法
  String toChinaDay(int day) {
    var s;
    switch (day) {
      case 10:
        s = '初十';
        break;
      case 20:
        s = '二十';
        break;
        break;
      case 30:
        s = '三十';
        break;
        break;
      default:
        s = this._nStr2[(day / 10).floor()];
        s += this._nStr1[day % 10];
    }
    return (s);
  }

  /// 年份转生肖[!仅能大致转换] => 精确划分生肖分界线是“立春”
  String getAnimal(int year) {
    return this._animals[(year - 4) % 12];
  }

  /// 传入阳历年月日获得详细的公历、农历object信息
  /// 参数区间1900.1.31~2100.12.31
  DateTime solar2lunar(DateTime solarDate) {
    int year = solarDate.year;
    int month = solarDate.month;
    int day = solarDate.day;
    //年份限定、上限
    if (year < 1900 || year > 2100) {
      return null;
    }
    //公历传参最下限
    if (year == 1900 && month == 1 && day < 31) {
      return null;
    }

    int offset = solarDate.difference(DateTime(1900, 1, 31)).inDays;
    int i, temp;

    for (i = 1900; i < 2101 && offset > 0; i++) {
      temp = this.lYearDays(i);
      offset -= temp;
    }
    if (offset < 0) {
      offset += temp;
      i--;
    }

    year = i;
    int leap = this.leapMonth(i); //闰哪个月
    var isLeap = false;

    //效验闰月
    for (i = 1; i < 13 && offset > 0; i++) {
      //闰月
      if (leap > 0 && i == (leap + 1) && isLeap == false) {
        --i;
        isLeap = true;
        temp = this.leapDays(year); //计算农历闰月天数
      } else {
        temp = this.monthDays(year, i); //计算农历普通月天数
      }
      //解除闰月
      if (isLeap == true && i == (leap + 1)) {
        isLeap = false;
      }
      offset -= temp;
    }

    // 闰月导致数组下标重叠取反
    if (offset == 0 && leap > 0 && i == leap + 1) {
      if (isLeap) {
        isLeap = false;
      } else {
        isLeap = true;
        --i;
      }
    }
    if (offset < 0) {
      offset += temp;
      --i;
    }
    month = i;
    day = offset + 1;
    return DateTime(year, month, day);
  }

  /// 传入农历年月日以及传入的月份是否闰月获得详细的公历、农历object信息 <=>JSON
  /// 参数区间1900.1.31~2100.12.1
  DateTime lunar2solar(DateTime dateTime, bool isLeapMonth) {
    int y = dateTime.year;
    int m = dateTime.month;
    int d = dateTime.day;
    isLeapMonth ??= false;
    var leapMonth = this.leapMonth(y);
    if (isLeapMonth && (leapMonth != m)) {
      return null;
    } //传参要求计算该闰月公历 但该年得出的闰月与传参的月份并不同
    if (y == 2100 && m == 12 && d > 1 || y == 1900 && m == 1 && d < 31) {
      return null;
    } //超出了最大极限值
    var day = this.monthDays(y, m);
    var _day = day;
    //bugFix 2016-9-25
    //if month is leap, _day use leapDays method
    if (isLeapMonth) {
      _day = this.leapDays(y, m);
    }
    if (y < 1900 || y > 2100 || d > _day) {
      return null;
    } //参数合法性效验

    //计算农历的时间差
    var offset = 0;
    for (var i = 1900; i < y; i++) {
      offset += this.lYearDays(i);
    }
    var leap = 0, isAdd = false;
    for (var i = 1; i < m; i++) {
      leap = this.leapMonth(y);
      if (!isAdd) {
        //处理闰月
        if (leap <= i && leap > 0) {
          offset += this.leapDays(y);
          isAdd = true;
        }
      }
      offset += this.monthDays(y, i);
    }
    //转换闰月农历 需补充该年闰月的前一个月的时差
    if (isLeapMonth) {
      offset += day;
    }
    //1900年农历正月一日的公历时间为1900年1月30日0时0分0秒(该时间也是本农历的最开始起始点)
    var stmap = DateTime.utc(1900, 1, 30, 0, 0, 0);
    var calObj = DateTime.fromMillisecondsSinceEpoch((offset + d - 31) * 86400000 + stmap.millisecondsSinceEpoch);

    return solar2lunar(calObj);
  }

  CalendarInfo getInfo(DateTime solarDate) {
    var lunarDate = solar2lunar(solarDate);

    String gzYear = this.toGanZhiYear(solarDate.year);
    var firstNode = this.getTerm(solarDate.year, (solarDate.month * 2 - 1)); //返回当月「节」为几日开始
    var secondNode = this.getTerm(solarDate.year, (solarDate.month * 2)); //返回当月「节」为几日开始

    // 依据12节气修正干支月
    var gzMonth = this.toGanZhi((solarDate.year - 1900) * 12 + solarDate.month + 11);
    if (solarDate.day >= firstNode) {
      gzMonth = this.toGanZhi((solarDate.year - 1900) * 12 + solarDate.month + 12);
    }

    //日柱 当月一日与 1900/1/1 相差天数
    var dayCyclical = DateTime(solarDate.year, solarDate.month, 1).difference(DateTime(1900)).inDays;
    var gzDay = this.toGanZhi(dayCyclical + solarDate.day + 9);

    //传入的日期的节气与否
    var term;
    if (firstNode == solarDate.day) {
      term = _solarTerm[solarDate.month * 2 - 2];
    }
    if (secondNode == solarDate.day) {
      term = _solarTerm[solarDate.month * 2 - 1];
    }

    return CalendarInfo(
      lunarDate: lunarDate,
      solarDate: solarDate,
      animal: getAnimal(solarDate.year),
      astro: toAstro(solarDate.month, solarDate.day),
      lunarYearName: toGanZhiYear(lunarDate.year),
      lunarMonthName: toChinaMonth(lunarDate.month),
      lunarDayName: toChinaDay(lunarDate.day),
      gzYear: gzYear,
      gzMonth: gzMonth,
      gzDay: gzDay,
      term: term,
      festival: _lfestival['${solarDate.year}-${solarDate.month}'],
      lunarFestival: _festival['${lunarDate.year}-${lunarDate.month}'],
    );
  }
}

class CalendarInfo {
  final DateTime lunarDate;
  final DateTime solarDate;
  final String lunarYearName;
  final String lunarMonthName;
  final String lunarDayName;

  //生肖
  final String animal;

  //星座
  final String astro;
  final String gzYear;
  final String gzMonth;
  final String gzDay;
  final String term;
  final String festival;
  final String lunarFestival;

  CalendarInfo({
    this.lunarDate,
    this.solarDate,
    this.lunarYearName,
    this.lunarMonthName,
    this.lunarDayName,
    this.animal,
    this.astro,
    this.gzYear,
    this.gzMonth,
    this.gzDay,
    this.term,
    this.festival,
    this.lunarFestival,
  });
}
