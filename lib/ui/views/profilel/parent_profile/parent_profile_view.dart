import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:pickup_parent/src/app/constants/constants.dart';
import 'package:pickup_parent/src/app/enum/enum.dart';
import 'package:pickup_parent/src/app/extensions.dart';
import 'package:pickup_parent/src/app/static_info.dart';
import 'package:pickup_parent/src/language/language_keys.dart';
import 'package:pickup_parent/ui/views/notification/notification_view.dart';
import 'package:pickup_parent/ui/views/profilel/current_location/current_location_view.dart';
import 'package:pickup_parent/ui/views/profilel/parent_profile/parent_profile_viewmodel.dart';
import 'package:pickup_parent/ui/widgets/added_child_list_widget.dart';
import 'package:pickup_parent/ui/widgets/app_bar_widget.dart';
import 'package:pickup_parent/ui/widgets/button_widget.dart';
import 'package:pickup_parent/ui/widgets/image_picker_widget.dart';
import 'package:pickup_parent/ui/widgets/input_field_widget.dart';
import 'package:pickup_parent/ui/widgets/pop_scope_dialog_widget.dart';
import 'package:stacked/stacked.dart';

class ParentProfileView extends StatefulWidget {
  const ParentProfileView({super.key});

  @override
  State<ParentProfileView> createState() => _ParentProfileViewState();
}

class _ParentProfileViewState extends State<ParentProfileView> {
  final ImagePicker _picker = ImagePicker();
  File? _profileImage = null;
  final _addressKey = GlobalKey<FormState>();
  final _nameKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidateAddressField = AutovalidateMode.disabled;
  AutovalidateMode _autoValidateNameField = AutovalidateMode.disabled;
  final ScrollController scrollController = ScrollController();
  ScrollController listViewCont = ScrollController();
  final ScrollController placeListCon = ScrollController();
  TextEditingController addressCon = TextEditingController();
  TextEditingController nameCon = TextEditingController();
  bool showSuggestion = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (StaticInfo.userModel!.data.user.name.isNotEmpty) {
      nameCon.text =
          '${StaticInfo.userModel!.data.user.name} ${StaticInfo.userModel!.data.user.surname}';
    }
    print('profile screen ${StaticInfo.userModel!.data.user.userLocation.address}');
    if (StaticInfo.userModel!.data.user.userLocation.address != null) {
      addressCon.text = StaticInfo.userModel!.data.user.userLocation.address!;
    }
  }

  void debouncing({required Function() fn, int waitForMs = 1}) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(Duration(seconds: waitForMs), fn);
  }

  @override
  Widget build(BuildContext context) {
    final mediaW = MediaQuery.of(context).size.width;
    final mediaH = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return ViewModelBuilder<ParentProfileViewModel>.reactive(
      builder: (context, viewModel, child) {
        return WillPopScope(
          onWillPop: () async {
            bool? shouldPop;
            (Navigator.canPop(context))
                ? Get.back()
                : shouldPop = await showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return PopScopeDialogWidget();
                    },
                  );
            if (shouldPop == true) {
              MoveToBackground.moveTaskToBack();
              return false;
            } else {
              return false;
            }
          },
          child: Scaffold(
            extendBodyBehindAppBar: true,
            resizeToAvoidBottomInset: false,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: AppBarWidget(
                title: profileKey.tr,
                titleStyle: textTheme.titleLarge!,
                //actionIcon: 'assets/black_bell_icon.svg',
                leadingIconOnTap: () => Get.back(),
                leadingIcon: (StaticInfo.userModel!.data.user.profileCompleted)
                    ? 'assets/back_arrow_light.svg'
                    : null,
               // actonIconOnTap: () => Get.to(() => const NotificationView()),
              ),
            ),
            body: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      //color: Colors.green,
                      height: mediaH * 0.28,
                      width: mediaW,
                      child: Stack(
                        children: [
                          SvgPicture.asset('assets/bg_image.svg',
                              fit: BoxFit.cover),
                          Column(
                            children: [
                              (0.155 * mediaH).vSpace(),
                              //showPopupMenu(context),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 38),
                                child: Form(
                                  key: _addressKey,
                                  autovalidateMode: _autoValidateAddressField,
                                  child: InputField(
                                    controller: addressCon,
                                    fillColor: theme.unselectedWidgetColor,
                                    hint: setLocationKey.tr,
                                    textStyle: textTheme.titleLarge!.copyWith(
                                      fontWeight: FontWeight.w400,
                                      // fontSize: 16,
                                      //height:1
                                    ),
                                    hintStyle: textTheme.displayMedium!
                                        .copyWith(color: theme.cardColor,height: 2,),
                                    contentPadding: EdgeInsetsDirectional.symmetric(horizontal: 15,vertical: 0),
                                    borderRadius: 10,
                                    borderColor: theme.primaryColorDark,
                                    maxLines: 1,
                                    suffixWidget: Container(
                                        //color: Colors.red,
                                        child: Text('  ')
                                      ),
                                    suffixBoxConstraints: BoxConstraints(
                                      maxHeight: MediaQuery.of(context).size.width * 0.5,
                                      maxWidth: MediaQuery.of(context).size.width * 0.5,
                                    ),
                                    prefixWidget: GestureDetector(
                                      onTap: () {
                                        Get.to(() => CurrentLocationView(
                                              userCurrentLocation:
                                                  (String address, double lat,
                                                      double lng) {
                                                setState(() {
                                                  addressCon.text = address;
                                                  viewModel.parentLocLatLng =
                                                      LatLng(lat, lng);
                                                });
                                              },
                                            ));
                                        //Get.to(() => VehicleTrackingView());
                                      },
                                      child: Container(
                                          height: 22,
                                          width: 22,
                                          margin:
                                              const EdgeInsetsDirectional.only(
                                                  end: 15, start: 16),
                                          child: SvgPicture.asset(
                                            'assets/location_icon.svg',
                                          )),
                                    ),
                                    onChange: (value) {
                                      //viewModel.autoCompletePlaces(address: _textEditingController.text);
                                      setState(() {
                                        debouncing(
                                          fn: () {
                                            if(addressCon.text.isNotEmpty){
                                              viewModel.autoCompletePlaces(
                                                  address: addressCon.text);
                                            }
                                          },
                                        );
                                        if (value.isEmpty) {
                                          showSuggestion = false;
                                        } else {
                                          showSuggestion = true;
                                        }
                                      });
                                    },
                                    validator: (val) {
                                      if (val.toString().isEmpty) {
                                        return 'Address is required';
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          //(mediaH * 0.219).vSpace(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: hMargin),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Stack(
                              children: [
                                Container(
                                  height: 123,
                                  width: 123,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: theme.primaryColor, width: 2),
                                      image: DecorationImage(
                                        image: (_profileImage != null)
                                            ? Image.file(
                                                File(_profileImage!.path),
                                                //fit: BoxFit.contain,
                                                width: 123,
                                                height: 123,
                                              ).image
                                            : (StaticInfo.userModel!.data.user
                                                    .profilePicture.isNotEmpty)
                                                ? Image.network(
                                                    StaticInfo.userModel!.data
                                                        .user.profilePicture,
                                                    fit: BoxFit.fitWidth,
                                                    height: 123,
                                                    width: 123,
                                                  ).image
                                                : const AssetImage(
                                                    'assets/person_placeholder.png'),
                                      )),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: SvgPicture.asset(
                                          'assets/camera_icon.svg'),
                                    ),
                                    onTap: () {
                                      showModalBottomSheet(
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(20),
                                                topLeft: Radius.circular(20))),
                                        context: context,
                                        builder: (context) {
                                          return ImagePickerWidget(
                                              imagePath: (File? image) {
                                            print('child result is $image');
                                            setState(() {
                                              _profileImage = image;
                                            });
                                          });
                                        },
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                          (0.03 * mediaH).vSpace(),
                          Container(
                            margin: const EdgeInsets.only(left: margin16),
                            child: Text(
                              nameKey.tr,
                              style: textTheme.displayMedium,
                            ),
                          ),
                          6.vSpace(),
                          Form(
                            key: _nameKey,
                            autovalidateMode: _autoValidateNameField,
                            child: InputField(
                              fillColor: theme.primaryColorDark,
                              hint: nameKey.tr,
                              controller: nameCon,
                              hintStyle: textTheme.displayMedium!
                                  .copyWith(color: theme.cardColor),
                              //prefixImage: 'assets/user.svg',
                              suffixWidget: Container(
                                //color: Colors.red,
                                  child: Text('  ')
                              ),
                              suffixBoxConstraints: BoxConstraints(
                                maxHeight: MediaQuery.of(context).size.width * 0.5,
                                maxWidth: MediaQuery.of(context).size.width * 0.5,
                              ),
                              borderRadius: 10,
                              borderColor: theme.primaryColorDark,
                              maxLines: 1,
                              validator: (val) {
                                if (val.toString().isEmpty) {
                                  return 'Name is Required';
                                }
                              },
                            ),
                          ),
                          //(0.04 * mediaH).vSpace(),
                          Container(
                            //color: Colors.green,
                            height: mediaH * 0.39,
                            child: Stack(
                              children: [
                                if (viewModel.allChildModel != null)
                                  FadingEdgeScrollView.fromScrollView(
                                    child: ListView.separated(
                                        physics: const BouncingScrollPhysics(),
                                        controller: scrollController,
                                        padding: const EdgeInsets.only(
                                            top: 25, bottom: 60),
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return AddedChildListWidget(
                                            index: index,
                                            viewModel: viewModel,
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return 10.vSpace();
                                        },
                                        itemCount: viewModel
                                            .allChildModel!.child.length),
                                  ),
                                //(0.09 * mediaH).vSpace(),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          // height: 48,
                                          width: mediaW * 0.39,
                                          child: ButtonWidget(
                                            horizontalPadding: 0,
                                            radius: 76,
                                            bgColor: (StaticInfo.userModel!.data
                                                    .user.profileCompleted)
                                                ? Colors.black
                                                : theme.canvasColor,
                                            btnText: addChildKey.tr,
                                            textStyle: textTheme.titleLarge!
                                                .copyWith(
                                                    color: theme
                                                        .unselectedWidgetColor),
                                            //bgColor: theme.cardColor,
                                            onTap: () {
                                              if (StaticInfo.userModel!.data
                                                  .user.profileCompleted) {
                                                viewModel
                                                    .updateChildModelLocally(parentAddress: addressCon.text.trim());
                                              } else {
                                                viewModel.showSnackBar(
                                                    "Complete your profile first.",
                                                    SnackBarType.universal,
                                                    color: Theme.of(context)
                                                        .canvasColor,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16
                                                )

                                                );
                                                //MotionToast.(description: Text('Complete your profile first'),height: 60,width: 300,).show(context);
                                              }
                                              // Get.to(() => const AddChildView());

                                              //Get.to(() => const Dummy());
                                            },
                                          ),
                                        ),
                                        15.hSpace(),
                                        SizedBox(
                                          //height: 48,
                                          width: mediaW * 0.39,
                                          child: ButtonWidget(
                                            horizontalPadding: 0,
                                            radius: 76,
                                            btnText: updateKey.tr,
                                            textStyle: textTheme.titleLarge!
                                                .copyWith(
                                                    color: theme
                                                        .unselectedWidgetColor),
                                            onTap: () {
                                              FocusScope.of(context).unfocus();
                                              // _profileImage ??= File('');

                                              if (_addressKey.currentState!
                                                      .validate() &&
                                                  _nameKey.currentState!
                                                      .validate()) {
                                                viewModel.updateParentProfile(
                                                    address:
                                                        addressCon.text.trim(),
                                                    name: nameCon.text.trim(),
                                                    imagePath: (_profileImage !=
                                                            null)
                                                        ? _profileImage!.path
                                                        : '');
                                              } else {
                                                _autoValidateAddressField =
                                                    AutovalidateMode
                                                        .onUserInteraction;
                                                _autoValidateNameField =
                                                    AutovalidateMode
                                                        .onUserInteraction;
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                if (showSuggestion && viewModel.suggestions.length>0)

                  Positioned(
                    top: mediaH * 0.219,
                    left: 0,
                    right: 0,
                    //bottom: 0,
                    child: Container(
                      height: 300,
                      //width: 200,
                      decoration: BoxDecoration(
                        color: theme.unselectedWidgetColor,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xff000000).withOpacity(0.1),
                            //Color.fromARGB(120, 0, 0, 0),
                            blurRadius: 10,
                            spreadRadius: 5,
                          ),
                        ],
                      ),

                      margin:
                          const EdgeInsets.only(top: 5, left: 38, right: 38),
                      //padding: const EdgeInsets.symmetric(horizontal: hMargin),
                      child: FadingEdgeScrollView.fromScrollView(
                        child: ListView.separated(
                            controller: placeListCon,
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(
                                horizontal: hMargin, vertical: 10),
                            itemBuilder: (context, index) {
                              return InkWell(
                                  onTap: () {
                                    setState(() {
                                      showSuggestion = false;
                                      addressCon.text = viewModel
                                          .suggestions[index].description;
                                      addressCon.selection =
                                          TextSelection.collapsed(
                                              offset: addressCon.text.length);
                                      viewModel.getLatLng(
                                          viewModel.suggestions[index].placeId);
                                    });
                                  },
                                  child: Text(viewModel
                                      .suggestions[index].description));
                            },
                            separatorBuilder: (context, index) {
                              return Divider(
                                color: theme.dividerColor,
                              );
                            },
                            itemCount: viewModel.suggestions.length),
                      ),
                    ),
                  )
              ],
            ),
          ),
        );
      },
      viewModelBuilder: () => ParentProfileViewModel(),
      onViewModelReady: (model) => SchedulerBinding.instance
          .addPostFrameCallback((_) => model.initialise()),
    );
  }
}
