import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pickup_parent/src/app/constants/constants.dart';
import 'package:pickup_parent/src/language/language_keys.dart';
import 'package:pickup_parent/ui/views/ride/car_details/car_detail_viewmodel.dart';
import 'package:pickup_parent/ui/widgets/app_bar_widget.dart';
import 'package:pickup_parent/ui/widgets/ride/car_detail_bottom_widget.dart';
import 'package:pickup_parent/ui/widgets/ride/car_detail_top_widget.dart';
import 'package:pickup_parent/ui/widgets/ride/car_specification_widget.dart';
import 'package:stacked/stacked.dart';

class CarDetailView extends StatefulWidget {
  const CarDetailView({super.key});

  @override
  State<CarDetailView> createState() => _CarDetailViewState();
}

class _CarDetailViewState extends State<CarDetailView> {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final mediaW = MediaQuery.of(context).size.width;
    final mediaH = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return ViewModelBuilder<CarDetailViewModel>.reactive(
      builder: (context, viewModel, child) {
        return Scaffold(
            //extendBodyBehindAppBar: true,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: AppBarWidget(
                bgColor: theme.dialogBackgroundColor,
                title: carDetailKey.tr,
                titleStyle: textTheme.titleLarge!,
                leadingIcon: 'assets/back_arrow_white.svg',
                leadingIconOnTap: () => Get.back(),
                actionIcon: 'assets/black_bell_icon.svg',
              ),
            ),
            body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverToBoxAdapter(
                  child: CarDetailTopWidget(),
                )
              ],
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  specificationHeading(theme, textTheme),
                  Expanded(child: ListView(
                    padding: EdgeInsets.only(top: 24),
                    children: [
                    CarSpecificationWidget(),
                    CarDetailBottomWidget(
                      phoneOnTap:()=> viewModel.phoneOnTap(),
                      smsOnTap: ()=> viewModel.smsOnTap(),
                    )
                  ],))

                ],
              ),
            )
            );
      },
      viewModelBuilder: () => CarDetailViewModel(),
    );
  }

  Container specificationHeading(ThemeData theme, TextTheme textTheme) {
    return Container(
      color: theme.scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsetsDirectional.only(
            start: hMargin, top: 17, bottom: 0),
        child: Text(
          specificationKey.tr,
          style: textTheme.displayMedium!.copyWith(fontSize: 20),
        ),
      ),
    );
  }

}
