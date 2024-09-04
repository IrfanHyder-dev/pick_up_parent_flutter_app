import 'dart:math' as math;
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pickup_parent/src/app/constants/constants.dart';
import 'package:pickup_parent/src/app/extensions.dart';
import 'package:pickup_parent/src/app/static_info.dart';
import 'package:pickup_parent/src/language/language_keys.dart';
import 'package:pickup_parent/src/theme/base_theme.dart';
import 'package:pickup_parent/ui/views/home/home_viewmodel.dart';
import 'package:pickup_parent/ui/views/notification/notification_view.dart';
import 'package:pickup_parent/ui/widgets/app_bar_widget.dart';
import 'package:pickup_parent/ui/widgets/button_widget.dart';
import 'package:pickup_parent/ui/widgets/home/home_child_detail_widget.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ScrollController childNameScrolCntrlr = ScrollController();

  Color firstGradientColor = lightThemeFirstGradientColor;
  Color secondGradientColor = lightThemeSecondGradientColor;

  @override
  Widget build(BuildContext context) {
    final mediaW = MediaQuery.of(context).size.width;
    final mediaH = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return ViewModelBuilder<HomeViewModel>.reactive(
      builder: (context, viewModel, child) {
        return Scaffold(
          body: Stack(
            children: [
              SizedBox(
                height: mediaH * 0.313,
                width: mediaW,
                child: SvgPicture.asset(
                  'assets/bg_image.svg',
                  fit: BoxFit.cover,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PreferredSize(
                    preferredSize: Size.fromHeight(kToolbarHeight),
                    child: AppBarWidget(
                      title: '',
                      titleStyle: textTheme.titleLarge!,
                      actionIcon: 'assets/black_bell_icon.svg',
                      actonIconOnTap: () =>
                          Get.to(() => const NotificationView()),
                    ),
                  ),
                  (mediaH * 0.026).vSpace(),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(start: 23),
                    child: Text(
                      'Welcome ${StaticInfo.userModel!.data.user.name}',
                      style: textTheme.displayLarge!.copyWith(fontSize: 24),
                    ),
                  ),
                  11.vSpace(),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(start: 23),
                    child: Text(
                      letsFindKey.tr,
                      style: textTheme.displayMedium!
                          .copyWith(color: theme.cardColor),
                    ),
                  ),
                  (mediaH * 0.042).vSpace(),
                  SizedBox(
                    height: 33,
                    width: mediaW,
                    child: FadingEdgeScrollView.fromScrollView(
                        child: ListView.separated(
                      controller: childNameScrolCntrlr,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      itemCount: viewModel.childList.length,
                      itemBuilder: (context, index) {
                        viewModel.selectedIndex =
                            viewModel.selectedChildColor(index: index);
                        print('index is ${viewModel.selectedIndex}');
                        return Center(
                          child: ButtonWidget(
                            btnText: viewModel.childList[index].name,
                            horizontalPadding: 25,
                            verticalPadding: 0,
                            radius: 10,
                            textStyle: textTheme.titleSmall!.copyWith(
                                height: 1,
                                color: (viewModel.selectedIndex == index)
                                    ? null
                                    : theme.unselectedWidgetColor),
                            bgColor: (viewModel.selectedIndex == index)
                                ? theme.primaryColor
                                : null,
                            onTap: () => viewModel.addOrRemoveSelectedChild(
                                index: index),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => 7.hSpace(),
                    )),
                  ),
                  (mediaH * 0.027).vSpace(),
                  if (viewModel.selectedChildList.isNotEmpty)
                    Container(
                      height: mediaH * 0.45,
                      width: mediaW,
                      margin: const EdgeInsets.symmetric(horizontal: hMargin),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          colors: [
                            firstGradientColor,
                            secondGradientColor,
                          ],
                          begin: const Alignment(-1.0, 0.0),
                          end: const Alignment(1.0, 0.0),
                          transform: const GradientRotation(math.pi / 4),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xff000000).withOpacity(0.1),
                            //Color.fromARGB(120, 0, 0, 0),
                            blurRadius: 30,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                              height: mediaH * 0.38,
                              child: HomeChildDetailWidget(
                                selectedChild: viewModel.selectedChildList,
                                isLocationDiff: viewModel.isLocationDiff,
                              )),
                          Padding(
                            padding: const EdgeInsetsDirectional.only(end: 26),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Checkbox(
                                  value: viewModel.isLocationDiff,
                                  activeColor: theme.primaryColor,
                                  fillColor: MaterialStatePropertyAll(
                                      (viewModel.isLocationDiff)
                                          ? theme.primaryColor
                                          : theme.cardColor),
                                  checkColor: profileBackColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(3),
                                      side: BorderSide(
                                          color: (viewModel.isLocationDiff)
                                              ? theme.primaryColor
                                              : theme.cardColor)),
                                  onChanged: (_) => viewModel.locationOff(),
                                ),
                                //3.hSpace(),
                                Text(
                                  locationDiffKey.tr,
                                  style: textTheme.bodyLarge!
                                      .copyWith(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  (0.02 * mediaH).vSpace(),
                  GestureDetector(
                    onTap: ()=> viewModel.moveToChoseRideScreen(),
                    child: Center(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                        decoration: BoxDecoration(
                          color: profileBackColor,
                          borderRadius: BorderRadius.circular(76),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset('assets/search_icon.svg'),
                            8.hSpace(),
                            Text(
                              findKey.tr,
                              style: textTheme.titleLarge!
                                  .copyWith(color: theme.unselectedWidgetColor),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
      viewModelBuilder: () => HomeViewModel(),
      onViewModelReady: (model) => SchedulerBinding.instance
          .addPostFrameCallback((_) => model.initialise()),
    );
  }
}
