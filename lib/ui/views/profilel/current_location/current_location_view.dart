import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
// import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pickup_parent/src/theme/base_theme.dart';
import 'package:pickup_parent/ui/views/profilel/current_location/current_location_viewmodel.dart';
import 'package:pickup_parent/ui/widgets/app_bar_widget.dart';
import 'package:pickup_parent/ui/widgets/button_widget.dart';
import 'package:pickup_parent/ui/widgets/loading_widget.dart';
import 'package:stacked/stacked.dart';

class CurrentLocationView extends StatefulWidget {
  final Function(String address, double lat, double lng) userCurrentLocation;

  const CurrentLocationView({super.key, required this.userCurrentLocation});

  @override
  State<CurrentLocationView> createState() => _CurrentLocationViewState();
}

class _CurrentLocationViewState extends State<CurrentLocationView> {
  late GoogleMapController mapController; //contrller for Google map
  Completer<GoogleMapController> _completer = Completer();
  LatLng showLocation = const LatLng(31.5233, 74.3485);
  LatLng? currentLatLng;
  final Set<Marker> markers = new Set();
  final CameraPosition cameraPosition =
      CameraPosition(target: LatLng(31.5233, 74.3485), zoom: 16.4746);
  BitmapDescriptor bitmapImage = BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    _createMarkerImageFromAsset();
    getCurrentLocation();
    super.initState();
  }

  void _createMarkerImageFromAsset() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), "assets/marker.png")
        .then(
      (icon) {
        setState(() {
          bitmapImage = icon;
        });
      },
    );
  }


  getCurrentLocation() async{
    bool locationPermission = await Permission.location.isPermanentlyDenied;
    print('get current location of user   ${locationPermission}');
    if(locationPermission){
      CustomDialog.showInfoDialog(context: context, infoText: 'To continue, please enable location from settings.', showSecondBtn: true,secondBtnText: "Go to settings",onTapBtn: () async {
        Get.back();
        Get.back();
        await openAppSettings();
      },);
    }
    Geolocator.requestPermission()
        .then((value) async {
    }).onError((error, stackTrace) async {
      // await Geolocator.requestPermission();
      print('error in fetching location' + error.toString());
    }).catchError((err){
      print('error in catch block of permission' + err.toString());
    });
    Geolocator.getCurrentPosition().then((value) async {
      currentLatLng = LatLng(value.latitude, value.longitude);
      showLocation = LatLng(value.latitude, value.longitude);
      print('user current location is' +
          value.latitude.toString() +
          "" +
          value.longitude.toString());

      markers.add(
        Marker(
          markerId: MarkerId('2'),
          position: LatLng(value.latitude, value.longitude),
          icon: bitmapImage!,
        ),
      );
    });
  }

  Future<void> fetchCurrentLocation(GoogleMapController cntlr) async {
    print('current location');
    if (markers.isNotEmpty) {
      markers.clear();
    }
    setState(() async {
      mapController = cntlr;
      await Geolocator.requestPermission()
          .then((value) {})
          .onError((error, stackTrace) async {
        await Geolocator.requestPermission();
        print('error in fetching location' + error.toString());
      });
      Geolocator.getCurrentPosition().then((value) async {
        currentLatLng = LatLng(value.latitude, value.longitude);

        markers.add(
          Marker(
            markerId: MarkerId('current location marker'),
            position: LatLng(value.latitude, value.longitude),
            icon: bitmapImage!,
          ),
        );
        setState(() {
          //btnDisplay = true;
        });

        CameraPosition cameraPosition = new CameraPosition(
            target: LatLng(value.latitude, value.longitude), zoom: 15);
        //final GoogleMapController controller = mapController;
        mapController!
            .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaW = MediaQuery.of(context).size.width;
    final mediaH = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return ViewModelBuilder<CurrentLocationViewModel>.reactive(
      builder: (context, viewModel, child) {
        return SafeArea(
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: AppBarWidget(
                title: '',
                titleStyle: textTheme.titleLarge!,
                leadingIcon: 'assets/back_arrow_light.svg',
                leadingIconOnTap: () => Get.back(),
                bgColor: Colors.transparent,
                actions: [
                  InkWell(
                    onTap: () {
                      print('current location icon');
                      fetchCurrentLocation(mapController);
                    },
                    child: Center(
                      child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              color: Color(0xffFCEFDB),
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Icon(Icons.pin_drop,
                                color: Colors.black, size: 20),
                          )),
                    ),
                  ),
                ],
              ),
            ),
            extendBodyBehindAppBar: true,
            body: Stack(
              children: [
                GoogleMap(
                  markers: markers,
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: false,
                  myLocationEnabled: false,
                  onMapCreated: fetchCurrentLocation,
                  initialCameraPosition: cameraPosition,
                  onTap: (LatLng latlng) {
                    markers.clear();
                    currentLatLng = LatLng(latlng.latitude, latlng.longitude);
                    markers.add(Marker(
                        markerId: MarkerId('current location marker'),
                        position: LatLng(latlng.latitude, latlng.longitude),
                        icon: bitmapImage!));
                    setState(() {});
                  },
                ),
                Positioned(
                    left: 0,
                    bottom: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(
                          start: 30, end: 30, bottom: 30),
                      child: ButtonWidget(
                        btnText: 'Done',
                        radius: 76,
                        bgColor: theme.primaryColor,
                        textStyle: textTheme.titleLarge,
                        onTap: () async {
                          await viewModel
                              .autoCompletePlaces(latLng: currentLatLng!)
                              .then((_) {
                            print('location address is ${viewModel.address}');
                            widget.userCurrentLocation(
                                viewModel.address!,
                                currentLatLng!.latitude,
                                currentLatLng!.longitude);
                          }).onError((error, stackTrace) {
                            print('location address error error ${error}');
                          });
                        },
                      ),
                    ))
              ],
            ),
          ),
        );
      },
      viewModelBuilder: () => CurrentLocationViewModel(),
      onViewModelReady: (model) => SchedulerBinding.instance
          .addPostFrameCallback((_) => model.initialize()),
    );
  }
}
