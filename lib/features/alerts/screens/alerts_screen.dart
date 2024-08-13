import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:payments_management/common/widgets/loader.dart';
import 'package:payments_management/common/widgets/main_title.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/constants/local_notifications.dart';
import 'package:payments_management/features/alerts/services/alerts_services.dart';
import 'package:payments_management/features/alerts/services/local_notifications_services.dart';
import 'package:payments_management/features/alerts/widgets/card_alert.dart';
import 'package:payments_management/features/alerts/widgets/notification_details_screen.dart';
import 'package:payments_management/models/alert.dart';
import 'package:workmanager/workmanager.dart';
import 'package:payments_management/features/alerts/services/work_manager_services.dart';

class AlertsScreen extends StatefulWidget {
  static const String routeName = '/alerts';
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  List<Alert>? alerts;

  final AlertsServices alertsServices = AlertsServices();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchAlerts();
    listenToNotificationStream();
  }

  @override
  void dispose() {
    super.dispose();
    LocalNotificationsServices.streamController.close();
  }

  void listenToNotificationStream() {
    // debugPrint(
    //  LocalNotificationsServices.streamController.stream.toString());
    //   LocalNotificationsServices.streamController.stream
    //    .listen((notification) {});

    // debugPrint(
    //    LocalNotificationsServices.streamController.hasListener.toString());

    LocalNotificationsServices.streamController.stream
        .listen((notificationResponse) {
      debugPrint(notificationResponse.id!.toString());
      debugPrint(notificationResponse.payload!.toString());

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) =>
                  NotificationDetailsScreen(response: notificationResponse)));
    });
  }

  fetchAlerts() async {
    setState(() {
      _isLoading = true;
    });
    alerts = await alertsServices.fetchAlerts(context: context);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        color: GlobalVariables.greyBackgroundColor,
        opacity: 0.8,
        blur: 0.8,
        inAsyncCall: _isLoading,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 20, left: 15, right: 15),
              child: MainTitle(title: 'Alertas'),
            ),
            ElevatedButton.icon(
                onPressed: () async {
                  //LocalNotificationsServices.showScheduledNotification();
                  //   LocalNotificationsServices.showBasicNotification();

                  // await Future.wait([
                  //   LocalNotificationsServices.init(),
                  //   WorkManagerServices().init()
                  // ]);
                  //await startIsolateAndScheduleRecurringNotification();
                },
                icon: Icon(Icons.abc_rounded),
                label: Text('gfff')),
            const SizedBox(
              height: 20,
            ),
            alerts == null
                ? const Loader()
                : alerts!.isEmpty
                    ? const Text('¡No existen alertas para mostrar!')
                    : Expanded(
                        child: ListView.builder(
                            itemBuilder: (context, index) {
                              return CardAlert(alert: alerts![index]);
                            },
                            itemCount: alerts!.length)),
          ],
        ),
      ),
    );
  }
}
