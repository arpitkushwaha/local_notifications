import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show Platform;
import 'package:rxdart/subjects.dart';

class LocalNotifyManager {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  var initSetting;

  BehaviorSubject<RecieveNotification> get didReceiveNotificationSubject =>
      BehaviorSubject<RecieveNotification>();

  static LocalNotifyManager localNotifyManager = LocalNotifyManager.init();

  LocalNotifyManager.init() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    if (Platform.isIOS) {
      requestIOSPermission();
    }
    initializePlatform();
  }

  requestIOSPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        .requestPermissions(alert: true, badge: true, sound: true);
  }

  initializePlatform() {
    var initSettingAndroid =
        AndroidInitializationSettings('app_notification_icon');
    var initSettingIOS = IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: (id, title, body, payload) async {
          RecieveNotification notification = RecieveNotification(
              id: id, title: title, body: body, payload: payload);
          didReceiveNotificationSubject.add(notification);
        });
    initSetting = InitializationSettings(initSettingAndroid, initSettingIOS);
  }

  setOnNotificationReceive(Function onNotificationReceive) {
    didReceiveNotificationSubject.listen((notification) {
      onNotificationReceive(notification);
    });
  }

  setOnNotificationClick(Function onNotificationClick) async {
    await flutterLocalNotificationsPlugin.initialize(initSetting,
        onSelectNotification: (String payload) async {
      onNotificationClick(payload);
    });
  }

  Future<void> showNotification() async {
    var androidChannel = AndroidNotificationDetails(
        "CHANNEL_ID 0", "CHANNEL_NAME 0", "CHANNEL_DESCRIPTION 0",
        importance: Importance.Max, priority: Priority.High, playSound: true);

    var iosChannel = IOSNotificationDetails();
    var platformChannel = NotificationDetails(androidChannel, iosChannel);
    await flutterLocalNotificationsPlugin.show(
        0, 'Test Title', 'Test Body', platformChannel,
        payload: 'New Payload');
  }

  Future<void> scheduleNotification() async {
    var scheduleNotificationDateTime = DateTime.now().add(Duration(seconds: 5));
    var androidChannel = AndroidNotificationDetails(
        "CHANNEL_ID 1", "CHANNEL_NAME 1 ", "CHANNEL_DESCRIPTION 1",
        importance: Importance.Max,
        priority: Priority.High,
        playSound: true,
        enableLights: true);

    var iosChannel = IOSNotificationDetails();
    var platformChannel = NotificationDetails(androidChannel, iosChannel);
    await flutterLocalNotificationsPlugin.schedule(0, 'Schedule Test Title',
        'Schedule Test Body', scheduleNotificationDateTime, platformChannel,
        payload: 'Schedule New Payload');
  }

  Future<void> repeatNotification() async {
    var androidChannel = AndroidNotificationDetails(
        "CHANNEL_ID 2", "CHANNEL_NAME 2", "CHANNEL_DESCRIPTION 2",
        importance: Importance.Max, priority: Priority.High, playSound: true);

    var iosChannel = IOSNotificationDetails();
    var platformChannel = NotificationDetails(androidChannel, iosChannel);
    await flutterLocalNotificationsPlugin.periodicallyShow(0, 'Repeat Title',
        'Repeat Body', RepeatInterval.EveryMinute, platformChannel,
        payload: 'Repeat New Payload');
  }

  Future<void> showDailyAtTimeNotification() async {
    var time = Time(20, 13, 0);
    var androidChannel = AndroidNotificationDetails(
        "CHANNEL_ID 3", "CHANNEL_NAME 3", "CHANNEL_DESCRIPTION 3",
        importance: Importance.Max, priority: Priority.High, playSound: true);

    var iosChannel = IOSNotificationDetails();
    var platformChannel = NotificationDetails(androidChannel, iosChannel);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        0,
        'Daily Title ${time.hour}-${time.minute}-${time.second}',
        'Daily Body',
        time,
        platformChannel,
        payload: 'Daily New Payload');
  }

  Future<void> showWeeklyAtDayTimeNotification() async {
    var time = Time(20, 18, 0);
    var androidChannel = AndroidNotificationDetails(
        "CHANNEL_ID 3", "CHANNEL_NAME 3", "CHANNEL_DESCRIPTION 3",
        importance: Importance.Max, priority: Priority.High, playSound: true);

    var iosChannel = IOSNotificationDetails();
    var platformChannel = NotificationDetails(androidChannel, iosChannel);
    await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
        0,
        'Weekly Title ${time.hour}-${time.minute}-${time.second}',
        'Weekly Body',
        Day.Monday,
        time,
        platformChannel,
        payload: 'Weekly New Payload');
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

}

class RecieveNotification {
  final int id;
  final String title;
  final String body;
  final String payload;
  RecieveNotification(
      {@required this.id,
      @required this.title,
      @required this.body,
      @required this.payload});
}
