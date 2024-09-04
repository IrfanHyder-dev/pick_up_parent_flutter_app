import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pickup_parent/models/all_child_model.dart';
import 'package:pickup_parent/src/app/extensions.dart';
import 'package:pickup_parent/src/language/language_keys.dart';
import 'package:pickup_parent/src/theme/base_theme.dart';
import 'package:pickup_parent/ui/views/profilel/parent_profile/parent_profile_viewmodel.dart';
import 'package:pickup_parent/ui/widgets/loading_widget.dart';

class AddedChildListWidget extends StatelessWidget {
  AddedChildListWidget({
    super.key,
    required this.viewModel,
    required this.index,
  });

  ParentProfileViewModel viewModel;
  int index;

  @override
  Widget build(BuildContext context) {
    final mediaW = MediaQuery.of(context).size.width;
    final mediaH = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Container(
      height: mediaH * 0.235,
      width: mediaW,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: theme.unselectedWidgetColor,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            children: [
              Container(
                width: mediaW * 0.6,
                margin: const EdgeInsetsDirectional.only(start: 34, top: 0),
                child: Text(
                  viewModel.allChildModel?.child[index].name ?? '',
                  style: textTheme.bodyLarge,
                ),
              ),
              Spacer(),
              GestureDetector(
                child: Container(
                  height: 30,
                  width: 30,
                  margin: EdgeInsetsDirectional.only(end: 5),
                  child: Center(
                    child: Icon(
                      Icons.delete,
                      color: redColor,
                      size: 25,
                    ),
                  ),
                ),
                onTap: () {
                  CustomDialog.showInfoDialog(
                      context: context,
                      infoText: deleteChildInfoTextKey.tr,
                      showSecondBtn: true,
                      secondBtnText: deleteBtnKey.tr,
                      onTapBtn: () {
                        Get.back();
                        viewModel.deleteChild(
                          context: context,
                            childId:
                                viewModel.allChildModel?.child[index].id ?? 0);
                      });
                },
              ),
              // Container(color: Colors.yellow,child: Text('mounim'),)
            ],
          ),
        ),
        20.vSpace(),
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 29),
          child: Row(
            children: [
              Column(
                children: [
                  SvgPicture.asset('assets/pickup_icon.svg'),
                  5.vSpace(),
                  SvgPicture.asset('assets/line_icon.svg'),
                  5.vSpace(),
                  SvgPicture.asset('assets/dropoff_icon.svg'),
                ],
              ),
              16.hSpace(),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pickUpKey.tr,
                    overflow: TextOverflow.ellipsis,
                    style:
                        textTheme.bodyLarge!.copyWith(color: theme.cardColor),
                  ),
                  5.vSpace(),
                  SizedBox(
                    width: mediaW * 0.68,
                    child: Text(
                      viewModel.allChildModel?.child[index].pickUp.address ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      style: textTheme.bodyLarge!.copyWith(height: 0),
                    ),
                  ),
                  15.vSpace(),
                  Text(
                    dropOffKey.tr,
                    style:
                        textTheme.bodyLarge!.copyWith(color: theme.cardColor),
                  ),
                  5.vSpace(),
                  SizedBox(
                    width: mediaW * 0.68,
                    child: Text(
                      viewModel.allChildModel?.child[index].dropOff.address ??
                          '',
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      style: textTheme.bodyLarge!.copyWith(height: 0),
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ]),
    );
  }
}
