import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pickup_parent/models/user_model.dart';
import 'package:pickup_parent/services/auth_service.dart';
import 'package:pickup_parent/services/common_ui_service.dart';
import 'package:pickup_parent/services/shared_preference.dart';
import 'package:pickup_parent/src/app/apiErrorsMessage.dart';
import 'package:pickup_parent/src/app/constants/constants.dart';
import 'package:pickup_parent/src/app/locator.dart';
import 'package:pickup_parent/src/app/static_info.dart';
import 'package:pickup_parent/src/language/language_keys.dart';
import 'package:pickup_parent/ui/views/bottom_bar/bottom_bar_view.dart';
import 'package:pickup_parent/ui/views/profilel/parent_profile/parent_profile_view.dart';
import 'package:pickup_parent/ui/widgets/loading_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart'as http;

class LoginViewModel extends BaseViewModel with CommonUiService {
  AuthService authService = locator<AuthService>();
  final ScrollController scrollController = ScrollController();
  TextEditingController emailPhoneCon = TextEditingController();
  TextEditingController passwordCon = TextEditingController();
  String email = '';
  String phoneNo = '';


  void onTap(){

  }

  Future parentLogin(
      ) async {
    CustomDialog.showLoadingDialog(Get.context!);
    bool connectivity = await check();
    if(connectivity){
      print('phone number length ${phoneNo.length}  $phoneNo');
      http.Response response = await authService.loginParent(
          email: email, phoneNo: phoneNo, password: passwordCon.text.trim());

      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        if (decodedResponse["success"] == true) {
          UserModel userModel = UserModel.fromJson(decodedResponse);
          StaticInfo.userModel = userModel;
          SharedPreferencesService().saveUser(userModel);
          Get.back();
          if (StaticInfo.userModel!.data.user.profileCompleted) {
            Get.offAll(
              () => BottomBarView(index: 2),
            );
          } else {
            Get.offAll(() => const ParentProfileView());
          }
        } else {
          Get.back();
          showCustomErrorTextToast(
              context: Get.context!, text: decodedResponse["message"]);
        }
      } else {
        ApiErrorsMessage().showApiErrorsMessage(response.statusCode);
      }
    }else{
      Get.back();
      showCustomWarningTextToast(context: Get.context!, text: checkInternetKey.tr);
    }
  }

  String? emailValidator(val) {
    RegExp emailExp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    RegExp phoneRegExp = RegExp(
        r'^\+923\d{9}$|^923\d{9}$|^03\d{9}$');
    if (emailExp.hasMatch(val.toString())) {
      email = emailPhoneCon.text.trim();
    } else if (phoneRegExp
        .hasMatch(val.toString())) {
      // phoneNo = emailPhoneCon.text.trim();
      String number = emailPhoneCon.text.trim();
      if(number.length == 13){
        phoneNo = number.substring(3);
      }else if(number.length == 12){
        phoneNo = number.substring(2);
      }else{
        phoneNo = number.substring(1);
      }
      print('length ${phoneNo.length}');
    } else {
      return enterEmailOrMobRequireKey.tr;
    }
    return null;
  }

  String? passwordValidator(val) {
    if (val.toString().isEmpty) {
      return passRequiredKey.tr;
    }
    else {
      return null;
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    emailPhoneCon.dispose();
    passwordCon.dispose();
    super.dispose();
  }
}
