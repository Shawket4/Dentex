import 'package:dentex/models/patient.dart';
import 'package:dentex/models/prescription.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

Future<Uint8List> makePrescriptionPdf(
    Prescription prescription, Patient patient) async {
  final imageLogo = MemoryImage(
      (await rootBundle.load('assets/images/Logo_Dark.png'))
          .buffer
          .asUint8List());
  final pdf = Document();
  pdf.addPage(
    Page(
      build: (context) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Date: ${prescription.date}",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Patient Name: ${patient.name}",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  child: Image(imageLogo),
                  width: 225,
                  height: 225,
                ),
              ],
            ),
            SizedBox(height: 30),
            Table(
              border: TableBorder.all(color: PdfColors.black),
              children: [
                // The first row just contains a phrase 'INVOICE FOR PAYMENT'
                TableRow(
                  children: [
                    Padding(
                      child: Text(
                        'Drug',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      padding: const EdgeInsets.all(20),
                    ),
                    Padding(
                      child: Text(
                        'Notes',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      padding: const EdgeInsets.all(20),
                    ),
                  ],
                ),

                ...prescription.prescriptionItems.items.map(
                  (item) => TableRow(
                    children: [
                      Expanded(
                        child: paddedText(item.name.toString()),
                        flex: 2,
                      ),
                      Expanded(
                        child: paddedText(item.notes.toString()),
                        flex: 1,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
      margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
    ),
  );
  return pdf.save();
}

Widget paddedText(
  final String text, {
  final TextAlign align = TextAlign.left,
}) =>
    Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        text,
        textAlign: align,
        style: const TextStyle(
          fontSize: 20,
        ),
      ),
    );