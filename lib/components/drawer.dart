import 'package:clinic_managment/main.dart';
import 'package:clinic_managment/screens/add_doctor_screen.dart';
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
        userInfo.permission == 2 ? Padding(
          padding: const EdgeInsets.only(left: 10, top: 5,),
          child: TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AddDoctorScreen()));
            },
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Add Doctor",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFFDFFFC)
                ),
              ),
            ),
          ),
        ) : Container(),
      ],
    ),
  );
}
