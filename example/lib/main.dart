import 'package:example/views/events_months_view.dart';
import 'package:example/views/events_planner_multi_columns_view.dart';
import 'package:example/views/events_planner_one_day_view.dart';
import 'package:example/views/events_planner_three_days_view.dart';
import 'package:flutter/material.dart';
import 'package:infinite_calendar_view/infinite_calendar_view.dart';

import 'app_bar.dart';
import 'data.dart';
import 'enumerations.dart';
import 'views/events_list_view.dart';
import 'views/events_planner_draggable_events_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  EventsController eventsController = EventsController();
  var calendarMode = CalendarView.day3;
  var darkMode = false;

  @override
  void initState() {
    super.initState();
    eventsController.updateCalendarData((calendarData) {
      calendarData.addEvents(events);
      calendarData.addEvents(fullDayEvents);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Infinite Calendar View',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        primaryColor: Colors.blue,
        appBarTheme: AppBarTheme(backgroundColor: Colors.blue),
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light,
          seedColor: Colors.blue,
          primary: Colors.blue,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        appBarTheme: AppBarTheme(backgroundColor: Color(0xff2F2F2F)),
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: Colors.blueAccent,
        ),
      ),
      themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        appBar: CustomAppBar(
          eventsController: eventsController,
          onChangeCalendarView: (calendarMode) =>
              setState(() => this.calendarMode = calendarMode),
          onChangeDarkMode: (darkMode) =>
              setState(() => this.darkMode = darkMode),
        ),
        body: CalendarViewWidget(
            calendarMode: calendarMode,
            controller: eventsController,
            darkMode: darkMode),
      ),
    );
  }
}

class CalendarViewWidget extends StatelessWidget {
  const CalendarViewWidget({
    super.key,
    required this.calendarMode,
    required this.controller,
    required this.darkMode,
  });

  final CalendarView calendarMode;
  final EventsController controller;
  final bool darkMode;

  @override
  Widget build(BuildContext context) {
    return switch (calendarMode) {
      CalendarView.agenda => EventsListView(
          controller: controller,
        ),
      CalendarView.day => EventsPlannerOneDayView(
          key: UniqueKey(),
          controller: controller,
          isDarkMode: darkMode,
        ),
      CalendarView.day3 => EventsPlannerTreeDaysView(
          key: UniqueKey(),
          controller: controller,
          isDarkMode: darkMode,
        ),
      CalendarView.draggableDay3 => EventsPlannerDraggableEventsView(
          key: UniqueKey(),
          controller: controller,
          daysShowed: 3,
          isDarkMode: darkMode,
        ),
      CalendarView.day7 => EventsPlannerDraggableEventsView(
          key: UniqueKey(),
          controller: controller,
          daysShowed: 7,
          isDarkMode: darkMode,
        ),
      CalendarView.multi_column => EventsPlannerMultiColumnView(
          key: UniqueKey(),
          isDarkMode: darkMode,
        ),
      CalendarView.month => EventsMonthsView(
          controller: controller,
        ),
    };
  }
}
