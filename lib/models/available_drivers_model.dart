// To parse this JSON data, do
//
//     final availableDriversModel = availableDriversModelFromJson(jsonString);

import 'dart:convert';

AvailableDriversModel availableDriversModelFromJson(String str) => AvailableDriversModel.fromJson(json.decode(str));

String availableDriversModelToJson(AvailableDriversModel data) => json.encode(data.toJson());

class AvailableDriversModel {
  bool success;
  String message;
  int status;
  List<Driver> data;

  AvailableDriversModel({
    required this.success,
    required this.message,
    required this.status,
    required this.data,
  });

  factory AvailableDriversModel.fromJson(Map<String, dynamic> json) => AvailableDriversModel(
    success: json["success"],
    message: json["message"],
    status: json["status"],
    data: List<Driver>.from(json["data"].map((x) => Driver.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Driver {
  int id;
  String email;
  String encryptedPassword;
  String? resetPasswordToken;
  DateTime? resetPasswordSentAt;
  String name;
  String surname;
  String contactNumber;
  String alternativeContactNumber;
  String lat;
  String long;
  String location;
  int vehicleTypeId;
  String vehicleModelYear;
  int? vehicleSeats;
  DateTime maintenanceDate;
  DateTime availableFrom;
  DateTime availableTill;
  int? otpCode;
  String? rememberCreatedAt;
  DateTime createdAt;
  DateTime updatedAt;
  String? authToken;
  String? cnicNumber;
  String? preferedLocation;
  String vehicleModel;
  String vehicleMake;
  String? vehicleNumberPlate;
  String vehicleColor;
  String? address;
  bool isProfileVerified;
  bool isProfileCompleted;
  bool approvalStatus;
  List<String>? fcmToken;
  bool mobileNotifications;
  bool emailNotifications;
  double? averageRating;
  int? totalReviewsReceived;
  int distance;
  String bearing;
  double fareAmount;
  String vehicleTypeName;
  String vehicleTypeIcon;
  String driverProfileImage;
  List<String> vehicleImages;

  Driver({
    required this.id,
    required this.email,
    required this.encryptedPassword,
    this.resetPasswordToken,
    this.resetPasswordSentAt,
    required this.name,
    required this.surname,
    required this.contactNumber,
    required this.alternativeContactNumber,
    required this.lat,
    required this.long,
    required this.location,
    required this.vehicleTypeId,
    required this.vehicleModelYear,
    this.vehicleSeats,
    required this.maintenanceDate,
    required this.availableFrom,
    required this.availableTill,
    this.otpCode,
    this.rememberCreatedAt,
    required this.createdAt,
    required this.updatedAt,
    this.authToken,
    this.cnicNumber,
    this.preferedLocation,
    required this.vehicleModel,
    required this.vehicleMake,
    this.vehicleNumberPlate,
    required this.vehicleColor,
    this.address,
    this.averageRating,
    this.totalReviewsReceived,
    required this.isProfileVerified,
    required this.isProfileCompleted,
    required this.approvalStatus,
     this.fcmToken,
    required this.mobileNotifications,
    required this.emailNotifications,
    required this.distance,
    required this.bearing,
    required this.fareAmount,
    required this.vehicleTypeName,
    required this.vehicleTypeIcon,
    required this.driverProfileImage,
    required this.vehicleImages,
  });

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
    id: json["id"],
    email: json["email"],
    encryptedPassword: json["encrypted_password"],
    resetPasswordToken: json["reset_password_token"],
    resetPasswordSentAt: json["reset_password_sent_at"] == null ? null : DateTime.parse(json["reset_password_sent_at"]),
    name: json["name"],
    surname: json["surname"],
    contactNumber: json["contact_number"],
    alternativeContactNumber: json["alternative_contact_number"],
    lat: json["lat"],
    long: json["long"],
    location: json["location"],
    vehicleTypeId: json["vehicle_type_id"],
    vehicleModelYear: json["vehicle_model_year"],
    vehicleSeats: json["vehicle_seats"],
    maintenanceDate: DateTime.parse(json["maintenance_date"]),
    availableFrom: DateTime.parse(json["available_from"]),
    availableTill: DateTime.parse(json["available_till"]),
    otpCode: json["otp_code"],
    rememberCreatedAt: json["remember_created_at"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    authToken: json["auth_token"],
    cnicNumber: json["cnic_number"],
    preferedLocation: json["prefered_location"],
    vehicleModel: json["vehicle_model"],
    vehicleMake: json["vehicle_make"],
    vehicleNumberPlate: json["vehicle_number_plate"],
    vehicleColor: json["vehicle_color"],
    address: json["address"],
    isProfileVerified: json["is_profile_verified"],
    isProfileCompleted: json["is_profile_completed"],
    averageRating: json["average_rating"]?.toDouble(),
    totalReviewsReceived: json["total_reviews_received"],
    approvalStatus: json["approval_status"],
    fcmToken:(json["fcm_token"] != null)?List<String>.from(json["fcm_token"].map((x) => x)) : [],
    mobileNotifications: json["mobile_notifications"],
    emailNotifications: json["email_notifications"],
    distance: json["distance"],
    bearing: json["bearing"],
    fareAmount: json["total_fare"],
    vehicleTypeName: json["vehicle_type_name"],
    vehicleTypeIcon: json["vehicle_type_icon"],
    driverProfileImage: json["driver_profile_image"],
    vehicleImages: List<String>.from(json["vehicle_images"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "encrypted_password": encryptedPassword,
    "reset_password_token": resetPasswordToken,
    "reset_password_sent_at": resetPasswordSentAt?.toIso8601String(),
    "name": name,
    "surname": surname,
    "contact_number": contactNumber,
    "alternative_contact_number": alternativeContactNumber,
    "lat": lat,
    "long": long,
    "location": location,
    "vehicle_type_id": vehicleTypeId,
    "vehicle_model_year": vehicleModelYear,
    "vehicle_seats": vehicleSeats,
    "maintenance_date": maintenanceDate.toIso8601String(),
    "available_from": availableFrom.toIso8601String(),
    "available_till": availableTill.toIso8601String(),
    "otp_code": otpCode,
    "remember_created_at": rememberCreatedAt,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "auth_token": authToken,
    "cnic_number": cnicNumber,
    "prefered_location": preferedLocation,
    "vehicle_model": vehicleModel,
    "vehicle_make": vehicleMake,
    "vehicle_number_plate": vehicleNumberPlate,
    "vehicle_color": vehicleColor,
    "address": address,
    "average_rating": averageRating,
    "total_reviews_received": totalReviewsReceived,
    "is_profile_verified": isProfileVerified,
    "is_profile_completed": isProfileCompleted,
    "approval_status": approvalStatus,
    "fcm_token": List<dynamic>.from(fcmToken!.map((x) => x)),
    "mobile_notifications": mobileNotifications,
    "email_notifications": emailNotifications,
    "distance": distance,
    "bearing": bearing,
    "total_fare": fareAmount,
    "vehicle_type_name": vehicleTypeName,
    "vehicle_type_icon": vehicleTypeIcon,
    "driver_profile_image": driverProfileImage,
    "vehicle_images": List<dynamic>.from(vehicleImages.map((x) => x)),
  };
}
