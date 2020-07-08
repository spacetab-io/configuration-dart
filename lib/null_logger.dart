import 'package:configuration/logger_interface.dart';

class NullLogger implements LoggerInterface {
  void debug(String message) {}

  void info(String message) {}

  void error(String message) {}
}