import 'package:dentex/main.dart';
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
}

class Condition {
  String? name = "None";
  double? price = 0.0;
  Color? color;
  Condition({this.name, this.price, this.color});
}

class Tooth {
  int id = 0;
  String toothCode = "";
  Condition condition = Condition();
  bool isTreated = false;
  Map<String, dynamic> toJSON() => {
        "id": id,
        "tooth_code": toothCode,
        "condition": condition.name,
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
