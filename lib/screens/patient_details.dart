import 'package:clinic_management/dio_helper.dart';
import 'package:clinic_management/main.dart';
import 'package:clinic_management/models/patient.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PatientDetailScreen extends StatefulWidget {
  const PatientDetailScreen({super.key, required this.patient});
  final Patient patient;
  @override
  State<PatientDetailScreen> createState() => _PatientDetailScreenState();
}

class _PatientDetailScreenState extends State<PatientDetailScreen> {
  List<Tooth> teethMap = [];
  bool isMapLoaded = false;
  @override
  void initState() {
    isMapLoaded = false;
    super.initState();
  }

  Future<String> loadTeethMap() async {
    if (!isMapLoaded) {
      var response =
          await postData("$ServerIP/api/protected/GetPatientTeethMap", {
        "patient_id": widget.patient.id,
      });
      print(response);
      for (var obj in response["teeth"]) {
        Tooth tooth = Tooth();
        tooth.id = obj["ID"];
        tooth.toothCode = obj["tooth_code"];
        tooth.condition = obj["condition"];
        tooth.isTreated = obj["is_treated"];
        teethMap.add(tooth);
      }
      isMapLoaded = true;
      setState(() {});
    }
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
        future: loadTeethMap(),
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
            itemCount: teethMap.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                    "Code: ${teethMap[index].toothCode}, Condition: ${teethMap[index].condition}, Treated: ${teethMap[index].isTreated}"),
              );
            },
          );
        },
      ),
    );
  }
}

class Tooth {
  int id = 0;
  String toothCode = "";
  String condition = "";
  bool isTreated = false;
}
