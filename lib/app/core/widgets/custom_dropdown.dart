import 'package:flutter/material.dart';

class CustomDropDown extends StatelessWidget {
  const CustomDropDown({
    super.key,
    this.controller,
    required this.label,
    this.validator,
    this.onChanged,
    required this.items,
    this.value,
  });

  final TextEditingController? controller;
  final String label;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;
  final List<DropdownMenuItem<String>> items;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      value: value,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(Icons.category, color: Colors.indigo),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.indigo.shade100),
        ),
      ),
      items: items,
      validator: validator,
      onChanged: onChanged,
    );
  }
}
