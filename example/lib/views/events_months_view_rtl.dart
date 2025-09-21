import 'package:flutter/material.dart';
import 'package:infinite_calendar_view/infinite_calendar_view.dart';
import 'package:intl/intl.dart' as intl;

class EventsMonthsViewRTL extends StatelessWidget {
  const EventsMonthsViewRTL({
    super.key,
    required this.controller,
  });

  final EventsController controller;
  final locale = "ar_TN";

  @override
  Widget build(BuildContext context) {
    return EventsMonths(
      controller: controller,
      textDirection: TextDirection.rtl,
      weekParam: WeekParam(
        headerDayText: (dayOfWeek) => getDayName(dayOfWeek),
      ),
      daysParam: DaysParam(
        dayHeaderTextBuilder: (day) => (day.day == 1
            ? "${intl.DateFormat.MMM(locale).format(day)}. 1"
            : day.day.toString()),
      ),
    );
  }

  String getDayName(int dayOfWeek) {
    final referenceDate = DateTime(2023, 1, 2); // monday
    final date = referenceDate.add(Duration(days: dayOfWeek - 1));
    return intl.DateFormat.E(locale).format(date);
  }
}
