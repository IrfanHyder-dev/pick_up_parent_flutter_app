import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pickup_parent/models/user_model.dart';
import 'package:pickup_parent/services/auth_service.dart';
import 'package:pickup_parent/services/common_ui_service.dart';
import 'package:pickup_parent/services/shared_preference.dart';
import 'package:pickup_parent/src/app/constants/constants.dart';
import 'package:pickup_parent/src/app/locator.dart';
import 'package:pickup_parent/src/app/static_info.dart';
import 'package:pickup_parent/src/language/language_keys.dart';
import 'package:pickup_parent/ui/views/bottom_bar/bottom_bar_view.dart';
import 'package:pickup_parent/ui/views/profilel/parent_profile/parent_profile_view.dart';
import 'package:pickup_parent/ui/views/welcome/welcome_view.dart';
import 'package:stacked/stacked.dart';

class SplashViewModel extends BaseViewModel with CommonUiService{
  AuthService authService = locator<AuthService>();

  initialise() async {
    UserModel? userModel =SharedPreferencesService().getUser();


    if(userModel == null){
      Future.delayed(
          const Duration(seconds: 5), () => Get.off(const WelcomeView()));
    }
    else{
      print('user detail from share pref');
      print('${userModel.data.user.profileCompleted}');
      print('${userModel.data.user.userLocation.address}');
      bool connectivity = await check();
      if(connectivity){
        bool result = await authService.authTokenVerification(userModel.data.user.authToken);
        if(result){
          Future.delayed(
              const Duration(seconds: 5), () {
            StaticInfo.userModel = userModel;
            print('user detail from static model');
            print('${StaticInfo.userModel!.data.user.profileCompleted}');
            print('${StaticInfo.userModel!.data.user.userLocation.address}');
            if (StaticInfo.userModel!.data.user.profileCompleted) {
              Get.offAll(
                    () => BottomBarView(index: 2),
              );
            } else {
              Get.offAll(() => const ParentProfileView());
            }
          });
        }
        else{
          Future.delayed(
              const Duration(seconds: 5), () => Get.off(const WelcomeView()));
        }
      }
      else{
        showCustomWarningTextToast(context: Get.context!, text: checkInternetKey.tr);
      }

    }
  }
}
