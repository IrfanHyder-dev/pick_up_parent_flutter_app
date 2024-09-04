import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pickup_parent/models/all_subscriptions_model.dart';
import 'package:pickup_parent/src/app/constants/constants.dart';
import 'package:pickup_parent/src/app/enum/enum.dart';
import 'package:pickup_parent/src/app/extensions.dart';
import 'package:pickup_parent/src/app/static_info.dart';
import 'package:pickup_parent/src/language/language_keys.dart';
import 'package:pickup_parent/src/theme/base_theme.dart';
import 'package:pickup_parent/ui/views/tracking/vehicle_tracking_viewmodel.dart';
import 'package:pickup_parent/ui/widgets/app_bar_widget.dart';
import 'package:pickup_parent/ui/widgets/loading_widget.dart';
import 'package:pickup_parent/ui/widgets/tracking/driver_info_row_widget.dart';
import 'package:flutter_animarker/flutter_map_marker_animation.dart';
import 'package:stacked/stacked.dart';

class VehicleTrackingView extends StatefulWidget {
  List<ChildElement>? children;
  int? driverId;
  Driver? driver;
  bool isComingFromNotification = false;
  int quotationId;
  DateTime? dateTimeOfArrivedDriver;

  VehicleTrackingView(
      {this.children,
      this.driverId,
      this.driver,
      required this.isComingFromNotification,
      required this.quotationId,
      this.dateTimeOfArrivedDriver});

  @override
  State<VehicleTrackingView> createState() => _VehicleTrackingViewState();
}

class _VehicleTrackingViewState extends State<VehicleTrackingView> {
  @override
  Widget build(BuildContext context) {
    final mediaW = MediaQuery.of(context).size.width;
    final mediaH = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return ViewModelBuilder<VehicleTrackingViewModel>.reactive(
      builder: (context, viewModel, child) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
          ),
          child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: AppBarWidget(
                title: vehicleTrackingKey.tr,
                titleStyle: textTheme.titleLarge!,
                leadingIcon: 'assets/back_arrow_white.svg',
                leadingIconOnTap: () => Get.back(),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Animarker(
                        mapId: viewModel.completer.future
                            .then<int>((value) => value.mapId),
                        markers: <Marker>{
                          ...viewModel.carMarker.values.toSet(),
                        },
                        duration: Duration(milliseconds: 3500),
                        zoom: 16.4746,
                        // onStopover: viewModel.onStopover,
                        child: GoogleMap(
                          markers: viewModel.markers,
                          polylines: Set<Polyline>.of(viewModel.polyLines),
                          onMapCreated: (GoogleMapController controller) {
                            if (!viewModel.completer.isCompleted) {
                              viewModel.completer.complete(controller);
                            }
                          },
                          initialCameraPosition: viewModel.cameraPosition,
                        ),
                      ),
                      if (viewModel.timeToDisplay.isNotEmpty)
                        TimerWidget(mediaH, textTheme, viewModel.timeToDisplay,
                            viewModel.textToDisplayOnTimerUi),
                    ],
                  ),
                ),
                if (viewModel.driver != null)
                  Container(
                    width: mediaW,
                    decoration: BoxDecoration(
                      color: theme.unselectedWidgetColor,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xff000000).withOpacity(0.1),
                          blurRadius: 30,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Container(
                        width: mediaW,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 25),
                        padding: const EdgeInsets.only(
                          bottom: 20,
                        ),
                        decoration: BoxDecoration(
                          color: theme.unselectedWidgetColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xff000000).withOpacity(0.1),
                              blurRadius: 30,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            DriverInfoRowWidget(
                              driver: viewModel.driver!,
                              onTapPhone: () => viewModel.makePhoneCall(
                                  viewModel.driver?.contactNumber ?? '', false),
                              onTapSms: () => viewModel.makePhoneCall(
                                  viewModel.driver?.contactNumber ?? '', true),
                            ),
                            12.vSpace(),
                            Container(
                              width: double.infinity,
                              height: 22,
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: FadingEdgeScrollView.fromScrollView(
                                child: ListView.separated(
                                  controller: viewModel.scrollController,
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: viewModel.childrenList.length,
                                  itemBuilder: (context, index) {
                                    print('======================== ride status ride status ${viewModel.childrenList[index].rideStatus}');
                                    bool disableField = viewModel
                                        .childrenList[index].rideStatus ==
                                        ArrivalStatus.dropped ||
                                        viewModel.childrenList[index].rideStatus ==
                                            ArrivalStatus.not_going;
                                    return GestureDetector(
                                      onTap: () {
                                        if(!disableField){
                                          CustomDialog.showInfoDialog(
                                            context: context,
                                            infoText:
                                                '${informYourDriverKey.tr} ${viewModel.childrenList[index].child?.name} ${notGoingSchoolKey.tr}',
                                            showSecondBtn: true,
                                            secondBtnText: notGoingBtnKey.tr,
                                            onTapBtn: () {
                                              Get.back();
                                              print(
                                                  'child id is ${StaticInfo.userModel!.data.user.authToken}');
                                              print(
                                                  'child id is ${viewModel.childrenList[index].id}');
                                              viewModel.childNotGoingToSchool(
                                                index: index,
                                                childId: viewModel
                                                    .childrenList[index].child?.id ?? -1,
                                                context: context,
                                                quotationId: widget.quotationId ?? 0,
                                              );
                                            },
                                          );
                                        }
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color:(disableField)
                                                ? darkThemeResendBtn.withOpacity(0.5)
                                                : theme.primaryColor),
                                        child: Text(
                                          viewModel.childrenList[index].child?.name ?? '',
                                          style: textTheme.titleMedium!
                                              .copyWith(
                                                  fontSize: 11, height: 0),
                                        ),
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      5.hSpace(),
                                ),
                              ),
                            ),
                            12.vSpace(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                rideInfo(textTheme, theme, vehicleTypeKey.tr,
                                    viewModel.driver?.vehicleModel ?? ''),
                                10.hSpace(),
                                SvgPicture.asset('assets/vertical_divider.svg'),
                                10.hSpace(),
                                rideInfo(textTheme, theme, arrivalTimeKey.tr,
                                    '20 Minutes'),
                              ],
                            ),
                          ],
                        )),
                  ),
              ],
            ),
          ),
        );
      },
      viewModelBuilder: () => VehicleTrackingViewModel(),
      disposeViewModel: false,
      onViewModelReady: (model) => SchedulerBinding.instance
          .addPostFrameCallback((_) => model.initialise(
              isComingFromNotification: widget.isComingFromNotification,
              quotationId: widget.quotationId,
              dateTimeOfArrivedDriver: widget.dateTimeOfArrivedDriver,
              children: widget.children,
              driverId: widget.driverId,
              driverData: widget.driver)),
    );
  }

  Container TimerWidget(
      double mediaH, TextTheme textTheme, String time, String text) {
    return Container(
      height: 45,
      margin: EdgeInsets.only(top: mediaH * 0.15),
      width: double.infinity,
      color: lightScaffoldColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/timer_image.png'),
          6.hSpace(),
          Text(
            text,
            style: textTheme.titleSmall!.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          17.hSpace(),
          Container(
            height: 27,
            width: 84,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5), color: primaryColor),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 41,
                  child: Text(
                    time,
                    style: textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.w500,
                      color: lightScaffoldColor,
                      height: 0,
                    ),
                  ),
                ),
                // 1.hSpace(),
                Text(
                  "Min",
                  style: textTheme.titleSmall!.copyWith(
                    fontWeight: FontWeight.w300,
                    color: lightScaffoldColor,
                    height: 0,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Column rideInfo(
      TextTheme textTheme, ThemeData theme, String title, String text) {
    return Column(
      children: [
        Text(
          title,
          style: textTheme.displayMedium!
              .copyWith(color: theme.cardColor, fontSize: 14),
        ),
        14.vSpace(),
        Text(
          text,
          style: textTheme.displayMedium!.copyWith(fontSize: 14),
        ),
      ],
    );
  }
}
