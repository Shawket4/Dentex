// ignore_for_file: use_build_context_synchronously

import 'package:dentex/dio_helper.dart';
import 'package:dentex/main.dart';
import 'package:dentex/models/patient.dart';
import 'package:dentex/models/time_block.dart';
import 'package:dentex/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart' as intl;

class MakeAppointmentScreen extends StatefulWidget {
  const MakeAppointmentScreen(
      {super.key, required this.tooth, required this.patient});
  final Tooth tooth;
  final Patient patient;

  @override
  State<MakeAppointmentScreen> createState() => MakeAppointmentScreenState();
}

class MakeAppointmentScreenState extends State<MakeAppointmentScreen> {
  bool isWorkingHoursLoaded = false;
  List<TimeBlock> timeBlocks = [];
  TimeBlock? selectedTimeBlock;
  DateTime selectedDate = DateTime.now();
  late BuildContext dialogContext;
  DateTime currentDate = DateTime.now();
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
    selectedTimeBlock ??= timeBlocks[0];
  }

  @override
  void initState() {
    isWorkingHoursLoaded = false;

    // loadBlocks();
    super.initState();
  }

  dynamic timeBlockResponse;
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
    isWorkingHoursLoaded = true;
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF011627),
        title: const Text(
          "Make Appointment",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
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
              var dateTime = intl.DateFormat("yyyy/MM/dd & h:mm a")
                  .parse(timeBlock["date"]);
              try {
                timeBlocks.firstWhere((element) {
                  return element.dateTime == dateTime;
                }).isAvailable = false;
              } catch (e) {
                //
              }
            }
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    width: double.infinity,
                    height: 600,
                    child: Card(
                      color: const Color(0xFFF1F3FF),
                      elevation: 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                                opacity:
                                    timeBlocks[index].isAvailable! ? 1 : 0.6,
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
                                            color: selectedTimeBlock!
                                                        .dateTime! ==
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
                                  initialDate: DateTime.now(),
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
                          )
                        ],
                      ),
                    ),
                  ),
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
                            "$ServerIP/api/protected/RegisterAppointment", {
                          "date": intl.DateFormat("yyyy/MM/dd & h:mm a")
                              .format(finalDateTime),
                          "doctor_id": widget.patient.doctorID,
                          "patient_id": widget.patient.id,
                          "treatment": widget.tooth.condition.name,
                          "price": widget.tooth.condition.price,
                          "tooth_id": widget.tooth.id,
                          "hex_color": widget.tooth.condition.color!.toHex(),
                        }).timeout(const Duration(seconds: 5));

                        if (response["message"] == "Registered Successfully") {
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                        children: const [
                          Text(
                            "Save",
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
                ],
              ),
            );
          }),
    );
  }
}
