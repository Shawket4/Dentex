// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers
import 'package:dentex/components/app_bar.dart';
import 'package:dentex/components/dialog.dart';
import 'package:dentex/components/image_manipulation.dart';
import 'package:dentex/components/rive_controller.dart';
import 'package:dentex/dio_helper.dart';
import 'package:dentex/edit_screens/edit_patient.dart';
import 'package:dentex/main.dart';
import 'package:dentex/models/patient.dart';
import 'package:dentex/screens/home_screen.dart';
import 'package:dentex/screens/make_appointment.dart';
import 'package:dentex/screens/patient_history.dart';
import 'package:dentex/screens/patient_prescriptions.dart';
import 'package:dentex/screens/uncompleted_appointments_screen.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:rive/rive.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

class PatientDetailScreen extends StatefulWidget {
  const PatientDetailScreen(
      {super.key, required this.patient, required this.conditions});
  final Patient patient;
  final List<Condition> conditions;
  @override
  State<PatientDetailScreen> createState() => _PatientDetailScreenState();
}

class _PatientDetailScreenState extends State<PatientDetailScreen> {
  List<Widget> teethTopLeft = [];
  List<Widget> teethTopRight = [];
  List<Widget> teethTopLateralLeft = [];
  List<Widget> teethTopLateralRight = [];
  List<Widget> teethBottomLeft = [];
  List<Widget> teethBottomRight = [];
  List<Widget> teethBottomLateralLeft = [];
  List<Widget> teethBottomLateralRight = [];
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
    patient = widget.patient;
    conditions = widget.conditions;
    super.initState();
  }

  Future<void> reloadTeethMap() async {
    teethBottomLeft.clear();
    teethBottomRight.clear();
    teethTopLeft.clear();
    teethTopRight.clear();
    teethBottomLateralLeft.clear();
    teethBottomLateralRight.clear();
    teethTopLateralLeft.clear();
    teethTopLateralRight.clear();
    for (var tooth in widget.patient.teethMap.teeth) {
      final GlobalKey key = GlobalKey();
      final GlobalKey _key = GlobalKey();
      if (tooth.uncompletedAppointments.isNotEmpty) {
        tooth.condition.color = Colors.grey[600];
      }
      if (tooth.toothCode[1] == "B" && tooth.toothCode[0] == "L") {
        if (tooth.condition.color != Colors.white) {
          final imageBytes = await returnColoredTooth(
            "assets/images/teeth/${tooth.toothCode[1]}${int.parse(tooth.toothCode[2])}_Colored.png",
            tooth.condition.color!,
          );
          final imageBytesLateral = await returnColoredTooth(
            "assets/images/teeth/Lateral_${tooth.toothCode[2]}_Colored.png",
            tooth.condition.color!,
          );
          teethBottomLateralLeft.add(
            InkWell(
              key: _key,
              onTap: () async {
                ui.Image image = await decodeImageFromList(imageBytesLateral);
                RelativeRect position = returnImagePosition(
                    key, (image.height / scale! * 1.5).toString(), false);
                showTeethDialog(tooth, position);
                //
              },
              child: Image.memory(
                imageBytesLateral,
                scale: scale! / 1.5,
              ),
            ),
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
          teethBottomLateralLeft.add(
            InkWell(
              key: _key,
              onTap: () async {
                late Uint8List imageBytes;
                var data = await rootBundle.load(
                  "assets/images/teeth/Lateral_${tooth.toothCode[2]}.png",
                );
                imageBytes = data.buffer.asUint8List();
                ui.Image image = await decodeImageFromList(imageBytes);
                RelativeRect position = returnImagePosition(
                    key, (image.height / scale!).toString(), false);
                showTeethDialog(tooth, position);
                //
              },
              child: Image.asset(
                "assets/images/teeth/Lateral_${tooth.toothCode[2]}.png",
                scale: scale! / 1.5,
              ),
            ),
          );
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
          final imageBytesLateral = await returnColoredTooth(
            "assets/images/teeth/Lateral_${tooth.toothCode[2]}_Colored.png",
            tooth.condition.color!,
          );
          teethBottomLateralRight.add(
            InkWell(
              key: _key,
              onTap: () async {
                ui.Image image = await decodeImageFromList(imageBytesLateral);
                RelativeRect position = returnImagePosition(
                    key, (image.height / scale! * 1.5).toString(), true);
                showTeethDialog(tooth, position);
              },
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(math.pi),
                child: Image.memory(
                  imageBytesLateral,
                  scale: scale! / 1.5,
                ),
              ),
            ),
          );
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
          teethBottomLateralRight.add(
            InkWell(
              key: _key,
              onTap: () async {
                late Uint8List imageBytes;
                var data = await rootBundle.load(
                  "assets/images/teeth/Lateral_${tooth.toothCode[2]}.png",
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
                  "assets/images/teeth/Lateral_${tooth.toothCode[2]}.png",
                  scale: scale! / 1.5,
                ),
              ),
            ),
          );
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
          final imageBytesLateral = await returnColoredTooth(
            "assets/images/teeth/Lateral_${tooth.toothCode[2]}_Colored.png",
            tooth.condition.color!,
          );
          teethTopLateralLeft.add(
            InkWell(
              key: _key,
              onTap: () async {
                ui.Image image = await decodeImageFromList(imageBytesLateral);
                RelativeRect position = returnImagePosition(
                    key, (image.height / scale! * 1.5).toString(), false);
                showTeethDialog(tooth, position);
              },
              child: Image.memory(
                imageBytesLateral,
                scale: scale! / 1.5,
              ),
            ),
          );
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
          teethTopLateralLeft.add(
            InkWell(
              key: _key,
              onTap: () async {
                late Uint8List imageBytes;
                var data = await rootBundle.load(
                  "assets/images/teeth/Lateral_${tooth.toothCode[2]}.png",
                );
                imageBytes = data.buffer.asUint8List();
                ui.Image image = await decodeImageFromList(imageBytes);
                RelativeRect position = returnImagePosition(
                    key, (image.height / scale! * 1.5).toString(), false);
                showTeethDialog(tooth, position);
              },
              child: Image.asset(
                "assets/images/teeth/Lateral_${tooth.toothCode[2]}.png",
                scale: scale! / 1.5,
              ),
            ),
          );
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
          final imageBytesLateral = await returnColoredTooth(
            "assets/images/teeth/Lateral_${tooth.toothCode[2]}_Colored.png",
            tooth.condition.color!,
          );
          teethTopLateralRight.add(
            InkWell(
              key: _key,
              onTap: () async {
                ui.Image image = await decodeImageFromList(imageBytesLateral);
                RelativeRect position = returnImagePosition(
                    key, (image.height / scale! * 1.5).toString(), true);
                showTeethDialog(tooth, position);
              },
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(math.pi),
                child: Image.memory(
                  imageBytesLateral,
                  scale: scale! / 1.5,
                ),
              ),
            ),
          );
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
          teethTopLateralRight.add(
            InkWell(
              key: _key,
              onTap: () async {
                late Uint8List imageBytes;
                var data = await rootBundle.load(
                  "assets/images/teeth/Lateral_${tooth.toothCode[2]}.png",
                );
                imageBytes = data.buffer.asUint8List();
                ui.Image image = await decodeImageFromList(imageBytes);
                RelativeRect position = returnImagePosition(
                    key, (image.height / scale! * 1.5).toString(), true);
                showTeethDialog(tooth, position);
              },
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(math.pi),
                child: Image.asset(
                  "assets/images/teeth/Lateral_${tooth.toothCode[2]}.png",
                  scale: scale! / 1.5,
                ),
              ),
            ),
          );
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
      for (var tooth in patient.teethMap.teeth) {
        final GlobalKey key = GlobalKey();
        final GlobalKey _key = GlobalKey();
        if (tooth.toothCode[1] == "B" && tooth.toothCode[0] == "L") {
          if (tooth.condition.color != Colors.white) {
            final imageBytes = await returnColoredTooth(
              "assets/images/teeth/${tooth.toothCode[1]}${int.parse(tooth.toothCode[2])}_Colored.png",
              tooth.condition.color!,
            );
            final imageBytesLateral = await returnColoredTooth(
              "assets/images/teeth/Lateral_${tooth.toothCode[2]}_Colored.png",
              tooth.condition.color!,
            );
            teethBottomLateralLeft.add(
              InkWell(
                key: _key,
                onTap: () async {
                  ui.Image image = await decodeImageFromList(imageBytesLateral);
                  RelativeRect position = returnImagePosition(
                      key, (image.height / scale! * 1.5).toString(), false);
                  showTeethDialog(tooth, position);
                  //
                },
                child: Image.memory(
                  imageBytesLateral,
                  scale: scale! / 1.5,
                ),
              ),
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
            teethBottomLateralLeft.add(
              InkWell(
                key: _key,
                onTap: () async {
                  late Uint8List imageBytes;
                  var data = await rootBundle.load(
                    "assets/images/teeth/Lateral_${tooth.toothCode[2]}.png",
                  );
                  imageBytes = data.buffer.asUint8List();
                  ui.Image image = await decodeImageFromList(imageBytes);
                  RelativeRect position = returnImagePosition(
                      key, (image.height / scale!).toString(), false);
                  showTeethDialog(tooth, position);
                  //
                },
                child: Image.asset(
                  "assets/images/teeth/Lateral_${tooth.toothCode[2]}.png",
                  scale: scale! / 1.5,
                ),
              ),
            );
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
            final imageBytesLateral = await returnColoredTooth(
              "assets/images/teeth/Lateral_${tooth.toothCode[2]}_Colored.png",
              tooth.condition.color!,
            );
            teethBottomLateralRight.add(
              InkWell(
                key: _key,
                onTap: () async {
                  ui.Image image = await decodeImageFromList(imageBytesLateral);
                  RelativeRect position = returnImagePosition(
                      key, (image.height / scale! * 1.5).toString(), true);
                  showTeethDialog(tooth, position);
                },
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(math.pi),
                  child: Image.memory(
                    imageBytesLateral,
                    scale: scale! / 1.5,
                  ),
                ),
              ),
            );
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
            teethBottomLateralRight.add(
              InkWell(
                key: _key,
                onTap: () async {
                  late Uint8List imageBytes;
                  var data = await rootBundle.load(
                    "assets/images/teeth/Lateral_${tooth.toothCode[2]}.png",
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
                    "assets/images/teeth/Lateral_${tooth.toothCode[2]}.png",
                    scale: scale! / 1.5,
                  ),
                ),
              ),
            );
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
            final imageBytesLateral = await returnColoredTooth(
              "assets/images/teeth/Lateral_${tooth.toothCode[2]}_Colored.png",
              tooth.condition.color!,
            );
            teethTopLateralLeft.add(
              InkWell(
                key: _key,
                onTap: () async {
                  ui.Image image = await decodeImageFromList(imageBytesLateral);
                  RelativeRect position = returnImagePosition(
                      key, (image.height / scale! * 1.5).toString(), false);
                  showTeethDialog(tooth, position);
                },
                child: Image.memory(
                  imageBytesLateral,
                  scale: scale! / 1.5,
                ),
              ),
            );
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
            teethTopLateralLeft.add(
              InkWell(
                key: _key,
                onTap: () async {
                  late Uint8List imageBytes;
                  var data = await rootBundle.load(
                    "assets/images/teeth/Lateral_${tooth.toothCode[2]}.png",
                  );
                  imageBytes = data.buffer.asUint8List();
                  ui.Image image = await decodeImageFromList(imageBytes);
                  RelativeRect position = returnImagePosition(
                      key, (image.height / scale! * 1.5).toString(), false);
                  showTeethDialog(tooth, position);
                },
                child: Image.asset(
                  "assets/images/teeth/Lateral_${tooth.toothCode[2]}.png",
                  scale: scale! / 1.5,
                ),
              ),
            );
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
            final imageBytesLateral = await returnColoredTooth(
              "assets/images/teeth/Lateral_${tooth.toothCode[2]}_Colored.png",
              tooth.condition.color!,
            );
            teethTopLateralRight.add(
              InkWell(
                key: _key,
                onTap: () async {
                  ui.Image image = await decodeImageFromList(imageBytesLateral);
                  RelativeRect position = returnImagePosition(
                      key, (image.height / scale! * 1.5).toString(), true);
                  showTeethDialog(tooth, position);
                },
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(math.pi),
                  child: Image.memory(
                    imageBytesLateral,
                    scale: scale! / 1.5,
                  ),
                ),
              ),
            );
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
            teethTopLateralRight.add(
              InkWell(
                key: _key,
                onTap: () async {
                  late Uint8List imageBytes;
                  var data = await rootBundle.load(
                    "assets/images/teeth/Lateral_${tooth.toothCode[2]}.png",
                  );
                  imageBytes = data.buffer.asUint8List();
                  ui.Image image = await decodeImageFromList(imageBytes);
                  RelativeRect position = returnImagePosition(
                      key, (image.height / scale! * 1.5).toString(), true);
                  showTeethDialog(tooth, position);
                },
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(math.pi),
                  child: Image.asset(
                    "assets/images/teeth/Lateral_${tooth.toothCode[2]}.png",
                    scale: scale! / 1.5,
                  ),
                ),
              ),
            );
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
            ? MediaQuery.of(context).size.shortestSide / 45
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
                  "$ServerIP/api/protected/EditPatientFavouriteStatus",
                  {
                    "patient_id": patient.id,
                  },
                  context);
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
                await postData(
                    "$ServerIP/api/protected/DeletePatient",
                    {
                      "id": patient.id,
                    },
                    context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HomeScreen(),
                  ),
                );
              } catch (e) {
                showErrorDialog(context);
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...List.generate(8, (index) {
                        return Expanded(
                          child: SizedBox(
                            child: Column(
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.shortestSide /
                                          3,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      teethTopLeft.reversed.toList()[index],
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      teethTopLateralLeft.reversed
                                          .toList()[index],
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text((index + 1).toString()),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.shortestSide /
                                          3,
                                  child: Column(
                                    children: [
                                      Text((index - 32).abs().toString()),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      teethBottomLateralLeft.reversed
                                          .toList()[index],
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      teethBottomLeft.reversed.toList()[index],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                      ...List.generate(8, (index) {
                        return Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.shortestSide /
                                        3,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    teethTopRight[index],
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    teethTopLateralRight[index],
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text((index + 9).toString()),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.shortestSide /
                                        3,
                                child: Column(
                                  children: [
                                    Text((index - 24).abs().toString()),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    teethBottomLateralRight[index],
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    teethBottomRight[index],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      })
                    ],
                  ),
                  // Center(
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: teethTopLeft.reversed.toList() + teethTopRight,
                  //   ),
                  // ),
                  // const SizedBox(height: 5),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     ...List.generate(
                  //       16,
                  //       (index) => Padding(
                  //         padding: const EdgeInsets.only(left: 5),
                  //         child: Text(
                  //           (index + 1).toString(),
                  //         ),
                  //       ),
                  //     )
                  //   ],
                  // ),
                  // const SizedBox(height: 20),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     ...List.generate(
                  //       16,
                  //       (index) => Padding(
                  //         padding: const EdgeInsets.only(left: 5),
                  //         child: Text(
                  //           (index + 17).toString(),
                  //         ),
                  //       ),
                  //     ).reversed
                  //   ],
                  // ),
                  // const SizedBox(height: 5),
                  // Center(
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //     children: teethBottomLateralLeft.reversed.toList() +
                  //         teethBottomLateralRight,
                  //   ),
                  // ),
                  // Center(
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children:
                  //         teethBottomLeft.reversed.toList() + teethBottomRight,
                  //   ),
                  // ),
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
                  Row(
                    children: [
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
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PatientHistoryScreen(
                                allAppointments: patient.history,
                                conditions: conditions,
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
                                "History",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.history_rounded,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // ElevatedButton(
                      //   onPressed: () {
                      //     if (patient.braces.notes != "") {
                      //       Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //           builder: (_) => BraceScreen(
                      //             patient: patient,
                      //           ),
                      //         ),
                      //       );
                      //     } else {
                      //       showDialog(
                      //           context: context,
                      //           builder: (context) {
                      //             TextEditingController notes =
                      //                 TextEditingController();
                      //             return Dialog(
                      //               child: SizedBox(
                      //                 width: 400,
                      //                 height: 400,
                      //                 child: Column(
                      //                   children: [
                      //                     const SizedBox(
                      //                       height: 20,
                      //                     ),
                      //                     Container(
                      //                       padding: const EdgeInsets.all(10),
                      //                       child: TextField(
                      //                         autocorrect: false,
                      //                         controller: notes,
                      //                         decoration: const InputDecoration(
                      //                           focusedBorder:
                      //                               OutlineInputBorder(
                      //                             borderSide: BorderSide(
                      //                               color: Color(0xFF011627),
                      //                               width: 2.0,
                      //                             ),
                      //                           ),
                      //                           border: OutlineInputBorder(),
                      //                           labelText: 'Notes',
                      //                           labelStyle: TextStyle(
                      //                             fontWeight: FontWeight.w600,
                      //                             fontSize: 20,
                      //                           ),
                      //                         ),
                      //                         maxLines: 5,
                      //                       ),
                      //                     ),
                      //                     const Spacer(),
                      //                     Container(
                      //                       height: 50,
                      //                       padding: const EdgeInsets.fromLTRB(
                      //                           10, 0, 10, 0),
                      //                       child: ElevatedButton(
                      //                         onPressed: () async {
                      //                           try {
                      //                             var response = await postData(
                      //                                 "$ServerIP/api/protected/RegisterBraces",
                      //                                 {
                      //                                   "patient_id":
                      //                                       patient.id,
                      //                                   "notes": notes.text,
                      //                                 });
                      //                             if (response["message"] ==
                      //                                 "Registered Successfully") {
                      //                               showDialog(
                      //                                   context: context,
                      //                                   barrierDismissible:
                      //                                       false,
                      //                                   builder: (context) {
                      //                                     dialogContext =
                      //                                         context;
                      //                                     return Dialog(
                      //                                       shape:
                      //                                           RoundedRectangleBorder(
                      //                                         borderRadius:
                      //                                             BorderRadius
                      //                                                 .circular(
                      //                                                     12.0),
                      //                                       ),
                      //                                       child: SizedBox(
                      //                                         height: 400,
                      //                                         child: Column(
                      //                                           mainAxisAlignment:
                      //                                               MainAxisAlignment
                      //                                                   .center,
                      //                                           children: [
                      //                                             SizedBox(
                      //                                               width: double
                      //                                                   .infinity,
                      //                                               child:
                      //                                                   Center(
                      //                                                 // Display lottie animation
                      //                                                 child: Lottie
                      //                                                     .asset(
                      //                                                   "assets/lottie/Success.json",
                      //                                                   height:
                      //                                                       300,
                      //                                                   width:
                      //                                                       300,
                      //                                                 ),
                      //                                               ),
                      //                                             ),
                      //                                             TextButton(
                      //                                               onPressed:
                      //                                                   () {
                      //                                                 Navigator.pop(
                      //                                                     dialogContext);
                      //                                                 Navigator
                      //                                                     .pushReplacement(
                      //                                                   context,
                      //                                                   MaterialPageRoute(
                      //                                                     builder: (_) =>
                      //                                                         const HomeScreen(),
                      //                                                   ),
                      //                                                 );
                      //                                               },
                      //                                               child:
                      //                                                   const Text(
                      //                                                 "Close",
                      //                                                 style:
                      //                                                     TextStyle(
                      //                                                   fontWeight:
                      //                                                       FontWeight.bold,
                      //                                                   fontSize:
                      //                                                       20,
                      //                                                 ),
                      //                                               ),
                      //                                             ),
                      //                                           ],
                      //                                         ),
                      //                                       ),
                      //                                     );
                      //                                   });
                      //                             } else {
                      //                               showDialog(
                      //                                   context: context,
                      //                                   barrierDismissible:
                      //                                       false,
                      //                                   builder: (context) {
                      //                                     dialogContext =
                      //                                         context;
                      //                                     return Dialog(
                      //                                       shape:
                      //                                           RoundedRectangleBorder(
                      //                                         borderRadius:
                      //                                             BorderRadius
                      //                                                 .circular(
                      //                                                     12.0),
                      //                                       ),
                      //                                       child: SizedBox(
                      //                                         height: 400,
                      //                                         child: Column(
                      //                                           mainAxisAlignment:
                      //                                               MainAxisAlignment
                      //                                                   .center,
                      //                                           children: [
                      //                                             SizedBox(
                      //                                               width: double
                      //                                                   .infinity,
                      //                                               child:
                      //                                                   Center(
                      //                                                 // Display lottie animation
                      //                                                 child: Lottie
                      //                                                     .asset(
                      //                                                   "assets/lottie/Error.json",
                      //                                                   height:
                      //                                                       300,
                      //                                                   width:
                      //                                                       300,
                      //                                                 ),
                      //                                               ),
                      //                                             ),
                      //                                             TextButton(
                      //                                               onPressed:
                      //                                                   () {
                      //                                                 Navigator.pop(
                      //                                                     dialogContext);
                      //                                                 Navigator.pop(
                      //                                                     dialogContext);
                      //                                               },
                      //                                               child:
                      //                                                   const Text(
                      //                                                 "Close",
                      //                                                 style:
                      //                                                     TextStyle(
                      //                                                   fontWeight:
                      //                                                       FontWeight.bold,
                      //                                                   fontSize:
                      //                                                       20,
                      //                                                 ),
                      //                                               ),
                      //                                             ),
                      //                                           ],
                      //                                         ),
                      //                                       ),
                      //                                     );
                      //                                   });
                      //                             }
                      //                           } catch (e) {
                      //                             showDialog(
                      //                                 context: context,
                      //                                 barrierDismissible: false,
                      //                                 builder: (context) {
                      //                                   dialogContext = context;
                      //                                   return Dialog(
                      //                                     shape:
                      //                                         RoundedRectangleBorder(
                      //                                       borderRadius:
                      //                                           BorderRadius
                      //                                               .circular(
                      //                                                   12.0),
                      //                                     ),
                      //                                     child: SizedBox(
                      //                                       height: 400,
                      //                                       child: Column(
                      //                                         mainAxisAlignment:
                      //                                             MainAxisAlignment
                      //                                                 .center,
                      //                                         children: [
                      //                                           SizedBox(
                      //                                             width: double
                      //                                                 .infinity,
                      //                                             child: Center(
                      //                                               // Display lottie animation
                      //                                               child: Lottie
                      //                                                   .asset(
                      //                                                 "assets/lottie/Error.json",
                      //                                                 height:
                      //                                                     300,
                      //                                                 width:
                      //                                                     300,
                      //                                               ),
                      //                                             ),
                      //                                           ),
                      //                                           TextButton(
                      //                                             onPressed:
                      //                                                 () {
                      //                                               Navigator.pop(
                      //                                                   dialogContext);
                      //                                               Navigator.pop(
                      //                                                   dialogContext);
                      //                                             },
                      //                                             child:
                      //                                                 const Text(
                      //                                               "Close",
                      //                                               style:
                      //                                                   TextStyle(
                      //                                                 fontWeight:
                      //                                                     FontWeight
                      //                                                         .bold,
                      //                                                 fontSize:
                      //                                                     20,
                      //                                               ),
                      //                                             ),
                      //                                           ),
                      //                                         ],
                      //                                       ),
                      //                                     ),
                      //                                   );
                      //                                 });
                      //                           }
                      //                         },
                      //                         child: const Text(
                      //                           "Register",
                      //                           style: TextStyle(
                      //                             fontSize: 20,
                      //                             fontWeight: FontWeight.w600,
                      //                           ),
                      //                         ),
                      //                       ),
                      //                     ),
                      //                     const SizedBox(
                      //                       height: 20,
                      //                     ),
                      //                   ],
                      //                 ),
                      //               ),
                      //             );
                      //           });
                      //     }
                      //   },
                      //   child: Padding(
                      //     padding: const EdgeInsets.symmetric(vertical: 12.0),
                      //     child: Row(
                      //       mainAxisSize: MainAxisSize.min,
                      //       children: [
                      //         Text(
                      //           patient.braces.notes != ""
                      //               ? "Braces"
                      //               : "Add Braces",
                      //           style: const TextStyle(
                      //             fontSize: 18,
                      //             fontWeight: FontWeight.w600,
                      //           ),
                      //         ),
                      //         const SizedBox(
                      //           width: 5,
                      //         ),
                      //         patient.braces.notes != ""
                      //             ? const Icon(Icons.troubleshoot_sharp)
                      //             : const Icon(Icons.add_circle),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
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
        // PopupMenuItem(
        //   value: 'History',
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: const [
        //       Text('History'),
        //       Icon(
        //         Icons.history_edu_rounded,
        //       ),
        //     ],
        //   ),
        // ),
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
                      await postData(
                        "$ServerIP/api/protected/EditTeethMap",
                        {
                          "patient_id": patient.id,
                          "patient_teeth_map": {
                            "teeth": widget.patient.teethMap.toJSON(),
                          },
                        },
                        context,
                      );
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
        route = MakeAppointmentScreen(
          tooth: tooth,
          patient: patient,
          isBraces: false,
        );
        // } else if (value == "History") {
        //   route = ToothHistoryScreen(
        //     tooth: tooth,
        //     scale: scale,
        //     patient: patient,
        //   );
      } else if (value == "Uncompleted Appointments") {
        route = UncompletedAppointmentScreen(
          tooth: tooth,
          scale: scale,
          patient: patient,
          conditions: conditions,
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
