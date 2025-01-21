import 'package:flutter/material.dart';
import 'package:infinite_calendar_view/src/utils/event_helder.dart';

import '../events/event.dart';
import '../utils/extension.dart';

typedef EventFilter = List<Event>? Function(
    DateTime date, List<Event>? dayEvents);
typedef UpdateCalendarDataCallback = void Function(CalendarData calendarData);

class EventsController extends ChangeNotifier {
  EventsController();

  // events data
  final CalendarData calendarData = CalendarData();

  // events filter to show on views
  EventFilter dayEventsFilter = (date, dayEvents) => dayEvents;

  // focused day : change when scroll on view
  DateTime focusedDay = DateTime.now();

  // call when focused day change
  void Function(DateTime day)? onFocusedDayChange;

  /// modify event data and update UI
  void updateCalendarData(UpdateCalendarDataCallback fn) {
    fn.call(calendarData);
    notifyListeners();
  }

  // change day event filter and update UI
  void updateDayEventsFilter({required EventFilter newFilter}) {
    dayEventsFilter = newFilter;
    notifyListeners();
  }

  updateFocusedDay(DateTime day) {
    focusedDay = day;
    onFocusedDayChange?.call(day);
  }

  // get events for day with filter applied
  List<Event>? getFilteredDayEvents(
    DateTime date, {
    bool returnDayEvents = true,
    bool returnFullDayEvent = true,
    bool returnMultiDayEvents = true,
    bool returnMultiFullDayEvents = true,
  }) {
    var dayEvents = calendarData.dayEvents[date.withoutTime];
    var dayEventsByType = dayEvents
        ?.where((e) => e.isFullDay
            ? (e.daysIndex == null
                ? returnFullDayEvent
                : returnMultiFullDayEvents)
            : (e.daysIndex == null ? returnDayEvents : returnMultiDayEvents))
        .toList();
    return dayEventsFilter.call(date, dayEventsByType);
  }

  // get day events sorted by startTime
  List<Event>? getSortedFilteredDayEvents(DateTime date) {
    var daysEvents = getFilteredDayEvents(date);
    daysEvents?.sort((a, b) => a.startTime.compareTo(b.startTime));
    return daysEvents;
  }

  // force update UI
  @override
  void notifyListeners() => super.notifyListeners();
}

class CalendarData {
  final dayEvents = <DateTime, List<Event>>{};

  /// add all events and cuts up appointments if they are over several days
  void addEvents(List<Event> events) {
    for (var event in events) {
      var days = event.endTime?.difference(event.startTime).inDays ?? 0;

      // if event is multi days, dispatch in all events days
      for (int i = 0; i <= days; i++) {
        var day = event.startTime.withoutTime.add(Duration(days: i));
        var startTime = i == 0 ? event.startTime : day;
        var endTime = (i == days && !event.isFullDay)
            ? event.endTime
            : day.add(Duration(days: 1, milliseconds: -1));
        var newEvents = event.copyWith(
          startTime: startTime,
          endTime: endTime,
          daysIndex: days > 0 ? i : null,
        );
        _addDayEvent(day, newEvents);
      }
    }
  }

  // add day events
  void _addDayEvent(DateTime day, Event event) {
    var dayDate = day.withoutTime;
    if (!dayEvents.containsKey(dayDate)) {
      dayEvents[dayDate] = [];
    }
    dayEvents[dayDate]?.add(event);
  }

  /// replace all day events
  /// if eventType is entered, replace juste day event type
  void replaceDayEvents(
    DateTime day,
    List<Event> events, [
    final Object? eventType,
  ]) {
    if (eventType != null) {
      dayEvents[day.withoutTime]?.removeWhere((e) => e.eventType == eventType);
    } else {
      dayEvents[day.withoutTime]?.clear();
    }
    addEvents(events);
  }

  /// update one event
  void updateEvent({required Event oldEvent, required Event newEvent}) {
    removeEvent(oldEvent);
    addEvents([newEvent]);
  }

  void removeEvent(Event event) {
    var endTime = event.endTime;
    var days = endTime == null
        ? [event.startTime.withoutTime]
        : getDaysInBetween(
            event.startTime.withoutTime, event.endTime!.withoutTime);
    for (var day in days) {
      dayEvents[day]?.removeWhere((e) => e.uniqueId == event.uniqueId);
    }
  }

  // clear all data
  clearAll() {
    dayEvents.clear();
  }
}
