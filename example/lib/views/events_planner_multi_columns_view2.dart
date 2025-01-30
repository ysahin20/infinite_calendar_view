import 'package:example/data.dart';
import 'package:example/extension.dart';
import 'package:example/utils.dart';
import 'package:flutter/material.dart';
import 'package:infinite_calendar_view/infinite_calendar_view.dart';
import 'package:intl/intl.dart';
import 'package:random_avatar/random_avatar.dart';

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
  var controller = EventsController()
    ..updateCalendarData((calendarData) {
      calendarData.addEvents(multiColumnEvents);
    });
  late double heightPerMinute;
  late double initialVerticalScrollOffset;
  late DateTime day = DateTime.now();

  @override
  void initState() {
    super.initState();
    heightPerMinute = 1.0;
    initialVerticalScrollOffset = heightPerMinute * 7 * 60;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: double.infinity,
          color: Theme.of(context).appBarTheme.backgroundColor,
          child: Center(
            child: Text(
              DateFormat.MMMd().format(day).toUpperCase(),
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        Expanded(
          child: EventsPlanner(
            controller: controller,
            daysShowed: 1,
            heightPerMinute: heightPerMinute,
            initialVerticalScrollOffset: initialVerticalScrollOffset,
            daySeparationWidth: 10,

            // event cell
            dayParam: DayParam(
              dayEventBuilder: (event, height, width, heightPerMinute) =>
                  EventWidget(controller, event, height, width),
              onSlotTap: (columnIndex, exactDateTime, roundDateTime) =>
                  showSnack(context, "Slot Tap column = ${columnIndex}"),
            ),

            // no full day events
            fullDayParam: FullDayParam(fullDayEventsBarVisibility: false),

            // header
            daysHeaderParam: DaysHeaderParam(
              daysHeaderHeight: 90,
              dayHeaderBuilder: (day, isToday) => SizedBox.shrink(),
            ),

            // personalize columns
            columnsParam: ColumnsParam(
              columns: 2,
              columnsWidthRatio: [1 / 2, 1 / 2],
              columnHeaderBuilder: (day, isToday, columIndex, columnWidth) {
                return Avatar(columnWidth: columnWidth, columIndex: columIndex);
              },
            ),

            // personalize offTimes per column
            offTimesParam: OffTimesParam(
              offTimesAllDaysPainter:
                  (column, day, isToday, heightPerMinute, ranges, color) {
                var offTimesDefaultColor = widget.isDarkMode
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
            ),
            onDayChange: (newDay) => setState(() => day = newDay),
          ),
        ),
      ],
    );
  }

  List<OffTimeRange> getHalfTimeRange() => [
        OffTimeRange(
          TimeOfDay(hour: 0, minute: 0),
          TimeOfDay(hour: 9, minute: 0),
        ),
        OffTimeRange(
          TimeOfDay(hour: 13, minute: 0),
          TimeOfDay(hour: 24, minute: 0),
        ),
      ];
}

class Avatar extends StatelessWidget {
  const Avatar({
    super.key,
    required this.columnWidth,
    required this.columIndex,
  });

  final double columnWidth;
  final int columIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: columnWidth,
      child: Column(
        children: [
          SizedBox(height: 20),
          RandomAvatar(
            columIndex == 0 ? 'Suzy' : 'Jose',
            trBackground: false,
            height: 60,
            width: 60,
          ),
          SizedBox(height: 10)
        ],
      ),
    );
  }
}

class EventWidget extends StatelessWidget {
  const EventWidget(
    this.controller,
    this.event,
    this.height,
    this.width,
  );

  final EventsController controller;
  final Event event;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return DraggableEventWidget(
      event: event,
      height: height,
      width: width,
      onDragEnd: (columnIndex, exactStart, exactEnd, roundStart, roundEnd) {
        controller.updateCalendarData(
          (data) => data.updateEvent(
            oldEvent: event,
            newEvent: event.copyWith(
              columnIndex: columnIndex,
              startTime: roundStart,
              endTime: roundEnd,
            ),
          ),
        );
      },
      child: DefaultDayEvent(
        height: height,
        width: width,
        color: event.color.darken(0.12),
        textColor: event.textColor,
        eventMargin: EdgeInsets.all(2),
        roundBorderRadius: 5,
        onTap: () => showSnack(context, "Tap ${event.title}"),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                getSlotHourText(event.startTime, event.endTime!),
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: TextStyle(fontSize: 11),
              ),
            ),
            Flexible(
              child: Text(
                event.title ?? "",
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: TextStyle(fontWeight: FontWeight.w500),
                maxLines: 2,
              ),
            ),
            Flexible(
              child: Text(
                event.description ?? "",
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: TextStyle(fontSize: 11),
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getSlotHourText(DateTime start, DateTime end) {
    return start.hour.toString().padLeft(2, '0') +
        ":" +
        start.hour.toString().padLeft(2, '0') +
        " - " +
        end.hour.toString().padLeft(2, '0') +
        ":" +
        end.hour.toString().padLeft(2, '0');
  }
}
