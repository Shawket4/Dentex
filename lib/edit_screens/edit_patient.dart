// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:dentex/models/patient.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:dentex/screens/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:dentex/main.dart';

class EditPatientScreen extends StatefulWidget {
  const EditPatientScreen({super.key, required this.patient});
  final Patient patient;
  @override
  State<EditPatientScreen> createState() => _EditPatientScreenState();
}

class _EditPatientScreenState extends State<EditPatientScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController patient_addr = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController age = TextEditingController();

  List<String> genderList = ["Female", "Male"];
  String? selectedGender;
  late BuildContext dialogContext;
  @override
  void initState() {
    name.text = widget.patient.name;
    patient_addr.text = widget.patient.address;
    phone.text = widget.patient.phone;
    age.text = widget.patient.age.toString();
    selectedGender = widget.patient.gender;
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
          "Edit Patient",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  autocorrect: false,
                  controller: name,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF011627),
                        width: 2.0,
                      ),
                    ),
                    border: OutlineInputBorder(),
                    labelText: 'Name',
                    labelStyle: TextStyle(
                      color: Color(0xFF011627),
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  autocorrect: false,
                  keyboardType: TextInputType.streetAddress,
                  controller: patient_addr,
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF011627),
                        width: 2.0,
                      ),
                    ),
                    border: OutlineInputBorder(),
                    labelText: 'Address',
                    labelStyle: TextStyle(
                      color: Color(0xFF011627),
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  autocorrect: false,
                  controller: phone,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF011627),
                        width: 2.0,
                      ),
                    ),
                    border: OutlineInputBorder(),
                    labelText: 'Phone Number',
                    labelStyle: TextStyle(
                      color: Color(0xFF011627),
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  autocorrect: false,
                  controller: age,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF011627),
                        width: 2.0,
                      ),
                    ),
                    border: OutlineInputBorder(),
                    labelText: 'Age',
                    labelStyle: TextStyle(
                      color: Color(0xFF011627),
                    ),
                  ),
                ),
              ),
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
                    labelText: "Gender*",
                    labelStyle: TextStyle(
                      color: Color(0xFF0b132b),
                    ),
                  ),
                  mode: Mode.MENU,
                  showSelectedItems: true,
                  showSearchBox: false,
                  enabled: true,
                  items: genderList,
                  selectedItem: selectedGender,
                  onChanged: (item) => setState(() {
                    selectedGender = item!;
                  }),
                ),
              ),
              ElevatedButton(
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
                      var response = await dio
                          .post("$ServerIP/api/protected/EditPatient", data: {
                        "ID": widget.patient.id,
                        "name": name.text,
                        "address": patient_addr.text,
                        "phone": phone.text,
                        "age": int.parse(age.text),
                        "gender": selectedGender,
                      }).timeout(const Duration(seconds: 5));
                      if (response.data["message"] == "Updated Successfully") {
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
            ],
          ),
        ),
      ),
    );
  }
}
