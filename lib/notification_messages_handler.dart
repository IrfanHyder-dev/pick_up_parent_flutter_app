import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:pickup_parent/src/app/locator.dart';
import 'package:pickup_parent/ui/views/bottom_bar/bottom_bar_view.dart';
import 'package:pickup_parent/ui/views/bottom_bar/bottom_bar_viewmodel.dart';
import 'package:pickup_parent/ui/views/tracking/vehicle_tracking_view.dart';

class NotificationMessagesHandler {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  void initialize() {
    print("notifications setup");
    onForegroundNotificationReceive();
    tapOnNotifications();
    onKillApp();
  }

  void onForegroundNotificationReceive() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      showBadge: true,
      //'This channel is used for important notifications.', // description
      importance: Importance.max,
    );
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/notification_icon');
    //var initializationSettingsAndroid = const AndroidInitializationSettings('notification_icon');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      //onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );
    var initializationSettings = new InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onForeGroundNotificationTap);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(
          'Just received a notification when app is in use   ${message.data}');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      Map<String, dynamic>? notificationData = message.data;

      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            payload: jsonEncode(notificationData),
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelShowBadge: channel.showBadge,
                icon: android.smallIcon,
                priority: Priority.high,
                importance: Importance.max,
              ),
            ));
      }
    });
  }

  void tapOnNotifications() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Just received a notification when app is opened ${message.data}');
      print(
          'Just received a notification when app is opened ${message.notification!.body}');
      //Get.to(()=> BottomBarView(pageIndex: 0,));
      actionToBePerformOnClick(message.data['view'], message);
    });
  }

  void actionToBePerformOnClick(String val, RemoteMessage message) {
    print(
        '=======================> action perform on notification click <======================= ${message.data['quotation_id']}  ${message.data['time']}');

    switch (val) {
      case 'subscriptionScreen':
        {
          /// this code will be used for navigation
          //PageController pageController1 = PageController(initialPage: 1);
          //BottomBarViewModel  bottomBarViewModel = locator<BottomBarViewModel>();
          //bottomBarViewModel.init(1);
          //  locator.resetLazySingleton<BottomBarViewModel>();

          //   bottomBarViewModel.setPageValue(1);
          // Get.offAll(()=> BottomBarView(index: 1,));
          //bottomBarViewModel.newPageNo(1);
          // BottomBarViewModel bottomBarViewModel =
          // locator<BottomBarViewModel>();
          // bottomBarViewModel.pageController?.jumpTo(4);
          //bottomBarViewModel.pageIndex = 1;
          // locator<BottomBarViewModel>();
          // bottomBarViewModel.pageIndex = 1;
        }
        break;
      case 'mapScreen':
        {
          if (message.data['quotation_id'] != null) {
            var isTimeKeyPresent = message.data.keys.contains('time');
            print(
                '===================================> time key  $isTimeKeyPresent');
            Get.to(
              () => VehicleTrackingView(
                isComingFromNotification: true,
                quotationId: int.parse(message.data['quotation_id'].toString()),
                dateTimeOfArrivedDriver: (isTimeKeyPresent)
                    ? DateTime.parse(message.data['time'].toString())
                    : null,
              ),
            );
          }
        }
        break;
    }
  }

  void onKillApp() {
    FirebaseMessaging.instance.getInitialMessage().then(
          (message) {
        if (kDebugMode) {
          print(
              "FirebaseMessaging.instance.getInitialMessage [APP TERMINATED] ${message?.notification?.title}");
        }

        if (message != null) {
          actionToBePerformOnClick(message.data['view'], message);
        }
      },
    );
  }

  void onForeGroundNotificationTap(NotificationResponse data) {
    print(
        '=====================>onForeGroundNotificationTap   ${data.payload}<=====================');
    var decodedData = json.decode(data.payload!);
    print(
        '=====================>onForeGroundNotificationTap   ${decodedData['view']}      ${decodedData}<=====================');
    actionToBePerformOnClick(decodedData['view'], decodedData);
    // switch(decodedData['view']){
    //   case 'driver approval':{
    //       homeViewModel.profileApprovalStatus();
    //   }break;
    // }
  }
}
