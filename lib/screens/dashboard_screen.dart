// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, unused_import

import 'dart:convert';

import 'package:dentex/components/app_bar.dart';
import 'package:dentex/components/bottom_nav_bar.dart';
import 'package:dentex/components/drawer.dart';
import 'package:dentex/dio_helper.dart';
import 'package:dentex/models/appointment.dart';
import 'package:dentex/models/patient.dart';
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
  List<Condition> conditions = [];
  double? earningsLast7Days;
  double? earningsThisMonth;
  String? text;
  @override
  void initState() {
    isUserLoaded = false;
    DateTime currentDateTime = DateTime.now();
    if (currentDateTime.hour < 12) {
      text = "Morning";
    } else if (currentDateTime.hour < 18) {
      text = "Afternoon";
    } else {
      text = "Evening";
    }
    super.initState();
  }

  Future<User> get GetDoctorSummary async {
    if (!isUserLoaded) {
      DateTime currentDate = DateTime.now();
      isUserLoaded = true;
      dynamic response;
      dynamic earningsResponse;
      dynamic treatmentsResponse;
      if (userInfo.permission == 2) {
        return userInfo;
      }
      bool isOnline = await isConnected();
      if (isOnline) {
        response =
            await getData("$ServerIP/api/protected/GetDoctorSchedule", context);
        await SetJSON(response, "DoctorSchedule");

        earningsResponse =
            await getData("$ServerIP/api/protected/GetDoctorEarnings", context);
        treatmentsResponse = await getData(
            "$ServerIP/api/protected/GetDoctorTreatments", context);
        await SetJSON(treatmentsResponse, "Treatments");
        await SetJSON(earningsResponse, "Earnings");
      } else {
        response = await GetJSON("DoctorSchedule");
        response = json.decode(response);
        earningsResponse = await GetJSON("Earnings");
        earningsResponse = json.decode(earningsResponse);
        treatmentsResponse = await GetJSON("Treatments");
        treatmentsResponse = json.decode(treatmentsResponse);
      }
      for (var obj in treatmentsResponse) {
        Condition condition = Condition();
        condition.id = obj["ID"];
        condition.name = obj["name"];
        condition.price = double.parse(obj["price"].toString());
        condition.color = obj["hex_color"] == ""
            ? Colors.white
            : HexColor.fromHex(obj["hex_color"]);
        conditions.add(condition);
      }
      earningsLast7Days =
          double.parse(earningsResponse["earnings_last_7_days"].toString());
      earningsThisMonth =
          double.parse(earningsResponse["earnings_this_month"].toString());
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
        appointment.condition.id = obj["condition_id"];
        appointment.condition.color = obj["hex_color"] == ""
            ? Colors.white
            : HexColor.fromHex(obj["hex_color"]);
        appointment.price = double.parse(obj["price"].toString());
        appointment.isPaid = obj["is_paid"];
        appointment.isCompleted = obj["is_completed"];
        appointment.notes = obj["notes"];
        appointment.patient.id = obj["patient"]["ID"];
        appointment.patient.doctorID = obj["patient"]["doctor_id"];
        appointment.patient.name = obj["patient"]["name"];
        appointment.patient.address = obj["patient"]["address"];
        appointment.patient.phone = obj["patient"]["phone"];
        appointment.patient.gender = obj["patient"]["gender"];
        appointment.patient.age = obj["patient"]["age"];
        appointment.patient.isFavourite = obj["patient"]["is_favourite"];
        List<dynamic> teeth = obj["patient"]["patient_teeth_map"]["teeth"];
        teeth.sort((a, b) => a["tooth_code"].compareTo(b["tooth_code"]));
        conditions
            .add(Condition(name: "None", price: 0.0, color: Colors.white));
        for (var objTooth in teeth) {
          Tooth tooth = Tooth();
          tooth.id = objTooth["ID"];
          tooth.toothCode = objTooth["tooth_code"];
          tooth.condition.name = objTooth["condition"];
          tooth.condition.id = objTooth["condition_id"];
          if (tooth.condition.id != 0) {
            tooth.condition.price = conditions
                .firstWhere((element) => element.id == tooth.condition.id)
                .price;
          }

          tooth.condition.color = objTooth["hex_color"] == ""
              ? Colors.white
              : HexColor.fromHex(objTooth["hex_color"]);
          if (objTooth["uncompleted_appointments"] != null) {
            for (var appointmentJSON in objTooth["uncompleted_appointments"]) {
              Appointment appointment = Appointment();
              appointment.id = appointmentJSON["ID"];
              appointment.date = intl.DateFormat("yyyy/MM/dd & h:mm a")
                  .parse(appointmentJSON["date"]);
              appointment.patientID = appointmentJSON["patient"]["id"];
              appointment.patientName = appointmentJSON["patient"]["name"];
              appointment.price =
                  double.parse(appointmentJSON["price"].toString());
              appointment.condition.color = appointmentJSON["hex_color"] == ""
                  ? Colors.white
                  : HexColor.fromHex(appointmentJSON["hex_color"]);
              appointment.isCompleted = false;
              appointment.isPaid = appointmentJSON["is_paid"];
              appointment.toothID = appointmentJSON["tooth_id"];
              appointment.toothCode = appointmentJSON["tooth_code"];
              appointment.condition.name = appointmentJSON["treatment"];
              appointment.condition.id = appointmentJSON["ID"];
              tooth.uncompletedAppointments.add(appointment);
            }
            tooth.condition.color = Colors.grey[600];
          }
          tooth.isTreated = objTooth["is_treated"];
          appointment.patient.teethMap.teeth.add(tooth);
        }

        allAppointments.add(appointment);

        if (appointment.date!.year == currentDate.year &&
            appointment.date!.month == currentDate.month) {
          currentMonthAppointments.add(appointment);
        }
      }
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
                    builder: (_) => AppointmentDetailScreen(
                      appointment: appointment,
                      conditions: conditions,
                    ),
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
                final bool response = await Logout(context);
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
                          Text(
                            "Good $text, ",
                            style: const TextStyle(
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
                                            conditions: conditions,
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
