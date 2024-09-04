import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pickup_parent/src/app/constants/constants.dart';
import 'package:pickup_parent/src/app/extensions.dart';
import 'package:pickup_parent/src/language/language_keys.dart';
import 'package:pickup_parent/src/theme/base_theme.dart';
import 'package:pickup_parent/ui/views/history/history_viewmodel.dart';

import 'history_row_widget.dart';

class PaymentHistoryWidget extends StatelessWidget {
  final ScrollController controller = ScrollController();
  final Color historyColor = lightThemeHistoryColor;
  final HistoryViewModel historyViewModel;

  PaymentHistoryWidget({super.key, required this.historyViewModel});

  @override
  Widget build(BuildContext context) {
    final mediaW = MediaQuery.of(context).size.width;
    final mediaH = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return (historyViewModel.isPaymentHistoryLoaded)
        ? (historyViewModel.paymentHistory?.data == null ||
                historyViewModel.paymentHistory!.data!.isEmpty)
            ? Center(
                child: Text(
                  'Payment History not available',
                  style: textTheme.displayMedium,
                ),
              )
            : FadingEdgeScrollView.fromScrollView(
                child: ListView.separated(
                    controller: controller,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(top: 42, bottom: 90),
                    itemCount: historyViewModel.paymentHistory?.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      var historyData = historyViewModel.paymentHistory?.data?[index];
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
                              child: Row(
                                children: [
                                  Text(
                                    monthlyKey.tr,
                                    style: textTheme.displayMedium!.copyWith(
                                      color: theme.unselectedWidgetColor,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${historyViewModel.extractMonthFromDate(historyData?.paymentDate ?? '')}',
                                    style: textTheme.displayMedium!.copyWith(
                                      color: theme.unselectedWidgetColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              //height: 242,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 13, vertical: 22),
                              decoration: BoxDecoration(
                                color: theme.unselectedWidgetColor,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xff000000)
                                        .withOpacity(0.1),
                                    //Color.fromARGB(120, 0, 0, 0),
                                    blurRadius: 30,
                                    spreadRadius: 10,
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  HistoryRowWidget(
                                      image: 'assets/driver_icon.svg',
                                      heading: driverNameKey.tr,
                                      containerText: historyData?.driverName ??""),
                                  11.vSpace(),
                                  HistoryRowWidget(
                                      image: 'assets/seat_icon.svg',
                                      heading: numOfSeatKey.tr,
                                      containerText: historyData?.noOfSeats.toString() ??""),
                                  11.vSpace(),
                                  HistoryRowWidget(
                                    containerWidth: 175,
                                      image: 'assets/number_plate_icon.svg',
                                      containerText: '${historyData?.vehicleType} (${historyData?.vehicleNumberPlate})' ??'',
                                      heading: vehicleDetailKey.tr),
                                  20.vSpace(),
                                  Divider(
                                    color: theme.dividerColor,
                                  ),
                                  15.vSpace(),
                                  Row(
                                    children: [
                                      RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: 'Rs',
                                                style: textTheme.displayMedium),
                                            TextSpan(
                                              text: historyData?.amount.toString() ??' ',
                                              style: textTheme.headlineMedium!
                                                  .copyWith(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600),
                                            ),
                                            TextSpan(
                                                text: '/Pkr',
                                                style: textTheme.titleMedium),
                                          ],
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        historyData?.paymentDate ??'',
                                        style: textTheme.titleSmall!
                                            .copyWith(color: theme.cardColor),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => 23.vSpace(),
                    ))
        : Container();
  }
}
