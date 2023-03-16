// ignore_for_file: avoid_dynamic_calls
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;

enum LogLevel {
  info,
  debug,
  error,
  bloc,
}

class Logger {
  void i([dynamic message]) => _printLog(LogLevel.info, message);
  void d([dynamic message]) => _printLog(LogLevel.debug, message);
  void e(dynamic e, [StackTrace? stackTrace]) =>
      _printLog(LogLevel.error, {'error': e, 'stackTrace': stackTrace});
  void bloc([dynamic message]) => _printLog(LogLevel.bloc, message);

  void _printLog(LogLevel level, dynamic obj) {
    if (!kReleaseMode) {
      String color = '\x1B[32m';
      bool showStackTrace = true;

      var message = obj?.toString();

      if (level == LogLevel.error) {
        message = "${obj?['error']}\n${obj?['stackTrace'] ?? ''}";
      }

      switch (level) {
        case LogLevel.info:
          color = '\x1B[32m';
          break;
        case LogLevel.debug:
          color = '\x1B[33m';
          break;
        case LogLevel.error:
          color = '\x1B[31m';
          break;
        case LogLevel.bloc:
          color = '\x1B[36m';
          showStackTrace = false;
          break;
        // case LogLevel.apiRes:
        //   color = '\x1B[37m';
        //   showStackTrace = false;
        //   break;
      }

      log('$color────────────────────────────────────────────────────────────────────────────────────');
      log('$color| ${DateTime.now()}');

      if (showStackTrace) {
        log('$color| ${stack_trace.Trace.current(2).terse.frames[0]}');
      }

      if (message != null) log('$color| $message');
    }
  }
}
