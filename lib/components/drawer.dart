// ignore_for_file: deprecated_member_use

import 'package:clinic_management/add_screens/add_doctor_screen.dart';
import 'package:clinic_management/add_screens/add_patient.dart';
import 'package:clinic_management/add_screens/add_treatment.dart';
import 'package:clinic_management/components/bottom_nav_bar.dart';
import 'package:clinic_management/components/rive_controller.dart';
import 'package:clinic_management/main.dart';
import 'package:clinic_management/screens/doctor_patients.dart';
import 'package:clinic_management/screens/favourites_screen.dart';
import 'package:clinic_management/screens/home_screen.dart';
import 'package:clinic_management/screens/search_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key, required this.update, required this.closeDrawer});
  final Function update;
  final Function closeDrawer;
  @override
  State<SideMenu> createState() => _SideMenuState();
}

RiveAsset? selectedSideItem;

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 308,
      child: Drawer(
        backgroundColor: const Color(0xFF011627),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 70,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      width: 230,
                      child: SvgPicture.asset(
                        "assets/images/Side_Logo.svg",
                        color: Colors.white,
                      ),
                    ),
                  ),
                  ...List.generate(
                    sideItems.length - 3,
                    (index) => Stack(
                      children: [
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 250),
                          height: 60,
                          width: selectedSideItem == sideItems[index] ? 308 : 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF6792FF),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            widget.update();
                            selectedIndex = index;
                            selectedBottomItem = bottomItems[index];
                            selectedSideItem = sideItems[index];
                            bottomItems[index].input!.change(true);
                            sideItems[index].input!.change(true);
                            Future.delayed(const Duration(milliseconds: 500),
                                () {
                              bottomItems[index].input!.change(false);
                              sideItems[index].input!.change(false);
                              widget.closeDrawer();
                            });
                          },
                          child: SizedBox(
                            height: 60,
                            child: ListTile(
                              title: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: RiveAnimation.asset(
                                        sideItems[index].file,
                                        artboard: sideItems[index].artboard,
                                        alignment: Alignment.centerLeft,
                                        onInit: (artboard) {
                                          StateMachineController controller =
                                              getRiveController(
                                            artboard,
                                            sideItems[index].stateMachineName,
                                          );
                                          sideItems[index].input = controller
                                                  .findSMI(sideItems[index].smi)
                                              as SMIBool;
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      bottomItems[index].title,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontFamily: "Calibri",
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFFFDFFFC),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  userInfo.permission == 2
                      ? buildMenuItem("Add Doctor", const AddDoctorScreen(), 3)
                      : Container(),
                  userInfo.permission == 1
                      ? buildMenuItem(
                          "Add Patient", const AddPatientScreen(), 4)
                      : Container(),
                  userInfo.permission == 1
                      ? buildMenuItem(
                          "Add Treatment", const AddTreatmentScreen(), 5)
                      : Container(),
                  // Spacer(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.white24,
                  radius: 23,
                  child: Icon(
                    CupertinoIcons.person,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  userInfo.username,
                  style: const TextStyle(
                    fontSize: 22,
                    overflow: TextOverflow.ellipsis,
                    fontFamily: "Calibri",
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFFDFFFC),
                  ),
                ),
                subtitle: Text(
                  userInfo.permission == 1 ? "Doctor" : "Admin",
                  style: const TextStyle(
                    fontSize: 18,
                    overflow: TextOverflow.ellipsis,
                    fontFamily: "Calibri",
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFFDFFFC),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem(String label, Widget route, int index) {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 250),
          height: 60,
          width: selectedSideItem == sideItems[index] ? 308 : 0,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF6792FF),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            widget.update();
            selectedSideItem = sideItems[index];
            Future.delayed(const Duration(milliseconds: 500), () {
              widget.closeDrawer();
              selectedSideItem = sideItems[selectedIndex];
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => route),
              );
            });
          },
          child: SizedBox(
            height: 60,
            child: ListTile(
              title: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    // SizedBox(
                    //   width: 40,
                    //   height: 40,
                    //   child: RiveAnimation.asset(
                    //     sideItems[index].file,
                    //     artboard: sideItems[index].artboard,
                    //     alignment: Alignment.centerLeft,
                    //     onInit: (artboard) {
                    //       StateMachineController controller = getRiveController(
                    //         artboard,
                    //         sideItems[index].stateMachineName,
                    //       );
                    //       sideItems[index].input =
                    //           controller.findSMI(sideItems[index].smi) as SMIBool;
                    //     },
                    //   ),
                    // ),
                    const SizedBox(
                      width: 40,
                      height: 40,
                      child: Icon(
                        CupertinoIcons.add_circled,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 20,
                        fontFamily: "Calibri",
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFFDFFFC),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

void loadSideItems(Function openDrawer) {
  sideItems = [
    RiveAsset(
      file: "assets/rive/icons.riv",
      artboard: "HOME",
      stateMachineName: "HOME_interactivity",
      title: "Dashboard",
      smi: "active",
      route: const HomeScreen(),
    ),
    RiveAsset(
      file: "assets/rive/icons.riv",
      artboard: "SEARCH",
      stateMachineName: "SEARCH_Interactivity",
      title: "Search",
      smi: "active",
      route: SearchScreen(
        openDrawer: openDrawer,
      ),
    ),
    RiveAsset(
      file: "assets/rive/icons.riv",
      artboard: "USER",
      stateMachineName: "USER_Interactivity",
      title: "My Patients",
      smi: "active",
      route: DoctorPatientScreen(
        openDrawer: openDrawer,
      ),
    ),
    RiveAsset(
      file: "assets/rive/icons.riv",
      artboard: "LIKE/STAR",
      stateMachineName: "STAR_Interactivity",
      title: "Favourites",
      smi: "active",
      route: FavouriteScreen(
        openDrawer: openDrawer,
      ),
    ),
    RiveAsset(
      file: "assets/rive/add_icon.riv",
      artboard: "ADD",
      stateMachineName: "ICON_Interactivity",
      title: "Add Doctor",
      smi: "Example",
      route: const Placeholder(),
    ),
    RiveAsset(
      file: "assets/rive/add_icon.riv",
      artboard: "ADD",
      stateMachineName: "ICON_Interactivity",
      title: "Add Patient",
      smi: "Example",
      route: const AddPatientScreen(),
    ),
    RiveAsset(
      file: "assets/rive/add_icon.riv",
      artboard: "ADD",
      stateMachineName: "ICON_Interactivity",
      title: "Add Treatment",
      smi: "Example",
      route: const AddTreatmentScreen(),
    ),
  ];
  selectedIndex = 0;
  selectedSideItem = sideItems[selectedIndex];
}

List<RiveAsset> sideItems = [];
