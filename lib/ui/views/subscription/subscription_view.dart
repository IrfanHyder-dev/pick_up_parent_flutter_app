import 'dart:math' as math;
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pickup_parent/src/app/constants/constants.dart';
import 'package:pickup_parent/src/app/enum/enum.dart';
import 'package:pickup_parent/src/app/extensions.dart';
import 'package:pickup_parent/src/language/language_keys.dart';
import 'package:pickup_parent/src/theme/base_theme.dart';
import 'package:pickup_parent/ui/views/subscription/subscription_viewmodel.dart';
import 'package:pickup_parent/ui/widgets/app_bar_widget.dart';
import 'package:pickup_parent/ui/widgets/button_widget.dart';
import 'package:pickup_parent/ui/widgets/child_names_dialog_widget.dart';
import 'package:pickup_parent/ui/widgets/pickup_dropoff_info_widget.dart';
import 'package:stacked/stacked.dart';
import '../notification/notification_view.dart';

class SubscriptionView extends StatefulWidget {
  const SubscriptionView({super.key});

  @override
  State<SubscriptionView> createState() => _SubscriptionViewState();
}

class _SubscriptionViewState extends State<SubscriptionView> {
  final ScrollController listController = ScrollController();
  Color firstGradientColor = lightThemeFirstGradientColor;
  Color secondGradientColor = lightThemeSecondGradientColor;

  @override
  Widget build(BuildContext context) {
    final mediaW = MediaQuery.of(context).size.width;
    final mediaH = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return ViewModelBuilder<SubscriptionViewModel>.reactive(
      builder: (context, viewModel, child) {
        return Scaffold(
          body: Stack(
            children: [
              SizedBox(
                height: mediaH * 0.313,
                width: mediaW,
                child: SvgPicture.asset(
                  'assets/bg_image.svg',
                  fit: BoxFit.cover,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PreferredSize(
                    preferredSize: Size.fromHeight(kToolbarHeight),
                    child: AppBarWidget(
                      title: '',
                      titleStyle: textTheme.titleLarge!,
                      actionIcon: 'assets/black_bell_icon.svg',
                      actonIconOnTap: () =>
                          Get.to(() => const NotificationView()),
                    ),
                  ),
                  (mediaH * 0.0226).vSpace(),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(start: 23),
                    child: Text(
                      subscriptionKey.tr,
                      style: textTheme.displayLarge!.copyWith(fontSize: 24),
                    ),
                  ),
                  (mediaH * 0.06).vSpace(),
                  (viewModel.isDataLoad)
                      ? (viewModel.allSubscriptionsModel!.subscriptionData!
                                  .isEmpty ||
                              viewModel.allSubscriptionsModel != null)
                          ? Container(
                              //color: Colors.red,
                              height: mediaH * 0.7,
                              child: FadingEdgeScrollView.fromScrollView(
                                  child: ListView.separated(
                                controller: listController,
                                physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.only(
                                    left: hMargin,
                                    right: hMargin,
                                    top: 15,
                                    bottom: 40),
                                itemCount: viewModel.allSubscriptionsModel
                                        ?.subscriptionData?.length ??
                                    0,
                                itemBuilder: (context, index) {
                                  var data = viewModel.allSubscriptionsModel
                                      ?.subscriptionData?[index];
                                  // .allSubscriptionsModel!.data[index];

                                  return GestureDetector(
                                    onTap: () => viewModel.onTap(index: index),
                                    child: Container(
                                      //height: 265,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: LinearGradient(
                                          colors: [
                                            firstGradientColor,
                                            secondGradientColor,
                                          ],
                                          begin: const Alignment(-1.0, 0.0),
                                          end: const Alignment(1.0, 0.0),
                                          transform: const GradientRotation(
                                              math.pi / 4),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xff000000)
                                                .withOpacity(0.1),
                                            //Color.fromARGB(120, 0, 0, 0),
                                            blurRadius: 10,
                                            spreadRadius: 4,
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              margin:
                                                  const EdgeInsetsDirectional
                                                      .only(
                                                      start: 34,
                                                      top: 18,
                                                      bottom: 10,
                                                      end: 20),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 190,
                                                    child: Text(
                                                      data?.children?[0].child
                                                              ?.name ??
                                                          '',
                                                      style: textTheme
                                                          .displayMedium,
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  if (data!.children!.length >
                                                      1)
                                                    GestureDetector(
                                                      onTap: () => showDialog(
                                                        useSafeArea: true,
                                                        context: context,
                                                        builder: (context) =>
                                                            ChildNamesDialogWidget(
                                                                child:
                                                                    data.children ??
                                                                        []),
                                                      ),
                                                      child: Text(
                                                        '${data.children?.length} more',
                                                        style: textTheme
                                                            .displayMedium!
                                                            .copyWith(
                                                                color: theme
                                                                    .cardColor),
                                                      ),
                                                    ),
                                                ],
                                              )),
                                          27.vSpace(),
                                          PickupDropOffInfoWidget(
                                            pickupLocation: data.children?[0]
                                                    .child?.pickUpLocation ??
                                                '',
                                            dropOffLocation: data.children?[0]
                                                    .child?.dropOffLocation ??
                                                '',
                                            startTime: DateFormat('hh:mm a')
                                                .format(data.children![0].child!
                                                    .startTime!),
                                            endTime: DateFormat('hh:mm a')
                                                .format(data.children![0].child!
                                                    .endTime!),
                                          ),
                                          20.vSpace(),
                                          Container(
                                            padding: EdgeInsetsDirectional.only(
                                                end: 20),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  'Status:',
                                                  style: textTheme.bodyLarge!
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w600),
                                                ),
                                                5.hSpace(),
                                                Text(
                                                  viewModel
                                                      .currentStatusOfQuotation(
                                                          index: index),
                                                  style: textTheme.bodyLarge,
                                                ),
                                              ],
                                            ),
                                          ),
                                          10.vSpace(),
                                          // if (data.status == QuotationStatus.pending)
                                          if (data.status !=
                                                  QuotationStatus.paid &&
                                              data.status !=
                                                  QuotationStatus
                                                      .accept_and_paid &&
                                              data.status !=
                                                  QuotationStatus.reject)
                                            Column(
                                              children: [
                                                Center(
                                                  child: SizedBox(
                                                    width: mediaW * 0.68,
                                                    child: const Divider(
                                                      thickness: 1,
                                                    ),
                                                  ),
                                                ),
                                                10.vSpace(),
                                                Center(
                                                  child: SizedBox(
                                                    width: mediaW * 0.68,
                                                    child: ButtonWidget(
                                                      verticalPadding: 10,
                                                      btnText: "Cancel Request",
                                                      textStyle: TextStyle(
                                                          color: Colors.white),
                                                      onTap: () {
                                                        viewModel.cancelRequest(
                                                            quotationId:
                                                                data.id ?? -1);
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                10.vSpace(),
                                              ],
                                            )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return 15.vSpace();
                                },
                              )),
                            )
                          : SizedBox(
                              height: mediaH * 0.7,
                              child: Center(
                                child: Text(
                                  'No Subscription yet',
                                  style: textTheme.displayMedium,
                                ),
                              ))
                      : Container(),
                ],
              )
            ],
          ),
        );
      },
      viewModelBuilder: () => SubscriptionViewModel(),
      disposeViewModel: false,
      fireOnViewModelReadyOnce: true,
      initialiseSpecialViewModelsOnce: true,
      onViewModelReady: (viewModel) => SchedulerBinding.instance
          .addPostFrameCallback((_) => viewModel.initialise()),
    );
  }
}
