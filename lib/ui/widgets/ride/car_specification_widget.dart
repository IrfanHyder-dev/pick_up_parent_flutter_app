import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pickup_parent/models/available_drivers_model.dart';
import 'package:pickup_parent/src/app/constants/constants.dart';
import 'package:pickup_parent/src/app/extensions.dart';
import 'package:pickup_parent/src/app/static_info.dart';
import 'package:pickup_parent/src/language/language_keys.dart';

class CarSpecificationWidget extends StatelessWidget {
  const CarSpecificationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaW = MediaQuery.of(context).size.width;
    final mediaH = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    Driver driver = StaticInfo.selectedDriver!;
    return Container(
      height: 90,
      width: mediaW,
      margin: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        //color: Colors.red,
          boxShadow: [
            BoxShadow(
              color: const Color(0xff000000).withOpacity(0.1),
              //Color.fromARGB(120, 0, 0, 0),
              blurRadius: 30,
              spreadRadius: 10,
            ),
          ],
      ),
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 90,
            width: 103,
            padding:
            const EdgeInsetsDirectional.only(start: 18, top: 10, bottom: 8),
            decoration: BoxDecoration(
                color: theme.unselectedWidgetColor,
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset('assets/color_pallet_icon.svg'),
                5.vSpace(),
                Text(
                  colorKey.tr,
                  style: textTheme.titleSmall,
                ),
                Spacer(),
                Text(
                  driver.vehicleColor,
                  style: textTheme.headlineSmall!.copyWith(fontSize: 17),
                )
              ],
            ),
          ),
          5.hSpace(),
          Container(
            height: 90,
            width: 105,
            padding: const EdgeInsetsDirectional.only(
                start: 12, end: 10, top: 10, bottom: 8),
            decoration: BoxDecoration(
                color: theme.unselectedWidgetColor,
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset('assets/number_plate_icon.svg'),
                7.vSpace(),
                Text(
                  numberPlateKey.tr,
                  style: textTheme.titleSmall,
                ),
                Spacer(),
                Text(
                  '${driver.vehicleNumberPlate != null? driver.vehicleNumberPlate : ''}',
                  style: textTheme.headlineSmall!.copyWith(fontSize: 15, height: 1),
                  maxLines: 2,
                )
              ],
            ),
          ),
          5.hSpace(),
          Container(
            height: 90,
            width: 103,
            padding: const EdgeInsetsDirectional.only(
                start: 12, top: 10, bottom: 8, end: 12),
            decoration: BoxDecoration(
                color: theme.unselectedWidgetColor,
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset('assets/seat_icon.svg'),
                5.vSpace(),
                Text(
                  capacityKey.tr,
                  style: textTheme.titleSmall,
                ),
                Spacer(),
                Text(
                  '${driver.vehicleSeats != null? driver.vehicleSeats : ''} ${seatKey.tr}',
                  style: textTheme.headlineSmall!.copyWith(fontSize: 17),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
