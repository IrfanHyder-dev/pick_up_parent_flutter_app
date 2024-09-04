import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pickup_parent/models/available_drivers_model.dart';
import 'package:pickup_parent/src/app/constants/constants.dart';
import 'package:pickup_parent/src/app/extensions.dart';
import 'package:pickup_parent/src/language/language_keys.dart';
import 'package:pickup_parent/src/theme/base_theme.dart';
 class AvailableVehicleListWidget extends StatelessWidget {
   final Function(Driver driver) onTap;
   List<Driver> availableVehiclesList;
   AvailableVehicleListWidget({super.key, required this.onTap, required this.availableVehiclesList});
   ScrollController scrollController = ScrollController();
   @override
   Widget build(BuildContext context) {
     final mediaW = MediaQuery.of(context).size.width;
     final mediaH = MediaQuery.of(context).size.height;
     final theme = Theme.of(context);
     final textTheme = theme.textTheme;
     final Color btnColor = lightThemeChoseRideBtnColor;
     return Expanded(
       child: ListView.builder(
         // controller: scrollController,
          physics: const BouncingScrollPhysics(),
         itemCount: availableVehiclesList.length,
         itemBuilder: (context, index) {
            var vehicle = availableVehiclesList[index];
           return GestureDetector(
             onTap:()=> onTap(availableVehiclesList[index]),
             child: Container(
               height: mediaH * 0.3,
               width: mediaW,
               margin: EdgeInsets.symmetric(horizontal: hMargin, vertical: 13),
               padding: const EdgeInsetsDirectional.only(
                   top: 22, bottom: 10, start: 20, end: 20),
               decoration: BoxDecoration(
                   color: theme.unselectedWidgetColor,
                   borderRadius: BorderRadius.circular(10)),
               child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text(
                       (vehicle.vehicleMake.isEmpty)?vehicle.vehicleTypeName : vehicle.vehicleMake,
                       style: textTheme.displayMedium,
                     ),
                     9.vSpace(),
                     Text(
                       vehicle.vehicleModel,
                       style: textTheme.bodyLarge,
                     ),
                     20.vSpace(),
                     //Center(child: Image.asset('assets/car_img.png')),
                     Center(
                       child: SizedBox(
                         height: 60,
                           width: 190,
                           child:
                           // SvgPicture.asset('assets/bus_img.svg',)
                           // SvgPicture.asset('assets/bus_img.svg'),
                            Image.asset('assets/car_img.png')
                       ),
                     ),
                     25.vSpace(),
                     Row(
                       children: [
                         Container(
                           height: 40,
                           width: 91,
                           decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(50),
                               color: btnColor),
                           child: Row(
                             mainAxisAlignment:
                             MainAxisAlignment.center,
                             children: [
                               SvgPicture.asset(
                                   'assets/seat_icon.svg'),
                               6.hSpace(),
                               Text(
                                 '${(vehicle.vehicleSeats != null)?vehicle.vehicleSeats:0} ${seatKey.tr}',
                                 style: textTheme.titleSmall!.copyWith(
                                     color: theme.canvasColor,height: 0),
                               ),
                             ],
                           ),
                         ),
                         11.hSpace(),
                         Container(
                           height: 40,
                           width: 91,
                           decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(50),
                               color: btnColor),
                           child: Row(
                             mainAxisAlignment:
                             MainAxisAlignment.center,
                             children: [
                               SvgPicture.asset(
                                   'assets/color_pallet_icon.svg'),
                               6.hSpace(),
                               Text(
                                   (vehicle.vehicleColor.isEmpty)?'':vehicle.vehicleColor,
                                 style: textTheme.titleSmall!.copyWith(
                                     color: theme.canvasColor),
                               ),
                             ],
                           ),
                         ),
                         48.hSpace(),
                         SvgPicture.asset(
                             'assets/forward_arrow_light.svg'),
                       ],
                     )
                   ]),
             ),
           );
         },
       ),
     );
   }
 }
