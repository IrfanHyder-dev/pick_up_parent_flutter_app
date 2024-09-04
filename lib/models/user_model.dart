// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

UserModel welcomeFromJson(String str) => UserModel.fromJson(json.decode(str));

String welcomeToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  bool success;
  String message;
  int status;
  Data data;

  UserModel({
    required this.success,
    required this.message,
    required this.status,
    required this.data,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
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

  Map<String, dynamic> toMap() {
    return {
      'success': this.success,
      'message': this.message,
      'status': this.status,
      'data': this.data,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      success: map['success'] as bool,
      message: map['message'] as String,
      status: map['status'] as int,
      data: map['data'] as Data,
    );
  }
}

class Data {
  User user;

  Data({
    required this.user,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
      };
}

class User {
  String authToken;
  String email;
  int id;
  String name;
  String? address;
  String contactNo;

  bool mobileNotifications;
  bool emailNotifications;
  DateTime createdAt;
  DateTime updatedAt;

  String surname;

  bool profileCompleted;
  bool isPhoneVerified;
  List<dynamic> fcmToken;
  String profilePicture;
  UserLocation userLocation;

  User({
    required this.authToken,
    required this.email,
    required this.id,
    required this.name,
     this.address,
    required this.contactNo,
    required this.mobileNotifications,
    required this.emailNotifications,
    required this.createdAt,
    required this.updatedAt,
    required this.surname,
    required this.profileCompleted,
    required this.isPhoneVerified,
    required this.fcmToken,
    required this.profilePicture,
    required this.userLocation,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        authToken: json["auth_token"],
        email: json["email"],
        id: json["id"],
        name: json["name"],
        address: json["address"],
        contactNo: json["contact_no"],
        mobileNotifications: json["mobile_notifications"],
        emailNotifications: json["email_notifications"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        surname: json["surname"],
        profileCompleted: json["profile_completed"],
        isPhoneVerified: json["is_phone_verified"],
        fcmToken: List<dynamic>.from(json["fcm_token"].map((x) => x)),
        profilePicture: json["profile_picture"],
        userLocation: UserLocation.fromJson(json["user_location"]),
      );

  Map<String, dynamic> toJson() => {
        "auth_token": authToken,
        "email": email,
        "id": id,
        "name": name,
        "address": address,
        "contact_no": contactNo,
        "mobile_notifications": mobileNotifications,
        "email_notifications": emailNotifications,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "surname": surname,
        "profile_completed": profileCompleted,
        "is_phone_verified": isPhoneVerified,
        "fcm_token": List<dynamic>.from(fcmToken.map((x) => x)),
        "profile_picture": profilePicture,
        "user_location": userLocation.toJson(),
      };
}

class UserLocation {
  String? lat;
  String? long;
  String? address;

  UserLocation({
    this.lat,
    this.long,
    this.address,
  });

  factory UserLocation.fromJson(Map<String, dynamic> json) => UserLocation(
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
