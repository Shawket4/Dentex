// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:clinic_management/dio_helper.dart';
import 'package:clinic_management/models/doctor.dart';
import 'package:clinic_management/models/patient.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:clinic_management/screens/home_screen.dart';
import 'package:lottie/lottie.dart';
import '../main.dart';

class AddAppointmentScreen extends StatefulWidget {
  const AddAppointmentScreen({super.key});

  @override
  State<AddAppointmentScreen> createState() => _AddAppointmentScreenState();
}

class _AddAppointmentScreenState extends State<AddAppointmentScreen> {
  TextEditingController treatment = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController dateTime = TextEditingController();
  DateTime? appointmentDateTime;
  late BuildContext dialogContext;
  List<Patient> patients = [];
  Patient selectedPatient = Patient();
  List<Doctor> doctors = [];
  Doctor selectedDoctor = Doctor();
  @override
  void initState() {
    if (userInfo.permission == 2) {
      getData("$ServerIP/api/protected/GetDoctorPatients").then((response) {
        for (var obj in response) {
          Patient patient = Patient();
          patient.name = obj["name"];
          patient.id = obj["ID"];
          patients.add(patient);
        }
        selectedPatient = patients[0];
      });
      getData("$ServerIP/api/admin/GetAllDoctors").then((response) {
        for (var obj in response) {
          Doctor doctor = Doctor();
          doctor.name = obj["name"];
          doctor.id = obj["user_id"];
          doctors.add(doctor);
        }
        selectedDoctor = doctors[0];
        setState(() {});
      });
    } else {
      getData("$ServerIP/api/protected/GetDoctorPatients").then((response) {
        for (var obj in response) {
          Patient patient = Patient();
          patient.name = obj["name"];
          patient.id = obj["ID"];
          patients.add(patient);
        }
        selectedPatient = patients[0];
        setState(() {});
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFFFC),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF011627),
        title: const Text(
          "Add Appointment",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            const SizedBox(
              height: 50,
            ),
            userInfo.permission == 2
                ? Padding(
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
                        labelText: "Doctor*",
                        labelStyle: TextStyle(
                          color: Color(0xFF0b132b),
                        ),
                      ),
                      mode: Mode.MENU,
                      showSelectedItems: true,
                      showSearchBox: true,
                      enabled: true,
                      items: doctors.map((e) => e.name).toList(),
                      selectedItem: selectedDoctor.name,
                      onChanged: (item) => setState(() {
                        selectedDoctor = doctors
                            .firstWhere((element) => element.name == item);
                      }),
                    ),
                  )
                : Container(),
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
                  labelText: "Patient*",
                  labelStyle: TextStyle(
                    color: Color(0xFF0b132b),
                  ),
                ),
                mode: Mode.MENU,
                showSelectedItems: true,
                showSearchBox: true,
                enabled: true,
                items: patients.map((e) => e.name).toList(),
                selectedItem: selectedPatient.name,
                onChanged: (item) => setState(() {
                  selectedPatient =
                      patients.firstWhere((element) => element.name == item);
                }),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                autocorrect: false,
                controller: treatment,
                decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF011627),
                      width: 2.0,
                    ),
                  ),
                  border: OutlineInputBorder(),
                  labelText: 'Treatment',
                  labelStyle: TextStyle(
                    color: Color(0xFF011627),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                autocorrect: false,
                controller: price,
                decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF011627),
                      width: 2.0,
                    ),
                  ),
                  border: OutlineInputBorder(),
                  labelText: 'Price',
                  labelStyle: TextStyle(
                    color: Color(0xFF011627),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                DateTime? pickDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2099));
                if (pickDate != null) {
                  appointmentDateTime = pickDate;
                }
                TimeOfDay? pickTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay(
                    hour: appointmentDateTime!.hour,
                    minute: appointmentDateTime!.minute,
                  ),
                );
                if (pickTime != null) {
                  appointmentDateTime = DateTime(
                    appointmentDateTime!.year,
                    appointmentDateTime!.month,
                    appointmentDateTime!.day,
                    pickTime.hour,
                    pickTime.minute,
                  );
                }
                setState(() {
                  dateTime.text = appointmentDateTime.toString();
                });
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  enabled: false,
                  autocorrect: false,
                  controller: dateTime,
                  decoration: InputDecoration(
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF011627),
                        width: 2.0,
                      ),
                    ),
                    suffixIcon: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.calendar_month_rounded,
                          color: Color(0xFF011627),
                        )),
                    border: const OutlineInputBorder(),
                    labelText: 'Date & Time',
                    labelStyle: const TextStyle(
                      color: Color(0xFF011627),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF011627)),
                  child: const Text(
                    "Add",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                      var response = await dio.post(
                          "`$ServerIP/api/protected/RegisterAppointment`",
                          data: {
                            "date": dateTime.text,
                            "doctor_id": selectedDoctor.id,
                            "patient_id": selectedPatient.id,
                            "treatment": treatment.text,
                            "price": double.parse(price.text),
                          }).timeout(const Duration(seconds: 5));
                      if (response.data["message"] ==
                          "Registered Successfully") {
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
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
