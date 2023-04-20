// ignore_for_file: use_build_context_synchronously

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

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key, required this.openDrawer});
  final Function openDrawer;
  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  List<Patient> favouritePatients = [];
  List<Condition> conditions = [];
  bool isLoaded = false;
  @override
  void initState() {
    favouritePatients.clear();
    conditions.clear();
    isLoaded = false;
    super.initState();
  }

  Future<String> loadPatients() async {
    if (!isLoaded) {
      dynamic response;
      dynamic treatmentsResponse;
      bool isOnline = await isConnected();
      if (isOnline) {
        response = await getData(
            "$ServerIP/api/protected/GetFavouritePatients", context);
        treatmentsResponse = await getData(
            "$ServerIP/api/protected/GetDoctorTreatments", context);
        await SetJSON(response, "Favourites");
        await SetJSON(treatmentsResponse, "Treatments");
      } else {
        response = await GetJSON("Favourites");
        response = json.decode(response);
        treatmentsResponse = await GetJSON("Treatments");
        treatmentsResponse = json.decode(treatmentsResponse);
      }
      if (response == null || response.isEmpty) {
        return "Empty";
      }
      conditions.add(Condition(name: "None", price: 0.0, color: Colors.white));
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

      for (var obj in response) {
        Patient patient = Patient();
        TeethMap teethMap = TeethMap();
        patient.id = obj["ID"];
        patient.doctorID = obj["doctor_id"];
        patient.name = obj["name"];
        patient.address = obj["address"];
        patient.phone = obj["phone"];
        patient.gender = obj["gender"];
        patient.age = obj["age"];
        patient.isFavourite = obj["is_favourite"];
        List<dynamic> teeth = obj["patient_teeth_map"]["teeth"];
        teeth.sort((a, b) => a["tooth_code"].compareTo(b["tooth_code"]));
        for (var obj in teeth) {
          Tooth tooth = Tooth();
          tooth.id = obj["ID"];
          tooth.toothCode = obj["tooth_code"];
          tooth.condition.name = obj["condition"];
          tooth.condition.id = obj["condition_id"];
          if (tooth.condition.id != 0) {
            tooth.condition.price = conditions
                .firstWhere((element) => element.id == tooth.condition.id)
                .price;
          }
          tooth.condition.color = obj["hex_color"] == ""
              ? Colors.white
              : HexColor.fromHex(obj["hex_color"]);
          if (obj["uncompleted_appointments"] != null) {
            for (var appointmentJSON in obj["uncompleted_appointments"]) {
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
          tooth.isTreated = obj["is_treated"];
          teethMap.teeth.add(tooth);
        }
        patient.teethMap = teethMap;
        favouritePatients.add(patient);
      }
      isLoaded = true;
      // setState(() {});
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Favourites",
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () async {
                final bool response = await Logout(context);
                if (response) {
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
          future: loadPatients(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Lottie.asset(
                  "assets/lottie/Loading.json",
                  height: 200,
                  width: 200,
                ),
              );
            } else if (snapshot.data == "Empty") {
              return const Center(
                child: Opacity(
                  opacity: 0.5,
                  child: Text(
                    "No Favourites Exist",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                  ),
                ),
              );
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  ...List.generate(
                    favouritePatients.length,
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
                                        patient: favouritePatients[index],
                                        conditions: conditions,
                                      )));
                        },
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 5.0,
                          ),
                          title: Text(
                            favouritePatients[index].name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          subtitle: Text(
                            favouritePatients[index].gender,
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
            );
          }),
    );
  }
}
