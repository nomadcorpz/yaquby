import 'dart:convert';

AttendanceResponseModel attendanceResponseJson(String str) => AttendanceResponseModel.fromJson(json.decode(str));

class AttendanceResponseModel {
  AttendanceResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });
  late final bool success;
  late final String message;
  late final List<Data> data;

  AttendanceResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = List.from(json['data']).map((e) => Data.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['message'] = message;
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Data {
  Data({
    required this.attendanceId,
    required this.date,
    required this.checkInTime,
    required this.checkOutTime,
  });
  late final int attendanceId;
  late final String date;
  late final String checkInTime;
  late final String? checkOutTime;

  Data.fromJson(Map<String, dynamic> json) {
    attendanceId = json['attendanceId'];
    date = json['date'];
    checkInTime = json['checkInTime'];
    checkOutTime = json['checkOutTime'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['attendanceId'] = attendanceId;
    _data['date'] = date;
    _data['checkInTime'] = checkInTime;
    _data['checkOutTime'] = checkOutTime;
    return _data;
  }
}
