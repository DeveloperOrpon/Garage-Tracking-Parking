import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../provider/adminProvider.dart';
import '../../core/constants/color_constants.dart';
import '../../core/models/data.dart';
import 'calendar_list_widget.dart';

class CalendarWidget extends StatefulWidget {
  final AdminProvider adminProvider;
  const CalendarWidget({super.key, required this.adminProvider});

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  List<CalendarData> _selectedDate = [];
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  List<CalendarData> _eventLoader(DateTime date, AdminProvider adminProvider) {
    return adminProvider.calendarData
        .where((element) => isSameDay(date, element.date))
        .toList();
  }

  void _onDaySelected(
      DateTime selectedDay, DateTime focusedDay, AdminProvider adminProvider) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _selectedDate = adminProvider.calendarData
            .where((element) => isSameDay(selectedDay, element.date))
            .toList();
      });
    }
  }

  @override
  void initState() {
    widget.adminProvider.addBookingInfoInCalender();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    widget.adminProvider.addBookingInfoInCalender();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminProvider>(builder: (context, adminProvider, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Booking show in calendar"),
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "Booking List In Calender",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      DateFormat("MMM, yyyy").format(_focusedDay),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.orange),
                    ),
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            _focusedDay = DateTime(
                                _focusedDay.year, _focusedDay.month - 1);
                          });
                        },
                        child: const Icon(
                          Icons.chevron_left,
                          color: greenColor,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _focusedDay = DateTime(
                                _focusedDay.year, _focusedDay.month + 1);
                          });
                        },
                        child: const Icon(
                          Icons.chevron_right,
                          color: greenColor,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 10),
              TableCalendar<CalendarData>(
                selectedDayPredicate: (day) => isSameDay(_focusedDay, day),
                focusedDay: _focusedDay,
                firstDay: DateTime.utc(2018),
                lastDay: DateTime.utc(2025),
                headerVisible: false,
                onDaySelected: (selectedDay, focusedDay) {
                  _onDaySelected(selectedDay, focusedDay, adminProvider);
                },
                onFormatChanged: (result) {},
                daysOfWeekStyle: DaysOfWeekStyle(
                  dowTextFormatter: (date, locale) {
                    return DateFormat("EEE").format(date).toUpperCase();
                  },
                  weekendStyle: const TextStyle(
                      fontWeight: FontWeight.normal, color: Colors.green),
                  weekdayStyle: const TextStyle(
                      fontWeight: FontWeight.normal, color: Colors.blue),
                ),
                onPageChanged: (day) {
                  _focusedDay = day;
                  setState(() {});
                },
                calendarStyle: const CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: greenColor,
                    shape: BoxShape.circle,
                  ),
                  markerDecoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                ),
                eventLoader: (day) {
                  return _eventLoader(day, adminProvider);
                },
              ),
              const SizedBox(
                height: 8,
              ),
              CalendartList(datas: _selectedDate),
            ],
          ),
        ),
      );
    });
  }
}
