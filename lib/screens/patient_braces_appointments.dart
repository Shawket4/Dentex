// // ignore_for_file: use_build_context_synchronously

// import 'package:dentex/components/app_bar.dart';
// import 'package:dentex/models/appointment.dart';
// import 'package:dentex/models/patient.dart';
// import 'package:dentex/screens/appointment_details_screen.dart';
// import 'package:dentex/screens/make_appointment.dart';
// import 'package:flutter/material.dart';
// import 'package:grouped_list/grouped_list.dart';
// import 'package:intl/intl.dart' as intl;

// class BraceScreen extends StatefulWidget {
//   const BraceScreen({super.key, required this.patient});
//   final Patient patient;
//   @override
//   State<BraceScreen> createState() => _BraceScreenState();
// }

// class _BraceScreenState extends State<BraceScreen> {
//   Future loadData() async {}
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const CustomAppBar(title: "Braces", actions: null),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             GroupedListView<Appointment, String>(
//               shrinkWrap: true,
//               elements: widget.patient.braces.appointments,
//               groupBy: (element) => element.isCompleted.toString(),
//               groupSeparatorBuilder: (value) => Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(16),
//                 color: Colors.black,
//                 child: Text(
//                   value == "false" ? "Uncompleted" : "Completed",
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               itemBuilder: (context, element) {
//                 return GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) =>
//                             AppointmentDetailScreen(appointment: element),
//                       ),
//                     );
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.all(5.0),
//                     child: Card(
//                       elevation: 2,
//                       color: const Color(0xFFF2F5F9),
//                       child: SizedBox(
//                         // width: MediaQuery.of(context).size.width / 3,
//                         height: 75,
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: <Widget>[
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: <Widget>[
//                                   const Text(
//                                     "Treatment",
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w600,
//                                       color: Color(0xFF696969),
//                                     ),
//                                   ),
//                                   Text(
//                                     intl.DateFormat("yyyy/MM/dd & h:mm a")
//                                         .format(element.date!),
//                                     style: const TextStyle(
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.w600,
//                                       color: Color(0xFF696969),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(
//                                 height: 5,
//                               ),
//                               Text(
//                                 element.condition.name.toString(),
//                                 style: const TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.w700,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//             Align(
//               alignment: Alignment.centerLeft,
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => MakeAppointmentScreen(
//                           tooth: Tooth(),
//                           patient: widget.patient,
//                           isBraces: true,
//                         ),
//                       ),
//                     );
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 12.0),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: const [
//                         Text(
//                           "Add Appointment",
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         SizedBox(
//                           width: 5.0,
//                         ),
//                         Icon(
//                           Icons.add_circle,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
