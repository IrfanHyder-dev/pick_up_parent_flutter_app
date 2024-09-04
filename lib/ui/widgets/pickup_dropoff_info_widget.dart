import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pickup_parent/src/app/constants/constants.dart';
import 'package:pickup_parent/src/app/extensions.dart';
import 'package:pickup_parent/src/language/language_keys.dart';

class PickupDropOffInfoWidget extends StatelessWidget {
  final pickupLocation;
  final String dropOffLocation;
  final String startTime;
  final String endTime;
  const PickupDropOffInfoWidget({super.key, required this.pickupLocation, required this.dropOffLocation, required this.startTime, required this.endTime});

  @override
  Widget build(BuildContext context) {
    final mediaW = MediaQuery.of(context).size.width;
    final mediaH = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional
              .only(
            start: hMargin,
            // top: 26,
          ),
          child: Row(
            children: [
              Column(
                children: [
                  5.vSpace(),
                  SvgPicture.asset(
                      'assets/pickup_icon.svg'),
                  5.vSpace(),
                  SizedBox(
                      child: SvgPicture.asset(
                        'assets/large_line_icon.svg',
                        height: 55,
                        fit: BoxFit.cover,
                      )),
                  5.vSpace(),
                  SvgPicture.asset(
                      'assets/dropoff_icon.svg'),
                ],
              ),
              16.hSpace(),
              Column(
                mainAxisAlignment:
                MainAxisAlignment.start,
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    pickUpKey.tr,
                    style: textTheme
                        .bodyLarge!
                        .copyWith(
                        color: theme
                            .cardColor),
                  ),
                  8.vSpace(),
                  Container(
                    width: mediaW * 0.7,
                    child: Text(
                      pickupLocation,
                      maxLines: 1,
                      overflow:
                      TextOverflow.fade,
                      style:
                      textTheme.bodyLarge!.copyWith(height: 0),
                    ),
                  ),
                  2.vSpace(),
                  SizedBox(
                    height: 20,
                    child: Row(
                      crossAxisAlignment:
                      CrossAxisAlignment
                          .center,
                      children: [
                        SvgPicture.asset(
                          'assets/clock_grey.svg',
                          height: 18,
                        ),
                        8.hSpace(),
                        Text(
                          startTime,
                          style: textTheme
                              .displayMedium!
                              .copyWith(
                              color: theme
                                  .canvasColor,
                              fontSize:
                              14,
                              height: 0),
                        ),
                      ],
                    ),
                  ),
                  5.vSpace(),
                  SizedBox(
                    width: mediaW * 0.68,
                    child: const Divider(
                      thickness: 1,
                    ),
                  ),
                  5.vSpace(),
                  Text(
                    dropOffKey.tr,
                    style: textTheme
                        .bodyLarge!
                        .copyWith(
                        color: theme
                            .cardColor),
                  ),
                  10.vSpace(),
                  SizedBox(
                    width: mediaW * 0.7,
                    child: Text(
                      dropOffLocation,
                      style:
                      textTheme.bodyLarge!.copyWith(height: 0),
                      maxLines: 1,
                      overflow:
                      TextOverflow.fade,
                    ),
                  ),
                  2.vSpace(),
                  SizedBox(
                    height: 20,
                    child: Row(
                      crossAxisAlignment:
                      CrossAxisAlignment
                          .center,
                      children: [
                        SvgPicture.asset(
                          'assets/clock_grey.svg',
                          height: 18,
                        ),
                        8.hSpace(),
                        Text(
                          endTime,
                          style: textTheme
                              .displayMedium!
                              .copyWith(
                              color: theme
                                  .canvasColor,
                              fontSize:
                              14,
                              height: 0),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
