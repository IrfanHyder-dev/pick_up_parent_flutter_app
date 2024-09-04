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
import 'package:pickup_parent/ui/views/auth/otp/otp_view.dart';
import 'package:pickup_parent/ui/widgets/loading_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart'as http;

class SignUpViewModel extends BaseViewModel with CommonUiService {
  AuthService authService = locator<AuthService>();
  final ScrollController formScrollController = ScrollController();
  final ScrollController screenScrollController = ScrollController();
  TextEditingController nameCon = TextEditingController();
  TextEditingController surNameCon = TextEditingController();
  TextEditingController phoneCon = TextEditingController();
  TextEditingController emailCon = TextEditingController();
  TextEditingController passwordCon = TextEditingController();

  Future signUpParent() async {
    CustomDialog.showLoadingDialog(Get.context!);
    bool connectivity  = await check();
    if(connectivity){
      http.Response result = await authService.signUpParent(
        name: nameCon.text.trim(),
        surName: surNameCon.text.trim(),
        phoneNumber: phoneCon.text.trim(),
        email: emailCon.text.trim(),
        password: passwordCon.text.trim(),
      );
      if (result.statusCode == 200) {
        var decodedResponse = json.decode(result.body);
        if (decodedResponse['success'] == true) {
          UserModel userModel = UserModel.fromJson(decodedResponse);
          StaticInfo.userModel = userModel;
          SharedPreferencesService().saveUser(userModel);
          Get.back();
          Get.offAll(() => const OtpView());
        } else {
          Get.back();
          showCustomErrorTextToast(
              context: Get.context!, text: '${decodedResponse['errors'][0]}');
        }
      }
      else{
        ApiErrorsMessage().showApiErrorsMessage(result.statusCode);
      }
    }else{
      Get.back();
      showCustomWarningTextToast(context: Get.context!, text: checkInternetKey.tr);
    }
  }

  String? nameValidator(val) {
    if (val.toString().isEmpty) {
      return nameRequiredKey.tr;
    } else {
      return null;
    }
  }

  String? surNameValidator(val) {
    if (val.toString().isEmpty) {
      return surnameRequiredKey.tr;
    } else {
      return null;
    }
  }

  String? phoneValidator(val) {
    RegExp regExp = RegExp(r'^(\03|3)\d{9}$');
    if (val.toString().isEmpty) {
      return mobNumbRequiredKey.tr;
    } else if (!regExp.hasMatch(val.toString())) {
      return validMobNumberKey.tr;
    } else {
      return null;
    }
  }

  String? emailValidator(val) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(p);
    if (val.toString().isEmpty) {
      return emailRequiredKey.tr;
    } else if (!regExp.hasMatch(val!)) {
      return validEmailKey.tr;
    } else {
      return null;
    }
  }

  String? passwordValidator(val) {
    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (val.toString().isEmpty) {
      return passRequiredKey.tr;
    } else if (!regex.hasMatch(val.toString())) {
      return passInstructionKey.tr;
    } else {
      return null;
    }
  }

  @override
  void dispose() {
    formScrollController.dispose();
    screenScrollController.dispose();
    nameCon.dispose();
    surNameCon.dispose();
    phoneCon.dispose();
    emailCon.dispose();
    passwordCon.dispose();
    super.dispose();
  }
}
