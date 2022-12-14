import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/material.dart';
import 'package:teragate/models/storage_model.dart';
import 'package:teragate/config/env.dart';

import '../utils/time_util.dart';

// deprecate : 사용하지 않음 ...
class SettingWorkTime extends StatefulWidget {
  final String getstate;
  final List<String?> initSwitchList;
  final List<String?> initTimeList;

  const SettingWorkTime(
      this.getstate, this.initSwitchList, this.initTimeList, Key? key)
      : super(key: key);

  @override
  SettingWorkTimeState createState() => SettingWorkTimeState();
}

class SettingWorkTimeState extends State<SettingWorkTime> {
  late SecureStorage secureStorage;

  TextStyle textStyle = const TextStyle(
      fontWeight: FontWeight.w700,
      fontFamily: 'suit',
      color: Colors.white,
      fontSize: 20);

  List<String> initTimeGetIn = [
    "08:30",
    "08:30",
    "08:30",
    "08:30",
    "08:30",
    "08:30",
    "08:30"
  ];
  List<String> initTimeGetOut = [
    "18:00",
    "18:00",
    "18:00",
    "18:00",
    "18:00",
    "18:00",
    "18:00"
  ];
  List<String> weekKR = ["월요일", "화요일", "수요일", "목요일", "금요일", "토요일", "일요일"];
  List<String> weekEn = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
  List<String> weekAlarmGITime = [
    Env.KEY_SETTING_MON_GI_TIME,
    Env.KEY_SETTING_TUE_GI_TIME,
    Env.KEY_SETTING_WED_GI_TIME,
    Env.KEY_SETTING_THU_GI_TIME,
    Env.KEY_SETTING_FRI_GI_TIME,
    Env.KEY_SETTING_SAT_GI_TIME,
    Env.KEY_SETTING_SUN_GI_TIME
  ];
  List<String> weekAlarmGOTime = [
    Env.KEY_SETTING_MON_GO_TIME,
    Env.KEY_SETTING_TUE_GO_TIME,
    Env.KEY_SETTING_WED_GO_TIME,
    Env.KEY_SETTING_THU_GO_TIME,
    Env.KEY_SETTING_FRI_GO_TIME,
    Env.KEY_SETTING_SAT_GO_TIME,
    Env.KEY_SETTING_SUN_GO_TIME
  ];
  List<String> weekAlarmGI = [
    Env.KEY_SETTING_MON_GI_SWITCH,
    Env.KEY_SETTING_TUE_GI_SWITCH,
    Env.KEY_SETTING_WED_GI_SWITCH,
    Env.KEY_SETTING_THU_GI_SWITCH,
    Env.KEY_SETTING_FRI_GI_SWITCH,
    Env.KEY_SETTING_SAT_GI_SWITCH,
    Env.KEY_SETTING_SUN_GI_SWITCH
  ];
  List<String> weekAlarmGO = [
    Env.KEY_SETTING_MON_GO_SWITCH,
    Env.KEY_SETTING_TUE_GO_SWITCH,
    Env.KEY_SETTING_WED_GO_SWITCH,
    Env.KEY_SETTING_THU_GO_SWITCH,
    Env.KEY_SETTING_FRI_GO_SWITCH,
    Env.KEY_SETTING_SAT_GO_SWITCH,
    Env.KEY_SETTING_SUN_GO_SWITCH
  ];
  List<bool> switchDay = [false, false, false, false, false, false, false];
  int colorvla = 0;
  List<String> colorChange = ["Colors.black", "Colors.white"];
  Color boxColor = const Color(0xff27282E);
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    secureStorage = SecureStorage();
    _initValue();
  }

  @override
  Widget build(BuildContext context) {
    return _createContainerByBackground(_initScaffoldByAppbar(
        _createWillPopScope(_initContainerByRadius()), widget.getstate));
  }

  Container _createContainer(Widget widget, int index) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: switchDay[index] == true
                ? const Color(0xFF17171C)
                : const Color(0xFF222229),
            borderRadius: BorderRadius.circular(10.0)),
        child: widget);
  }

  Container _initContainerByRadius() {
    return Container(
        padding: const EdgeInsets.only(top: 15),
        decoration: const BoxDecoration(
            color: Color(0xff27282E),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0))),
        child: _initListView());
  }

  Container _createContainerByBackground(Widget widget) {
    return Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/background.png"), fit: BoxFit.fill)),
        child: widget);
  }

  WillPopScope _createWillPopScope(Widget widget) {
    return WillPopScope(
        onWillPop: () {
          _saveValue();
          Navigator.pop(context);
          return Future(() => false);
        },
        child: widget);
  }

  Scaffold _initScaffoldByAppbar(Widget widget, getstate) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const ImageIcon(
            AssetImage("assets/arrow_back_white_24dp.png"),
            color: Colors.white,
          ),
          onPressed: () async {
            _saveValue().then((value) => Navigator.pop(context));
            
          },
        ),
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
        title: Text(
            getstate == Env.WORK_GET_IN ? "WorkIn Alarm" : "WorkOut Alarm",
            style:
                textStyle.copyWith(fontWeight: FontWeight.w600, fontSize: 30)),
        actions: const [],
        centerTitle: true,
        elevation: 4,
      ),
      backgroundColor: Colors.transparent,
      body: widget,
    );
  }

  ListView _initListView() {
    return ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.only(top: 18, bottom: 50),
        itemCount: weekEn.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              onTap: () {
                _initBottomPicker(context, index);
              },
              child: _createContainer(_initRowByWeek(index), index));
        });
  }

  Row _initRowByWeek(index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            alignment: Alignment.center,
            child: Text(weekEn[index],
                style: textStyle.copyWith(
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff9093A5),
                    fontSize: 18))),
        if (widget.getstate == Env.WORK_GET_IN)
          Text(initTimeGetIn[index],
              style: textStyle.copyWith(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xffE8EBFF),
                  fontSize: 28))
        else if (widget.getstate == Env.WORK_GET_OUT)
          Text(initTimeGetOut[index],
              style: textStyle.copyWith(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xffE8EBFF),
                  fontSize: 28)),
        SizedBox(
            child: FittedBox(
                fit: BoxFit.fill,
                child: Switch(
                    value: switchDay[index],
                    activeColor: Colors.white,
                    activeTrackColor: const Color(0xff26C145),
                    inactiveTrackColor: const Color(0xff444653),
                    onChanged: (newValue) {
                      if (widget.getstate == Env.WORK_GET_IN) {
                        setState(
                          () => switchDay[index] = newValue,
                        );
                      } else if (widget.getstate == Env.WORK_GET_OUT) {
                        setState(() => switchDay[index] = newValue);
                      }
                    })))
      ],
    );
  }

  void _initBottomPicker(BuildContext context, int index) async {
    BottomPicker.time(
            title: weekEn[index],
            titleStyle: textStyle,
            backgroundColor: const Color(0xff27282E),
            pickerTextStyle: textStyle,
            buttonText: "Save",
            buttonTextStyle: textStyle,
            buttonSingleColor: const Color(0xff314CF8),
            displayButtonIcon: false,
            closeIconColor: Colors.white,
            onSubmit: (dateTime) async {
              String formattedDate = getPickerTime(dateTime);
              setState(() {
                if (widget.getstate == Env.WORK_GET_IN) {
                  initTimeGetIn[index] = formattedDate;
                } else {
                  initTimeGetOut[index] = formattedDate;
                }
              });
            },
            onClose: () {},
            use24hFormat: true)
        .show(context);
  }

  void _initValue() {
    if (widget.getstate == Env.WORK_GET_IN) {
      for (int i = 0; i < weekAlarmGI.length; i++) {
        _initTimeByGetIN(i);
        _initSwitch(i);
      }
    } else {
      for (int i = 0; i < weekAlarmGI.length; i++) {
        _initTimeByGetOut(i);
        _initSwitch(i);
      }
    }
  }

  Future<void> _initTimeByGetIN(int index) async {
    String? check = widget.initTimeList[index];
    // ignore: prefer_if_null_operators, unnecessary_null_comparison
    initTimeGetIn[index] = check == null ? initTimeGetIn[index] : check;
  }

  Future<void> _initTimeByGetOut(int index) async {
    String? check = widget.initTimeList[index];
    // ignore: prefer_if_null_operators, unnecessary_null_comparison
    initTimeGetOut[index] = check == null ? initTimeGetOut[index] : check;
  }

  Future<void> _initSwitch(int index) async {
    String? change = widget.initSwitchList[index];
    // ignore: prefer_if_null_operators, unnecessary_null_comparison
    switchDay[index] =
        (change == null ? switchDay[index] : (change == "true" ? true : false));
  }

  Future<void> _saveValue() async {
    if (widget.getstate == Env.WORK_GET_IN) {
      for (int i = 0; i < weekAlarmGITime.length; i++) {
        secureStorage.write(weekAlarmGITime[i], initTimeGetIn[i]);
        secureStorage.write(weekAlarmGI[i], switchDay[i].toString());
      }
    } else if (widget.getstate == Env.WORK_GET_OUT) {
      for (int i = 0; i < weekAlarmGOTime.length; i++) {
        secureStorage.write(weekAlarmGOTime[i], initTimeGetOut[i]);
        secureStorage.write(weekAlarmGO[i], switchDay[i].toString());
      }
    }
  }
}
