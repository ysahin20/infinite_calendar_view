import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:infinite_calendar_view/src/controller/events_controller.dart';
import 'package:infinite_calendar_view/src/events/event.dart';
import 'package:infinite_calendar_view/src/events_months.dart';
import 'package:infinite_calendar_view/src/utils/default_text.dart';
import 'package:infinite_calendar_view/src/utils/event_helder.dart';
import 'package:infinite_calendar_view/src/utils/extension.dart';
import 'package:infinite_calendar_view/src/widgets/month/day.dart';

class Week extends StatefulWidget {
  const Week({
    super.key,
    required this.controller,
    required this.weekParam,
    required this.daysParam,
    required this.startOfWeek,
  });

  final DateTime startOfWeek;
  final WeekParam weekParam;
  final DaysParam daysParam;
  final EventsController controller;

  @override
  State<Week> createState() => _WeekState();
}

class _WeekState extends State<Week> {
  late VoidCallback eventListener;
  int maxEventsShowed = 0;
  List<List<Event>?> weekEvents = [];
  List<List<Event?>> weekShowedEvents = [];

  @override
  void initState() {
    super.initState();
    maxEventsShowed = getMaxEventsCanBeShowed();
    updateEvents();
    eventListener = () => updateEvents();
    widget.controller.addListener(eventListener);
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(eventListener);
  }

  /// get max row (events) can be showed to each day
  int getMaxEventsCanBeShowed() {
    var dayParam = widget.daysParam;
    var dayHeight = widget.weekParam.weekHeight;
    var headerHeight = dayParam.headerHeight;
    var eventHeight = dayParam.eventHeight;
    var space = dayParam.eventSpacing;
    var beforeEventSpacing = dayParam.spaceBetweenHeaderAndEvents;
    return ((dayHeight - headerHeight - beforeEventSpacing + space) /
            (eventHeight + space))
        .toInt();
  }

  // update day events when change
  void updateEvents() {
    if (mounted) {
      var weekEvents = getWeekEvents();
      var weekShowedEvents = getShowedWeekEvents(weekEvents, maxEventsShowed);
      // no update if no change for current day
      if (listEquals(weekShowedEvents, this.weekShowedEvents) == false) {
        setState(() {
          this.weekEvents = weekEvents;
          this.weekShowedEvents = weekShowedEvents;
        });
      }
    }
  }

  /// find events of week
  List<List<Event>?> getWeekEvents() {
    List<List<Event>?> eventsList = [];
    for (var day = 0; day < 7; day++) {
      eventsList.add(widget.controller.getSortedFilteredDayEvents(
        widget.startOfWeek.add(Duration(days: day)),
      ));
    }
    return eventsList;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: widget.weekParam.weekDecoration ??
          WeekParam.defaultWeekDecoration(context),
      child: Container(
        height: widget.weekParam.weekHeight,
        child: LayoutBuilder(builder: (context, constraints) {
          var width = constraints.maxWidth;
          var dayWidth = width / 7;

          return DragTarget(
            onAcceptWithDetails: (details) {
              var onDragEnd = details.data as Function(DateTime);
              var dragDay = getPositionDay(
                  Offset(details.offset.dx + dayWidth / 2, details.offset.dy),
                  dayWidth);
              onDragEnd.call(dragDay);
            },
            builder: (context, candidateData, rejectedData) {
              return GestureDetector(
                onTapDown: (details) => widget.daysParam.onDayTapDown
                    ?.call(getPositionDay(details.localPosition, dayWidth)),
                onTapUp: (details) => widget.daysParam.onDayTapUp
                    ?.call(getPositionDay(details.localPosition, dayWidth)),
                behavior: HitTestBehavior.translucent,
                child: Column(
                  children: [
                    // days header
                    Container(
                      height: widget.daysParam.headerHeight,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          for (var dayOfWeek = 0; dayOfWeek < 7; dayOfWeek++)
                            Expanded(child: getHeaderWidget(dayOfWeek)),
                        ],
                      ),
                    ),

                    // week events
                    Container(
                      height: widget.weekParam.weekHeight -
                          widget.daysParam.headerHeight,
                      child: Stack(
                        children: [
                          for (var dayOfWeek = 0; dayOfWeek < 7; dayOfWeek++)
                            for (var eventIndex = 0;
                                eventIndex < weekShowedEvents[dayOfWeek].length;
                                eventIndex++)
                              if (eventIndex < maxEventsShowed)
                                ...getEventOrMoreEventsWidget(
                                    dayOfWeek, eventIndex, dayWidth),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }

  DateTime getPositionDay(Offset localPosition, double dayWidth) {
    var x = localPosition.dx;
    var dayIndex = (x / dayWidth).toInt();
    var day = widget.startOfWeek.add(Duration(days: dayIndex));
    return day;
  }

  // get header of day
  Container getHeaderWidget(int dayOfWeek) {
    var day = widget.startOfWeek.add(Duration(days: dayOfWeek));
    var isStartOfMonth = day.day == 1;
    var colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: widget.daysParam.headerHeight,
      child: widget.daysParam.dayHeaderBuilder?.call(day) ??
          DefaultMonthDayHeader(
            text: isStartOfMonth
                ? "${defaultMonthAbrText[day.month - 1]} 1"
                : day.day.toString(),
            isToday: DateUtils.isSameDay(day, DateTime.now()),
            textColor:
                isStartOfMonth ? colorScheme.onSurface : colorScheme.outline,
          ),
    );
  }

  /// get Event widget or "More" widget
  List<Widget> getEventOrMoreEventsWidget(
    int dayOfWeek,
    int eventIndex,
    double dayWidth,
  ) {
    var daySpacing = widget.weekParam.daySpacing;
    var eventSpacing = widget.daysParam.eventSpacing;
    var eventHeight = widget.daysParam.eventHeight;
    var left = dayOfWeek * dayWidth + (daySpacing / 2);
    var eventsLength = weekEvents[dayOfWeek]?.length ?? 0;

    // More widget
    var isLastSlot = eventIndex == maxEventsShowed - 1;
    var notShowedEventsCount = (eventsLength - maxEventsShowed) + 1;
    if (isLastSlot && notShowedEventsCount > 1) {
      return [
        Positioned(
          left: left,
          top: (maxEventsShowed - 1) * (eventHeight + eventSpacing),
          width: dayWidth - daySpacing,
          height: eventHeight,
          child: widget.daysParam.dayMoreEventsBuilder
                  ?.call(notShowedEventsCount) ??
              DefaultNotShowedMonthEventsWidget(
                context: context,
                eventHeight: eventHeight,
                text: "$notShowedEventsCount others",
              ),
        )
      ];
    }

    // Event widget
    var event = weekShowedEvents[dayOfWeek][eventIndex];
    var isMultiDayOtherDay = (event?.daysIndex ?? 0) > 0 && dayOfWeek > 0;
    if (event != null && !isMultiDayOtherDay) {
      // multi days events duration
      var duration = 1;
      while (weekShowedEvents
              .getOrNull(dayOfWeek + duration)
              ?.getOrNull(eventIndex)
              ?.uniqueId ==
          event.uniqueId) {
        duration++;
      }
      var eventWidth = (dayWidth * duration) - daySpacing;
      var top = weekShowedEvents[dayOfWeek].indexOf(event) *
          (eventHeight + eventSpacing);
      return [
        Positioned(
            left: left,
            top: top,
            width: eventWidth,
            height: eventHeight,
            child: widget.daysParam.dayEventBuilder?.call(
                  event,
                  eventWidth,
                  eventHeight,
                ) ??
                DefaultMonthDayEvent(event: event))
      ];
    }

    return [];
  }
}
