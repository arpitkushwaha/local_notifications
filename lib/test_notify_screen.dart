import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_notifications/screen_second.dart';
import 'local_notify_manager.dart';

class TestNotifyScreen extends StatefulWidget {
  @override
  _TestNotifyScreenState createState() => _TestNotifyScreenState();
}

class _TestNotifyScreenState extends State<TestNotifyScreen> {
  //LocalNotifyManager localNotifyManager = LocalNotifyManager.init();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LocalNotifyManager.localNotifyManager = LocalNotifyManager.init();
    LocalNotifyManager.localNotifyManager
        .setOnNotificationReceive(onNotificationReceive);
    LocalNotifyManager.localNotifyManager
        .setOnNotificationClick(onNotificationClick);
  }

  onNotificationReceive(RecieveNotification notification) {
    print('Notification Recieved: ${notification.id}');
  }

  onNotificationClick(String payload) {
    print('Payload $payload');
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ScreenSecond(payload: payload);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Local Notifications"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await LocalNotifyManager.localNotifyManager.showNotification();
            //await LocalNotifyManager.localNotifyManager.scheduleNotification();
            //await LocalNotifyManager.localNotifyManager.showDailyAtTimeNotification();
            //await LocalNotifyManager.localNotifyManager.showWeeklyAtDayTimeNotification();
          },
          child: Text("Send Notification"),
        ),
      ),
    );
  }
}
