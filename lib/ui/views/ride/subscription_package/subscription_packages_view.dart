import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pickup_parent/src/app/constants/constants.dart';
import 'package:pickup_parent/src/app/extensions.dart';
import 'package:pickup_parent/src/language/language_keys.dart';
import 'package:pickup_parent/src/theme/base_theme.dart';
import 'package:pickup_parent/ui/views/ride/subscription_detail/subscription_detail_view.dart';
import 'package:pickup_parent/ui/views/ride/subscription_package/subscription_packages_viewmodel.dart';
import 'package:pickup_parent/ui/widgets/app_bar_widget.dart';
import 'package:pickup_parent/ui/widgets/button_widget.dart';
import 'package:pickup_parent/ui/widgets/subscription_package_widget.dart';
import 'package:stacked/stacked.dart';

class SubscriptionPackagesView extends StatefulWidget {
  const SubscriptionPackagesView({super.key});

  @override
  State<SubscriptionPackagesView> createState() =>
      _SubscriptionPackagesViewState();
}

class _SubscriptionPackagesViewState extends State<SubscriptionPackagesView> {


  @override
  Widget build(BuildContext context) {
    final mediaW = MediaQuery.of(context).size.width;
    final mediaH = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    const Color packageClr = lightThemeHistoryColor;
    return ViewModelBuilder<SubscriptionPackagesViewModel>.reactive(
      builder: (context, viewModel, child) {
        return Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBarWidget(
                title: subscription$fareKey.tr,
                titleStyle: textTheme.titleLarge!,
                leadingIcon: 'assets/back_arrow_light.svg',
                leadingIconOnTap: () => Get.back(),
                actionIcon: 'assets/black_bell_icon.svg',
              ),
              Container(
                width: mediaW,
                padding: const EdgeInsets.symmetric(horizontal: hMargin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (0.046 * mediaH).vSpace(),
                    Row(
                      children: [
                        Text(
                          packageKey.tr,
                          style: textTheme.displayMedium!.copyWith(fontSize: 20),
                        ),
                        Spacer(),
                        Text(
                          (viewModel.selectedChild.length < 2)?
                          '${viewModel.selectedChild.length} ${personKey.tr}' :'${viewModel.selectedChild.length} ${personsKey.tr}' ,
                          style: textTheme.displaySmall!.copyWith(fontSize: 15,color:profileBackColor.withOpacity(0.5),height: 1),
                        ),
                      ],
                    ),
                    (0.024 * mediaH).vSpace(),
                    SizedBox(
                    height: 120,
                      width: mediaW,
                      child: SubscriptionPackageWidget(),
                    ),
                    (0.047 * mediaH).vSpace(),
                    Text(
                      currentSelectedKey.tr,
                      style: textTheme.displayMedium!.copyWith(fontSize: 20),
                    ),
                    (0.06 * mediaH).vSpace(),
                    (viewModel.isDataLoad)?
                    Center(
                      child: Container(
                        height: 148,
                        width: 260,
                        decoration: BoxDecoration(
                          color: theme.unselectedWidgetColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: theme.cardColor),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 56,
                              width: 180,
                              decoration: BoxDecoration(
                                color: theme.dialogBackgroundColor,
                                borderRadius: const BorderRadiusDirectional.only(
                                    topStart: Radius.circular(15),
                                    bottomEnd: Radius.circular(16)),
                              ),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.only(
                                    top: 1, start: 15, end: 15, bottom: 10),
                                child: Image.asset('assets/car_img.png'),
                              ),
                            ),
                            21.vSpace(),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 13),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        viewModel.driver!.name,
                                        style: textTheme.displayMedium,
                                      ),
                                      const Spacer(),
                                      Text(
                                        '${viewModel.driver!.fareAmount.toStringAsFixed(0)}/Pkr',
                                        style: textTheme.displayMedium!
                                            .copyWith(fontSize: 14),
                                      )
                                    ],
                                  ),
                                  13.vSpace(),
                                  SvgPicture.asset('assets/dash_divider.svg'),
                                  12.vSpace(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset('assets/seat_icon.svg'),
                                      8.hSpace(),
                                      SizedBox(
                                        width: 40,
                                        child: Text(
                                          '${(viewModel.driver!.vehicleSeats != null)?viewModel.driver!.vehicleSeats : 0} ${seatKey.tr}',
                                          style: textTheme.bodySmall,
                                          maxLines: 2,
                                        ),
                                      ),
                                      13.hSpace(),
                                      SvgPicture.asset(
                                          'assets/color_pallet_icon.svg'),
                                      8.hSpace(),
                                      SizedBox(
                                        width: 40,
                                        child: Text(
                                          (viewModel.driver!.vehicleColor.isNotEmpty)? viewModel.driver!.vehicleColor : '',
                                          maxLines: 2,
                                          style: textTheme.bodySmall,
                                        ),
                                      ),
                                      13.hSpace(),
                                      SvgPicture.asset(
                                          'assets/number_plate_icon.svg'),
                                      8.hSpace(),
                                      Container(
                                        //height: 50,
                                        width: 40,
                                        child: Text(
                                          (viewModel.driver!.vehicleNumberPlate !=null)?viewModel.driver!.vehicleNumberPlate! : '',
                                          maxLines: 2,
                                          style: textTheme.bodySmall,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ): Container(),
                    (0.032 * mediaH).vSpace(),
                    Container(
                      height: 99,
                      padding: const EdgeInsets.symmetric(
                          horizontal: hMargin, vertical: 12),
                      decoration: BoxDecoration(
                        color: packageClr,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: theme.cardColor),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset('assets/big_bell.svg'),
                          17.hSpace(),
                          SizedBox(
                            width: 205,
                            child: Column(
                              children: [
                                Text(
                                  fairRaisedKey.tr,
                                  style: textTheme.displayMedium!.copyWith(
                                      fontSize: 14,
                                      overflow: TextOverflow.visible),
                                ),
                                15.vSpace(),
                                Text(
                                  notifyKey.tr,
                                  style: textTheme.bodyLarge,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    (0.032 * mediaH).vSpace(),
                    Center(
                      child: ButtonWidget(
                        btnText: submitKey.tr,
                        textStyle: textTheme.titleLarge!
                            .copyWith(color: theme.unselectedWidgetColor),
                        width: 145,
                        height: 48,
                        radius: 76,
                        onTap: () {
                        viewModel.createBooking();
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
      viewModelBuilder: () => SubscriptionPackagesViewModel(),
      onViewModelReady: (viewModel) => SchedulerBinding.instance.addPostFrameCallback((_)=> viewModel.initialise()),
    );
  }
}
