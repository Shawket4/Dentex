// ignore_for_file: use_build_context_synchronously

import 'package:dentex/components/app_bar.dart';
import 'package:dentex/components/dialog.dart';
import 'package:dentex/dio_helper.dart';
import 'package:dentex/main.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  final String developerName = "Shawket Ibrahim";
  final String appVersion = "1.0.5";
  final String appLogo = "assets/images/Logo_Dark.png";

  const AboutPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9),
      appBar: const CustomAppBar(
        title: "About",
        actions: null,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              appLogo,
              width: 300.0,
              height: 300.0,
            ),
            Text(
              "Developed By: $developerName",
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              'App Version: $appVersion',
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 40.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              onPressed: () async {
                try {
                  var response = await getData(
                      "$ServerIP/api/protected/DeleteUser", context);
                  if (response["message"] == "Account Deleted Successfully") {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MainWidget(),
                      ),
                    );
                    showSuccessDialog(context);
                  }
                } catch (e) {
                  showErrorDialog(context);
                }
              },
              child: const Text(
                'Delete Account',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 150,
            ),
          ],
        ),
      ),
    );
  }
}
