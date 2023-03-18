import 'package:dentex/components/app_bar.dart';
import 'package:dentex/components/create_pdf.dart';
import 'package:dentex/models/patient.dart';
import 'package:dentex/models/prescription.dart';
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
      appBar: const CustomAppBar(
        title: 'Prescription Preview',
        actions: null,
      ),
      body: PdfPreview(
        build: (context) =>
            makePrescriptionPdf(widget.prescription, widget.patient),
      ),
    );
  }
}
