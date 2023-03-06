// ignore_for_file: unused_local_variable, non_constant_identifier_names

import 'package:clinic_management/components/rive_controller.dart';
import 'package:clinic_management/screens/dashboard_screen.dart';
import 'package:clinic_management/screens/doctor_patients.dart';
import 'package:clinic_management/screens/home_screen.dart';
import 'package:clinic_management/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

RiveAsset selectedBottomItem = bottomItems.first;
int selectedIndex = 0;

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar({super.key, required this.update});
  final Function update;
  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ...List.generate(
              bottomItems.length,
              (index) => GestureDetector(
                onTap: () {
                  widget.update();
                  setState(() {
                    selectedIndex = index;
                    selectedBottomItem = bottomItems[index];
                  });
                  bottomItems[index].input!.change(true);
                  Future.delayed(const Duration(milliseconds: 600), () {
                    bottomItems[index].input!.change(false);
                  });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedBar(bottomItems[index] == selectedBottomItem),
                    SizedBox(
                      height: 40,
                      width: 40,
                      child: Opacity(
                        opacity:
                            selectedBottomItem == bottomItems[index] ? 1 : 0.5,
                        child: RiveAnimation.asset(
                          "assets/rive/icons.riv",
                          artboard: bottomItems[index].artboard,
                          onInit: (artboard) {
                            StateMachineController controller =
                                getRiveController(
                              artboard,
                              bottomItems[index].stateMachineName,
                            );
                            bottomItems[index].input =
                                controller.findSMI("active") as SMIBool;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Widget CustomNavigationBar(BuildContext context) {}

class RiveAsset {
  final String artboard, stateMachineName, title;
  final Widget route;
  late SMIBool? input;
  RiveAsset({
    required this.artboard,
    required this.stateMachineName,
    required this.title,
    required this.route,
    this.input,
  });
  set setInput(SMIBool status) {
    input = status;
  }
}

Widget loadScreen(Function openDrawer) {
  switch (selectedIndex) {
    case 0:
      return DashboardScreen(
        openDrawer: openDrawer,
      );
    case 1:
      return SearchScreen(
        openDrawer: openDrawer,
      );
    case 2:
      return DoctorPatientScreen(
        openDrawer: openDrawer,
      );
  }
  return const HomeScreen();
}

void loadBottomItems(Function openDrawer) {
  bottomItems = [
    RiveAsset(
      artboard: "HOME",
      stateMachineName: "HOME_interactivity",
      title: "Dashboard",
      route: const HomeScreen(),
    ),
    RiveAsset(
      artboard: "SEARCH",
      stateMachineName: "SEARCH_Interactivity",
      title: "Search",
      route: SearchScreen(
        openDrawer: openDrawer,
      ),
    ),
    RiveAsset(
      artboard: "USER",
      stateMachineName: "USER_Interactivity",
      title: "My Patients",
      route: DoctorPatientScreen(
        openDrawer: openDrawer,
      ),
    ),
  ];
  selectedIndex = 0;
  selectedBottomItem = bottomItems[selectedIndex];
}

List<RiveAsset> bottomItems = [];

AnimatedContainer AnimatedBar(bool isActive) {
  return AnimatedContainer(
    duration: const Duration(milliseconds: 200),
    margin: const EdgeInsets.only(bottom: 2),
    height: 4,
    width: isActive ? 22 : 0,
    decoration: BoxDecoration(
        color: const Color(0xFF81B4FF),
        borderRadius: BorderRadius.circular(12)),
  );
}
