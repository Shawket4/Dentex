// ignore_for_file: use_build_context_synchronously

import 'package:dentex/components/app_bar.dart';
import 'package:dentex/components/dialog.dart';
import 'package:dentex/dio_helper.dart';
import 'package:dentex/edit_screens/edit_treatment.dart';
import 'package:dentex/main.dart';
import 'package:dentex/models/patient.dart';
import 'package:dentex/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TreatmentDetailScreen extends StatefulWidget {
  const TreatmentDetailScreen({super.key, required this.treatment});
  final Condition treatment;
  @override
  State<TreatmentDetailScreen> createState() => _TreatmentDetailScreenState();
}

class _TreatmentDetailScreenState extends State<TreatmentDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Treatment: ${widget.treatment.name}",
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      EditTreatmentScreen(treatment: widget.treatment),
                ),
              );
            },
            child: const Icon(
              Icons.edit_document,
            ),
          ),
          GestureDetector(
            onTap: () async {
              try {
                await postData("$ServerIP/api/protected/DeleteTreatment", {
                  "id": widget.treatment.id,
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HomeScreen(),
                  ),
                );
              } catch (e) {
                showErrorDialog(context);
              }
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              height: 40,
              width: 40,
              child: const Icon(
                Icons.delete,
                size: 30,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Color Code",
                style: GoogleFonts.jost(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 10,
                ),
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                    color: widget.treatment.color,
                    borderRadius: BorderRadius.circular(10)),
              ),
              Text(
                "Treatment: ${widget.treatment.name}",
                style: GoogleFonts.jost(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "Price: ${widget.treatment.price} LE",
                style: GoogleFonts.jost(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
