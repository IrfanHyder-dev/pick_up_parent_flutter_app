// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

AllChildModel welcomeFromJson(String str) => AllChildModel.fromJson(json.decode(str));

String welcomeToJson(AllChildModel data) => json.encode(data.toJson());

class AllChildModel {
  bool success;
  String message;
  int status;
  List<Child> child;

  AllChildModel({
    required this.success,
    required this.message,
    required this.status,
    required this.child,
  });

  factory AllChildModel.fromJson(Map<String, dynamic> json) => AllChildModel(
    success: json["success"],
    message: json["message"],
    status: json["status"],
    child: List<Child>.from(json["data"].map((x) => Child.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "status": status,
    "data": List<dynamic>.from(child.map((x) => x.toJson())),
  };
}

class Child {
  int id;
  String name;
  DateTime startTime;
  DateTime endTime;
  int userId;
  String schoolName;
  DropOff pickUp;
  DropOff dropOff;

  Child({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.userId,
    required this.schoolName,
    required this.pickUp,
    required this.dropOff,
  });

  factory Child.fromJson(Map<String, dynamic> json) => Child(
    id: json["id"],
    name: json["name"],
    //startTime: DateTime.parse(json["start"].split(' ')[1] + ' ' + json["start"].split(' ')[2]),
     startTime: DateTime.parse(json["start"]),
    endTime: DateTime.parse(json["end"]),
    userId: json["user_id"],
    schoolName: json["school_name"],
    pickUp: DropOff.fromJson(json["pick_up"]),
    dropOff: DropOff.fromJson(json["drop_off"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "start_time": startTime.toIso8601String(),
    "end_time": endTime.toIso8601String(),
    "user_id": userId,
    "school_name": schoolName,
    "pick_up": pickUp.toJson(),
    "drop_off": dropOff.toJson(),
  };
}

class DropOff {
  String lat;
  String long;
  String address;

  DropOff({
    required this.lat,
    required this.long,
    required this.address,
  });

  factory DropOff.fromJson(Map<String, dynamic> json) => DropOff(
    lat: json["lat"],
    long: json["long"],
    address: json["address"],
  );

  Map<String, dynamic> toJson() => {
    "lat": lat,
    "long": long,
    "address": address,
  };
}
