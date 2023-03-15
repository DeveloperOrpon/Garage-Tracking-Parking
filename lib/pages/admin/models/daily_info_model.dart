import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../core/constants/color_constants.dart';

class DailyInfoModel {
  IconData? icon;
  String? title;
  String? totalStorage;
  int? volumeData;
  int? percentage;
  Color? color;
  List<Color>? colors;
  List<FlSpot>? spots;

  DailyInfoModel({
    this.icon,
    this.title,
    this.totalStorage,
    this.volumeData,
    this.percentage,
    this.color,
    this.colors,
    this.spots,
  });

  DailyInfoModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    volumeData = json['volumeData'];
    icon = json['icon'];
    totalStorage = json['totalStorage'];
    color = json['color'];
    percentage = json['percentage'];
    colors = json['colors'];
    spots = json['spots'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['volumeData'] = this.volumeData;
    data['icon'] = this.icon;
    data['totalStorage'] = this.totalStorage;
    data['color'] = this.color;
    data['percentage'] = this.percentage;
    data['colors'] = this.colors;
    data['spots'] = this.spots;
    return data;
  }
}

List<DailyInfoModel> dailyDatas =
    dailyData.map((item) => DailyInfoModel.fromJson(item)).toList();

var dailyData = [
  {
    "title": "All Parking",
    "volumeData": 1328,
    "icon": Icons.location_on_rounded,
    "totalStorage": "+ %20",
    "color": primaryColor,
    "percentage": 35,
    "colors": [
      const Color(0xff23b6e6),
      const Color(0xff23b6e6),
    ],
    "spots": [
      const FlSpot(1, 2),
      const FlSpot(2, 1.0),
      const FlSpot(3, 1.8),
      const FlSpot(4, 1.5),
      const FlSpot(5, 1.0),
      const FlSpot(6, 2.2),
      const FlSpot(7, 1.8),
      const FlSpot(8, 1.5)
    ]
  },
  {
    "title": "All Garage",
    "volumeData": 1328,
    "icon": Icons.storefront_rounded,
    "totalStorage": "+ %5",
    "color": Color(0xFFFFA113),
    "percentage": 35,
    "colors": [Color(0xfff12711), Color(0xfff5af19)],
    "spots": [
      const FlSpot(1, 1.3),
      const FlSpot(2, 1.0),
      const FlSpot(3, 4),
      const FlSpot(4, 1.5),
      const FlSpot(5, 1.0),
      const FlSpot(6, 3),
      const FlSpot(7, 1.8),
      const FlSpot(8, 1.5)
    ]
  },
  {
    "title": "Parking Booking Request",
    "volumeData": 1328,
    "icon": Icons.local_parking,
    "totalStorage": "+ %8",
    "color": Color(0xFFA4CDFF),
    "percentage": 10,
    "colors": [Color(0xff2980B9), Color(0xff6DD5FA)],
    "spots": [
      FlSpot(1, 1.3),
      FlSpot(2, 5),
      FlSpot(3, 1.8),
      FlSpot(4, 6),
      FlSpot(5, 1.0),
      FlSpot(6, 2.2),
      FlSpot(7, 1.8),
      FlSpot(8, 1)
    ]
  },
  {
    "title": "Garage Request",
    "volumeData": 1328,
    "icon": Icons.garage_sharp,
    "totalStorage": "+ %8",
    "color": const Color(0xFFd50000),
    "percentage": 10,
    "colors": [const Color(0xff93291E), Color(0xffED213A)],
    "spots": [
      const FlSpot(1, 3),
      const FlSpot(2, 4),
      const FlSpot(3, 1.8),
      const FlSpot(4, 1.5),
      const FlSpot(5, 1.0),
      const FlSpot(6, 2.2),
      const FlSpot(7, 1.8),
      const FlSpot(8, 1.5)
    ]
  },
  {
    "title": "Ads Request",
    "volumeData": 5328,
    "icon": Icons.add_location_alt_rounded,
    "totalStorage": "- %5",
    "color": Color(0xFF00F260),
    "percentage": 78,
    "colors": [Color(0xff0575E6), Color(0xff00F260)],
    "spots": [
      FlSpot(1, 1.3),
      FlSpot(2, 1.0),
      FlSpot(3, 1.8),
      FlSpot(4, 1.5),
      FlSpot(5, 1.0),
      FlSpot(6, 2.2),
      FlSpot(7, 1.8),
      FlSpot(8, 1.5)
    ]
  },
  {
    "title": "Show All User",
    "volumeData": 5328,
    "icon": Icons.person,
    "totalStorage": "- %5",
    "color": Color(0xff0575E6),
    "percentage": 78,
    "colors": [Color(0xff0575E6), Color(0xfff29100)],
    "spots": [
      FlSpot(1, 1.3),
      FlSpot(2, 1.0),
      FlSpot(3, 1.8),
      FlSpot(4, 1.5),
      FlSpot(5, 1.0),
      FlSpot(6, 2.2),
      FlSpot(7, 1.8),
      FlSpot(8, 1.5)
    ]
  },
  {
    "title": "Comment & Rating Request",
    "volumeData": 5328,
    "icon": Icons.comment,
    "totalStorage": "- %5",
    "color": Color(0xffd005e6),
    "percentage": 78,
    "colors": [Color(0xffd005e6), Color(0xfff29100)],
    "spots": [
      FlSpot(1, 1.3),
      FlSpot(2, 1.0),
      FlSpot(3, 1.8),
      FlSpot(4, 1.5),
      FlSpot(5, 1.0),
      FlSpot(6, 2.2),
      FlSpot(7, 1.8),
      FlSpot(8, 1.5)
    ]
  },
  {
    "title": "Vat and Coupon Code",
    "volumeData": 5328,
    "icon": Icons.monetization_on,
    "totalStorage": "- %5",
    "color": Color(0xffe60505),
    "percentage": 78,
    "colors": [Color(0xffd005e6), Color(0xfff29100)],
    "spots": [
      FlSpot(1, 1.3),
      FlSpot(2, 1.0),
      FlSpot(3, 1.8),
      FlSpot(4, 1.5),
      FlSpot(5, 1.0),
      FlSpot(6, 2.2),
      FlSpot(7, 1.8),
      FlSpot(8, 1.5)
    ]
  },
  {
    "title": "Become A Garage Owner Request",
    "volumeData": 5328,
    "icon": Icons.offline_bolt,
    "totalStorage": "- %5",
    "color": Color(0xff8805e6),
    "percentage": 78,
    "colors": [Color(0xff63e605), Color(0xfff20030)],
    "spots": [
      FlSpot(1, 1.3),
      FlSpot(2, 1.0),
      FlSpot(3, 1.8),
      FlSpot(4, 1.5),
      FlSpot(5, 1.0),
      FlSpot(6, 2.2),
      FlSpot(7, 1.8),
      FlSpot(8, 1.5)
    ]
  },
  {
    "title": "Cash Withdraw Request",
    "volumeData": 5328,
    "icon": FontAwesomeIcons.moneyCheckDollar,
    "totalStorage": "- %5",
    "color": Colors.orange,
    "percentage": 78,
    "colors": [Color(0xff63e605), Color(0xfff20030)],
    "spots": [
      FlSpot(1, 1.3),
      FlSpot(2, 1.0),
      FlSpot(3, 1.8),
      FlSpot(4, 1.5),
      FlSpot(5, 1.0),
      FlSpot(6, 2.2),
      FlSpot(7, 1.8),
      FlSpot(8, 1.5)
    ]
  }
];
