import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:teragate/config/env.dart';
import 'package:teragate/models/storage_model.dart';

void showToast(String text) {
  Fluttertoast.showToast(
    fontSize: 13,
    msg: '   $text   ',
    backgroundColor: Colors.black,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
  );
}

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      text,
      textAlign: TextAlign.center,
    ),
    duration: const Duration(seconds: 2),
    backgroundColor: Colors.grey[400],
  ));
}

void _showDialog(BuildContext context, String title, text, var actions) {
  TextStyle textStyle = const TextStyle(
      fontWeight: FontWeight.w700,
      fontFamily: 'suit',
      color: Colors.white,
      fontSize: 20);
  contentBox(context, title, text, actions) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: const Color(0xff27282E),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(8),
                color: const Color(0xff444653),
                child: const ImageIcon(
                  AssetImage("assets/logout_black_24dp.png"),
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Text(
                  title,
                  style: textStyle.copyWith(fontSize: 20),
                ),
              ),
              Text(
                text,
                style: textStyle.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff9093A5)),
                textAlign: TextAlign.center,
              ),
              Container(
                  margin: const EdgeInsets.only(bottom: 15, top: 20),
                  alignment: Alignment.bottomRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                          height: 40,
                          width: 100,
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                "Cancel",
                                style: textStyle.copyWith(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ))),
                      SizedBox(
                          height: 40,
                          width: 100,
                          child: ElevatedButton(
                              onPressed: () {
                                actions();
                              },
                              child: Text(
                                "OK",
                                style: textStyle.copyWith(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ))),
                    ],
                  )),
            ],
          ),
        ), // bottom part
      ],
    );
  }

  showDialog(
      context: context,
      barrierDismissible: false, // ?????? ?????? ????????? ????????? ??????
      builder: (BuildContext context) {
        // return AlertDialog(
        //   title: Text(title),
        //   content: SingleChildScrollView(
        //     child: Column(
        //       children: contentWigets,
        //     ),
        //   ),
        //   actions: actions,
        // );
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: const Color(0xff27282E),
          child: contentBox(context, title, text, actions),
        );
      });
}

void showConfirmDialog(BuildContext context, String title, String text) {
  _showDialog(
    context,
    title,
    text,
    <Widget>[Text(text)],
  );
}

void showOkCancelDialog(
    BuildContext context, String title, String text, Function okCallback) {
  _showDialog(context, title, text, okCallback);
}

//???????????? ?????? ??????, iOS?????? ???????????? ???????????? ????????? ????????? ????????????...
Future<void> selectNotificationType(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    String tag,
    String subtitle) async {
  late SecureStorage strage = SecureStorage();

  String? soundCheck = await strage.read(Env.KEY_SETTING_SOUND);
  String? vibCheck = await strage.read(Env.KEY_SETTING_VIBRATE);

  //??????????????? null????????? ture ??? ???????????? ??????????????? ??????.
  if (soundCheck == 'true' && vibCheck == 'true') {
    //????????? / ?????? ?????? ?????????????????? ??????????????? ??????
    showNotification(flutterLocalNotificationsPlugin, tag, subtitle);
  } else if (soundCheck == 'true' && vibCheck == 'false') {
    //???????????? ?????????????????? ??????
    showNotificationWithNoVibration(
        flutterLocalNotificationsPlugin, tag, subtitle);
  } else if (soundCheck == 'false' && vibCheck == 'true') {
    //????????? ?????????????????? ??????
    _showNotificationWithNoSound(
        flutterLocalNotificationsPlugin, tag, subtitle);
  } else {
    //?????? , ?????? ?????? ??????????????????
    showNotificationWithNoOptions(
        flutterLocalNotificationsPlugin, tag, subtitle);
  }
}

Future<void> _showNotification(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    String tag,
    String subtitle,
    AndroidNotificationDetails androidNotificationDetails,
    IOSNotificationDetails iOSNotificationDetails) async {
  int id = 0;
  var notificationDetails = NotificationDetails(
      android: androidNotificationDetails, iOS: iOSNotificationDetails);
  flutterLocalNotificationsPlugin.show(id, tag, subtitle, notificationDetails,
      payload: 'item x');
}

// ??????, ?????? ?????? ???????????????
Future<void> showNotification(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    String tag,
    String subtitle) async {
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
          Env.NOTIFICATION_CHANNEL_ID, Env.NOTIFICATION_CHANNEL_NAME,
          playSound: true,
          enableVibration: true,
          enableLights: false,
          ongoing: true,
          importance: Importance.high,
          priority: Priority.high);
  const IOSNotificationDetails iOSNotificationDetails =
      IOSNotificationDetails(presentSound: true);
  _showNotification(flutterLocalNotificationsPlugin, tag, subtitle,
      androidNotificationDetails, iOSNotificationDetails);
}

//????????? ???????????????
Future<void> _showNotificationWithNoSound(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    String tag,
    String subtitle) async {
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
          Env.NOTIFICATION_CHANNEL_ID, Env.NOTIFICATION_CHANNEL_NAME,
          playSound: false,
          enableVibration: true,
          enableLights: false,
          ongoing: true,
          importance: Importance.high,
          priority: Priority.high);
  const IOSNotificationDetails iOSNotificationDetails =
      IOSNotificationDetails(presentSound: false);
  _showNotification(flutterLocalNotificationsPlugin, tag, subtitle,
      androidNotificationDetails, iOSNotificationDetails);
}

//????????? ???????????????
Future<void> showNotificationWithNoVibration(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    String tag,
    String subtitle) async {
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
          Env.NOTIFICATION_CHANNEL_ID, Env.NOTIFICATION_CHANNEL_NAME,
          playSound: true,
          enableVibration: false,
          enableLights: false,
          ongoing: true,
          importance: Importance.high,
          priority: Priority.high);
  const IOSNotificationDetails iOSNotificationDetails =
      IOSNotificationDetails(presentSound: true);
  _showNotification(flutterLocalNotificationsPlugin, tag, subtitle,
      androidNotificationDetails, iOSNotificationDetails);
}

//??????, ?????? ?????? ???????????????
Future<void> showNotificationWithNoOptions(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    String tag,
    String subtitle) async {
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(Env.NOTIFICATION_CHANNEL_ID_NO_ALARM,
          Env.NOTIFICATION_CHANNEL_NAME_NO_ALARM,
          playSound: false,
          enableVibration: false,
          enableLights: false,
          ongoing: true,
          importance: Importance.high,
          priority: Priority.high);
  const IOSNotificationDetails iOSNotificationDetails =
      IOSNotificationDetails(presentSound: false);
  _showNotification(flutterLocalNotificationsPlugin, tag, subtitle,
      androidNotificationDetails, iOSNotificationDetails);
}
