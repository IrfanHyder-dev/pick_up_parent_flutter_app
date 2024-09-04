// To parse this JSON data, do
//
//     final allSubscriptionsModel = allSubscriptionsModelFromJson(jsonString);

import 'dart:convert';

import 'package:pickup_parent/src/app/enum/enum.dart';

AllSubscriptionsModel allSubscriptionsModelFromJson(String str) =>
    AllSubscriptionsModel.fromJson(json.decode(str));

String allSubscriptionsModelToJson(AllSubscriptionsModel data) =>
    json.encode(data.toJson());

class AllSubscriptionsModel {
  bool? success;
  String? message;
  int? status;
  List<SubscriptionData>? subscriptionData;

  AllSubscriptionsModel({
    this.success,
    this.message,
    this.status,
    this.subscriptionData,
  });

  factory AllSubscriptionsModel.fromJson(Map<String, dynamic> json) =>
      AllSubscriptionsModel(
        success: json["success"],
        message: json["message"],
        status: json["status"],
        subscriptionData: json["data"] == null
            ? []
            : List<SubscriptionData>.from(json["data"]!.map((x) => SubscriptionData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "status": status,
        "data": subscriptionData == null
            ? []
            : List<dynamic>.from(subscriptionData!.map((x) => x.toJson())),
      };
}

class SubscriptionData {
  int? id;
  double? amount;
  QuotationStatus? status;
  bool? expired;
  int? userId;
  int? driverId;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<dynamic>? childIds;
  String? distance;
  PaymentStatus? paymentStatus;
  Driver? driver;
  List<ChildElement>? children;

  SubscriptionData({
    this.id,
    this.amount,
    this.status,
    this.expired,
    this.userId,
    this.driverId,
    this.createdAt,
    this.updatedAt,
    this.childIds,
    this.distance,
    this.paymentStatus,
    this.driver,
    this.children,
  });

  factory SubscriptionData.fromJson(Map<String, dynamic> json) => SubscriptionData(
        id: json["id"],
        amount: double.parse(json["amount"].toString()),
        // status: json["status"],
        status: (json["status"] == QuotationStatus.pending.name)
            ? QuotationStatus.pending
            : (json["status"] == QuotationStatus.accept.name)
                ? QuotationStatus.accept
                : (json["status"] == QuotationStatus.reject.name)
                    ? QuotationStatus.reject
                    : (json["status"] == QuotationStatus.cancel.name)
                        ? QuotationStatus.cancel
                        : (json["status"] == QuotationStatus.paid.name)
                            ? QuotationStatus.paid
                            : QuotationStatus.accept_and_paid,
        expired: json["expired"],
        userId: json["user_id"],
        driverId: json["driver_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        childIds: json["child_ids"] == null
            ? []
            : List<dynamic>.from(json["child_ids"]!.map((x) => x)),
        distance: json["distance"],
        paymentStatus: (json["payment_status"] == PaymentStatus.paid.name)? PaymentStatus.paid : PaymentStatus.pending,
        driver: json["driver"] == null ? null : Driver.fromJson(json["driver"]),
        children: json["children"] == null
            ? []
            : List<ChildElement>.from(
                json["children"]!.map((x) => ChildElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "amount": amount,
        "status": status,
        "expired": expired,
        "user_id": userId,
        "driver_id": driverId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "child_ids":
            childIds == null ? [] : List<dynamic>.from(childIds!.map((x) => x)),
        "distance": distance,
        "payment_status": paymentStatus,
        "driver": driver?.toJson(),
        "children": children == null
            ? []
            : List<dynamic>.from(children!.map((x) => x.toJson())),
      };
}

class ChildElement {
  int? id;
  ArrivalStatus? rideStatus;
  ChildChild? child;

  ChildElement({
    this.id,
    this.rideStatus,
    this.child,
  });

  factory ChildElement.fromJson(Map<String, dynamic> json) => ChildElement(
        id: json["id"],
        // rideStatus: json["ride_status"],
        rideStatus: (json["ride_status"] == ArrivalStatus.picked.name)
            ? ArrivalStatus.picked
            : (json["ride_status"] == ArrivalStatus.arrived.name)
                ? ArrivalStatus.arrived
                : (json["ride_status"] == ArrivalStatus.dropped.name)
                    ? ArrivalStatus.dropped
                    : (json["ride_status"] == ArrivalStatus.not_going.name)
                        ? ArrivalStatus.not_going
                        : ArrivalStatus.not_arrived,
        child:
            json["child"] == null ? null : ChildChild.fromJson(json["child"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "ride_status": rideStatus,
        "child": child?.toJson(),
      };
}

class ChildChild {
  int? id;
  String? name;
  String? pickUpLat;
  String? pickUpLong;
  String? pickUpLocation;
  String? dropOffLat;
  String? dropOffLong;
  String? dropOffLocation;
  DateTime? startTime;
  DateTime? endTime;
  int? userId;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? schoolName;
  bool? isSelected;
  int? rideStatus;

  ChildChild({
    this.id,
    this.name,
    this.pickUpLat,
    this.pickUpLong,
    this.pickUpLocation,
    this.dropOffLat,
    this.dropOffLong,
    this.dropOffLocation,
    this.startTime,
    this.endTime,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.schoolName,
    this.isSelected,
    this.rideStatus,
  });

  factory ChildChild.fromJson(Map<String, dynamic> json) => ChildChild(
        id: json["id"],
        name: json["name"],
        pickUpLat: json["pick_up_lat"],
        pickUpLong: json["pick_up_long"],
        pickUpLocation: json["pick_up_location"],
        dropOffLat: json["drop_off_lat"],
        dropOffLong: json["drop_off_long"],
        dropOffLocation: json["drop_off_location"],
        startTime: json["start"] == null ? null : DateTime.parse(json["start"]),
        endTime: json["end"] == null ? null : DateTime.parse(json["end"]),
        userId: json["user_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        schoolName: json["school_name"],
        isSelected: json["is_selected"],
        rideStatus: json["ride_status"],
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
        "start": startTime?.toIso8601String(),
        "end": endTime?.toIso8601String(),
        "user_id": userId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "school_name": schoolName,
        "is_selected": isSelected,
        "ride_status": rideStatus,
      };
}

class Driver {
  int? id;
  String? email;
  String? name;
  String? surname;
  String? contactNumber;
  String? alternativeContactNumber;
  String? lat;
  String? long;
  String? location;
  int? vehicleTypeId;
  String? vehicleModelYear;
  int? vehicleSeats;
  DateTime? maintenanceDate;
  DateTime? availableFrom;
  DateTime? availableTill;
  int? otpCode;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? authToken;
  String? cnicNumber;
  dynamic preferedLocation;
  String? vehicleModel;
  String? vehicleMake;
  String? vehicleNumberPlate;
  String? vehicleColor;
  dynamic address;
  bool? isProfileVerified;
  bool? isProfileCompleted;
  bool? approvalStatus;
  List<String>? fcmToken;
  bool? mobileNotifications;
  bool? emailNotifications;
  String? dropOffLat;
  String? dropOffLong;
  String? dropOffLocation;
  String? driverFirebaseId;

  Driver({
    this.id,
    this.email,
    this.name,
    this.surname,
    this.contactNumber,
    this.alternativeContactNumber,
    this.lat,
    this.long,
    this.location,
    this.vehicleTypeId,
    this.vehicleModelYear,
    this.vehicleSeats,
    this.maintenanceDate,
    this.availableFrom,
    this.availableTill,
    this.otpCode,
    this.createdAt,
    this.updatedAt,
    this.authToken,
    this.cnicNumber,
    this.preferedLocation,
    this.vehicleModel,
    this.vehicleMake,
    this.vehicleNumberPlate,
    this.vehicleColor,
    this.address,
    this.isProfileVerified,
    this.isProfileCompleted,
    this.approvalStatus,
    this.fcmToken,
    this.mobileNotifications,
    this.emailNotifications,
    this.dropOffLat,
    this.dropOffLong,
    this.dropOffLocation,
    this.driverFirebaseId,
  });

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
        id: json["id"],
        email: json["email"],
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
        maintenanceDate: json["maintenance_date"] == null
            ? null
            : DateTime.parse(json["maintenance_date"]),
        availableFrom: json["available_from"] == null
            ? null
            : DateTime.parse(json["available_from"]),
        availableTill: json["available_till"] == null
            ? null
            : DateTime.parse(json["available_till"]),
        otpCode: json["otp_code"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
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
        approvalStatus: json["approval_status"],
        fcmToken: json["fcm_token"] == null
            ? []
            : List<String>.from(json["fcm_token"]!.map((x) => x)),
        mobileNotifications: json["mobile_notifications"],
        emailNotifications: json["email_notifications"],
        dropOffLat: json["drop_off_lat"],
        dropOffLong: json["drop_off_long"],
        dropOffLocation: json["drop_off_location"],
        driverFirebaseId: json["driver_firebase_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
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
        "maintenance_date": maintenanceDate?.toIso8601String(),
        "available_from": availableFrom?.toIso8601String(),
        "available_till": availableTill?.toIso8601String(),
        "otp_code": otpCode,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "auth_token": authToken,
        "cnic_number": cnicNumber,
        "prefered_location": preferedLocation,
        "vehicle_model": vehicleModel,
        "vehicle_make": vehicleMake,
        "vehicle_number_plate": vehicleNumberPlate,
        "vehicle_color": vehicleColor,
        "address": address,
        "is_profile_verified": isProfileVerified,
        "is_profile_completed": isProfileCompleted,
        "approval_status": approvalStatus,
        "fcm_token":
            fcmToken == null ? [] : List<dynamic>.from(fcmToken!.map((x) => x)),
        "mobile_notifications": mobileNotifications,
        "email_notifications": emailNotifications,
        "drop_off_lat": dropOffLat,
        "drop_off_long": dropOffLong,
        "drop_off_location": dropOffLocation,
        "driver_firebase_id": driverFirebaseId,
      };
}
