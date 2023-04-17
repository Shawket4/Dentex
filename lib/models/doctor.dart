class Doctor {
  int id = 0;
  int userID = 0;
  String name = "";
  String phone = "";
  String specialization = "";
  String clinicName = "";
  String clinicAddress = "";
  String photoUrl = "";
  bool isDemo = false;
  bool isFrozen = false;
  Doctor fromJSON(Map<String, dynamic> input) {
    Doctor doctor = Doctor();
    doctor.id = input["ID"];
    doctor.userID = input["user_id"];
    doctor.name = input["name"];
    doctor.phone = input["phone"];
    doctor.specialization = input["specialization"];
    doctor.clinicName = input["clinic_name"];
    doctor.clinicAddress = input["clinic_address"];
    doctor.photoUrl = input["photo_url"];
    doctor.isDemo = input["is_demo"];
    doctor.isFrozen = input["is_frozen"];
    return doctor;
  }
}
