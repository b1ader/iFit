import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googlelogin/pages/Login.dart';
import 'package:intl/intl.dart';
import '../design/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';

class LeaderBoard extends StatefulWidget {
  Board createState() => Board();
}

//final GoogleSignIn _googleSignIn = GoogleSignIn();

class Board extends State<LeaderBoard> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            toolbarHeight: 40,
            backgroundColor: colors.secondary,
            title: Text(
              'LeaderBoard',
              style: colors.font10,
            ),
            centerTitle: true,
            bottom: TabBar(
              labelColor: colors.black,
              unselectedLabelColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.label,
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  color: Colors.white),
              tabs: [
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("Yesterday"),
                  ),
                ),
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("LastWeek"),
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .orderBy("steps", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return RepaintBoundary(
                          child: Column(
                        children: [
                          Container(
                            width: double.maxFinite,
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.only(
                                left: 10, right: 10, top: 15, bottom: 8),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 193, 192, 192),
                            ),
                            child: Row(children: [
                              Text(
                                'Rank:',
                                style: colors.font9,
                              ),
                              Spacer(),
                              Text(
                                'Name:',
                                style: colors.font9,
                              ),
                              Spacer(),
                              Text(
                                'Steps:',
                                style: colors.font9,
                              )
                            ]),
                          ),
                          Expanded(
                              child: ListView(
                                  children: List.generate(snapshot.data!.size,
                                      (index) {
                            if (snapshot.data!.docs[index]["id"] ==
                                FirebaseAuth.instance.currentUser!.uid) {
                              return Container(
                                  width: double.maxFinite,
                                  padding: EdgeInsets.all(12),
                                  margin: EdgeInsets.only(
                                      left: 10, right: 10, top: 15, bottom: 8),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 185, 224, 250),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                      )
                                    ],
                                  ),
                                  child: Row(children: [
                                    Text(
                                      '${index + 1}',
                                      style: colors.font8,
                                    ),
                                    Spacer(),
                                    Text(
                                      '${snapshot.data!.docs[index]["name"]}',
                                      style: colors.font8,
                                    ),
                                    Spacer(),
                                    D(snapshot.data!.docs[index]['steps date'],
                                            snapshot.data!.docs[index]['id'])
                                        ? Text(
                                            '${snapshot.data!.docs[index]['steps']}',
                                            style: colors.font8,
                                          )
                                        : Text(
                                            '0',
                                            style: colors.font8,
                                          )
                                  ]));
                            } else {
                              return Container(
                                  width: double.maxFinite,
                                  padding: EdgeInsets.all(12),
                                  margin: EdgeInsets.only(
                                      left: 10, right: 10, top: 15, bottom: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                      )
                                    ],
                                  ),
                                  child: Row(children: [
                                    Text(
                                      '${index + 1}',
                                      style: colors.font8,
                                    ),
                                    Spacer(),
                                    Text(
                                      '${snapshot.data!.docs[index]["name"]}',
                                      style: colors.font8,
                                    ),
                                    Spacer(),
                                    D(snapshot.data!.docs[index]['steps date'],
                                            snapshot.data!.docs[index]['id'])
                                        ? Text(
                                            '${snapshot.data!.docs[index]['steps']}',
                                            style: colors.font8,
                                          )
                                        : Text(
                                            '0',
                                            style: colors.font8,
                                          )
                                  ]));
                            }
                          })))
                        ],
                      ));
                    } else {
                      return CircularProgressIndicator();
                      // return ElevatedButton(
                      //     style: ButtonStyle(
                      //         fixedSize: MaterialStateProperty.all<Size>(
                      //             Size(300, 10)),
                      //         backgroundColor: MaterialStateProperty.all<Color>(
                      //             Color.fromARGB(255, 245, 7, 7))),
                      //     onPressed: () async {
                      //       FirebaseAuth.instance.signOut();
                      //       await _googleSignIn.signOut().whenComplete(() {
                      //         Navigator.pushAndRemoveUntil(
                      //           context,
                      //           MaterialPageRoute(
                      //               builder: (context) => Login()),
                      //           (Route<dynamic> route) => false,
                      //         );
                      //       });
                      //     },
                      //     child: Text(
                      //       "Log Out",
                      //       style: TextStyle(color: Colors.white),
                      //     ));
                    }
                  }),
              //---------------------------------------------------------------------------------------------
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .orderBy("weekly steps", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return RepaintBoundary(
                          child: Column(
                        children: [
                          Container(
                            width: double.maxFinite,
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.only(
                                left: 10, right: 10, top: 15, bottom: 8),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 193, 192, 192),
                            ),
                            child: Row(children: [
                              Text(
                                'Rank:',
                                style: colors.font9,
                              ),
                              Spacer(),
                              Text(
                                'Name:',
                                style: colors.font9,
                              ),
                              Spacer(),
                              Text(
                                'Steps:',
                                style: colors.font9,
                              )
                            ]),
                          ),
                          Expanded(
                              child: ListView(
                                  children: List.generate(snapshot.data!.size,
                                      (index) {
                            if (snapshot.data!.docs[index]["id"] ==
                                FirebaseAuth.instance.currentUser!.uid) {
                              return Container(
                                  width: double.maxFinite,
                                  padding: EdgeInsets.all(12),
                                  margin: EdgeInsets.only(
                                      left: 10, right: 10, top: 15, bottom: 8),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 185, 224, 250),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                      )
                                    ],
                                  ),
                                  child: Row(children: [
                                    Text(
                                      '${index + 1}',
                                      style: colors.font8,
                                    ),
                                    Spacer(),
                                    Text(
                                      '${snapshot.data!.docs[index]["name"]}',
                                      style: colors.font8,
                                    ),
                                    Spacer(),
                                    S(
                                            snapshot.data!.docs[index]
                                                ['weekly steps date'],
                                            snapshot.data!.docs[index]['id'])
                                        ? Text(
                                            '${snapshot.data!.docs[index]['weekly steps']}',
                                            style: colors.font8,
                                          )
                                        : Text(
                                            '0',
                                            style: colors.font8,
                                          )
                                  ]));
                            } else {
                              return Container(
                                  width: double.maxFinite,
                                  padding: EdgeInsets.all(12),
                                  margin: EdgeInsets.only(
                                      left: 10, right: 10, top: 15, bottom: 8),
                                  decoration: BoxDecoration(
                                    color: colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                      )
                                    ],
                                  ),
                                  child: Row(children: [
                                    Text(
                                      '${index + 1}',
                                      style: colors.font8,
                                    ),
                                    Spacer(),
                                    Text(
                                      '${snapshot.data!.docs[index]["name"]}',
                                      style: colors.font8,
                                    ),
                                    Spacer(),
                                    S(
                                            snapshot.data!.docs[index]
                                                ['weekly steps date'],
                                            snapshot.data!.docs[index]['id'])
                                        ? Text(
                                            '${snapshot.data!.docs[index]['weekly steps']}',
                                            style: colors.font8,
                                          )
                                        : Text(
                                            '0',
                                            style: colors.font8,
                                          )
                                  ]));
                            }
                          })))
                        ],
                      ));
                    } else {
                      return CircularProgressIndicator();
                    }
                  })
              //---------------------------------------------------------------------------------------------
            ],
          ),
        ));
  }

  bool D(String v, String id) {
    final now = DateTime.now();

    String noww = DateFormat('yyyy-MM-dd').format(now);
    var check = DateTime.parse(v);
    String checkk = DateFormat('yyyy-MM-dd').format(check);
    if (checkk == noww) {
      return true;
    } else {
      FirebaseFirestore.instance
          .collection("users")
          .doc(id)
          .update({"steps": "0"});

      return false;
    }
  }

  bool S(String v, String id) {
    final now = DateTime.now();

    var thisweek = now.subtract(Duration(days: now.weekday));
    var day = DateTime.parse(v);
    var dayy = day.subtract(Duration(days: day.weekday));
    String thisweekk = DateFormat('yyyy-MM-dd').format(thisweek);
    String dayyy = DateFormat('yyyy-MM-dd').format(dayy);
    if (thisweekk == dayyy) {
      return true;
    } else {
      FirebaseFirestore.instance
          .collection("users")
          .doc(id)
          .update({"weekly steps": "0"});
      return false;
    }
  }
}
/*StreamBuilder(Stream:FirebaseFirestore.instance.collection("users").snapshots() , builder: (context, snapshot){
  if(snapshot.hasdata){

  }else{
    return CircularProgressIndicator();
  }
});*/