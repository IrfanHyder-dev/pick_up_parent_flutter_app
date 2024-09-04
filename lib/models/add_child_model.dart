

class AddChildModel{
  String name;
  // String startTime;
  // String endTime;
  DateTime startTime;
  DateTime endTime;
  String schoolName;
  double dropOffLat;
  double dropOffLong;
  String dropOffLocation;
  double pickUpLat;
  double pickUpLong;
  String pickUpLocation;

  AddChildModel({
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.schoolName,
    required this.dropOffLat,
    required this.dropOffLong,
    required this.dropOffLocation,
    required this.pickUpLat,
    required this.pickUpLong,
    required this.pickUpLocation,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'school_name': schoolName,
      'drop_off_lat': dropOffLat,
      'drop_off_long': dropOffLong,
      'drop_off_location': dropOffLocation,
      'pick_up_lat': pickUpLat,
      'pick_up_long': pickUpLong,
      'pick_up_location': pickUpLocation,

    };
  }

}