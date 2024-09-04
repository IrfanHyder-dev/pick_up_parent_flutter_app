import 'dart:async';
import 'dart:convert';

import 'package:action_slider/action_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pickup_parent/services/auth_service.dart';
import 'package:pickup_parent/services/common_ui_service.dart';
import 'package:pickup_parent/src/app/apiErrorsMessage.dart';
import 'package:pickup_parent/src/app/constants/constants.dart';
import 'package:pickup_parent/src/app/locator.dart';
import 'package:pickup_parent/src/language/language_keys.dart';
import 'package:pickup_parent/ui/views/bottom_bar/bottom_bar_view.dart';
import 'package:pickup_parent/ui/views/profilel/parent_profile/parent_profile_view.dart';
import 'package:pickup_parent/ui/widgets/loading_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

class OtpViewModel extends BaseViewModel with CommonUiService {
  AuthService authService = locator<AuthService>();

  String verificationCode = '';
  TextEditingController verificationCodeCont = TextEditingController();
  ActionSliderController controller = ActionSliderController();
  final ScrollController scrollController = ScrollController();

  bool hasError = false;
  int start = 50;
  Timer? timer;
  int iconType = 0;

  initialise() {
    startTimer();
  }

  void startTimer() {
    print('timer');
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (start < 1) {
          timer.cancel();
        } else {
          start--;
        }
        notifyListeners();
      },
    );
    notifyListeners();
  }

  void onChange(value) {
    verificationCode = value;
    notifyListeners();
  }

  void onAction(controller) async {
    //print('timer');

    iconType = 1;
    notifyListeners();
    controller.loading(); //starts loading animation
    await Future.delayed(const Duration(seconds: 3));

    iconType = 2;
    notifyListeners();
    controller.success(); //starts success animation
    await Future.delayed(const Duration(seconds: 1));

    iconType = 0;
    notifyListeners();
    controller.reset(); //resets the slider

    start = 50;
    verificationCodeCont.text = '';
    startTimer();
    notifyListeners();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future otpVerification() async {
    CustomDialog.showLoadingDialog(Get.context!);
   bool connectivity = await check();
    if(connectivity){
      http.Response response =
          await authService.otpVerificationCode(otpCode: verificationCode);
      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        if (decodedResponse['success'] == true) {
          Get.back();
          Get.offAll(() => const ParentProfileView());
        } else {
          Get.back();
          showCustomErrorTextToast(
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
