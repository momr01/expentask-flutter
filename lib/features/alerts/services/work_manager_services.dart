import 'package:flutter/material.dart';
import 'package:payments_management/features/alerts/services/local_notifications_services.dart';
import 'package:workmanager/workmanager.dart';

@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    debugPrint(
        "Native called background task: $task"); //simpleTask will be emitted here.
    LocalNotificationsServices.showBasicNotification();
    return Future.value(true);
  });
}

class WorkManagerServices {
  void registerMyTask() async {
    await Workmanager().registerOneOffTask('id1', 'show simple notification');
  }

  void registerPeriodicTask() async {
    await Workmanager().registerPeriodicTask('id1', 'show simple notification',
        frequency: const Duration(seconds: 15));
  }

  void registerPeriodicTaskEveryday() async {
    await Workmanager().registerPeriodicTask('id1', 'show simple notification',
        frequency: const Duration(hours: 9, minutes: 0, seconds: 15));
  }

  void registerDailyPeriodicTask() async {
    await Workmanager().registerPeriodicTask(
      'id1',
      'WARNINGgggg!',
      frequency: const Duration(minutes: 15),
      inputData: <String, dynamic>{},
      constraints: Constraints(
        networkType: NetworkType.not_required, // Restricciones opcionales
        requiresCharging: false,
        requiresDeviceIdle: false,
        requiresBatteryNotLow: false,
      ),
    );
  }

//init work manager service
  Future<void> init() async {
    await Workmanager().initialize(callbackDispatcher,
        isInDebugMode:
            false // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
        );
    registerDailyPeriodicTask();
  }

  void cancelTask(String id) {
    Workmanager().cancelByUniqueName(id);
  }
}
