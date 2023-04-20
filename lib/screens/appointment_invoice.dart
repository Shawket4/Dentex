// ignore_for_file: use_build_context_synchronously

import 'package:dentex/components/app_bar.dart';
import 'package:dentex/components/create_pdf.dart';
import 'package:dentex/models/appointment.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

class AppointmentInvoiceScreen extends StatefulWidget {
  const AppointmentInvoiceScreen({
    super.key,
    required this.appointment,
  });
  final Appointment appointment;
  @override
  State<AppointmentInvoiceScreen> createState() =>
      _AppointmentInvoiceScreenState();
}

class _AppointmentInvoiceScreenState extends State<AppointmentInvoiceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Invoice',
        actions: null,
      ),
      body: PdfPreview(
        build: (context) => makeInvoicePdf(
          widget.appointment,
        ),
      ),
    );
  }
}
