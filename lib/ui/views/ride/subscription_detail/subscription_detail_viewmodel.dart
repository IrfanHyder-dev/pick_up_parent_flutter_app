import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pickup_parent/models/all_subscriptions_model.dart';
import 'package:pickup_parent/models/payment_completed_model.dart';
import 'package:pickup_parent/services/common_ui_service.dart';
import 'package:pickup_parent/services/vehical_service.dart';
import 'package:pickup_parent/src/app/apiErrorsMessage.dart';
import 'package:pickup_parent/src/app/constants/constants.dart';
import 'package:pickup_parent/src/app/locator.dart';
import 'package:pickup_parent/src/language/language_keys.dart';
import 'package:pickup_parent/ui/views/bottom_bar/bottom_bar_view.dart';
import 'package:pickup_parent/ui/views/ride/chose_ride/chose_ride_viewmodel.dart';
import 'package:pickup_parent/ui/widgets/loading_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

class SubscriptionDetailViewModel extends BaseViewModel with CommonUiService{
  ChoseRideViewModel choseRideViewModel = locator<ChoseRideViewModel>();
  VehicleService vehicleService = locator<VehicleService>();
  final ScrollController scrollController = ScrollController();
  final ScrollController singleChildController = ScrollController();
  bool isMethodSelected = false;
  int selectedMethod = 0;
  PaymentCompletedModel? paymentCompletedModel;



  initialise() {

  }

  void paymentMethodOnTap(int index){
    selectedMethod = index;
    notifyListeners();
  }

  Future payNow({required int id}) async{
    CustomDialog.showLoadingDialog(Get.context!);
    bool connectivity = await check();
    if(connectivity){
      http.Response response = await vehicleService.payNow(id: id);
      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        if (decodedResponse['success']) {
          paymentCompletedModel = PaymentCompletedModel.fromJson(decodedResponse);
          Get.back();
          Get.to(() => BottomBarView(index: 2));
          showCustomSuccessTextToast(
              context: Get.context!, text: decodedResponse['message']);
        }
        else {
          Get.back();
          showCustomErrorTextToast(
              context: Get.context!, text: decodedResponse['message']);
        }
      }
      else {
        ApiErrorsMessage().showApiErrorsMessage(response.statusCode);
      }
    }else{
      Get.back();
      showCustomErrorTextToast(context: Get.context!, text: checkInternetKey.tr);
    }
  }


}