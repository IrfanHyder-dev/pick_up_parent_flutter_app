import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pickup_parent/models/add_child_model.dart';
import 'package:pickup_parent/models/all_child_model.dart';
import 'package:pickup_parent/models/prediction.dart';
import 'package:pickup_parent/services/common_ui_service.dart';
import 'package:pickup_parent/services/profile_service.dart';
import 'package:pickup_parent/src/app/apiErrorsMessage.dart';
import 'package:pickup_parent/src/app/constants/constants.dart';
import 'package:pickup_parent/src/app/locator.dart';
import 'package:pickup_parent/src/app/static_info.dart';
import 'package:pickup_parent/src/language/language_keys.dart';
import 'package:pickup_parent/ui/views/profilel/current_location/current_location_view.dart';
import 'package:pickup_parent/ui/views/profilel/parent_profile/parent_profile_viewmodel.dart';
import 'package:pickup_parent/ui/widgets/loading_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

class AddChildViewModel extends BaseViewModel with CommonUiService {
  ProfileService profileService = locator<ProfileService>();
  ParentProfileViewModel parentProfileViewModel =
      locator<ParentProfileViewModel>();

  final formKey = GlobalKey<FormState>();
  AutovalidateMode autoValidate = AutovalidateMode.disabled;
  final ScrollController scrollController = ScrollController();
  TextEditingController startTimeCon = TextEditingController();
  TextEditingController endTimeCon = TextEditingController();
  TextEditingController dropOffCon = TextEditingController();
  TextEditingController childNameCon = TextEditingController();
  TextEditingController schoolNameCon = TextEditingController();
  TextEditingController pickUpCon = TextEditingController();
  final ScrollController placeListCon = ScrollController();
  bool showSuggestion = false;
  bool isPickupLocation = true;
  Timer? debounceTimer;
  DateTime selectedStartTime = DateTime.now();
  DateTime selectedEndTime = DateTime.now();

  List<Prediction> suggestions = [];
  LatLng? childDropOffLocLatLng;
  LatLng? childPickUPLocLatLng;
  List<AddChildModel> newChildList = [];
  AllChildModel? allChildModel;

  initialise({String? parentAddress}) {
    if (parentAddress!.isNotEmpty) {
      pickUpCon.text = parentAddress!;
    }
  }

  void debouncing({required Function() fn, int waitForMs = 1}) {
    debounceTimer?.cancel();
    debounceTimer = Timer(Duration(seconds: waitForMs), fn);
  }

  void getChildPickUpLocation() {
    print('profile');
    Get.to(() => CurrentLocationView(
          userCurrentLocation: (String address, double lat, double lng) {
            pickUpCon.text = address;
            childPickUPLocLatLng = LatLng(lat, lng);
            rebuildUi();
          },
        ));
  }

  void onChangeChildPickupField(value) {
    //viewModel.autoCompletePlaces(address: _textEditingController.text);
    debouncing(
      fn: () {
        if (pickUpCon.text.isNotEmpty) {
          autoCompletePlaces(address: pickUpCon.text);
        }
      },
    );
    if (value.isEmpty) {
      showSuggestion = false;
    } else {
      isPickupLocation = true;
      showSuggestion = true;
    }
    rebuildUi();
  }

  void getChildDropOffLoc() {
    print('profile');
    Get.to(() => CurrentLocationView(
          userCurrentLocation: (String address, double lat, double lng) {
            dropOffCon.text = address;
            childDropOffLocLatLng = LatLng(lat, lng);
            rebuildUi();
          },
        ));
  }

  void onChangeChildDropOffField(value){

      debouncing(
        fn: () {
          if(dropOffCon.text.isNotEmpty){
            autoCompletePlaces(
                address: dropOffCon.text);
          }

        },
      );
      if (value.isEmpty) {
        showSuggestion = false;
      } else {
        isPickupLocation = false;
        showSuggestion = true;
      }
    rebuildUi();
  }

  void getChildStartTime (time) {
    var outputFormat =
    DateFormat(
        'hh:mm a');
    var outputDate =
    outputFormat
        .format(
        time);
      selectedStartTime = time;
      endTimeCon.text = '';
      startTimeCon.text =
          outputDate;

    print('timeeeeeeeeeeeeeeeeeeeeeeeee ${startTimeCon.text}   ${selectedStartTime}  ${outputDate}');
 rebuildUi();
  }

  getChildEndTime (time) {
    var outputFormat =
    DateFormat(
        'hh:mm a');
    var outputDate =
    outputFormat
        .format(
        time);

      selectedEndTime = time;
      endTimeCon.text =
          outputDate;

    print(time);
    rebuildUi();
  }

  void autoValidateForm(){
    autoValidate = AutovalidateMode.onUserInteraction;
    rebuildUi();
  }

  Future<void> autoCompletePlaces({required String address}) async {
    http.Response response =
        await profileService.autocompletePlaces(address: address);
    if (response.statusCode == 200 &&
        (jsonDecode(response.body)['status'] == "OK" ||
            jsonDecode(response.body)['status'] == "ZERO_RESULTS")) {
      final predictions =
          jsonDecode(response.body)['predictions'] as List<dynamic>;
      var result = predictions
          .map((prediction) => Prediction.fromJson(prediction))
          .toList();
      if (result != null) {
        suggestions.clear();
        for (final place in result) {
          suggestions.add(place);
        }
      } else {
        showCustomErrorTextToast(
            context: Get.context!, text: googleMapErrKey.tr);
      }
    } else {
      showCustomErrorTextToast(context: Get.context!, text: googleMapErrKey.tr);
    }

    rebuildUi();
  }

  Future<void> getLatLng(String placeId, int type) async {
    CustomDialog.showLoadingDialog(Get.context!);
    dynamic result = await profileService.getLatLng(placeId);
    if (result != null) {
      if (type == 1) {
        childPickUPLocLatLng = LatLng(result['lat'], result['lng']);
      } else {
        childDropOffLocLatLng = LatLng(result['lat'], result['lng']);
      }
    }
    Get.back();
  }

  Future<void> addChild({
    required String name,
    required String schoolName,
    required String startTime,
    required String endTime,
    required String dropOffLocation,
    required String pickUpLocation,
    required DateTime selectedStartTime,
    required DateTime selectedEndTime,
  }) async {
    CustomDialog.showLoadingDialog(Get.context!);
    bool connectivity = await check();
    if (connectivity) {
      if (childPickUPLocLatLng == null) {
        childPickUPLocLatLng = LatLng(
          double.parse(
              StaticInfo.userModel!.data.user.userLocation.lat.toString()),
          double.parse(
              StaticInfo.userModel!.data.user.userLocation.long.toString()),
        );
      }
      newChildList.add(AddChildModel(
        name: name,
        // startTime: startTime,
        // endTime: endTime,
        startTime: selectedStartTime,
        endTime: selectedEndTime,
        schoolName: schoolName,
        dropOffLat: childDropOffLocLatLng!.latitude,
        dropOffLong: childDropOffLocLatLng!.longitude,
        dropOffLocation: dropOffLocation,
        pickUpLat: childPickUPLocLatLng!.latitude,
        pickUpLong: childPickUPLocLatLng!.longitude,
        pickUpLocation: pickUpLocation,
      ));
      http.Response result = await profileService.addChild(newChildList);
      if (result.statusCode == 200) {
        var decodedResponse = jsonDecode(result.body);
        if (decodedResponse['success'] == true) {
          allChildModel = AllChildModel.fromJson(decodedResponse);
          for (int i = 0; i < allChildModel!.child.length; i++) {
            print('add child vModel ${allChildModel!.child[i].name}');
            print(
                'add child vModel ${allChildModel!.child[i].dropOff.address}');
            print('add child vModel ${allChildModel!.child[i].pickUp.address}');
          }
          newChildList.clear();
          Get.back();
          Get.back(result: allChildModel);
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
}
