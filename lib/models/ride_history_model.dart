// To parse this JSON data, do
//
//     final rideHistoryModel = rideHistoryModelFromJson(jsonString);

import 'dart:convert';

import 'package:pickup_parent/src/app/enum/enum.dart';

RideHistoryModel rideHistoryModelFromJson(String str) =>
    RideHistoryModel.fromJson(json.decode(str));

String rideHistoryModelToJson(RideHistoryModel data) =>
    json.encode(data.toJson());

class RideHistoryModel {
  bool? success;
  String? message;
  int? status;
  List<HistoryData>? data;

  RideHistoryModel({
    this.success,
    this.message,
    this.status,
    this.data,
  });

  factory RideHistoryModel.fromJson(Map<String, dynamic> json) =>
      RideHistoryModel(
        success: json["success"],
        message: json["message"],
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<HistoryData>.from(
                json["data"]!.map((x) => HistoryData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "status": status,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class HistoryData {
  int? id;
  int? quotationId;
  String? driverName;
  String? vehicleType;
  RideShiftType? shiftType;
  String? rideStartTime;
  String? rideEndTime;
  String? rideDate;
  String? numberPlate;
  Child? child;
  String? keyForGrouping;
  double? distanceCovered;

  HistoryData({
    this.id,
    this.quotationId,
    this.driverName,
    this.vehicleType,
    this.shiftType,
    this.rideStartTime,
    this.rideEndTime,
    this.rideDate,
    this.numberPlate,
    this.child,
    this.keyForGrouping = '',
    this.distanceCovered = 0.0,
  });

  factory HistoryData.fromJson(Map<String, dynamic> json) => HistoryData(
        id: json["id"],
        quotationId: json["quotation_id"],
        driverName: json["driver_name"],
        vehicleType: json["vehicle_type"],
        shiftType: (json["shift_type"] == RideShiftType.morning.name)
            ? RideShiftType.morning
            : (json["shift_type"] == RideShiftType.evening.name)
                ? RideShiftType.evening
                : RideShiftType.not_available,
        rideStartTime: json["ride_start_time"],
        rideEndTime: json["ride_end_time"],
        rideDate: json["ride_date"],
        numberPlate: json["number_plate"],
        child: json["child"] == null ? null : Child.fromJson(json["child"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "quotation_id": quotationId,
        "driver_name": driverName,
        "vehicle_type": vehicleType,
        "shift_type": shiftType,
        "ride_start_time": rideStartTime,
        "ride_end_time": rideEndTime,
        "ride_date": rideDate,
        "number_plate": numberPlate,
        "child": child?.toJson(),
      };
}

class Child {
  String? name;
  String? pickUpLat;
  String? pickUpLong;
  String? dropOffLat;
  String? dropOffLong;

  Child({
    this.name,
    this.pickUpLat,
    this.pickUpLong,
    this.dropOffLat,
    this.dropOffLong,
  });

  factory Child.fromJson(Map<String, dynamic> json) => Child(
        name: json["name"],
        pickUpLat: json["pick_up_lat"],
        pickUpLong: json["pick_up_long"],
        dropOffLat: json["drop_off_lat"],
        dropOffLong: json["drop_off_long"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "pick_up_lat": pickUpLat,
        "pick_up_long": pickUpLong,
        "drop_off_lat": dropOffLat,
        "drop_off_long": dropOffLong,
      };
}
