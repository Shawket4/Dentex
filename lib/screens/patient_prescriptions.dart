import 'package:dentex/add_screens/add_prescription.dart';
import 'package:dentex/components/app_bar.dart';
import 'package:dentex/dio_helper.dart';
import 'package:dentex/main.dart';
import 'package:dentex/models/patient.dart';
import 'package:dentex/models/prescription.dart';
import 'package:dentex/screens/pdf_preview.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PatientPrescriptionScreen extends StatefulWidget {
  const PatientPrescriptionScreen({super.key, required this.patient});
  final Patient patient;
  @override
  State<PatientPrescriptionScreen> createState() =>
      _PatientPrescriptionScreenState();
}

class _PatientPrescriptionScreenState extends State<PatientPrescriptionScreen> {
  bool isLoaded = false;
  @override
  void initState() {
    isLoaded = false;
    super.initState();
  }

  List<Prescription> patientPrescriptions = [];
  Future get loadPatientPrescriptions async {
    if (!isLoaded) {
      var response =
          await postData("$ServerIP/api/protected/GetPatientPrescriptions", {
        "patient_id": widget.patient.id,
      });
      for (var obj in response) {
        Prescription prescription = Prescription().fromJSON(obj);
        patientPrescriptions.add(prescription);
      }
      isLoaded = true;
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "${widget.patient.name.split(" ").first}'s: Prescriptions",
        actions: null,
      ),
      body: FutureBuilder(
        future: loadPatientPrescriptions,
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
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                ...List.generate(
                  patientPrescriptions.length,
                  (index) => Card(
                    elevation: 8.0,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 4.0,
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PDFPreviewScreen(
                              prescription: patientPrescriptions[index],
                              patient: widget.patient,
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 5.0,
                        ),
                        title: Text(
                          "${patientPrescriptions[index].prescriptionItems.items[0].name}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        subtitle: Text("${patientPrescriptions[index].date}"),
                        trailing: Icon(
                          Icons.keyboard_arrow_right_rounded,
                          color: Theme.of(context).primaryColor,
                          size: 40.0,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 10.0,
                  ),
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                AddPrescriptionScreen(patient: widget.patient),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              "Add Prescription",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(Icons.add_circle_rounded),
                          ],
                        ),
                      )),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
