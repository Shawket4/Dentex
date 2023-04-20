import 'package:dentex/components/app_bar.dart';
import 'package:dentex/dio_helper.dart';
import 'package:dentex/main.dart';
import 'package:dentex/models/appointment.dart';
import 'package:dentex/models/patient.dart';
import 'package:dentex/screens/login_screen.dart';
import 'package:dentex/screens/patient_details.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:convert';
import 'package:intl/intl.dart' as intl;

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.openDrawer});
  final Function openDrawer;
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  List<Condition> conditions = [];
  @override
  void initState() {
    foundPatients.clear();
    searchController.clear();
    super.initState();
  }

  List<Patient> foundPatients = [];
  bool isSearching = false;
  Future<String> loadTreatments() async {
    dynamic treatmentsResponse = await GetJSON("Treatments");
    treatmentsResponse = json.decode(treatmentsResponse);
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
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Search",
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () async {
                final bool response = await Logout(context);
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
        future: loadTreatments(),
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
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    autocorrect: false,
                    onSubmitted: (value) {
                      searchCallback();
                    },
                    controller: searchController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search_rounded),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color(0xFF011627),
                          width: 2.0,
                        ),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          searchController.clear();
                        },
                        icon: const Icon(Icons.clear_rounded),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      labelText: "Search",
                      hintText: "Search Patients",
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                      labelStyle: const TextStyle(
                        color: Color(0xFF011627),
                      ),
                    ),
                  ),
                ),
                isSearching
                    ? Align(
                        alignment: Alignment.center,
                        child: Lottie.asset(
                          "assets/lottie/Searching.json",
                          height: 350,
                          width: 350,
                        ),
                      )
                    : SingleChildScrollView(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...List.generate(
                                foundPatients.length,
                                (index) => Card(
                                  elevation: 8.0,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 4.0),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => PatientDetailScreen(
                                            patient: foundPatients[index],
                                            conditions: conditions,
                                          ),
                                        ),
                                      );
                                    },
                                    child: ListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 20.0,
                                        vertical: 5.0,
                                      ),
                                      title: Text(
                                        foundPatients[index].name,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      subtitle: Text(
                                        foundPatients[index].gender,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      trailing: Icon(
                                        Icons.keyboard_arrow_right_rounded,
                                        color: Theme.of(context).primaryColor,
                                        size: 40.0,
                                      ),
                                    ),
                                  ),
                                ),
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

  void searchCallback() async {
    setState(() {
      isSearching = true;
    });
    var response = await postData(
        "$ServerIP/api/protected/Search",
        {
          "query": searchController.text,
        },
        context);
    foundPatients.clear();
    for (var obj in response) {
      Patient patient = Patient();
      patient.id = obj["ID"];
      patient.doctorID = obj["doctor_id"];
      patient.name = obj["name"];
      patient.address = obj["address"];
      patient.phone = obj["phone"];
      patient.gender = obj["gender"];
      patient.age = obj["age"];
      List<dynamic> teeth = obj["patient_teeth_map"]["teeth"];
      teeth.sort((a, b) => a["tooth_code"].compareTo(b["tooth_code"]));
      conditions.add(Condition(name: "None", price: 0.0, color: Colors.white));
      for (var objTooth in teeth) {
        Tooth tooth = Tooth();
        tooth.id = objTooth["ID"];
        tooth.toothCode = objTooth["tooth_code"];
        tooth.condition.name = objTooth["condition"];
        tooth.condition.id = objTooth["condition_id"];
        if (tooth.condition.id != 0) {
          tooth.condition.price = conditions
              .firstWhere((element) => element.id == tooth.condition.id)
              .price;
        }

        tooth.condition.color = objTooth["hex_color"] == ""
            ? Colors.white
            : HexColor.fromHex(objTooth["hex_color"]);
        if (objTooth["uncompleted_appointments"] != null) {
          for (var appointmentJSON in objTooth["uncompleted_appointments"]) {
            Appointment appointment = Appointment();
            appointment.id = appointmentJSON["ID"];
            appointment.date = intl.DateFormat("yyyy/MM/dd & h:mm a")
                .parse(appointmentJSON["date"]);
            appointment.patientID = appointmentJSON["patient"]["id"];
            appointment.patientName = appointmentJSON["patient"]["name"];
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
        tooth.isTreated = objTooth["is_treated"];
        patient.teethMap.teeth.add(tooth);
      }
      foundPatients.add(patient);
    }
    setState(() {
      isSearching = false;
    });
  }
}
