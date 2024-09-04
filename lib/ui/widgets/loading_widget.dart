import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pickup_parent/src/app/extensions.dart';
import 'package:pickup_parent/src/theme/base_theme.dart';
import 'package:pickup_parent/ui/widgets/button_widget.dart';

class CustomDialog {
  static Future<void> showLoadingDialog(BuildContext context) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.16,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              child: Center(
                child: WillPopScope(
                  onWillPop: () async => false,
                  child: LoadingAnimationWidget.discreteCircle(
                      secondRingColor: Theme.of(context).primaryColorLight,
                      color: Theme.of(context).primaryColor, size: 50),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static Future<void> showInfoDialog({
    required BuildContext context,
    Color dialogBackGroundColor = Colors.white,
    required String infoText,
    required bool showSecondBtn,
    String? secondBtnText,
    double btnHorizontalPadding = 15,
    Function()? onTapBtn,
  }) async {
    double width = MediaQuery.of(context).size.width;
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return WillPopScope(
            onWillPop: () async => false,
            child: Dialog(
              backgroundColor: dialogBackGroundColor,
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Container(
                padding: EdgeInsets.all(24),
                child: Wrap(
                  children: [
                    Column(
                      children: [
                        Text(
                          // "If you want to proceed enable location to Always",
                          infoText,
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(height: 0, color: darkThemeDarkColor),
                        ),
                        // Spacer(flex: 2),
                        20.vSpace(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if(showSecondBtn)
                              ButtonWidget(
                                horizontalPadding: btnHorizontalPadding,
                                btnText: secondBtnText,
                                bgColor: Theme.of(context).primaryColor,
                                textStyle: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: defaultFontFamily,
                                    color: Colors.white,
                                    height: 0),
                                onTap:onTapBtn,
                              ),
                            15.hSpace(),
                            ButtonWidget(
                              btnText: "Back",
                              horizontalPadding: btnHorizontalPadding,
                              textStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: defaultFontFamily,
                                  color: Colors.white,
                                  height: 0),
                              bgColor: darkThemeDarkColor,
                              onTap: () {
                                Get.back();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }


  static Future<void> showRideNotStartedDialogDialog(BuildContext context) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return WillPopScope(
            onWillPop: () async => false,
            child: Dialog(
              backgroundColor: Theme.of(context).primaryColor,
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Container(
                padding: EdgeInsets.all(24),
                height: MediaQuery.of(context).size.height * 0.25,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Your Ride not started yet. \n Please come again later",
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(height: 0, color: Colors.white),
                    ),
                    Spacer(),
                    ButtonWidget(
                      btnText: "Back",
                      radius: 10,
                      textStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontFamily: defaultFontFamily,
                          color: Colors.white,
                          height: 0),
                      bgColor: darkThemeDarkColor,
                      onTap: () {
                        Get.back();
                        Get.back();
                      },
                    ),

                  ],
                ),
              ),
            ));
      },
    );
  }

}
