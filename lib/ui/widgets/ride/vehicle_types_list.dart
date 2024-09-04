import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:pickup_parent/models/available_drivers_model.dart';
import 'package:pickup_parent/src/app/constants/constants.dart';
import 'package:pickup_parent/src/app/extensions.dart';
import 'package:pickup_parent/src/theme/base_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';

class VehicleTypesListWidget extends StatelessWidget {
  final Function(int index) onTap;
  int selectedIndex;
  List<Driver> vehicleTypesList;

   VehicleTypesListWidget({super.key, required this.onTap, required this.selectedIndex,required this.vehicleTypesList});

  @override
  Widget build(BuildContext context) {
    final mediaW = MediaQuery.of(context).size.width;
    final mediaH = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final ScrollController horiListViewCont = ScrollController();
    final Color btnColor = lightThemeChoseRideBtnColor;
    return SizedBox(
      width: mediaW,
      height: mediaH * 0.127,
      child: FadingEdgeScrollView.fromScrollView(
          child: ListView.separated(
              controller: horiListViewCont,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: hMargin),
              itemCount: vehicleTypesList.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap:()=> onTap(index),
                      child: Container(
                        height: 65,
                        width: 65,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                            color: (selectedIndex == index)
                                ? theme.primaryColor
                                : btnColor,
                            borderRadius: BorderRadius.circular(76),
                            border:
                                Border.all(width: 1, color: theme.canvasColor)),
                        child:CachedNetworkImage(
                          imageUrl:vehicleTypesList[index].vehicleTypeIcon,
                          errorWidget: (context, url, error) => Center(child: Text( vehicleTypesList[index].vehicleTypeName,style: textTheme.bodyLarge,)),
                        )
                        // Image.network(
                        //   vehicleTypesList[index].vehicleTypeIcon,
                        // ),
                      ),
                    ),
                    10.vSpace(),
                    Text(
                      vehicleTypesList[index].vehicleTypeName,
                      style: textTheme.bodyLarge,
                    )
                  ],
                );
              },
              separatorBuilder: (context, index) {
                return 20.hSpace();
              },
              )),
    );
  }
}
