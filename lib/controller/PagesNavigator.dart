import 'package:flutter/material.dart';
import 'package:googlelogin/pages/HomePage.dart';
import 'package:googlelogin/pages/LeaderBoard.dart';
import 'package:googlelogin/pages/Profile.dart';
import 'package:googlelogin/pages/rewards.dart';
import '../design/colors.dart';
import 'package:get/get.dart';
import 'navcontroller.dart';
import '../pages/HomePage.dart';
import '../design/app_data.dart';
import '../design/colors.dart';

final navcontroller controller = Get.put(navcontroller());

class PagesNavigator extends StatelessWidget {
  final List<Widget> screens = [
    HomePage(),
    LeaderBoard(),
    Rewords(),
    profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.maincolor,
      bottomNavigationBar: Obx(
        () {
          return BottomNavigationBar(
            backgroundColor: Colors.white,
            unselectedItemColor: Colors.black,
            currentIndex: controller.currentBottomNavItemIndex.value,
            showUnselectedLabels: true,
            onTap: controller.switchBetweenBottomNavigationItems,
            fixedColor: colors.secondary,
            items: AppData.bottomNavigationItems
                .map(
                  (element) => BottomNavigationBarItem(
                      icon: element.icon, label: element.label),
                )
                .toList(),
          );
        },
      ),
      body: Obx(() => screens[controller.currentBottomNavItemIndex.value]),
    );
  }
}
