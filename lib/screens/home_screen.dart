import 'package:clinic_management/components/drawer.dart';
import 'package:flutter/material.dart';
import 'package:clinic_management/screens/login_page.dart';
import 'package:clinic_management/main.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: GetUserInfo,
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
          return Scaffold(
              backgroundColor: const Color(0xFFFDFFFC),
              drawer: SideMenu(context),
              appBar: AppBar(
                centerTitle: true,
                backgroundColor: const Color(0xFF011627),
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: IconButton(
                      onPressed: () async {
                        final bool response = await Logout;
                        if (response) {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
                        }
                      },
                      icon: const Icon(
                        Icons.logout_rounded,
                        size: 30,
                      ),
                    ),
                  ),
                ],
                title: const Text(
                  "Home",
                ),
              ),
              body: Padding(
          padding: const EdgeInsets.all(8.0),
        child: Text("Welcome, ${userInfo.username}"),
        ),
        );
        }
      }
    );
  }
}
