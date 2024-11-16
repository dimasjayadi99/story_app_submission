import 'package:flutter/material.dart';

class CustomSnackBar {
  showSnackBar(BuildContext context, String message, bool isSuccess) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(message),
            backgroundColor: isSuccess ? Colors.green : Colors.red),
      );
    }
  }
}
