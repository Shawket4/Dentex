import 'package:dentex/dio_helper.dart';
import 'package:dentex/main.dart';
import 'package:dentex/models/appointment.dart';
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
        appointment.condition.name = obj["treatment"];
        appointment.condition.color = HexColor.fromHex(obj["hex_color"]);
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
