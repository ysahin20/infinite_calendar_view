import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../controller/events_controller.dart';
import '../../events/event.dart';
import '../../events/event_arranger.dart';
import '../../events_planner.dart';
import '../../extension.dart';
import '../../painters/events_painters.dart';

class DayWidget extends StatelessWidget {
  const DayWidget({
    super.key,
    required this.controller,
    required this.day,
    required this.todayColor,
    required this.daySeparationWidthPadding,
    required this.plannerHeight,
    required this.heightPerMinute,
    required this.dayWidth,
    required this.dayEventsArranger,
    required this.dayParam,
    required this.currentHourIndicatorParam,
    required this.currentHourIndicatorColor,
    required this.offTimesParam,
  });

  final EventsController controller;
  final DateTime day;
  final Color? todayColor;
  final double daySeparationWidthPadding;
  final double plannerHeight;
  final double heightPerMinute;
  final double dayWidth;
  final EventArranger dayEventsArranger;
  final DayParam dayParam;
  final CurrentHourIndicatorParam currentHourIndicatorParam;
  final Color currentHourIndicatorColor;
  final OffTimesParam offTimesParam;

  @override
  Widget build(BuildContext context) {
    var isToday = DateUtils.isSameDay(day, DateTime.now());
    var dayBackgroundColor = isToday ? todayColor : null;
    var width = dayWidth - (daySeparationWidthPadding * 2);
    var offTimesOfDay = offTimesParam.offTimesDayRanges[day];
    var offTimesDefaultColor = context.isDarkMode
        ? Theme.of(context).colorScheme.surface.lighten(0.03)
        : const Color(0xFFF4F4F4);

    return Padding(
      padding: EdgeInsets.only(
        left: daySeparationWidthPadding,
        right: daySeparationWidthPadding,
        top: dayParam.dayTopPadding,
        bottom: dayParam.dayBottomPadding,
      ),
      child: GestureDetector(
        onTapUp: (details) => dayParam.onSlotTap?.call(
          getExactDateTime(details.localPosition.dy),
          getRoundDateTime(details.localPosition.dy),
        ),
        onLongPressStart: (details) => dayParam.onSlotLongTap?.call(
          getExactDateTime(details.localPosition.dy),
          getRoundDateTime(details.localPosition.dy),
        ),
        onDoubleTapDown: (details) => dayParam.onSlotDoubleTap?.call(
          getExactDateTime(details.localPosition.dy),
          getRoundDateTime(details.localPosition.dy),
        ),
        child: Stack(
          children: [
            // offSet all days painter
            Container(
              width: width,
              height: plannerHeight,
              decoration: BoxDecoration(color: dayBackgroundColor),
              child: CustomPaint(
                foregroundPainter: offTimesParam.offTimesAllDaysPainter?.call(
                      isToday,
                      heightPerMinute,
                      offTimesParam.offTimesAllDaysRanges,
                      offTimesParam.offTimesColor ?? offTimesDefaultColor,
                    ) ??
                    OffSetAllDaysPainter(
                      isToday,
                      heightPerMinute,
                      offTimesParam.offTimesAllDaysRanges,
                      offTimesParam.offTimesColor ?? offTimesDefaultColor,
                    ),
              ),
            ),

            // offSet particular days painter
            if (offTimesOfDay != null)
              SizedBox(
                width: width,
                height: plannerHeight,
                child: CustomPaint(
                  foregroundPainter: offTimesParam.offTimesDayPainter?.call(
                        isToday,
                        heightPerMinute,
                        offTimesParam.offTimesAllDaysRanges,
                        offTimesParam.offTimesColor ?? offTimesDefaultColor,
                      ) ??
                      OffSetAllDaysPainter(
                        false,
                        heightPerMinute,
                        offTimesOfDay,
                        offTimesParam.offTimesColor ?? offTimesDefaultColor,
                      ),
                ),
              ),

            // lines painters
            SizedBox(
              width: width,
              height: plannerHeight,
              child: CustomPaint(
                foregroundPainter: dayParam.dayCustomPainter?.call(
                      heightPerMinute,
                      isToday,
                    ) ??
                    LinesPainter(
                      heightPerMinute: heightPerMinute,
                      isToday: isToday,
                      lineColor: Theme.of(context).colorScheme.outlineVariant,
                    ),
              ),
            ),

            // events
            EventsListWidget(
              controller: controller,
              day: day,
              plannerHeight: plannerHeight -
                  (dayParam.dayTopPadding + dayParam.dayBottomPadding),
              heightPerMinute: heightPerMinute,
              dayWidth: width,
              dayEventsArranger: dayEventsArranger,
              dayEventBuilder: dayParam.dayEventBuilder,
            ),

            // time line indicator
            if (currentHourIndicatorParam.currentHourIndicatorLineVisibility)
              SizedBox(
                width: width,
                height: plannerHeight,
                child: CustomPaint(
                  foregroundPainter: currentHourIndicatorParam
                          .currentHourIndicatorCustomPainter
                          ?.call(heightPerMinute, isToday) ??
                      TimeIndicatorPainter(
                        heightPerMinute,
                        isToday,
                        currentHourIndicatorColor,
                      ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  DateTime getExactDateTime(double dy) {
    var dayMinute = dy / heightPerMinute;
    return day.withoutTime.add(Duration(minutes: dayMinute.toInt()));
  }

  DateTime getRoundDateTime(double dy) {
    var dayMinute = dy / heightPerMinute;
    var dayMinuteRounded = dayParam.onSlotMinutesRound *
        (dayMinute / dayParam.onSlotMinutesRound)
            .round(); // Round to nearest multiple of 10 minutes
    return day.withoutTime.add(Duration(minutes: dayMinuteRounded.toInt()));
  }
}

class EventsListWidget extends StatefulWidget {
  const EventsListWidget({
    super.key,
    required this.controller,
    required this.day,
    required this.plannerHeight,
    required this.heightPerMinute,
    required this.dayWidth,
    required this.dayEventsArranger,
    required this.dayEventBuilder,
  });

  final EventsController controller;
  final DateTime day;
  final double plannerHeight;
  final double heightPerMinute;
  final double dayWidth;
  final EventArranger dayEventsArranger;
  final Widget Function(
          Event event, double height, double width, double heightPerMinute)?
      dayEventBuilder;

  @override
  State<EventsListWidget> createState() => _EventsListWidgetState();
}

class _EventsListWidgetState extends State<EventsListWidget> {
  List<Event>? events;
  var organizedEvents = <OrganizedEvent>[];
  late double heightPerMinute;
  late VoidCallback eventListener;

  @override
  void initState() {
    super.initState();
    heightPerMinute = widget.heightPerMinute;
    eventListener = () => updateEvents();
    widget.controller.addListener(eventListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      updateEvents();
    });
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(eventListener);
  }

  void updateEvents() {
    if (mounted) {
      var dayEvents = widget.controller.getFilteredDayEvents(widget.day);

      // no update if no change for current day
      if ((listEquals(dayEvents, events) == false) ||
          (heightPerMinute != widget.heightPerMinute)) {
        setState(() {
          heightPerMinute = widget.heightPerMinute;
          events = dayEvents != null ? [...dayEvents] : null;
          var arranger = widget.dayEventsArranger;
          organizedEvents = arranger.arrange(
            events: events ?? [],
            height: widget.plannerHeight,
            width: widget.dayWidth,
            heightPerMinute: heightPerMinute,
            type: "",
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var scale = 1.0;
    // dynamically resize event when scale update (without complete arrange)
    if (heightPerMinute != widget.heightPerMinute) {
      scale = widget.heightPerMinute / heightPerMinute;
    }
    return SizedBox(
      height: widget.plannerHeight,
      width: widget.dayWidth,
      child: Stack(
        children: organizedEvents
            .map((e) => Positioned(
                  left: e.left,
                  top: e.top * scale,
                  right: e.right,
                  bottom: e.bottom * scale,
                  child: getEventWidget(e),
                ))
            .toList(),
      ),
    );
  }

  Widget getEventWidget(OrganizedEvent organizedEvent) {
    var height =
        widget.plannerHeight - organizedEvent.bottom - organizedEvent.top;
    var width = widget.dayWidth - organizedEvent.left - organizedEvent.right;

    if (widget.dayEventBuilder != null) {
      return widget.dayEventBuilder!
          .call(organizedEvent.event, height, width, heightPerMinute);
    }
    return DefaultDayEvent(
      title: organizedEvent.event.title,
      description: organizedEvent.event.description,
      color: organizedEvent.event.color,
      textColor: organizedEvent.event.textColor,
      height: height,
      width: width,
    );
  }
}

class DefaultDayEvent extends StatelessWidget {
  const DefaultDayEvent({
    super.key,
    required this.height,
    required this.width,
    this.title,
    this.description,
    this.color = Colors.blue,
    this.textColor = Colors.white,
    this.titleFontSize = 14,
    this.descriptionFontSize = 10,
    this.horizontalPadding = 4,
    this.verticalPadding = 4,
    this.eventMargin = const EdgeInsets.all(1),
  });

  final String? title;
  final String? description;
  final Color color;
  final double height;
  final double width;
  final Color textColor;
  final double titleFontSize;
  final double descriptionFontSize;
  final double horizontalPadding;
  final double verticalPadding;
  final EdgeInsetsGeometry? eventMargin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: eventMargin,
      decoration: BoxDecoration(color: color),
      width: width,
      height: height,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: height > 30 ? verticalPadding : 0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title?.isNotEmpty == true)
              Flexible(
                child: Text(
                  title!,
                  style: TextStyle(
                    color: textColor,
                    fontSize: titleFontSize,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            if (description?.isNotEmpty == true)
              Flexible(
                child: Text(
                  description!,
                  style: TextStyle(
                    color: textColor,
                    fontSize: descriptionFontSize,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 4,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
