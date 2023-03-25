// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:dentex/components/app_bar.dart';
import 'package:dentex/components/image_manipulation.dart';
import 'package:dentex/dio_helper.dart';
import 'package:dentex/main.dart';
import 'package:dentex/models/appointment.dart';
import 'package:dentex/models/patient.dart';
import 'package:dentex/models/time_block.dart';
import 'package:dentex/screens/home_screen.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart' as intl;
import 'dart:math' as math;

class EditAppointmentScreen extends StatefulWidget {
  const EditAppointmentScreen({super.key, required this.appointment});
  final Appointment appointment;

  @override
  State<EditAppointmentScreen> createState() => _EditAppointmentScreenState();
}

class _EditAppointmentScreenState extends State<EditAppointmentScreen> {
  bool isWorkingHoursLoaded = false;
  List<TimeBlock> timeBlocks = [];
  TimeBlock? selectedTimeBlock;
  TimeBlock? previousTimeBlock;
  DateTime selectedDate = DateTime.now();
  late BuildContext dialogContext;
  DateTime currentDate = DateTime.now();
  List<Condition> conditions = [];
  Condition? selectedCondition;
  int? selectedToothID;

  List<Widget> teethTopLeft = [];
  List<Widget> teethTopRight = [];
  List<Widget> teethBottomLeft = [];
  List<Widget> teethBottomRight = [];
  double? scale;
  // List<String> workingHours;
  void loadBlocks() {
    timeBlocks.clear();
    timeBlocks.add(TimeBlock(
        dateTime: DateTime(
            currentDate.year, currentDate.month, currentDate.day, 24, 0),
        isAvailable: true));
    timeBlocks.add(
      TimeBlock(
        dateTime: DateTime(
            currentDate.year, currentDate.month, currentDate.day, 0, 30),
        isAvailable: true,
      ),
    );
    timeBlocks.add(TimeBlock(
        dateTime: DateTime(
            currentDate.year, currentDate.month, currentDate.day, 1, 0),
        isAvailable: true));
    timeBlocks.add(TimeBlock(
        dateTime: DateTime(
            currentDate.year, currentDate.month, currentDate.day, 1, 30),
        isAvailable: true));
    timeBlocks.add(TimeBlock(
        dateTime: DateTime(
            currentDate.year, currentDate.month, currentDate.day, 2, 0),
        isAvailable: true));
    timeBlocks.add(TimeBlock(
        dateTime: DateTime(
            currentDate.year, currentDate.month, currentDate.day, 2, 30),
        isAvailable: true));
    timeBlocks.add(TimeBlock(
        dateTime: DateTime(
            currentDate.year, currentDate.month, currentDate.day, 3, 0),
        isAvailable: true));
    timeBlocks.add(TimeBlock(
        dateTime: DateTime(
            currentDate.year, currentDate.month, currentDate.day, 3, 30),
        isAvailable: true));
    timeBlocks.add(TimeBlock(
        dateTime: DateTime(
            currentDate.year, currentDate.month, currentDate.day, 4, 0),
        isAvailable: true));
    timeBlocks.add(TimeBlock(
        dateTime: DateTime(
            currentDate.year, currentDate.month, currentDate.day, 4, 30),
        isAvailable: true));
    timeBlocks.add(TimeBlock(
        dateTime: DateTime(
            currentDate.year, currentDate.month, currentDate.day, 5, 0),
        isAvailable: true));
    timeBlocks.add(TimeBlock(
        dateTime: DateTime(
            currentDate.year, currentDate.month, currentDate.day, 5, 30),
        isAvailable: true));
    timeBlocks.add(TimeBlock(
        dateTime: DateTime(
            currentDate.year, currentDate.month, currentDate.day, 6, 0),
        isAvailable: true));
    timeBlocks.add(TimeBlock(
        dateTime: DateTime(
            currentDate.year, currentDate.month, currentDate.day, 6, 30),
        isAvailable: true));
    timeBlocks.add(TimeBlock(
        dateTime: DateTime(
            currentDate.year, currentDate.month, currentDate.day, 7, 0),
        isAvailable: true));
    timeBlocks.add(TimeBlock(
        dateTime: DateTime(
            currentDate.year, currentDate.month, currentDate.day, 7, 30),
        isAvailable: true));
    timeBlocks.add(TimeBlock(
        dateTime: DateTime(
            currentDate.year, currentDate.month, currentDate.day, 8, 0),
        isAvailable: true));
    timeBlocks.add(TimeBlock(
        dateTime: DateTime(
            currentDate.year, currentDate.month, currentDate.day, 8, 30),
        isAvailable: true));
    timeBlocks.add(TimeBlock(
        dateTime: DateTime(
            currentDate.year, currentDate.month, currentDate.day, 9, 0),
        isAvailable: true));
    timeBlocks.add(TimeBlock(
        dateTime: DateTime(
            currentDate.year, currentDate.month, currentDate.day, 9, 30),
        isAvailable: true));
    timeBlocks.add(TimeBlock(
        dateTime: DateTime(
            currentDate.year, currentDate.month, currentDate.day, 10, 0),
        isAvailable: true));
    timeBlocks.add(TimeBlock(
        dateTime: DateTime(
            currentDate.year, currentDate.month, currentDate.day, 10, 30),
        isAvailable: true));
    timeBlocks.add(TimeBlock(
        dateTime: DateTime(
            currentDate.year, currentDate.month, currentDate.day, 11, 0),
        isAvailable: true));
    timeBlocks.add(TimeBlock(
        dateTime: DateTime(
            currentDate.year, currentDate.month, currentDate.day, 11, 30),
        isAvailable: true));
    timeBlocks.add(TimeBlock(
        dateTime: DateTime(
            currentDate.year, currentDate.month, currentDate.day, 12, 0),
        isAvailable: true));
    timeBlocks.add(TimeBlock(
        dateTime: DateTime(
            currentDate.year, currentDate.month, currentDate.day, 12, 30),
        isAvailable: true));
    timeBlocks.add(TimeBlock(
        dateTime: DateTime(
            currentDate.year, currentDate.month, currentDate.day, 13, 0),
        isAvailable: true));
    timeBlocks.add(TimeBlock(
        dateTime: DateTime(
            currentDate.year, currentDate.month, currentDate.day, 13, 30),
        isAvailable: true));
    timeBlocks.add(TimeBlock(
        dateTime: DateTime(
            currentDate.year, currentDate.month, currentDate.day, 14, 0),
        isAvailable: true));
    timeBlocks.add(TimeBlock(
        dateTime: DateTime(
            currentDate.year, currentDate.month, currentDate.day, 14, 30),
        isAvailable: true));
    timeBlocks.add(TimeBlock(
        dateTime: DateTime(
            currentDate.year, currentDate.month, currentDate.day, 15, 0),
        isAvailable: true));
    timeBlocks.add(TimeBlock(
        dateTime: DateTime(
            currentDate.year, currentDate.month, currentDate.day, 15, 30),
        isAvailable: true));
    timeBlocks.add(TimeBlock(
        dateTime: DateTime(
            currentDate.year, currentDate.month, currentDate.day, 16, 0),
        isAvailable: true));
    timeBlocks.add(TimeBlock(
        dateTime: DateTime(
            currentDate.year, currentDate.month, currentDate.day, 16, 30),
        isAvailable: true));
    timeBlocks.add(TimeBlock(
        dateTime: DateTime(
            currentDate.year, currentDate.month, currentDate.day, 17, 0),
        isAvailable: true));
    timeBlocks.add(TimeBlock(
        dateTime: DateTime(
            currentDate.year, currentDate.month, currentDate.day, 17, 30),
        isAvailable: true));
    timeBlocks.add(TimeBlock(
        dateTime: DateTime(
            currentDate.year, currentDate.month, currentDate.day, 18, 0),
        isAvailable: true));
    timeBlocks.add(TimeBlock(
        dateTime: DateTime(
            currentDate.year, currentDate.month, currentDate.day, 18, 30),
        isAvailable: true));
    timeBlocks.add(TimeBlock(
        dateTime: DateTime(
            currentDate.year, currentDate.month, currentDate.day, 19, 0),
        isAvailable: true));
    timeBlocks.add(TimeBlock(
        dateTime: DateTime(
            currentDate.year, currentDate.month, currentDate.day, 19, 30),
        isAvailable: true));
    timeBlocks.add(TimeBlock(
        dateTime: DateTime(
            currentDate.year, currentDate.month, currentDate.day, 20, 0),
        isAvailable: true));
    timeBlocks.add(TimeBlock(
        dateTime: DateTime(
            currentDate.year, currentDate.month, currentDate.day, 20, 30),
        isAvailable: true));
    timeBlocks.add(TimeBlock(
        dateTime: DateTime(
            currentDate.year, currentDate.month, currentDate.day, 21, 0),
        isAvailable: true));
    timeBlocks.add(TimeBlock(
        dateTime: DateTime(
            currentDate.year, currentDate.month, currentDate.day, 21, 30),
        isAvailable: true));
    timeBlocks.add(TimeBlock(
        dateTime: DateTime(
            currentDate.year, currentDate.month, currentDate.day, 22, 0),
        isAvailable: true));
    timeBlocks.add(TimeBlock(
        dateTime: DateTime(
            currentDate.year, currentDate.month, currentDate.day, 22, 30),
        isAvailable: true));
    timeBlocks.add(TimeBlock(
        dateTime: DateTime(
            currentDate.year, currentDate.month, currentDate.day, 23, 0),
        isAvailable: true));
    timeBlocks.add(TimeBlock(
        dateTime: DateTime(
            currentDate.year, currentDate.month, currentDate.day, 23, 30),
        isAvailable: true));
    if (selectedTimeBlock == null) {
      selectedTimeBlock = TimeBlock();
      selectedTimeBlock!.dateTime = widget.appointment.date;
      selectedTimeBlock!.isAvailable = true;
      previousTimeBlock = selectedTimeBlock;
    }
  }

  dynamic timeBlockResponse;

  Future loadTeeth() async {
    teethBottomLeft = [];
    teethBottomRight = [];
    teethTopLeft = [];
    teethTopRight = [];

    final response =
        await postData("$ServerIP/api/protected/GetPatientTeethMap", {
      "patient_id": widget.appointment.patientID,
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
          appointment.price = double.parse(appointmentJSON["price"].toString());
          appointment.condition.color = appointmentJSON["hex_color"] == ""
              ? Colors.white
              : HexColor.fromHex(appointmentJSON["hex_color"]);
          appointment.isCompleted = false;
          appointment.isPaid = appointmentJSON["is_paid"];
          appointment.toothID = appointmentJSON["tooth_id"];
          appointment.toothCode = appointmentJSON["tooth_code"];
          appointment.condition.name = appointmentJSON["treatment"];
          tooth.uncompletedAppointments.add(appointment);
        }
        tooth.condition.color = Colors.grey[600];
      }
      tooth.isTreated = obj["is_treated"];
      if (tooth.toothCode[1] == "B" && tooth.toothCode[0] == "L") {
        Uint8List? imageBytes;
        if (tooth.id == selectedToothID) {
          imageBytes = await returnColoredTooth(
            "assets/images/teeth/${tooth.toothCode[1]}${int.parse(tooth.toothCode[2])}_Colored.png",
            Colors.blue,
          );
        }
        teethBottomLeft.add(
          InkWell(
            key: key,
            onTap: () async {
              selectedToothID = tooth.id;
              await loadTeeth();
              setState(() {});
            },
            child: imageBytes == null
                ? Image.asset(
                    "assets/images/teeth/${tooth.toothCode[1]}${int.parse(tooth.toothCode[2])}.png",
                    scale: scale!,
                  )
                : Image.memory(
                    imageBytes,
                    scale: scale!,
                  ),
          ),
        );
      }
      if (tooth.toothCode[1] == "B" && tooth.toothCode[0] == "R") {
        Uint8List? imageBytes;
        if (tooth.id == selectedToothID) {
          imageBytes = await returnColoredTooth(
            "assets/images/teeth/${tooth.toothCode.substring(1)}_Colored.png",
            Colors.blue,
          );
        }
        teethBottomRight.add(
          InkWell(
            key: key,
            onTap: () async {
              selectedToothID = tooth.id;
              await loadTeeth();
              setState(() {});
            },
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(math.pi),
              child: imageBytes == null
                  ? Image.asset(
                      "assets/images/teeth/${tooth.toothCode.substring(1)}.png",
                      scale: scale!,
                    )
                  : Image.memory(
                      imageBytes,
                      scale: scale!,
                    ),
            ),
          ),
        );
      }
      if (tooth.toothCode[1] == "T" && tooth.toothCode[0] == "L") {
        Uint8List? imageBytes;
        if (tooth.id == selectedToothID) {
          imageBytes = await returnColoredTooth(
            "assets/images/teeth/${tooth.toothCode.substring(1)}_Colored.png",
            Colors.blue,
          );
        }
        teethTopLeft.add(
          InkWell(
            key: key,
            onTap: () async {
              selectedToothID = tooth.id;
              await loadTeeth();
              setState(() {});
            },
            child: imageBytes == null
                ? Image.asset(
                    "assets/images/teeth/${tooth.toothCode.substring(1)}.png",
                    scale: scale!,
                  )
                : Image.memory(
                    imageBytes,
                    scale: scale!,
                  ),
          ),
        );
      }
      if (tooth.toothCode[1] == "T" && tooth.toothCode[0] == "R") {
        Uint8List? imageBytes;
        if (tooth.id == selectedToothID) {
          imageBytes = await returnColoredTooth(
            "assets/images/teeth/${tooth.toothCode[1]}${int.parse(tooth.toothCode[2])}_Colored.png",
            Colors.blue,
          );
        }
        teethTopRight.add(
          InkWell(
            key: key,
            onTap: () async {
              selectedToothID = tooth.id;
              await loadTeeth();
              setState(() {});
            },
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(math.pi),
              child: imageBytes == null
                  ? Image.asset(
                      "assets/images/teeth/${tooth.toothCode[1]}${int.parse(tooth.toothCode[2])}.png",
                      scale: scale!,
                    )
                  : Image.memory(
                      imageBytes,
                      scale: scale!,
                    ),
            ),
          ),
        );
      }
    }
  }

  Future<String> loadData() async {
    if (isWorkingHoursLoaded) {
      return "";
    }
    var response = await getData("$ServerIP/api/protected/GetDoctorSchedule");
    // print(response);
    timeBlockResponse = response["schedule"]["time_blocks"];
    // for (var timeBlock in timeBlockResponse) {
    //   var dateTime =
    //       intl.DateFormat("yyyy/MM/dd & h:mm a").parse(timeBlock["date"]);
    //   try {
    //     timeBlocks.firstWhere((element) {
    //       return element.dateTime == dateTime;
    //     }).isAvailable = false;
    //   } catch (e) {}
    // }
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
    selectedCondition = widget.appointment.condition;
    selectedToothID = widget.appointment.toothID;
    isWorkingHoursLoaded = true;
    await loadTeeth();
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
      appBar: const CustomAppBar(
        title: "Edit Appointment",
        actions: null,
      ),
      body: FutureBuilder(
        future: loadData(),
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
          loadBlocks();
          for (var timeBlock in timeBlockResponse) {
            var dateTime =
                intl.DateFormat("yyyy/MM/dd & h:mm a").parse(timeBlock["date"]);
            try {
              if (dateTime != previousTimeBlock!.dateTime) {
                timeBlocks.firstWhere((element) {
                  return element.dateTime == dateTime;
                }).isAvailable = false;
              }
            } catch (e) {
              //
            }
          }
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 15.0),
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
                    selectedItem: selectedCondition!.name,
                    onChanged: (item) => selectedCondition = conditions
                        .firstWhere((element) => element.name == item),
                  ),
                ),
                SizedBox(
                  height: 400,
                  child: Card(
                    color: const Color(0xFFF1F3FF),
                    elevation: 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              intl.DateFormat("yyyy/MM/dd").format(currentDate),
                              style: GoogleFonts.jost(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GridView.builder(
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 2,
                              mainAxisSpacing: 10,
                            ),
                            itemBuilder: (context, index) => Opacity(
                              opacity: timeBlocks[index].isAvailable! ? 1 : 0.6,
                              child: GestureDetector(
                                onTap: () {
                                  timeBlocks[index].isAvailable!
                                      ? {
                                          setState(() {
                                            selectedTimeBlock =
                                                timeBlocks[index];
                                          })
                                        }
                                      : {};
                                },
                                child: SizedBox(
                                  height: 50,
                                  child: Card(
                                    color: selectedTimeBlock!.dateTime! ==
                                            timeBlocks[index].dateTime
                                        ? Theme.of(context).primaryColor
                                        : const Color(0xFFFEFEFE),
                                    elevation: 2,
                                    child: Center(
                                      child: Text(
                                        intl.DateFormat("h:mm a").format(
                                            timeBlocks[index].dateTime!),
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: selectedTimeBlock!.dateTime! ==
                                                  timeBlocks[index].dateTime
                                              ? Colors.white
                                              : null,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            itemCount: timeBlocks.length,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            DateTime? returnedDate = await showDatePicker(
                                context: context,
                                initialDate: currentDate,
                                firstDate: DateTime.now()
                                    .subtract(const Duration(days: 365 * 30)),
                                lastDate: DateTime.now()
                                    .add(const Duration(days: 365 * 30)));
                            if (returnedDate != null) {
                              currentDate = returnedDate;
                              selectedDate = returnedDate;
                              setState(() {});
                            }
                          },
                          icon: const Icon(Icons.calendar_month_rounded),
                        ),
                      ],
                    ),
                  ),
                ),
                // Center(
                //   child: SingleChildScrollView(
                //     scrollDirection: Axis.horizontal,
                //     child: Row(
                //       children: teethTopLeft.reversed.toList() + teethTopRight,
                //     ),
                //   ),
                // ),
                // const SizedBox(height: 30),
                // Center(
                //   child: SingleChildScrollView(
                //     scrollDirection: Axis.horizontal,
                //     child: Row(
                //       children:
                //           teethBottomLeft.reversed.toList() + teethBottomRight,
                //     ),
                //   ),
                // ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          dialogContext = context;
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: SizedBox(
                              height: 400,
                              width: double.infinity,
                              child: Center(
                                // Display lottie animation
                                child: Lottie.asset(
                                  "assets/lottie/Loading.json",
                                  height: 200,
                                  width: 200,
                                ),
                              ),
                            ),
                          );
                        });
                    try {
                      DateTime? finalDateTime = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        selectedTimeBlock!.dateTime!.hour,
                        selectedTimeBlock!.dateTime!.minute,
                      );
                      var response = await postData(
                          "$ServerIP/api/protected/EditAppointment", {
                        "ID": widget.appointment.id,
                        "date": intl.DateFormat("yyyy/MM/dd & h:mm a")
                            .format(finalDateTime),
                        "patient_id": widget.appointment.patientID,
                        "condition_id": selectedCondition!.id,
                        // "treatment": widget.tooth.condition.name,
                        // "price": widget.tooth.condition.price,
                        "tooth_id": widget.appointment.toothID,
                        // "hex_color": widget.tooth.condition.color!.toHex(),
                      }).timeout(const Duration(seconds: 5));

                      if (response["message"] == "Updated Successfully") {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              dialogContext = context;
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
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
                                            "assets/lottie/Success.json",
                                            height: 300,
                                            width: 300,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            Navigator.pop(dialogContext);
                                          });
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  const HomeScreen(),
                                            ),
                                          );
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
                      } else {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              dialogContext = context;
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
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
                    } catch (e) {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            dialogContext = context;
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
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
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Save",
                          style: GoogleFonts.jost(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(
                          Icons.save_rounded,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
