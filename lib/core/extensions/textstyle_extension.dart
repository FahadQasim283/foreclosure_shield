import 'package:flutter/material.dart' show BuildContext, TextStyle, TextTheme, Theme;
import 'package:flutter/material.dart' show TextStyle, FontWeight, FontStyle, TextDecoration, Color;

extension TextThemeExtension on BuildContext {
  TextTheme get appText => Theme.of(this).textTheme;
}

extension TextStyleExtensions on TextStyle {
  TextStyle get italic => copyWith(fontStyle: FontStyle.italic);

  TextStyle get underline => copyWith(decoration: TextDecoration.underline);

  TextStyle get lineThrough => copyWith(decoration: TextDecoration.lineThrough);

  TextStyle withFontSize(double size) => copyWith(fontSize: size);
  TextStyle withLetterSpacing(double spacing) => copyWith(letterSpacing: spacing);
  TextStyle withFontWeight(FontWeight weight) => copyWith(fontWeight: weight);
  TextStyle withFontColor(Color color) => copyWith(color: color);
}
