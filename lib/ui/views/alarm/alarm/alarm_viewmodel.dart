import 'dart:async';
import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pickup_parent/ui/views/alarm/alarm_edit/alarm_edit_screen_view.dart';
import 'package:pickup_parent/ui/views/alarm/alarm_ring/alarm_ring_screen_view.dart';
import 'package:stacked/stacked.dart';

class AlarmViewModel extends BaseViewModel {
  List<AlarmSettings>? alarms;
  bool isDataLoading = true;

  static StreamSubscription? subscription;

  initialise() {
    loadAlarms();
    subscription ??=
        Alarm.ringStream.stream.listen(
      (alarmSettings) => navigateToRingScreen(alarmSettings),
    );
    isDataLoading = false;
    notifyListeners();
  }

  void loadAlarms() {
    alarms = Alarm.getAlarms();
    alarms!.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
    notifyListeners();
  }

  Future<void> navigateToRingScreen(AlarmSettings alarmSettings) async {
    print('alarm ringinggggggggggggggggggggggggggggggggg');
    await Navigator.push(
        Get.context!,
        MaterialPageRoute(
          builder: (context) =>
              AlarmRingScreenView(alarmSettings: alarmSettings),
        ));
    // loadAlarms();
  }

  Future<void> navigateToAlarmScreen(AlarmSettings? settings) async {
    final res = await showModalBottomSheet<bool?>(
        context: Get.context!,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        builder: (context) {
          return AlarmEditScreenView(alarmSettings: settings);
        });

    if (res != null && res == true) loadAlarms();
    notifyListeners();
  }

  @override
  void dispose() {
    //subscription?.cancel();
    super.dispose();
  }
}
