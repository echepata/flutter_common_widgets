import 'package:flutter/material.dart';

extension ThemeExtension on ThemeData {
  bool get isDark => brightness == Brightness.dark;
}
