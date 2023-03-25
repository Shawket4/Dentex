// ignore_for_file: use_build_context_synchronously
import 'package:dentex/components/app_bar.dart';
import 'package:dentex/components/image_manipulation.dart';
import 'package:dentex/components/rive_controller.dart';
import 'package:dentex/dio_helper.dart';
import 'package:dentex/edit_screens/edit_patient.dart';
import 'package:dentex/main.dart';
import 'package:dentex/models/appointment.dart';
import 'package:dentex/models/patient.dart';
import 'package:dentex/screens/home_screen.dart';
import 'package:dentex/screens/make_appointment.dart';
import 'package:dentex/screens/patient_prescriptions.dart';
import 'package:dentex/screens/tooth_history_screen.dart';
import 'package:dentex/screens/uncompleted_appointments_screen.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:rive/rive.dart';
import 'package:intl/intl.dart' as intl;
import 'dart:math' as math;
import 'dart:ui' as ui;

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
  late BuildContext dialogContext;
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
      final GlobalKey key = GlobalKey();
      if (tooth.uncompletedAppointments.isNotEmpty) {
        tooth.condition.color = Colors.grey[600];
      }
      if (tooth.toothCode[1] == "B" && tooth.toothCode[0] == "L") {
        if (tooth.condition.color != Colors.white) {
          final imageBytes = await returnColoredTooth(
            "assets/images/teeth/${tooth.toothCode[1]}${int.parse(tooth.toothCode[2])}_Colored.png",
            tooth.condition.color!,
          );
          teethBottomLeft.add(
            InkWell(
              key: key,
              onTap: () async {
                ui.Image image = await decodeImageFromList(imageBytes);
                RelativeRect position = returnImagePosition(
                    key, (image.height / scale!).toString(), false);
                showTeethDialog(tooth, position);
                //
              },
              child: Image.memory(
                imageBytes,
                scale: scale!,
              ),
            ),
          );
        } else {
          teethBottomLeft.add(
            InkWell(
              key: key,
              onTap: () async {
                late Uint8List imageBytes;
                var data = await rootBundle.load(
                    "assets/images/teeth/${tooth.toothCode[1]}${int.parse(tooth.toothCode[2])}.png");
                imageBytes = data.buffer.asUint8List();
                ui.Image image = await decodeImageFromList(imageBytes);
                RelativeRect position = returnImagePosition(
                    key, (image.height / scale!).toString(), false);
                showTeethDialog(tooth, position);
              },
              child: Image.asset(
                "assets/images/teeth/${tooth.toothCode[1]}${int.parse(tooth.toothCode[2])}.png",
                scale: scale!,
              ),
            ),
          );
        }
      }
      if (tooth.toothCode[1] == "B" && tooth.toothCode[0] == "R") {
        if (tooth.condition.color != Colors.white) {
          final imageBytes = await returnColoredTooth(
              "assets/images/teeth/${tooth.toothCode.substring(1)}_Colored.png",
              tooth.condition.color!);
          teethBottomRight.add(
            InkWell(
              key: key,
              onTap: () async {
                ui.Image image = await decodeImageFromList(imageBytes);
                RelativeRect position = returnImagePosition(
                    key, (image.height / scale!).toString(), true);
                showTeethDialog(tooth, position);
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
        } else {
          teethBottomRight.add(
            InkWell(
              key: key,
              onTap: () async {
                late Uint8List imageBytes;
                var data = await rootBundle.load(
                  "assets/images/teeth/${tooth.toothCode.substring(1)}.png",
                );
                imageBytes = data.buffer.asUint8List();
                ui.Image image = await decodeImageFromList(imageBytes);
                RelativeRect position = returnImagePosition(
                    key, (image.height / scale!).toString(), true);
                showTeethDialog(tooth, position);
              },
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(math.pi),
                child: Image.asset(
                  "assets/images/teeth/${tooth.toothCode.substring(1)}.png",
                  scale: scale!,
                ),
              ),
            ),
          );
        }
      }
      if (tooth.toothCode[1] == "T" && tooth.toothCode[0] == "L") {
        if (tooth.condition.color != Colors.white) {
          final imageBytes = await returnColoredTooth(
              "assets/images/teeth/${tooth.toothCode.substring(1)}_Colored.png",
              tooth.condition.color!);
          teethTopLeft.add(
            InkWell(
              key: key,
              onTap: () async {
                ui.Image image = await decodeImageFromList(imageBytes);
                RelativeRect position = returnImagePosition(
                    key, (image.height / scale!).toString(), false);
                showTeethDialog(tooth, position);
              },
              child: Image.memory(
                imageBytes,
                scale: scale!,
              ),
            ),
          );
        } else {
          teethTopLeft.add(
            InkWell(
              key: key,
              onTap: () async {
                late Uint8List imageBytes;
                var data = await rootBundle.load(
                  "assets/images/teeth/${tooth.toothCode.substring(1)}.png",
                );
                imageBytes = data.buffer.asUint8List();
                ui.Image image = await decodeImageFromList(imageBytes);
                RelativeRect position = returnImagePosition(
                    key, (image.height / scale!).toString(), false);
                showTeethDialog(tooth, position);
              },
              child: Image.asset(
                "assets/images/teeth/${tooth.toothCode.substring(1)}.png",
                scale: scale!,
              ),
            ),
          );
        }
      }
      if (tooth.toothCode[1] == "T" && tooth.toothCode[0] == "R") {
        if (tooth.condition.color != Colors.white) {
          final imageBytes = await returnColoredTooth(
              "assets/images/teeth/${tooth.toothCode[1]}${int.parse(tooth.toothCode[2])}_Colored.png",
              tooth.condition.color!);
          teethTopRight.add(
            InkWell(
              key: key,
              onTap: () async {
                ui.Image image = await decodeImageFromList(imageBytes);
                RelativeRect position = returnImagePosition(
                    key, (image.height / scale!).toString(), true);
                showTeethDialog(tooth, position);
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
        } else {
          teethTopRight.add(
            InkWell(
              key: key,
              onTap: () async {
                late Uint8List imageBytes;
                var data = await rootBundle.load(
                  "assets/images/teeth/${tooth.toothCode[1]}${int.parse(tooth.toothCode[2])}.png",
                );
                imageBytes = data.buffer.asUint8List();
                ui.Image image = await decodeImageFromList(imageBytes);
                RelativeRect position = returnImagePosition(
                    key, (image.height / scale!).toString(), true);
                showTeethDialog(tooth, position);
              },
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(math.pi),
                child: Image.asset(
                  "assets/images/teeth/${tooth.toothCode[1]}${int.parse(tooth.toothCode[2])}.png",
                  scale: scale!,
                ),
              ),
            ),
          );
        }
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
        condition.id = obj["ID"];
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
        final GlobalKey key = GlobalKey();
        Tooth tooth = Tooth();
        tooth.id = obj["ID"];
        tooth.toothCode = obj["tooth_code"];
        tooth.condition.name = obj["condition"];
        tooth.condition.id = obj["condition_id"];
        tooth.condition.color = obj["hex_color"] == ""
            ? Colors.white
            : HexColor.fromHex(obj["hex_color"]);
        if (obj["uncompleted_appointments"] != null) {
          for (var appointmentJSON in obj["uncompleted_appointments"]) {
            Appointment appointment = Appointment();
            appointment.id = appointmentJSON["ID"];
            appointment.date = intl.DateFormat("yyyy/MM/dd & h:mm a")
                .parse(appointmentJSON["date"]);
            appointment.patientID = appointmentJSON["patient_id"];
            appointment.patientName = appointmentJSON["patient_name"];
            appointment.price =
                double.parse(appointmentJSON["price"].toString());
            appointment.condition.color = appointmentJSON["hex_color"] == ""
                ? Colors.white
                : HexColor.fromHex(appointmentJSON["hex_color"]);
            appointment.isCompleted = false;
            appointment.isPaid = appointmentJSON["is_paid"];
            appointment.toothID = appointmentJSON["tooth_id"];
            appointment.toothCode = appointmentJSON["tooth_code"];
            appointment.condition.name = appointmentJSON["treatment"];
            appointment.condition.id = appointmentJSON["ID"];
            tooth.uncompletedAppointments.add(appointment);
          }
          tooth.condition.color = Colors.grey[600];
        }

        tooth.isTreated = obj["is_treated"];
        teethMap.teeth.add(tooth);

        if (tooth.toothCode[1] == "B" && tooth.toothCode[0] == "L") {
          if (tooth.condition.color != Colors.white) {
            final imageBytes = await returnColoredTooth(
              "assets/images/teeth/${tooth.toothCode[1]}${int.parse(tooth.toothCode[2])}_Colored.png",
              tooth.condition.color!,
            );
            teethBottomLeft.add(
              InkWell(
                key: key,
                onTap: () async {
                  ui.Image image = await decodeImageFromList(imageBytes);
                  RelativeRect position = returnImagePosition(
                      key, (image.height / scale!).toString(), false);
                  showTeethDialog(tooth, position);
                  //
                },
                child: Image.memory(
                  imageBytes,
                  scale: scale!,
                ),
              ),
            );
          } else {
            teethBottomLeft.add(
              InkWell(
                key: key,
                onTap: () async {
                  late Uint8List imageBytes;
                  var data = await rootBundle.load(
                      "assets/images/teeth/${tooth.toothCode[1]}${int.parse(tooth.toothCode[2])}.png");
                  imageBytes = data.buffer.asUint8List();
                  ui.Image image = await decodeImageFromList(imageBytes);
                  RelativeRect position = returnImagePosition(
                      key, (image.height / scale!).toString(), false);
                  showTeethDialog(tooth, position);
                },
                child: Image.asset(
                  "assets/images/teeth/${tooth.toothCode[1]}${int.parse(tooth.toothCode[2])}.png",
                  scale: scale!,
                ),
              ),
            );
          }
        }
        if (tooth.toothCode[1] == "B" && tooth.toothCode[0] == "R") {
          if (tooth.condition.color != Colors.white) {
            final imageBytes = await returnColoredTooth(
                "assets/images/teeth/${tooth.toothCode.substring(1)}_Colored.png",
                tooth.condition.color!);
            teethBottomRight.add(
              InkWell(
                key: key,
                onTap: () async {
                  ui.Image image = await decodeImageFromList(imageBytes);
                  RelativeRect position = returnImagePosition(
                      key, (image.height / scale!).toString(), true);
                  showTeethDialog(tooth, position);
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
          } else {
            teethBottomRight.add(
              InkWell(
                key: key,
                onTap: () async {
                  late Uint8List imageBytes;
                  var data = await rootBundle.load(
                    "assets/images/teeth/${tooth.toothCode.substring(1)}.png",
                  );
                  imageBytes = data.buffer.asUint8List();
                  ui.Image image = await decodeImageFromList(imageBytes);
                  RelativeRect position = returnImagePosition(
                      key, (image.height / scale!).toString(), true);
                  showTeethDialog(tooth, position);
                },
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(math.pi),
                  child: Image.asset(
                    "assets/images/teeth/${tooth.toothCode.substring(1)}.png",
                    scale: scale!,
                  ),
                ),
              ),
            );
          }
        }
        if (tooth.toothCode[1] == "T" && tooth.toothCode[0] == "L") {
          if (tooth.condition.color != Colors.white) {
            final imageBytes = await returnColoredTooth(
                "assets/images/teeth/${tooth.toothCode.substring(1)}_Colored.png",
                tooth.condition.color!);
            teethTopLeft.add(
              InkWell(
                key: key,
                onTap: () async {
                  ui.Image image = await decodeImageFromList(imageBytes);
                  RelativeRect position = returnImagePosition(
                      key, (image.height / scale!).toString(), false);
                  showTeethDialog(tooth, position);
                },
                child: Image.memory(
                  imageBytes,
                  scale: scale!,
                ),
              ),
            );
          } else {
            teethTopLeft.add(
              InkWell(
                key: key,
                onTap: () async {
                  late Uint8List imageBytes;
                  var data = await rootBundle.load(
                    "assets/images/teeth/${tooth.toothCode.substring(1)}.png",
                  );
                  imageBytes = data.buffer.asUint8List();
                  ui.Image image = await decodeImageFromList(imageBytes);
                  RelativeRect position = returnImagePosition(
                      key, (image.height / scale!).toString(), false);
                  showTeethDialog(tooth, position);
                },
                child: Image.asset(
                  "assets/images/teeth/${tooth.toothCode.substring(1)}.png",
                  scale: scale!,
                ),
              ),
            );
          }
        }
        if (tooth.toothCode[1] == "T" && tooth.toothCode[0] == "R") {
          if (tooth.condition.color != Colors.white) {
            final imageBytes = await returnColoredTooth(
                "assets/images/teeth/${tooth.toothCode[1]}${int.parse(tooth.toothCode[2])}_Colored.png",
                tooth.condition.color!);
            teethTopRight.add(
              InkWell(
                key: key,
                onTap: () async {
                  ui.Image image = await decodeImageFromList(imageBytes);
                  RelativeRect position = returnImagePosition(
                      key, (image.height / scale!).toString(), true);
                  showTeethDialog(tooth, position);
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
          } else {
            teethTopRight.add(
              InkWell(
                key: key,
                onTap: () async {
                  late Uint8List imageBytes;
                  var data = await rootBundle.load(
                    "assets/images/teeth/${tooth.toothCode[1]}${int.parse(tooth.toothCode[2])}.png",
                  );
                  imageBytes = data.buffer.asUint8List();
                  ui.Image image = await decodeImageFromList(imageBytes);
                  RelativeRect position = returnImagePosition(
                      key, (image.height / scale!).toString(), true);
                  showTeethDialog(tooth, position);
                },
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(math.pi),
                  child: Image.asset(
                    "assets/images/teeth/${tooth.toothCode[1]}${int.parse(tooth.toothCode[2])}.png",
                    scale: scale!,
                  ),
                ),
              ),
            );
          }
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
        title: patient.name.split(" ").first,
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
              margin: const EdgeInsets.only(left: 5, right: 5, bottom: 2),
              height: 40,
              width: 40,
              child: RiveAnimation.asset(
                star.file,
                artboard: star.artboard,
                onInit: (artboard) {
                  StateMachineController controller = getRiveController(
                    artboard,
                    star.stateMachineName,
                  );
                  star.input = controller.findSMI(star.smi) as SMIBool;
                },
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditPatientScreen(patient: patient),
                ),
              );
            },
            child: const Icon(
              Icons.edit_document,
            ),
          ),
          GestureDetector(
            onTap: () async {
              try {
                await postData("$ServerIP/api/protected/DeletePatient", {
                  "id": patient.id,
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HomeScreen(),
                  ),
                );
              } catch (e) {
                dialogContext = context;
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: SizedBox(
                          height: 400,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: Center(
                                  // Display lottie animation
                                  child: Lottie.asset(
                                    "assets/lottie/Error.json",
                                    height: 300,
                                    width: 300,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(dialogContext);
                                },
                                child: const Text(
                                  "Close",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              }
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              height: 40,
              width: 40,
              child: const Icon(
                Icons.delete,
                size: 30,
                color: Colors.red,
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
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PatientPrescriptionScreen(
                            patient: patient,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            "Prescriptions",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.description_rounded,
                          ),
                        ],
                      ),
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

  void showTeethDialog(Tooth tooth, RelativeRect position) {
    showMenu(
      context: context,
      position: position,
      items: [
        PopupMenuItem(
          value: tooth.condition.name != "None"
              ? 'Edit Condition'
              : 'Add Condition',
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                tooth.condition.name != "None"
                    ? 'Edit Condition'
                    : 'Add Condition',
              ),
              Icon(
                tooth.condition.name != "None"
                    ? Icons.edit_rounded
                    : Icons.add_circle_rounded,
              ),
            ],
          ),
        ),
        if (tooth.condition.name != "None")
          PopupMenuItem(
            value: 'Make Appointment',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Make Appointment'),
                Icon(Icons.app_registration_rounded),
              ],
            ),
          ),
        PopupMenuItem(
          value: 'History',
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('History'),
              Icon(
                Icons.history_edu_rounded,
              ),
            ],
          ),
        ),
        if (tooth.uncompletedAppointments.isNotEmpty)
          PopupMenuItem(
            value: 'Uncompleted Appointments',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Uncompleted Appointments'),
                Icon(
                  Icons.alarm,
                ),
              ],
            ),
          ),
      ],
    ).then((value) {
      if (value == null) return;
      Widget? route;
      if (value == "Add Condition" || value == "Edit Condition") {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => Dialog(
            child: SizedBox(
              width: 250,
              height: 250,
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
                      showSearchBox: true,
                      enabled: true,
                      items: conditions.map((e) => e.name.toString()).toList(),
                      selectedItem: tooth.condition.name,
                      onChanged: (item) => tooth.condition = conditions
                          .firstWhere((element) => element.name == item),
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
      } else if (value == "Make Appointment") {
        route = MakeAppointmentScreen(tooth: tooth, patient: patient);
      } else if (value == "History") {
        route = ToothHistoryScreen(
          tooth: tooth,
          scale: scale,
          patient: patient,
        );
      } else if (value == "Uncompleted Appointments") {
        route = UncompletedAppointmentScreen(
          tooth: tooth,
          scale: scale,
          patient: patient,
        );
      }
      if (route == null) return;
      Navigator.push(context, MaterialPageRoute(builder: (_) => route!));
    });
  }

  RelativeRect returnImagePosition(
      GlobalKey key, String height, bool alignRight) {
    final dynamic button = key.currentContext!.findRenderObject();
    final dynamic overlay = Overlay.of(context).context.findRenderObject();
    RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );
    if (alignRight) {
      return position
          .shift(Offset(-button.size.width + 10, double.parse(height)));
    } else {
      return position
          .shift(Offset(button.size.width - 10, double.parse(height)));
    }
  }
}
