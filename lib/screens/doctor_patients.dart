import 'package:clinic_management/components/app_bar.dart';
import 'package:clinic_management/dio_helper.dart';
import 'package:clinic_management/main.dart';
import 'package:clinic_management/models/patient.dart';
import 'package:clinic_management/screens/login_page.dart';
import 'package:clinic_management/screens/patient_details.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DoctorPatientScreen extends StatefulWidget {
  const DoctorPatientScreen({super.key, required this.openDrawer});
  final Function openDrawer;
  @override
  State<DoctorPatientScreen> createState() => _DoctorPatientScreenState();
}

class _DoctorPatientScreenState extends State<DoctorPatientScreen> {
  List<Patient> doctorPatients = [];
  bool isLoaded = false;
  @override
  void initState() {
    doctorPatients.clear();
    isLoaded = false;
    super.initState();
  }

  Future<String> loadPatients() async {
    if (!isLoaded) {
      var response = await getData("$ServerIP/api/protected/GetDoctorPatients");
      for (var obj in response) {
        Patient patient = Patient();
        patient.id = obj["ID"];
        patient.doctorID = obj["doctor_id"];
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
      backgroundColor: const Color(0xFFF2F5F9),
      appBar: CustomAppBar(
        title: "My Patients",
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () async {
                final bool response = await Logout;
                if (response) {
                  // ignore: use_build_context_synchronously
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const LoginPage()));
                }
              },
              icon: const Icon(
                Icons.logout_rounded,
                size: 30,
              ),
            ),
          ),
        ],
        leading: IconButton(
          onPressed: () {
            widget.openDrawer();
          },
          icon: const Icon(Icons.menu),
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
                                patientID: doctorPatients[index].id)));
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
