// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'package:dentex/components/bottom_nav_bar.dart';
import 'package:dentex/components/drawer.dart';
import 'package:dentex/dio_helper.dart';
import 'package:dentex/main.dart';
import 'package:dentex/screens/dashboard_screen.dart';
import 'package:dentex/screens/doctor_patients.dart';
import 'package:dentex/screens/favourites_screen.dart';
import 'package:dentex/screens/search_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _update() {
    setState(() {});
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  void _changeDrawerState() {
    if (_key.currentState!.isDrawerOpen) {
      _key.currentState!.closeDrawer();
    } else {
      _key.currentState!.openDrawer();
    }
  }

  @override
  void initState() {
    loadBottomItems(_changeDrawerState);
    loadSideItems(_changeDrawerState);
    getData("$ServerIP/api/protected/user").then((response) {
      String userName = response["data"]["username"].toString();
      int permission = response["data"]["permission"];
      String? clinicName = response["data"]["clinic_name"];
      userInfo.username = userName;
      userInfo.permission = permission;
      userInfo.clinicName = clinicName;
      FirebaseMessaging.instance.getToken().then((token) {
        postData("$ServerIP/api/protected/LinkDeviceToken", {
          "token": token,
        });
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: const Color(0xFFF2F5F9),
      bottomNavigationBar: CustomNavigationBar(update: _update),
      drawer: SideMenu(
        update: _update,
        closeDrawer: _changeDrawerState,
      ),
      body: loadScreen(_changeDrawerState),
    );
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
    case 3:
      return FavouriteScreen(
        openDrawer: openDrawer,
      );
  }
  return DashboardScreen(
    openDrawer: openDrawer,
  );
}
