import 'package:flutter/material.dart';

extension ColorExtension on Color {
  Color get pastel {
    var hsl = HSLColor.fromColor(this);
    var newSaturation = hsl.saturation > 0.1 ? 0.65 : hsl.saturation;
    return hsl.withSaturation(newSaturation).withLightness(0.87).toColor();
  }

  Color get onPastel {
    var hsl = HSLColor.fromColor(this);
    var newSaturation = hsl.saturation > 0.1 ? 0.48 : hsl.saturation;
    return hsl.withSaturation(newSaturation).withLightness(0.20).toColor();
  }
}

extension DateTimeExtensions on DateTime {
  /// Returns [DateTime] without timestamp.
  DateTime get withoutTime => DateTime(year, month, day);
}
