import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_activity_recognition/flutter_activity_recognition.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googlelogin/Component/Repository.dart';
import 'package:googlelogin/controller/PagesNavigator.dart';
import 'package:googlelogin/pages/HomePage.dart';
import 'package:googlelogin/pages/Login.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';
import 'dart:developer' as dev;
import 'package:intl/intl.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();
  runApp(MyApp());
}

final GoogleSignIn _googleSignIn = GoogleSignIn();

class MyApp extends StatefulWidget {
  _Myapp createState() => _Myapp();
}

class _Myapp extends State<MyApp> {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final AndroidInitializationSettings _androidInitializationSettings =
      AndroidInitializationSettings('logo');

  void initialiseNOtifications() async {
    InitializationSettings initializationSettings =
        InitializationSettings(android: _androidInitializationSettings);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void Notify(String title, String body) async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max, priority: Priority.high);

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin.periodicallyShow(
        0, title, body, RepeatInterval.hourly, notificationDetails);
  }

  final _activityStreamController = StreamController<Activity>();
  StreamSubscription<Activity>? _activityStreamSubscription;

  void _onActivityReceive(Activity activity) {
    dev.log('Activity Detected >> ${activity.toJson()}');
    _activityStreamController.sink.add(activity);
  }

  void _handleError(dynamic error) {
    dev.log('Catch Error >> $error');
  }

  bool D(String v, String id) {
    final now = DateTime.now();

    String noww = DateFormat('yyyy-MM-dd').format(now);
    var check = DateTime.parse(v);
    String checkk = DateFormat('yyyy-MM-dd').format(check);
    if (checkk == noww) {
      return true;
    } else {
      return false;
    }
  }

  void initState() {
    super.initState();
    _flutterLocalNotificationsPlugin.cancelAll();
    initialiseNOtifications();

    Notify('ifit', 'Keep going');

    signin().then((value) async {
      if (value == true) {
        await FirebaseFirestore.instance
            .collection("users")
            .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .get()
            .then((value) {
          if (D(value.docs.first["steps date"],
                  FirebaseAuth.instance.currentUser!.uid) ==
              false) {
            FirebaseFirestore.instance
                .collection("users")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .update({"calc": "no"});
          }
        });

        HealthAppState().fetchStepDataforyesterday().then((value) async {
          await FirebaseFirestore.instance
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({
            "steps": value.toString(),
            "steps date": '${DateTime.now()}'
          });
        });
        await FirebaseFirestore.instance
            .collection("users")
            .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .get()
            .then((value) {
          if (value.docs.first["calc"] == "no") {
            int calc = (int.parse(value.docs.first["steps"]) / 500) < 1
                ? 0
                : (int.parse(value.docs.first["steps"]) / 500).toInt();
            int points = int.parse(value.docs.first["points"]);
            calc = calc + points;
            FirebaseFirestore.instance
                .collection("users")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .update({"points": "$calc", "calc": "yes"});
          }
        });

        HealthAppState().fetchStepDataforweeklyboard().then((value) async {
          await FirebaseFirestore.instance
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({
            "weekly steps": value.toString(),
            "weekly steps date": '${DateTime.now()}'
          });
        });
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final activityRecognition = FlutterActivityRecognition.instance;

      // Check if the user has granted permission. If not, request permission.
      PermissionRequestResult reqResult;
      reqResult = await activityRecognition.checkPermission();
      if (reqResult == PermissionRequestResult.PERMANENTLY_DENIED) {
        dev.log('Permission is permanently denied.');
        return;
      } else if (reqResult == PermissionRequestResult.DENIED) {
        reqResult = await activityRecognition.requestPermission();
        if (reqResult != PermissionRequestResult.GRANTED) {
          dev.log('Permission is denied.');
          return;
        }
      }

      // Subscribe to the activity stream.
      _activityStreamSubscription = activityRecognition.activityStream
          .handleError(_handleError)
          .listen(_onActivityReceive);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: signin(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == true) {
            return MaterialApp(home: PagesNavigator() //PagesNavigator(),
                );
          } else {
            return MaterialApp(
              home: Login(),
            );
          }
        } else {
          return MaterialApp(
            home: Login(),
          );
        }
      },
    );
  }
}

Future<bool> signin() {
  return _googleSignIn.isSignedIn();
}
