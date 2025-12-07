import 'package:flutter/material.dart';

extension BuildContextExtensions on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;
  double get screenIsPortrait =>
      MediaQuery.of(this).orientation == Orientation.portrait ? screenHeight : screenWidth;
  double get screenIsLandscape =>
      MediaQuery.of(this).orientation == Orientation.landscape ? screenWidth : screenHeight;
  bool get screenIsTablet => MediaQuery.of(this).size.shortestSide >= 600 ? true : false;
  bool get screenIsPhone => MediaQuery.of(this).size.shortestSide < 600 ? true : false;
}
