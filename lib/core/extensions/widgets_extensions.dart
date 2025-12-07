import 'package:flutter/material.dart' show SizedBox, Widget, Transform;
import 'dart:math' show pi;

extension SizeBoxExtension on double {
  SizedBox get h => SizedBox(height: this);
  SizedBox get w => SizedBox(width: this);
}

enum Rotation { zero, ninety, oneEighty, twoSeventy }

extension RotationWidgetExtension on Widget {
  Widget rotate(Rotation rotation) {
    double angle;
    switch (rotation) {
      case Rotation.zero:
        angle = 0;
        break;
      case Rotation.ninety:
        angle = pi / 2;
        break;
      case Rotation.oneEighty:
        angle = pi;
        break;
      case Rotation.twoSeventy:
        angle = 3 * pi / 2;
        break;
    }
    return Transform.rotate(angle: angle, child: this);
  }
}
