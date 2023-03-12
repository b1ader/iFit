// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, use_key_in_widget_constructors, camel_case_types, prefer_const_literals_to_create_immutables, non_constant_identifier_names

//import 'package:flutter_application_1/Logout.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:googlelogin/controller/PagesNavigator.dart';
import 'package:googlelogin/design/colors.dart';
import 'package:googlelogin/pages/Login.dart';

import 'Profile_Interface.dart';
import 'package:flutter/material.dart';

class SetData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: 40,
          backgroundColor: colors.secondary,
          title: Text(
            'Set Your Data',
            style: colors.font10,
          ),
          centerTitle: true,
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  SizedBox(height: 20),
                  MyHomePage(
                    text: "Activity level",
                    icon: Icon(Icons.show_chart_sharp),
                    data: snapshot.data!.docs.first["Activity level"],
                  ),
                  MyHomePage(
                    text: "Daily steps goal",
                    icon: Icon(Icons.sports_score),
                    data: snapshot.data!.docs.first["Daily steps goal"],
                  ),
                  MyHomePage(
                    text: "Weekly weight goal",
                    icon: Icon(Icons.track_changes),
                    data: snapshot.data!.docs.first["Weekly weight goal"],
                  ),
                  MyHomePage(
                    text: "Date of birth",
                    icon: Icon(Icons.date_range_rounded),
                    data: snapshot.data!.docs.first["Date of birth"],
                  ),
                  MyHomePage(
                    text: "Height",
                    icon: Icon(Icons.height),
                    data: snapshot.data!.docs.first["Height"],
                  ),
                  MyHomePage(
                    text: "Weight",
                    icon: Icon(Icons.monitor_weight_sharp),
                    data: snapshot.data!.docs.first["Weight"],
                  ),
                  MyHomePage(
                    text: "Gender",
                    icon: Icon(Icons.person_rounded),
                    data: snapshot.data!.docs.first["Gender"],
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                          fixedSize:
                              MaterialStateProperty.all<Size>(Size(300, 10)),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              colors.secondary)),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PagesNavigator()),
                          (Route<dynamic> route) => false,
                        );
                      },
                      child: Text(
                        "Done",
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        )
        //padding: EdgeInsets.symmetric(vertical: 10),

        );
  }
}
