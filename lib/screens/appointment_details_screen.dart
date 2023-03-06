// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:clinic_management/dio_helper.dart';
import 'package:clinic_management/main.dart';
import 'package:clinic_management/models/appointment.dart';
import 'package:clinic_management/screens/home_screen.dart';
import 'package:clinic_management/screens/patient_details.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AppointmentDetailScreen extends StatefulWidget {
  final Appointment appointment;
  const AppointmentDetailScreen({super.key, required this.appointment});

  @override
  State<AppointmentDetailScreen> createState() =>
      _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF011627),
        title: Text(
          "${widget.appointment.treatment} Appointment",
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
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
                "Case: ${widget.appointment.treatment}",
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
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                widget.appointment.isPaid! ? "Paid: Yes" : "Paid: No",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
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
            TextButton(
              onPressed: () {
                postData(
                    "$ServerIP/api/protected/ChangeAppointmentPaymentStatus", {
                  "appointment_id": widget.appointment.id,
                  "payment_status": !widget.appointment.isPaid!,
                }).then((value) => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const HomeScreen())));
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
                      widget.appointment.isPaid!
                          ? "Unmark As Paid"
                          : "Mark As Paid",
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
