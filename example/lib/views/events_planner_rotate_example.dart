import 'package:example/main.dart';
import 'package:example/utils.dart';
import 'package:flutter/material.dart';
import 'package:infinite_calendar_view/infinite_calendar_view.dart';
import 'package:intl/intl.dart' as intl;

class PlannerRotation extends StatelessWidget {
  const PlannerRotation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var heightPerMinute = 1.0;
    var initialVerticalScrollOffset = heightPerMinute * 7 * 60;

    return RotatedBox(
      quarterTurns: -1,
      child: EventsPlanner(
        controller: eventsController,
        textDirection: TextDirection.rtl,
        daysShowed: 3,
        heightPerMinute: heightPerMinute,
        initialVerticalScrollOffset: initialVerticalScrollOffset,
        daysHeaderParam: DaysHeaderParam(
          daysHeaderVisibility: true,
          dayHeaderTextBuilder: (day) => intl.DateFormat("E d").format(day),
        ),
        dayParam: DayParam(
          onSlotTap: (_, __, round) => showSnack(context, round.toString()),
          dayEventBuilder: (event, height, width, heightPerMinute) {
            return RotatedBox(
              quarterTurns: 1,
              child: DefaultDayEvent(
                title: event.title,
                description: event.description,
                color: event.color,
                textColor: event.textColor,
                height: height,
                width: width,
              ),
            );
          },
        ),
      ),
    );
  }
}
