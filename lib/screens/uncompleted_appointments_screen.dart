import 'dart:typed_data';

import 'package:dentex/components/app_bar.dart';
import 'package:dentex/components/image_manipulation.dart';
import 'package:dentex/models/patient.dart';
import 'package:dentex/screens/appointment_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class UncompletedAppointmentScreen extends StatefulWidget {
  const UncompletedAppointmentScreen({
    super.key,
    required this.tooth,
    required this.scale,
    required this.patient,
    required this.conditions,
  });
  final Tooth tooth;
  final double? scale;
  final Patient patient;
  final List<Condition> conditions;
  @override
  State<UncompletedAppointmentScreen> createState() =>
      _UncompletedAppointmentScreenState();
}

class _UncompletedAppointmentScreenState
    extends State<UncompletedAppointmentScreen> {
  bool isLoaded = false;
  List<Uint8List> imagesBytes = [];
  Future<String> get loadData async {
    if (!isLoaded) {
      for (var appointment in widget.tooth.uncompletedAppointments) {
        final imageBytes = await returnColoredTooth(
            "assets/images/teeth/${widget.tooth.toothCode[1]}${int.parse(widget.tooth.toothCode[2])}${appointment.condition.name != "None" ? "_Colored" : ""}.png",
            appointment.condition.color!);
        imagesBytes.add(imageBytes);
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
          return Column(
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
                      ...List.generate(
                          widget.tooth.uncompletedAppointments.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.all(10),
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AppointmentDetailScreen(
                                    appointment: widget
                                        .tooth.uncompletedAppointments[index],
                                    conditions: widget.conditions,
                                  ),
                                ),
                              );
                            },
                            child: Image.memory(
                              imagesBytes[index],
                              scale: widget.scale!,
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
