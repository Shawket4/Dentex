// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:dentex/components/app_bar.dart';
import 'package:dentex/dio_helper.dart';
import 'package:dentex/edit_screens/edit_appointment.dart';
import 'package:dentex/main.dart';
import 'package:dentex/models/appointment.dart';
import 'package:dentex/screens/home_screen.dart';
import 'package:dentex/screens/patient_details.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart' as intl;

class AppointmentDetailScreen extends StatefulWidget {
  final Appointment appointment;
  const AppointmentDetailScreen({super.key, required this.appointment});

  @override
  State<AppointmentDetailScreen> createState() =>
      _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {
  late BuildContext dialogContext;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "${widget.appointment.condition.name}",
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      EditAppointmentScreen(appointment: widget.appointment),
                ),
              );
            },
            child: Icon(
              Icons.edit_document,
            ),
          ),
          GestureDetector(
            onTap: () async {
              try {
                await postData("$ServerIP/api/protected/DeleteAppointment", {
                  "id": widget.appointment.id,
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HomeScreen(),
                  ),
                );
              } catch (e) {
                dialogContext = context;
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
                            mainAxisAlignment: MainAxisAlignment.center,
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
                    });
              }
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              height: 40,
              width: 40,
              child: const Icon(
                Icons.delete,
                size: 30,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF2F5F9),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Center(
                // Display lottie animation
                child: Lottie.asset(
                  "assets/lottie/AppointmentOnGoing.json",
                  height: 380,
                  width: double.infinity,
                ),
              ),
            ),
            const Center(
              child: Text(
                "Details",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PatientDetailScreen(
                      patientID: widget.appointment.patientID!,
                    ),
                  ),
                );
              },
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      "Patient: ${widget.appointment.patientName}",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Icon(Icons.arrow_circle_right_rounded),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                "Date: ${intl.DateFormat("yyyy/MM/dd & h:mm a").format(widget.appointment.date!)}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                "Case: ${widget.appointment.condition.name}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                "Tooth: ${widget.appointment.toothCode}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                "Cost: ${widget.appointment.price}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(12.0),
            //   child: Text(
            //     widget.appointment.isPaid! ? "Paid: Yes" : "Paid: No",
            //     style: const TextStyle(
            //       fontSize: 22,
            //       fontWeight: FontWeight.w600,
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                widget.appointment.isCompleted!
                    ? "Completed: Yes"
                    : "Completed: No",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            // TextButton(
            //   onPressed: () {
            //     postData(
            //         "$ServerIP/api/protected/ChangeAppointmentPaymentStatus", {
            //       "appointment_id": widget.appointment.id,
            //       "payment_status": !widget.appointment.isPaid!,
            //     }).then((value) => Navigator.pushReplacement(context,
            //         MaterialPageRoute(builder: (_) => const HomeScreen())));
            //   },
            //   child: Container(
            //     decoration: BoxDecoration(
            //       color: Theme.of(context).primaryColor,
            //       borderRadius: BorderRadius.circular(6.0),
            //     ),
            //     height: 50,
            //     child: Center(
            //       child: Padding(
            //         padding: const EdgeInsets.all(10.0),
            //         child: Text(
            //           widget.appointment.isPaid!
            //               ? "Unmark As Paid"
            //               : "Mark As Paid",
            //           style: const TextStyle(
            //             fontFamily: "Calibri",
            //             color: Colors.white,
            //             fontSize: 20,
            //             fontWeight: FontWeight.w600,
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            TextButton(
              onPressed: () {
                postData(
                    "$ServerIP/api/protected/ChangeAppointmentCompletionStatus",
                    {
                      "appointment_id": widget.appointment.id,
                      "completion_status": !widget.appointment.isCompleted!,
                    }).then((value) => Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => HomeScreen())));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(6.0),
                ),
                height: 50,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      widget.appointment.isCompleted!
                          ? "Unmark As Completed"
                          : "Mark As Completed",
                      style: const TextStyle(
                        fontFamily: "Calibri",
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
