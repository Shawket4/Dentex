// ignore_for_file: unused_local_variable, non_constant_identifier_names, constant_identifier_names, unused_import
import 'package:clinic_management/components/bottom_nav_bar.dart';
import 'package:clinic_management/models/user.dart';
import 'package:flutter/material.dart';
import 'package:clinic_management/screens/home_screen.dart';
import 'package:clinic_management/screens/login_page.dart';
import 'package:dio/dio.dart';
import 'package:material_color_generator/material_color_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(const Router());
}

final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
late String jwt;
User userInfo = User();
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

Future<bool> get Logout async {
  final SharedPreferences prefs = await _prefs;
  return await prefs.remove("jwt");
}

const String ServerIP = "http://localhost:5505";

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
        fontFamily: "Inter",
        primaryColor: const Color(0xFF0b132b),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF0b132b),
          secondary: const Color(0xFF011627),
        ),
        primarySwatch: generateMaterialColor(
          color: const Color(0xFF0b132b),
        ),
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
