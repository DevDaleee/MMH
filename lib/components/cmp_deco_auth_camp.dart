import 'package:flutter/material.dart';

InputDecoration getAutenticationInputDecoration(String label) {
  return InputDecoration(
    label: Text(label),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(0)),
  );
}
