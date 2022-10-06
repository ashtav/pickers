import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PickerConstant {
  static TextStyle style = GoogleFonts.lato(fontSize: 16);

  static List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
}

extension PickerSized on BuildContext {
  double get h => MediaQuery.of(this).size.height;
  double get w => MediaQuery.of(this).size.width;
}
