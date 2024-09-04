import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pickup_parent/models/all_subscriptions_model.dart';
import 'package:pickup_parent/src/app/constants/constants.dart';
import 'package:pickup_parent/src/app/extensions.dart';
import 'package:pickup_parent/src/app/static_info.dart';
import 'package:pickup_parent/src/language/language_keys.dart';

class ChildDetailWidget extends StatelessWidget {
  ChildDetailWidget({
    super.key,
    required this.theme,
    required this.textTheme,
    required this.selectedChild,
    required this.amount,
    required this.distance,
  });

  final ThemeData theme;
  final TextTheme textTheme;
  List<ChildElement>selectedChild;
  final double amount;
  final double distance;
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 150,
      margin: const EdgeInsets.symmetric(horizontal: hMargin),
      padding:
          const EdgeInsets.symmetric(horizontal: hMargin, vertical: hMargin),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: theme.unselectedWidgetColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset('assets/child_icon.svg'),
              10.hSpace(),
              Text(
                childNameKey.tr,
                style: textTheme.titleSmall!.copyWith(height: 0),
              ),
              const Spacer(),
              Container(
                  width: 180,
                  height: 22,
                  alignment: Alignment.centerRight,
                  child: FadingEdgeScrollView.fromScrollView(
                      child: ListView.separated(
                        controller: scrollController,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: selectedChild.length,
                    itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),color: theme.primaryColor),
                            child: Text(
                                      selectedChild[index].child?.name ?? '',
                                      style: textTheme.titleMedium!
                                          .copyWith(fontSize: 11,height: 0),
                                    ),
                          );
                    },
                    separatorBuilder: (context, index) => 5.hSpace(),
                  ))
                  ),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            child: SvgPicture.asset('assets/dash_divider.svg'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset('assets/filled_location_icon.svg'),
              10.hSpace(),
              Text(
                distanceFrmHmKey.tr,
                style: textTheme.titleSmall,
              ),
              const Spacer(),
              Text(
                '${distance.toStringAsFixed(1)} KM',
                style: textTheme.titleMedium!.copyWith(fontSize: 12),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            child: SvgPicture.asset('assets/dash_divider.svg'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset('assets/currency_icon.svg'),
              10.hSpace(),
              Text(
                subscriptionAmntKey.tr,
                style: textTheme.titleSmall,
              ),
              const Spacer(),
              Text(
                '${amount.toStringAsFixed(0)}/Pkr',
                style: textTheme.titleMedium!.copyWith(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
