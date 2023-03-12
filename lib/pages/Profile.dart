// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, use_key_in_widget_constructors, camel_case_types, prefer_const_literals_to_create_immutables, non_constant_identifier_names

//import 'package:flutter_application_1/Logout.dart';

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googlelogin/controller/PagesNavigator.dart';
import 'package:googlelogin/design/colors.dart';
import 'package:googlelogin/pages/HomePage.dart';
import 'package:googlelogin/pages/Login.dart';

import 'Profile_Interface.dart';
import 'package:flutter/material.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();

class profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("users")
          .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                toolbarHeight: 40,
                backgroundColor: colors.secondary,
                title: Text(
                  'Profile',
                  style: colors.font10,
                ),
                centerTitle: true,
              ),
              body: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: Column(
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
                        data: snapshot.data!.docs[0]["Daily steps goal"],
                      ),
                      MyHomePage(
                        text: "Weekly weight goal",
                        icon: Icon(Icons.track_changes),
                        data: snapshot.data!.docs[0]["Weekly weight goal"],
                      ),
                      MyHomePage(
                        text: "Date of birth",
                        icon: Icon(Icons.date_range_rounded),
                        data: snapshot.data!.docs.last["Date of birth"],
                      ),
                      MyHomePage(
                        text: "Height",
                        icon: Icon(Icons.height),
                        data: snapshot.data!.docs.last["Height"],
                      ),
                      MyHomePage(
                        text: "Weight",
                        icon: Icon(Icons.monitor_weight_sharp),
                        data: snapshot.data!.docs.last["Weight"],
                      ),
                      MyHomePage(
                        text: "Gender",
                        icon: Icon(Icons.person_rounded),
                        data: snapshot.data!.docs.last["Gender"],
                      ),
                      ElevatedButton(
                          style: ButtonStyle(
                              fixedSize: MaterialStateProperty.all<Size>(
                                  Size(300, 10)),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color.fromARGB(255, 245, 7, 7))),
                          onPressed: () async {
                            FirebaseAuth.instance.signOut();
                            await _googleSignIn.signOut().whenComplete(() {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()),
                                (Route<dynamic> route) => false,
                              );
                            });
                          },
                          child: Text(
                            "Log Out",
                            style: TextStyle(color: Colors.white),
                          ))
                    ],
                  )));
        } else {
          return CircularProgressIndicator();
        }
      },

      //padding: EdgeInsets.symmetric(vertical: 10),
    );
  }
}
