// To parse this JSON data, do
//
//     final paymentHistoryModel = paymentHistoryModelFromJson(jsonString);

import 'dart:convert';

PaymentHistoryModel paymentHistoryModelFromJson(String str) => PaymentHistoryModel.fromJson(json.decode(str));

String paymentHistoryModelToJson(PaymentHistoryModel data) => json.encode(data.toJson());

class PaymentHistoryModel {
  bool? success;
  String? message;
  int? status;
  List<Datum>? data;

  PaymentHistoryModel({
    this.success,
    this.message,
    this.status,
    this.data,
  });

  factory PaymentHistoryModel.fromJson(Map<String, dynamic> json) => PaymentHistoryModel(
    success: json["success"],
    message: json["message"],
    status: json["status"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "status": status,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  String? paymentStatus;
  int? noOfSeats;
  String? vehicleType;
  String? vehicleNumberPlate;
  String? driverName;
  double? amount;
  String? paymentDate;

  Datum({
    this.paymentStatus,
    this.noOfSeats,
    this.vehicleType,
    this.vehicleNumberPlate,
    this.driverName,
    this.amount,
    this.paymentDate,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    paymentStatus: json["payment_status"],
    noOfSeats: json["no_of_seats"],
    vehicleType: json["vehicle_type"],
    vehicleNumberPlate: json["number_plate"],
    driverName: json["driver_name"],
    amount: json["amount"],
    paymentDate: json["payment_date"],
  );

  Map<String, dynamic> toJson() => {
    "payment_status": paymentStatus,
    "no_of_seats": noOfSeats,
    "vehicle_type": vehicleType,
    "number_plate": vehicleNumberPlate,
    "driver_name": driverName,
    "amount": amount,
    "payment_date": paymentDate,
  };
}
