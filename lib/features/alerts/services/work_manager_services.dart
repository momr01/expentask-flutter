import 'package:flutter/material.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/constants/navigator_keys.dart';
import 'package:payments_management/features/alerts/services/local_notifications_services.dart';
import 'package:workmanager/workmanager.dart';
import 'package:payments_management/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Future<int> numberOfAlerts() async {
  final userProvider = Provider.of<UserProvider>(
      NavigatorKeys.navKey.currentContext!,
      listen: false);

  int total = 0;

  try {
    http.Response res =
        await http.get(Uri.parse('$uri/api/payments/totalAlerts'), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'x-auth-token': userProvider.user.token
    });

    total = jsonDecode(res.body)['alerts'];
  } catch (e) {
    debugPrint(e.toString());
  }
  return total;
}

@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // debugPrint("Native called background task: $task");

    // Accede al token desde un servicio o singleton
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('x-auth-token') ?? '';

    if (token.isEmpty) {
      // debugPrint("Token no disponible");
      return Future.value(false);
    }

    int total = 0;

    try {
      http.Response res = await http.get(
        Uri.parse('$uri/api/payments/totalAlerts'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );

      if (res.statusCode == 200) {
        total = jsonDecode(res.body)['alerts'];
      } else {
        // debugPrint('Failed to load alerts: ${res.statusCode}');
        return Future.value(false);
      }
    } catch (e
    //, stackTrace
    ) {
      //  debugPrint('Error occurred: $e\n$stackTrace');
      return Future.value(false);
    }

    if (total > 0) {
      LocalNotificationsServices.showNumberOfPendingPayments(total);
    } else {
      debugPrint("Sin alertas, nada para notificar");
    }

    return Future.value(true);
  });
}

class WorkManagerServices {
  /* void registerMyTask() async {
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
*/
  void registerDailyPeriodicTask() async {
    await Workmanager().registerPeriodicTask(
      '1',
      'Workmanager Periodic Task',
      // frequency: const Duration(minutes: 15),
      frequency: const Duration(hours: 1),
      inputData: <String, dynamic>{},
      constraints: Constraints(
          networkType: NetworkType.not_required, // Restricciones opcionales
          requiresCharging: false,
          requiresDeviceIdle: false,
          requiresBatteryNotLow: false,
          requiresStorageNotLow: false),
    );
  }

//init work manager service
  Future<void> init() async {
    await Workmanager().initialize(callbackDispatcher,
        isInDebugMode:
            true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
        );
    registerDailyPeriodicTask();
  }

  void cancelTask(String id) {
    Workmanager().cancelByUniqueName(id);
  }
}
