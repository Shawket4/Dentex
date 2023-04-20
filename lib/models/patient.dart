import 'package:dentex/main.dart';
import 'package:dentex/models/appointment.dart';
import 'package:flutter/material.dart';

class Patient {
  int id = 0;
  int doctorID = 0;
  String name = "";
  String address = "";
  String phone = "";
  String gender = "";
  int age = 0;
  bool isFavourite = false;
  Braces braces = Braces();
  TeethMap teethMap = TeethMap();
  List<Appointment> history = [];
}

class Braces {
  int id = 0;
  int teethMapID = 0;
  int patientID = 0;
  List<Appointment> appointments = [];
  String notes = "";
}

class Condition {
  int? id = 0;
  String? name = "None";
  double? price = 0.0;
  Color? color;
  Condition({this.id, this.name, this.price, this.color});
}

class Tooth {
  int id = 0;
  String toothCode = "";
  Condition condition = Condition();
  bool isTreated = false;
  List<Appointment> uncompletedAppointments = [];
  Map<String, dynamic> toJSON() => {
        "id": id,
        "tooth_code": toothCode,
        "condition": condition.name,
        "condition_id": condition.id,
        "is_treated": isTreated,
        "hex_color": HexColor(condition.color!).toHex(),
      };
}

class TeethMap {
  List<Tooth> teeth = [];
  List<Map<String, dynamic>> toJSON() {
    List<Map<String, dynamic>> jsonOutput = [];
    teeth.sort((a, b) => a.toothCode.compareTo(b.toothCode));
    for (var tooth in teeth) {
      // print(tooth.toothCode + ":" + tooth.condition.name!);
      jsonOutput.add(tooth.toJSON());
    }
    return jsonOutput;
  }
}
