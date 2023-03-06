// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'package:clinic_management/components/bottom_nav_bar.dart';
import 'package:clinic_management/components/drawer.dart';
import 'package:clinic_management/dio_helper.dart';
import 'package:clinic_management/main.dart';
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
    getData("$ServerIP/api/protected/user").then((response) {
      String userName = response["data"]["username"].toString();
      int permission = response["data"]["permission"];

      userInfo.username = userName;
      userInfo.permission = permission;
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
