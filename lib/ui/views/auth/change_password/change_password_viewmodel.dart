import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pickup_parent/services/auth_service.dart';
import 'package:pickup_parent/services/common_ui_service.dart';
import 'package:pickup_parent/services/profile_service.dart';
import 'package:pickup_parent/src/app/apiErrorsMessage.dart';
import 'package:pickup_parent/src/app/constants/constants.dart';
import 'package:pickup_parent/src/app/locator.dart';
import 'package:pickup_parent/src/language/language_keys.dart';
import 'package:pickup_parent/ui/widgets/loading_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart'as http;

class ChangePasswordViewModel extends BaseViewModel with CommonUiService{
  AuthService authService = locator<AuthService>();
  final ScrollController scrollController = ScrollController();
  TextEditingController oldPasswordCon = TextEditingController();
  TextEditingController newPasswordCon = TextEditingController();
  TextEditingController confirmPasswordCon = TextEditingController();

  Future<void> changePassword()async{
    CustomDialog.showLoadingDialog(Get.context!);
    bool connectivity = await check();
    if(connectivity){
      http.Response result = await authService.changePassword(
          oldPassword: oldPasswordCon.text.trim(), newPassword: newPasswordCon.text.trim());

      if (result.statusCode == 200) {
        var decodedResponse = jsonDecode(result.body);
        if (decodedResponse['success'] == true) {
          oldPasswordCon.text = '';
          newPasswordCon.text = '';
          confirmPasswordCon.text = '';
          Get.back();
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
    }else{
      Get.back();
      showCustomWarningTextToast(context: Get.context!, text: checkInternetKey.tr);
    }
  }
}