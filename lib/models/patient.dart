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
  Condition({
    this.name,
    this.price,
  });
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
