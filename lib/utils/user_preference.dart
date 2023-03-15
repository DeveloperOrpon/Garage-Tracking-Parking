import 'package:shared_preferences/shared_preferences.dart';

const String notificationStatus = 'notification';

Future<bool> setNotificationStatus(bool status) async {
  final pref = await SharedPreferences.getInstance();
  return pref.setBool(notificationStatus, status);
}

Future<bool> getNotificationStatus() async {
  final pref = await SharedPreferences.getInstance();
  return pref.getBool(notificationStatus) ?? false;
}
