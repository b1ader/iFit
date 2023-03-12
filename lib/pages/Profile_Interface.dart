// ignore_for_file: library_private_types_in_public_api, non_constant_identifier_names, unused_element, unused_field, prefer_interpolation_to_compose_strings, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:googlelogin/design/colors.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.text,
    required this.icon,
    required this.data,
  }) : super(key: key);

  final String text;
  final Icon icon;
  final String data;

  @override
  _MyHomePageState createState() => _MyHomePageState.withdata(data);
}

class _MyHomePageState extends State<MyHomePage> {
  late String data;
  _MyHomePageState({required this.data});
  //
  factory _MyHomePageState.withdata(String data) {
    return _MyHomePageState(data: data);
  }

  //

  late Function() press;
  String valueText = "";
  TextEditingController _textFieldController = TextEditingController();
  TextEditingController dateinput = TextEditingController();

  //
  //
  String? G_List_Value; // <<<<<<<<<-----------------------------
  String codeDialog_Value = ""; // <<<<<<<<<-----------------------------

  //
  //

  @override
  void initState() {
    if (widget.text == 'Activity level') {
      dateinput.text = data;
      G_List_Value = data;
    } else if (widget.text == 'Daily steps goal') {
      codeDialog_Value = _textFieldController.text = data;
      valueText = data;
    } else if (widget.text == 'Weekly weight goal') {
      dateinput.text = data;
      G_List_Value = data;
    } else if (widget.text == 'Height') {
      codeDialog_Value = _textFieldController.text = data;
      valueText = data;
    } else if (widget.text == 'Weight') {
      codeDialog_Value = _textFieldController.text = data;
      valueText = data;
    } else if (widget.text == 'Gender') {
      dateinput.text = data;
      G_List_Value = data;
    }
    super.initState();
  }

  Future<void> date_Picker(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(2050));

    if (pickedDate != null) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({widget.text: formattedDate});
      setState(
        () {
          dateinput.text = formattedDate;
          data = dateinput.text;
        },
      );
    } else {}
  }

  Future<void> Gender_List(
      BuildContext context, List<String> d, String name, String title) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('$title'),
          content: DropdownButtonFormField(
            hint: Text(
              "Choose $title",
            ),
            isExpanded: true,
            iconSize: 35.0,
            style: TextStyle(color: Colors.blue),
            items: d.map(
              (val) {
                return DropdownMenuItem<String>(
                  value: val,
                  child: Text(val),
                );
              },
            ).toList(),
            onChanged: (val) async {
              await FirebaseFirestore.instance
                  .collection("users")
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .update({widget.text: val});
              setState(
                () {
                  G_List_Value = val;
                  if (name == "Gender") {
                    data = G_List_Value!;
                  } else if (name == "Activity level") {
                    data = G_List_Value!;
                  } else if (name == "Weekly weight goal") {
                    data = G_List_Value!;
                  }
                },
              );
            },
          ),
        );
      },
    );
  }

  Future<void> numbers_Only(BuildContext context) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(widget.text),
            content: TextField(
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ], // Only numbers can be entered
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Enter " + widget.text),
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                    primary: Color.fromARGB(255, 228, 15, 15)),
                child: Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    valueText = codeDialog_Value;
                    _textFieldController.text = codeDialog_Value;
                    Navigator.pop(context);
                  });
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                    primary: Color.fromARGB(255, 10, 236, 32)),
                child: Text('OK'),
                onPressed: () async {
                  if (valueText != '0' && valueText != '') {
                    await FirebaseFirestore.instance
                        .collection("users")
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .update({widget.text: valueText});
                    setState(() {
                      _textFieldController.text = valueText;
                      codeDialog_Value = valueText;
                      if (widget.text == 'Daily steps goal') {
                        data = _textFieldController.text;
                      } else if (widget.text == 'Height') {
                        data = _textFieldController.text;
                      } else if (widget.text == 'Weight') {
                        data = _textFieldController.text;
                      }
                      Navigator.pop(context);
                    });
                  } else if (valueText == '0') {
                    showAlertDialog(context, 'can not be zero');
                  } else {
                    showAlertDialog(context, 'Invalid Input');
                  }
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    String widget_value = "";

    if (widget.text == 'Activity level') {
      widget_value = data;
      codeDialog_Value = "";
      press = () {
        Gender_List(
            context,
            ["Not Very Active", "Lightly Active", "Active", "Very Active"],
            widget.text,
            "Activity level");
      };
    } else if (widget.text == 'Daily steps goal') {
      widget_value = data;
      press = () {
        numbers_Only(context);
      };
    } else if (widget.text == 'Weekly weight goal') {
      widget_value = data;
      press = () {
        Gender_List(
            context,
            ["Lose 0.5 kg per week", "Maintain weight", "Gain 0.5 kg per week"],
            widget.text,
            'Weekly weight goal');
      };
    } else if (widget.text == 'Height') {
      widget_value = data;
      press = () {
        numbers_Only(context);
      };
    } else if (widget.text == 'Weight') {
      widget_value = data;
      press = () {
        numbers_Only(context);
      };
    } else if (widget.text == 'Date of birth') {
      widget_value = data;
      press = () {
        date_Picker(context);
      };
    } else if (widget.text == 'Gender') {
      widget_value = data;
      press = () {
        Gender_List(context, ["Male", 'Female'], widget.text, "Gender");
      };
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: colors.secondary,
          padding: EdgeInsets.all(20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: colors.white,
        ),
        onPressed: press,
        child: Row(
          children: [
            widget.icon,
            SizedBox(width: 10),
            Expanded(
              child: Text((widget.text + " :  " + widget_value)),
            ),
            Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}

showAlertDialog(BuildContext context, String e) {
  Widget cancelButton = IconButton(
    icon: Icon(Icons.close),
    color: Color.fromARGB(255, 228, 15, 15),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  AlertDialog alert = AlertDialog(
    title: Text('Error!'),
    content: Text(e),
    actions: [cancelButton],
  );

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      });
}
