import 'dart:async';
import 'dart:developer' as out;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parking_koi/pages/redirect_page.dart';
import 'package:parking_koi/provider/adminProvider.dart';
import 'package:parking_koi/provider/mapProvider.dart';
import 'package:parking_koi/utils/language_translate.dart';
import 'package:provider/provider.dart';

import 'controllers/home_controller.dart';
import 'controllers/login_controller.dart';
import 'controllers/map_controller.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  out.log("Handling a background message: ${message.messageId}");
}

void main() async {
  Get.put(LoginController());
  Get.put(HomeController());
  Get.put(MapController());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: true,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  out.log('User granted permission: ${settings.authorizationStatus}');
  final fcmToken = await FirebaseMessaging.instance.getToken();
  //outPut.log("FCM: $fcmToken");
  await FirebaseMessaging.instance.subscribeToTopic('promo');
  await FirebaseMessaging.instance.subscribeToTopic('newproduct');
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {});

  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => MapProvider()),
      ChangeNotifierProvider(create: (context) => AdminProvider()),
    ], child: const MyApp()),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription? connection;

  @override
  void initState() {
    connection = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        Fluttertoast.showToast(
          msg: "Check your internet connection",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 18.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: "You are Online",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 18.0,
        );
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    connection!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: LocaleString(),
      locale: const Locale('en', 'US'),
      title: 'Parking & Garage Tracking',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        textTheme: GoogleFonts.robotoSerifTextTheme(),
      ),
      home: const RedirectPage(),
      builder: EasyLoading.init(),
    );
  }
}
