import 'dart:convert';

SalesDocDetailedResponse salesDocDetailedResponseJson(String str) =>
    SalesDocDetailedResponse.fromJson(json.decode(str));

class SalesDocDetailedResponse {
  final bool success;
  final String message;
  final List<SalesDocDetailData> data;

  SalesDocDetailedResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory SalesDocDetailedResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> dataList = json['data'];
    final List<SalesDocDetailData> data = dataList
        .map((itemJson) => SalesDocDetailData.fromJson(itemJson))
        .toList();

    return SalesDocDetailedResponse(
      success: json['success'],
      message: json['message'],
      data: data,
    );
  }
}

class SalesDocDetailData {
  final String itemId;
  final String itemName;
  final String itemBrandId;
  final String itemBrandName;
  final String itemCategoryId;
  final String itemCategoryName;
  final String itemImage;
  final double itemCost;
  final double itemPrice;
  final double itemDiscount;
  final double itemNetAmount;
  final double itemQty;

  SalesDocDetailData({
    required this.itemId,
    required this.itemName,
    required this.itemBrandId,
    required this.itemBrandName,
    required this.itemCategoryId,
    required this.itemCategoryName,
    required this.itemImage,
    required this.itemCost,
    required this.itemPrice,
    required this.itemDiscount,
    required this.itemNetAmount,
    required this.itemQty,
  });

  factory SalesDocDetailData.fromJson(Map<String, dynamic> json) {
    return SalesDocDetailData(
      itemId: json['itemId'],
      itemName: json['itemName'],
      itemBrandId: json['itemBrandId'],
      itemBrandName: json['itemBrandName'],
      itemCategoryId: json['itemCategoryId'],
      itemCategoryName: json['itemCategoryName'],
      itemImage: json['itemImage'],
      itemCost: json['itemCost'].toDouble(),
      itemPrice: json['itemPrice'].toDouble(),
      itemDiscount: json['itemDiscount'].toDouble(),
      itemNetAmount: json['itemNetAmount'].toDouble(),
      itemQty: json['itemQty'].toDouble(),
    );
  }
}
