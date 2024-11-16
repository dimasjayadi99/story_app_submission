import 'package:flutter/material.dart';

class CustomButton {
  Widget filledButton(double? width, String label, VoidCallback? onTap) {
    return SizedBox(
      width: width,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
        onPressed: onTap,
        child: Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget outlinedButton(double? width, String label, VoidCallback? onTap) {
    return SizedBox(
      width: width,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: const RoundedRectangleBorder(
            side: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
        onPressed: onTap,
        child: Text(
          label,
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
