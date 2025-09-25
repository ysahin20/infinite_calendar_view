import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:infinite_calendar_view/infinite_calendar_view.dart';

class Months extends StatelessWidget {
  const Months({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return EventsMonths(
      controller: eventsController,
      daysParam: DaysParam(
        // custom builder : add drag and drop
        dayEventBuilder: (event, width, height) {
          return DraggableMonthEvent(
            child: DefaultMonthDayEvent(event: event),
            onDragEnd: (DateTime day) {
              eventsController
                  .updateCalendarData((data) => move(data, event, day));
            },
          );
        },
      ),
    );
  }

  move(CalendarData data, Event event, DateTime newDay) {
    data.moveEvent(
      event,
      newDay.copyWith(
        hour: event.effectiveStartTime!.hour,
        minute: event.effectiveStartTime!.minute,
      ),
    );
  }
}
