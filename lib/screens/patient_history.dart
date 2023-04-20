import 'package:dentex/components/app_bar.dart';
import 'package:dentex/models/appointment.dart';
import 'package:dentex/models/patient.dart';
import 'package:dentex/screens/appointment_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart' as intl;

class PatientHistoryScreen extends StatefulWidget {
  const PatientHistoryScreen(
      {super.key, required this.allAppointments, required this.conditions});
  final List<Appointment> allAppointments;
  final List<Condition> conditions;
  @override
  State<PatientHistoryScreen> createState() => _PatientHistoryScreenState();
}

class _PatientHistoryScreenState extends State<PatientHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF2F5F9),
        appBar: const CustomAppBar(
          title: "All Appointments",
          actions: null,
        ),
        body: widget.allAppointments.isEmpty
            ? const Center(
                child: Opacity(
                  opacity: 0.5,
                  child: Text(
                    "No Appointments Exist",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                  ),
                ),
              )
            : GroupedListView<Appointment, String>(
                elements: widget.allAppointments,
                groupBy: (element) => element.isCompleted.toString(),
                groupSeparatorBuilder: (value) => Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: Colors.black,
                  child: Text(
                    value == "false" ? "Uncompleted" : "Completed",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                itemBuilder: (context, element) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AppointmentDetailScreen(
                            appointment: element,
                            conditions: widget.conditions,
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
                          // width: MediaQuery.of(context).size.width / 3,
                          height: 75,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                      intl.DateFormat("yyyy/MM/dd & h:mm a")
                                          .format(element.date!),
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
                                  element.condition.name.toString(),
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
                  );
                },
              )
        // : SingleChildScrollView(
        //     child: Column(
        //       children: [
        //         const SizedBox(
        //           height: 10,
        //         ),
        //         ...List.generate(
        //           widget.allAppointments.length,
        //           (index) => GestureDetector(
        //             onTap: () {
        //               Navigator.push(
        //                 context,
        //                 MaterialPageRoute(
        //                   builder: (_) => AppointmentDetailScreen(
        //                       appointment: widget.allAppointments[index]),
        //                 ),
        //               );
        //             },
        //             child: Padding(
        //               padding: const EdgeInsets.all(5.0),
        //               child: Card(
        //                 elevation: 2,
        //                 color: const Color(0xFFF2F5F9),
        //                 child: SizedBox(
        //                   // width: MediaQuery.of(context).size.width / 3,
        //                   height: 75,
        //                   child: Padding(
        //                     padding: const EdgeInsets.all(8.0),
        //                     child: Column(
        //                       crossAxisAlignment: CrossAxisAlignment.start,
        //                       children: <Widget>[
        //                         Row(
        //                           mainAxisAlignment:
        //                               MainAxisAlignment.spaceBetween,
        //                           children: <Widget>[
        //                             const Text(
        //                               "Treatment",
        //                               style: TextStyle(
        //                                 fontSize: 14,
        //                                 fontWeight: FontWeight.w600,
        //                                 color: Color(0xFF696969),
        //                               ),
        //                             ),
        //                             Text(
        //                               intl.DateFormat("yyyy/MM/dd & h:mm a")
        //                                   .format(widget
        //                                       .allAppointments[index].date!),
        //                               style: const TextStyle(
        //                                 fontSize: 12,
        //                                 fontWeight: FontWeight.w600,
        //                                 color: Color(0xFF696969),
        //                               ),
        //                             ),
        //                           ],
        //                         ),
        //                         const SizedBox(
        //                           height: 5,
        //                         ),
        //                         Text(
        //                           widget.allAppointments[index].treatment
        //                               .toString(),
        //                           style: const TextStyle(
        //                             fontSize: 18,
        //                             fontWeight: FontWeight.w700,
        //                           ),
        //                         ),
        //                       ],
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        );
  }
}
