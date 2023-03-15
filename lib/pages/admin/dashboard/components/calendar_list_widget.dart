import 'package:flutter/material.dart';

import '../../core/models/data.dart';
import 'list_calendar_data.dart';

class CalendartList extends StatelessWidget {
  final List<CalendarData> datas;

  const CalendartList({Key? key, required this.datas}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: datas.isEmpty ? _Empty() : _List(list: datas),
    );
  }
}

class _Empty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          textAlign: TextAlign.center,
          'There are no Parking And Garage Information',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ),
    );
  }
}

class _List extends StatelessWidget {
  final List<CalendarData> list;

  const _List({Key? key, required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("🔥 List Of Parking And Garage"),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.orange.shade400,
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListCalendarData(calendarData: list),
        ),
      ],
    );
  }
}
