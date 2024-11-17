import 'dart:math';

import 'package:example/extension.dart';
import 'package:flutter/material.dart';
import 'package:infinite_calendar_view/infinite_calendar_view.dart';

DateTime get _now => DateTime.now();
List<Event> events = generateRandomEvents(250);
List<Event> events2 = [
  Event(
    title: "Project meeting",
    description: "Today is project meeting.",
    startTime: DateTime(_now.year, _now.month, _now.day, 18, 30),
    endTime: DateTime(_now.year, _now.month, _now.day, 22),
    color: Colors.red.pastel,
    textColor: Colors.red.onPastel,
  ),
  Event(
    startTime: DateTime(_now.year, _now.month, _now.day, 18),
    endTime: DateTime(_now.year, _now.month, _now.day, 19),
    title: "Wedding anniversary",
    description: "Attend uncle's wedding anniversary.",
    color: Colors.yellow.pastel,
    textColor: Colors.yellow.onPastel,
  ),
  Event(
    startTime: DateTime(_now.year, _now.month, _now.day, 14),
    endTime: DateTime(_now.year, _now.month, _now.day, 17),
    title: "Football Tournament",
    description: "Go to football tournament.",
    color: Colors.purple.pastel,
    textColor: Colors.purple.onPastel,
  ),
  Event(
    startTime: DateTime(_now.add(Duration(days: 3)).year,
        _now.add(Duration(days: 3)).month, _now.add(Duration(days: 3)).day, 10),
    endTime: DateTime(_now.add(Duration(days: 3)).year,
        _now.add(Duration(days: 3)).month, _now.add(Duration(days: 3)).day, 14),
    title: "Sprint Meeting.",
    description: "Last day of project submission for last year.",
    color: Colors.cyanAccent.pastel,
    textColor: Colors.cyanAccent.onPastel,
  ),
  Event(
    startTime: DateTime(
        _now.subtract(Duration(days: 2)).year,
        _now.subtract(Duration(days: 2)).month,
        _now.subtract(Duration(days: 2)).day,
        14),
    endTime: DateTime(
        _now.subtract(Duration(days: 2)).year,
        _now.subtract(Duration(days: 2)).month,
        _now.subtract(Duration(days: 2)).day,
        16),
    title: "Team Meeting",
    description: "Team Meeting",
    color: Colors.green.pastel,
    textColor: Colors.green.onPastel,
  ),
  Event(
    startTime: DateTime(
        _now.subtract(Duration(days: 2)).year,
        _now.subtract(Duration(days: 2)).month,
        _now.subtract(Duration(days: 2)).day,
        10),
    endTime: DateTime(
        _now.subtract(Duration(days: 2)).year,
        _now.subtract(Duration(days: 2)).month,
        _now.subtract(Duration(days: 2)).day,
        12),
    title: "Chemistry Viva",
    description: "Today is Joe's birthday.",
    color: Colors.blue.pastel,
    textColor: Colors.blue.onPastel,
  ),
];

List<Event> generateRandomEvents(int count) {
  final random = Random();
  final colors = [
    Colors.red,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.green,
    Colors.brown,
    Colors.purple,
    Colors.pink,
    Colors.cyanAccent,
    Colors.grey
  ];
  final titles = [
    "Project meeting",
    "Team brainstorming",
    "Client presentation",
    "Weekly sync",
    "Development session",
    "Design review",
    "Lunch meeting",
    "Stand-up",
    "Workshop",
    "Demo",
    "Product planning",
    "One-on-one",
    "Strategy session",
    "Goal review",
    "Budget discussion",
    "Quarterly update",
    "Marketing campaign planning",
    "Engineering sync",
    "HR review",
    "Sales strategy meeting",
    "Research update",
    "Performance review",
    "Sprint planning",
    "Retrospective",
    "Innovation day",
    "Recruitment meeting",
    "Customer feedback review",
    "UX research session",
    "Product launch",
    "Operations check-in",
    "Team-building activity",
    "Legal briefing",
    "Finance review",
    "Security audit",
    "Onboarding session",
    "Tech talk",
    "Town hall",
    "Press release planning",
    "Product roadmap review",
    "Data analytics review",
    "Executive briefing",
    "Industry trends review",
    "Company update",
    "Customer success sync",
    "PR strategy meeting",
    "Leadership meeting",
    "Investor relations update",
    "Product demo",
    "Webinar planning",
    "End-of-year celebration"
  ];

  return List.generate(count, (index) {
    // Random title and description
    final title = titles[random.nextInt(titles.length)];
    final description = "Today is the $title, make sure to attend and prepare.";

    // Random start time (current day, random hour between 8 and 18)
    final startHour = 8 + random.nextInt(10);
    final startMinute = random.nextInt(60);
    final startTime = DateTime(
        _now.year,
        _now.month,
        _now.day + random.nextInt(60) - 30,
        startHour.toInt(),
        startMinute.toInt());

    // Random duration (1-3 hours)
    final duration = 1 + random.nextInt(2);
    final endTime = startTime.add(Duration(hours: duration.toInt()));

    // Random color
    final color = colors[random.nextInt(colors.length)];

    return Event(
      title: title,
      description: description,
      startTime: startTime,
      endTime: endTime,
      color: color.pastel,
      textColor: color.onPastel,
    );
  });
}

List<FullDayEvent> fullDayEvents = [
  FullDayEvent(
    title: "vacation",
    color: Colors.grey,
    textColor: Colors.white,
  ),
];
