import 'dart:async';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googlelogin/main.dart';
import 'package:googlelogin/pages/Alldata.dart';
import 'package:googlelogin/pages/Heart_Rate.dart';
import 'package:googlelogin/pages/nutrition.dart';
import 'package:googlelogin/pages/weeklyData.dart';
import '../design/colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import '../Component/Chart.dart';
import 'package:awesome_circular_chart/awesome_circular_chart.dart';
import 'package:get/get.dart';
import 'package:googlelogin/Component/Repository.dart';

class HomePage extends StatefulWidget {
  home createState() => home();
}

final GoogleSignIn _googleSignIn = GoogleSignIn();

class home extends State<HomePage> {
  static const platform = MethodChannel('samples.flutter.dev/battery');

  Future<void> _getBatteryLevel() async {
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
    } on PlatformException catch (e) {
      print("Failed to get battery level: '${e.message}'.");
    }
  }

  final GlobalKey<AnimatedCircularChartState> _chartKey =
      GlobalKey<AnimatedCircularChartState>();

  late Timer timer;
  @override
  void initState() {
    super.initState();
    _getBatteryLevel();

    timer = Timer.periodic(Duration(seconds: 4), (timer) {
      signin().then((value) {
        if (value == true) {
          steps = HealthAppState().fetchStepData();
          movingT = HealthAppState().movingmins();
          distance = HealthAppState().distance();
        }
      });

      setState(() {
        temp;
      });
    });
  }

  Future steps = HealthAppState().fetchStepData();
  Future movingT = HealthAppState().movingmins();
  Future distance = HealthAppState().distance();
  late int temp;
  late int goal;
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData('Carbohydrates', 50, '50%', "Carbohydrates\n50%"),
      ChartData('Protien', 30, '30%', "Protien\n30%"),
      ChartData('Fat', 20, '20%', "Fat\n20%")
    ];

    return Scaffold(
        backgroundColor: colors.maincolor,
        body: SingleChildScrollView(
            child: Column(children: [
          Container(
              margin: EdgeInsets.only(top: 30, left: 15, right: 15, bottom: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32)),
              ),
              child: FutureBuilder(
                  future: steps,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      temp = int.parse(snapshot.data.toString());
                      return StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("users")
                              .where("id",
                                  isEqualTo:
                                      FirebaseAuth.instance.currentUser!.uid)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              goal = int.parse(snapshot
                                  .data!.docs.first["Daily steps goal"]);
                              return AnimatedCircularChart(
                                key: _chartKey,
                                size: Size(400.0, 400.0),
                                initialChartData: <CircularStackEntry>[
                                  CircularStackEntry(
                                    <CircularSegmentEntry>[
                                      CircularSegmentEntry(
                                        ((temp * 100) / goal),
                                        colors.secondary,
                                        rankKey: 'completed',
                                      ),
                                      CircularSegmentEntry(
                                        100.0 - ((temp * 100) / goal),
                                        colors.white,
                                        rankKey: 'remaining',
                                      ),
                                    ],
                                    rankKey: 'progress',
                                  ),
                                ],
                                chartType: CircularChartType.Radial,
                                percentageValues: true,
                                edgeStyle: SegmentEdgeStyle.round,
                                holeLabel: 'STEPS: ${temp.toString()}',
                                labelStyle: TextStyle(
                                  color: colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24.0,
                                ),
                              );
                            } else {
                              return CircularProgressIndicator();
                            }
                          });
                    } else {
                      return CircularProgressIndicator();
                    }
                  })),

          Container(
            width: double.maxFinite,
            margin: EdgeInsets.only(left: 25, right: 25),
            child: Padding(
              padding: EdgeInsets.only(
                left: 40,
                right: 40,
              ),
              child: Row(
                children: [
                  Column(
                    children: [
                      Icon(
                        Icons.watch_later_outlined,
                        size: 35,
                        color: colors.secondary,
                      ),
                      FutureBuilder(
                          future: movingT,
                          builder: (context, snapshot) {
                            return Text(
                              '${snapshot.data} min',
                              style: colors.font2,
                            );
                          })
                    ],
                  ),
                  Spacer(),
                  Column(
                    children: [
                      Icon(
                        Icons.arrow_circle_right_outlined,
                        size: 35,
                        color: colors.secondary,
                      ),
                      FutureBuilder(
                          future: distance,
                          builder: (context, snapshot) {
                            return Text(
                              '${snapshot.data} km',
                              style: colors.font2,
                            );
                          })
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Divider(color: colors.black, thickness: 1),
          Container(
              width: double.maxFinite,
              margin: EdgeInsets.only(left: 15, right: 15),
              child: MaterialButton(
                child: Row(
                  children: [
                    Text(
                      'Show All Health Data',
                      style: colors.font2,
                      textAlign: TextAlign.right,
                    ),
                    Spacer(),
                    Icon(Icons.keyboard_arrow_right)
                  ],
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Alldata()));
                },
              )),

          Container(
            width: double.maxFinite,
            margin: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32), topRight: Radius.circular(32)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                )
              ],
            ),
            child: SfCircularChart(
              series: <CircularSeries>[
                PieSeries<ChartData, String>(
                    dataSource: chartData,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y,
                    // Map the data label text for each point from the data source
                    dataLabelMapper: (ChartData data, _) => data.z,
                    dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                      textStyle: colors.font11,
                      useSeriesColor: true,
                      labelPosition: ChartDataLabelPosition.inside,
                    ))
              ],
              title: ChartTitle(text: 'nutritions', textStyle: colors.font1),
            ),
          ),
          Container(
              width: double.maxFinite,
              margin: EdgeInsets.only(left: 15, right: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  )
                ],
              ),
              child: MaterialButton(
                child: Text(
                  'Details >',
                  style: colors.font2,
                  textAlign: TextAlign.center,
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => nutrition()));
                },
              )),
          Container(
              padding: EdgeInsets.only(
                top: 15,
                bottom: 15,
              ),
              width: double.maxFinite,
              margin: EdgeInsets.only(left: 15, right: 15, top: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  )
                ],
              ),
              child: MaterialButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Heart_Rate()),
                    );
                  },
                  child: Row(
                    children: [
                      Text(
                        'Check your heart rate',
                        style: colors.font3,
                      ),
                      Spacer(),
                      Icon(Icons.keyboard_arrow_right)
                    ],
                  ))),
          Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              height: 140,
              width: double.maxFinite,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(32)),
              ),
              child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection("tips").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return PageView.builder(
                      itemCount: snapshot.data!.docs.length,
                      controller: PageController(viewportFraction: 0.7),
                      onPageChanged: (int index) =>
                          setState(() => _index = index),
                      itemBuilder: (_, i) => Transform.scale(
                        scale: i == _index ? 1 : 0.9,
                        child: Card(
                            color: Color.fromARGB(255, 185, 224, 250),
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: Container(
                                padding: EdgeInsets.all(12),
                                child: Center(
                                  child: Text(
                                    snapshot.data!.docs[i]["tip"],
                                    style: colors.font8,
                                  ),
                                ))),
                      ),
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              )),
        ])));
  }
}
