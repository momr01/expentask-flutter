import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotifications {
  // static final FlutterLocalNotificationsPlugin
  //    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static onTap(NotificationResponse notificationResponse) {}

  static Future init() async {
    InitializationSettings settings = const InitializationSettings(
        android: AndroidInitializationSettings("@mipmap/ic_launcher"),
        iOS: DarwinInitializationSettings());

    flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveBackgroundNotificationResponse: onTap,
      onDidReceiveNotificationResponse: onTap,
    );
  }

  //basic notification
  static void showBasicNotification() async {
    NotificationDetails details = const NotificationDetails(
        android: AndroidNotificationDetails('id 1',
            'basic notification')); //aca se modifican cosas como sonido vibracion etc

    await flutterLocalNotificationsPlugin.show(
        0, 'Basic Notification', 'body', details);
  }

// initialise the local notifications
  /*static Future init() async {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
            onDidReceiveLocalNotification: ((id, title, body, payload) =>
                null));
    final LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
            linux: initializationSettingsLinux);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: ((details) => null));
  }*/

  //show a simple notification
  /* static Future showSimpleNotification(
      {required String title,
      required String body,
      required String payload}) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin
        .show(0, title, body, notificationDetails, payload: payload);
  }*/
}
