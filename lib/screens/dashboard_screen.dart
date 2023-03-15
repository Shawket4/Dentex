// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, unused_import

import 'package:dentex/components/app_bar.dart';
import 'package:dentex/components/bottom_nav_bar.dart';
import 'package:dentex/components/drawer.dart';
import 'package:dentex/dio_helper.dart';
import 'package:dentex/models/appointment.dart';
import 'package:dentex/models/user.dart';
import 'package:dentex/screens/all_appointments.dart';
import 'package:dentex/screens/appointment_details_screen.dart';
import 'package:dentex/screens/patient_details.dart';
import 'package:flutter/material.dart';
import 'package:dentex/screens/login_screen.dart';
import 'package:dentex/main.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart' as intl;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key, required this.openDrawer}) : super(key: key);
  final Function openDrawer;
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

bool isUserLoaded = false;

class _DashboardScreenState extends State<DashboardScreen> {
  List<Appointment> allAppointments = [];
  List<Appointment> currentMonthAppointments = [];
  List<Widget> appointmentWidgetsToday = [];
  double? earningsLast7Days;
  double? earningsThisMonth;

  @override
  void initState() {
    isUserLoaded = false;
    super.initState();
  }

  Future<User> get GetDoctorSummary async {
    if (!isUserLoaded) {
      DateTime currentDate = DateTime.now();
      isUserLoaded = true;
      var response = await getData("$ServerIP/api/protected/GetDoctorSchedule");
      if (userInfo.permission == 2) {
        return userInfo;
      }
      for (var obj in response["schedule"]["time_blocks"]) {
        obj = obj["appointment"];
        Appointment appointment = Appointment();
        appointment.id = obj["ID"];
        appointment.date =
            intl.DateFormat("yyyy/MM/dd & h:mm a").parse(obj["date"]);
        appointment.patientID = obj["patient_id"];
        appointment.toothID = obj["tooth_id"];
        appointment.patientName = obj["patient_name"];
        appointment.toothCode = obj["tooth_code"];
        appointment.condition.name = obj["treatment"];
        appointment.condition.color = obj["hex_color"] == ""
            ? Colors.white
            : HexColor.fromHex(obj["hex_color"]);
        appointment.price = double.parse(obj["price"].toString());
        appointment.isPaid = obj["is_paid"];
        appointment.isCompleted = obj["is_completed"];
        allAppointments.add(appointment);

        if (appointment.date!.year == currentDate.year &&
            appointment.date!.month == currentDate.month) {
          currentMonthAppointments.add(appointment);
        }
      }
      response = await getData("$ServerIP/api/protected/GetDoctorEarnings");
      earningsLast7Days =
          double.parse(response["earnings_last_7_days"].toString());
      earningsThisMonth =
          double.parse(response["earnings_this_month"].toString());
      allAppointments.sort(
        (a, b) => b.date!.compareTo(a.date!),
      );
      for (var appointment in allAppointments) {
        if (appointment.date!.year == currentDate.year &&
            appointment.date!.month == currentDate.month &&
            appointment.date!.day == currentDate.day &&
            !appointment.isCompleted!) {
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
                    // width: MediaQuery.of(context).size.width / 3,
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
                                intl.DateFormat("yyyy/MM/dd & h:mm a")
                                    .format(appointment.date!),
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
                            appointment.condition.name.toString(),
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
      setState(() {});
    }
    return userInfo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9),
      appBar: CustomAppBar(
        title: "Dashboard",
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () async {
                final bool response = await Logout;
                if (response) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const LoginPage()));
                }
              },
              icon: const Icon(
                Icons.logout_rounded,
                size: 30,
              ),
            ),
          ),
        ],
        leading: IconButton(
          onPressed: () {
            widget.openDrawer();
          },
          icon: const Icon(Icons.menu),
        ),
      ),
      body: FutureBuilder(
          future: GetDoctorSummary,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Lottie.asset(
                  "assets/lottie/Loading.json",
                  height: 200,
                  width: 200,
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.only(
                top: 20.0,
                left: 10,
                right: 10,
                bottom: 10,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
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
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    appointmentWidgetsToday.length.toString(),
                                    style: const TextStyle(
                                      fontSize: 64,
                                      fontFamily: "Iowan Old",
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF696969),
                                    ),
                                  ),
                                  const Spacer(),
                                  // const SizedBox(
                                  //   width: 40,
                                  // ),
                                  SizedBox(
                                    height: 180,
                                    width:
                                        MediaQuery.of(context).size.width / 1.4,
                                    child: ListView(
                                      shrinkWrap: true,
                                      children: appointmentWidgetsToday,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => AllAppointments(
                                            allAppointments: allAppointments,
                                          ),
                                        ),
                                      );
                                    },
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
                                  "Earnings Last 7 Days",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "LE $earningsLast7Days",
                                  style: const TextStyle(
                                    fontSize: 35,
                                    fontFamily: "Iowan Old",
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF696969),
                                  ),
                                ),
                              ),
                              const Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Earnings This Month",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "LE $earningsThisMonth",
                                  style: const TextStyle(
                                    fontSize: 35,
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
            );
          }),
      // body:  Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: Text("Welcome, ${userInfo.username}"),
      // ),
    );
  }
}
