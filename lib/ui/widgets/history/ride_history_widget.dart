import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pickup_parent/src/app/constants/constants.dart';
import 'package:pickup_parent/src/app/enum/enum.dart';
import 'package:pickup_parent/src/app/extensions.dart';
import 'package:pickup_parent/src/language/language_keys.dart';
import 'package:pickup_parent/src/theme/base_theme.dart';
import 'package:pickup_parent/ui/views/history/history_viewmodel.dart';
import 'package:pickup_parent/ui/widgets/history/history_row_widget.dart';

class RideHistoryWidget extends StatelessWidget {
  final ScrollController controller = ScrollController();
  final Color historyColor = lightThemeHistoryColor;
  HistoryViewModel historyViewModel;

  RideHistoryWidget({super.key, required this.historyViewModel});

  @override
  Widget build(BuildContext context) {
    final mediaW = MediaQuery.of(context).size.width;
    final mediaH = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return(historyViewModel.isRideHistoryLoaded)?(historyViewModel.groupedHistories.isEmpty)? Center(
      child: Text(
        'Ride History not available',
        style: textTheme.displayMedium,
      ),):FadingEdgeScrollView.fromScrollView(
      child: ListView.separated(
        controller: controller,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(top: 42, bottom: 90),
        itemCount: historyViewModel.groupedHistories.length,
        itemBuilder: (context, index) {
          var key = historyViewModel.groupedHistories.keys.elementAt(index);
          var historyData = historyViewModel.groupedHistories[key];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: hMargin),
            //height: 317,
            width: mediaW,
            decoration: BoxDecoration(
              color: darkThemeTextColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 27, left: 35, right: 35, bottom: 20),
                  child: Text(
                    (historyData?[0].shiftType == RideShiftType.morning)
                        ? "${driverDroppedKey.tr} ${toSchoolKey.tr}"
                        : "${driverDroppedKey.tr} ${toHomeKey.tr}",
                    style: textTheme.displayMedium!.copyWith(
                        color: theme.unselectedWidgetColor, fontSize: 14),
                  ),
                ),
                Container(
                  //height: 242,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 13, vertical: 22),
                  decoration: BoxDecoration(
                    color: theme.unselectedWidgetColor,
                    borderRadius: BorderRadius.circular(20),
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
                    children: [
                      HistoryRowWidget(
                          image: 'assets/outlined_child_icon.svg',
                          heading: childNameKey.tr,
                          containerWidth: 180,
                          childrenNameList: historyData,
                          isThisList: true,
                          containerText: ""),
                      11.vSpace(),
                      HistoryRowWidget(
                          image: 'assets/driver_icon.svg',
                          heading: driverNameKey.tr,
                          containerWidth: 180,
                          containerText: historyData?[0].driverName ?? ""),
                      11.vSpace(),
                      HistoryRowWidget(
                          image: 'assets/clock.svg',
                          containerText: historyData?[0].rideStartTime ?? '',
                          heading: pickUpTimeKey.tr),
                      11.vSpace(),
                      HistoryRowWidget(
                          image: 'assets/clock.svg',
                          containerText: historyData?[0].rideEndTime ?? '',
                          heading: dropOffTimeKey.tr),
                      11.vSpace(),
                      HistoryRowWidget(
                          image: 'assets/shift_type_icon.svg',
                          containerText: GetStringUtils(
                                      '${historyData?[0].shiftType?.name}')
                                  .capitalizeFirst ??
                              '',
                          heading: rideShiftTypeKey.tr),
                      11.vSpace(),
                      HistoryRowWidget(
                          image: 'assets/outlined_location_icon.svg',
                          containerText:
                              "${historyData?[0].distanceCovered?.toStringAsFixed(2)} km",
                          heading: distanceCovredKey.tr),
                      11.vSpace(),
                      HistoryRowWidget(
                          containerWidth: 175,
                          image: 'assets/number_plate_icon.svg',
                          containerText:
                              '${historyData?[0].vehicleType} (${historyData?[0].numberPlate})',
                          heading: vehicleDetailKey.tr),
                      20.vSpace(),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          historyData?[0].rideDate ?? '',
                          style: textTheme.titleSmall!
                              .copyWith(color: theme.cardColor),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => 23.vSpace(),
      ),
    ):Container();
  }
}
