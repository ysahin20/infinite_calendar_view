import 'package:example/main.dart';
import 'package:example/views/widgets/calendar.dart';
import 'package:flutter/material.dart';
import 'package:infinite_calendar_view/infinite_calendar_view.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class PlannerOneDay extends StatefulWidget {
  const PlannerOneDay({
    super.key,
  });

  @override
  State<PlannerOneDay> createState() => _PlannerOneDayState();
}

class _PlannerOneDayState extends State<PlannerOneDay> {
  GlobalKey<EventsPlannerState> oneDayViewKey = GlobalKey<EventsPlannerState>();
  late DateTime selectedDay;

  @override
  void initState() {
    super.initState();
    selectedDay = eventsController.focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    var heightPerMinute = 1.0;
    var initialVerticalScrollOffset = heightPerMinute * 7 * 60;

    return SafeArea(
      top: true,
      bottom: false,
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PlannerOneDay()));
            },
            child: Text("sss"),
          ),
          Expanded(
            child: EventsPlanner(
              key: oneDayViewKey,
              customSliverWidgets: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const SizedBox(height: 8.0),
                      // buildCalendar(),
                      TableCalendar(
                        firstDay: DateTime.now(),
                        lastDay: DateTime.now().add(const Duration(days: 365)),
                        focusedDay: DateTime.now(),
                        onDaySelected: (DateTime day, DateTime focusedDay) {
                          print(day);
                        },
                      ),
                      const SizedBox(height: 4.0),
                      Divider(
                        color: Theme.of(context).colorScheme.outlineVariant,
                        height: 2,
                      ),
                    ],
                  ),
                ),
              ],
              controller: eventsController,
              daysShowed: 1,
              heightPerMinute: heightPerMinute,
              initialVerticalScrollOffset: initialVerticalScrollOffset,
              horizontalScrollPhysics: const PageScrollPhysics(),
              daysHeaderParam: DaysHeaderParam(
                daysHeaderHeight: 70,
                daysHeaderVisibility: false,
                dayHeaderTextBuilder: (day) => DateFormat("E d").format(day),
              ),
              onDayChange: (firstDay) {
                setState(() {
                  selectedDay = firstDay;
                });
              },
              columnsParam: ColumnsParam(
                columns: 6,
                maxColumns: 3,
                columnsWidthRatio: List.generate(6, (i) => 1 / 3),
                nextColumnsIcon: Icon(Icons.arrow_forward_ios),
                columnHeaderBuilder: (day, isToday, columIndex, columnWidth) {
                  // return DefaultColumnHeader(
                  //   backgroundColor: Colors.blue,
                  //   foregroundColor: Colors.white,
                  //   columnText: ["DSP1", "DSP2", "DSP3"].elementAt(columIndex),
                  //   columnWidth: columnWidth,
                  // );
                  List<String> personNames = [
                    "Jackson, Jack",
                    "Haraldson, Harald",
                    "Johnson, John",
                    "Jimson, Jim",
                    "Carson, Car",
                    "Mason, Ma",
                  ];
                  List<double> thisWeekWorkedHours = [21, 33, 40, 30, 20, 39];
                  List<double> thisWeekTotalEligibleHours = [
                    40,
                    40,
                    40,
                    40,
                    40,
                    40
                  ];

                  return Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          personNames[columIndex],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Montserrat",
                          ),
                        ),
                        SizedBox(height: 4),
                        CircleAvatar(
                          backgroundColor: Colors.red,
                          radius: 10,
                          child: Icon(
                            thisWeekWorkedHours[columIndex] >=
                                    thisWeekTotalEligibleHours[columIndex]
                                ? Icons.error
                                : thisWeekTotalEligibleHours[columIndex] -
                                            thisWeekWorkedHours[columIndex] <
                                        8
                                    ? Icons.warning
                                    : Icons.check,
                            size: 16,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              fullDayParam: const FullDayParam(
                fullDayEventsBarVisibility: false,
                showMultiDayEvents: false,
              ),
              dayParam: DayParam(
                dayCustomPainter: (heightPerMinute, isToday) {
                  return LinesPainter(
                    heightPerMinute: heightPerMinute,
                    isToday: isToday,
                    lineColor: Colors.black12,
                  );
                },
                dayEventBuilder: (event, height, width, heightPerMinute) {
                  return DefaultDayEvent(
                    height: height,
                    width: width,
                    title: event.title,
                    description: event.description,
                    color: event.color,
                    textColor: event.textColor,
                    roundBorderRadius: 15,
                    horizontalPadding: 8,
                    verticalPadding: 8,
                    onTap: () => print("tap ${event.uniqueId}"),
                    onTapDown: (details) => print("tapdown ${event.uniqueId}"),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Calendar buildCalendar() {
    return Calendar(
      selectedDay: selectedDay,
      onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
        setState(() {
          this.selectedDay = selectedDay;
        });
        eventsController.updateFocusedDay(selectedDay);
        oneDayViewKey.currentState?.jumpToDate(selectedDay);
      },
    );
  }
}
