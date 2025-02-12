import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextForm extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final int? maxLines;
  final String? prefixText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final String? suffixText;
  final void Function()? onTap;
  final Function(String)? onChanged;
  final bool? readOnly;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final String? initialValue;

  const CustomTextForm({
    super.key,
    this.controller,
    this.label,
    this.maxLines,
    this.prefixText,
    this.keyboardType,
    this.validator,
    this.suffixText,
    this.onTap,
    this.readOnly,
    this.suffixIcon,
    this.prefixIcon,
    this.inputFormatters,
    this.initialValue,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      inputFormatters: inputFormatters,
      readOnly: readOnly ?? false,
      onTap: onTap,
      onChanged: onChanged,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(Icons.inventory, color: Colors.indigo),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.indigo.shade100),
        ),
      ),
    );
  }
}
