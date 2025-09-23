import 'package:example/views/widgets/calendar.dart';
import 'package:flutter/material.dart';
import 'package:infinite_calendar_view/infinite_calendar_view.dart';
import 'package:intl/intl.dart';

class EventsPlannerOneDayView extends StatefulWidget {
  const EventsPlannerOneDayView({
    super.key,
    required this.controller,
    required this.isDarkMode,
  });

  final EventsController controller;
  final bool isDarkMode;

  @override
  State<EventsPlannerOneDayView> createState() =>
      _EventsPlannerOneDayViewState();
}

class _EventsPlannerOneDayViewState extends State<EventsPlannerOneDayView> {
  GlobalKey<EventsPlannerState> oneDayViewKey = GlobalKey<EventsPlannerState>();
  late DateTime selectedDay;

  @override
  void initState() {
    super.initState();
    selectedDay = widget.controller.focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    var heightPerMinute = 1.0;
    var initialVerticalScrollOffset = heightPerMinute * 7 * 60;

    return Column(
      children: [
        const SizedBox(height: 8.0),
        buildCalendar(),
        const SizedBox(height: 4.0),
        Divider(
          color: Theme.of(context).colorScheme.outlineVariant,
          height: 2,
        ),
        Expanded(
          child: EventsPlanner(
            key: oneDayViewKey,
            controller: widget.controller,
            daysShowed: 1,
            heightPerMinute: heightPerMinute,
            initialVerticalScrollOffset: initialVerticalScrollOffset,
            horizontalScrollPhysics: const PageScrollPhysics(),
            daysHeaderParam: DaysHeaderParam(
              daysHeaderVisibility: false,
              dayHeaderTextBuilder: (day) => DateFormat("E d").format(day),
            ),
            onDayChange: (firstDay) {
              setState(() {
                selectedDay = firstDay;
              });
            },
            dayParam: DayParam(
              dayEventBuilder: (event, height, width, heightPerMinute) {
                return DefaultDayEvent(
                  height: height,
                  width: width,
                  title: event.title,
                  description: event.description,
                  color: event.color,
                  textColor: event.textColor,
                  roundBorderRadius: 15,
                  horizontalPadding: 8,
                  verticalPadding: 8,
                  onTap: () => print("tap ${event.uniqueId}"),
                  onTapDown: (details) => print("tapdown ${event.uniqueId}"),
                );
              },
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
        widget.controller.updateFocusedDay(selectedDay);
        oneDayViewKey.currentState?.jumpToDate(selectedDay);
      },
    );
  }
}
