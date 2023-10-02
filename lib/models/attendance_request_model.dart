// class AttendanceRequestModel {
//   AttendanceRequestModel({
//     required this.date,
//     required this.checkInTime,
//     required this.checkOutTime,
//     required this.locationId,
//     required this.longitude,
//     required this.latitude,
//     required this.employeeId,
//     required this.deviceMAC,
//     required this.deviceDateTime,
//   });

//   late final String date;
//   late final String checkInTime;
//   late final String checkOutTime;
//   late final int locationId;
//   late final int longitude;
//   late final int latitude;
//   late final String employeeId;
//   late final String deviceMAC;
//   late final String deviceDateTime;

//   AttendanceRequestModel.fromJson(Map<String, dynamic> json){
//     date = json['date'];
//     checkInTime = json['checkInTime'];
//     checkOutTime = json['checkOutTime'];
//     locationId = json['locationId'];
//     longitude = json['longitude'];
//     latitude = json['latitude'];
//     employeeId = json['employeeId'];
//     deviceMAC = json['deviceMAC'];
//     deviceDateTime = json['deviceDateTime'];
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['date'] = date;
//     _data['checkInTime'] = checkInTime;
//     _data['checkOutTime'] = checkOutTime;
//     _data['locationId'] = locationId;
//     _data['longitude'] = longitude;
//     _data['latitude'] = latitude;
//     _data['employeeId'] = employeeId;
//     _data['deviceMAC'] = deviceMAC;
//     _data['deviceDateTime'] = deviceDateTime;
//     return _data;
//   }
// }

class AttendanceRequestModel {
  AttendanceRequestModel({
    DateTime? date,
    DateTime? checkInTime,
    DateTime? checkOutTime,
    int? locationId,
    double? longitude,
    double? latitude,
    String? employeeId,
    String? deviceMAC,
    DateTime? deviceDateTime,
  })  : date = date ?? DateTime.now(),
        checkInTime = checkInTime ?? DateTime.now(),
        checkOutTime = checkOutTime != null ? checkOutTime : null,
        locationId = locationId ?? 0,
        longitude = longitude ?? 0,
        latitude = latitude ?? 0,
        employeeId = employeeId ?? '',
        deviceMAC = deviceMAC ?? '',
        deviceDateTime = deviceDateTime ?? DateTime.now();

  late final DateTime date;
  late final DateTime checkInTime;
  late final DateTime? checkOutTime;
  late final int locationId;
  late final double longitude;
  late final double latitude;
  late final String employeeId;
  late final String deviceMAC;
  late final DateTime deviceDateTime;

  AttendanceRequestModel.fromJson(Map<String, dynamic> json) {
    date = DateTime.tryParse(json['date'] ?? '') ?? DateTime.now();
    checkInTime = DateTime.tryParse(json['checkInTime'] ?? '') ?? DateTime.now();
    checkOutTime = DateTime.tryParse(json['checkOutTime'] ?? '') ?? null;
    locationId = json['locationId'] ?? 0;
    longitude = json['longitude'] ?? 0.0;
    latitude = json['latitude'] ?? 0.0;
    employeeId = json['employeeId'] ?? '';
    deviceMAC = json['deviceMAC'] ?? '';
    deviceDateTime = DateTime.tryParse(json['deviceDateTime'] ?? '') ?? DateTime.now();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['date'] = date.toIso8601String();
    _data['checkInTime'] = checkInTime.toIso8601String();
    _data['checkOutTime'] = checkOutTime?.toIso8601String(); // Use ?. to handle potential null value
    _data['locationId'] = locationId;
    _data['longitude'] = longitude;
    _data['latitude'] = latitude;
    _data['employeeId'] = employeeId;
    _data['deviceMAC'] = deviceMAC;
    _data['deviceDateTime'] = deviceDateTime.toIso8601String();
    return _data;
  }
}
