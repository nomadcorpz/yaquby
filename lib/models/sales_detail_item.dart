class SalesDetailItem {
  final String itemId;
  final String itemName;
  final String itemImage;
  final double itemCost;
  final double itemPrice;
  final double itemDiscount;
  final double itemNetAmount;
  final int itemQty;
  final String itemBrandId; // New field
  final String itemBrandName; // New field
  final String itemCategoryId; // New field
  final String itemCategoryName; // New field

  SalesDetailItem({
    required this.itemId,
    required this.itemName,
    required this.itemImage,
    required this.itemCost,
    required this.itemPrice,
    required this.itemDiscount,
    required this.itemNetAmount,
    required this.itemQty,
    required this.itemBrandId, // New field
    required this.itemBrandName, // New field
    required this.itemCategoryId, // New field
    required this.itemCategoryName, // New field
  });

  Map<String, dynamic> toJson() {
    return {
      "itemId": itemId,
      "itemName": itemName,
      "itemImage": itemImage,
      "itemCost": itemCost,
      "itemPrice": itemPrice,
      "itemDiscount": itemDiscount,
      "itemNetAmount": itemNetAmount,
      "itemQty": itemQty,
      "itemBrandId": itemBrandId, // New field
      "itemBrandName": itemBrandName, // New field
      "itemCategoryId": itemCategoryId, // New field
      "itemCategoryName": itemCategoryName, // New field
    };
  }
}

class SalesData {
  final String docDate;
  final String salesRepId;
  final double totalCost;
  final double grossAmount;
  final double discountAmount;
  final double netAmount;
  final int totalProducts;
  final int locationId;
  final double longitude;
  final double latitude;
  final String deviceMAC;
  final String deviceDateTime;
  final String currentUser;
  final List<SalesDetailItem> salesDetails;

  SalesData({
    required this.docDate,
    required this.salesRepId,
    required this.totalCost,
    required this.grossAmount,
    required this.discountAmount,
    required this.netAmount,
    required this.totalProducts,
    required this.locationId,
    required this.longitude,
    required this.latitude,
    required this.deviceMAC,
    required this.deviceDateTime,
    required this.currentUser,
    required this.salesDetails,
  });

  Map<String, dynamic> toJson() {
    return {
      "docDate": docDate,
      "salesRepId": salesRepId,
      "totalCost": totalCost,
      "grossAmount": grossAmount,
      "discountAmount": discountAmount,
      "netAmount": netAmount,
      "totalProducts": totalProducts,
      "locationId": locationId,
      "longitude": longitude,
      "latitude": latitude,
      "deviceMAC": deviceMAC,
      "deviceDateTime": deviceDateTime,
      "currentUser": currentUser,
      "salesDetails": salesDetails.map((item) => item.toJson()).toList(),
    };
  }
}
