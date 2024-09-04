import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pickup_parent/models/all_child_model.dart';
import 'package:pickup_parent/services/common_ui_service.dart';
import 'package:pickup_parent/services/home_service.dart';
import 'package:pickup_parent/src/app/apiErrorsMessage.dart';
import 'package:pickup_parent/src/app/constants/constants.dart';
import 'package:pickup_parent/src/app/enum/enum.dart';
import 'package:pickup_parent/src/app/locator.dart';
import 'package:pickup_parent/src/language/language_keys.dart';
import 'package:pickup_parent/ui/views/ride/chose_ride/chose_ride_view.dart';
import 'package:pickup_parent/ui/widgets/loading_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

class HomeViewModel extends BaseViewModel with CommonUiService {
  HomeService homeService = locator<HomeService>();
  AllChildModel? allChildModel;
  List<Child> childList = [];
  List<Child> selectedChildList = [];
  int? selectedIndex;
  bool isLocationDiff = false;

  initialise() {
    fetchAllChild();
  }

  Future<void> fetchAllChild() async {
    CustomDialog.showLoadingDialog(Get.context!);
    bool connectivity =await check();
    if(connectivity){
      childList.clear();
      http.Response result = await homeService.fetchAllChild();
      if (result.statusCode == 200) {
        var decodedResponse = jsonDecode(result.body);
        if (decodedResponse['success'] == true) {
          allChildModel = AllChildModel.fromJson(decodedResponse);
          for (final item in allChildModel!.child) {
            childList.add(item);
          }
          rebuildUi();
          Get.back();
        } else {
          Get.back();
          showCustomErrorTextToast(
              context: Get.context!, text: decodedResponse['message']);
        }
      } else {
        ApiErrorsMessage().showApiErrorsMessage(result.statusCode);
      }
    }else{
      Get.back();
      showCustomWarningTextToast(context: Get.context!, text: checkInternetKey.tr);
    }
    // print('child length is ${childList.length}  ${allChildModel!.data.length}');
  }

  selectedChildColor({
    required int index,
  }) {
    if (selectedChildList.isNotEmpty) {
      print('selected child $selectedChildList');
      if (selectedChildList.contains(childList[index])) {
        return index;
      } else {
        return -1;
      }
    }
  }

  void addOrRemoveSelectedChild({required int index}) {
    if (selectedChildList.isNotEmpty) {
      if (selectedChildList.contains(childList[index])) {
        selectedChildList.remove(childList[index]);
      } else {
        selectedChildList.add(childList[index]);
      }
    } else {
      selectedChildList.add(childList[index]);
    }
    notifyListeners();
  }

  void moveToChoseRideScreen(){
    if(selectedChildList.isNotEmpty){
      Get.to(()=>ChoseRideView(selectedChild: selectedChildList,));
    }else{
      showSnackBar('Select Child', SnackBarType.universal,color: Theme.of(Get.context!)
          .canvasColor,
          style: TextStyle(
              color: Colors.white,
              fontSize: 14
          ));
    }
  }

  void locationOff() {
    isLocationDiff = !isLocationDiff;
    notifyListeners();
  }
}
