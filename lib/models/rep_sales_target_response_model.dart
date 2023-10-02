import 'dart:convert';

RepSalesTargetResponseModel repSalesTargetResponseJson(String str) =>
    RepSalesTargetResponseModel.fromJson(json.decode(str));

class RepSalesTargetResponseModel {
  RepSalesTargetResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  late final bool success;
  late final String message;
  late final List<RepSalesTargetData> data;

  RepSalesTargetResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = List<RepSalesTargetData>.from(
        json['data'].map((x) => RepSalesTargetData.fromJson(x)));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    data['data'] = List<dynamic>.from(this.data.map((x) => x.toJson()));
    return data;
  }
}

class RepSalesTargetData {
  RepSalesTargetData({
    required this.fromDate,
    required this.toDate,
    required this.targetAmount,
    required this.achievedAmount,
  });

  late final String fromDate;
  late final String toDate;
  late final double targetAmount;
  late final double achievedAmount;

  RepSalesTargetData.fromJson(Map<String, dynamic> json) {
    fromDate = json['fromDate'];
    toDate = json['toDate'];
    targetAmount = json['targetAmount'];
    achievedAmount = json['achievedAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fromDate'] = fromDate;
    data['toDate'] = toDate;
    data['targetAmount'] = targetAmount;
    data['achievedAmount'] = achievedAmount;
    return data;
  }
}
