import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pickup_parent/src/app/extensions.dart';
import 'package:pickup_parent/src/app/static_info.dart';
import 'package:pickup_parent/src/language/language_keys.dart';
import 'package:pickup_parent/src/theme/base_theme.dart';

class SubscriptionPackageWidget extends StatefulWidget {
  const SubscriptionPackageWidget({super.key});

  @override
  State<SubscriptionPackageWidget> createState() =>
      _SubscriptionPackageWidgetState();
}

class _SubscriptionPackageWidgetState extends State<SubscriptionPackageWidget> {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final mediaW = MediaQuery.of(context).size.width;
    final mediaH = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    const Color packageClr = lightThemeHistoryColor;
    return Row(
      children: [
        packageDetailContainer(
            index: 0,
            theme: theme,
            packageClr: packageClr,
            textTheme: textTheme,
            packageName: monthlyKey.tr,
            price: StaticInfo.selectedDriver!.fareAmount,
            noOfMonths: oneMonthKey.tr),
        12.hSpace(),
        packageDetailContainer(
            index: 1,
            theme: theme,
            packageClr: packageClr,
            textTheme: textTheme,
            packageName: quarterlyKey.tr,
            price: (StaticInfo.selectedDriver!.fareAmount * 6),
            noOfMonths: sixMonthKey.tr),
        12.hSpace(),
        packageDetailContainer(
            index: 1,
            theme: theme,
            packageClr: packageClr,
            textTheme: textTheme,
            packageName: anualKey.tr,
            price: (StaticInfo.selectedDriver!.fareAmount * 12),
            noOfMonths: twlvMonthKey.tr),
      ],
    );
  }

  Widget packageDetailContainer({
    required int index,
    required ThemeData theme,
    required Color packageClr,
    required TextTheme textTheme,
    required String packageName,
    required double price,
    required String noOfMonths,
  }) {
    return Container(
      width: 98,
      decoration: BoxDecoration(
          color: (index == 0)
              ? Colors.transparent
              : theme.dialogBackgroundColor.withOpacity(0.3),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: (index == 0)
                  ? theme.primaryColor
                  : theme.dialogBackgroundColor)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 42,
            decoration: BoxDecoration(
                color: (index == 0) ? packageClr : theme.dialogBackgroundColor,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Image.asset('assets/calendar_icon.png')),
                11.hSpace(),
                Container(
                  height: 17,
                  width: 17,
                  margin: const EdgeInsetsDirectional.only(end: 5, top: 5),
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(70),
                    border: Border.all(
                        color: (index == 0)
                            ? theme.primaryColor
                            : theme.cardColor),
                    color: (index == 0)
                        ? theme.primaryColor
                        : theme.dialogBackgroundColor,
                  ),
                  child: (index == 0) ? Image.asset('assets/check.png') : null,
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                5.vSpace(),
                Text(
                  packageName,
                  style: textTheme.displayMedium!.copyWith(fontSize: 14),
                ),
                13.vSpace(),
                Text(
                  noOfMonths,
                  style: textTheme.bodySmall,
                ),
                4.vSpace(),
                Text(
                  maxLines: 2,
                  // '1000000/Pkr',
                  '${price.toStringAsFixed(0)}/Pkr',
                  style: textTheme.displayMedium!.copyWith(fontSize: 15),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
