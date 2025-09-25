import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:infinite_calendar_view/infinite_calendar_view.dart';
import 'package:intl/intl.dart' as intl;

class PlannerRTL extends StatelessWidget {
  const PlannerRTL({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var heightPerMinute = 1.0;
    var initialVerticalScrollOffset = heightPerMinute * 7 * 60;

    return EventsPlanner(
      controller: eventsController,
      daysShowed: 3,
      textDirection: TextDirection.rtl,
      heightPerMinute: heightPerMinute,
      initialVerticalScrollOffset: initialVerticalScrollOffset,
      daysHeaderParam: DaysHeaderParam(
        daysHeaderVisibility: true,
        dayHeaderTextBuilder: (day) =>
            intl.DateFormat("E d", "ar_TN").format(day),
      ),
    );
  }
}
