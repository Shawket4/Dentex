class Patient {
  int id = 0;
  String name = "";
  String address = "";
  String phone = "";
  String gender = "";
  int age = 0;
}

class Tooth {
  int id = 0;
  String toothCode = "";
  String condition = "None";
  bool isTreated = false;
  Map<String, dynamic> toJSON() => {
        "id": id,
        "tooth_code": toothCode,
        "condition": condition,
        "is_treated": isTreated,
      };
}

class TeethMap {
  List<Tooth> teeth = [];
  List<Map<String, dynamic>> toJSON() {
    List<Map<String, dynamic>> jsonOutput = [];
    for (var tooth in teeth) {
      jsonOutput.add(tooth.toJSON());
    }
    return jsonOutput;
  }
}
