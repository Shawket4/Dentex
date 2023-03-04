import 'package:clinic_management/dio_helper.dart';
import 'package:clinic_management/main.dart';
import 'package:clinic_management/models/appointment.dart';
import 'package:flutter/material.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  List<Appointment> appointments = [];
  @override
  void initState() {
    getData("$ServerIP/api/protected/GetDoctorAppointments").then((response) {
      for (var obj in response) {
        Appointment appointment = Appointment();
        appointment.id = obj["ID"];
        appointment.date = DateTime.parse(obj["date"]);
        appointment.patientName = obj["patient_name"];
        appointment.treatment = obj["treatment"];
        appointment.price = obj["price"];
        appointment.isPaid = obj["paid"];
        appointments.add(appointment);
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF011627),
        title: const Text(
          "Appointments",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
