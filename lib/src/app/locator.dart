import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:pickup_parent/services/auth_service.dart';
import 'package:pickup_parent/services/history_service.dart';
import 'package:pickup_parent/services/home_service.dart';
import 'package:pickup_parent/services/notification_service.dart';
import 'package:pickup_parent/services/profile_service.dart';
import 'package:pickup_parent/services/route_services.dart';
import 'package:pickup_parent/services/shared_preference.dart';
import 'package:pickup_parent/services/vehical_service.dart';
import 'package:pickup_parent/ui/views/bottom_bar/bottom_bar_viewmodel.dart';
import 'package:pickup_parent/ui/views/profilel/parent_profile/parent_profile_viewmodel.dart';
import 'package:pickup_parent/ui/views/ride/chose_ride/chose_ride_viewmodel.dart';
import 'package:pickup_parent/ui/views/tracking/vehicle_tracking_viewmodel.dart';

//import 'package:pickup/ui/views/auth/signin/signup_viewmodel.dart';


final locator = GetIt.instance;

@injectableInit
Future<void> setupLocator() async {
  await SharedPreferencesService().init();
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => ProfileService());
  locator.registerLazySingleton(() => HomeService());
  // locator.registerLazySingleton(() => VehicleTrackingViewModel());
  locator.registerLazySingleton(() => ParentProfileViewModel());
  locator.registerLazySingleton(() => NotificationService());
  locator.registerLazySingleton(() => VehicleService());
  locator.registerLazySingleton(() => ChoseRideViewModel());
  locator.registerLazySingleton(() => RoutesServices());
  locator.registerLazySingleton(() => HistoryService());

  /// ViewModel register
  //locator.registerSingleton<BottomBarViewModel>(BottomBarViewModel());
  //locator.registerSingleton<SignUpViewModel>(SignUpViewModel());
  //locator.registerSingleton<BottomBarViewModel>(BottomBarViewModel());
}
