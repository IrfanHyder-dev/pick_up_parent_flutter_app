import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:pickup_parent/models/payment_history_model.dart';
import 'package:pickup_parent/models/ride_history_model.dart';
import 'package:pickup_parent/services/common_ui_service.dart';
import 'package:pickup_parent/services/history_service.dart';
import 'package:pickup_parent/src/app/apiErrorsMessage.dart';
import 'package:pickup_parent/src/app/constants/constants.dart';
import 'package:pickup_parent/src/app/locator.dart';
import 'package:pickup_parent/src/language/language_keys.dart';
import 'package:pickup_parent/ui/widgets/loading_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

class HistoryViewModel extends BaseViewModel with CommonUiService {
  HistoryService historyService = locator<HistoryService>();
  Map<String, List<HistoryData>> groupedHistories = {};
  PaymentHistoryModel? paymentHistory;
  RideHistoryModel? rideHistory;
  bool isPaymentHistoryLoaded = false;
  bool isRideHistoryLoaded = false;
  double distanceCovered = 0.0;

  initialise() {
    getHistories();
  }

  void getHistories() async {
    CustomDialog.showLoadingDialog(Get.context!);
    await userRideHistory();
    await userPaymentHistory();
    Get.back();
  }

  Future<void> userPaymentHistory() async {
    bool checkConnectivity = await check();
    if (checkConnectivity) {
      try {
        http.Response response = await historyService.userPaymentHistory();
        if (response.statusCode == 200) {
          var decodedResponse = json.decode(response.body);
          print('user payment history in view model ${decodedResponse}');
          if (decodedResponse["success"]) {
            paymentHistory = PaymentHistoryModel.fromJson(decodedResponse);
            paymentHistory?.data?.sort((a,b)=> a.paymentDate!.compareTo(b.paymentDate!));
            isPaymentHistoryLoaded = true;
          } else {
            Get.back();
            showCustomErrorTextToast(
                context: Get.context!, text: decodedResponse["message"]);
          }
        } else {
          ApiErrorsMessage().showApiErrorsMessage(response.statusCode);
        }
      } on SocketException {
        showCustomWarningTextToast(
            context: Get.context!, text: 'Socket Exception');
      } catch (e) {}
    } else {
      showCustomWarningTextToast(
          context: Get.context!, text: checkInternetKey.tr);
    }
    notifyListeners();
  }

  Future<void> userRideHistory() async {
    bool checkConnectivity = await check();
    if (checkConnectivity) {
      try{
      http.Response response = await historyService.userRideHistory();
      if (response.statusCode == 200) {
        var decodedResponse = json.decode(response.body);
        print('user ride history view model ${decodedResponse}');
        if (decodedResponse["success"]) {
          rideHistory = RideHistoryModel.fromJson(decodedResponse);
          await groupedSameQuotationHistories();
          isRideHistoryLoaded = true;
        } else {
          showCustomErrorTextToast(
              context: Get.context!, text: decodedResponse["message"]);
        }
      } else {
        ApiErrorsMessage().showApiErrorsMessage(response.statusCode);
      }
      }on SocketException{
        print('socket exception');
        showCustomWarningTextToast(context: Get.context!, text: "Socket Exception");
      }catch(e){
        print('catch exception $e');
      }
    } else {
      showCustomWarningTextToast(
          context: Get.context!, text: checkInternetKey.tr);
    }
  }

  Future<void> groupedSameQuotationHistories()async{
    /// grouped all child histories having the same quotationId
    for (var history in rideHistory!.data!) {
      String key =
          '${history.quotationId}_${history.shiftType?.name}_${history.rideDate}';
      double distance = await checkDistance(
        existingLat: double.parse(history.child?.pickUpLat ?? '0.0'),
        existingLng: double.parse(history.child?.pickUpLong ?? '0.0'),
        currentLat: double.parse(history.child?.dropOffLat ?? '0.0'),
        currentLng: double.parse(history.child?.dropOffLong ?? '0.0'),
      );
      history.keyForGrouping = key;
      history.distanceCovered = distance /1000;
      print('each child key is $key    ${history.keyForGrouping}');
      if (groupedHistories.containsKey(history.keyForGrouping)) {
        groupedHistories[history.keyForGrouping]?.add(history);
      } else {
        groupedHistories[history.keyForGrouping ?? ''] = [history];
      }
    }

    /// sort the group histories
    List<String> sortedKeys = groupedHistories.keys.toList();
    sortedKeys.sort((key1,key2){
      String rideDate1 = key1.split('_')[2];
      String rideDate2 = key2.split('_')[2];
      DateTime dateTime1 = DateFormat("EEEE, dd MMMM yyyy", "en").parse(rideDate1);
      DateTime dateTime2 = DateFormat("EEEE, dd MMMM yyyy", "en").parse(rideDate2);
      return dateTime2.compareTo(dateTime1);
    });
    Map<String,List<HistoryData>> sortedGroupHistories = {};
    sortedKeys.forEach((key) {
      sortedGroupHistories[key] = groupedHistories[key]!;
    });
    groupedHistories.clear();
    groupedHistories = sortedGroupHistories;
    print('grouped histories  $groupedHistories');
  }

  String extractMonthFromDate(String paymentDate) {
    DateTime dateTime = DateFormat('EEEE, dd MMMM yyyy').parse(paymentDate);
    String month = DateFormat('MMMM').format(dateTime);
    print("Month: $month");
    return month;
  }

  Future<double> checkDistance({
    required double existingLat,
    required double existingLng,
    required double currentLat,
    required double currentLng,
  }) async {
    /// Create two Location objects for the coordinates
    final LocationData existingLocation = LocationData.fromMap({
      "latitude": existingLat,
      "longitude": existingLng,
    });
    final LocationData currentLocation = LocationData.fromMap({
      "latitude": currentLat,
      "longitude": currentLng,
    });

    /// Calculate the distance between the two points in meters
    final double distance = await Geolocator.distanceBetween(
      existingLocation.latitude!,
      existingLocation.longitude!,
      currentLocation.latitude!,
      currentLocation.longitude!,
    );
    debugPrint("existing location  ${existingLocation}");
    debugPrint("current location  ${currentLocation}");
    debugPrint("distance  ${distance}");
    distanceCovered = distance;
    return distance;
  }
}


