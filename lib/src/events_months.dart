import 'package:flutter/material.dart';
import 'package:infinite_calendar_view/src/widgets/month/header.dart';
import 'package:infinite_calendar_view/src/widgets/month/month.dart';
import 'package:sticky_infinite_list/models/alignments.dart';
import 'package:sticky_infinite_list/widget.dart';

import 'controller/events_controller.dart';
import 'events/event.dart';

class EventsMonths extends StatefulWidget {
  const EventsMonths({
    super.key,
    required this.controller,
    this.initialDate,
    this.maxPreviousMonth = 120,
    this.maxNextMonth = 120,
    this.weekParam = const WeekParam(),
    this.daysParam = const DaysParam(),
    this.verticalScrollPhysics = const BouncingScrollPhysics(
      decelerationRate: ScrollDecelerationRate.fast,
    ),
  });

  /// data controller
  final EventsController controller;

  /// initial first day
  final DateTime? initialDate;

  /// max horizontal previous days scroll
  /// Null for infinite
  final int? maxPreviousMonth;

  /// max horizontal next days scroll
  /// Null for infinite
  final int? maxNextMonth;

  /// week param
  final WeekParam weekParam;

  /// day param
  final DaysParam daysParam;

  /// Horizontal day scroll physics
  final ScrollPhysics verticalScrollPhysics;

  @override
  State createState() => EventsMonthsState();
}

class EventsMonthsState extends State<EventsMonths> {
  late ScrollController mainVerticalController;
  late DateTime initialMonth;
  bool listenScroll = true;

  @override
  void initState() {
    super.initState();
    var initialDay = widget.initialDate ?? DateTime.now();
    initialMonth = DateTime(initialDay.year, initialDay.month);
    mainVerticalController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // week header
        MonthHeader(weekParam: widget.weekParam),

        // months
        Expanded(
          child: InfiniteList(
            controller: mainVerticalController,
            direction: InfiniteListDirection.multi,
            negChildCount: widget.maxPreviousMonth,
            posChildCount: widget.maxNextMonth,
            physics: widget.verticalScrollPhysics,
            builder: (context, index) {
              var month =
                  DateTime(initialMonth.year, initialMonth.month + index);

              return InfiniteListItem(
                contentBuilder: (context) => Month(
                  controller: widget.controller,
                  month: month,
                  weekParam: widget.weekParam,
                  daysParam: widget.daysParam,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// jump to date
  /// change initial date and redraw all list
  void jumpToDate(DateTime date) {
    if (context.mounted) {
      listenScroll = false;
      setState(() {
        initialMonth = DateTime(date.year, date.month);
      });
      listenScroll = true;
      mainVerticalController.jumpTo(0);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.controller.notifyListeners();
      });
    }
  }
}

class WeekParam {
  const WeekParam({
    this.startOfWeekDay = 7,
    this.weekDecoration,
    this.weekHeight = 117.0,
    this.daySpacing = 4.0,
    this.headerHeight = 45,
    this.headerStyle,
    this.headerDayBuilder,
    this.headerDayText,
    this.headerDayTextColor,
  });

  /// start day of week : 1 = monday, 7 = sunday
  final int startOfWeekDay;

  // week decoration (border...)
  final BoxDecoration? weekDecoration;

  /// week height
  final double weekHeight;

  /// space between day of week
  final double daySpacing;

  /// top header (day of week) height
  final double headerHeight;

  /// top header (day of week) text style
  final TextStyle? headerStyle;

  /// top header (day of week) day builder
  final Widget Function(int dayOfWeek)? headerDayBuilder;

  /// top header (day of week) day text
  final String Function(int dayOfWeek)? headerDayText;

  /// top header (day of week) text color
  final Color Function(int dayOfWeek)? headerDayTextColor;

  static BoxDecoration defaultWeekDecoration(BuildContext context) {
    return BoxDecoration(
      border: Border(
        bottom: BorderSide(
          width: 0.5,
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
    );
  }
}

class DaysParam {
  const DaysParam({
    this.headerHeight = 25.0,
    this.eventHeight = 20.0,
    this.eventSpacing = 2.0,
    this.spaceBetweenHeaderAndEvents = 6.0,
    this.onMonthChange,
    this.dayHeaderBuilder,
    this.dayEventBuilder,
    this.dayMoreEventsBuilder,
    this.onDayTapDown,
    this.onDayTapUp,
  });

  /// header (day of month) height
  final double headerHeight;

  /// event height of container
  final double eventHeight;

  /// vertical space between each event
  final double eventSpacing;

  /// space between header and events
  final double spaceBetweenHeaderAndEvents;

  /// Callback when month change during vertical scroll
  final void Function(DateTime month)? onMonthChange;

  /// day header builder
  final Widget Function(DateTime day)? dayHeaderBuilder;

  final Widget Function(Event event)? dayEventBuilder;

  final Widget Function(int count)? dayMoreEventsBuilder;

  final void Function(DateTime day)? onDayTapDown;

  final void Function(DateTime day)? onDayTapUp;
}
