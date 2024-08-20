import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationsServices {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static StreamController<NotificationResponse> streamController =
      StreamController.broadcast();

  static onTap(NotificationResponse notificationResponse) {
    streamController.add(notificationResponse);
  }

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
    NotificationDetails details = NotificationDetails(
        android: AndroidNotificationDetails('id 1', 'basic notification',
            importance: Importance.max,
            priority: Priority.high,
            sound: RawResourceAndroidNotificationSound('bell.wav'
                .split('.')
                .first))); //aca se modifican cosas como sonido vibracion etc

    await flutterLocalNotificationsPlugin.show(
        0, 'Basic Notification', 'body', details,
        payload: 'payload data');
  }

  //repeated notification
  static void showRepeatedNotification() async {
    NotificationDetails details = const NotificationDetails(
        android: AndroidNotificationDetails('id 2', 'repeated notification',
            importance: Importance.max,
            priority: Priority
                .high)); //aca se modifican cosas como sonido vibracion etc

    await flutterLocalNotificationsPlugin.periodicallyShow(
        1, 'repeated Notification', 'body', RepeatInterval.everyMinute, details,
        payload: 'payload data');
  }

  static void cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  //schedule notification
  static void showScheduledNotification() async {
    NotificationDetails details = const NotificationDetails(
        android: AndroidNotificationDetails('id 3', 'scheduled notification',
            importance: Importance.max,
            priority: Priority
                .high)); //aca se modifican cosas como sonido vibracion etc

    tz.initializeTimeZones();

    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    await flutterLocalNotificationsPlugin.zonedSchedule(
        2,
        'scheduled notification',
        'body',
        tz.TZDateTime(
          tz.local, 2024,
          5, //month
          21, //day,
          21, //hour
          58, //minute
          //second
          //milisecond
        ),
        details,
        payload: 'zonedSchedule',
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  //schedule daily notification
  static void showDailyScheduledNotification() async {
    NotificationDetails details = const NotificationDetails(
        android: AndroidNotificationDetails(
      'id 4', 'daily scheduled notification',
      importance: Importance.max,
      priority: Priority.high,
      channelDescription: 'your_channel_description',
      ticker: 'ticker',
      styleInformation: BigTextStyleInformation(''),
      color: Colors.blue, // Cambia el color de la notificación
      ledColor: Colors.red, // Color de la luz LED (si aplica)
      ledOnMs: 1000,
      ledOffMs: 500,
      icon: '@mipmap/ic_launcher', // I
    )); //aca se modifican cosas como sonido vibracion etc

    tz.initializeTimeZones();

    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();

    // tz.setLocalLocation(tz.getLocation('America/Argentina/Buenos_Aires'));
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    var currentTime = tz.TZDateTime.now(tz.local);

    var scheduleTime = tz.TZDateTime(
        tz.local,
        currentTime.year,
        currentTime.month, //month
        currentTime.day, //day,
        //9
        //currentTime.hour + 1
        17,
        24
        //currentTime.hour, //hour
        //57, //minutes
        //second
        //milisecond
        );

    if (scheduleTime.isBefore(currentTime)) {
      scheduleTime = scheduleTime.add(const Duration(days: 1));
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
        3, 'daily scheduled notification', 'body', scheduleTime, details,
        payload: 'zonedSchedule',
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  static void cancelAll() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
