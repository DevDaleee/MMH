import 'package:flutter/material.dart';

InputDecoration getAutenticationInputDecoration(String label) {
  return InputDecoration(
      label: Text(label),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(0)),
      labelStyle: const TextStyle(color: Color(0xffA6BD94)),
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffA6BD94), width: 1.0)));
}
