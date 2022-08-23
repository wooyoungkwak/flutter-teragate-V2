import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:beacons_plugin/beacons_plugin.dart';

import 'package:teragate/config/env.dart';
import 'package:teragate/models/storage_model.dart';
import 'package:teragate/utils/log_util.dart';
import 'package:teragate/utils/time_util.dart';

import 'package:teragate/models/beacon_model.dart';

// 비콘 초기화
Future<void> initBeacon(Function showNotification, StreamController beaconStreamController, SecureStorage secureStorage) async {

  if (Platform.isAndroid) {
    await BeaconsPlugin.setDisclosureDialogMessage(title: "Need Location Permission", message: "This app collects location data to work with beacons.");

    BeaconsPlugin.channel.setMethodCallHandler((call) async {
      Log.log(" ********* Call Method: ${call.method}");

      if (call.method == 'scannerReady') {
        await startBeacon();
      } else if (call.method == 'isPermissionDialogShown') {
        showNotification("Beacon 을 검색 할 수 없습니다. 권한을 확인 하세요.");
      }
    });
    
  } else if (Platform.isIOS) {
    BeaconsPlugin.setDebugLevel(2);
    Future.delayed(const Duration(milliseconds: 3000), () async {
      await startBeacon();
    }); //Send 'true' to run in background

    Future.delayed(const Duration(milliseconds: 3000), () async {
      await BeaconsPlugin.runInBackground(true);
    }); //Send 'true' to run in background
  }

  BeaconsPlugin.listenToBeacons(beaconStreamController);
}

bool checkUUID(Map<String, String> uuids, dynamic event) {
  Map<String, dynamic> userMap = jsonDecode(event);
  var iBeacon = BeaconData.fromJson(userMap);
  
  if ( iBeacon.uuid.toUpperCase() ==  "12345678-9A12-3456-789B-123456FFFFFF".toUpperCase()) {
    return true;
  }

  // if ( iBeacon.uuid.toUpperCase() ==  "74278bdb-b644-4520-8f0c-720eeaffffff".toUpperCase()) {
  //   return true;
  // }

  return false;
}

// 비콘 설정
Future<void> _setBeacon() async {
  await BeaconsPlugin.addRegion("iBeacon", Env.UUID_DEFAULT);
  if (Platform.isAndroid) {
    BeaconsPlugin.addBeaconLayoutForAndroid("m:2-3=0215,i:4-19,i:20-21,i:22-23,p:24-24");
    BeaconsPlugin.addBeaconLayoutForAndroid("m:2-3=beac,i:4-19,i:20-21,i:22-23,p:24-24,d:25-25");
    BeaconsPlugin.setForegroundScanPeriodForAndroid(foregroundScanPeriod: 2200, foregroundBetweenScanPeriod: 10);
    BeaconsPlugin.setBackgroundScanPeriodForAndroid(backgroundScanPeriod: 2200, backgroundBetweenScanPeriod: 10);
  }
}

// 비콘 시작
Future<void> startBeacon() async {
  await _setBeacon();
  await BeaconsPlugin.startMonitoring();
}

// 비콘 멈춤
Future<void> stopBeacon() async {
  await BeaconsPlugin.stopMonitoring();
}
