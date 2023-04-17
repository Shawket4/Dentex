// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, unused_import, deprecated_member_use

import 'package:dentex/components/app_bar.dart';
import 'package:dentex/components/dialog.dart';
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
  // late BuildContext dialogContext;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9),
      appBar: const CustomAppBar(title: "Dentex", actions: null),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 200,
                child: Container(
                  margin: EdgeInsets.only(top: 50),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      height: MediaQuery.of(context).size.shortestSide / 4,
                      child: Image.asset(
                        "assets/images/Logo_Dark.png",
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
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
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RegisterDemoScreen(),
                          ),
                        );
                      },
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          showLoadingDialog(context);
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
                                  builder: (_) => HomeScreen(),
                                ),
                              );
                            }
                          }
                        } catch (e) {
                          if (e is DioError) {
                            if (e.response!.statusCode == 401) {
                              showErrorDialogLogin(context, "Account Frozen");
                            } else {
                              showErrorDialogLogin(
                                  context, "Invalid Credentials");
                            }
                          } else {
                            showErrorDialogLogin(
                                context, "Invalid Credentials");
                          }
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
                  ],
                ),
              ),
              const SizedBox(
                height: 150,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
