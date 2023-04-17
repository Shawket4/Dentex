import 'package:dentex/components/app_bar.dart';
import 'package:dentex/dio_helper.dart';
import 'package:dentex/main.dart';
import 'package:dentex/models/patient.dart';
import 'package:dentex/screens/login_screen.dart';
import 'package:dentex/screens/patient_details.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key, required this.openDrawer});
  final Function openDrawer;
  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  List<Patient> favouritePatients = [];
  bool isLoaded = false;
  @override
  void initState() {
    favouritePatients.clear();
    isLoaded = false;
    super.initState();
  }

  Future<String> loadPatients() async {
    if (!isLoaded) {
      var response = await getData(
          "$ServerIP/api/protected/GetFavouritePatients", context);
      if (response == null) {
        return "Empty";
      }
      for (var obj in response) {
        Patient patient = Patient();
        patient.id = obj["ID"];
        patient.doctorID = obj["doctor_id"];
        patient.name = obj["name"];
        patient.address = obj["address"];
        patient.phone = obj["phone"];
        patient.gender = obj["gender"];
        patient.age = obj["age"];
        patient.isFavourite = obj["is_favourite"];
        favouritePatients.add(patient);
      }
      isLoaded = true;
    }

    // setState(() {});
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
                                      patientID: favouritePatients[index].id)));
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
