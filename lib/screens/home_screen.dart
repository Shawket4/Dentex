// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'dart:io';

import 'package:dentex/components/bottom_nav_bar.dart';
import 'package:dentex/components/drawer.dart';
import 'package:dentex/dio_helper.dart';
import 'package:dentex/main.dart';
import 'package:dentex/screens/dashboard_screen.dart';
import 'package:dentex/screens/doctor_patients.dart';
import 'package:dentex/screens/favourites_screen.dart';
import 'package:dentex/screens/search_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

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
    loadData();
    super.initState();
  }

  Future<void> loadData() async {
    bool isOnline = await isConnected();
    dynamic response;
    if (isOnline) {
      response = await getData("$ServerIP/api/protected/user", context);
      if (!kIsWeb && !Platform.isMacOS && !Platform.isWindows) {
        FirebaseMessaging.instance.getToken().then((token) {
          postData(
              "$ServerIP/api/protected/LinkDeviceToken",
              {
                "token": token,
              },
              context);
        });
      }
      await SetJSON(response, "UserInfo");
    } else {
      response = await GetJSON("UserInfo");
      response = json.decode(response);
    }
    userInfo.username = response["data"]["username"];
    userInfo.permission = response["data"]["permission"];
    userInfo.clinicName = response["data"]["clinic_name"];
    return;
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
