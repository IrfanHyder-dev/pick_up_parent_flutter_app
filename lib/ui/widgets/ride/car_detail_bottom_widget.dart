import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pickup_parent/models/available_drivers_model.dart';
import 'package:pickup_parent/src/app/constants/constants.dart';
import 'package:pickup_parent/src/app/extensions.dart';
import 'package:pickup_parent/src/app/static_info.dart';
import 'package:pickup_parent/src/language/language_keys.dart';
import 'package:pickup_parent/src/theme/base_theme.dart';
import 'package:pickup_parent/ui/views/ride/subscription_detail/subscription_detail_view.dart';
import 'package:pickup_parent/ui/views/ride/subscription_package/subscription_packages_view.dart';

class CarDetailBottomWidget extends StatelessWidget {
  final Function() phoneOnTap;
  final Function() smsOnTap;
  CarDetailBottomWidget({
    super.key,
    required this.phoneOnTap,
    required this.smsOnTap,
  });

  @override
  Widget build(BuildContext context) {
    final mediaW = MediaQuery.of(context).size.width;
    final mediaH = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    Driver driver = StaticInfo.selectedDriver!;
    print('driver image is ${driver.driverProfileImage}');
    return Container(
      height: 450,
      width: mediaW,
      margin: const EdgeInsets.only(
          top: 20, left: hMargin, right: hMargin, bottom: 25),
      decoration: BoxDecoration(
        color: theme.unselectedWidgetColor,
        borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff000000).withOpacity(0.1),
            blurRadius: 30,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            //height: 62,
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
                color: theme.dialogBackgroundColor,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10))),
            child: Row(
              children: [
                (driver.driverProfileImage.isEmpty)
                    ? SizedBox(
                    height: 41,
                    width: 41,
                    child: Image.asset('assets/person_placeholder.png'))
                    : Container(
                        height: 41,
                        width: 41,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: Image.network(driver.driverProfileImage)
                                    .image)),
                      ),
                10.hSpace(),
                Container(
                  width: 125,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          maxLines: 2,
                          driver.name,
                          style: textTheme.displayMedium!.copyWith(height: 1),
                        ),
                        6.vSpace(),
                        Row(
                          children: [
                            SvgPicture.asset('assets/star_icon.svg'),
                            5.hSpace(),
                            Text(
                              '4.9',
                              style: textTheme.titleSmall!.copyWith(
                                  fontSize: 14, color: theme.cardColor),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Spacer(),
                GestureDetector(
                    onTap: ()=> phoneOnTap(),
                    child: SvgPicture.asset('assets/phone_icon.svg')),
                7.hSpace(),
                GestureDetector(
                    onTap: ()=> smsOnTap(),
                    child: SvgPicture.asset('assets/msg_icon.svg')),
              ],
            ),
          ),
          14.vSpace(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (driver.vehicleMake.isEmpty)?driver.vehicleTypeName: driver.vehicleMake,
                  style: textTheme.displayMedium,
                ),
                8.vSpace(),
                Text(
                  driver.vehicleModelYear,
                  style: textTheme.bodyLarge,
                ),
                17.vSpace(),
                Text(
                  thisDriverMostKey.tr,
                  style: textTheme.bodySmall!.copyWith(fontSize: 12),
                ),
                22.vSpace(),
                SvgPicture.asset('assets/dash_divider.svg'),
                32.vSpace(),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: '${driver.fareAmount.toStringAsFixed(0)}/',
                          style: textTheme.displayLarge!.copyWith(
                            fontSize: 26,
                          ),
                        ),
                        TextSpan(
                          text: 'Pkr',
                          style: textTheme.displayMedium,
                        ),
                      ],
                    ),
                  ),
                 Spacer(),
                  GestureDetector(
                    onTap: ()=> Get.to(()=> SubscriptionPackagesView()),
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
                            SizedBox(
                                height: 18,
                                width: 18,
                                child: SvgPicture.asset(
                                    'assets/button_check_icon.svg')),
                            8.hSpace(),
                            Text(
                              selectKey.tr,
                              style: textTheme.titleLarge!.copyWith(
                                  color: theme.unselectedWidgetColor,
                                  height: 0),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ]),
                18.vSpace(),
                const Divider(
                  thickness: 1,
                ),
                22.vSpace(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 57,
                      width: 57,
                      child: Image.asset('assets/person_placeholder.png'),
                    ),
                    10.hSpace(),
                    SizedBox(
                      width: 197,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hassan Khan',
                            style:
                                textTheme.displayMedium!.copyWith(fontSize: 20),
                          ),
                          7.vSpace(),
                          RatingBar.builder(
                            itemSize: 20,
                            initialRating: 3.5,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            maxRating: 5,
                            unratedColor: theme.cardColor,
                            itemCount: 5,
                            // itemPadding: const EdgeInsets.symmetric(
                            //     horizontal: 2.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: theme.primaryColor,
                            ),
                            onRatingUpdate: (rating) {
                              print(rating);
                            },
                          ),
                          14.vSpace(),
                          Text(thisRiderNiceKey.tr,
                              style: textTheme.displayMedium!
                                  .copyWith(fontSize: 14),
                              overflow: TextOverflow.clip),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
