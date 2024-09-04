import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/material.dart';
import 'package:pickup_parent/ui/views/alarm/alarm_ring/alarm_ring_viewmodel.dart';
import 'package:stacked/stacked.dart';

class AlarmRingScreenView extends StatelessWidget {
  final AlarmSettings alarmSettings;

  const AlarmRingScreenView({Key? key, required this.alarmSettings})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AlarmRingViewModel>.reactive(
      builder: (context, viewModel, child) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                const Text("🔔", style: TextStyle(fontSize: 50)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    RawMaterialButton(
                      onPressed: () {
                        final now = DateTime.now();
                        Alarm.set(
                          alarmSettings: alarmSettings.copyWith(
                            dateTime: DateTime(
                              now.year,
                              now.month,
                              now.day,
                              now.hour,
                              now.minute,
                              0,
                              0,
                            ).add(const Duration(minutes: 1)),
                          ),
                        ).then((_) => Navigator.pop(context));
                      },
                      child: Text(
                        "Snooze",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    RawMaterialButton(
                      onPressed: () {
                        Alarm.stop(alarmSettings.id)
                            .then((_) => Navigator.pop(context));
                      },
                      child: Text(
                        "Stop",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      viewModelBuilder: () => AlarmRingViewModel(),
    );
  }
}