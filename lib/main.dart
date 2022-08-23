import 'package:flutter/material.dart';

import 'package:teragate/config/env.dart';
import 'package:teragate/models/storage_model.dart';
import 'package:teragate/services/server_service.dart';
import 'package:teragate/utils/alarm_util.dart';
import 'package:teragate/states/login_state.dart';
import 'package:teragate/states/dashboard_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHome(),
    );
  }
}

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  State<MyHome> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHome> {
  late SecureStorage secureStorage;

  @override
  void initState() {
    super.initState();
    initSet();
  }

  @override
  Widget build(BuildContext context) {
    return _createContainerByBackground(Center(
        child: _createPaddingByOnly(
            8.0,
            30.0,
            80.0,
            80.0,
            Image.asset(
              'assets/workon_logo.png',
              fit: BoxFit.fitWidth,
            ))));
  }

  Container _createContainerByBackground(Widget widget) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/background.png"), fit: BoxFit.fill)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: widget,
      ),
    );
  }

  Padding _createPaddingByOnly(
      double top, double bottom, double left, double right, Widget widget) {
    return Padding(
        padding:
            EdgeInsets.only(top: top, bottom: bottom, left: left, right: right),
        child: widget);
  }

  void initSet() async {
    secureStorage = SecureStorage();
    _checkUser(context).then(
        (data) => move(data["loginId"], data["loginPw"], data["isLogin"]));
  }

  Future<Map<String, String?>> _checkUser(context) async {
    String? loginId = await secureStorage.read(Env.LOGIN_ID);
    String? loginPw = await secureStorage.read(Env.LOGIN_PW);
    String? isLogin = await secureStorage.read(Env.KEY_LOGIN_STATE);

    return {"loginId": loginId, "loginPw": loginPw, "isLogin": isLogin};
  }

  void move(String? id, String? password, String? isLogin) async {
    if (isLogin == "true") {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Dashboard()));
    } else {
      if (id != null && password != null) {
        login(id, password).then((loginInfo) {
          if (loginInfo.success!) {
            secureStorage.write(Env.KEY_ACCESS_TOKEN,
                '${loginInfo.tokenInfo?.getAccessToken()}');
            secureStorage.write(Env.KEY_REFRESH_TOKEN,
                '${loginInfo.tokenInfo?.getRefreshToken()}');
            secureStorage.write(
                Env.KEY_LOGIN_RETURN_ID, loginInfo.data!["userId"].toString());
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => const Dashboard()));
          } else {
            showSnackBar(context, loginInfo.message!);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const Login()));
          }
        });
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Login()));
      }
    }
  }
}
