// ignore_for_file: use_build_context_synchronously
import 'package:dentex/components/app_bar.dart';
import 'package:dentex/components/image_manipulation.dart';
import 'package:dentex/components/rive_controller.dart';
import 'package:dentex/dio_helper.dart';
import 'package:dentex/main.dart';
import 'package:dentex/models/patient.dart';
import 'package:dentex/screens/make_appointment.dart';
import 'package:dentex/screens/tooth_history_screen.dart';
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
  List<Widget> teethTopLeft = [];
  List<Widget> teethTopRight = [];
  List<Widget> teethBottomLeft = [];
  List<Widget> teethBottomRight = [];
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

  Future<void> reloadTeethMap() async {
    teethBottomLeft = [];
    teethBottomRight = [];
    teethTopLeft = [];
    teethTopRight = [];
    for (var tooth in teethMap.teeth) {
      if (tooth.toothCode[1] == "B" && tooth.toothCode[0] == "L") {
        final imageBytes = await returnColoredTooth(
            "assets/images/teeth/${tooth.toothCode[1]}${int.parse(tooth.toothCode[2])}${tooth.condition.name != "None" ? "_Colored" : ""}.png",
            tooth.condition.color!);
        teethBottomLeft.add(
          GestureDetector(
            onTap: () {
              showTeethDialog(tooth);
            },
            child: Image.memory(
              imageBytes,
              scale: scale!,
            ),
          ),
        );
      }
      if (tooth.toothCode[1] == "B" && tooth.toothCode[0] == "R") {
        final imageBytes = await returnColoredTooth(
            "assets/images/teeth/${tooth.toothCode.substring(1)}${tooth.condition.name != "None" ? "_Colored" : ""}.png",
            tooth.condition.color!);
        teethBottomRight.add(
          GestureDetector(
            onTap: () {
              showTeethDialog(tooth);
            },
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(math.pi),
              child: Image.memory(
                imageBytes,
                scale: scale!,
              ),
            ),
          ),
        );
      }
      if (tooth.toothCode[1] == "T" && tooth.toothCode[0] == "L") {
        final imageBytes = await returnColoredTooth(
            "assets/images/teeth/${tooth.toothCode.substring(1)}${tooth.condition.name != "None" ? "_Colored" : ""}.png",
            tooth.condition.color!);
        teethTopLeft.add(
          GestureDetector(
            onTap: () {
              showTeethDialog(tooth);
            },
            child: Image.memory(
              imageBytes,
              scale: scale!,
            ),
          ),
        );
      }
      if (tooth.toothCode[1] == "T" && tooth.toothCode[0] == "R") {
        final imageBytes = await returnColoredTooth(
            "assets/images/teeth/${tooth.toothCode[1]}${int.parse(tooth.toothCode[2])}${tooth.condition.name != "None" ? "_Colored" : ""}.png",
            tooth.condition.color!);
        teethTopRight.add(
          GestureDetector(
            onTap: () {
              showTeethDialog(tooth);
            },
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(math.pi),
              child: Image.memory(
                imageBytes,
                scale: scale!,
              ),
            ),
          ),
        );
      }
    }
    setState(() {});
  }

  Future<String> loadPatientData() async {
    if (!isMapLoaded) {
      conditions.add(Condition(name: "None", price: 0.0, color: Colors.white));
      var treatmentsResponse =
          await getData("$ServerIP/api/protected/GetDoctorTreatments");
      for (var obj in treatmentsResponse) {
        Condition condition = Condition();
        condition.name = obj["name"];
        condition.price = double.parse(obj["price"].toString());
        condition.color = obj["hex_color"] == ""
            ? Colors.white
            : HexColor.fromHex(obj["hex_color"]);
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
      List<dynamic> teeth = response["teeth"];
      teeth.sort((a, b) => a["tooth_code"].compareTo(b["tooth_code"]));

      for (var obj in teeth) {
        Tooth tooth = Tooth();
        tooth.id = obj["ID"];
        tooth.toothCode = obj["tooth_code"];
        tooth.condition.name = obj["condition"];

        tooth.condition.color = obj["hex_color"] == ""
            ? Colors.white
            : HexColor.fromHex(obj["hex_color"]);
        tooth.isTreated = obj["is_treated"];
        teethMap.teeth.add(tooth);
        if (tooth.toothCode[1] == "B" && tooth.toothCode[0] == "L") {
          final imageBytes = await returnColoredTooth(
              "assets/images/teeth/${tooth.toothCode[1]}${int.parse(tooth.toothCode[2])}${tooth.condition.name != "None" ? "_Colored" : ""}.png",
              tooth.condition.color!);
          teethBottomLeft.add(
            GestureDetector(
              onTap: () {
                showTeethDialog(tooth);
              },
              child: Image.memory(
                imageBytes,
                scale: scale!,
              ),
            ),
          );
        }
        if (tooth.toothCode[1] == "B" && tooth.toothCode[0] == "R") {
          final imageBytes = await returnColoredTooth(
              "assets/images/teeth/${tooth.toothCode.substring(1)}${tooth.condition.name != "None" ? "_Colored" : ""}.png",
              tooth.condition.color!);
          teethBottomRight.add(
            GestureDetector(
              onTap: () {
                showTeethDialog(tooth);
              },
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(math.pi),
                child: Image.memory(
                  imageBytes,
                  scale: scale!,
                ),
              ),
            ),
          );
        }
        if (tooth.toothCode[1] == "T" && tooth.toothCode[0] == "L") {
          final imageBytes = await returnColoredTooth(
              "assets/images/teeth/${tooth.toothCode.substring(1)}${tooth.condition.name != "None" ? "_Colored" : ""}.png",
              tooth.condition.color!);
          teethTopLeft.add(
            GestureDetector(
              onTap: () {
                showTeethDialog(tooth);
              },
              child: Image.memory(
                imageBytes,
                scale: scale!,
              ),
            ),
          );
        }
        if (tooth.toothCode[1] == "T" && tooth.toothCode[0] == "R") {
          final imageBytes = await returnColoredTooth(
              "assets/images/teeth/${tooth.toothCode[1]}${int.parse(tooth.toothCode[2])}${tooth.condition.name != "None" ? "_Colored" : ""}.png",
              tooth.condition.color!);
          teethTopRight.add(
            GestureDetector(
              onTap: () {
                showTeethDialog(tooth);
              },
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(math.pi),
                child: Image.memory(
                  imageBytes,
                  scale: scale!,
                ),
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
        ? MediaQuery.of(context).size.shortestSide / 180
        : MediaQuery.of(context).size.shortestSide > 380
            ? MediaQuery.of(context).size.shortestSide / 38
            : MediaQuery.of(context).size.shortestSide / 28;
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
                        children:
                            teethTopLeft.reversed.toList() + teethTopRight,
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: teethBottomLeft.reversed.toList() +
                            teethBottomRight,
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

  void showTeethDialog(Tooth tooth) => showDialog(
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
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ToothHistoryScreen(
                          tooth: tooth,
                          scale: scale,
                          patient: patient,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    "Tooth History",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 18,
                      fontFamily: "Calibri",
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () async {
                    await postData("$ServerIP/api/protected/EditTeethMap", {
                      "patient_id": patient.id,
                      "patient_teeth_map": {
                        "teeth": teethMap.toJSON(),
                      },
                    });

                    await reloadTeethMap();
                    Navigator.pop(context);
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
