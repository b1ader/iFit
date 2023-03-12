import 'package:flutter/material.dart';
import '../Component/bottom_navigation_item.dart';

class AppData {
  const AppData._();

  static List<BottomNavigationItem> bottomNavigationItems = [
    BottomNavigationItem(const Icon(Icons.home), ''),
    BottomNavigationItem(const Icon(Icons.leaderboard), ''),
    BottomNavigationItem(const Icon(Icons.shopping_bag), ''),
    BottomNavigationItem(const Icon(Icons.person), '')
  ];
}
