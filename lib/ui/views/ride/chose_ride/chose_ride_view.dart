import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pickup_parent/models/all_child_model.dart';
import 'package:pickup_parent/src/app/locator.dart';
import 'package:pickup_parent/src/language/language_keys.dart';
import 'package:pickup_parent/ui/views/notification/notification_view.dart';
import 'package:pickup_parent/ui/views/ride/chose_ride/chose_ride_viewmodel.dart';
import 'package:pickup_parent/ui/widgets/app_bar_widget.dart';
import 'package:pickup_parent/ui/widgets/ride/available_vehicle_list.dart';
import 'package:pickup_parent/ui/widgets/ride/available_vehicle_shimmer_list.dart';
import 'package:pickup_parent/ui/widgets/ride/vehicle_types_list.dart';
import 'package:stacked/stacked.dart';
import 'package:get/get.dart';

class ChoseRideView extends StatefulWidget {
  final List<Child> selectedChild;

  ChoseRideView({super.key, required this.selectedChild});

  @override
  State<ChoseRideView> createState() => _ChoseRideViewState();
}

class _ChoseRideViewState extends State<ChoseRideView> {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final mediaW = MediaQuery.of(context).size.width;
    final mediaH = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return ViewModelBuilder<ChoseRideViewModel>.reactive(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: AppBarWidget(
              title: choseRideKey.tr,
              titleStyle: textTheme.titleLarge!,
              leadingIcon: 'assets/back_arrow_light.svg',
              leadingIconOnTap: () => Get.back(),
              actionIcon: 'assets/black_bell_icon.svg',
              actonIconOnTap: () => Get.to(() => const NotificationView()),
            ),
          ),
          body: (viewModel.isDataLoad)
              ? NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) => [
                        SliverToBoxAdapter(
                            child: VehicleTypesListWidget(
                          vehicleTypesList: viewModel.vehicleTypesOptions,
                          selectedIndex: viewModel.selectedIndex,
                          onTap: (index) =>
                              viewModel.filterAvailableServices(index: index),
                        ))
                      ],
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      availableCarsHeading(mediaH, textTheme, theme,viewModel.selectedVehicleTypeName!),
                      AvailableVehicleListWidget(
                          availableVehiclesList:
                              viewModel.availableVehiclesList,
                          onTap: (driver) =>
                              viewModel.availableVehicleOnTap(driver))
                    ],
                  ))
              : AvailableVehicleShimmerList(),
        );
      },
      viewModelBuilder: () => locator<ChoseRideViewModel>(),
      disposeViewModel: false,
      onViewModelReady: (viewModel) => SchedulerBinding.instance
          .addPostFrameCallback(
              (_) => viewModel.initialise(selectedChild: widget.selectedChild)),
    );
  }

  Widget availableCarsHeading(
      double mediaH, TextTheme textTheme, ThemeData theme,String vehicleTypeName) {
    return Container(
      height: 60,
      color: theme.scaffoldBackgroundColor,
      //margin: EdgeInsets.only(bottom: 40),
      padding: const EdgeInsetsDirectional.only(start: 20, bottom: 20, top: 20),
      child: Text(
        '${availableCarsKey.tr} ${vehicleTypeName}',
        style: textTheme.displayMedium!.copyWith(fontSize: 20),
      ),
    );
  }
}
