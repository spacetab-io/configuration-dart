import 'package:configuration/logger_interface.dart';

class StdoutConsoleLogger implements LoggerInterface {

  final bool _showDebug;

  StdoutConsoleLogger([showDebug = false]): _showDebug = showDebug;

  void debug(String message) {
    if (_showDebug) {
      StdoutConsoleLogger.log('[DEBUG]: $message');
    }
  }

  void info(String message) {
    StdoutConsoleLogger.log('[INFO]: $message');
  }

  void error(String message) {
    StdoutConsoleLogger.log('[ERROR]: $message');
  }

  static void log(String message) {
    print(message);
  }

}