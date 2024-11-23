import 'package:logger/logger.dart';

class DateTimeHelper {
  DateTimeHelper._();
  static String format(DateTime dateTime, DateTimeFormatter dateTimeFormatter) {
    return dateTimeFormatter.call(dateTime);
  }

  static String formatHHMMSS(int seconds) {
    int hours = (seconds / 3600).truncate();
    seconds = (seconds % 3600).truncate();
    int minutes = (seconds / 60).truncate();

    String hoursStr = (hours).toString().padLeft(2, '0');
    String minutesStr = (minutes).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    if (hours == 0) {
      return "$minutesStr:$secondsStr";
    }

    return "$hoursStr:$minutesStr:$secondsStr";
  }
}

typedef DateTimeFormatter = String Function(DateTime time);

class DateTimeFormat {
  /// Omits the date and time completely.
  static const DateTimeFormatter none = _none;

  /// Prints only the time.
  ///
  /// Example:
  /// * `12:30:40.550`
  static const DateTimeFormatter onlyTime = _onlyTime;

  /// Prints only the time including the difference since [PrettyPrinter.startTime].
  ///
  /// Example:
  /// * `12:30:40.550 (+0:00:00.060700)`
  static const DateTimeFormatter onlyTimeAndSinceStart = _onlyTimeAndSinceStart;

  /// Prints only the date.
  ///
  /// Example:
  /// * `2019-06-04`
  static const DateTimeFormatter onlyDate = _onlyDate;

  /// Prints date and time (combines [onlyDate] and [onlyTime]).
  ///
  /// Example:
  /// * `2019-06-04 12:30:40.550`
  static const DateTimeFormatter dateAndTime = _dateAndTime;

  DateTimeFormat._();

  static String _none(DateTime t) => throw UnimplementedError();

  static String _onlyTime(DateTime t) {
    String twoDigits(int n) {
      if (n >= 10) return '$n';
      return '0$n';
    }

    var now = t;
    var h = twoDigits(now.hour);
    var min = twoDigits(now.minute);
    var sec = twoDigits(now.second);
    return '$h:$min:$sec';
  }

  static String _onlyTimeAndSinceStart(DateTime t) {
    var timeSinceStart = t.difference(PrettyPrinter.startTime!).toString();
    return '${onlyTime(t)} (+$timeSinceStart)';
  }

  static String _onlyDate(DateTime t) {
    String isoDate = t.toIso8601String();
    return isoDate.substring(0, isoDate.indexOf("T"));
  }

  static String _dateAndTime(DateTime t) {
    return "${_onlyDate(t)}   ${_onlyTime(t)}";
  }
}
