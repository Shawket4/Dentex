import 'package:clinic_management/components/app_bar.dart';
import 'package:clinic_management/dio_helper.dart';
import 'package:clinic_management/main.dart';
import 'package:clinic_management/models/patient.dart';
import 'package:clinic_management/screens/login_page.dart';
import 'package:flutter/material.dart';

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
                controller: searchController,
                decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF011627),
                      width: 2.0,
                    ),
                  ),
                  border: OutlineInputBorder(),
                  labelText: "Search",
                  hintText: "Search Patients",
                  hintStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                  ),
                  labelStyle: TextStyle(
                    color: Color(0xFF011627),
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...List.generate(
                      foundPatients.length,
                      (index) => ListTile(
                        title: Text(
                          foundPatients[index].name,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                var response =
                    await postData("$ServerIP/api/protected/Search", {
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
                setState(() {});
              },
              child: const Text("Search"),
            )
          ],
        ),
      ),
    );
  }
}
