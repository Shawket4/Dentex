// ignore_for_file: use_build_context_synchronously

import 'package:clinic_management/dio_helper.dart';
import 'package:clinic_management/main.dart';
import 'package:clinic_management/models/patient.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PatientDetailScreen extends StatefulWidget {
  const PatientDetailScreen({super.key, required this.patient});
  final Patient patient;
  @override
  State<PatientDetailScreen> createState() => _PatientDetailScreenState();
}

class _PatientDetailScreenState extends State<PatientDetailScreen> {
  TeethMap teethMap = TeethMap();
  List<Widget> teethTop = [];
  List<Widget> teethBottom = [];
  List<String> conditions = ["None", "Carries", "Open Access"];

  bool isMapLoaded = false;
  @override
  void initState() {
    isMapLoaded = false;
    super.initState();
  }

  void reloadTeethMap() {
    teethBottom = [];
    teethTop = [];
    for (var tooth in teethMap.teeth) {
      if (tooth.toothCode[1] == "B") {
        teethBottom.add(
          GestureDetector(
            onTap: () {
              showTeethDialog(tooth);
            },
            child: Column(
              children: [
                SizedBox(
                    height: 30,
                    width: 30,
                    child: Image.asset("assets/images/teeth/LB1_Bottom.png")),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  tooth.toothCode,
                  style: TextStyle(
                    color: tooth.condition == "None" ? null : Colors.red,
                  ),
                ),
              ],
            ),
          ),
        );
      }
      if (tooth.toothCode[1] == "T") {
        teethTop.add(
          GestureDetector(
            onTap: () {
              showTeethDialog(tooth);
            },
            child: Column(
              children: [
                SizedBox(
                    height: 30,
                    width: 30,
                    child: Image.asset("assets/images/teeth/LB1_Top.png")),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  tooth.toothCode,
                  style: TextStyle(
                    color: tooth.condition == "None" ? null : Colors.red,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }
    setState(() {});
  }

  Future<String> loadTeethMap() async {
    if (!isMapLoaded) {
      var response =
          await postData("$ServerIP/api/protected/GetPatientTeethMap", {
        "patient_id": widget.patient.id,
      });

      for (var obj in response["teeth"]) {
        Tooth tooth = Tooth();
        tooth.id = obj["ID"];
        tooth.toothCode = obj["tooth_code"];
        tooth.condition = obj["condition"];
        tooth.isTreated = obj["is_treated"];
        teethMap.teeth.add(tooth);
        if (tooth.toothCode[1] == "B") {
          teethBottom.add(
            GestureDetector(
              onTap: () {
                showTeethDialog(tooth);
              },
              child: Column(
                children: [
                  SizedBox(
                      height: 30,
                      width: 30,
                      child: Image.asset("assets/images/teeth/LB1_Bottom.png")),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    tooth.toothCode,
                    style: TextStyle(
                      color: tooth.condition == "None" ? null : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        if (tooth.toothCode[1] == "T") {
          teethTop.add(
            GestureDetector(
              onTap: () {
                showTeethDialog(tooth);
              },
              child: Column(
                children: [
                  SizedBox(
                      height: 30,
                      width: 30,
                      child: Image.asset("assets/images/teeth/LB1_Top.png")),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    tooth.toothCode,
                    style: TextStyle(
                      color: tooth.condition == "None" ? null : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      }
      isMapLoaded = true;
      setState(() {});
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF011627),
        title: Text(
          "Patient: ${widget.patient.name.split(" ").first}",
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
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
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: teethTop,
                    ),
                  ),
                  const SizedBox(height: 50),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: teethBottom,
                    ),
                  ),
                  const SizedBox(height: 60),
                  Text(
                    "Patient: ${widget.patient.name}",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    "Address: ${widget.patient.address}",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    "Phone: ${widget.patient.phone}",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    "Age: ${widget.patient.age}",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    "Gender: ${widget.patient.gender}",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: TextButton(
                      onPressed: () async {
                        await postData("$ServerIP/api/protected/EditTeethMap", {
                          "patient_id": widget.patient.id,
                          "patient_teeth_map": {
                            "teeth": teethMap.toJSON(),
                          },
                        });
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => PatientDetailScreen(
                                    patient: widget.patient)));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 15.0,
                            right: 15.0,
                            top: 10.0,
                            bottom: 10.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text(
                                "Save",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.save_rounded,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future showTeethDialog(Tooth tooth) => showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => Dialog(
          child: SizedBox(
            width: 300,
            height: 300,
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: DropdownSearch<String>(
                    dropdownSearchTextAlign: TextAlign.left,
                    searchFieldProps: const TextFieldProps(
                      autocorrect: false,
                      cursorColor: Color(0xFF0b132b),
                    ),
                    popupItemBuilder: (context, item, isSelected) => SizedBox(
                      height: 50,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    item,
                                    style: TextStyle(
                                      color: isSelected
                                          ? const Color(0xFF5bc0be)
                                          : const Color(0xFF0b132b),
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    dropdownSearchDecoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF0b132b),
                          width: 2.0,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      labelText: "Case Treatment*",
                      labelStyle: TextStyle(
                        color: Color(0xFF0b132b),
                      ),
                    ),
                    mode: Mode.MENU,
                    showSelectedItems: true,
                    showSearchBox: false,
                    enabled: true,
                    items: conditions,
                    selectedItem: tooth.condition,
                    onChanged: (item) => setState(() {
                      tooth.condition = item!;
                    }),
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    reloadTeethMap();
                  },
                  child: const Text(
                    "Done",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 22,
                      fontFamily: "Calibri",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ),
      );
}
