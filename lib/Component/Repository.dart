import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:health/health.dart';

class HealthApp extends StatefulWidget {
  @override
  HealthAppState createState() => HealthAppState();
}

enum AppState {
  DATA_NOT_FETCHED,
  FETCHING_DATA,
  DATA_READY,
  NO_DATA,
  AUTH_NOT_GRANTED,
  DATA_ADDED,
  DATA_NOT_ADDED,
  STEPS_READY,
}

class HealthAppState extends State<HealthApp> {
  List<HealthDataPoint> healthDataList = [];
  AppState _state = AppState.DATA_NOT_FETCHED;
  int _nofSteps = 10;
  double _mgdl = 10.0;

  // create a HealthFactory for use in the app
  HealthFactory health = HealthFactory();

  /// Fetch data points from the health plugin and show them in the app.
  Future fetchData() async {
    setState(() => _state = AppState.FETCHING_DATA);

    // define the types to get
    final types = [
      HealthDataType.MOVE_MINUTES,
      HealthDataType.STEPS,
      HealthDataType.WEIGHT,
      HealthDataType.HEIGHT,
      HealthDataType.BLOOD_GLUCOSE,
      HealthDataType.WORKOUT,
      // Uncomment these lines on iOS - only available on iOS
      // HealthDataType.AUDIOGRAM
    ];

    // with coresponsing permissions
    final permissions = [
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      // HealthDataAccess.READ,
    ];

    // get data within the last 24 hours
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);
    // requesting access to the data types before reading them
    // note that strictly speaking, the [permissions] are not
    // needed, since we only want READ access.
    bool requested =
        await health.requestAuthorization(types, permissions: permissions);
    print('requested: $requested');

    // If we are trying to read Step Count, Workout, Sleep or other data that requires
    // the ACTIVITY_RECOGNITION permission, we need to request the permission first.
    // This requires a special request authorization call.
    //
    // The location permission is requested for Workouts using the Distance information.
    await Permission.activityRecognition.request();
    await Permission.location.request();

    if (requested) {
      try {
        // fetch health data
        List<HealthDataPoint> healthData =
            await health.getHealthDataFromTypes(midnight, now, types);
        // save all the new data points (only the first 100)
        healthDataList.addAll((healthData.length < 100)
            ? healthData
            : healthData.sublist(0, 100));
      } catch (error) {
        print("Exception in getHealthDataFromTypes: $error");
      }

      // filter out duplicates
      healthDataList = HealthFactory.removeDuplicates(healthDataList);

      // print the results
      healthDataList.forEach((x) => print(x));

      // update the UI to display the results
      setState(() {
        _state =
            healthDataList.isEmpty ? AppState.NO_DATA : AppState.DATA_READY;
      });
    } else {
      print("Authorization not granted");
      setState(() => _state = AppState.DATA_NOT_FETCHED);
    }
  }

  Future movingmins() async {
    List<HealthDataPoint> movingmins = [];

    final types = [HealthDataType.MOVE_MINUTES];
    final permissions = [HealthDataAccess.READ];
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    bool requested =
        await health.requestAuthorization(types, permissions: permissions);

    await Permission.activityRecognition.request();
    await Permission.location.request();

    if (requested) {
      try {
        // fetch health data
        List<HealthDataPoint> healthData =
            await health.getHealthDataFromTypes(midnight, now, types);
        // save all the new data points (only the first 100)
        movingmins.addAll(healthData);
      } catch (error) {
        print("Exception in getHealthDataFromTypes: $error");
      }

      // filter out duplicates
      movingmins = HealthFactory.removeDuplicates(movingmins);

      return movingmins.length;
    }
  }

  // movingW
  Future movingminsW() async {
    List<List<HealthDataPoint>> movingmins = [];

    final types = [HealthDataType.MOVE_MINUTES];
    final permissions = [HealthDataAccess.READ];
    final now = DateTime.now();
    final midnight1 = DateTime(now.year, now.month, now.day);
    final midnight2 = midnight1.subtract(const Duration(days: 1));
    final midnight3 = midnight2.subtract(const Duration(days: 1));
    final midnight4 = midnight3.subtract(const Duration(days: 1));
    final midnight5 = midnight4.subtract(const Duration(days: 1));
    final midnight6 = midnight5.subtract(const Duration(days: 1));
    final midnight7 = midnight6.subtract(const Duration(days: 1));

    bool requested =
        await health.requestAuthorization(types, permissions: permissions);

    await Permission.activityRecognition.request();
    await Permission.location.request();

    if (requested) {
      try {
        // fetch health data
        List<HealthDataPoint> healthData1 =
            await health.getHealthDataFromTypes(midnight1, now, types);
        List<HealthDataPoint> healthData2 =
            await health.getHealthDataFromTypes(midnight2, midnight1, types);
        List<HealthDataPoint> healthData3 =
            await health.getHealthDataFromTypes(midnight3, midnight2, types);
        List<HealthDataPoint> healthData4 =
            await health.getHealthDataFromTypes(midnight4, midnight3, types);
        List<HealthDataPoint> healthData5 =
            await health.getHealthDataFromTypes(midnight5, midnight4, types);
        List<HealthDataPoint> healthData6 =
            await health.getHealthDataFromTypes(midnight6, midnight5, types);
        List<HealthDataPoint> healthData7 =
            await health.getHealthDataFromTypes(midnight7, midnight6, types);

        // save all the new data points (only the first 100)

        movingmins.add(healthData1);
        movingmins.add(healthData2);

        movingmins.add(healthData3);

        movingmins.add(healthData4);
        movingmins.add(healthData5);
        movingmins.add(healthData6);
        movingmins.add(healthData7);
      } catch (error) {
        print("Exception in getHealthDataFromTypes: $error");
      }

      // filter out duplicates

      List<int> mvl = [
        movingmins[0].length,
        movingmins[1].length,
        movingmins[2].length,
        movingmins[3].length,
        movingmins[4].length,
        movingmins[5].length,
        movingmins[6].length,
      ];

      return mvl;
    }
  }

  // cal
  Future calBurned() async {
    List<HealthDataPoint> cal = [];

    final types = [HealthDataType.ACTIVE_ENERGY_BURNED];
    final permissions = [HealthDataAccess.READ];
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    bool requested =
        await health.requestAuthorization(types, permissions: permissions);

    await Permission.activityRecognition.request();
    await Permission.location.request();

    if (requested) {
      try {
        // fetch health data
        List<HealthDataPoint> healthData =
            await health.getHealthDataFromTypes(midnight, now, types);
        // save all the new data points (only the first 100)
        cal.addAll((healthData.length < 100)
            ? healthData
            : healthData.sublist(0, 100));
      } catch (error) {
        print("Exception in getHealthDataFromTypes: $error");
      }

      // filter out duplicates
      cal = HealthFactory.removeDuplicates(cal);
      double va = 0;
      for (int i = 0; i < cal.length; i++) {
        va += double.parse(cal[i].value.toString());
      }
      return va.toInt();
    }
  }

  // calW
  Future calW() async {
    List<List<HealthDataPoint>> cal = [];

    final types = [HealthDataType.ACTIVE_ENERGY_BURNED];
    final permissions = [HealthDataAccess.READ];
    final now = DateTime.now();
    final midnight1 = DateTime(now.year, now.month, now.day);
    final midnight2 = midnight1.subtract(const Duration(days: 1));
    final midnight3 = midnight2.subtract(const Duration(days: 1));
    final midnight4 = midnight3.subtract(const Duration(days: 1));
    final midnight5 = midnight4.subtract(const Duration(days: 1));
    final midnight6 = midnight5.subtract(const Duration(days: 1));
    final midnight7 = midnight6.subtract(const Duration(days: 1));

    bool requested =
        await health.requestAuthorization(types, permissions: permissions);

    await Permission.activityRecognition.request();
    await Permission.location.request();

    if (requested) {
      try {
        // fetch health data
        List<HealthDataPoint> healthData1 =
            await health.getHealthDataFromTypes(midnight1, now, types);
        List<HealthDataPoint> healthData2 =
            await health.getHealthDataFromTypes(midnight2, midnight1, types);
        List<HealthDataPoint> healthData3 =
            await health.getHealthDataFromTypes(midnight3, midnight2, types);
        List<HealthDataPoint> healthData4 =
            await health.getHealthDataFromTypes(midnight4, midnight3, types);
        List<HealthDataPoint> healthData5 =
            await health.getHealthDataFromTypes(midnight5, midnight4, types);
        List<HealthDataPoint> healthData6 =
            await health.getHealthDataFromTypes(midnight6, midnight5, types);
        List<HealthDataPoint> healthData7 =
            await health.getHealthDataFromTypes(midnight7, midnight6, types);

        // save all the new data points (only the first 100)

        cal.add(healthData1);
        cal.add(healthData2);

        cal.add(healthData3);

        cal.add(healthData4);
        cal.add(healthData5);
        cal.add(healthData6);
        cal.add(healthData7);
      } catch (error) {
        print("Exception in getHealthDataFromTypes: $error");
      }

      // filter out duplicates

      int temp(List<HealthDataPoint> s) {
        double va = 0;
        for (int i = 0; i < s.length; i++) {
          va += double.parse(s[i].value.toString());
        }
        return va.toInt();
      }

      List<int?> calL = [
        temp(cal[0]),
        temp(cal[1]),
        temp(cal[2]),
        temp(cal[3]),
        temp(cal[4]),
        temp(cal[5]),
        temp(cal[6]),
      ];

      return calL;
    }
  }

  //bloodD
  Future bloodD() async {
    List<HealthDataPoint> bloodD = [];

    final types = [HealthDataType.BLOOD_PRESSURE_DIASTOLIC];
    final permissions = [HealthDataAccess.READ];
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    bool requested =
        await health.requestAuthorization(types, permissions: permissions);

    await Permission.activityRecognition.request();
    await Permission.location.request();

    if (requested) {
      try {
        // fetch health data
        List<HealthDataPoint> healthData =
            await health.getHealthDataFromTypes(midnight, now, types);
        // save all the new data points (only the first 100)
        bloodD.addAll((healthData.length < 100)
            ? healthData
            : healthData.sublist(0, 100));
      } catch (error) {
        print("Exception in getHealthDataFromTypes: $error");
      }

      // filter out duplicates
      bloodD = HealthFactory.removeDuplicates(bloodD);
      double va = 0;
      for (int i = 0; i < bloodD.length; i++) {
        va += double.parse(bloodD[i].value.toString());
      }
      return va.toInt();
    }
  }

  //blooddW
  Future bloodDW() async {
    List<List<HealthDataPoint>> blood = [];

    final types = [HealthDataType.BLOOD_PRESSURE_DIASTOLIC];
    final permissions = [HealthDataAccess.READ];
    final now = DateTime.now();
    final midnight1 = DateTime(now.year, now.month, now.day);
    final midnight2 = midnight1.subtract(const Duration(days: 1));
    final midnight3 = midnight2.subtract(const Duration(days: 1));
    final midnight4 = midnight3.subtract(const Duration(days: 1));
    final midnight5 = midnight4.subtract(const Duration(days: 1));
    final midnight6 = midnight5.subtract(const Duration(days: 1));
    final midnight7 = midnight6.subtract(const Duration(days: 1));

    bool requested =
        await health.requestAuthorization(types, permissions: permissions);

    await Permission.activityRecognition.request();
    await Permission.location.request();

    if (requested) {
      try {
        // fetch health data
        List<HealthDataPoint> healthData1 =
            await health.getHealthDataFromTypes(midnight1, now, types);
        List<HealthDataPoint> healthData2 =
            await health.getHealthDataFromTypes(midnight2, midnight1, types);
        List<HealthDataPoint> healthData3 =
            await health.getHealthDataFromTypes(midnight3, midnight2, types);
        List<HealthDataPoint> healthData4 =
            await health.getHealthDataFromTypes(midnight4, midnight3, types);
        List<HealthDataPoint> healthData5 =
            await health.getHealthDataFromTypes(midnight5, midnight4, types);
        List<HealthDataPoint> healthData6 =
            await health.getHealthDataFromTypes(midnight6, midnight5, types);
        List<HealthDataPoint> healthData7 =
            await health.getHealthDataFromTypes(midnight7, midnight6, types);

        // save all the new data points (only the first 100)

        blood.add(healthData1);
        blood.add(healthData2);

        blood.add(healthData3);

        blood.add(healthData4);
        blood.add(healthData5);
        blood.add(healthData6);
        blood.add(healthData7);
      } catch (error) {
        print("Exception in getHealthDataFromTypes: $error");
      }

      // filter out duplicates

      int temp(List<HealthDataPoint> s) {
        double va = 0;
        for (int i = 0; i < s.length; i++) {
          va += double.parse(s[i].value.toString());
        }
        return va.toInt();
      }

      List<int?> bloodL = [
        temp(blood[0]),
        temp(blood[1]),
        temp(blood[2]),
        temp(blood[3]),
        temp(blood[4]),
        temp(blood[5]),
        temp(blood[6]),
      ];

      return bloodL;
    }
  }

  //bloodS
  Future bloodS() async {
    List<HealthDataPoint> bloodS = [];

    final types = [HealthDataType.BLOOD_PRESSURE_SYSTOLIC];
    final permissions = [HealthDataAccess.READ];
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    bool requested =
        await health.requestAuthorization(types, permissions: permissions);

    await Permission.activityRecognition.request();
    await Permission.location.request();

    if (requested) {
      try {
        // fetch health data
        List<HealthDataPoint> healthData =
            await health.getHealthDataFromTypes(midnight, now, types);
        // save all the new data points (only the first 100)
        bloodS.addAll((healthData.length < 100)
            ? healthData
            : healthData.sublist(0, 100));
      } catch (error) {
        print("Exception in getHealthDataFromTypes: $error");
      }

      // filter out duplicates
      bloodS = HealthFactory.removeDuplicates(bloodS);
      double va = 0;
      for (int i = 0; i < bloodS.length; i++) {
        va += double.parse(bloodS[i].value.toString());
      }
      return va.toInt();
    }
  }

  //heartrate
  Future Heartrate() async {
    List<HealthDataPoint> rate = [];

    final types = [HealthDataType.HEART_RATE];
    final permissions = [HealthDataAccess.READ];
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    bool requested =
        await health.requestAuthorization(types, permissions: permissions);

    await Permission.activityRecognition.request();
    await Permission.location.request();

    if (requested) {
      try {
        // fetch health data
        List<HealthDataPoint> healthData =
            await health.getHealthDataFromTypes(midnight, now, types);
        // save all the new data points (only the first 100)
        rate.addAll((healthData.length < 100)
            ? healthData
            : healthData.sublist(0, 100));
      } catch (error) {
        print("Exception in getHealthDataFromTypes: $error");
      }

      // filter out duplicates
      rate = HealthFactory.removeDuplicates(rate);
      double va = 0;
      for (int i = 0; i < rate.length; i++) {
        va += double.parse(rate[i].value.toString());
      }

      return va ~/ rate.length;
    }
  }

  //heartrateW
  Future heartrateW() async {
    List<List<HealthDataPoint>> hrate = [];

    final types = [HealthDataType.HEART_RATE];
    final permissions = [HealthDataAccess.READ];
    final now = DateTime.now();
    final midnight1 = DateTime(now.year, now.month, now.day);
    final midnight2 = midnight1.subtract(const Duration(days: 1));
    final midnight3 = midnight2.subtract(const Duration(days: 1));
    final midnight4 = midnight3.subtract(const Duration(days: 1));
    final midnight5 = midnight4.subtract(const Duration(days: 1));
    final midnight6 = midnight5.subtract(const Duration(days: 1));
    final midnight7 = midnight6.subtract(const Duration(days: 1));

    bool requested =
        await health.requestAuthorization(types, permissions: permissions);

    await Permission.activityRecognition.request();
    await Permission.location.request();

    if (requested) {
      try {
        // fetch health data
        List<HealthDataPoint> healthData1 =
            await health.getHealthDataFromTypes(midnight1, now, types);
        List<HealthDataPoint> healthData2 =
            await health.getHealthDataFromTypes(midnight2, midnight1, types);
        List<HealthDataPoint> healthData3 =
            await health.getHealthDataFromTypes(midnight3, midnight2, types);
        List<HealthDataPoint> healthData4 =
            await health.getHealthDataFromTypes(midnight4, midnight3, types);
        List<HealthDataPoint> healthData5 =
            await health.getHealthDataFromTypes(midnight5, midnight4, types);
        List<HealthDataPoint> healthData6 =
            await health.getHealthDataFromTypes(midnight6, midnight5, types);
        List<HealthDataPoint> healthData7 =
            await health.getHealthDataFromTypes(midnight7, midnight6, types);

        // save all the new data points (only the first 100)

        hrate.add(healthData1);
        hrate.add(healthData2);

        hrate.add(healthData3);

        hrate.add(healthData4);
        hrate.add(healthData5);
        hrate.add(healthData6);
        hrate.add(healthData7);
      } catch (error) {
        print("Exception in getHealthDataFromTypes: $error");
      }

      // filter out duplicates

      int temp(List<HealthDataPoint> s) {
        double va = 0;
        for (int i = 0; i < s.length; i++) {
          va += double.parse(s[i].value.toString());
        }
        int r = (s.isEmpty) ? 1 : s.length;
        return va ~/ r;
      }

      List<int?> hrateL = [
        temp(hrate[0]),
        temp(hrate[1]),
        temp(hrate[2]),
        temp(hrate[3]),
        temp(hrate[4]),
        temp(hrate[5]),
        temp(hrate[6]),
      ];

      return hrateL;
    }
  }

  Future bloodSW() async {
    List<List<HealthDataPoint>> blood = [];

    final types = [HealthDataType.BLOOD_PRESSURE_SYSTOLIC];
    final permissions = [HealthDataAccess.READ];
    final now = DateTime.now();
    final midnight1 = DateTime(now.year, now.month, now.day);
    final midnight2 = midnight1.subtract(const Duration(days: 1));
    final midnight3 = midnight2.subtract(const Duration(days: 1));
    final midnight4 = midnight3.subtract(const Duration(days: 1));
    final midnight5 = midnight4.subtract(const Duration(days: 1));
    final midnight6 = midnight5.subtract(const Duration(days: 1));
    final midnight7 = midnight6.subtract(const Duration(days: 1));

    bool requested =
        await health.requestAuthorization(types, permissions: permissions);

    await Permission.activityRecognition.request();
    await Permission.location.request();

    if (requested) {
      try {
        // fetch health data
        List<HealthDataPoint> healthData1 =
            await health.getHealthDataFromTypes(midnight1, now, types);
        List<HealthDataPoint> healthData2 =
            await health.getHealthDataFromTypes(midnight2, midnight1, types);
        List<HealthDataPoint> healthData3 =
            await health.getHealthDataFromTypes(midnight3, midnight2, types);
        List<HealthDataPoint> healthData4 =
            await health.getHealthDataFromTypes(midnight4, midnight3, types);
        List<HealthDataPoint> healthData5 =
            await health.getHealthDataFromTypes(midnight5, midnight4, types);
        List<HealthDataPoint> healthData6 =
            await health.getHealthDataFromTypes(midnight6, midnight5, types);
        List<HealthDataPoint> healthData7 =
            await health.getHealthDataFromTypes(midnight7, midnight6, types);

        // save all the new data points (only the first 100)

        blood.add(healthData1);
        blood.add(healthData2);

        blood.add(healthData3);

        blood.add(healthData4);
        blood.add(healthData5);
        blood.add(healthData6);
        blood.add(healthData7);
      } catch (error) {
        print("Exception in getHealthDataFromTypes: $error");
      }

      // filter out duplicates

      int temp(List<HealthDataPoint> s) {
        double va = 0;
        for (int i = 0; i < s.length; i++) {
          va += double.parse(s[i].value.toString());
        }
        return va.toInt();
      }

      List<int?> bloodL = [
        temp(blood[0]),
        temp(blood[1]),
        temp(blood[2]),
        temp(blood[3]),
        temp(blood[4]),
        temp(blood[5]),
        temp(blood[6]),
      ];

      return bloodL;
    }
  }

  //sleep
  Future sleep() async {
    List<HealthDataPoint> sleep = [];

    final types = [HealthDataType.SLEEP_ASLEEP];
    final permissions = [HealthDataAccess.READ];
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    bool requested =
        await health.requestAuthorization(types, permissions: permissions);

    await Permission.activityRecognition.request();
    await Permission.location.request();

    if (requested) {
      try {
        // fetch health data
        List<HealthDataPoint> healthData =
            await health.getHealthDataFromTypes(midnight, now, types);
        // save all the new data points (only the first 100)
        sleep.addAll((healthData.length < 100)
            ? healthData
            : healthData.sublist(0, 100));
      } catch (error) {
        print("Exception in getHealthDataFromTypes: $error");
      }

      // filter out duplicates
      sleep = HealthFactory.removeDuplicates(sleep);
      double va = 0;
      for (int i = 0; i < sleep.length; i++) {
        va += double.parse(sleep[i].value.toString());
      }
      return double.parse((va / 60).toStringAsFixed(1));
    }
  }

  //sleepW
  Future sleepW() async {
    List<List<HealthDataPoint>> sleep = [];

    final types = [HealthDataType.SLEEP_ASLEEP];
    final permissions = [HealthDataAccess.READ];
    final now = DateTime.now();
    final midnight1 = DateTime(now.year, now.month, now.day);
    final midnight2 = midnight1.subtract(const Duration(days: 1));
    final midnight3 = midnight2.subtract(const Duration(days: 1));
    final midnight4 = midnight3.subtract(const Duration(days: 1));
    final midnight5 = midnight4.subtract(const Duration(days: 1));
    final midnight6 = midnight5.subtract(const Duration(days: 1));
    final midnight7 = midnight6.subtract(const Duration(days: 1));

    bool requested =
        await health.requestAuthorization(types, permissions: permissions);

    await Permission.activityRecognition.request();
    await Permission.location.request();

    if (requested) {
      try {
        // fetch health data
        List<HealthDataPoint> healthData1 =
            await health.getHealthDataFromTypes(midnight1, now, types);
        List<HealthDataPoint> healthData2 =
            await health.getHealthDataFromTypes(midnight2, midnight1, types);
        List<HealthDataPoint> healthData3 =
            await health.getHealthDataFromTypes(midnight3, midnight2, types);
        List<HealthDataPoint> healthData4 =
            await health.getHealthDataFromTypes(midnight4, midnight3, types);
        List<HealthDataPoint> healthData5 =
            await health.getHealthDataFromTypes(midnight5, midnight4, types);
        List<HealthDataPoint> healthData6 =
            await health.getHealthDataFromTypes(midnight6, midnight5, types);
        List<HealthDataPoint> healthData7 =
            await health.getHealthDataFromTypes(midnight7, midnight6, types);

        // save all the new data points (only the first 100)

        sleep.add(healthData1);
        sleep.add(healthData2);

        sleep.add(healthData3);

        sleep.add(healthData4);
        sleep.add(healthData5);
        sleep.add(healthData6);
        sleep.add(healthData7);
      } catch (error) {
        print("Exception in getHealthDataFromTypes: $error");
      }

      // filter out duplicates

      double temp(List<HealthDataPoint> s) {
        double va = 0;
        for (int i = 0; i < s.length; i++) {
          va += double.parse(s[i].value.toString());
        }
        return double.parse((va / 60).toStringAsFixed(2));
      }

      List<double?> sleepL = [
        temp(sleep[0]),
        temp(sleep[1]),
        temp(sleep[2]),
        temp(sleep[3]),
        temp(sleep[4]),
        temp(sleep[5]),
        temp(sleep[6]),
      ];

      return sleepL;
    }
  }

  //distance
  Future distance() async {
    List<HealthDataPoint> distance = [];

    final types = [HealthDataType.DISTANCE_DELTA];
    final permissions = [HealthDataAccess.READ];
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    bool requested =
        await health.requestAuthorization(types, permissions: permissions);

    await Permission.activityRecognition.request();
    await Permission.location.request();

    if (requested) {
      try {
        // fetch health data
        List<HealthDataPoint> healthData =
            await health.getHealthDataFromTypes(midnight, now, types);
        // save all the new data points (only the first 100)
        distance.addAll((healthData.length < 100)
            ? healthData
            : healthData.sublist(0, 100));
      } catch (error) {
        print("Exception in getHealthDataFromTypes: $error");
      }

      // filter out duplicates
      distance = HealthFactory.removeDuplicates(distance);
      double va = 0;
      for (int i = 0; i < distance.length; i++) {
        va += double.parse(distance[i].value.toString());
      }
      return double.parse((va / 1000).toStringAsFixed(2));
    }
  }

//weekDistance
  Future distanceW() async {
    List<List<HealthDataPoint>> distance = [];

    final types = [HealthDataType.DISTANCE_DELTA];
    final permissions = [HealthDataAccess.READ];
    final now = DateTime.now();
    final midnight1 = DateTime(now.year, now.month, now.day);
    final midnight2 = midnight1.subtract(const Duration(days: 1));
    final midnight3 = midnight2.subtract(const Duration(days: 1));
    final midnight4 = midnight3.subtract(const Duration(days: 1));
    final midnight5 = midnight4.subtract(const Duration(days: 1));
    final midnight6 = midnight5.subtract(const Duration(days: 1));
    final midnight7 = midnight6.subtract(const Duration(days: 1));

    bool requested =
        await health.requestAuthorization(types, permissions: permissions);

    await Permission.activityRecognition.request();
    await Permission.location.request();

    if (requested) {
      try {
        // fetch health data
        List<HealthDataPoint> healthData1 =
            await health.getHealthDataFromTypes(midnight1, now, types);
        List<HealthDataPoint> healthData2 =
            await health.getHealthDataFromTypes(midnight2, midnight1, types);
        List<HealthDataPoint> healthData3 =
            await health.getHealthDataFromTypes(midnight3, midnight2, types);
        List<HealthDataPoint> healthData4 =
            await health.getHealthDataFromTypes(midnight4, midnight3, types);
        List<HealthDataPoint> healthData5 =
            await health.getHealthDataFromTypes(midnight5, midnight4, types);
        List<HealthDataPoint> healthData6 =
            await health.getHealthDataFromTypes(midnight6, midnight5, types);
        List<HealthDataPoint> healthData7 =
            await health.getHealthDataFromTypes(midnight7, midnight6, types);

        // save all the new data points (only the first 100)

        distance.add(healthData1);
        distance.add(healthData2);

        distance.add(healthData3);

        distance.add(healthData4);
        distance.add(healthData5);
        distance.add(healthData6);
        distance.add(healthData7);
      } catch (error) {
        print("Exception in getHealthDataFromTypes: $error");
      }

      // filter out duplicates

      double temp(List<HealthDataPoint> s) {
        double va = 0;
        for (int i = 0; i < s.length; i++) {
          va += double.parse(s[i].value.toString());
        }
        return double.parse((va / 1000).toStringAsFixed(2));
      }

      List<double?> distanceL = [
        temp(distance[0]),
        temp(distance[1]),
        temp(distance[2]),
        temp(distance[3]),
        temp(distance[4]),
        temp(distance[5]),
        temp(distance[6]),
      ];

      return distanceL;
    }
  }

  /// Add some random health data.
  Future addData() async {
    final now = DateTime.now();
    final earlier = now.subtract(Duration(minutes: 20));

    final types = [
      HealthDataType.STEPS,

      HealthDataType.HEART_RATE,
      HealthDataType.SLEEP_ASLEEP

      // Requires Google Fit on Android
      // Uncomment these lines on iOS - only available on iOS
      // HealthDataType.AUDIOGRAM,
    ];
    final rights = [
      HealthDataAccess.WRITE,
      HealthDataAccess.WRITE,
      HealthDataAccess.WRITE,

      // HealthDataAccess.WRITE
    ];
    final permissions = [
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ_WRITE,

      // HealthDataAccess.READ_WRITE,
    ];
    late bool perm;
    bool? hasPermissions =
        await HealthFactory.hasPermissions(types, permissions: rights);
    if (hasPermissions == false) {
      perm = await health.requestAuthorization(types, permissions: permissions);
    }

    // Store a count of steps taken
    _nofSteps = Random().nextInt(10);
    bool success =
        await health.writeHealthData(65, HealthDataType.HEART_RATE, now, now);

    // // Store a height
    // success &= await health.writeHealthData(
    //     1.93, HealthDataType.DISTANCE_DELTA, earlier, now);

    // // Store a Blood Glucose measurement
    // _mgdl = Random().nextInt(10) * 1.0;
    // success &= await health.writeHealthData(
    //     _mgdl, HealthDataType.BLOOD_GLUCOSE, now, now);

    // // Store a workout eg. running
    // success &= await health.writeWorkoutData(
    //   HealthWorkoutActivityType.RUNNING, earlier, now,
    //   // The following are optional parameters
    //   // and the UNITS are functional on iOS ONLY!
    //   totalEnergyBurned: 230,
    //   totalEnergyBurnedUnit: HealthDataUnit.KILOCALORIE,
    //   totalDistance: 1234,
    //   totalDistanceUnit: HealthDataUnit.FOOT,
    // );

    // Store an Audiogram
    // Uncomment these on iOS - only available on iOS
    // const frequencies = [125.0, 500.0, 1000.0, 2000.0, 4000.0, 8000.0];
    // const leftEarSensitivities = [49.0, 54.0, 89.0, 52.0, 77.0, 35.0];
    // const rightEarSensitivities = [76.0, 66.0, 90.0, 22.0, 85.0, 44.5];

    // success &= await health.writeAudiogram(
    //   frequencies,
    //   leftEarSensitivities,
    //   rightEarSensitivities,
    //   now,
    //   now,
    //   metadata: {
    //     "HKExternalUUID": "uniqueID",
    //     "HKDeviceName": "bluetooth headphone",
    //   },
    // );

    setState(() {
      _state = success ? AppState.DATA_ADDED : AppState.DATA_NOT_ADDED;
    });
  }

  /// Fetch steps from the health plugin and show them in the app.
  Future fetchStepDataW() async {
    List<int?> steps = [];
    // get steps for today (i.e., since midnight)
    final now = DateTime.now();

    final midnight1 = DateTime(now.year, now.month, now.day);
    final midnight2 = midnight1.subtract(const Duration(days: 1));
    final midnight3 = midnight2.subtract(const Duration(days: 1));
    final midnight4 = midnight3.subtract(const Duration(days: 1));
    final midnight5 = midnight4.subtract(const Duration(days: 1));
    final midnight6 = midnight5.subtract(const Duration(days: 1));
    final midnight7 = midnight6.subtract(const Duration(days: 1));

    bool requested = await health.requestAuthorization([HealthDataType.STEPS]);

    if (requested) {
      try {
        steps = [
          await health.getTotalStepsInInterval(midnight1, now),
          await health.getTotalStepsInInterval(midnight2, midnight1),
          await health.getTotalStepsInInterval(midnight3, midnight2),
          await health.getTotalStepsInInterval(midnight4, midnight3),
          await health.getTotalStepsInInterval(midnight5, midnight4),
          await health.getTotalStepsInInterval(midnight6, midnight5),
          await health.getTotalStepsInInterval(midnight7, midnight6),
        ];
      } catch (error) {
        print("Caught exception in getTotalStepsInInterval: $error");
      }

      for (int i = 0; i < steps.length; i++) {
        if (steps[i] == null) {
          steps[i] = 0;
        }
      }
      if (steps != null) {
        return steps;
      } else {
        return 0;
      }
      return steps;
    } else {
      print("Authorization not granted - error in authorization");
      setState(() => _state = AppState.DATA_NOT_FETCHED);
    }
  }

  //weeklysteps

  Future fetchStepData() async {
    int? steps;

    // get steps for today (i.e., since midnight)
    final now = DateTime.now();

    final midnight = DateTime(now.year, now.month, now.day);

    bool requested = await health.requestAuthorization([HealthDataType.STEPS]);

    if (requested) {
      try {
        steps = await health.getTotalStepsInInterval(midnight, now);
      } catch (error) {
        print("Caught exception in getTotalStepsInInterval: $error");
      }
      if (steps != null) {
        return steps;
      } else {
        return 0;
      }
    } else {
      print("Authorization not granted - error in authorization");
      setState(() => _state = AppState.DATA_NOT_FETCHED);
    }
  }

  // yesterday steps
  Future fetchStepDataforyesterday() async {
    int? steps;

    // get steps for today (i.e., since midnight)
    final now = DateTime.now();

    final midnight = DateTime(now.year, now.month, now.day);
    final yesterday = midnight.subtract(const Duration(days: 1));

    bool requested = await health.requestAuthorization([HealthDataType.STEPS]);

    if (requested) {
      try {
        steps = await health.getTotalStepsInInterval(yesterday, midnight);
      } catch (error) {
        print("Caught exception in getTotalStepsInInterval: $error");
      }
      if (steps != null) {
        return steps;
      } else {
        return 0;
      }
    } else {
      print("Authorization not granted - error in authorization");
      setState(() => _state = AppState.DATA_NOT_FETCHED);
    }
  }

  // steps weekly for board

  Future fetchStepDataforweeklyboard() async {
    int? steps;

    // get steps for today (i.e., since midnight)
    final now = DateTime.now();

    var thisweek = now.subtract(Duration(days: now.weekday));
    thisweek = DateTime(thisweek.year, thisweek.month, thisweek.day);
    final lastweek = thisweek.subtract(Duration(days: 7));
    bool requested = await health.requestAuthorization([HealthDataType.STEPS]);

    if (requested) {
      try {
        steps = await health.getTotalStepsInInterval(lastweek, thisweek);
      } catch (error) {
        print("Caught exception in getTotalStepsInInterval: $error");
      }

      if (steps != null) {
        return steps;
      } else {
        return 0;
      }
    } else {
      print("Authorization not granted - error in authorization");
      setState(() => _state = AppState.DATA_NOT_FETCHED);
    }
  }

  Widget _contentFetchingData() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            padding: EdgeInsets.all(20),
            child: CircularProgressIndicator(
              strokeWidth: 10,
            )),
        Text('Fetching data...')
      ],
    );
  }

  Widget _contentDataReady() {
    return ListView.builder(
        itemCount: healthDataList.length,
        itemBuilder: (_, index) {
          HealthDataPoint p = healthDataList[index];
          if (p.value is AudiogramHealthValue) {
            return ListTile(
              title: Text("${p.typeString}: ${p.value}"),
              trailing: Text('${p.unitString}'),
              subtitle: Text('${p.dateFrom} - ${p.dateTo}'),
            );
          }
          if (p.value is WorkoutHealthValue) {
            return ListTile(
              title: Text(
                  "${p.typeString}: ${(p.value as WorkoutHealthValue).totalEnergyBurned} ${(p.value as WorkoutHealthValue).totalEnergyBurnedUnit?.typeToString()}"),
              trailing: Text(
                  '${(p.value as WorkoutHealthValue).workoutActivityType.typeToString()}'),
              subtitle: Text('${p.dateFrom} - ${p.dateTo}'),
            );
          }
          return ListTile(
            title: Text("${p.typeString}: ${p.value}"),
            trailing: Text('${p.unitString}'),
            subtitle: Text('${p.dateFrom} - ${p.dateTo}'),
          );
        });
  }

  Widget _contentNoData() {
    return Text('No Data to show');
  }

  Widget _contentNotFetched() {
    return Column(
      children: [
        Text('Press the download button to fetch data.'),
        Text('Press the plus button to insert some random data.'),
        Text('Press the walking button to get total step count.'),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  Widget _authorizationNotGranted() {
    return Text('Authorization not given. '
        'For Android please check your OAUTH2 client ID is correct in Google Developer Console. '
        'For iOS check your permissions in Apple Health.');
  }

  Widget _dataAdded() {
    return Text('Data points inserted successfully!');
  }

  Widget stepsFetched() {
    return Text('Total number of steps: $_nofSteps');
  }

  Widget _dataNotAdded() {
    return Text('Failed to add data');
  }

  Widget _content() {
    if (_state == AppState.DATA_READY)
      return _contentDataReady();
    else if (_state == AppState.NO_DATA)
      return _contentNoData();
    else if (_state == AppState.FETCHING_DATA)
      return _contentFetchingData();
    else if (_state == AppState.AUTH_NOT_GRANTED)
      return _authorizationNotGranted();
    else if (_state == AppState.DATA_ADDED)
      return _dataAdded();
    else if (_state == AppState.STEPS_READY)
      return stepsFetched();
    else if (_state == AppState.DATA_NOT_ADDED) return _dataNotAdded();

    return _contentNotFetched();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
