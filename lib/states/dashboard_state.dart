import 'dart:async';
// import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

//플러터 플로팅버튼용
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

//Back버튼 기능 변경(종료 > background)
import 'package:move_to_background/move_to_background.dart';

//현재시간
import 'package:timer_builder/timer_builder.dart';

import 'package:teragate/config/colors.dart';
import 'package:teragate/config/font-weights.dart';
import 'package:teragate/config/icons.dart';

import 'package:teragate/states/widgets/background.dart';
import 'package:teragate/states/widgets/navbar.dart';
import 'package:teragate/states/widgets/text.dart';
import 'package:teragate/states/widgets/card_commuting.dart';
import 'package:teragate/states/widgets/card_state.dart';
import 'package:teragate/states/widgets/card_button.dart';

import 'package:teragate/config/env.dart';
import 'package:teragate/models/storage_model.dart';
import 'package:teragate/services/network_service.dart';
import 'package:teragate/services/server_service.dart';
import 'package:teragate/services/beacon_service.dart';
import 'package:teragate/states/login_state.dart';
import 'package:teragate/utils/alarm_util.dart';
import 'package:teragate/utils/time_util.dart';
import 'package:teragate/utils/Log_util.dart';
import 'package:teragate/states/setting_state.dart';
import 'package:teragate/states/webview_state.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> with WidgetsBindingObserver {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late SecureStorage secureStorage;

  String? name = "";
  String? currentLocationState = "외부";
  String? currentUuid = "";
  String? deviceip = "";
  Timer? backgroundTimer;
  late StreamSubscription connectivityStreamSubscription;
  late StreamSubscription beaconStreamSubscription;
  late StreamController<String> beaconStreamController;

  String? currentState = "근무중";
  String? currentLocation = "사무실";
  String currentWeekKor = "월요일";
  String currentTime = "00:00";
  String currentDay = "1978-01-01";

  String? getInState = "출근 하기";
  String? getInTime = "";
  

  late DateTime innerTime;

  late Map<String, String> uuids;
  @override
  void initState() {
    super.initState();

    secureStorage = SecureStorage();

    WidgetsBinding.instance.addObserver(this);

    _initIp();
    _initNotification();
    _initUuids();
    _startBeacon().then((value) => _startListenByBeacon());
    _startBackgroundTimer().then((timer) => backgroundTimer = timer);
    innerTime = getNow();
  }

  @override
  // ignore: avoid_renaming_method_parameters
  void didChangeAppLifecycleState(AppLifecycleState appLifecycleState) {
    super.didChangeAppLifecycleState(appLifecycleState);
    switch (appLifecycleState) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.paused:
        break;
    }
  }

  @override
  void dispose() {
    _stopListenByBeacon();
    _stopBeacon();
    WidgetsBinding.instance.removeObserver(this);
    connectivityStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return initBackgoundImage(_createWillPopScope(_initScaffoldByMain()));
  }

  WillPopScope _createWillPopScope(Widget widget) {
    return WillPopScope(
        onWillPop: () {
          MoveToBackground.moveTaskToBack();
          return Future(() => false);
        },
        child: widget);
  }

  Container _createContainer(Widget widget) {
    return Container(margin: const EdgeInsets.all(8.0), child: widget);
  }

  Text _createText(String subject, String value) {
    return Text(
      "$subject : $value",
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Colors.blue,
      ),
    );
  }

  Scaffold _initScaffoldByMain() {
    return Scaffold(
      appBar: NavBar(
        title: Image.asset('assets/logo_02.png', fit: BoxFit.none),
        isActions: true,
        moveLogin: _checkMoveLogin,
      ),
      backgroundColor: Colors.transparent,
      body: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomText(
              text: currentTime,
              size: 60.0,
              weight: TeragateFontWeight.bold,
            ),
            CustomText(
              text: currentWeekKor,
              size: 20.0,
              weight: TeragateFontWeight.medium,
            ),
            CustomText(
              text: currentDay,
              size: 18.0,
              weight: TeragateFontWeight.regular,
              color: TeragateColors.grey,
            ),
            const SizedBox(height: 30.0),
            Expanded(
              child: createContentBox(
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 1
                    CustomText(
                      text: "출근 · 퇴근",
                      size: 20.0,
                      weight: TeragateFontWeight.bold,
                      color: TeragateColors.cardTitle,
                    ),
                    const SizedBox(height: 10.0),
                    Expanded(
                      flex: 4,
                      child: Row(
                        children: [
                          Expanded(
                            child: CardCommuting(
                              title: "출근",
                              time: "$getInTime ",
                              isCommuting: "$getInState ",
                            ),
                          ),
                          Expanded(
                            child: CardCommuting(
                              title: "퇴근",
                              time: "18:02",
                              isCommuting: "퇴근 완료",
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Expanded(flex: 5, child: CardState(locationState: currentState, location: currentLocation)),
                    const SizedBox(height: 5.0),
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          Expanded(
                            child: CardButton(
                              icon: TeragateIcons.groups,
                              title: "그룹웨어",
                              subtitle: "HI5 바로가기",
                              function: _moveWebview
                            ),
                          ),
                          Expanded(
                            child: CardButton(
                              icon: Icons.settings,
                              title: "환경설정",
                              subtitle: "일정 및 앱 설정",
                              function: _moveSetting,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Notifcation 알람 초기화
  Future<void> _initNotification() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = const IOSInitializationSettings(onDidReceiveLocalNotification: null);
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: null);
  }

  void _showNotification(String message) {
    selectNotificationType(flutterLocalNotificationsPlugin, Env.TITLE_DIALOG, message);
  }

  // ip 설정 ( wifi or mobile (lte, 5G 등 ) )
  void _initIp() {
    Connectivity().checkConnectivity().then((result) {
      if (result == ConnectivityResult.mobile) {
        getIPAddressByMobile().then((map) {
          Log.log(' mobile ip address = ${map["ip"]}');
          deviceip = map["ip"];
        });
      } else if (result == ConnectivityResult.wifi) {
        getIPAddressByWifi().then((map) {
          Log.log(' wifi ip address = ${map["ip"]}');
          deviceip = map["ip"];
        });
      }
    });

    connectivityStreamSubscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile) {
        getIPAddressByMobile().then((map) {
          Log.log(' mobile ip address = ${map["ip"]}');
          deviceip = map["ip"];
        });
      } else if (result == ConnectivityResult.wifi) {
        getIPAddressByWifi().then((map) {
          Log.log(' wifi ip address = ${map["ip"]}');
          deviceip = map["ip"];
        });
      }
    });
  }

  void _checkMoveLogin() {
    showOkCancelDialog(context, "로그아웃", '로그인 페이지로 이동하시겠습니까?', _moveLogin);
  }

  void _moveLogin() async {
    secureStorage.read(Env.KEY_ID_CHECK).then((value) {
      if (value == null && value == "false") {
        secureStorage.write(Env.LOGIN_ID, "");
      }
    });
    secureStorage.write(Env.LOGIN_PW, "");
    secureStorage.write(Env.KEY_LOGIN_STATE, "false");
    secureStorage.write(Env.KEY_ACCESS_TOKEN, "");
    secureStorage.write(Env.KEY_REFRESH_TOKEN, "");

    _stopBackgroundTimer();
    Navigator.push(context, MaterialPageRoute(builder: (_) => const Login()));
  }

  void _moveWebview(BuildContext context) async {
    secureStorage.read(Env.KEY_LOGIN_RETURN_ID).then((value) => Navigator.push(context, MaterialPageRoute(builder: (context) => WebViews(value!, null))));
  }

  Future<void> _moveSetting(BuildContext context) async {
    _getSetting().then((data) => Navigator.push(context, MaterialPageRoute(builder: (context) => Setting(data["beaconuuid"], data["switchGetIn"], data["switchGetOut"], data["switchAlarm"], null))));
  }

  Future<Map<String, dynamic>> _getSetting() async {
    String? uuid = await secureStorage.read(Env.KEY_SETTING_UUID);
    String? getin = await secureStorage.read(Env.KEY_SETTING_GI_SWITCH);
    String? getout = await secureStorage.read(Env.KEY_SETTING_GO_SWITCH);
    String? alarm = await secureStorage.read(Env.KEY_SETTING_ALARM);

    return {
      // ignore: prefer_if_null_operators
      "beaconuuid": (uuid == null ? Env.UUID_DEFAULT : uuid),
      "switchGetIn": (getin == null ? false : (getin == "true" ? true : false)),
      "switchGetOut": (getout == null ? false : (getout == "true" ? true : false)),
      "switchAlarm": (alarm == null ? false : (alarm == "true" ? true : false))
    };
  }

  void _startToGetIn() async {
    String? accessToken = await secureStorage.read(Env.KEY_ACCESS_TOKEN);
    String? refreshToken = await secureStorage.read(Env.KEY_REFRESH_TOKEN);

    if (accessToken == null) {
      _showNotification(Env.MSG_NOT_TOKEN);
      return;
    }

    if (refreshToken == null) {
      _showNotification(Env.MSG_NOT_TOKEN);
      return;
    }

    processGetIn(accessToken, refreshToken, deviceip!, secureStorage, 0).then((workInfo) {
      if (workInfo.success) {
        _showNotification(workInfo.message);
      } else {
        _showNotification(workInfo.message);
      }
    });
  }

  void _startToGetOut() async {
    String? accessToken = await secureStorage.read(Env.KEY_ACCESS_TOKEN);
    String? refreshToken = await secureStorage.read(Env.KEY_REFRESH_TOKEN);

    if (accessToken == null) {
      _showNotification(Env.MSG_NOT_TOKEN);
      return;
    }

    if (refreshToken == null) {
      _showNotification(Env.MSG_NOT_TOKEN);
      return;
    }

    processGetOut(accessToken, refreshToken, deviceip!, secureStorage, 0).then((workInfo) {
      if (workInfo.success) {
        _showNotification(workInfo.message);
      } else {
        _showNotification(workInfo.message);
      }
    });
  }

  Future<void> _startBeacon() async {
    beaconStreamController = StreamController<String>.broadcast();
    initBeacon(_showNotification, beaconStreamController, secureStorage);
  }

  Future<void> _stopBeacon() async {
    beaconStreamController.close();
    stopBeacon();
  }

  void _startListenByBeacon() {
    beaconStreamSubscription = beaconStreamController.stream.listen((event) {
      if (event.isNotEmpty) {
        if (checkUUID(uuids, event)) {
          innerTime = getNow();
        }
      }
    }, onError: (dynamic error) {
      Log.error('Received error: ${error.message}');
    });
  }

  void _stopListenByBeacon() {
    beaconStreamSubscription.cancel();
  }

  Future<Timer> _startBackgroundTimer() async {
    Timer? timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // ignore: unnecessary_null_comparison
      if (innerTime == null) return;

      int diff = getNow().difference(innerTime).inSeconds;

      String locationState = "";
      String location = "";

      if (diff > 60) {
        locationState = "";
        location = "외부";
        getInState = "출근 하기";
      } else {
        locationState = "근무중";
        location = "사무실";
        getInState = "출근 완료";
      }

      if (currentState != locationState) {
        // 서버에 전송

        getInTime = getPickerTime(getNow());
        currentState = locationState;
        currentLocation = location;
      }

      _setUI();
    });

    return timer;
  }

  Future<void> _stopBackgroundTimer() async {
    backgroundTimer!.cancel();
  }

  Future<void> _initUuids() async {
    // String? sizeStr = await secureStorage.read(Env.KEY_UUID_SIZE);
    // int size = int.parse(sizeStr!);
    int size = 0;

    uuids = {};
    for (int i = 0; i < size; i++) {
      uuids["$i"] = (await secureStorage.read("uuid$i"))!;
    }
  }

  Future<String?> _getLoactionName() async {
    String? name = await secureStorage.read(currentUuid!);
    return name;
  }

  void _setUI() async {
    setState(() {
      currentWeekKor = getWeekByKor();
      currentTime = getDateToStringForHHMMInNow();
      currentDay = getDateToStringForYYYYMMDDKORInNow();
      // currentState = "";
    });
  }
}
