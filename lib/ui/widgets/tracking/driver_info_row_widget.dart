import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pickup_parent/models/all_subscriptions_model.dart';
import 'package:pickup_parent/src/app/constants/constants.dart';
import 'package:pickup_parent/src/app/extensions.dart';

class DriverInfoRowWidget extends StatelessWidget {
  Driver driver;
  Function onTapPhone;
  Function onTapSms;
   DriverInfoRowWidget({super.key,required this.driver,required this.onTapPhone,required this.onTapSms});

  @override
  Widget build(BuildContext context) {
    final mediaW = MediaQuery.of(context).size.width;
    final mediaH = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return
      Column(
        children: [
          Container(
            margin: const EdgeInsets.only(
                top: 18, left: 10, right: 10),
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 11),
            decoration: BoxDecoration(
              color: theme.unselectedWidgetColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color:
                  const Color(0xff000000).withOpacity(0.1),
                  //Color.fromARGB(120, 0, 0, 0),
                  blurRadius: 10,
                  //spreadRadius: 10,
                ),
              ],
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: 41,
                        width: 41,
                        child: CircleAvatar(
                            backgroundColor: theme.primaryColor,
                            backgroundImage: const AssetImage(
                                'assets/profile_image.png'),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 12,
                                width: 33,
                                padding:
                                const EdgeInsets.symmetric(
                                    horizontal: 7,
                                    vertical: 2),
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(6),
                                  color: theme
                                      .unselectedWidgetColor,
                                  boxShadow: [
                                    BoxShadow(
                                        color: const Color(
                                            0xff000000)
                                            .withOpacity(0.1),
                                        blurRadius: 3,
                                        offset: (const Offset(
                                            -1, 0))),
                                  ],
                                ),
                                child: Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '4.9',
                                      style: textTheme
                                          .titleMedium!
                                          .copyWith(
                                          fontSize: 6,
                                          height: 0),
                                    ),
                                    const Spacer(),
                                    SizedBox(
                                        height: 7,
                                        width: 7,
                                        child: SvgPicture.asset(
                                            'assets/star_icon.svg')),
                                  ],
                                ),
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
                16.hSpace(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      driver.name!,
                      style: textTheme.displayMedium,
                    ),
                    4.vSpace(),
                    Text(
                      'Top Rated Driver',
                      style: textTheme.bodyLarge!
                          .copyWith(fontSize: 10),
                    ),
                  ],
                ),
                30.hSpace(),
                InkWell(
                    onTap:()=> onTapPhone(),
                    child: SvgPicture.asset('assets/phone_icon.svg')),
                10.hSpace(),
                InkWell(
                    onTap:()=> onTapSms(),
                    child: SvgPicture.asset('assets/msg_icon.svg')),
              ],
            ),
          )
        ],
    );
  }
}
