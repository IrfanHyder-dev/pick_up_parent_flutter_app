import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:pickup_parent/models/all_child_model.dart';
import 'package:pickup_parent/models/prediction.dart';
import 'package:pickup_parent/models/user_model.dart';
import 'package:pickup_parent/services/common_ui_service.dart';
import 'package:pickup_parent/services/profile_service.dart';
import 'package:pickup_parent/services/shared_preference.dart';
import 'package:pickup_parent/src/app/apiErrorsMessage.dart';
import 'package:pickup_parent/src/app/constants/constants.dart';
import 'package:pickup_parent/src/app/locator.dart';
import 'package:pickup_parent/src/app/static_info.dart';
import 'package:pickup_parent/src/language/language_keys.dart';
import 'package:pickup_parent/ui/views/bottom_bar/bottom_bar_view.dart';
import 'package:pickup_parent/ui/views/bottom_bar/bottom_bar_viewmodel.dart';
import 'package:pickup_parent/ui/views/profilel/add_child/add_child_view.dart';
import 'package:pickup_parent/ui/widgets/loading_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

@injectable
class ParentProfileViewModel extends BaseViewModel with CommonUiService {
  ProfileService profileService = locator<ProfileService>();

  List<Prediction> suggestions = [];
  List<AllChildModel> allChildList = [];
  LatLng? parentLocLatLng;
  String? parentAddress;
  File? parentImage;
  AllChildModel? allChildModel;

  initialise() async {
    print('init');
    CustomDialog.showLoadingDialog(Get.context!);
    fetchAllChild();
  }

  Future<void> autoCompletePlaces({required String address}) async {
    http.Response response = await profileService.autocompletePlaces(address: address);
    if (response.statusCode == 200 && (jsonDecode(response.body)['status'] == "OK" || jsonDecode(response.body)['status'] == "ZERO_RESULTS")) {
      final predictions = jsonDecode(response.body)['predictions'] as List<dynamic>;
      var result =  predictions.map((prediction) => Prediction.fromJson(prediction)).toList();
      if (result != null) {
        suggestions.clear();
        for (final place in result) {
          suggestions.add(place);
        }
      }else{
        FocusManager.instance.primaryFocus?.unfocus();
        showCustomErrorTextToast(context: Get.context!, text: googleMapErrKey.tr);
      }
    } else {
      FocusManager.instance.primaryFocus?.unfocus();
      showCustomErrorTextToast(context: Get.context!, text: googleMapErrKey.tr);
    }

    rebuildUi();
  }


  Future<void> getLatLng(String placeId) async {
    CustomDialog.showLoadingDialog(Get.context!);
    dynamic result = await profileService.getLatLng(placeId);
    if (result != null) {
      parentLocLatLng = LatLng(result['lat'], result['lng']);
    }
    Get.back();
  }

  Future<void> updateParentProfile({
    required String address,
    required String name,
    required String imagePath,
  }) async {
    CustomDialog.showLoadingDialog(Get.context!);
    bool connectivity = await check();
    if (connectivity) {
      if (StaticInfo.userModel!.data.user.profileCompleted) {
        parentAddress = StaticInfo.userModel!.data.user.userLocation.address!;
        parentLocLatLng = LatLng(
            double.parse(StaticInfo.userModel!.data.user.userLocation.lat!),
            double.parse(StaticInfo.userModel!.data.user.userLocation.long!));
      } else {
        parentAddress = address;
      }
      http.StreamedResponse result = await profileService.updateParentProfile(
          address: parentAddress!,
          lat: parentLocLatLng!.latitude,
          lng: parentLocLatLng!.longitude,
          name: name,
          imagePath: imagePath);

      if (result.statusCode == 200) {
        var responseData = await result.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        var decodedResponse = jsonDecode(responseString);
        if (decodedResponse['success'] == true) {
          print('profile viewModel');
          log(responseString);
          debugPrint(responseString);
          UserModel userModel = UserModel.fromJson(decodedResponse);
          SharedPreferencesService().saveUser(userModel);
          StaticInfo.userModel = userModel;
          print('profile screen11 ${StaticInfo.userModel!.data.user.profileCompleted}');
          rebuildUi();
          Get.back();
          Get.to(() => BottomBarView(index: 2));
          //BottomBarViewModel bottomBarViewModel = locator<BottomBarViewModel>();
          //bottomBarViewModel.pageController!.jumpTo(2);
          showCustomSuccessTextToast(
              context: Get.context!, text: decodedResponse['message']);
        } else {
          Get.back();
          showCustomErrorTextToast(
              context: Get.context!, text: decodedResponse['message']);
        }
      } else {
        ApiErrorsMessage().showApiErrorsMessage(result.statusCode);
      }
    } else {
      Get.back();
      showCustomWarningTextToast(
          context: Get.context!, text: checkInternetKey.tr);
    }
  }

  Future<void> fetchAllChild() async {
    http.Response result = await profileService.fetchAllChild();
    if (result.statusCode == 200) {
      var decodedResponse = jsonDecode(result.body);
      if (decodedResponse['success'] == true) {
        allChildModel = AllChildModel.fromJson(decodedResponse);
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
  }

  Future<void> deleteChild({required int childId,required BuildContext context}) async {
    CustomDialog.showLoadingDialog(context);
    http.Response result = await profileService.deleteChild(childId: childId);
    if (result.statusCode == 200) {
      var decodedResponse = jsonDecode(result.body);
      if (decodedResponse['success'] == true) {
        allChildModel?.child.removeWhere((element) => element.id == childId);
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
  }

  void updateChildModelLocally(
      {AllChildModel? newChildData, String? parentAddress}) async {
    AllChildModel response = await Get.to(() => AddChildView(
          parentAddress: parentAddress,
        ));
    if (response != null) {
      if (allChildModel != null) {
        allChildModel!.child.add(response.child[0]);
      } else {
        allChildModel = response;
      }
      rebuildUi();
      showCustomSuccessTextToast(
          context: Get.context!, text: 'Child Added Successfully');
    }
  }
}
