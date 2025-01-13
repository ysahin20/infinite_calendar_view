import 'package:flutter/material.dart';

const String defaultType = "default";

class Event {
  Event({
    this.columnIndex = 0,
    required this.startTime,
    this.endTime,
    this.isFullDay = false,
    this.title,
    this.description,
    this.data,
    this.eventType = defaultType,
    this.color = Colors.blue,
    this.textColor = Colors.white,
    this.daysIndex,
  }) {
    if (!isFullDay) {
      assert(endTime != null);
      assert(endTime!.isAfter(startTime));
    } else if (endTime != null) {
      assert(endTime!.isAfter(startTime));
    }
  }

  late UniqueKey uuid = UniqueKey();
  final int columnIndex;
  final DateTime startTime;
  final DateTime? endTime;
  final bool isFullDay;
  final String? title;
  final String? description;
  final Color color;
  final Color textColor;
  final Object? data;
  final Object eventType;

  // multi days finder
  final int? daysIndex;

  Event copyWith({
    final int? columnIndex,
    final DateTime? startTime,
    final DateTime? endTime,
    final bool? isFullDay,
    final String? title,
    final String? description,
    final Color? color,
    final Color? textColor,
    final Object? data,
    final Object? eventType,
    final int? daysIndex,
  }) {
    var event = Event(
      columnIndex: columnIndex ?? this.columnIndex,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isFullDay: isFullDay ?? this.isFullDay,
      title: title ?? this.title,
      description: description ?? this.description,
      color: color ?? this.color,
      textColor: textColor ?? this.textColor,
      data: data ?? this.data,
      eventType: eventType ?? this.eventType,
      daysIndex: daysIndex ?? this.daysIndex,
    );
    event.uuid = uuid;
    return event;
  }
}
