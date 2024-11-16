import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final IconData? prefixIcon;
  final TextEditingController controller;
  final TextInputType textInputType;
  final String? Function(String?)? validator;
  final bool? isObscure;
  final IconData? suffixIcon;
  final GestureTapCallback? suffixIconTap;
  final bool? expands;
  final int? maxLines;
  const CustomTextField(
      {super.key,
      required this.label,
      this.prefixIcon,
      required this.controller,
      required this.textInputType,
      this.validator,
      this.isObscure,
      this.suffixIcon,
      this.suffixIconTap,
      this.expands,
      this.maxLines});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        obscureText: isObscure ?? false,
        keyboardType: textInputType,
        controller: controller,
        maxLines: maxLines,
        expands: expands ?? false,
        textAlignVertical: TextAlignVertical.top,
        textAlign: TextAlign.start,
        decoration: InputDecoration(
          label: Text(label),
          hintText: label,
          prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          suffixIcon: InkWell(onTap: suffixIconTap, child: Icon(suffixIcon)),
          border: const OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
        validator: validator);
  }
}
