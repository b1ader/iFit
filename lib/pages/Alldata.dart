import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:googlelogin/Component/Repository.dart';
import 'package:googlelogin/design/colors.dart';
import 'package:googlelogin/pages/weeklyData.dart';
import 'package:googlelogin/pages/weeklyDataforD.dart';
import 'package:share_files_and_screenshot_widgets/share_files_and_screenshot_widgets.dart';

class Alldata extends StatefulWidget {
  alldata createState() => alldata();
}

class alldata extends State<Alldata> {
  List<String> names = [
    'STEPS:',
    'DISTANCE\n(km):',
    'MOVING MIN:',
    'Cal:',
    'Blood Pressure\n(diastolic)',
    'Blood Pressure\n(systolic)',
    'HeartRate\n(bpm)',
    'sleep time\n(hour)'
  ];
  List<Future> data = [
    HealthAppState().fetchStepData(),
    HealthAppState().distance(),
    HealthAppState().movingmins(),
    HealthAppState().calBurned(),
    HealthAppState().bloodD(),
    HealthAppState().bloodS(),
    HealthAppState().Heartrate(),
    HealthAppState().sleep()
  ];
  List<Future> dataW = [
    HealthAppState().fetchStepDataW(),
    HealthAppState().distanceW(),
    HealthAppState().movingminsW(),
    HealthAppState().calW(),
    HealthAppState().bloodDW(),
    HealthAppState().bloodSW(),
    HealthAppState().heartrateW(),
    HealthAppState().sleepW(),
  ];
  GlobalKey previewContainer = new GlobalKey();
  int originalSize = 800;

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
          'HealthData',
          style: colors.font10,
        ),
        centerTitle: true,
      ),
      body: RepaintBoundary(
        key: previewContainer,
        child: GridView.count(
          crossAxisCount: 2,
          children: List.generate(8, (index) {
            return FutureBuilder(
                future: dataW[index],
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
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
                        child: MaterialButton(
                            onPressed: () {
                              if (index == 1 || index == 7) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SimpleBarChartD.withSampleData(
                                                snapshot.data, names[index])));
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SimpleBarChart.withSampleData(
                                                snapshot.data, names[index])));
                              }
                            },
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
                                FutureBuilder(
                                  future: data[index],
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Center(
                                          heightFactor: 2,
                                          child: Text(
                                            snapshot.data.toString(),
                                            style: colors.font1,
                                          ));
                                    } else {
                                      return Center(
                                          heightFactor: 2,
                                          child: Text(
                                            '_',
                                            style: colors.font1,
                                          ));
                                    }
                                  },
                                )
                              ],
                            )));
                  } else {
                    return CircularProgressIndicator();
                  }
                });
          }),
        ),
      ),
      backgroundColor: colors.maincolor,
    );
  }
}
