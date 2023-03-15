import 'package:intl/intl.dart';

class CalendarData {
  String id;
  final String title;
  final String userName;
  final DateTime date;
  final String duration;
  final String cost;
  final String address;

  String getDate() {
    final formatter = DateFormat('hh:mm a');

    return formatter.format(date);
  }

  CalendarData({
    required this.id,
    required this.title,
    required this.userName,
    required this.date,
    required this.duration,
    required this.cost,
    required this.address,
  });
}
