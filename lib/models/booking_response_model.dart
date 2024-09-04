// To parse this JSON data, do
//
//     final bookingResponseModel = bookingResponseModelFromJson(jsonString);

import 'dart:convert';

BookingResponseModel bookingResponseModelFromJson(String str) => BookingResponseModel.fromJson(json.decode(str));

String bookingResponseModelToJson(BookingResponseModel data) => json.encode(data.toJson());

class BookingResponseModel {
  bool success;
  String message;
  int status;
  Data data;

  BookingResponseModel({
    required this.success,
    required this.message,
    required this.status,
    required this.data,
  });

  factory BookingResponseModel.fromJson(Map<String, dynamic> json) => BookingResponseModel(
    success: json["success"],
    message: json["message"],
    status: json["status"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "status": status,
    "data": data.toJson(),
  };
}

class Data {
  int id;
  double amount;
  String status;
  bool expired;
  int userId;
  int driverId;
  DateTime createdAt;
  DateTime updatedAt;

  Data({
    required this.id,
    required this.amount,
    required this.status,
    required this.expired,
    required this.userId,
    required this.driverId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    amount: json["amount"]?.toDouble(),
    status: json["status"],
    expired: json["expired"],
    userId: json["user_id"],
    driverId: json["driver_id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "amount": amount,
    "status": status,
    "expired": expired,
    "user_id": userId,
    "driver_id": driverId,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
