// ignore_for_file: use_build_context_synchronously

import 'package:clinic_management/components/app_bar.dart';
import 'package:clinic_management/components/rive_controller.dart';
import 'package:clinic_management/dio_helper.dart';
import 'package:clinic_management/main.dart';
import 'package:clinic_management/models/patient.dart';
import 'package:clinic_management/screens/make_appointment.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:math' as math;
import 'package:rive/rive.dart';

class PatientDetailScreen extends StatefulWidget {
  const PatientDetailScreen({super.key, required this.patientID});
  final int patientID;
  @override
  State<PatientDetailScreen> createState() => _PatientDetailScreenState();
}

class _PatientDetailScreenState extends State<PatientDetailScreen> {
  TeethMap teethMap = TeethMap();
  List<Widget> teethTop = [];
  List<Widget> teethBottom = [];
  List<Condition> conditions = [];
  Patient patient = Patient();
  bool isMapLoaded = false;
  double? scale;
  RiveAsset star = RiveAsset(
    file: "assets/rive/icons.riv",
    artboard: "LIKE/STAR",
    stateMachineName: "STAR_Interactivity",
    title: "Favourites",
    smi: "active",
    route: const Placeholder(),
  );
  @override
  void initState() {
    isMapLoaded = false;
    super.initState();
  }

  void reloadTeethMap() {
    teethBottom = [];
    teethTop = [];
    for (var tooth in teethMap.teeth) {
      if (tooth.toothCode[1] == "B" && tooth.toothCode[0] == "L") {
        teethBottom.add(
          GestureDetector(
            onTap: () {
              showTeethDialog(tooth);
            },
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: SizedBox(
                    child: Image.asset(
                        "assets/images/teeth/${tooth.toothCode[1]}${(int.parse(tooth.toothCode[2]) - 9).abs()}.png",
                        scale: scale),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "${(int.parse(tooth.toothCode[2]) - 9).abs()}",
                  style: TextStyle(
                    color: tooth.condition.name == "None" ? null : Colors.red,
                  ),
                ),
              ],
            ),
          ),
        );
      }
      if (tooth.toothCode[1] == "B" && tooth.toothCode[0] == "R") {
        teethBottom.add(
          GestureDetector(
            onTap: () {
              showTeethDialog(tooth);
            },
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: SizedBox(
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(math.pi),
                      child: Image.asset(
                          "assets/images/teeth/${tooth.toothCode.substring(1)}.png",
                          scale: scale),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "${int.parse(tooth.toothCode[2])}",
                  style: TextStyle(
                    color: tooth.condition.name == "None" ? null : Colors.red,
                  ),
                ),
              ],
            ),
          ),
        );
      }
      if (tooth.toothCode[1] == "T" && tooth.toothCode[0] == "L") {
        teethTop.add(
          GestureDetector(
            onTap: () {
              showTeethDialog(tooth);
            },
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: SizedBox(
                    child: Image.asset(
                        "assets/images/teeth/${tooth.toothCode.substring(1)}.png",
                        scale: scale),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "${(int.parse(tooth.toothCode[2]) - 9).abs()}",
                  style: TextStyle(
                    color: tooth.condition.name == "None" ? null : Colors.red,
                  ),
                ),
              ],
            ),
          ),
        );
      }
      if (tooth.toothCode[1] == "T" && tooth.toothCode[0] == "R") {
        teethTop.add(
          GestureDetector(
            onTap: () {
              showTeethDialog(tooth);
            },
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: SizedBox(
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(math.pi),
                      child: Image.asset(
                          "assets/images/teeth/${tooth.toothCode[1]}${(int.parse(tooth.toothCode[2]) - 9).abs()}.png",
                          scale: scale),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "${int.parse(tooth.toothCode[2])}",
                  style: TextStyle(
                    color: tooth.condition.name == "None" ? null : Colors.red,
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

  Future<String> loadPatientData() async {
    if (!isMapLoaded) {
      conditions.add(Condition(name: "None", price: 0.0));
      var treatmentsResponse =
          await getData("$ServerIP/api/protected/GetDoctorTreatments");
      for (var obj in treatmentsResponse) {
        Condition condition = Condition();
        condition.name = obj["name"];
        condition.price = double.parse(obj["price"].toString());
        conditions.add(condition);
      }

      var userResponse =
          await postData("$ServerIP/api/protected/GetPatientDetails", {
        "patient_id": widget.patientID,
      });
      patient.id = userResponse["ID"];
      patient.doctorID = userResponse["doctor_id"];
      patient.name = userResponse["name"];
      patient.address = userResponse["address"];
      patient.phone = userResponse["phone"];
      patient.gender = userResponse["gender"];
      patient.age = userResponse["age"];
      patient.isFavourite = userResponse["is_favourite"];
      var response =
          await postData("$ServerIP/api/protected/GetPatientTeethMap", {
        "patient_id": widget.patientID,
      });

      for (var obj in response["teeth"]) {
        Tooth tooth = Tooth();
        tooth.id = obj["ID"];
        tooth.toothCode = obj["tooth_code"];
        tooth.condition.name = obj["condition"];
        tooth.isTreated = obj["is_treated"];
        teethMap.teeth.add(tooth);
        if (tooth.toothCode[1] == "B" && tooth.toothCode[0] == "L") {
          teethBottom.add(
            GestureDetector(
              onTap: () {
                showTeethDialog(tooth);
              },
              child: Stack(
                children: [
                  SizedBox(
                    child: Image.asset(
                      "assets/images/teeth/${tooth.toothCode[1]}${(int.parse(tooth.toothCode[2]) - 9).abs()}.png",
                      scale: scale,
                    ),
                  ),
                  // Column(
                  //   children: [
                  //     SizedBox(
                  //       height: MediaQuery.of(context).size.shortestSide > 500
                  //           ? MediaQuery.of(context).size.height / 7
                  //           : MediaQuery.of(context).size.height / 11,
                  //     ),
                  //     Align(
                  //       alignment: Alignment.bottomCenter,
                  //       child: Padding(
                  //         padding: const EdgeInsets.only(left: 7),
                  //         child: Text(
                  //           "${(int.parse(tooth.toothCode[2]) - 9).abs()}",
                  //           style: TextStyle(
                  //             color: tooth.condition.name == "None"
                  //                 ? null
                  //                 : Colors.red,
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          );
        }
        if (tooth.toothCode[1] == "B" && tooth.toothCode[0] == "R") {
          teethBottom.add(
            GestureDetector(
              onTap: () {
                showTeethDialog(tooth);
              },
              child: Stack(
                children: [
                  Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(math.pi),
                    child: SizedBox(
                      child: Image.asset(
                        "assets/images/teeth/${tooth.toothCode.substring(1)}.png",
                        scale: scale,
                      ),
                    ),
                  ),
                  // Column(
                  //   children: [
                  //     SizedBox(
                  //       height: MediaQuery.of(context).size.shortestSide > 500
                  //           ? MediaQuery.of(context).size.height / 7
                  //           : MediaQuery.of(context).size.height / 11,
                  //     ),
                  //     Align(
                  //       alignment: Alignment.bottomCenter,
                  //       child: Padding(
                  //         padding: const EdgeInsets.only(left: 7),
                  //         child: Text(
                  //           "${int.parse(tooth.toothCode[2])}",
                  //           style: TextStyle(
                  //             color: tooth.condition.name == "None"
                  //                 ? null
                  //                 : Colors.red,
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          );
        }
        if (tooth.toothCode[1] == "T" && tooth.toothCode[0] == "L") {
          teethTop.add(
            GestureDetector(
              onTap: () {
                showTeethDialog(tooth);
              },
              child: Stack(
                children: [
                  SizedBox(
                    child: Image.asset(
                      "assets/images/teeth/${tooth.toothCode.substring(1)}.png",
                      scale: scale,
                    ),
                  ),
                  // Column(
                  //   children: [
                  //     SizedBox(
                  //       height: MediaQuery.of(context).size.shortestSide > 500
                  //           ? MediaQuery.of(context).size.height / 7
                  //           : MediaQuery.of(context).size.height / 11,
                  //     ),
                  //     Padding(
                  //       padding: const EdgeInsets.only(left: 7),
                  //       child: Align(
                  //         alignment: Alignment.bottomCenter,
                  //         child: Text(
                  //           "${(int.parse(tooth.toothCode[2]) - 9).abs()}",
                  //           style: TextStyle(
                  //             color: tooth.condition.name == "None"
                  //                 ? null
                  //                 : Colors.red,
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          );
        }
        if (tooth.toothCode[1] == "T" && tooth.toothCode[0] == "R") {
          teethTop.add(
            GestureDetector(
              onTap: () {
                showTeethDialog(tooth);
              },
              child: Stack(
                children: [
                  Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(math.pi),
                    child: SizedBox(
                      child: Image.asset(
                        "assets/images/teeth/${tooth.toothCode[1]}${(int.parse(tooth.toothCode[2]) - 9).abs()}.png",
                        scale: scale,
                      ),
                    ),
                  ),
                  // Column(
                  //   children: [
                  //     SizedBox(
                  //       height: MediaQuery.of(context).size.shortestSide > 500
                  //           ? MediaQuery.of(context).size.height / 7
                  //           : MediaQuery.of(context).size.height / 11,
                  //     ),
                  //     Align(
                  //       alignment: Alignment.bottomCenter,
                  //       child: Padding(
                  //         padding: const EdgeInsets.only(left: 7),
                  //         child: Text(
                  //           "${int.parse(tooth.toothCode[2])}",
                  //           style: TextStyle(
                  //             color: tooth.condition.name == "None"
                  //                 ? null
                  //                 : Colors.red,
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
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
    scale = MediaQuery.of(context).size.shortestSide > 500
        ? MediaQuery.of(context).size.shortestSide / 400
        : MediaQuery.of(context).size.shortestSide > 380
            ? MediaQuery.of(context).size.shortestSide / 90
            : MediaQuery.of(context).size.shortestSide / 80;
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9),
      appBar: CustomAppBar(
        title: "Patient: ${patient.name.split(" ").first}",
        actions: [
          GestureDetector(
            onTap: () async {
              patient.isFavourite = true;
              await postData(
                  "$ServerIP/api/protected/EditPatientFavouriteStatus", {
                "patient_id": patient.id,
              });
              star.input!.change(true);
              await Future.delayed(const Duration(milliseconds: 600), () {});
              star.input!.change(false);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              height: 40,
              width: 40,
              child: RiveAnimation.asset(
                star.file,
                artboard: star.artboard,
                onInit: (artboard) {
                  // (artboard.fills.first.children[0].name as SolidColor)
                  //     .colorValue = (Colors.yellow).value;
                  StateMachineController controller = getRiveController(
                    artboard,
                    star.stateMachineName,
                  );

                  star.input = controller.findSMI(star.smi) as SMIBool;
                },
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: loadPatientData(),
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
                  Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: teethTop,
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: teethBottom,
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                  Text(
                    "Patient: ${patient.name}",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    "Address: ${patient.address}",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    "Phone: ${patient.phone}",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    "Age: ${patient.age}",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    "Gender: ${patient.gender}",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
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
                    items: conditions.map((e) => e.name.toString()).toList(),
                    selectedItem: tooth.condition.name,
                    onChanged: (item) => setState(() {
                      tooth.condition = conditions
                          .firstWhere((element) => element.name == item);
                    }),
                  ),
                ),
                // const SizedBox(
                //   height: 20.0,
                // ),
                tooth.condition.name != "None"
                    ? TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MakeAppointmentScreen(
                                tooth: tooth,
                                patient: patient,
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          "Make Appointment",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 18,
                            fontFamily: "Calibri",
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      )
                    : Container(),
                const Spacer(),
                TextButton(
                  onPressed: () async {
                    await postData("$ServerIP/api/protected/EditTeethMap", {
                      "patient_id": patient.id,
                      "patient_teeth_map": {
                        "teeth": teethMap.toJSON(),
                      },
                    });

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
