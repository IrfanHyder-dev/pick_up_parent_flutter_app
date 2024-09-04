import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pickup_parent/models/all_child_model.dart';
import 'package:pickup_parent/src/app/constants/constants.dart';
import 'package:pickup_parent/src/app/extensions.dart';
import 'package:pickup_parent/src/language/language_keys.dart';
import 'package:pickup_parent/ui/widgets/pickup_dropoff_info_widget.dart';
import 'package:stacked/stacked.dart';

class HomeChildDetailWidget extends StatefulWidget {
  final List<Child> selectedChild;
  final bool isLocationDiff;

  const HomeChildDetailWidget(
      {super.key, required this.selectedChild, required this.isLocationDiff});

  @override
  State<HomeChildDetailWidget> createState() => _HomeChildDetailWidgetState();
}

class _HomeChildDetailWidgetState extends State<HomeChildDetailWidget> {
  final ScrollController scrollController = ScrollController();
  String date = 'Date';

  @override
  Widget build(BuildContext context) {
    final mediaW = MediaQuery.of(context).size.width;
    final mediaH = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return FadingEdgeScrollView.fromScrollView(
        child: ListView.separated(
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(vertical: 20),
            itemBuilder: (context, index) {
              Child child = widget.selectedChild[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: const EdgeInsetsDirectional.only(
                          start: 34, top: 8, bottom: 10),
                      child: Text(
                        child.name,
                        style: textTheme.displayMedium,
                      )),
                  PickupDropOffInfoWidget(
                    pickupLocation: child.pickUp.address,
                    dropOffLocation: child.dropOff.address,
                    startTime: DateFormat('hh:mm a').format(child.startTime),
                    endTime: DateFormat('hh:mm a').format(child.endTime),
                  ),
                  12.vSpace(),
                  GestureDetector(
                    onTap: () {
                      BottomPicker.date(
                        pickerTextStyle: TextStyle(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                        titleStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black,
                        ),
                        descriptionStyle:
                            const TextStyle(color: Colors.red, fontSize: 14),
                        closeIconColor: Colors.black,
                        // iconColor: Colors.black,
                        buttonSingleColor: theme.primaryColor,
                        title: endTimeKey.tr,
                        onSubmit: (pickDate) {
                          var outputFormat = DateFormat('dd-MM-yyyy ');
                          var outputDate = outputFormat.format(pickDate);
                          setState(() {
                            date = outputDate.toString();
                          });
                          print(pickDate);
                        },
                        onClose: () {
                          print("Picker closed");
                        },
                        bottomPickerTheme: BottomPickerTheme.blue,
                      ).show(context);
                    },
                    child: Center(
                      child: Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: hMargin),
                        child: Container(
                          width: mediaW * 0.6,
                          height: 39,
                          padding: const EdgeInsetsDirectional.only(
                            start: 14,
                          ),
                          decoration: BoxDecoration(
                            color: theme.unselectedWidgetColor,
                            borderRadius: BorderRadius.circular(10),
                            border:
                                Border.all(color: theme.cardColor, width: 1),
                          ),
                          child: Row(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  //color: Colors.red,
                                  // height: 24,
                                  // width: 24,
                                  child: SvgPicture.asset(
                                'assets/calendar_date.svg',
                              )),
                              13.hSpace(),
                              Text(
                                date,
                                style: textTheme.displayMedium!.copyWith(
                                    color: theme.cardColor, height: 0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  5.vSpace(),
                ],
              );
            },
            separatorBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: hMargin),
                child: Divider(
                  color: theme.cardColor,
                  thickness: 1,
                ),
              );
            },
            itemCount:
                (widget.isLocationDiff) ? widget.selectedChild.length : 1));
  }
}
