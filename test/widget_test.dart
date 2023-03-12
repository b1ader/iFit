// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:googlelogin/main.dart';
import 'package:googlelogin/pages/LeaderBoard.dart';
import 'package:googlelogin/pages/nutrition.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(nutrition());

    await tester.pump();
  });
  test("if steps up to date", (() {
    final _sut = Board();

    expect(_sut.D("2023-02-09 14:43:05.440117", "ClryzIoaIUT8RNQ4VMJhCVpIfIm1"),
        isTrue);
  }));

  test("Calc calories", () {
    final _sut = nu();
    expect(_sut.CCalories("Male", 21, 170, 65, "Active", "Maintain weight"),
        2500.9715);
    expect(
        _sut.CCalories(
            "Male", 21, 170, 65, "Not Very Active", "Maintain weight"),
        1936.2359999999999);
    expect(
        _sut.CCalories(
            "Male", 21, 170, 65, "Lightly Active", "Maintain weight"),
        2218.6037499999998);
    expect(
        _sut.CCalories("Male", 21, 170, 65, "Very Active", "Maintain weight"),
        2783.33925);
    expect(
        _sut.CCalories("Male", 21, 170, 65, "Active", "Lose 0.5 kg per week"),
        2100.9715);
    expect(
        _sut.CCalories("Male", 21, 170, 65, "Active", "Gain 0.5 kg per week"),
        2900.9715);
    //----------------------------------------------------
    expect(_sut.CCalories("Female", 21, 170, 65, "Active", "Maintain weight"),
        2243.6715);
    expect(
        _sut.CCalories(
            "Female", 21, 170, 65, "Not Very Active", "Maintain weight"),
        1737.0359999999998);
    expect(
        _sut.CCalories(
            "Female", 21, 170, 65, "Lightly Active", "Maintain weight"),
        1990.35375);
    expect(
        _sut.CCalories("Female", 21, 170, 65, "Very Active", "Maintain weight"),
        2496.98925);
    expect(
        _sut.CCalories("Female", 21, 170, 65, "Active", "Lose 0.5 kg per week"),
        1843.6715);
    expect(
        _sut.CCalories("Female", 21, 170, 65, "Active", "Gain 0.5 kg per week"),
        2643.6715);
  });

  test("Calc protien", () {
    final _sut = nu();
    expect(_sut.CProtein(65), 130);
  });

  test("Calc fat", () {
    final _sut = nu();
    expect(_sut.CFat(65), 57.2);
  });

  test("Calc Sfat", () {
    final _sut = nu();
    expect(_sut.Csfat(2500.9715), 27.788572222222225);
  });

  test("Calc carb", () {
    final _sut = nu();
    expect(_sut.CCarbohydrates(2500.9715, 130, 57.2), 366.542875);
  });
}
