import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pickup_parent/models/available_drivers_model.dart';
import 'package:pickup_parent/src/app/constants/constants.dart';
import 'package:pickup_parent/src/app/extensions.dart';
import 'package:pickup_parent/src/app/static_info.dart';

class CarDetailTopWidget extends StatelessWidget {
  const CarDetailTopWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaW = MediaQuery.of(context).size.width;
    final mediaH = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    Driver vehicle = StaticInfo.selectedDriver!;
    return Container(
      height: mediaH * 0.394,
      width: mediaW,
      decoration: BoxDecoration(
          color: theme.dialogBackgroundColor,
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (0.04 * mediaH).vSpace(),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: hMargin),
            child: Text(
              (vehicle.vehicleMake.isEmpty)?vehicle.vehicleTypeName: vehicle.vehicleMake,
              style: textTheme.headlineMedium!.copyWith(fontSize: 20),
            ),
          ),
          8.vSpace(),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: hMargin),
            child: Row(
              children: [
                SvgPicture.asset('assets/star_icon.svg'),
                5.hSpace(),
                Text(
                  '4.9',
                  style: textTheme.titleSmall!.copyWith(fontSize: 14),
                ),
                9.hSpace(),
                Text(
                  '10 Reviews',
                  style:
                  textTheme.bodySmall!.copyWith(color: theme.canvasColor),
                )
              ],
            ),
          ),
          40.vSpace(),
          Center(
            child: Image.asset('assets/car_img.png'),
          )
        ],
      ),
    );
  }
}
