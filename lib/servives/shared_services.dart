import 'dart:convert';

import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:flutter/material.dart';
import 'package:yaquby/models/attendance_request_model.dart';

import '../models/login_response_model.dart';
import 'token_manager.dart';

class SharedService {
  static Future<bool> isLoggedIn() async {
    var isKeyExist = await APICacheManager().isAPICacheKeyExist("login_details");
    return isKeyExist;
  }
  static Future<bool> isLocationSelected() async {
    var isKeyExist = await APICacheManager().isAPICacheKeyExist("selected_location");
    return isKeyExist;
  }

  static Future<LoginResponseModel?> loginDetails() async {
    var isKeyExist = await APICacheManager().isAPICacheKeyExist("login_details");

    if (isKeyExist) {
      var cacheData = await APICacheManager().getCacheData("login_details");

      return loginResponseJson(cacheData.syncData);
    }
    return null;
  }
  static Future<String?> getUsername() async {
    var isKeyExist = await APICacheManager().isAPICacheKeyExist("user_name");
    if (isKeyExist) {
      String cacheData = (await APICacheManager().getCacheData("user_name")) as String;

      return cacheData;
    }
    return null;
  }

  static Future<void> setLoginDetails(LoginResponseModel model , userName) async {
    DateTime expirationTime = DateTime.parse(model.data.expires);
    TokenManager().expirationTime = expirationTime;

    APICacheDBModel cacheDBModel1 = APICacheDBModel(
      key: "user_name",
      syncData: userName ,
    );
    await APICacheManager().addCacheData(cacheDBModel1);

    APICacheDBModel cacheDBModel = APICacheDBModel(
      key: "login_details",
      syncData: jsonEncode(model.toJson()),
    );
    await APICacheManager().addCacheData(cacheDBModel);
  }

  static Future<void> setPostedAttendance(AttendanceRequestModel model) async {
    APICacheDBModel cacheDBModel = APICacheDBModel(
      key: "current_attendance",
      syncData: jsonEncode(model.toJson()),
    );
    await APICacheManager().addCacheData(cacheDBModel);
  }

  static Future<AttendanceRequestModel?> getPostedAttendance() async {
    var isKeyExist = await APICacheManager().isAPICacheKeyExist("current_attendance");
    if (isKeyExist) {
      var cacheData = await APICacheManager().getCacheData("current_attendance");
      print(AttendanceRequestModel.fromJson(json.decode(cacheData.syncData)));
      return AttendanceRequestModel.fromJson(json.decode(cacheData.syncData));
    }
    return null;
  }

  static Future<void> logout(BuildContext context) async {
    await APICacheManager().deleteCache("login_details");
    await APICacheManager().deleteCache("selected_location");
    await APICacheManager().deleteCache("current_attendance");

    // ignore: use_build_context_synchronously
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (route) => false,
    );
  }

  static Future<Userlocations?> getSelectedUserLocation() async {
    var isKeyExist = await APICacheManager().isAPICacheKeyExist("selected_location");
    if (isKeyExist) {
      var cacheData = await APICacheManager().getCacheData("selected_location");
      print(Userlocations.fromJson(json.decode(cacheData.syncData)));
      return Userlocations.fromJson(json.decode(cacheData.syncData));
    }
    return null;
  }

  static Future<void> setSelectedLocationToCasheData(Userlocations userlocation) async {
    APICacheDBModel cacheDBModel = APICacheDBModel(
      key: "selected_location",
      syncData: jsonEncode(userlocation.toJson()),
    );
    await APICacheManager().addCacheData(cacheDBModel);
  }
}
