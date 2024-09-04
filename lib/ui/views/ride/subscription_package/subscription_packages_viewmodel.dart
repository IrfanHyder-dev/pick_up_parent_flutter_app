import 'dart:convert';

import 'package:get/get.dart';
import 'package:pickup_parent/models/all_child_model.dart';
import 'package:pickup_parent/models/available_drivers_model.dart';
import 'package:pickup_parent/models/booking_response_model.dart';
import 'package:pickup_parent/services/common_ui_service.dart';
import 'package:pickup_parent/services/vehical_service.dart';
import 'package:pickup_parent/src/app/apiErrorsMessage.dart';
import 'package:pickup_parent/src/app/constants/constants.dart';
import 'package:pickup_parent/src/app/locator.dart';
import 'package:pickup_parent/src/app/static_info.dart';
import 'package:pickup_parent/src/language/language_keys.dart';
import 'package:pickup_parent/ui/views/bottom_bar/bottom_bar_view.dart';
import 'package:pickup_parent/ui/views/ride/chose_ride/chose_ride_viewmodel.dart';
import 'package:pickup_parent/ui/widgets/loading_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

class SubscriptionPackagesViewModel extends BaseViewModel with CommonUiService{

  ChoseRideViewModel choseRideViewModel = locator<ChoseRideViewModel>();
  VehicleService vehicleService = locator<VehicleService>();
  bool isPackageSelected = false;
  int selectedIndex = 0;
  List<Child> selectedChild= [];
  Driver? driver;
  bool isDataLoad = false;
  BookingResponseModel? bookingResponseModel;

  initialise() {
    getSelectedChildList();

  }

  void getSelectedChildList(){
    selectedChild.clear();
    selectedChild.addAll(choseRideViewModel.selectedChildList);
    driver = StaticInfo.selectedDriver!;
    isDataLoad = true;
    notifyListeners();
  }

  Future createBooking() async{
    CustomDialog.showLoadingDialog(Get.context!);
    bool connectivity = await check();
    if(connectivity){
      List<int> selectedChildId = [];
      for (final item in selectedChild) {
        selectedChildId.add(item.id);
      }
      http.StreamedResponse response = await vehicleService.createBooking(
          ids: selectedChildId);
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var decodedResponse = jsonDecode(responseData);
        if (decodedResponse['success'] == true) {
          bookingResponseModel = BookingResponseModel.fromJson(decodedResponse);
          Get.back();
          Get.to(() => BottomBarView(index: 2,));
          showCustomSuccessTextToast(
              context: Get.context!, text: decodedResponse['message']);
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

}