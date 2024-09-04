import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pickup_parent/models/all_subscriptions_model.dart';
import 'package:pickup_parent/models/fetch_route_details_model.dart';
import 'package:pickup_parent/models/user_firebase_model.dart';
import 'package:pickup_parent/services/common_ui_service.dart';
import 'package:pickup_parent/services/firebase_serivce.dart';
import 'package:pickup_parent/services/route_services.dart';
import 'package:pickup_parent/src/app/apiErrorsMessage.dart';
import 'package:pickup_parent/src/app/constants/constants.dart';
import 'package:pickup_parent/src/app/enum/enum.dart';
import 'package:pickup_parent/src/app/locator.dart';
import 'package:pickup_parent/src/app/static_info.dart';
import 'package:pickup_parent/src/language/language_keys.dart';
import 'package:pickup_parent/ui/views/subscription/subscription_viewmodel.dart';
import 'package:pickup_parent/ui/widgets/loading_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;
import 'package:pickup_parent/models/routes_response_model.dart' as model;
import 'package:url_launcher/url_launcher.dart';

class VehicleTrackingViewModel extends BaseViewModel with CommonUiService {
  // RideShiftZone? shiftZone;
  int? driverId;
  bool isRouteGenerated = false;
  FetchRouteDetailsModel? fetchRouteDetailsModel;
  RideStatusModel? rideStatusModel;
  RoutesServices routesServices = locator<RoutesServices>();
  SubscriptionViewModel subscriptionViewModel = SubscriptionViewModel();
  final LatLng initialCameraPosition = LatLng(31.5233, 74.3485);
  CameraPosition cameraPosition =
      CameraPosition(target: LatLng(31.5233, 74.3485), zoom: 16.4746);
  final Completer<GoogleMapController> completer = Completer();
  GoogleMapController? _controller;
  ScrollController scrollController = ScrollController();
  StreamSubscription<UserFirebaseModel>? firebaseUserStream;
  StreamSubscription<RideStatusModel>? firebaseRideStatusStream;
  List<ChildElement> childrenList = [];
  Driver? driver;
  List<FetchRouteDetailsModel> childList = [];
  List<PointLatLng> routePolyline = [];
  final List<LatLng> polylineCoordinates = [];
  final List<Polyline> polyLines = [];
  Set<Marker> markers = {};
  Map<MarkerId, Marker> carMarker = <MarkerId, Marker>{};
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor carMarkerIcon = BitmapDescriptor.defaultMarker;
  Timer? timer;

  final int countdownInSeconds = 1;
  String timeToDisplay = '';
  String textToDisplayOnTimerUi = '';

  initialise({
    required bool isComingFromNotification,
    int? quotationId,
    DateTime? dateTimeOfArrivedDriver,
    List<ChildElement>? children,
    int? driverId,
    Driver? driverData,
  }) async {
    if (isComingFromNotification) {
      fetchSubscription(
          quotationId: quotationId ?? -1,
          dateTimeOfArrivedDriver: dateTimeOfArrivedDriver);
    } else {
      driver = driverData;
      _createMarkerImageFromAsset();
      childData(children ?? []);
      getFirebaseRideStatus(firebaseUSerID: driver?.driverFirebaseId ?? '');
      fetchDataForRoute(
          driverId: driverId ?? -1,
          driverFirebaseId: driver?.driverFirebaseId ?? '');
    }
  }

  void startTimer({
    required int initialTimerTime,
    bool? startTimerFromZero,
  }) {
    // DateTime currentTime = DateTime.now();
    // DateTime driverArrivedTime = driverTime;
    // int initialTime = driverArrivedTime.difference(currentTime).inSeconds;
    // int initialTime = currentTime.difference(driverArrivedTime).inSeconds;
    // print('=============================> time diff $initialTime');
    // if(initialTime < 300){
    int initialTimeInSeconds = initialTimerTime;

    timer = Timer.periodic(Duration(seconds: countdownInSeconds), (timer) {
      if (startTimerFromZero!) {
        if (initialTimeInSeconds <= 299) {
          initialTimeInSeconds += countdownInSeconds;
          timeToDisplay = formatTime(initialTimeInSeconds);
          notifyListeners();
        } else {
          timer.cancel();
          timeToDisplay = '';
          notifyListeners();
        }
      } else {
        print('========================> start from 5');
        if (initialTimeInSeconds >= 0) {
          initialTimeInSeconds -= countdownInSeconds;
          timeToDisplay = formatTime(initialTimeInSeconds);
          notifyListeners();
        } else {
          timer.cancel();
          timeToDisplay = '';
          notifyListeners();
        }
      }
    });
    // }
  }

  String formatTime(int timeInSeconds) {
    Duration duration = Duration(seconds: timeInSeconds);
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  void _createMarkerImageFromAsset() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), "assets/marker.png")
        .then(
      (icon) {
        markerIcon = icon;
      },
    );

    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), "assets/car_marker_icon.png")
        .then(
      (icon) {
        carMarkerIcon = icon;
      },
    );
  }

  /// fetch all subscription data if come from notification click
  Future fetchSubscription(
      {required int quotationId, DateTime? dateTimeOfArrivedDriver}) async {
    await subscriptionViewModel.fetchAllSubscriptions();
    int? index = subscriptionViewModel.allSubscriptionsModel?.subscriptionData
        ?.indexWhere((element) => element.id == quotationId);
    var data = subscriptionViewModel.allSubscriptionsModel?.subscriptionData?[index!];
    driver = data?.driver;
    _createMarkerImageFromAsset();
    childData(data?.children ?? []);
    getFirebaseRideStatus(firebaseUSerID: driver?.driverFirebaseId ?? '');
    fetchDataForRoute(
        driverId: data?.driverId ?? -1,
        driverFirebaseId: driver?.driverFirebaseId ?? '');
  }

  Future fetchDataForRoute(
      {required int driverId, required String driverFirebaseId}) async {
    CustomDialog.showLoadingDialog(Get.context!);
    bool connectivity = await check();
    if (connectivity) {
      http.Response response = await routesServices.fetchDataForRoute(driverId);
      if (response.statusCode == 200) {
        var decodedResponse = json.decode(response.body);
        if (decodedResponse["success"]) {
          fetchRouteDetailsModel =
              FetchRouteDetailsModel.fromJson(decodedResponse);
          await fetchDriverRideStatusDoc(driverId: driverFirebaseId);
          await fetchRoutes();
          notifyListeners();
          Get.back();
        } else {
          Get.back();
          showCustomWarningTextToast(
              context: Get.context!, text: decodedResponse["message"]);
        }
      } else {
        ApiErrorsMessage().showApiErrorsMessage(response.statusCode);
      }
    } else {
      Get.back();
      showCustomWarningTextToast(
          context: Get.context!, text: checkInternetKey.tr);
    }
  }

  Future fetchRoutes() async {
    String? isUserAvailable =
        await FirebaseServices.checkUserInDB(driver?.driverFirebaseId ?? "");
    if (isUserAvailable != null) {
      UserFirebaseModel value =
          await FirebaseServices.fetchRoute(driver!.driverFirebaseId!);
      var decodedResponse;
      if (rideStatusModel?.morningRideStatus == RideStatus.started) {
        decodedResponse = jsonDecode(value.morningShift!);
        model.RoutesResponseModel responseModel =
            model.RoutesResponseModel.fromJson(decodedResponse);
        StaticInfo.routesResponseModel = responseModel;
        await decodeRoutePolyline();
      } else if (rideStatusModel?.eveningRideStatus == RideStatus.started) {
        decodedResponse = jsonDecode(value.eveningShift!);
        model.RoutesResponseModel responseModel =
            model.RoutesResponseModel.fromJson(decodedResponse);
        StaticInfo.routesResponseModel = responseModel;
        await decodeRoutePolyline();
      }
    } else {
      showCustomWarningTextToast(
          context: Get.context!, text: 'Route not available');
      Get.back();
    }
  }

  Future<void> decodeRoutePolyline() async {
    model.RoutesResponseModel responseModel = StaticInfo.routesResponseModel!;
    PolylinePoints polylinePoints = PolylinePoints();
    String encodePolyline = responseModel.encodedPolyline ?? '';
    routePolyline = await polylinePoints.decodePolyline(encodePolyline);
    List<int> locationOrder =
        responseModel.optimizedIntermediateWaypointIndex ?? [];
    List<ChildDetail> dumyList = [];
    if(locationOrder.length > 1){
      dumyList.addAll(fetchRouteDetailsModel!.data!);
      for (int i = 0; i < fetchRouteDetailsModel!.data!.length; i++) {
        dumyList[locationOrder[i]] = fetchRouteDetailsModel!.data![i];
      }
      fetchRouteDetailsModel?.data?.clear();
      fetchRouteDetailsModel?.data?.addAll(dumyList);
    }
    addMarker();
    getPolyline();
  }

  void addMarker() {
    carMarker[MarkerId('${StaticInfo.userModel!.data.user.id}')] = Marker(
      rotation: 270,
      markerId: MarkerId('${StaticInfo.userModel!.data.user.id}'),
      position: LatLng(
        double.parse(childrenList[0].child?.pickUpLat ?? '0.0'),
        double.parse(childrenList[0].child?.pickUpLong ?? '0.0'),
      ),
      icon: carMarkerIcon,
    );

    markers.clear();
    for (int i = 0; i < fetchRouteDetailsModel!.data!.length; i++) {
      markers.add(
        Marker(
          markerId: MarkerId(
            '${fetchRouteDetailsModel!.data![i].child?.name}${fetchRouteDetailsModel!.data![i].child?.pickUpLat}',
          ),
          position: LatLng(
              double.parse(fetchRouteDetailsModel!.data![i].child?.pickUpLat ?? '0'),
              double.parse(fetchRouteDetailsModel!.data![i].child?.pickUpLong ?? '0')),
          icon: markerIcon,
          infoWindow: InfoWindow(
            title: fetchRouteDetailsModel!.data![i].child?.name,
            snippet: fetchRouteDetailsModel!.data![i].child?.name,
          ),
        ),
      );
    }
    markers.add(
      Marker(
        markerId: MarkerId('${fetchRouteDetailsModel?.data?[0].child?.dropOffLat}'),
        position: LatLng(
            double.parse(fetchRouteDetailsModel!.data![0].child?.dropOffLat ?? '0'),
            double.parse(fetchRouteDetailsModel!.data![0].child?.dropOffLong ?? '0')),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );
    notifyListeners();
  }

  void getPolyline() async {
    routePolyline.forEach(
      (PointLatLng point) {
        polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        );
      },
    );

    routePolyline.forEach(
      (PointLatLng point) {
        polyLines.add(
          Polyline(
            polylineId: PolylineId('polyLinePoint${point.latitude}'),
            color: Theme.of(Get.context!).primaryColor,
            width: 4,
            points: polylineCoordinates,
          ),
        );
      },
    );
    getFirebaseUser(firebaseUSerID: driver!.driverFirebaseId!);
  }

  Future<void> getFirebaseUser({required String firebaseUSerID}) async {
    String? isUserAvailable =
        await FirebaseServices.checkUserInDB(firebaseUSerID);
    if (isUserAvailable != null) {
      var value = FirebaseServices.fetchUserData(firebaseUSerID);
      if (firebaseUserStream == null) {
        value.listen((event) async {
          /// update car marker on location update
          carMarker[MarkerId('${StaticInfo.userModel!.data.user.id}')] = Marker(
            rotation: event.heading ?? 270,
            markerId: MarkerId('${StaticInfo.userModel!.data.user.id}'),
            position:
                LatLng(event.location!.latitude, event.location!.longitude),
            icon: carMarkerIcon,
          );
          notifyListeners();
        });
        notifyListeners();
      }
    } else {
      debugPrint("user not found in firebase");
      Get.back();
      showCustomWarningTextToast(
          context: Get.context!, text: 'Driver live location not available');
    }
  }

  Future<void> getFirebaseRideStatus({required String firebaseUSerID}) async {
    String? isUserAvailable =
        await FirebaseServices.checkUserInDB(firebaseUSerID);
    bool isTimerTimeFetched = false;
    if (isUserAvailable != null) {
      String? rideStatusFirebaseDocId =
          await FirebaseServices.getRideStatusDocId(firebaseUSerID);
      if (rideStatusFirebaseDocId != null) {
        var value =
            FirebaseServices.fetchRideStatusStream(rideStatusFirebaseDocId);
        if (firebaseRideStatusStream == null) {
          value?.listen((event) {
            int? index = event?.childList
                ?.indexWhere((element){
                  // print('================ id id di di did id ${element.id}     ${childrenList[0].child!.id}');
                  return element.id == childrenList[0].child!.id;
            });
            print('================= idddddddddddddddddddddddddddd $index');
            if (event?.childList?[index!].arrivalStatus ==
                ArrivalStatus.arrival_soon) {
              /// first cancel the timer if timer is already active
              if (timer != null) {
                if (timer!.isActive) {
                  timer!.cancel();
                }
              }
              textToDisplayOnTimerUi = 'your driver will arrive in';
              startTimer(initialTimerTime: 300, startTimerFromZero: false);
            } else if (event?.childList?[index!].arrivalStatus ==
                ArrivalStatus.arrived) {
              /// first cancel the timer if timer is already active
              if (timer != null) {
                if (timer!.isActive) {
                  timer!.cancel();
                }
              }
              if (!isTimerTimeFetched) {
                isTimerTimeFetched = true;
                textToDisplayOnTimerUi = 'Your driver has arrived';
                startTimer(
                    initialTimerTime:
                        event!.childList![index!].reamingTimerTimeInSeconds!,
                    startTimerFromZero: true);
              }
            }
            if (event?.childList?[index!].arrivalStatus !=
                    ArrivalStatus.arrived &&
                event?.childList?[index!].arrivalStatus !=
                    ArrivalStatus.arrival_soon) {
              if (timer != null) {
                if (timer!.isActive) {
                  timer!.cancel();
                  timeToDisplay = '';
                  notifyListeners();
                }
              }
            }
          });
          notifyListeners();
        }
      }
    } else {
      debugPrint("user not found in firebase");
      Get.back();
      showCustomWarningTextToast(
          context: Get.context!, text: 'Driver live location not available');
    }
  }

  Future<void> fetchDriverRideStatusDoc({required String driverId}) async {
    String? driverFirebaseID =
        await FirebaseServices.checkUserInDB(driverId ?? "");
    if (driverFirebaseID != null) {
      rideStatusModel =
          await FirebaseServices.getRideStatusDoc(driverFirebaseID);
      if (rideStatusModel == null) {}
      debugPrint("driver ride status is ${rideStatusModel?.toJson()}");
    } else {
      debugPrint("Driver not found in firebase");
    }
    notifyListeners();
  }

  Future<void>childNotGoingToSchool({required int index,required int childId, required BuildContext context,required int quotationId})async{
    CustomDialog.showLoadingDialog(context);
    bool connectivity = await check();
    if (connectivity) {
      try {
        http.Response response =
        await routesServices.childNotGoingToSchool(childId: childId,quotationId: quotationId);
        if (response.statusCode == 200) {
          var decodedResponse = json.decode(response.body);
          if (decodedResponse["success"]) {
            childrenList[index].rideStatus = ArrivalStatus.not_going;
            Get.back();
            notifyListeners();
          } else {
            showCustomWarningTextToast(
                context: Get.context!, text: decodedResponse["message"]);
          }
        } else {
          ApiErrorsMessage().showApiErrorsMessage(response.statusCode);
        }
      } on SocketException {
        showCustomWarningTextToast(
            context: Get.context!, text: "Socket Exception");
      } catch (e) {}
    } else {
      showCustomWarningTextToast(
          context: Get.context!, text: checkInternetKey.tr);
    }
  }

  Future<void> makePhoneCall(String url, bool isSms) async {
    final call = Uri.parse(isSms ? 'sms:$url' : 'tel:$url');
    if (await canLaunchUrl(call)) {
      await launchUrl(call);
    } else {
      throw 'Could not launch $url';
    }
  }

  void disposeFirebaseUserStream() {
    firebaseUserStream?.cancel();
    firebaseUserStream = null;
  }

  void disposeFirebaseRideStatusStream() {
    firebaseRideStatusStream?.cancel();
    firebaseRideStatusStream = null;
  }

  void childData(List<ChildElement> children) async {
    childrenList.addAll(children);

    notifyListeners();
  }

  void checkShiftTime() async {
  DateTime morningStartTime =
      DateTime.parse(childrenList[0].child!.startTime.toString());
  DateTime eveningStartTime = DateTime.parse(childrenList[0].child!.endTime.toString());
  DateTime currentTime = DateTime.now();
  // DateTime currentTime = DateTime.parse('2023-11-14 13:00:41.240771');
  var shiftZone;
  /// Define pickup time range
  DateTime pickupStartTime = DateTime(
      currentTime.year,
      currentTime.month,
      currentTime.day,
      morningStartTime.hour - 1,
      morningStartTime.minute,
      morningStartTime.second);
  DateTime pickupEndTime = DateTime(
      currentTime.year,
      currentTime.month,
      currentTime.day,
      morningStartTime.hour + 1,
      morningStartTime.minute,
      morningStartTime.second);

  /// Define drop off time range
  DateTime dropOffStartTime = DateTime(
      currentTime.year,
      currentTime.month,
      currentTime.day,
      eveningStartTime.hour - 1,
      eveningStartTime.minute,
      eveningStartTime.second);
  DateTime dropOffEndTime = DateTime(
      currentTime.year,
      currentTime.month,
      currentTime.day,
      eveningStartTime.hour + 1,
      eveningStartTime.minute,
      eveningStartTime.second);

  RideShiftType status = RideShiftType.morning;

  /// Check if the current time is within pickup time range
  if (currentTime.isAfter(pickupStartTime) &&
      currentTime.isBefore(pickupEndTime)) {
    print('morning morning ${status.runtimeType}');
     shiftZone = RideShiftType.morning;
  } else if (currentTime.isAfter(dropOffStartTime) &&
      currentTime.isBefore(dropOffEndTime)) {
    print('evening evening evening ${status.name}');
    shiftZone = RideShiftType.evening;
  } else {
    shiftZone = RideShiftType.not_available;
    print(
        'time is over ${status.runtimeType}    ${status == RideShiftType.morning}');
  }
  notifyListeners();
}


  @override
  void dispose() {
    super.dispose();
    disposeFirebaseUserStream();
    disposeFirebaseRideStatusStream();
  }

}

/// this method may be used is future for getting shift zone
// void checkShiftTime() async {
//   DateTime morningStartTime =
//       DateTime.parse(childrenList[0].start.toString());
//   DateTime eveningStartTime = DateTime.parse(childrenList[0].end.toString());
//   DateTime currentTime = DateTime.now();
//   // DateTime currentTime = DateTime.parse('2023-11-14 13:00:41.240771');
//
//   /// Define pickup time range
//   DateTime pickupStartTime = DateTime(
//       currentTime.year,
//       currentTime.month,
//       currentTime.day,
//       morningStartTime.hour - 1,
//       morningStartTime.minute,
//       morningStartTime.second);
//   DateTime pickupEndTime = DateTime(
//       currentTime.year,
//       currentTime.month,
//       currentTime.day,
//       morningStartTime.hour + 1,
//       morningStartTime.minute,
//       morningStartTime.second);
//
//   /// Define drop off time range
//   DateTime dropOffStartTime = DateTime(
//       currentTime.year,
//       currentTime.month,
//       currentTime.day,
//       eveningStartTime.hour - 1,
//       eveningStartTime.minute,
//       eveningStartTime.second);
//   DateTime dropOffEndTime = DateTime(
//       currentTime.year,
//       currentTime.month,
//       currentTime.day,
//       eveningStartTime.hour + 1,
//       eveningStartTime.minute,
//       eveningStartTime.second);
//
//   RideShiftZone status = RideShiftZone.morning;
//
//   /// Check if the current time is within pickup time range
//   if (currentTime.isAfter(pickupStartTime) &&
//       currentTime.isBefore(pickupEndTime)) {
//     print('morning morning ${status.runtimeType}');
//     shiftZone = RideShiftZone.morning;
//   } else if (currentTime.isAfter(dropOffStartTime) &&
//       currentTime.isBefore(dropOffEndTime)) {
//     print('evening evening evening ${status.name}');
//     shiftZone = RideShiftZone.evening;
//   } else {
//     shiftZone = RideShiftZone.end;
//     print(
//         'time is over ${status.runtimeType}    ${status == RideShiftZone.morning}');
//   }
//   notifyListeners();
// }

