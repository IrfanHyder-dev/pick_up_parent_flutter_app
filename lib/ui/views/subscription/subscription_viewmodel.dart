import 'dart:convert';

import 'package:get/get.dart';
import 'package:pickup_parent/models/all_subscriptions_model.dart';
import 'package:pickup_parent/models/user_firebase_model.dart';
import 'package:pickup_parent/services/common_ui_service.dart';
import 'package:pickup_parent/services/vehical_service.dart';
import 'package:pickup_parent/src/app/apiErrorsMessage.dart';
import 'package:pickup_parent/src/app/constants/constants.dart';
import 'package:pickup_parent/src/app/enum/enum.dart';
import 'package:pickup_parent/src/app/locator.dart';
import 'package:pickup_parent/src/language/language_keys.dart';
import 'package:pickup_parent/ui/views/ride/subscription_detail/subscription_detail_view.dart';
import 'package:pickup_parent/ui/views/tracking/vehicle_tracking_view.dart';
import 'package:pickup_parent/ui/views/tracking/vehicle_tracking_viewmodel.dart';
import 'package:pickup_parent/ui/widgets/loading_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

class SubscriptionViewModel extends ReactiveViewModel with CommonUiService {
  VehicleService vehicleService = locator<VehicleService>();
  bool isDataLoad = false;
  AllSubscriptionsModel? allSubscriptionsModel;

  initialise() {
    fetchAllSubscriptions();
  }

  Future fetchAllSubscriptions() async {
    CustomDialog.showLoadingDialog(Get.context!);
    bool connectivity = await check();
    if (connectivity) {
      http.Response response = await vehicleService.fetchAllSubscriptions();
      Get.back();

      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        if (decodedResponse['success'] == true) {
          isDataLoad = true;
          allSubscriptionsModel =
              AllSubscriptionsModel.fromJson(decodedResponse);
          allSubscriptionsModel?.subscriptionData
              ?.removeWhere((element) => element.children!.length <= 0);
          notifyListeners();
        } else {
          Get.back();
          showCustomErrorTextToast(
              context: Get.context!, text: decodedResponse['message']);
        }
      } else {
        ApiErrorsMessage().showApiErrorsMessage(response.statusCode);
      }
    } else {
      Get.back();
      showCustomErrorTextToast(context: Get.context!, text: wentWrongkey.tr);
    }
  }

  Future cancelRequest({required int quotationId}) async {
    print('========================> cancel request $quotationId');
    CustomDialog.showLoadingDialog(Get.context!);
    bool connectivity = await check();
    if (connectivity) {
      http.Response response =
          await vehicleService.cancelRequest(quotationId: quotationId);
      Get.back();

      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        if (decodedResponse['success'] == true) {
          allSubscriptionsModel?.subscriptionData
              ?.removeWhere((element) => element.id == quotationId);
          showCustomSuccessTextToast(
              context: Get.context!, text: decodedResponse['message']);
          notifyListeners();
        } else {
          Get.back();
          showCustomSuccessTextToast(
              context: Get.context!, text: decodedResponse['message']);
        }
      } else {
        ApiErrorsMessage().showApiErrorsMessage(response.statusCode);
      }
    } else {
      Get.back();
      showCustomErrorTextToast(context: Get.context!, text: wentWrongkey.tr);
    }
  }

  void onTap({required int index}) async {
    var data = allSubscriptionsModel!.subscriptionData?[index];
    VehicleTrackingViewModel vehicleTrackingViewModel =
        VehicleTrackingViewModel();
    if (data?.paymentStatus == PaymentStatus.paid) {
      /// check if driver starts the ride then redirect user to map screen otherwise show info dialog
      CustomDialog.showLoadingDialog(Get.context!);
      allSubscriptionsModel!.subscriptionData?[index].children;
      await vehicleTrackingViewModel.fetchDriverRideStatusDoc(
          driverId: data?.driver!.driverFirebaseId ?? '');
      RideStatusModel? rideStatusModel =
          vehicleTrackingViewModel.rideStatusModel;
      Get.back();
      if (rideStatusModel != null) {
        if (rideStatusModel.morningRideStatus == RideStatus.started) {
          Get.to(
            () => VehicleTrackingView(
              children: data?.children,
              driverId: data?.driverId,
              driver: data?.driver!,
              quotationId: data?.id ?? 0,
              isComingFromNotification: false,
            ),
          );
        } else if (rideStatusModel.morningRideStatus == RideStatus.finished &&
            rideStatusModel.eveningRideStatus == RideStatus.started) {
          Get.to(
            () => VehicleTrackingView(
              children: data?.children,
              driverId: data?.driverId,
              driver: data?.driver!,
              quotationId: data?.id ?? 0,
              isComingFromNotification: false,
            ),
          );
        } else {
          print('------------------> subscription on tap else condition 1');
          CustomDialog.showRideNotStartedDialogDialog(Get.context!);
        }
      } else {
        print('------------------> subscription on tap else condition ');
        CustomDialog.showRideNotStartedDialogDialog(Get.context!);
      }
    } else if (data?.status == QuotationStatus.accept && data?.paymentStatus == PaymentStatus.pending) {
      Get.to(() => SubscriptionDetailView(
            selectedService: data?.children ?? [],
            id: data?.id ?? -1,
            distance: double.parse(data?.distance ?? '0'),
            amount: double.parse(data?.amount.toString() ?? '0'),
          ));
    }
  }

  String currentStatusOfQuotation({required int index}) {
    var data = allSubscriptionsModel?.subscriptionData?[index];
    if (data?.paymentStatus == PaymentStatus.paid) {
      return "Paid";
    } else if (data?.status == QuotationStatus.accept) {
      return 'Pay now';
    } else if (data?.status == QuotationStatus.reject) {
      return 'Rejected';
    } else {
      return 'Waiting for approval';
    }
  }
}
