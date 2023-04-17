import 'package:dentex/components/app_bar.dart';
import 'package:dentex/dio_helper.dart';
import 'package:dentex/main.dart';
import 'package:dentex/models/doctor.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ManageUserScreen extends StatefulWidget {
  const ManageUserScreen({super.key});

  @override
  State<ManageUserScreen> createState() => _ManageUserScreenState();
}

class _ManageUserScreenState extends State<ManageUserScreen> {
  List<Doctor> doctors = [];
  bool isLoaded = false;
  Future<String> get loadData async {
    if (isLoaded) {
      return "";
    }
    var response =
        await getData("$ServerIP/api/admin/ReturnAllDoctors", context);
    if (response == null || response.isEmpty) {
      isLoaded = true;
      return "Empty";
    } else {
      for (var obj in response) {
        Doctor doctor = Doctor().fromJSON(obj);
        doctors.add(doctor);
      }
      isLoaded = true;
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9),
      appBar: const CustomAppBar(
        title: "Manage Users",
        actions: null,
      ),
      body: FutureBuilder(
        future: loadData,
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
                  "No Users Exist",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ),
            );
          }
          return ListView(
            children: <Widget>[
              ...List.generate(
                doctors.length,
                (index) => Card(
                  elevation: 8.0,
                  margin: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 4.0),
                  child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 5.0,
                      ),
                      title: Text(
                        doctors[index].name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      subtitle: Text(
                        "Status Frozen: ${doctors[index].isFrozen}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: Checkbox(
                        value: doctors[index].isFrozen,
                        onChanged: (value) async {
                          var response = await postData(
                              "$ServerIP/api/admin/ChangeDoctorState",
                              {
                                "doctor_id": doctors[index].id,
                              },
                              context);
                          if (response["message"] ==
                              "User Changed Successfully") {
                            setState(() {});
                            doctors[index].isFrozen = !doctors[index].isFrozen;
                          }
                        },
                      )),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
