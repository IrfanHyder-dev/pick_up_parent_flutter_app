import 'dart:async';

import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pickup_parent/src/app/constants/constants.dart';
import 'package:pickup_parent/src/app/enum/enum.dart';
import 'package:pickup_parent/src/app/extensions.dart';
import 'package:pickup_parent/src/language/language_keys.dart';
import 'package:pickup_parent/ui/views/notification/notification_view.dart';
import 'package:pickup_parent/ui/views/profilel/add_child/add_child_viewmodel.dart';
import 'package:pickup_parent/ui/views/profilel/current_location/current_location_view.dart';
import 'package:pickup_parent/ui/widgets/app_bar_widget.dart';
import 'package:pickup_parent/ui/widgets/button_widget.dart';
import 'package:pickup_parent/ui/widgets/input_field_widget.dart';
import 'package:stacked/stacked.dart';

class AddChildView extends StatefulWidget {
  final String? parentAddress;

  AddChildView({super.key, this.parentAddress});

  @override
  State<AddChildView> createState() => _AddChildViewState();
}

class _AddChildViewState extends State<AddChildView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaW = MediaQuery.of(context).size.width;
    final mediaH = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return ViewModelBuilder<AddChildViewModel>.reactive(
      builder: (context, viewModel, child) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          body: FadingEdgeScrollView.fromSingleChildScrollView(
            child: SingleChildScrollView(
              controller: viewModel.scrollController,
              physics: const BouncingScrollPhysics(),
              child: SizedBox(
                height: mediaH,
                child: Stack(
                  children: [
                    SizedBox(
                      height: mediaH * 0.31,
                      width: mediaW,
                      child: SvgPicture.asset(
                        'assets/bg_image.svg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Column(
                      children: [
                        AppBarWidget(
                          title: profileKey.tr,
                          titleStyle: textTheme.titleLarge!,
                          leadingIcon: 'assets/back_arrow_light.svg',
                          actionIcon: 'assets/black_bell_icon.svg',
                          leadingIconOnTap: () => Get.back(),
                          actonIconOnTap: () =>
                              Get.to(() => const NotificationView()),
                        ),
                        (0.03 * mediaH).vSpace(),
                        Container(
                          margin:
                              const EdgeInsets.symmetric(horizontal: hMargin),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Form(
                                key: viewModel.formKey,
                                autovalidateMode: viewModel.autoValidate,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsetsDirectional.only(
                                          start: margin16),
                                      child: Text(
                                        pickUpKey.tr,
                                        style: textTheme.displayMedium,
                                      ),
                                    ),
                                    6.vSpace(),
                                    InputField(
                                      fillColor: theme.primaryColorDark,
                                      controller: viewModel.pickUpCon,
                                      hint: enterDropOfKey.tr,
                                      hintStyle: textTheme.displayMedium!
                                          .copyWith(color: theme.cardColor),
                                      borderRadius: 10,
                                      borderColor: theme.primaryColorDark,
                                      maxLines: 1,
                                      suffixWidget:
                                          Container(child: Text('  ')),
                                      suffixBoxConstraints: BoxConstraints(
                                        maxHeight:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                      ),
                                      prefixWidget: GestureDetector(
                                        onTap: () {
                                          viewModel.getChildPickUpLocation();
                                        },
                                        child: Container(
                                            height: 24,
                                            width: 24,
                                            margin: const EdgeInsetsDirectional
                                                .only(end: 15, start: 16),
                                            child: SvgPicture.asset(
                                              'assets/location_icon.svg',
                                            )),
                                      ),
                                      validator: (val) {
                                        if (val.toString().isEmpty) {
                                          return 'Pickup Location is Required';
                                        }
                                      },
                                      onChange: (value) {
                                        viewModel
                                            .onChangeChildPickupField(value);
                                      },
                                    ),
                                    20.vSpace(),
                                    Container(
                                      margin: const EdgeInsetsDirectional.only(
                                          start: margin16),
                                      child: Text(
                                        dropOffKey.tr,
                                        style: textTheme.displayMedium,
                                      ),
                                    ),
                                    6.vSpace(),
                                    InputField(
                                      fillColor: theme.primaryColorDark,
                                      controller: viewModel.dropOffCon,
                                      hint: enterDropOfKey.tr,
                                      hintStyle: textTheme.displayMedium!
                                          .copyWith(color: theme.cardColor),
                                      borderRadius: 10,
                                      borderColor: theme.primaryColorDark,
                                      maxLines: 1,
                                      suffixWidget: Container(
                                          //color: Colors.red,
                                          child: Text('  ')),
                                      suffixBoxConstraints: BoxConstraints(
                                        maxHeight:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                      ),
                                      prefixWidget: GestureDetector(
                                        onTap: () {
                                          viewModel.getChildDropOffLoc();
                                        },
                                        child: Container(
                                            height: 24,
                                            width: 24,
                                            margin: const EdgeInsetsDirectional
                                                .only(end: 15, start: 16),
                                            child: SvgPicture.asset(
                                              'assets/location_icon.svg',
                                            )),
                                      ),
                                      validator: (val) {
                                        if (val.toString().isEmpty) {
                                          return 'Drop Off Location is Required';
                                        }
                                      },
                                      onChange: (value) {
                                        viewModel
                                            .onChangeChildDropOffField(value);
                                      },
                                    ),
                                    20.vSpace(),
                                    Container(
                                      margin: const EdgeInsetsDirectional.only(
                                          start: margin16),
                                      child: Text(
                                        childNameKey.tr,
                                        style: textTheme.displayMedium,
                                      ),
                                    ),
                                    6.vSpace(),
                                    InputField(
                                      fillColor: theme.primaryColorDark,
                                      hint: enterChildNameKey.tr,
                                      controller: viewModel.childNameCon,
                                      hintStyle: textTheme.displayMedium!
                                          .copyWith(color: theme.cardColor),
                                      borderRadius: 10,
                                      borderColor: theme.primaryColorDark,
                                      maxLines: 1,
                                      suffixWidget: Container(
                                          //color: Colors.red,
                                          child: Text('  ')),
                                      suffixBoxConstraints: BoxConstraints(
                                        maxHeight:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                      ),
                                      validator: (val) {
                                        if (val.toString().isEmpty) {
                                          return 'Child Name is Required';
                                        }
                                      },
                                    ),
                                    20.vSpace(),
                                    Container(
                                      margin: const EdgeInsetsDirectional.only(
                                          start: margin16),
                                      child: Text(
                                        schoolNameKey.tr,
                                        style: textTheme.displayMedium,
                                      ),
                                    ),
                                    6.vSpace(),
                                    InputField(
                                      fillColor: theme.primaryColorDark,
                                      hint: enterSchoolKey.tr,
                                      controller: viewModel.schoolNameCon,
                                      hintStyle: textTheme.displayMedium!
                                          .copyWith(color: theme.cardColor),
                                      borderRadius: 10,
                                      borderColor: theme.primaryColorDark,
                                      maxLines: 1,
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return 'School name is required';
                                        }
                                      },
                                    ),
                                    20.vSpace(),
                                    Container(
                                      height: 98,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin:
                                                    const EdgeInsetsDirectional
                                                        .only(start: margin16),
                                                child: Text(
                                                  startTimeKey.tr,
                                                  style:
                                                      textTheme.displayMedium,
                                                ),
                                              ),
                                              6.vSpace(),
                                              SizedBox(
                                                width: mediaW * 0.43,
                                                child: InputField(
                                                  readOnlyField: true,
                                                  controller:
                                                      viewModel.startTimeCon,
                                                  fillColor:
                                                      theme.primaryColorDark,
                                                  hint: startKey.tr,
                                                  hintStyle: textTheme
                                                      .displayMedium!
                                                      .copyWith(
                                                          //height: 2,
                                                          color:
                                                              theme.cardColor),
                                                  textStyle: textTheme
                                                      .displayMedium!
                                                      .copyWith(height: 1.7),
                                                  borderRadius: 10,
                                                  borderColor:
                                                      theme.primaryColorDark,
                                                  maxLines: 1,
                                                  contentPadding:
                                                      const EdgeInsetsDirectional
                                                          .only(
                                                          start: 10, end: 0),
                                                  suffixWidget: Container(
                                                      height: 24,
                                                      width: 24,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 10),
                                                      child: SvgPicture.asset(
                                                        'assets/clock.svg',
                                                      )),
                                                  validator: (val) {
                                                    if (val
                                                        .toString()
                                                        .isEmpty) {
                                                      return 'Start Time is Required';
                                                    }
                                                  },
                                                  onTap: () async {
                                                    BottomPicker.time(
                                                            initialTime: Time(
                                                                hours: DateTime
                                                                        .now()
                                                                    .hour,
                                                                minutes: DateTime
                                                                        .now()
                                                                    .minute),
                                                            pickerTextStyle:
                                                                TextStyle(
                                                              color: theme
                                                                  .primaryColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15,
                                                            ),
                                                            titleStyle:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            descriptionStyle:
                                                                const TextStyle(
                                                                    color:
                                                                        Colors
                                                                            .red,
                                                                    fontSize:
                                                                        14),
                                                            closeIconColor:
                                                                Colors.black,
                                                            buttonSingleColor:
                                                                theme
                                                                    .primaryColor,
                                                            title:
                                                                startTimeKey.tr,
                                                            onSubmit: (time) {
                                                              viewModel
                                                                  .getChildStartTime(
                                                                      time);
                                                            },
                                                            onClose: () {
                                                              print(
                                                                  "Picker closed");
                                                            },
                                                            bottomPickerTheme:
                                                                BottomPickerTheme
                                                                    .blue,
                                                            use24hFormat: false)
                                                        .show(context);
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin:
                                                    const EdgeInsetsDirectional
                                                        .only(start: margin16),
                                                child: Text(
                                                  endTimeKey.tr,
                                                  style:
                                                      textTheme.displayMedium,
                                                ),
                                              ),
                                              6.vSpace(),
                                              SizedBox(
                                                width: mediaW * 0.43,
                                                child: IgnorePointer(
                                                  ignoring: viewModel
                                                      .startTimeCon
                                                      .text
                                                      .isEmpty,
                                                  child: InputField(
                                                    readOnlyField: true,
                                                    controller:
                                                        viewModel.endTimeCon,
                                                    fillColor:
                                                        theme.primaryColorDark,
                                                    hint: endKey.tr,
                                                    hintStyle: textTheme
                                                        .displayMedium!
                                                        .copyWith(
                                                            //height: 2,
                                                            color: theme
                                                                .cardColor),
                                                    textStyle: textTheme
                                                        .displayMedium!
                                                        .copyWith(height: 1.7),
                                                    borderRadius: 10,
                                                    borderColor:
                                                        theme.primaryColorDark,
                                                    maxLines: 1,
                                                    contentPadding:
                                                        const EdgeInsetsDirectional
                                                            .only(
                                                            start: 10, end: 0),
                                                    suffixWidget: Container(
                                                        height: 24,
                                                        width: 24,
                                                        margin: const EdgeInsets
                                                            .only(left: 10),
                                                        child: SvgPicture.asset(
                                                          'assets/clock.svg',
                                                        )),
                                                    validator: (val) {
                                                      if (val
                                                          .toString()
                                                          .isEmpty) {
                                                        return 'End Time is Required';
                                                      }
                                                    },
                                                    onTap: () async {
                                                      BottomPicker.time(
                                                              initialTime: Time(
                                                                  hours:
                                                                      DateTime.now()
                                                                          .hour,
                                                                  minutes: DateTime.now()
                                                                      .minute),
                                                              minTime: Time(
                                                                  hours: viewModel
                                                                      .selectedStartTime
                                                                      .hour,
                                                                  minutes: viewModel
                                                                          .selectedStartTime
                                                                          .minute +
                                                                      1),
                                                              pickerTextStyle:
                                                                  TextStyle(
                                                                color: theme
                                                                    .primaryColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 15,
                                                              ),
                                                              titleStyle:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                              descriptionStyle:
                                                                  const TextStyle(
                                                                      color: Colors
                                                                          .red,
                                                                      fontSize:
                                                                          14),
                                                              closeIconColor:
                                                                  Colors.black,
                                                              buttonSingleColor: theme
                                                                  .primaryColor,
                                                              title:
                                                                  endTimeKey.tr,
                                                              onSubmit: (time) {
                                                                viewModel
                                                                    .getChildEndTime(
                                                                        time);
                                                              },
                                                              onClose: () {
                                                                print(
                                                                    "Picker closed");
                                                              },
                                                              bottomPickerTheme:
                                                                  BottomPickerTheme
                                                                      .blue,
                                                              use24hFormat: false)
                                                          .show(context);
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              (0.035 * mediaH).vSpace(),
                              Center(
                                child: ButtonWidget(
                                  width: 145,
                                  height: 48,
                                  btnText: submitKey.tr,
                                  textStyle: textTheme.titleLarge!.copyWith(
                                      color: theme.unselectedWidgetColor),
                                  radius: 76,
                                  onTap: () {
                                    if (viewModel.selectedStartTime
                                        .isAfter(viewModel.selectedEndTime)) {
                                      print('time time');
                                      viewModel.showSnackBar(
                                          "End time must be greater than start time",
                                          SnackBarType.universal,
                                          color: Theme.of(context).canvasColor,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14));
                                    } else if (viewModel.formKey.currentState!
                                        .validate()) {
                                      viewModel.addChild(
                                        selectedStartTime:
                                            viewModel.selectedStartTime,
                                        selectedEndTime:
                                            viewModel.selectedEndTime,
                                        pickUpLocation:
                                            viewModel.pickUpCon.text.trim(),
                                        name:
                                            viewModel.childNameCon.text.trim(),
                                        schoolName:
                                            viewModel.schoolNameCon.text.trim(),
                                        startTime:
                                            viewModel.startTimeCon.text.trim(),
                                        endTime:
                                            viewModel.endTimeCon.text.trim(),
                                        dropOffLocation:
                                            viewModel.dropOffCon.text.trim(),
                                      );
                                    } else {
                                      viewModel.autoValidateForm();
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    if (viewModel.showSuggestion &&
                        viewModel.suggestions.length > 0)
                      Positioned(
                          left: 0,
                          right: 0,
                          top: (viewModel.isPickupLocation)
                              ? (mediaH * 0.27)
                              : (mediaH * 0.385),
                          child: suggestionContainer(theme, viewModel))
                  ],
                ),
              ),
            ),
          ),
        );
      },
      viewModelBuilder: () => AddChildViewModel(),
      onViewModelReady: (model) => SchedulerBinding.instance
          .addPostFrameCallback(
              (_) => model.initialise(parentAddress: widget.parentAddress)),
    );
  }

  Container suggestionContainer(ThemeData theme, AddChildViewModel viewModel) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: theme.unselectedWidgetColor,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff000000).withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      margin: const EdgeInsets.only(top: 5, left: hMargin, right: hMargin),
      child: FadingEdgeScrollView.fromScrollView(
        child: ListView.separated(
            controller: viewModel.placeListCon,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            padding:
                const EdgeInsets.symmetric(horizontal: hMargin, vertical: 10),
            itemBuilder: (context, index) {
              return InkWell(
                  onTap: () {
                    setState(() {
                      viewModel.showSuggestion = false;
                      if (viewModel.isPickupLocation) {
                        viewModel.pickUpCon.text =
                            viewModel.suggestions[index].description;
                        viewModel.pickUpCon.selection = TextSelection.collapsed(
                            offset: viewModel.pickUpCon.text.length);
                        viewModel.getLatLng(
                            viewModel.suggestions[index].placeId, 1);
                      } else {
                        viewModel.dropOffCon.text =
                            viewModel.suggestions[index].description;
                        viewModel.dropOffCon.selection =
                            TextSelection.collapsed(
                                offset: viewModel.dropOffCon.text.length);
                        viewModel.getLatLng(
                            viewModel.suggestions[index].placeId, 2);
                      }
                    });
                  },
                  child: Text(viewModel.suggestions[index].description));
            },
            separatorBuilder: (context, index) {
              return Divider(
                color: theme.dividerColor,
              );
            },
            itemCount: viewModel.suggestions.length),
      ),
    );
  }
}
