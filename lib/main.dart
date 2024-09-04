import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:pickup_parent/notification_messages_handler.dart';
import 'package:pickup_parent/src/app/locator.dart';
import 'package:pickup_parent/src/app/static_info.dart';
import 'package:pickup_parent/src/language/languages.dart';
import 'package:pickup_parent/src/language/locales.dart';
import 'package:alarm/alarm.dart';
import 'package:pickup_parent/src/theme/theme.dart';
import 'package:pickup_parent/ui/views/splash/splash_view.dart';
import 'package:pickup_parent/ui/widgets/pop_scope_dialog_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  // FlutterError.onError = (errorDetails) {
  //   FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  // };
  // // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  // PlatformDispatcher.instance.onError = (error, stack) {
  //   FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  //   return true;
  // };
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  fcmToken();
  await Alarm.init(showDebugLogs: true);
  runApp(const MyApp());
}

Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

void fcmToken() async {
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );
  NotificationMessagesHandler().initialize();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  String? token = await FirebaseMessaging.instance.getToken();
  print('fcm token is $token');
  StaticInfo.fcmToken = token;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool? shouldPop = await showDialog<bool>(
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
      child: GetMaterialApp(
        //title: appNameKey.tr,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.getTheme(),
        translations: Languages(),
        locale: engLocale,
        fallbackLocale: engLocale,
        supportedLocales: const [
          engLocale,
          urLocale,
        ],
        localizationsDelegates: const [
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        // home:  FlutterMapMarkerAnimationRealTimeExample(),
        //  home:  DummyList(),
         home: const SplashView(),
      ),
    );
  }
}
