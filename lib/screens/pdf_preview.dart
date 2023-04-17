// ignore_for_file: use_build_context_synchronously

import 'package:dentex/components/app_bar.dart';
import 'package:dentex/components/create_pdf.dart';
import 'package:dentex/components/dialog.dart';
import 'package:dentex/dio_helper.dart';
import 'package:dentex/edit_screens/edit_prescription.dart';
import 'package:dentex/main.dart';
import 'package:dentex/models/patient.dart';
import 'package:dentex/models/prescription.dart';
import 'package:dentex/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

class PDFPreviewScreen extends StatefulWidget {
  const PDFPreviewScreen(
      {super.key, required this.prescription, required this.patient});
  final Prescription prescription;
  final Patient patient;
  @override
  State<PDFPreviewScreen> createState() => _PDFPreviewScreenState();
}

class _PDFPreviewScreenState extends State<PDFPreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Preview',
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      EditPrescriptionScreen(prescription: widget.prescription),
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
                await postData(
                    "$ServerIP/api/protected/DeletePrescription",
                    {
                      "id": widget.prescription.id,
                    },
                    context);
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
              margin: const EdgeInsets.symmetric(horizontal: 10),
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
      body: PdfPreview(
        build: (context) =>
            makePrescriptionPdf(widget.prescription, widget.patient),
      ),
    );
  }
}
