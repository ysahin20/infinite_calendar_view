import 'package:example/data.dart';
import 'package:example/utils.dart';
import 'package:example/views/widgets/avatar.dart';
import 'package:example/views/widgets/calendar.dart';
import 'package:example/views/widgets/event.dart';
import 'package:example/views/widgets/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:infinite_calendar_view/infinite_calendar_view.dart';

class EventsPlannerMultiColumnSchedulerView extends StatefulWidget {
  const EventsPlannerMultiColumnSchedulerView({
    super.key,
    required this.isDarkMode,
  });

  final bool isDarkMode;

  @override
  State<EventsPlannerMultiColumnSchedulerView> createState() =>
      _EventsPlannerMultiColumnSchedulerViewState();
}

class _EventsPlannerMultiColumnSchedulerViewState
    extends State<EventsPlannerMultiColumnSchedulerView> {
  GlobalKey<EventsPlannerState> oneDayViewKey = GlobalKey<EventsPlannerState>();
  late double heightPerMinute;
  late double initialVerticalScrollOffset;
  late DateTime selectedDay;
  var controller = EventsController()
    ..updateCalendarData((calendarData) {
      calendarData.addEvents(multiColumnEvents);
    });

  @override
  void initState() {
    super.initState();
    selectedDay = controller.focusedDay;
    heightPerMinute = 1.0;
    initialVerticalScrollOffset = heightPerMinute * 7 * 60;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 20),
        buildCalendar(),
        Divider(),
        Expanded(
          child: EventsPlanner(
            key: oneDayViewKey,
            controller: controller,
            daysShowed: 1,
            heightPerMinute: heightPerMinute,
            initialVerticalScrollOffset: initialVerticalScrollOffset,
            daySeparationWidth: 10,

            // header
            daysHeaderParam: DaysHeaderParam(
              daysHeaderVisibility: false,
              daysHeaderHeight: 70,
              daysHeaderColor: Theme.of(context).colorScheme.surface,
            ),

            // custom column bar decoration
            fullDayParam: FullDayParam(
              fullDayEventsBarDecoration: Utils.customBarDecoration(context),
            ),

            // personalize columns
            columnsParam: ColumnsParam(
              columns: 7,
              maxColumns: 3,
              columnsWidthRatio: List.generate(7, (i) => 1 / 3),
              columnHeaderBuilder: (day, isToday, columIndex, columnWidth) {
                return Avatar(columnWidth: columnWidth, columIndex: columIndex);
              },
            ),

            // personalize offTimes per column
            offTimesParam: Utils.customOffTimes(
              context,
              widget.isDarkMode,
            ),
            onDayChange: (newDay) => setState(() => selectedDay = newDay),

            // event cell
            dayParam: DayParam(
              dayEventBuilder: (event, height, width, heightPerMinute) =>
                  EventWidget(controller, event, height, width),
              onSlotTap: (columnIndex, exactDateTime, roundDateTime) =>
                  showSnack(context, "Slot Tap column = ${columnIndex}"),
              todayColor: Theme.of(context).colorScheme.surface,
            ),
          ),
        ),
      ],
    );
  }

  Calendar buildCalendar() {
    return Calendar(
      selectedDay: selectedDay,
      onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
        setState(() {
          this.selectedDay = selectedDay;
        });
        controller.updateFocusedDay(selectedDay);
        oneDayViewKey.currentState?.jumpToDate(selectedDay);
      },
    );
  }
}
