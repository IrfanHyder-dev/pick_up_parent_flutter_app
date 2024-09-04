// To parse this JSON data, do
//
//     final paymentCompletedModel = paymentCompletedModelFromJson(jsonString);

import 'dart:convert';

PaymentCompletedModel paymentCompletedModelFromJson(String str) => PaymentCompletedModel.fromJson(json.decode(str));

String paymentCompletedModelToJson(PaymentCompletedModel data) => json.encode(data.toJson());

class PaymentCompletedModel {
  bool success;
  String message;
  int status;
  Data data;

  PaymentCompletedModel({
    required this.success,
    required this.message,
    required this.status,
    required this.data,
  });

  factory PaymentCompletedModel.fromJson(Map<String, dynamic> json) => PaymentCompletedModel(
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
  String paymentStatus;
  String paymentType;
  String paymentDate;
  DateTime createdAt;
  DateTime updatedAt;

  Data({
    required this.id,
    required this.paymentStatus,
    required this.paymentType,
    required this.paymentDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    paymentStatus: json["payment_status"],
    paymentType: json["payment_type"],
    paymentDate: json["payment_date"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "payment_status": paymentStatus,
    "payment_type": paymentType,
    "payment_date": paymentDate,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
