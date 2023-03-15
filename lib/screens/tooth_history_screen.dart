import 'package:dentex/components/app_bar.dart';
import 'package:dentex/dio_helper.dart';
import 'package:dentex/main.dart';
import 'package:dentex/models/appointment.dart';
import 'package:dentex/models/patient.dart';
import 'package:dentex/screens/appointment_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart' as intl;

class ToothHistoryScreen extends StatefulWidget {
  const ToothHistoryScreen(
      {super.key,
      required this.tooth,
      required this.scale,
      required this.patient});
  final Tooth tooth;
  final double? scale;
  final Patient patient;
  @override
  State<ToothHistoryScreen> createState() => _ToothHistoryScreenState();
}

class _ToothHistoryScreenState extends State<ToothHistoryScreen> {
  List<Appointment> toothAppointments = [];
  bool isLoaded = false;
  Future<String> get loadData async {
    if (!isLoaded) {
      var response = await postData("$ServerIP/api/protected/GetToothHistory", {
        "tooth_id": widget.tooth.id,
      });

      for (var obj in response["ToothHistory"]) {
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
        toothAppointments.add(appointment);
      }
      isLoaded = true;
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFFF2F5F9),
      backgroundColor: Colors.white,
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
              // : Column(
              //     children: [
              //       const SizedBox(
              //         height: 50,
              //       ),
              //       SingleChildScrollView(
              //         scrollDirection: Axis.horizontal,
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             ...List.generate(toothAppointments.length, (index) {
              //               return Padding(
              //                 padding: const EdgeInsets.all(20),
              //                 child: toothWidget(
              //                   () => Navigator.push(
              //                     context,
              //                     MaterialPageRoute(
              //                       builder: (_) => AppointmentDetailScreen(
              //                         appointment: toothAppointments[index],
              //                       ),
              //                     ),
              //                   ),
              //                   widget.tooth,
              //                   toothAppointments[index],
              //                   widget.scale,
              //                 ),
              //               );
              //             }),
              //           ],
              //         ),
              //       ),
              //     ],
              //   );
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      ...List.generate(
                        toothAppointments.length,
                        (index) => GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AppointmentDetailScreen(
                                  appointment: toothAppointments[index],
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Card(
                              elevation: 2,
                              color: const Color(0xFFF2F5F9),
                              child: SizedBox(
                                height: 75,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                                            intl.DateFormat(
                                                    "yyyy/MM/dd & h:mm a")
                                                .format(toothAppointments[index]
                                                    .date!),
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
                                        toothAppointments[index]
                                            .condition
                                            .name
                                            .toString(),
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
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
