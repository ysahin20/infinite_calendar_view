import 'package:flutter/material.dart';
import 'package:sticky_infinite_list/models/alignments.dart';
import 'package:sticky_infinite_list/widget.dart';

import '../../../infinite_calendar_view.dart';

class HorizontalDaysIndicatorWidget extends StatelessWidget {
  const HorizontalDaysIndicatorWidget({
    super.key,
    required this.daysHeaderParam,
    required this.timesIndicatorsWidth,
    required this.dayHorizontalController,
    required this.maxPreviousDays,
    required this.maxNextDays,
    required this.initialDate,
    required this.dayWidth,
  });

  final DaysHeaderParam daysHeaderParam;
  final double timesIndicatorsWidth;
  final ScrollController dayHorizontalController;
  final int? maxPreviousDays;
  final int? maxNextDays;
  final DateTime initialDate;
  final double dayWidth;

  @override
  Widget build(BuildContext context) {
    // take appbar background color first
    var defaultHeaderBackgroundColor = Theme.of(context).colorScheme.primary;

    return Container(
      decoration: BoxDecoration(
        color: daysHeaderParam.daysHeaderColor ?? defaultHeaderBackgroundColor,
      ),
      child: Padding(
        padding: EdgeInsets.only(left: timesIndicatorsWidth),
        child: SizedBox(
          height: daysHeaderParam.daysHeaderHeight,
          child: InfiniteList(
              controller: dayHorizontalController,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              direction: InfiniteListDirection.multi,
              negChildCount: maxPreviousDays,
              posChildCount: maxNextDays,
              builder: (context, index) {
                var day = initialDate.add(Duration(days: index));
                var isToday = DateUtils.isSameDay(day, DateTime.now());

                return InfiniteListItem(
                  contentBuilder: (context) {
                    return SizedBox(
                      width: dayWidth,
                      child: daysHeaderParam.dayHeaderBuilder != null
                          ? daysHeaderParam.dayHeaderBuilder!.call(day, isToday)
                          : DefaultDayHeader(
                              dayText: "${day.day}/${day.month}",
                              isToday: isToday,
                            ),
                    );
                  },
                );
              }),
        ),
      ),
    );
  }
}

class DefaultDayHeader extends StatelessWidget {
  const DefaultDayHeader({
    super.key,
    required this.dayText,
    this.isToday = false,
    this.foregroundColor,
    this.todayForegroundColor,
    this.todayBackgroundColor,
    this.textStyle,
  });

  /// day text
  final String dayText;

  final bool isToday;

  /// day text color
  final Color? foregroundColor;

  /// today text color
  final Color? todayForegroundColor;

  /// today background color
  final Color? todayBackgroundColor;

  /// text TextStyle
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var fgColor = foregroundColor ?? colorScheme.onPrimary;
    var todayBgColor = todayForegroundColor ?? colorScheme.surface;
    var todayFgColor = todayBackgroundColor ?? colorScheme.primary;

    return Center(
      child: isToday
          ? Container(
              decoration: BoxDecoration(
                color: todayBgColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                child: Text(
                  dayText,
                  textAlign: TextAlign.center,
                  style: textStyle ?? getDefaultStyle(todayFgColor),
                ),
              ),
            )
          : Text(
              dayText,
              textAlign: TextAlign.center,
              style: textStyle ?? getDefaultStyle(fgColor),
            ),
    );
  }

  TextStyle getDefaultStyle(Color fgColor) {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: fgColor,
    );
  }
}
