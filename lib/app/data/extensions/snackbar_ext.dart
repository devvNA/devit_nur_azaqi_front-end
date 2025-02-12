import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  void showSnackBar(
    String message, {
    bool isError = false,
    Duration duration = const Duration(milliseconds: 1500),
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
            isError ? const Color(0xFFC63323) : const Color(0xFF0D936B),
        duration: duration,
      ),
    );
  }
}
