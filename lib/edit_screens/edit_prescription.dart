// ignore_for_file: use_build_context_synchronously

import 'package:dentex/components/app_bar.dart';
import 'package:dentex/components/dialog.dart';
import 'package:dentex/dio_helper.dart';
import 'package:dentex/main.dart';
import 'package:dentex/models/prescription.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' as intl;

class EditPrescriptionScreen extends StatefulWidget {
  const EditPrescriptionScreen({super.key, required this.prescription});
  final Prescription prescription;

  @override
  State<EditPrescriptionScreen> createState() => _EditPrescriptionScreenState();
}

class _EditPrescriptionScreenState extends State<EditPrescriptionScreen> {
  List<TextEditingController> prescriptionTitleControllers = [];
  List<TextEditingController> prescriptionNotesControllers = [];
  TextEditingController dateOfPrescription = TextEditingController();
  Prescription prescription = Prescription();
  @override
  void initState() {
    prescription.date = widget.prescription.date;
    prescription.id = widget.prescription.id;
    prescription.patientID = widget.prescription.id;
    for (var prescriptionItem in widget.prescription.prescriptionItems.items) {
      prescription.prescriptionItems.items.add(prescriptionItem);
    }
    prescriptionTitleControllers.clear();
    prescriptionNotesControllers.clear();
    for (var prescriptionItem in prescription.prescriptionItems.items) {
      prescriptionTitleControllers
          .add(TextEditingController(text: prescriptionItem.name));
      prescriptionNotesControllers
          .add(TextEditingController(text: prescriptionItem.notes));
    }
    prescription.prescriptionItems.items.clear();
    dateOfPrescription.text = prescription.date!;
    super.initState();
  }

  @override
  void dispose() {
    prescription.date = widget.prescription.date;
    prescription.id = widget.prescription.id;
    prescription.patientID = widget.prescription.id;
    for (var prescriptionItem in widget.prescription.prescriptionItems.items) {
      prescription.prescriptionItems.items.add(prescriptionItem);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9),
      appBar: const CustomAppBar(
        title: "Edit Prescription",
        actions: null,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            ...List.generate(
              prescriptionTitleControllers.length,
              (index) => Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(
                        top: 10,
                        bottom: 10,
                        right: 5.0,
                        left: 10.0,
                      ),
                      child: TextField(
                        autocorrect: false,
                        controller: prescriptionTitleControllers[index],
                        decoration: InputDecoration(
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF011627),
                              width: 2.0,
                            ),
                          ),
                          border: const OutlineInputBorder(),
                          labelText: 'Prescription ${index + 1}',
                          labelStyle: const TextStyle(
                            color: Color(0xFF011627),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 5.0,
                      ),
                      child: TextField(
                        autocorrect: false,
                        controller: prescriptionNotesControllers[index],
                        decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF011627),
                              width: 2.0,
                            ),
                          ),
                          border: OutlineInputBorder(),
                          labelText: 'Notes',
                          labelStyle: TextStyle(
                            color: Color(0xFF011627),
                          ),
                        ),
                      ),
                    ),
                  ),
                  index != 0
                      ? IconButton(
                          onPressed: () {
                            prescriptionTitleControllers
                                .remove(prescriptionTitleControllers[index]);
                            prescriptionNotesControllers
                                .remove(prescriptionNotesControllers[index]);
                            setState(() {});
                          },
                          icon: const Icon(
                            Icons.remove_circle,
                            color: Colors.red,
                          ),
                        )
                      : IconButton(
                          onPressed: () {
                            prescriptionTitleControllers
                                .add(TextEditingController());
                            prescriptionNotesControllers
                                .add(TextEditingController());
                            setState(() {});
                          },
                          icon: const Icon(
                            Icons.add_circle_rounded,
                            color: Colors.green,
                          ),
                        ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () async {
                DateTime? returnedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 365 * 30)),
                    lastDate:
                        DateTime.now().add(const Duration(days: 365 * 30)));
                if (returnedDate != null) {
                  dateOfPrescription.text =
                      intl.DateFormat("yyyy/MM/dd").format(returnedDate);
                  setState(() {});
                }
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  autocorrect: false,
                  enabled: false,
                  controller: dateOfPrescription,
                  decoration: const InputDecoration(
                    suffixIcon: Icon(
                      Icons.calendar_month_rounded,
                      color: Colors.black,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF011627),
                        width: 2.0,
                      ),
                    ),
                    border: OutlineInputBorder(),
                    labelText: 'Prescription Date',
                    labelStyle: TextStyle(
                      color: Color(0xFF011627),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
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
                showLoadingDialog(context);
                for (var index = 0;
                    index < prescriptionTitleControllers.length;
                    index++) {
                  prescription.prescriptionItems.items.add(
                    PrescriptionItem(
                        name: prescriptionTitleControllers[index].text,
                        notes: prescriptionNotesControllers[index].text),
                  );
                }
                try {
                  var response = await postData(
                          "$ServerIP/api/protected/EditPrescription",
                          {
                            "ID": prescription.id,
                            "patient_id": prescription.patientID,
                            "date": dateOfPrescription.text,
                            "prescription_items":
                                prescription.prescriptionItems.toJSON(),
                          },
                          context)
                      .timeout(const Duration(seconds: 5));

                  if (response["message"] == "Updated Successfully") {
                    showSuccessDialog(context);
                  }
                } catch (e) {
                  showErrorDialog(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
