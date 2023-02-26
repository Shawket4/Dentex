// ignore_for_file: unused_local_variable, non_constant_identifier_names, constant_identifier_names

import 'package:clinic_managment/screens/add_doctor_screen.dart';
import 'package:flutter/material.dart';
import 'package:clinic_managment/screens/home_screen.dart';
import 'package:clinic_managment/screens/login_page.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(const Router());
}

final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
late String jwt;
UserInfo userInfo = UserInfo();
Future<String> get _getJwt async {
  final SharedPreferences prefs = await _prefs;
  // await prefs.remove("jwt");
  jwt = (prefs.getString('jwt') ?? "");
  dio.options.headers["Authorization"] = "Bearer $jwt";
  try {
    var checkValidity = await dio.get("$ServerIP/api/protected/user");
  } catch (e) {
    Logout;
    jwt = "";
    return jwt;
  }
  return jwt;
}

Future<bool> SetJwt(String jwt) async {
  final SharedPreferences prefs = await _prefs;
  final bool status = await (prefs.setString('jwt', jwt));
  return status;
}

Dio dio = Dio();

Future<UserInfo> get GetUserInfo async {
  var response = await dio.get("$ServerIP/api/protected/user");
 String user_name = response.data["data"]["username"].toString();
 int  permission = response.data["data"]["permission"];
  

  userInfo.username = user_name;
  userInfo.permission = permission;
  return userInfo;
}

Future<bool> get Logout async {
  final SharedPreferences prefs = await _prefs;
  return await prefs.remove("jwt");
}

const String ServerIP = "http://172.20.10.6:5505";

class Router extends StatefulWidget {
  const Router({Key? key}) : super(key: key);
  @override
  State<Router> createState() => _RouterState();
}

class _RouterState extends State<Router> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: const Color(0xFF0b132b),
      ),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
          future: _getJwt,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Scaffold(
                body: Center(
                  child: Lottie.asset(
                    "assets/lottie/Loading.json",
                    height: 200,
                    width: 200,
                  ),
                ),
              );
            } else {
              if (jwt != "") {
                return const HomeScreen();
              } else {
                return const LoginPage();
              }
            }
          }),
    );
  }
}

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Quick Quiz',
//       home: LoginPage(),
//     );
//   }
// }
class UserInfo {
  String username = "";
  int permission = 0;
}