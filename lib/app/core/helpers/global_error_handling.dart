import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GlobalErrorHandler {
  static void init() {
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.dumpErrorToConsole(details);

      Get.dialog(AlertDialog(
        title: Text('Terjadi Kesalahan'),
        content: Text(details.exceptionAsString()),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Tutup'),
          )
        ],
      ));
    };

    // Handler untuk error di luar Flutter
    PlatformDispatcher.instance.onError = (error, stack) {
      log('Unhandled exception: $error');
      log('Stack trace: $stack');
      return true;
    };
  }
}
