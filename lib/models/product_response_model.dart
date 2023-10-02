//     "product_id": "3410+1106+5103",
//      "barcode": "8021098003386",
//     "product_name": "BRN.SE3410 + FG1106 + SELS5103",
//     "product_category": "BRAUN PERSONAL CARE",
//     "product_brand": "BRAUN P&G",
//     "selling_price": 0,
//     "cost_price": 20.4652666666667,
//     "product_image_url": "http://192.10.164.45:8080/webpage?partno=3410+1106+5103"
//     "stock_on_hand": 5

// "product_id": "622356246187",
//   "barcode": "622356246187",
//   "product_name": "NINJA NUTRI SHARK IZ102ME ",
//   "product_category": "NUTRI NINJA HOUSEHOLD",
//   "product_brand": "NUTRI NINJA",
//   "selling_price": 65.364,
//   "cost_price": 49.1533453658537,
//   "product_image_url": "http://192.10.164.45:8080/webpage?partno=622356246187",
//   "stock_on_hand": 6
import 'dart:convert';

class CartItem {
  final Product product;
  int quantity;
  double discount;
  String discountType;
  bool isDiscountInvalid;
  CartItem(this.product, this.quantity, {this.discount = 0.0, this.discountType = 'Percentage', this.isDiscountInvalid = false});
}

class Product {
  final String productId;
  final String? barcode;
  final String productName;
  final String productCategory;
  final String productBrand;
  late double sellingPrice;
  final double costPrice;
  final String? productImageUrl;
  final int? stockOnHand;

  /// Date , User , Current Datetime , Product_List,
  Product({
    required this.productId,
    required this.barcode,
    required this.productName,
    required this.productCategory,
    required this.productBrand,
    required this.sellingPrice,
    required this.costPrice,
    required this.productImageUrl,
    required this.stockOnHand,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // print(json['barcode']);
    return Product(
      productId: json['product_id'],
      barcode: json['barcode'].toString().trim(),
      productName: json['product_name'],
      productCategory: json['product_category'],
      productBrand: json['product_brand'],
      sellingPrice: json['selling_price'].toDouble(),
      costPrice: json['cost_price'].toDouble(),
      productImageUrl: json['product_image_url'],
      stockOnHand: json['stock_on_hand'],
    );
  }
}

class ProductResponseModel {
  final bool success;
  final List<Product> productsData;

  ProductResponseModel({
    required this.success,
    required this.productsData,
  });
}

// List<Product> productResponseJson(String responseBody) {
//   final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
//   return parsed.map<Product>((json) => Product.fromJson(json)).toList();
// }

// List<Product> productResponseJson(String responseBody) {
//   final cleanedResponseBody = responseBody.trim(); // Remove leading and trailing spaces
//   final parsed = json.decode(cleanedResponseBody) as List<dynamic>;
//   return parsed.map<Product>((json) => Product.fromJson(json)).toList();
// }
// List<Product> productResponseJson(String responseBody) {
//   final cleanedResponseBody = responseBody.trim(); // Remove leading and trailing spaces
//   final parsed = jsonDecode(cleanedResponseBody) as List<dynamic>;
//   return parsed.map<Product>((json) => Product.fromJson(json)).toList();
// }

///////
String preprocessJsonData(String jsonData) {
  final cleanedData = jsonData.replaceAll(RegExp(r'[^\x20-\x7E]+'), ''); // Remove non-printable characters
  return cleanedData;
}

List<Product> productResponseJson(String responseBody) {
  final preprocessedData = preprocessJsonData(responseBody); // Preprocess the JSON data
  final parsed = json.decode(preprocessedData) as List<dynamic>;
  return parsed.map<Product>((json) => Product.fromJson(json)).toList();
}
///////

// List<Product> productResponseJson(String responseBody) {
//   final cleanedResponseBody = responseBody.replaceAll(RegExp(r'[^\x20-\x7E]+'), '');
//   final parsed = json.decode(cleanedResponseBody).cast<Map<String, dynamic>>();
//   return parsed.map<Product>((json) => Product.fromJson(json)).toList();
// }

// The Product model as defined earlier
