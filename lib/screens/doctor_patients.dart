import 'package:clinic_management/dio_helper.dart';
import 'package:clinic_management/main.dart';
import 'package:clinic_management/models/patient.dart';
import 'package:clinic_management/screens/patient_details.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DoctorPatientScreen extends StatefulWidget {
  const DoctorPatientScreen({super.key});

  @override
  State<DoctorPatientScreen> createState() => _DoctorPatientScreenState();
}

class _DoctorPatientScreenState extends State<DoctorPatientScreen> {
  List<Patient> doctorPatients = [];
  bool isLoaded = false;
  @override
  void initState() {
    isLoaded = false;
    super.initState();
  }

  Future<String> loadPatients() async {
    if (!isLoaded) {
      var response = await getData("$ServerIP/api/protected/GetDoctorPatients");
      for (var obj in response) {
        Patient patient = Patient();
        patient.id = obj["ID"];
        patient.name = obj["name"];
        patient.address = obj["address"];
        patient.phone = obj["phone"];
        patient.gender = obj["gender"];
        patient.age = obj["age"];
        doctorPatients.add(patient);
      }
      isLoaded = true;
    }

    // setState(() {});
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF011627),
        title: const Text(
          "My Patients",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder(
          future: loadPatients(),
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
            return ListView.builder(
              itemCount: doctorPatients.length,
              itemBuilder: (context, index) {
                return TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => PatientDetailScreen(
                                patient: doctorPatients[index])));
                  },
                  child: ListTile(
                    title: Text(doctorPatients[index].name),
                  ),
                );
              },
            );
          }),
    );
  }
}
