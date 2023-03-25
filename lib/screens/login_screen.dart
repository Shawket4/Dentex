// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, unused_import, deprecated_member_use

import 'package:dentex/animation/fade_animation.dart';
import 'package:dentex/screens/register_demo_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:dentex/screens/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late BuildContext dialogContext;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF011627),
        title: const Text(
          "Login",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 200,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: 30,
                    width: 80,
                    height: 200,
                    child: FadeAnimation(
                      1,
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            opacity: 0.4,
                            image: AssetImage(
                              'assets/images/light-1.png',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 140,
                    width: 80,
                    height: 150,
                    child: FadeAnimation(
                        1.3,
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              opacity: 0.4,
                              image: AssetImage(
                                'assets/images/light-2.png',
                              ),
                            ),
                          ),
                        )),
                  ),
                  Positioned(
                    right: 40,
                    top: 40,
                    width: 80,
                    height: 150,
                    child: FadeAnimation(
                      1.5,
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            opacity: 0.4,
                            image: AssetImage('assets/images/clock.png'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    child: FadeAnimation(
                      1.6,
                      Container(
                        margin: EdgeInsets.only(top: 50),
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            height:
                                MediaQuery.of(context).size.shortestSide / 4,
                            child: Image.asset(
                              "assets/images/Logo_Dark.png",
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            FadeAnimation(
              1.8,
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextField(
                        autocorrect: false,
                        controller: usernameController,
                        decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF011627),
                              width: 2.0,
                            ),
                          ),
                          border: OutlineInputBorder(),
                          labelText: 'User Name',
                          labelStyle: TextStyle(
                            color: Color(0xFF011627),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextField(
                        autocorrect: false,
                        obscureText: true,
                        controller: passwordController,
                        decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF011627),
                              width: 2.0,
                            ),
                          ),
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            color: Color(0xFF011627),
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      child: Text(
                        "Try A Demo",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RegisterDemoScreen(),
                          ),
                        );
                      },
                    ),
                    FadeAnimation(
                      2,
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  dialogContext = context;
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: SizedBox(
                                      height: 400,
                                      width: double.infinity,
                                      child: Center(
                                        // Display lottie animation
                                        child: Lottie.asset(
                                          "assets/lottie/Loading.json",
                                          height: 200,
                                          width: 200,
                                        ),
                                      ),
                                    ),
                                  );
                                });
                            var response = await dio.post(
                              "$ServerIP/api/login",
                              data: {
                                "username": usernameController.text,
                                "password": passwordController.text
                              },
                            );
                            var message = response.data["message"];
                            if (message == "Login Successful") {
                              var jwt = response.data["jwt"];
                              final bool status = await SetJwt(jwt);
                              if (status) {
                                dio.options.headers['Content-Type'] =
                                    "application/json";
                                dio.options.headers['Authorization'] =
                                    "Bearer $jwt";
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => HomeScreen()));
                              }
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: SizedBox(
                                      height: 400,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: double.infinity,
                                            child: Center(
                                              // Display lottie animation
                                              child: Lottie.asset(
                                                "assets/lottie/Error.json",
                                                height: 300,
                                                width: 300,
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(dialogContext);
                                              Navigator.pop(dialogContext);
                                            },
                                            child: const Text(
                                              "Close",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                          } catch (e) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                dialogContext = context;
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: SizedBox(
                                    height: 400,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: double.infinity,
                                          child: Center(
                                            // Display lottie animation
                                            child: Lottie.asset(
                                              "assets/lottie/Error.json",
                                              height: 200,
                                              width: 200,
                                            ),
                                          ),
                                        ),
                                        const Text(
                                          "Invalid Credentials",
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(dialogContext);
                                            Navigator.pop(dialogContext);
                                          },
                                          child: const Text(
                                            "Close",
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        },
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            // gradient: LinearGradient(
                            //   colors: [
                            //     Color.fromRGBO(143, 148, 251, 1),
                            //     Color.fromRGBO(143, 148, 251, .6),
                            //   ],
                            // ),
                            color: Theme.of(context).primaryColor,
                          ),
                          child: Center(
                            child: Text(
                              "Login",
                              style: GoogleFonts.jost(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
