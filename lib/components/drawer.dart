import 'package:clinic_management/add_screens/add_appointment.dart';
import 'package:clinic_management/add_screens/add_doctor_screen.dart';
import 'package:clinic_management/add_screens/add_patient.dart';
import 'package:clinic_management/add_screens/add_treatment.dart';
import 'package:clinic_management/components/bottom_nav_bar.dart';
import 'package:clinic_management/main.dart';
import 'package:flutter/material.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key, required this.update, required this.closeDrawer});
  final Function update;
  final Function closeDrawer;
  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF011627),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4.0, top: 30),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage:
                          AssetImage("assets/images/user_avatar.png"),
                      radius: 25,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(
                        userInfo.username,
                        style: const TextStyle(
                            fontSize: 22,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFFDFFFC)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ...List.generate(
              bottomItems.length,
              (index) => Padding(
                padding: const EdgeInsets.all(8),
                child: TextButton(
                  onPressed: () {
                    widget.update();
                    setState(() {
                      widget.update;
                      selectedIndex = index;
                      selectedBottomItem = bottomItems[index];
                      widget.closeDrawer();
                    });
                    bottomItems[index].input!.change(true);
                    Future.delayed(const Duration(milliseconds: 600), () {
                      bottomItems[index].input!.change(false);
                    });
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      bottomItems[index].title,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFFDFFFC)),
                    ),
                  ),
                ),
              ),
            ),
            userInfo.permission == 2
                ? buildMenuItem("Add Doctor", const AddDoctorScreen(), context)
                : Container(),
            userInfo.permission == 1
                ? buildMenuItem(
                    "Add Patient", const AddPatientScreen(), context)
                : Container(),
            userInfo.permission == 1
                ? buildMenuItem(
                    "Add Appointment", const AddAppointmentScreen(), context)
                : Container(),
            userInfo.permission == 1
                ? buildMenuItem(
                    "Add Treatment", const AddTreatmentScreen(), context)
                : Container(),
          ],
        ),
      ),
    );
  }
}

Widget buildMenuItem(String label, Widget route, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(8),
    child: TextButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => route));
      },
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          label,
          style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFFFDFFFC)),
        ),
      ),
    ),
  );
}
