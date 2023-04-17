import 'package:dentex/components/app_bar.dart';
import 'package:dentex/dio_helper.dart';
import 'package:dentex/main.dart';
import 'package:dentex/models/patient.dart';
import 'package:dentex/screens/treatment_details.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DoctorTreatmentScreen extends StatefulWidget {
  const DoctorTreatmentScreen({super.key});
  @override
  State<DoctorTreatmentScreen> createState() => _DoctorTreatmentScreenState();
}

class _DoctorTreatmentScreenState extends State<DoctorTreatmentScreen> {
  List<Condition> doctorTreatments = [];
  bool isLoaded = false;
  @override
  void initState() {
    doctorTreatments.clear();
    isLoaded = false;
    super.initState();
  }

  Future<String> loadPatients() async {
    if (!isLoaded) {
      var treatmentsResponse =
          await getData("$ServerIP/api/protected/GetDoctorTreatments", context);
      if (treatmentsResponse.isEmpty) {
        return "Empty";
      }
      for (var obj in treatmentsResponse) {
        Condition treatment = Condition();
        treatment.id = obj["ID"];
        treatment.name = obj["name"];
        treatment.price = double.parse(obj["price"].toString());
        treatment.color = obj["hex_color"] == ""
            ? Colors.white
            : HexColor.fromHex(obj["hex_color"]);
        doctorTreatments.add(treatment);
      }
      isLoaded = true;
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9),
      appBar: const CustomAppBar(
        title: "My Treatments",
        actions: null,
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
                    "No Treatments Exist",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
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
                    doctorTreatments.length,
                    (index) => Card(
                      elevation: 8.0,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 4.0),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TreatmentDetailScreen(
                                treatment: doctorTreatments[index],
                              ),
                            ),
                          );
                        },
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 5.0,
                          ),
                          title: Text(
                            doctorTreatments[index].name!,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          subtitle: Text(
                            "${doctorTreatments[index].price} LE",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          trailing: Icon(
                            Icons.keyboard_arrow_right_rounded,
                            color: doctorTreatments[index].color,
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
