import 'package:dentex/components/app_bar.dart';
import 'package:dentex/dio_helper.dart';
import 'package:dentex/main.dart';
import 'package:dentex/models/patient.dart';
import 'package:dentex/screens/login_screen.dart';
import 'package:dentex/screens/patient_details.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.openDrawer});
  final Function openDrawer;
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    foundPatients.clear();
    searchController.clear();
    super.initState();
  }

  List<Patient> foundPatients = [];
  bool isSearching = false;
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
                final bool response = await Logout;
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
      body: SingleChildScrollView(
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
                                              patientID:
                                                  foundPatients[index].id)));
                                },
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
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
      ),
    );
  }

  void searchCallback() async {
    setState(() {
      isSearching = true;
    });
    var response = await postData("$ServerIP/api/protected/Search", {
      "query": searchController.text,
    });
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
      foundPatients.add(patient);
    }
    setState(() {
      isSearching = false;
    });
  }
}
