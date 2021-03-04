import 'package:common_utils/common_utils.dart';

class TimeMachineUtil {
  static getStartEndYearDate(int iYear) {
    Map mapDate = new Map();
    int yearNow = DateTime.now().year;
    yearNow = yearNow + iYear;

    String newStartYear = '$yearNow' + '-' + '01' + '-' + '01';
    String newEndYear = (yearNow + 1).toString() + '-' + '01' + '-' + '00';

    mapDate['startTime'] = DateUtil.formatDate(
        DateTime.fromMillisecondsSinceEpoch(turnTimestamp(newStartYear)),
        format: 'yyyy-MM-dd');
    mapDate['endTime'] = DateUtil.formatDate(
        DateTime.fromMillisecondsSinceEpoch(turnTimestamp(newEndYear)),
        format: 'yyyy-MM-dd');

    mapDate['startStamp'] = turnTimestamp(mapDate['startTime'] + ' 00:00:00');
    mapDate['endStamp'] = turnTimestamp(mapDate['endTime'] + ' 23:59:59');
    // print('某一年初和年末：$mapDate');
  }

  static Map<String, String> getMonthDate(DateTime dateTime, int iMonth) {
    Map<String, String> dateMap = Map();
    var currentDate = dateTime;
    if (iMonth + currentDate.month > 0) {
      dateMap = timeConversion(
          iMonth + currentDate.month, (currentDate.year).toString());
    } else {
      int beforeYear = (iMonth + currentDate.month) ~/ 12;
      String yearNew = (currentDate.year + beforeYear - 1).toString();
      int monthNew = (iMonth + currentDate.month) - beforeYear * 12;
      dateMap = timeConversion(12 + monthNew, yearNew);
    }
    return dateMap;
  }

  static Map<String, String> timeConversion(int monthTime, String yearTime) {
    Map<String, String> dateMap = Map();
    dateMap['startDate'] = '$yearTime' +
        '-' +
        (monthTime < 10 ? '0' + monthTime.toString() : '$monthTime') +
        '-' +
        '01';
    dateMap['startDate'] = DateUtil.formatDate(
        DateTime.fromMillisecondsSinceEpoch(
            turnTimestamp(dateMap['startDate'])),
        format: 'yyyy-MM-dd');
    String endMonth = '$yearTime' +
        '-' +
        ((monthTime + 1) < 10
                ? '0' + (monthTime + 1).toString()
                : (monthTime + 1))
            .toString() +
        '-' +
        '00';
    var endMonthTimeStamp = turnTimestamp(endMonth);
    endMonth = DateUtil.formatDate(
        DateTime.fromMillisecondsSinceEpoch(endMonthTimeStamp),
        format: 'yyyy-MM-dd');
    dateMap['endDate'] = endMonth;
    dateMap['startDateStamp'] =
        turnTimestamp(dateMap['startDate'] + ' 00:00:00').toString();
    dateMap['endDateStamp'] =
        turnTimestamp(dateMap['endDate'] + ' 23:59:59').toString();
    return dateMap;
    // print('过去未来某个月初月末：$dateMap');
  }

  static int turnTimestamp(String timestamp) {
    return DateTime.parse(timestamp).millisecondsSinceEpoch;
  }

  static void getWeeksDate(int weeks) {
    Map<String, String> mapTime = new Map();
    DateTime now = new DateTime.now();
    int weekday = now.weekday; //今天周几

    var sunDay = getTimestampLatest(false, 7 - weekday + weeks * 7); //周末
    var monDay = getTimestampLatest(true, -weekday + 1 + weeks * 7); //周一

    mapTime['monDay'] = DateUtil.formatDate(
        DateTime.fromMillisecondsSinceEpoch(sunDay),
        format: 'yyyy-MM-dd'); //周一 时间格式化
    mapTime['sunDay'] = DateUtil.formatDate(
        DateTime.fromMillisecondsSinceEpoch(monDay),
        format: 'yyyy-MM-dd'); //周一 时间格式化
    mapTime['monDayStamp'] = '$monDay'; //周一 时间戳
    mapTime['sunDayStamp'] = '$sunDay'; //周日 时间戳
    // print('某个周的周一和周日：$mapTime');
  }

  static int getTimestampLatest(bool phase, int day) {
    String newHours;
    DateTime now = new DateTime.now();
    DateTime sixtyDaysFromNow = now.add(new Duration(days: day));
    String formattedDate =
        DateUtil.formatDate(sixtyDaysFromNow, format: 'yyyy-MM-dd');
    if (phase) {
      newHours = formattedDate + ' 00:00:00';
    } else {
      newHours = formattedDate + ' 23:59:59';
    }
    DateTime newDate = DateTime.parse(newHours);
    // String newFormattedDate =
    //     DateUtil.formatDate(newDate, format: 'yyyy-MM-dd HH:mm:ss');
    int timeStamp = newDate.millisecondsSinceEpoch;
    return timeStamp;
  }
}
