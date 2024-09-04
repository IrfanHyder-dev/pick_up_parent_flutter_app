import 'package:pickup_parent/src/app/constants/constants.dart';
import 'package:pickup_parent/src/app/extensions.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';

class AvailableVehicleShimmerList extends StatelessWidget {
  const AvailableVehicleShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaW = MediaQuery.of(context).size.width;
    final mediaH = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    return Column(
      children: [
        Shimmer.fromColors(
    baseColor: theme.cardColor.withOpacity(0.4),
    highlightColor: theme.cardColor.withOpacity(0.2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 85,
                  width: mediaW,
                  child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: hMargin),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Container(
                              height: 65,
                              width: 65,
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                color:theme.cardColor.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(76),
                                 ),
                            ),
                            10.vSpace(),
                            Container(
                              height: 10,
                              width: 30,
                              decoration: BoxDecoration(
                                color: theme.cardColor.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(20)
                              ),
                              
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (context, index) => 20.hSpace()),
                ),
                Container(
                  height: 20,
                  width: 200,
                  margin: const EdgeInsetsDirectional.only(start: 20, bottom: 20, top: 35),
                  decoration: BoxDecoration(
                    color: theme.cardColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(15)
                  ),
                ),
                13.vSpace(),
                Container(
                  height:mediaH * 0.64 ,
                  //color: Colors.red,
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: hMargin),
                      itemCount: 2,
                    itemBuilder: (context, index) {
                    return Container(
                      height: 230,
                      width: 335,
                      decoration: BoxDecoration(
                        color: theme.cardColor.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10)
                      ),
                    );
                  }, separatorBuilder: (context, index) => 12.vSpace(), ),
                )
              ],
            ),
            ),
      ],
    );
  }
}
