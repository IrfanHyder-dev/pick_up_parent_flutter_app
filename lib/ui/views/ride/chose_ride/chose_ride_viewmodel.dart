import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:pickup_parent/models/all_child_model.dart';
import 'package:pickup_parent/models/available_drivers_model.dart';
import 'package:pickup_parent/services/common_ui_service.dart';
import 'package:pickup_parent/services/vehical_service.dart';
import 'package:pickup_parent/src/app/apiErrorsMessage.dart';
import 'package:pickup_parent/src/app/constants/constants.dart';
import 'package:pickup_parent/src/app/locator.dart';
import 'package:pickup_parent/src/app/static_info.dart';
import 'package:pickup_parent/src/language/language_keys.dart';
import 'package:pickup_parent/ui/views/ride/car_details/car_detail_view.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

@injectable
class ChoseRideViewModel extends BaseViewModel with CommonUiService {
  VehicleService vehicleService = locator<VehicleService>();
  int selectedIndex = 0;
  bool isDataLoad = false;
  AvailableDriversModel? availableDriversModel;
  List<Driver> vehicleTypesOptions = [];
  List<Driver> availableVehiclesList = [];
  List<Child> selectedChildList = [];
  String? selectedVehicleTypeName;

  initialise({required List<Child> selectedChild}) {
    selectedChildList.clear();
    selectedChildList.addAll(selectedChild);
    print('choose ride model ${selectedChild}');
    fetchDrivers(selectedChild);
  }

  Future fetchDrivers(List<Child> selectedChild) async {
    bool connectivity = await check();
    if(connectivity){
      isDataLoad = false;
      notifyListeners();
      List<int> selectedChildId = [];
      for (final item in selectedChild) {
        selectedChildId.add(item.id);
      }
      http.StreamedResponse response =
          await vehicleService.fetchDriver(selectedChildId);


      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        debugPrint('${response.statusCode} ${responseData}');
        var decodedResponse = jsonDecode(responseData);
        if (decodedResponse['success'] == true && decodedResponse["data"] != null) {
          availableDriversModel =
              AvailableDriversModel.fromJson(decodedResponse);
          if (availableDriversModel!.data.isNotEmpty) {
            filterVehicleTypes();
          } else {
            Get.back();
            showCustomWarningTextToast(
                context: Get.context!, text: 'No Driver found on this route');
          }
        } else {
          Get.back();
          showCustomWarningTextToast(
              context: Get.context!, text: decodedResponse['message']);
        }
      } else {
        ApiErrorsMessage().showApiErrorsMessage(response.statusCode);
      }
    }else{
      Get.back();
      showCustomWarningTextToast(context: Get.context!, text: checkInternetKey.tr);
    }
  }

  void filterVehicleTypes() {
    List<int> vehicleTypeId = [];
    vehicleTypesOptions.clear();
    for (Driver item in availableDriversModel!.data) {
      if (!vehicleTypeId.contains(item.vehicleTypeId)) {
        vehicleTypeId.add(item.vehicleTypeId);
        vehicleTypesOptions.add(item);
      }
    }
    filterAvailableServices(index: 0);
    notifyListeners();
  }

  void filterAvailableServices({required int index}) {
    availableVehiclesList.clear();
    selectedIndex = index;
    int selectedVehicleId = vehicleTypesOptions[index].vehicleTypeId;

    for(Driver item in availableDriversModel!.data){
      if(selectedVehicleId == item.vehicleTypeId){
        availableVehiclesList.add(item);
      }
    }
    selectedVehicleTypeName = vehicleTypesOptions[index].vehicleTypeName;
    isDataLoad = true;
    notifyListeners();
  }

  void changeIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  void availableVehicleOnTap(Driver driver) {

    print('on tap ${driver.vehicleSeats}');
    StaticInfo.selectedDriver = driver;
    Get.to(() => const CarDetailView());
  }
  @override
  void dispose() {
    isDataLoad = false;
    super.dispose();
  }
}
