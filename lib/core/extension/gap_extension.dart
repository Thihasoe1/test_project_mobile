
import 'package:flutter/material.dart';

extension GapExtension on int {
  Widget gap() {
    return SizedBox(
      width: toDouble(),
      height: toDouble(),
    );
  }

  Widget gw() {
    return SizedBox(
      width: toDouble(),
    );
  }

  Widget gh() {
    return SizedBox(
      height: toDouble(),
    );
  }
}
