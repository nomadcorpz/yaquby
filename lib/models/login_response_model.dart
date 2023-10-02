import 'dart:convert';

LoginResponseModel loginResponseJson(String str) => LoginResponseModel.fromJson(json.decode(str));

class LoginResponseModel {
  LoginResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });
  late final bool success;
  late final String message;
  late final Data data;

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['message'] = message;
    _data['data'] = data.toJson();
    return _data;
  }
}

class Data {
  Data({
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.expires,
    required this.token,
    required this.userlocations,
    required this.userroles,
  });
  late final String userId;
  late final String expires;
  late final String userName;
  late final String userImage;
  late final String token;
  late final List<Userlocations> userlocations;
  late final List<Userroles> userroles;

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userName = json['userName'];
    userImage = json['userImage'];
    expires = json['expires'];
    token = json['token'];
    userlocations = List.from(json['userlocations']).map((e) => Userlocations.fromJson(e)).toList();
    userroles = List.from(json['userroles']).map((e) => Userroles.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['userId'] = userId;
    _data['userName'] =userName;
     _data['userImage'] =userImage;
    _data['expires'] = expires;
    _data['token'] = token;
    _data['userlocations'] = userlocations.map((e) => e.toJson()).toList();
    _data['userroles'] = userroles.map((e) => e.toJson()).toList();
    return _data;
  }
}

Userlocations userLocationJson(String str) => Userlocations.fromJson(json.decode(str));

class Userlocations {
  Userlocations({
    required this.locationId,
    required this.description,
  });
  late final int locationId;
  late final String description;

  Userlocations.fromJson(Map<String, dynamic> json) {
    locationId = json['locationId'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['locationId'] = locationId;
    _data['description'] = description;
    return _data;
  }
}

class Userroles {
  Userroles({
    required this.roleId,
    required this.roleName,
  });
  late final String roleId;
  late final String roleName;

  Userroles.fromJson(Map<String, dynamic> json) {
    roleId = json['roleId'];
    roleName = json['roleName'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['roleId'] = roleId;
    _data['roleName'] = roleName;
    return _data;
  }
}
