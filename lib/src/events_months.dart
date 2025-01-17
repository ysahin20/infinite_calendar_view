import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sticky_infinite_list/models/alignments.dart';
import 'package:sticky_infinite_list/widget.dart';

import 'controller/events_controller.dart';
import 'events/event.dart';
import 'widgets/month/header.dart';
import 'widgets/month/month.dart';

class EventsMonths extends StatefulWidget {
  const EventsMonths({
    super.key,
    required this.controller,
    this.initialMonth,
    this.maxPreviousMonth = 120,
    this.maxNextMonth = 120,
    this.weekParam = const WeekParam(),
    this.daysParam = const DaysParam(),
    this.onMonthChange,
    this.automaticAdjustScrollToStartOfMonth = true,
    this.verticalScrollPhysics = const BouncingScrollPhysics(
      decelerationRate: ScrollDecelerationRate.fast,
    ),
    this.showWebScrollBar = false,
  });

  /// data controller
  final EventsController controller;

  /// initial first day
  final DateTime? initialMonth;

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

  /// Callback when month change during vertical scroll
  final void Function(DateTime monthFirstDay)? onMonthChange;

  /// Automatic adjust scroll to nearest month and background
  final bool automaticAdjustScrollToStartOfMonth;

  /// Vertical day scroll physics
  final ScrollPhysics verticalScrollPhysics;

  /// show scroll bar for web
  final bool showWebScrollBar;

  @override
  State createState() => EventsMonthsState();
}

class EventsMonthsState extends State<EventsMonths> {
  late ScrollController mainVerticalController;
  late DateTime initialMonth;
  late DateTime _stickyMonth;
  late double _stickyPercent;
  late double _stickyOffset;
  bool _blockAdjustScroll = false;
  bool scrollIsStopped = true;

  @override
  void initState() {
    super.initState();
    var initialDay = widget.initialMonth ?? widget.controller.focusedDay;
    initialMonth = DateTime(initialDay.year, initialDay.month);
    _stickyMonth = initialMonth;
    mainVerticalController = ScrollController();

    if (widget.automaticAdjustScrollToStartOfMonth) {
      autoAdjustScrollToStartOfMonth();
    }
  }

  void autoAdjustScrollToStartOfMonth() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var scroll = mainVerticalController;
      scroll.position.isScrollingNotifier.addListener(() {
        scrollIsStopped = !scroll.position.isScrollingNotifier.value;
        if (scrollIsStopped) {
          if (!_blockAdjustScroll) {
            var adjustedOffset = _stickyPercent < 0.5
                ? scroll.offset - _stickyOffset
                : scroll.offset +
                    (((1 - _stickyPercent) * _stickyOffset) / _stickyPercent);

            Future.delayed(const Duration(milliseconds: 1), () {
              if (scrollIsStopped) {
                _blockAdjustScroll = true;
                scroll.animateTo(
                  adjustedOffset,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeIn,
                );
              }
            });
          } else {
            _blockAdjustScroll = false;
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // week header
        MonthHeader(weekParam: widget.weekParam),

        // months
        Expanded(
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              scrollbars: widget.showWebScrollBar,
              dragDevices: PointerDeviceKind.values.toSet(),
            ),
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
                  headerStateBuilder: (context, state) {
                    if (state.sticky && _stickyMonth != month) {
                      _stickyMonth = month;
                      Future(() {
                        widget.controller.updateFocusedDay(_stickyMonth);
                        widget.onMonthChange?.call(_stickyMonth);
                      });
                    }
                    _stickyPercent = state.position;
                    _stickyOffset = state.offset;
                    return SizedBox.shrink();
                  },
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
        ),
      ],
    );
  }

  /// jump to date
  /// change initial date and redraw all list
  void jumpToDate(DateTime date) {
    if (context.mounted) {
      setState(() {
        initialMonth = DateTime(date.year, date.month);
      });
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
