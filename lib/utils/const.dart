import 'package:flutter/material.dart';

const String takaSymbol = " ৳";
const String isAdmin = "admin";
const String isGarageOwner = "isGarageOwner";

List<Gradient> movieListGradient = [
  LinearGradient(
    colors: [
      Color.fromARGB(255, 235, 77, 11).withOpacity(0.3),
      Color.fromARGB(255, 252, 153, 11).withOpacity(0.3),
    ],
    begin: Alignment.bottomRight,
    end: Alignment.topLeft,
  ),
  LinearGradient(colors: [
    const Color.fromARGB(255, 42, 174, 235).withOpacity(0.3),
    const Color.fromARGB(255, 126, 212, 252).withOpacity(0.3),
  ]),
  const LinearGradient(
    colors: [
      Color(0xfffc7efc),
      Color(0xffeb2aeb),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  const LinearGradient(colors: [
    Color.fromARGB(255, 235, 77, 42),
    Color.fromARGB(255, 252, 153, 126),
  ]),
  const LinearGradient(colors: [
    Color.fromARGB(255, 42, 174, 235),
    Color.fromARGB(255, 126, 212, 252),
  ]),
  const LinearGradient(colors: [
    Color.fromARGB(255, 235, 77, 42),
    Color.fromARGB(255, 252, 153, 126),
  ]),
  const LinearGradient(colors: [
    Color(0xffeb2aeb),
    Color(0xfffc7efc),
  ]),
  const LinearGradient(colors: [
    Color.fromARGB(255, 235, 77, 42),
    Color.fromARGB(255, 252, 153, 126),
  ]),
  const LinearGradient(colors: [
    Color.fromARGB(255, 42, 174, 235),
    Color.fromARGB(255, 126, 212, 252),
  ]),
  const LinearGradient(colors: [
    Color.fromARGB(255, 235, 77, 42),
    Color.fromARGB(255, 252, 153, 126),
  ]),
];

List<Color> randomColors = [
  Color.fromARGB(255, 235, 77, 11).withOpacity(0.3),
  Color.fromARGB(255, 252, 153, 11).withOpacity(0.3),
  Color.fromARGB(255, 42, 174, 235),
  Color(0xfffc7efc),
  Color(0xffeb2aeb),
  Color.fromARGB(255, 126, 212, 252),
  Color(0xffeb2aeb),
  Color(0xfffc7efc),
  Color.fromARGB(255, 235, 77, 42),
  Color.fromARGB(255, 252, 153, 126),
];
