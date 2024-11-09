import 'package:flutter/material.dart';

enum CalendarView {
  agenda("Agenda", Icons.list),
  day("Day", Icons.calendar_view_day_outlined),
  day3("3 days", Icons.calendar_view_week),
  day7("7 days (web)", Icons.calendar_view_week);

  const CalendarView(
    this.text,
    this.icon,
  );

  final String text;
  final IconData icon;
}
