import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pickup_parent/models/all_subscriptions_model.dart';
import 'package:pickup_parent/src/app/constants/constants.dart';
import 'package:pickup_parent/src/app/extensions.dart';
import 'package:pickup_parent/src/language/language_keys.dart';
import 'package:pickup_parent/src/theme/base_theme.dart';
import 'package:pickup_parent/ui/views/review/review_view.dart';
import 'package:pickup_parent/ui/views/ride/subscription_detail/subscription_detail_viewmodel.dart';
import 'package:pickup_parent/ui/widgets/app_bar_widget.dart';
import 'package:pickup_parent/ui/widgets/button_widget.dart';
import 'package:pickup_parent/ui/widgets/ride/child_detail_widget.dart';
import 'package:pickup_parent/ui/widgets/subscription_detail_list_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:dotted_border/dotted_border.dart';

class SubscriptionDetailView extends StatefulWidget {
  List<ChildElement> selectedService = [];
  int id;
  double distance;
  double amount;
  SubscriptionDetailView({super.key,required this.selectedService, required this.id, required this.distance,required this.amount});

  @override
  State<SubscriptionDetailView> createState() => _SubscriptionDetailViewState();
}

class _SubscriptionDetailViewState extends State<SubscriptionDetailView> {

  @override
  Widget build(BuildContext context) {
    final mediaW = MediaQuery.of(context).size.width;
    final mediaH = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return ViewModelBuilder<SubscriptionDetailViewModel>.reactive(
      builder: (context, viewModel, child) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          //extendBody: true,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: AppBarWidget(
              title: subsDetailKey.tr,
              titleStyle: textTheme.titleLarge!,
              leadingIcon: 'assets/back_arrow_light.svg',
              leadingIconOnTap: () => Get.back(),
              actionIcon: 'assets/black_bell_icon.svg',
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: mediaH * 0.747,
                  child: FadingEdgeScrollView.fromSingleChildScrollView(
                    child: SingleChildScrollView(
                      controller: viewModel.singleChildController,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          (0.033 * mediaH).vSpace(),
                          Padding(
                            padding:
                                const EdgeInsetsDirectional.only(start: 32),
                            child: Text(
                              childDetailKey.tr,
                              style: textTheme.displayMedium!
                                  .copyWith(fontSize: 20),
                            ),
                          ),
                          (0.019 * mediaH).vSpace(),
                          ChildDetailWidget(theme: theme, textTheme: textTheme,selectedChild: widget.selectedService,amount: widget.amount,distance: widget.distance),
                          (0.033 * mediaH).vSpace(),
                          Padding(
                            padding:
                                const EdgeInsetsDirectional.only(start: 24),
                            child: Text(
                              paymentMethodKey.tr,
                              style: textTheme.displayMedium!
                                  .copyWith(fontSize: 20),
                            ),
                          ),
                          (0.027 * mediaH).vSpace(),
                          SizedBox(
                            height: 46,
                            width: mediaW,
                            child: FadingEdgeScrollView.fromScrollView(
                                child: ListView.separated(
                                    controller: viewModel.scrollController,
                                    scrollDirection: Axis.horizontal,
                                    physics: const BouncingScrollPhysics(),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: hMargin),
                                    itemBuilder: (context, index) {
                                      if (index == viewModel.selectedMethod) {
                                        viewModel.isMethodSelected = true;
                                      } else {
                                        viewModel.isMethodSelected = false;
                                      }
                                      return GestureDetector(
                                        onTap: ()=> viewModel.paymentMethodOnTap(index),
                                        child: SubscriptionDetailListWidget(
                                            isMethodSelected: viewModel.isMethodSelected),
                                      );
                                    },
                                    separatorBuilder: (context, index) =>
                                        12.hSpace(),
                                    itemCount: 4)),
                          ),
                          (0.033 * mediaH).vSpace(),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: hMargin),
                            child: DottedBorder(
                                color: theme.cardColor,
                                strokeWidth: 1,
                                dashPattern: const [
                                  6,
                                  5,
                                ],
                                radius: const Radius.circular(10),
                                //padding: EdgeInsets.all(6),
                                borderType: BorderType.RRect,
                                child: Container(
                                  height: 51,
                                  decoration: BoxDecoration(
                                    color: theme.unselectedWidgetColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        addPymntKey.tr,
                                        style: textTheme.headlineMedium!.copyWith(height: 0),
                                      ),
                                      43.hSpace(),
                                      Padding(
                                        padding:
                                            const EdgeInsetsDirectional.only(
                                                end: 22),
                                        child:
                                            SvgPicture.asset('assets/plus.svg'),
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                          (0.013 * mediaH).vSpace(),
                          Padding(
                            padding: const EdgeInsetsDirectional.only(
                                start: 25, end: 21),
                            child: Text(
                              addNewMethodkey.tr,
                              style: textTheme.displayMedium!.copyWith(
                                  fontSize: 14, color: theme.canvasColor),
                            ),
                          ),
                          (0.029 * mediaH).vSpace(),
                          Padding(
                            padding:
                                const EdgeInsetsDirectional.only(start: 24),
                            child: Row(
                              children: [
                                Text(
                                  promoCodeKey.tr,
                                  style: textTheme.displayMedium!
                                      .copyWith(fontSize: 20),
                                ),
                                const Spacer(),
                                Padding(
                                  padding:
                                      const EdgeInsetsDirectional.only(end: 43),
                                  child: SvgPicture.asset('assets/plus.svg'),
                                ),
                              ],
                            ),
                          ),
                          (0.013 * mediaH).vSpace(),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: hMargin),
                            child: DottedBorder(
                              color: theme.cardColor,
                              strokeWidth: 1,
                              dashPattern: const [
                                6,
                                5,
                              ],
                              radius: const Radius.circular(10),
                              //padding: EdgeInsets.all(6),
                              borderType: BorderType.RRect,
                              child: Container(
                                height: 68,
                                padding: EdgeInsets.symmetric(
                                    horizontal: mediaW * 0.25),
                                decoration: BoxDecoration(
                                  color: theme.unselectedWidgetColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: TextFormField(
                                    cursorColor: theme.primaryColor,
                                    cursorHeight: 24,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: defaultFontFamily,
                                      color: theme.cardColor,
                                    ),
                                    decoration: InputDecoration(
                                        // fillColor: Colors.red,
                                        // filled: true,
                                        hintText: 'RIDE1234',
                                        hintStyle: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: defaultFontFamily,
                                          color: theme.cardColor,
                                          height: 2
                                        ),
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: mediaH * 0.125,
                  //color: Colors.lightBlue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 23),
                  child: GestureDetector(
                    onTap: ()=> viewModel.payNow(id: widget.id),
                    child: Container(
                      padding:const EdgeInsets.symmetric(horizontal: 35,vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(30)
                      ),
                      child: SvgPicture.asset('assets/button_arrow.svg'),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
      viewModelBuilder: () => SubscriptionDetailViewModel(),
      onViewModelReady: (viewModel) =>SchedulerBinding.instance.addPostFrameCallback((_)=> viewModel.initialise() ) ,
    );
  }
}
