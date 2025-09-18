import 'package:example/data.dart';
import 'package:example/extension.dart';
import 'package:flutter/material.dart';
import 'package:infinite_calendar_view/infinite_calendar_view.dart';

class Utils {
  static BoxDecoration customBarDecoration(BuildContext context) {
    return BoxDecoration(
      border: Border(
        top: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
        bottom: BorderSide(color: Colors.black12),
      ),
    );
  }

  static OffTimesParam customOffTimes(BuildContext context, bool isDarkMode) {
    return OffTimesParam(
      offTimesAllDaysPainter:
          (column, day, isToday, heightPerMinute, ranges, color) {
        var offTimesDefaultColor = isDarkMode
            ? Theme.of(context).colorScheme.surface.lighten(0.03)
            : const Color(0xFFF4F4F4);
        return OffSetAllDaysPainter(
          isToday,
          paintToday: true,
          heightPerMinute,
          column == 0 ? ranges : getHalfTimeRange(),
          offTimesDefaultColor,
        );
      },
    );
  }
}
