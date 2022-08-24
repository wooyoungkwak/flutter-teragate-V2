import 'dart:convert';

import 'package:teragate/config/env.dart';

LoginInfo resultInfoFromJson(String str) => LoginInfo.fromJson(json.decode(str));

String resultInfoToJson(LoginInfo loginInfo) => json.encode(loginInfo.toJson());

class LoginInfo {
  LoginInfo(this.success, this.data, this.message, this.tokenInfo);

  bool? success;
  String? message;
  Map<String, dynamic>? data = {};
  TokenInfo? tokenInfo;

  static LoginInfo fromJson(Map<String, dynamic> json) {
    TokenInfo tokenInfo = TokenInfo(accessToken: json["accessToken"], refreshToken: json["refreshToken"], isUpdated: true);
    return LoginInfo(json["success"], json["data"], "", tokenInfo);
  }

  static LoginInfo fromJsonByFail(Map<String, dynamic> json) => LoginInfo(json["success"], {}, Env.MSG_LOGIN_FAIL, null);

  Map<String, dynamic> toJson() => {"success": success, "data": data};
}

class WorkInfo {
  bool success;
  String message;
  int work;

  WorkInfo({required this.success, required this.message, required this.work});

  static WorkInfo fromJson(Map<String, dynamic> json) {
    if (json["success"]) {
      return WorkInfo(success: json["success"], message: "", work:json["work"]);
    } else {
      return WorkInfo(success: json["success"], message: json["message"] == "exist" ? Env.MSG_GET_IN_EXIST : json["message"], work: 0);
    }
  }

  Map<String, dynamic> toJson() => {"success": success};
}

class TokenInfo {
  bool isUpdated;
  String accessToken;
  String refreshToken;
  String? message;

  TokenInfo({required this.accessToken, required this.refreshToken, this.message, required this.isUpdated});

  String getAccessToken() {
    return accessToken;
  }

  String getRefreshToken() {
    return refreshToken;
  }

  String? getMessage() {
    return message;
  }

  void setAccessToken(String accessToken) {
    this.accessToken = accessToken;
  }

  void setRefreshToken(String refreshToken) {
    this.refreshToken = refreshToken;
  }
}
