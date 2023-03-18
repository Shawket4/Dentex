class Prescription {
  int? patientID;
  String? date;
  PrescriptionItems prescriptionItems = PrescriptionItems();
  Prescription fromJSON(Map<String, dynamic> input) {
    Prescription prescription = Prescription();
    prescription.patientID = input["patient_id"];
    prescription.date = input["date"];
    prescription.prescriptionItems =
        prescription.prescriptionItems.fromJSON(input["prescription_items"]);
    return prescription;
  }
}

class PrescriptionItems {
  List<PrescriptionItem> items = [];
  PrescriptionItems fromJSON(dynamic input) {
    PrescriptionItems items = PrescriptionItems();
    for (var x in input) {
      PrescriptionItem item = PrescriptionItem().fromJSON(x);
      items.items.add(item);
    }
    return items;
  }

  List<Map<String, dynamic>> toJSON() {
    List<Map<String, dynamic>> jsonOutput = [];
    for (var item in items) {
      jsonOutput.add(item.toJSON());
    }
    return jsonOutput;
  }
}

class PrescriptionItem {
  String? name;
  String? notes;
  PrescriptionItem fromJSON(Map<String, dynamic> input) {
    PrescriptionItem? item = PrescriptionItem();
    item.name = input["name"];
    item.notes = input["notes"];
    return item;
  }

  Map<String, dynamic> toJSON() => {
        "name": name,
        "notes": notes,
      };
  PrescriptionItem({this.name, this.notes});
}
