/// this code will be used, commented this code for testing notification testing

// import 'package:flutter/material.dart';
// import 'package:injectable/injectable.dart';
// import 'package:pickup_parent/blank_screen.dart';
// import 'package:pickup_parent/ui/views/history/history_view.dart';
// import 'package:pickup_parent/ui/views/home/home_view.dart';
// import 'package:pickup_parent/ui/views/settings/settings_view.dart';
// import 'package:pickup_parent/ui/views/subscription/subscription_view.dart';
// import 'package:stacked/stacked.dart';
//
// @singleton
// class BottomBarViewModel extends BaseViewModel {
//   PageController? pageController = PageController(initialPage: 2);
//   int pageIndex = 2;
//   int maxCount = 5;
//   /// widget list
//
//   final List<Widget> bottomBarPages = [
//     const BlackScreen(),
//     const SubscriptionView(),
//     const HomeView(),
//     const HistoryView(),
//     const SettingsView(),
//   ];
//
//   init(int index) {
//     pageIndex = index;
//     pageController!.jumpToPage(index);
//     notifyListeners();
//   }
//
//   void onTap(v){
//     if(v != 3){
//       pageIndex = v;
//       pageController!.jumpToPage(v);
//     notifyListeners();
//     }
//   }
//   @override
//   void dispose() {
//     pageController!.dispose();
//     super.dispose();
//   }
// }