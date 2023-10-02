import 'dart:convert';
import 'product_response_model.dart';

class ProductCategory {
  final String productCategoryId;
  final String productCategoryName;

  ProductCategory({
    required this.productCategoryId,
    required this.productCategoryName,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      productCategoryId: json['Product_Category_Id'],
      productCategoryName: json['Product_Category_Name'],
    );
  }
}

List<ProductCategory> productCategoryResponseJson(String responseBody) {
  final preprocessedData = preprocessJsonData(responseBody);
  final parsed = json.decode(preprocessedData) as List<dynamic>;
  return parsed.map<ProductCategory>((json) => ProductCategory.fromJson(json)).toList();
}

class ProductCategoryResponseModel {
  final bool success;
  final List<ProductCategory> productsCategoriesData;

  ProductCategoryResponseModel({
    required this.success,
    required this.productsCategoriesData,
  });
}
