import 'package:logger/logger.dart';

final Logger logger = Logger(
  printer: PrettyPrinter(
    stackTraceBeginIndex: 1,
    // errorMethodCount: 3,
    errorMethodCount: 0,
    printEmojis: false,
    dateTimeFormat: DateTimeFormat.dateAndTime,
  ),
);

extension ContextExtensions on Logger {
  static bool _printDio = true;
  static bool _printBloc = true;
  void print(
    dynamic message, {
    PrintColor? color,
    String? title,
  }) {
    if (title == PrintTitles.dioInterceptors && !_printDio ||
        title == PrintTitles.blocObserver && !_printBloc) {
      return;
    }

    color ??= PrintColor.blue;

    if (title != null) {
      if (title.contains(PrintTitles.blocObserver)) {
        color = PrintColor.cyan;
      } else if (title.contains(PrintTitles.dioInterceptors)) {
        color = PrintColor.grey;
      }
    }

    switch (color) {
      case PrintColor.grey:
        logger.t(message, error: title);
      case PrintColor.blue:
        logger.d(message, error: title);
      case PrintColor.cyan:
        logger.i(message, error: title);
      case PrintColor.orange:
        logger.w(message, error: title);
      case PrintColor.red:
        logger.e(message, error: title);
      case PrintColor.pink:
        logger.f(message, error: title);
    }
  }

  void on({
    bool bloc = true,
    bool dio = true,
  }) {
    _printDio = dio;
    _printBloc = bloc;
  }
}

enum PrintColor {
  grey,
  blue,
  cyan,
  orange,
  red,
  pink,
}

void testLogs() {
  logger.print("Trace log", color: PrintColor.grey, title: '1');

  logger.print("Debug log", color: PrintColor.blue, title: '2');

  logger.print("Info log", color: PrintColor.cyan, title: '3');

  logger.print("Warning log", color: PrintColor.orange, title: '4');

  logger.print("Error log", color: PrintColor.red, title: '5');

  logger.print("What a fatal log", color: PrintColor.pink, title: '6');
}

abstract final class PrintTitles {
  PrintTitles._();
  static const blocObserver = 'Bloc Observer';
  static const dioInterceptors = 'Dio Interceptors';
  static const websocketServices = 'WebSocket Services';
  static const firebaseUril = 'Firebase Util';
}
