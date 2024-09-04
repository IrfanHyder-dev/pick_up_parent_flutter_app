import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:pickup_parent/src/app/extensions.dart';
import 'package:pickup_parent/src/language/language_keys.dart';
import 'package:pickup_parent/ui/views/auth/login/login_view.dart';
import 'package:pickup_parent/ui/views/auth/signin/signup/signup_view.dart';
import 'package:pickup_parent/ui/views/welcome/welcome_viewmodel.dart';
import 'package:pickup_parent/ui/widgets/button_widget.dart';
import 'package:pickup_parent/ui/widgets/pop_scope_dialog_widget.dart';
import 'package:stacked/stacked.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({Key? key}) : super(key: key);

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaH = MediaQuery.of(context).size.height;
    final mediaW = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return ViewModelBuilder<WelcomeViewmodel>.reactive(
      builder: (context, viewModel, child) {
        return WillPopScope(
          onWillPop: () async {
            bool? shouldPop = await showDialog<bool>(
              context: context,
              builder: (context) {
                return PopScopeDialogWidget();
              },
            );
            if (shouldPop == true) {
              MoveToBackground.moveTaskToBack();
              return false;
            } else {
              return false;
            }
          },
          child: Scaffold(
            body: Container(
              child: Column(
                children: [
                  (mediaH * 0.357).vSpace(),
                  SizedBox(
                      //height: 63,
                      width: 180,
                      child: Image.asset('assets/papne_cab.png')),
                  (mediaH * 0.058).vSpace(),
                  Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 47),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Welcome to ',
                              style: textTheme.titleLarge!.copyWith(
                                  fontWeight: FontWeight.w400, fontSize: 30),
                            ),
                            TextSpan(
                              text: 'Papne',
                              recognizer: TapGestureRecognizer(),
                              // ..onTap = () {
                              //   Get.to(() => LoginView());
                              // },
                              style: textTheme.titleLarge!.copyWith(
                                  color: theme.primaryColor,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  (mediaH * 0.068).vSpace(),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 37),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 48,
                          width: 136,
                          child: ButtonWidget(
                            radius: 76,
                            horizontalPadding: 0,
                            verticalPadding: 0,
                            btnText: loginKey.tr,
                            textStyle: textTheme.titleLarge!.copyWith(color: theme.scaffoldBackgroundColor),
                            onTap: (){Get.to(const LoginView());},
                          ),
                        ),
                        14.hSpace(),
                        SizedBox(
                          height: 48,
                          width: 136,
                          child: ButtonWidget(
                            radius: 76,
                            horizontalPadding: 0,
                            verticalPadding: 0,
                            btnText: signUpKey.tr,
                            textStyle: textTheme.titleLarge!.copyWith(color: theme.scaffoldBackgroundColor),
                          onTap: () {Get.to(const SignUpView());},
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      viewModelBuilder: () => WelcomeViewmodel(),
    );
  }
}
