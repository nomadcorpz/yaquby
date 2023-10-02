import 'dart:convert';
import 'product_response_model.dart';

class ProductBrand {
  final String productBrandId;
  final String productBrandName;

  ProductBrand({
    required this.productBrandId,
    required this.productBrandName,
  });

  factory ProductBrand.fromJson(Map<String, dynamic> json) {
    return ProductBrand(
      productBrandId: json['Product_Brand_Id'],
      productBrandName: json['Product_Brand_Name'],
    );
  }
}



List<ProductBrand> productBrandResponseJson(String responseBody) {
  final preprocessedData = preprocessJsonData(responseBody);
  final parsed = json.decode(preprocessedData) as List<dynamic>;
  return parsed.map<ProductBrand>((json) => ProductBrand.fromJson(json)).toList();
}

class ProductBrandResponseModel {
  final bool success;
  final List<ProductBrand> productsBrandsData;

  ProductBrandResponseModel({
    required this.success,
    required this.productsBrandsData,
  });
}
