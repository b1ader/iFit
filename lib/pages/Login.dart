import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:googlelogin/Component/Repository.dart';
import 'package:googlelogin/controller/PagesNavigator.dart';
import 'package:googlelogin/design/colors.dart';
import 'package:googlelogin/pages/HomePage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:auth/auth.dart';
import 'package:googlelogin/pages/SetData.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class Login extends StatefulWidget {
  login createState() => login();
}

final GoogleSignIn _googleSignIn = GoogleSignIn();

class login extends State<Login> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colors.maincolor,
        body: Center(
            child: Column(children: [
          Padding(
              padding: EdgeInsets.only(top: 35),
              child: Center(
                  child: Text(
                "welcome to ifit",
                style: colors.font1,
              ))),
          Spacer(),
          Image.asset('assets/images/logo3-color.png'),
          Spacer(),
          Padding(
              padding: EdgeInsets.only(bottom: 35),
              child: SizedBox(
                width: 280,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(colors.secondary)),
                    onPressed: () async {
                      final String? u = await signInWithGoogle();
                      await FirebaseFirestore.instance
                          .collection("users")
                          .where("id", isEqualTo: u)
                          .get()
                          .then((Value) async {
                        if (Value.docs.length != 0) {
                          await FirebaseFirestore.instance
                              .collection("users")
                              .where("id",
                                  isEqualTo:
                                      FirebaseAuth.instance.currentUser!.uid)
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
                          HealthAppState()
                              .fetchStepDataforyesterday()
                              .then((value) async {
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
                              .where("id",
                                  isEqualTo:
                                      FirebaseAuth.instance.currentUser!.uid)
                              .get()
                              .then((value) {
                            if (value.docs.first["calc"] == "no") {
                              int calc = (int.parse(value.docs.first["steps"]) /
                                          500) <
                                      1
                                  ? 0
                                  : (int.parse(value.docs.first["steps"]) / 500)
                                      .toInt();
                              int points =
                                  int.parse(value.docs.first["points"]);
                              calc = calc + points;
                              FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .update({"points": "$calc", "calc": "yes"});
                            }
                          });
                          HealthAppState()
                              .fetchStepDataforweeklyboard()
                              .then((value) async {
                            await FirebaseFirestore.instance
                                .collection("users")
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .update({
                              "weekly steps": value.toString(),
                              "weekly steps date": '${DateTime.now()}'
                            });
                          });
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PagesNavigator()),
                            (Route<dynamic> route) => false,
                          );
                        } else {
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .set({
                            "id": FirebaseAuth.instance.currentUser!.uid,
                            "name":
                                FirebaseAuth.instance.currentUser!.displayName,
                            "Activity level": 'Active',
                            "Daily steps goal": '10000',
                            "Weekly weight goal": 'Maintain weight',
                            "Date of birth": '01-01-1999',
                            "Height": '170',
                            "Weight": '60',
                            "Gender": 'Male',
                            "steps": '0',
                            "steps date": '${DateTime.now()}',
                            "weekly steps": '0',
                            "weekly steps date": '${DateTime.now()}',
                            "points": "0",
                            "calc": "no"
                          });
                          HealthAppState().fetchStepData().whenComplete(() {
                            HealthAppState().distance().whenComplete(
                              () {
                                HealthAppState().movingmins().whenComplete(() {
                                  HealthAppState().calBurned().whenComplete(() {
                                    HealthAppState().bloodD().whenComplete(() {
                                      HealthAppState()
                                          .bloodS()
                                          .whenComplete(() {
                                        HealthAppState()
                                            .Heartrate()
                                            .whenComplete(() {
                                          HealthAppState()
                                              .sleep()
                                              .whenComplete(() {
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SetData()),
                                              (Route<dynamic> route) => false,
                                            );
                                          });
                                        });
                                      });
                                    });
                                  });
                                });
                              },
                            );
                          });
                        }
                      });
                    },
                    child: Text(
                      "Let's get started",
                      style: TextStyle(color: Colors.white),
                    )),
              )),
        ])));
  }

  Future<String?> signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuthentication =
        await googleSignInAccount!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuthentication.accessToken,
        idToken: googleAuthentication.idToken);
    final UserCredential authResult =
        await firebaseAuth.signInWithCredential(credential);
    final User? user = authResult.user;
    assert(!user!.isAnonymous);
    assert(await user!.getIdToken() != null);
    final User? currentUser = await firebaseAuth.currentUser;
    assert(user!.uid == currentUser!.uid);
    print('signInWithGoogle succeeded: $user');
    return user?.uid.toString();
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
}
