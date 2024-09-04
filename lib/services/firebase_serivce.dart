import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:pickup_parent/src/app/constants/firebase_collection.dart';
import 'package:pickup_parent/models/user_firebase_model.dart';

class FirebaseServices {
  static Future<String?> checkUserInDB(String userID) async {
    try {
      DocumentSnapshot userDocument =
          await FBCollections.drivers.doc(userID).get();
      if (userDocument.exists) {
        return userDocument.id;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint("Error in checking user in DB \n\n\n $e");
      return null;
    }
  }

  static Future<UserFirebaseModel> fetchRoute(String id) async {
     var ref = await FBCollections.drivers
        .doc(id)
        .get();
     UserFirebaseModel data = UserFirebaseModel.fromJson(ref.data());
    return data;
  }

  static Stream<UserFirebaseModel> fetchUserData(String id) {
    Stream<DocumentSnapshot<Object?>> ref =
        FBCollections.drivers.doc(id).snapshots().asBroadcastStream();
    return ref.map((event) => UserFirebaseModel.fromJson(event.data()));
  }

  static Future<String?> getRideStatusDocId(String? driverFirebaseDocID)async{
    if (driverFirebaseDocID != null){
      var data = await FBCollections.rideStatus
          .where("driver_firebase_id", isEqualTo: driverFirebaseDocID)
          .limit(1)
          .get();

      return data.docs.first.id;
    }else{
      return null;
    }
  }

  static Stream<RideStatusModel?>? fetchRideStatusStream(String? driverFirebaseRideStatusDocID){
    try {
        Stream<DocumentSnapshot<Object?>> ref = FBCollections.rideStatus.doc(driverFirebaseRideStatusDocID).snapshots().asBroadcastStream();
        return ref.map((event) => RideStatusModel.fromJson(event.data()));

    } catch (e) {
      debugPrint("Error in checking ride status in DB \n\n\n $e");
      return null;
    }
  }

  /*================== Ride status Functions ======================*/

  static Future<RideStatusModel?> getRideStatusDoc(
      String? driverFirebaseDocID) async {
    try {
      if (driverFirebaseDocID != null) {
        return await FBCollections.rideStatus
            .where("driver_firebase_id", isEqualTo: driverFirebaseDocID)
            .limit(1)
            .get()
            .then((value) async {
          if (value.docs.length > 0) {
            var data =
            await FBCollections.rideStatus.doc(value.docs.first.id).get();
            RideStatusModel rideStatusModel =
            RideStatusModel.fromJson(data.data());
            return rideStatusModel;
          } else {
            return null;
          }
        });
      }
      return null;
    } catch (e) {
      debugPrint("Error in checking ride status in DB \n\n\n $e");

      return null;
    }
  }
}
