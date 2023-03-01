// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'package:clinic_management/components/drawer.dart';
import 'package:clinic_management/dio_helper.dart';
import 'package:clinic_management/models/appointment.dart';
import 'package:clinic_management/screens/appointment_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:clinic_management/screens/login_page.dart';
import 'package:clinic_management/main.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

bool isUserLoaded = false;

class _HomeScreenState extends State<HomeScreen> {
  List<Appointment> allAppointments = [];
  List<Appointment> currentMonthAppointments = [];
  List<Widget> appointmentWidgetsToday = [];
  @override
  void initState() {
    isUserLoaded = false;
    DateTime currentDate = DateTime.now();
    getData("$ServerIP/api/protected/GetDoctorAppointments").then((response) {
      for (var obj in response) {
        Appointment appointment = Appointment();
        appointment.id = obj["ID"];
        appointment.date = DateTime.parse(obj["date"]);
        appointment.patientName = obj["patient_name"];
        appointment.treatment = obj["treatment"];
        appointment.price = double.parse(obj["price"].toString());
        appointment.isPaid = obj["is_paid"];
        appointment.isCompleted = obj["is_completed"];
        allAppointments.add(appointment);
        if (appointment.date!.year == currentDate.year &&
            appointment.date!.month == currentDate.month) {
          currentMonthAppointments.add(appointment);
        }
        if (appointment.date!.year == currentDate.year &&
            appointment.date!.month == currentDate.month &&
            appointment.date!.day == currentDate.day) {
          appointmentWidgetsToday.add(
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        AppointmentDetailScreen(appointment: appointment),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Card(
                  elevation: 2,
                  color: const Color(0xFFF2F5F9),
                  child: SizedBox(
                    width: 250,
                    height: 75,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              const Text(
                                "Treatment",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF696969),
                                ),
                              ),
                              Text(
                                "${appointment.date!.year}/${appointment.date!.month}/${appointment.date!.day} & ${appointment.date!.hour}:${appointment.date!.minute}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF696969),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            appointment.treatment.toString(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      }
    });
    super.initState();
  }

  Future<UserInfo> get GetUserInfo async {
    if (!isUserLoaded) {
      var response = await dio.get("$ServerIP/api/protected/user");
      String userName = response.data["data"]["username"].toString();
      int permission = response.data["data"]["permission"];

      userInfo.username = userName;
      userInfo.permission = permission;
      isUserLoaded = true;
    }
    setState(() {});
    return userInfo;
  }

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
              backgroundColor: const Color(0xFFF2F5F9),
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
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const LoginPage()));
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
                  "Dashboard",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.only(
                  top: 20.0,
                  left: 10,
                  right: 10,
                  bottom: 10,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: [
                          const Text(
                            "Good Morning, ",
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "Dr ${userInfo.username.split(' ')[0]}.",
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Card(
                        elevation: 5,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "Today's Appointments (${appointmentWidgetsToday.length})",
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        appointmentWidgetsToday.length
                                            .toString(),
                                        style: const TextStyle(
                                          fontSize: 64,
                                          fontFamily: "Iowan Old",
                                          fontWeight: FontWeight.w900,
                                          color: Color(0xFF696969),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 180,
                                      width: 300,
                                      child: ListView(
                                        shrinkWrap: true,
                                        children: appointmentWidgetsToday,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () {},
                                      child: Container(
                                        width: 130,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF2F5F9),
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: const <Widget>[
                                            Text(
                                              "More",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                            Icon(
                                              Icons.arrow_circle_right_rounded,
                                              size: 26,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Card(
                        elevation: 5,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: <Widget>[
                                const Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "Appointments This Month",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    currentMonthAppointments.length.toString(),
                                    style: const TextStyle(
                                      fontSize: 64,
                                      fontFamily: "Iowan Old",
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF696969),
                                    ),
                                  ),
                                ),
                                const Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "All Appointments",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    allAppointments.length.toString(),
                                    style: const TextStyle(
                                      fontSize: 64,
                                      fontFamily: "Iowan Old",
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF696969),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () {},
                                      child: Container(
                                        width: 130,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF2F5F9),
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: const <Widget>[
                                            Text(
                                              "More",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                            Icon(
                                              Icons.arrow_circle_right_rounded,
                                              size: 26,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // body:  Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Text("Welcome, ${userInfo.username}"),
              // ),
            );
          }
        });
  }
}
