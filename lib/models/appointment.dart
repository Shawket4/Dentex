import 'package:dentex/models/patient.dart';

class Appointment {
  int? id;
  int? patientID;
  int? toothID;
  String? patientName;
  String? toothCode;
  DateTime? date;
  Condition condition = Condition();
  double? price;
  bool? isPaid;
  bool? isCompleted;
}
