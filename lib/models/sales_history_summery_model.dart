import 'dart:convert';

SalesSummaryResponse salesSummaryResponseJson(String str) =>
    SalesSummaryResponse.fromJson(json.decode(str));

class SalesSummaryResponse {
  SalesSummaryResponse({
    required this.success,
    required this.message,
    required this.data,
  });
  late final bool success;
  late final String message;
  late final List<SalesSummaryData> data;

  SalesSummaryResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = List.from(json['data']).map((e) => SalesSummaryData.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['message'] = message;
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class SalesSummaryData {
  SalesSummaryData({
    required this.id,
    required this.docDate,
    required this.totalCost,
    required this.grossAmount,
    required this.discountAmount,
    required this.netAmount,
    required this.totalProducts,
  });
  late final int id;
  late final String docDate;
  late final double totalCost;
  late final double grossAmount;
  late final double discountAmount;
  late final double netAmount;
  late final int totalProducts;

  SalesSummaryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    docDate = json['docDate'];
    totalCost = json['totalCost'].toDouble();
    grossAmount = json['grossAmount'].toDouble();
    discountAmount = json['discountAmount'].toDouble();
    netAmount = json['netAmount'].toDouble();
    totalProducts = json['totalProducts'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['docDate'] = docDate;
    _data['totalCost'] = totalCost;
    _data['grossAmount'] = grossAmount;
    _data['discountAmount'] = discountAmount;
    _data['netAmount'] = netAmount;
    _data['totalProducts'] = totalProducts;
    return _data;
  }
}
