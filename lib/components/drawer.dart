// ignore_for_file: non_constant_identifier_names

import 'package:clinic_management/add_screens/add_appointment.dart';
import 'package:clinic_management/add_screens/add_patient.dart';
import 'package:clinic_management/main.dart';
import 'package:clinic_management/add_screens/add_doctor_screen.dart';
import 'package:clinic_management/screens/doctor_patients.dart';
import 'package:clinic_management/screens/home_screen.dart';
import 'package:flutter/material.dart';

Widget SideMenu(BuildContext context) {
  return Drawer(
    backgroundColor: const Color(0xFF011627),
    child: ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 4.0, top: 30),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage("assets/images/user_avatar.png"),
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
        userInfo.permission == 1
            ? buildMenuItem("Dashboard", const HomeScreen(), context)
            : Container(),
        userInfo.permission == 1
            ? buildMenuItem("My Patients", const DoctorPatientScreen(), context)
            : Container(),
        userInfo.permission == 2
            ? buildMenuItem("Add Doctor", const AddDoctorScreen(), context)
            : Container(),
        buildMenuItem("Add Patient", const AddPatientScreen(), context),
        buildMenuItem("Add Appointment", const AddAppointmentScreen(), context),
      ],
    ),
  );
}

Widget buildMenuItem(String label, Widget route, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(10),
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
