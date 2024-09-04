// To parse this JSON data, do
//
//     final fetchRouteDetailsModel = fetchRouteDetailsModelFromJson(jsonString);

import 'dart:convert';

FetchRouteDetailsModel fetchRouteDetailsModelFromJson(String str) => FetchRouteDetailsModel.fromJson(json.decode(str));

String fetchRouteDetailsModelToJson(FetchRouteDetailsModel data) => json.encode(data.toJson());

class FetchRouteDetailsModel {
  bool? success;
  String? message;
  int? status;
  List<ChildDetail>? data;

  FetchRouteDetailsModel({
    this.success,
    this.message,
    this.status,
    this.data,
  });

  factory FetchRouteDetailsModel.fromJson(Map<String, dynamic> json) => FetchRouteDetailsModel(
    success: json["success"],
    message: json["message"],
    status: json["status"],
    data: json["data"] == null ? [] : List<ChildDetail>.from(json["data"]!.map((x) => ChildDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "status": status,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class ChildDetail {
  int? id;
  dynamic rideStatus;
  int? quotationId;
  Child? child;

  ChildDetail({
    this.id,
    this.rideStatus,
    this.quotationId,
    this.child,
  });

  factory ChildDetail.fromJson(Map<String, dynamic> json) => ChildDetail(
    id: json["id"],
    rideStatus: json["ride_status"],
    quotationId: json["quotation_id"],
    child: json["child"] == null ? null : Child.fromJson(json["child"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ride_status": rideStatus,
    "quotation_id": quotationId,
    "child": child?.toJson(),
  };
}

class Child {
  int? id;
  String? name;
  String? pickUpLat;
  String? pickUpLong;
  String? pickUpLocation;
  String? dropOffLat;
  String? dropOffLong;
  String? dropOffLocation;
  String? schoolName;
  bool? isSelected;
  DateTime? start;
  DateTime? end;

  Child({
    this.id,
    this.name,
    this.pickUpLat,
    this.pickUpLong,
    this.pickUpLocation,
    this.dropOffLat,
    this.dropOffLong,
    this.dropOffLocation,
    this.schoolName,
    this.isSelected,
    this.start,
    this.end,
  });

  factory Child.fromJson(Map<String, dynamic> json) => Child(
    id: json["id"],
    name: json["name"],
    pickUpLat: json["pick_up_lat"],
    pickUpLong: json["pick_up_long"],
    pickUpLocation: json["pick_up_location"],
    dropOffLat: json["drop_off_lat"],
    dropOffLong: json["drop_off_long"],
    dropOffLocation: json["drop_off_location"],
    schoolName: json["school_name"],
    isSelected: json["is_selected"],
    start: json["start"] == null ? null : DateTime.parse(json["start"]),
    end: json["end"] == null ? null : DateTime.parse(json["end"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "pick_up_lat": pickUpLat,
    "pick_up_long": pickUpLong,
    "pick_up_location": pickUpLocation,
    "drop_off_lat": dropOffLat,
    "drop_off_long": dropOffLong,
    "drop_off_location": dropOffLocation,
    "school_name": schoolName,
    "is_selected": isSelected,
    "start": start?.toIso8601String(),
    "end": end?.toIso8601String(),
  };
}
