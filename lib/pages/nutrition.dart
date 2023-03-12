import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:googlelogin/design/colors.dart';
import 'package:intl/intl.dart';
import 'package:share_files_and_screenshot_widgets/share_files_and_screenshot_widgets.dart';

class nutrition extends StatefulWidget {
  nu createState() => nu();
}

class nu extends State<nutrition> {
  GlobalKey previewContainer = new GlobalKey();
  int originalSize = 800;

  List<String> data = [];
  List<String> names = [
    "calories(kcal)",
    "Protien(g)",
    "Fat(g)",
    "Saturated\nfat(g)",
    "Carbohydrates\n(g)",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  ShareFilesAndScreenshotWidgets().shareScreenshot(
                      previewContainer,
                      originalSize,
                      "Title",
                      "Name.png",
                      "image/png",
                      text: "This is the my data");
                },
                icon: Icon(
                  Icons.ios_share_rounded,
                  color: colors.white,
                ))
          ],
          toolbarHeight: 40,
          backgroundColor: colors.secondary,
          title: Text(
            'Nutrition (Per Day)',
            style: colors.font10,
          ),
          centerTitle: true,
        ),
        body: RepaintBoundary(
            key: previewContainer,
            child: GridView.count(
                crossAxisCount: 2,
                children: List.generate(5, (index) {
                  return StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .where("id",
                              isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                          .snapshots(),
                      builder: ((context, snapshot) {
                        if (snapshot.hasData) {
                          data.addAll([
                            CCalories(
                                    snapshot.data!.docs[0]["Gender"],
                                    21,
                                    double.parse(
                                        snapshot.data!.docs[0]["Height"]),
                                    double.parse(
                                        snapshot.data!.docs[0]["Weight"]),
                                    snapshot.data!.docs[0]["Activity level"],
                                    snapshot.data!.docs[0]
                                        ["Weekly weight goal"])
                                .toStringAsFixed(2),
                            CProtein(double.parse(
                                    snapshot.data!.docs[0]["Weight"]))
                                .toStringAsFixed(2),
                            CFat(double.parse(snapshot.data!.docs[0]["Weight"]))
                                .toStringAsFixed(2),
                            Csfat(CCalories(
                                    snapshot.data!.docs[0]["Gender"],
                                    age(snapshot.data!.docs[0]
                                        ["Date of birth"]),
                                    double.parse(
                                        snapshot.data!.docs[0]["Height"]),
                                    double.parse(
                                        snapshot.data!.docs[0]["Weight"]),
                                    snapshot.data!.docs[0]["Activity level"],
                                    snapshot.data!.docs[0]
                                        ["Weekly weight goal"]))
                                .toStringAsFixed(2),
                            CCarbohydrates(
                                    CCalories(
                                        snapshot.data!.docs[0]["Gender"],
                                        21,
                                        double.parse(
                                            snapshot.data!.docs[0]["Height"]),
                                        double.parse(
                                            snapshot.data!.docs[0]["Weight"]),
                                        snapshot.data!.docs[0]
                                            ["Activity level"],
                                        snapshot.data!.docs[0]
                                            ["Weekly weight goal"]),
                                    CProtein(double.parse(
                                        snapshot.data!.docs[0]["Weight"])),
                                    CFat(double.parse(
                                        snapshot.data!.docs[0]["Weight"])))
                                .toStringAsFixed(2),
                          ]);
                          return Container(
                              width: double.maxFinite,
                              margin: EdgeInsets.only(
                                  left: 15, right: 15, top: 15, bottom: 2),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(32),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                  )
                                ],
                              ),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      heightFactor: 1,
                                      child: Text(
                                        names[index],
                                        style: colors.font5,
                                      ),
                                    ),
                                    Center(
                                        heightFactor: 2,
                                        child: Text(
                                          data[index].toString(),
                                          style: colors.font1,
                                        ))
                                  ]));
                        } else {
                          return CircularProgressIndicator();
                        }
                      }));
                }))));
  }

  double CCalories(String gender, int age, double height, double weight,
      String activityLevel, String weightWeeklyGoal) {
    var bmr, calories;
    if (gender == "Male") {
      bmr = (9.99 * weight) + (6.25 * height) - (4.92 * age) + 5;
    } else if (gender == "Female") {
      bmr = (9.99 * weight) + (6.25 * height) - (4.92 * age) - 161;
    }
    if (activityLevel == "Not Very Active") {
      calories = bmr * 1.2;
    } else if (activityLevel == "Lightly Active") {
      calories = bmr * 1.375;
    } else if (activityLevel == "Active") {
      calories = bmr * 1.55;
    } else if (activityLevel == "Very Active") {
      calories = bmr * 1.725;
    }
    if (weightWeeklyGoal == "Lose 0.5 kg per week") {
      calories = calories - 400;
      return calories;
    } else if (weightWeeklyGoal == "Gain 0.5 kg per week") {
      calories = calories + 400;
      return calories;
    } else {
      return calories;
    }
  }

  double CProtein(double weight) {
    var protein = 2 * weight;
    return protein;
  }

  double CFat(double weight) {
    var fat = 0.88 * weight;
    return fat;
  }

  double CCarbohydrates(double calories, double protein, double fat) {
    var remain_calories = calories - (fat * 9 + protein * 4);
    var Carbohydrates = remain_calories / 4;
    return Carbohydrates;
  }

  double Csfat(double cal) {
    var fattt = (cal * 0.1) / 9;
    return fattt;
  }

  int age(String date) {
    final now = DateTime.now();
    var outputFormat = DateFormat('dd-MM-yyyy');
    var check = outputFormat.parse(date);

    return now.year - check.year;
  }
}
