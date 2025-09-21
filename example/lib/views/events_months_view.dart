import 'package:flutter/material.dart';
import 'package:infinite_calendar_view/infinite_calendar_view.dart';

class EventsMonthsView extends StatelessWidget {
  const EventsMonthsView({
    super.key,
    required this.controller,
  });

  final EventsController controller;

  @override
  Widget build(BuildContext context) {
    return EventsMonths(
      controller: controller,
      daysParam: DaysParam(
        // custom builder : add drag and drop
        dayEventBuilder: (event, width, height) {
          return DraggableMonthEvent(
            child: DefaultMonthDayEvent(event: event),
            onDragEnd: (DateTime day) {
              controller.updateCalendarData((data) => move(data, event, day));
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
