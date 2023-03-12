import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googlelogin/design/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:googlelogin/pages/Login.dart';
import 'package:intl/intl.dart';
import '../design/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:empty_widget/empty_widget.dart';

class Rewords extends StatefulWidget {
  rewards createState() => rewards();
}

//final GoogleSignIn _googleSignIn = GoogleSignIn();

class rewards extends State<Rewords> {
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
              '',
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
                    child: Text("Rewards"),
                  ),
                ),
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("MyRewards"),
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(children: <Widget>[
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("rewards")
                  .orderBy("points", descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var val = snapshot.data;
                  return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .where("id",
                            isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return RepaintBoundary(
                            child: Column(children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .center, //Center Row contents horizontally,

                              children: [
                                Icon(
                                  Icons.run_circle_outlined,
                                  size: 35,
                                  color: colors.secondary,
                                ),
                                Text(
                                  " :${snapshot.data!.docs.first["points"]}",
                                  style: colors.font2,
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "500 Steps = 1 Point",
                            style: colors.font13,
                          ),
                          Expanded(
                              child: ListView(
                                  children: List.generate(val!.size, (index) {
                            return Container(
                                width: double.maxFinite,
                                height: 80,
                                padding: EdgeInsets.all(12),
                                margin: EdgeInsets.only(
                                    left: 10, right: 10, top: 15, bottom: 8),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(9)),
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
                                  Image.network(
                                    "${val!.docs[index]["img"]}",
                                    width: 50,
                                    height: 50,
                                  ),
                                  Text(
                                    "${val!.docs[index]["name"]}",
                                    style: colors.font8,
                                  ),
                                  Spacer(),
                                  (int.parse(snapshot
                                              .data!.docs.first["points"]) >=
                                          int.parse(val!.docs[index]["points"]))
                                      ? ElevatedButton(
                                          style: ButtonStyle(
                                              fixedSize: MaterialStateProperty
                                                  .all<Size>(Size(15, 10)),
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(colors.secondary)),
                                          onPressed: () async {
                                            await showAlertDialog(
                                                context,
                                                val!.docs[index]["id"],
                                                snapshot
                                                    .data!.docs.first["points"],
                                                val!.docs[index]["points"],
                                                val!.docs[index]["code"],
                                                val!.docs[index]["name"],
                                                val!.docs[index]["img"]);
                                          },
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .center, //Center Row contents horizontally,
                                            children: [
                                              Icon(
                                                Icons.run_circle_outlined,
                                                size: 15,
                                                color: colors.white,
                                              ),
                                              Text(
                                                "${val!.docs[index]["points"]}",
                                                style: colors.font12,
                                              ),
                                            ],
                                          ),
                                        )
                                      : ElevatedButton(
                                          style: ButtonStyle(
                                              fixedSize: MaterialStateProperty
                                                  .all<Size>(Size(25, 12)),
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      Color.fromARGB(
                                                          255, 193, 192, 192))),
                                          onPressed: () {},
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .center, //Center Row contents horizontally,
                                            children: [
                                              Icon(
                                                Icons.run_circle_outlined,
                                                size: 15,
                                                color: colors.secondary,
                                              ),
                                              Text(
                                                "${val!.docs[index]["points"]}",
                                                style: colors.font12,
                                              ),
                                            ],
                                          ),
                                        )
                                ]));
                          })))
                        ]));
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),

            //------------------------------------------------------------------------------------------------------------------------
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("usrs")
                  .where("userid",
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.docs.length == 0) {
                    return EmptyWidget(
                        image: null,
                        packageImage: PackageImage.Image_1,
                        title: 'No Rewards',
                        subTitle: '',
                        titleTextStyle: TextStyle(
                          fontSize: 22,
                          color: Color(0xff9da9c7),
                          fontWeight: FontWeight.w500,
                        ));
                    // return ElevatedButton(
                    //     style: ButtonStyle(
                    //         fixedSize:
                    //             MaterialStateProperty.all<Size>(Size(300, 10)),
                    //         backgroundColor: MaterialStateProperty.all<Color>(
                    //             Color.fromARGB(255, 245, 7, 7))),
                    //     onPressed: () async {
                    //       FirebaseAuth.instance.signOut();
                    //       await _googleSignIn.signOut().whenComplete(() {
                    //         Navigator.pushAndRemoveUntil(
                    //           context,
                    //           MaterialPageRoute(builder: (context) => Login()),
                    //           (Route<dynamic> route) => false,
                    //         );
                    //       });
                    //     },
                    //     child: Text(
                    //       "Log Out",
                    //       style: TextStyle(color: Colors.white),
                    //     ));
                  } else {
                    return Column(children: [
                      Expanded(
                          child: ListView(
                              children:
                                  List.generate(snapshot.data!.size, (index) {
                        return Container(
                            width: double.maxFinite,
                            height: 60,
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
                              Image.network(
                                "${snapshot.data!.docs[index]["img"]}",
                                width: 50,
                                height: 50,
                              ),
                              Text(
                                "${snapshot.data!.docs[index]["name"]}",
                                style: colors.font8,
                              ),
                              Spacer(),
                              MaterialButton(
                                child: Text(
                                  '${snapshot.data!.docs[index]["code"]}',
                                  style: colors.font12,
                                  textAlign: TextAlign.right,
                                ),
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(
                                          text:
                                              "${snapshot.data!.docs[index]["code"]}"))
                                      .then((value) {
                                    //only if ->
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("Copied")));
                                  });
                                },
                              )
                            ]));
                      })))
                    ]);
                  }
                } else {
                  return CircularProgressIndicator();
                }
              },
            )
          ]),
          //--------------------------------------------------------------------------------------------------------------------------
        ));
  }

  redeem(String id, String points, String pointsneeded, String code,
      String name, String img) {
    String calc = (int.parse(points) - int.parse(pointsneeded)).toString();
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"points": "$calc"});
    FirebaseFirestore.instance.collection("usrs").doc().set({
      "userid": "${FirebaseAuth.instance.currentUser!.uid}",
      "img": "$img",
      "name": "$name",
      "code": "$code",
    });
  }

  showAlertDialog(BuildContext context, String id, String points,
      String pointsneeded, String code, String name, String img) {
    // set up the buttons
    Widget cancelButton = TextButton(
      style: TextButton.styleFrom(primary: Color.fromARGB(255, 228, 15, 15)),
      child: Text(
        "Cancel",
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Yes"),
      onPressed: () {
        redeem(id, points, pointsneeded, code, name, img);
        Navigator.pop(context);
      },
    ); // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text("Would you like to proceed ?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    ); // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
