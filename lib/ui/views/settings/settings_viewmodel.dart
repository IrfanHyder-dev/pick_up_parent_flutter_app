import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pickup_parent/services/auth_service.dart';
import 'package:pickup_parent/services/common_ui_service.dart';
import 'package:pickup_parent/services/notification_service.dart';
import 'package:pickup_parent/src/app/apiErrorsMessage.dart';
import 'package:pickup_parent/src/app/constants/constants.dart';
import 'package:pickup_parent/src/app/locator.dart';
import 'package:pickup_parent/src/app/static_info.dart';
import 'package:pickup_parent/src/language/language_keys.dart';
import 'package:pickup_parent/ui/widgets/loading_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../../../models/base_model.dart';

class SettingsViewModel extends BaseViewModel with CommonUiService {
  AuthService authService = locator<AuthService>();
  NotificationService notificationService = locator<NotificationService>();

  bool value = true;

  initialise() {
    value = StaticInfo.userModel!.data.user.mobileNotifications;
  }

  Future logout() async {
    authService.logout();
  }

  Future<void> launchURL() async {
    final Uri deleteAccountUrl = Uri.parse('$url/delete_my_account');
    if (!await launchUrl(deleteAccountUrl)) {
      throw Exception('Could not launch $deleteAccountUrl');
    }
  }

  void switchButtonOnChange(bool val) {
    value = val;
    stopNotification(status: val);
    rebuildUi();
  }

  Future<void> stopNotification({required bool status}) async {
    CustomDialog.showLoadingDialog(Get.context!);
    bool connectivity = await check();
    if(connectivity){
      http.Response result =
          await notificationService.stopNotification(status: status);
      if (result.statusCode == 200) {
        var decodedResponse = jsonDecode(result.body);
        if (decodedResponse['success'] == true) {
          Get.back();
        } else {
          Get.back();
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
