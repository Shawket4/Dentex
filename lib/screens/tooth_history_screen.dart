import 'dart:typed_data';

import 'package:dentex/components/app_bar.dart';
import 'package:dentex/components/image_manipulation.dart';
import 'package:dentex/dio_helper.dart';
import 'package:dentex/main.dart';
import 'package:dentex/models/appointment.dart';
import 'package:dentex/models/patient.dart';
import 'package:dentex/screens/appointment_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart' as intl;

class ToothHistoryScreen extends StatefulWidget {
  const ToothHistoryScreen({
    super.key,
    required this.tooth,
    required this.scale,
    required this.patient,
  });
  final Tooth tooth;
  final double? scale;
  final Patient patient;
  @override
  State<ToothHistoryScreen> createState() => _ToothHistoryScreenState();
}

class _ToothHistoryScreenState extends State<ToothHistoryScreen> {
  List<Appointment> toothAppointments = [];
  bool isLoaded = false;
  List<Uint8List> imagesBytes = [];
  Future<String> get loadData async {
    if (!isLoaded) {
      var response = await postData("$ServerIP/api/protected/GetToothHistory", {
        "tooth_id": widget.tooth.id,
      });
      if (response["tooth_history"] != null) {
        for (var obj in response["tooth_history"]) {
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
          final imageBytes = await returnColoredTooth(
              "assets/images/teeth/${widget.tooth.toothCode[1]}${int.parse(widget.tooth.toothCode[2])}${appointment.condition.name != "None" ? "_Colored" : ""}.png",
              appointment.condition.color!);
          imagesBytes.add(imageBytes);
          toothAppointments.add(appointment);
        }
      }
      isLoaded = true;
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9),
      appBar: CustomAppBar(
        title: "${widget.tooth.toothCode}: ${widget.patient.name}",
        actions: null,
      ),
      body: FutureBuilder(
        future: loadData,
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
          return toothAppointments.isEmpty
              ? const Center(
                  child: Opacity(
                    opacity: 0.5,
                    child: Text(
                      "No History Exists",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                    ),
                  ),
                )
              : Column(
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    Center(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ...List.generate(toothAppointments.length, (index) {
                              return Padding(
                                padding: const EdgeInsets.all(6),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => AppointmentDetailScreen(
                                          appointment: toothAppointments[index],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    child: SizedBox(
                                      width: 300,
                                      height: 300,
                                      child: Image.memory(
                                        imagesBytes[index],
                                        scale: widget.scale! / 4,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
