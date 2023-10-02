import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:yaquby/models/attendance_response_model.dart';
import 'package:yaquby/models/brand_response_model.dart';
import 'package:yaquby/models/category_response_model.dart';
import 'package:yaquby/models/login_request_model.dart';
import 'package:yaquby/models/product_response_model.dart';
import 'package:yaquby/models/rep_sales_target_response_model.dart';
import 'package:yaquby/models/sales_detail_item.dart';
import 'package:yaquby/models/sales_history_summery_model.dart';
import 'package:yaquby/servives/global_variables.dart';
import '../config.dart';
import '../models/attendance_request_model.dart';
import '../models/login_response_model.dart';
import '../models/sales_history_detailed_doc_response.dart';
import 'shared_services.dart';

class APIService {
  static var client = http.Client();

  static Future<bool> login(LoginRequestModel model) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.http(Config.apiURL, Config.loginAPI);

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );

    try {
      switch (response.statusCode) {
        case 200:
          await SharedService.setLoginDetails(loginResponseJson(response.body), model.username);
          DataManagerProvider dataManagerProvider = DataManagerProvider();
          dataManagerProvider.user = model.username;
          return true;
        case 400:
          Fluttertoast.showToast(
            msg: 'Bad request',
            toastLength: Toast.LENGTH_SHORT,
          );
          throw Exception('Bad request');
        case 401:
          Fluttertoast.showToast(
            msg: 'Unauthorized',
            toastLength: Toast.LENGTH_SHORT,
          );
          throw Exception('Unauthorized');
        default:
          Fluttertoast.showToast(
            msg: 'Failed to fetch attendance details',
            toastLength: Toast.LENGTH_SHORT,
          );
          return false;
      }
    } catch (e) {
      print('Exception occurred: $e');
      return false;
      //// Handle the exception gracefully or perform any necessary actions
    }
  }

  static Future<bool> currentInAndOut(AttendanceRequestModel model) async {
    var loginDetails = await SharedService.loginDetails();
    Map<String, String> requestHeaders = {'Content-Type': 'application/json', 'Authorization': 'Bearer ${loginDetails!.data.token}'};

    var url = Uri.http(Config.apiURL, Config.postAttendanceDetailsnAPI);

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );
    // Print the data before making the API call
    print('Sending the following data to the API:');
    print(jsonEncode(model.toJson()));
    try {
      switch (response.statusCode) {
        case 200:
          print("200 Success");
          await SharedService.setPostedAttendance(model);
          return true;
        case 400:
          print("400 'Bad request");
          Fluttertoast.showToast(
            msg: 'Bad request',
            toastLength: Toast.LENGTH_SHORT,
          );
          throw Exception('Bad request');
        case 401:
          print("401 Unauthorized");
          Fluttertoast.showToast(
            msg: 'Unauthorized',
            toastLength: Toast.LENGTH_SHORT,
          );

          throw Exception('Unauthorized');
        default:
          print("default - ${response.statusCode}");
          Fluttertoast.showToast(
            msg: 'Failed to fetch attendance details',
            toastLength: Toast.LENGTH_SHORT,
          );
          return false;
      }
    } catch (e) {
      print('Exception occurred: $e');
      return false;
      //// Handle the exception gracefully or perform any necessary actions
    }
  }

  static Future<AttendanceResponseModel> getAttendanceDetails(String employeeId, String fromDate, String toDate) async {
    var loginDetails = await SharedService.loginDetails();
    Map<String, String> requestHeaders = {'Content-Type': 'application/json', 'Authorization': 'Bearer ${loginDetails!.data.token}'};

    AttendanceResponseModel returnEpmtyObject = AttendanceResponseModel(
      success: false,
      message: '',
      data: [],
    );

    var url = Uri.http(Config.apiURL.replaceFirst('https://', ''), Config.getAttendanceDetailsAPI, {
      // var url = Uri.https(Config.apiURL, Config.getAttendanceDetailsAPI, {
      'employeeId': employeeId,
      'fromDate': fromDate,
      'toDate': toDate,
    });

    print(url);
    try {
      var response = await client.get(
        url,
        headers: requestHeaders,
      );
      switch (response.statusCode) {
        case 200:
          Fluttertoast.showToast(
            msg: 'Data fetched',
            toastLength: Toast.LENGTH_SHORT,
          );

          return attendanceResponseJson(response.body);
        case 400:
          Fluttertoast.showToast(
            msg: 'Bad request',
            toastLength: Toast.LENGTH_SHORT,
          );
          throw Exception('Bad request');
        case 401:
          Fluttertoast.showToast(
            msg: 'Unauthorized',
            toastLength: Toast.LENGTH_SHORT,
          );
          throw Exception('Unauthorized');
        case 500:
          Fluttertoast.showToast(
            msg: 'Internal Server Error',
            toastLength: Toast.LENGTH_SHORT,
          );
          throw Exception('Internal Server Error');
        default:
          Fluttertoast.showToast(
            msg: 'Failed to fetch attendance details',
            toastLength: Toast.LENGTH_SHORT,
          );
          throw Exception('Failed to fetch attendance details');
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Failed to fetch attendance details',
        toastLength: Toast.LENGTH_SHORT,
      );
      return returnEpmtyObject; // or handle the error in a different way
    }
  }

  static Future<RepSalesTargetResponseModel> getRepSalesTargetDetails(String employeeId) async {
    var loginDetails = await SharedService.loginDetails();
    Map<String, String> requestHeaders = {'Content-Type': 'application/json', 'Authorization': 'Bearer ${loginDetails!.data.token}'};
    RepSalesTargetResponseModel returnEpmtyObject = RepSalesTargetResponseModel(
      success: false,
      message: '',
      data: [],
    );

    var url = Uri.http(Config.apiURL.replaceFirst('https://', ''), Config.getRepSalesTarget, {
      // var url = Uri.https(Config.apiURL, Config.getAttendanceDetailsAPI, {
      'salesRepId': employeeId,
    });

    print(url);
    try {
      var response = await client.get(
        url,
        headers: requestHeaders,
      );
      switch (response.statusCode) {
        case 200:
          print("200");
          Fluttertoast.showToast(
            msg: 'Data fetched',
            toastLength: Toast.LENGTH_SHORT,
          );
          return repSalesTargetResponseJson(response.body);
        case 400:
          print("400");
          Fluttertoast.showToast(
            msg: 'Bad request',
            toastLength: Toast.LENGTH_SHORT,
          );
          throw Exception('Bad request');
        case 401:
          print("401");
          Fluttertoast.showToast(
            msg: 'Unauthorized',
            toastLength: Toast.LENGTH_SHORT,
          );
          throw Exception('Unauthorized');

        case 500:
          Fluttertoast.showToast(
            msg: 'Internal Server Error',
            toastLength: Toast.LENGTH_SHORT,
          );
          throw Exception('Internal Server Error');
        default:
          print("default");
          Fluttertoast.showToast(
            msg: 'Failed to fetch target detail',
            toastLength: Toast.LENGTH_SHORT,
          );
          throw Exception('Failed to fetch targets detail');
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Failed to fetch targets details',
        toastLength: Toast.LENGTH_SHORT,
      );
      return returnEpmtyObject; // or handle the error in a different way
    }
  }

//= {'Content-Type': 'application/json', 'Authorization': 'Bearer ${loginDetails!.data.token}'};
  static Future<bool> saveSalesDetails(SalesData salesData) async {
    var loginDetails = await SharedService.loginDetails();
    Map<String, String> requestHeaders = {'Content-Type': 'application/json', 'Authorization': 'Bearer ${loginDetails!.data.token}'};
    var url = Uri.http(Config.apiURL, Config.postSalesData);
// Print the data before making the API call
    print('Sending the following data to the API:');
    print(jsonEncode(salesData.toJson()));
    try {
      var response = await client.post(
        url,
        headers: requestHeaders,
        body: jsonEncode(salesData.toJson()), // Convert SalesData to JSON
      );
      switch (response.statusCode) {
        case 200:
          // Handle a successful response
          print("200");
          return true;
        case 400:
          print("400");
          return false;
        case 404:
          print("404");
          return false;
        case 500:
          print("500");
          return false;
        // ... other cases ...
        default:
          print(response.statusCode);
          // Handle other response codes or errors
          print("DEFAULT ERROR");
          return false;
      }
    } catch (e) {
      print('Exception occurred: $e');
      return false;
      // Handle the exception gracefully or perform any necessary actions
    }
  }

  static Future<ProductResponseModel> fetchProductsByBrand(String brand) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.http(Config.apiURLYaquby, 'product_by_brand', {
      'USER': 'SUPER',
      'PASS': 'SUPER',
      'product_brand': brand,
    });
    try {
      var response = await client.get(
        url,
        headers: requestHeaders,
      );
      switch (response.statusCode) {
        case 200:
          // Parse the response body into a list of Product objects
          List<Product> products = productResponseJson(response.body);
          // Create a ProductResponseModel with the parsed list of products
          return ProductResponseModel(success: true, productsData: products);

        case 400:
          Fluttertoast.showToast(
            msg: 'Bad request',
            toastLength: Toast.LENGTH_SHORT,
          );
          throw Exception('Bad request');
        case 401:
          Fluttertoast.showToast(
            msg: 'Unauthorized product details',
            toastLength: Toast.LENGTH_SHORT,
          );
          throw Exception('Unauthorized product details');
        case 500:
          Fluttertoast.showToast(
            msg: 'Internal Server Error',
            toastLength: Toast.LENGTH_SHORT,
          );
          throw Exception('Internal Server Error');
        default:
          Fluttertoast.showToast(
            msg: 'Failed to fetch product details',
            toastLength: Toast.LENGTH_SHORT,
          );
          throw Exception('Failed to fetch product details');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Exception occurred: $e');
      Fluttertoast.showToast(
        msg: 'An error occurred while fetching products',
        toastLength: Toast.LENGTH_SHORT,
      );
      throw Exception('An error occurred while fetching products');
    }
  }

  static Future<ProductResponseModel> fetchProductsByStocksWithName(String productName) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.http(Config.apiURLYaquby, 'stock_product', {
      'USER': 'SUPER',
      'PASS': 'SUPER',
      'product_name': productName,
    });
    try {
      var response = await client.get(
        url,
        headers: requestHeaders,
      );
      switch (response.statusCode) {
        case 200:
          // Parse the response body into a list of Product objects
          List<Product> products = productResponseJson(response.body);
          // Create a ProductResponseModel with the parsed list of products

          return ProductResponseModel(success: true, productsData: products);

        case 400:
          Fluttertoast.showToast(
            msg: 'Bad request',
            toastLength: Toast.LENGTH_SHORT,
          );
          throw Exception('Bad request');
        case 401:
          Fluttertoast.showToast(
            msg: 'Unauthorized product details',
            toastLength: Toast.LENGTH_SHORT,
          );
          throw Exception('Unauthorized product details');
        case 500:
          Fluttertoast.showToast(
            msg: 'Internal Server Error',
            toastLength: Toast.LENGTH_SHORT,
          );
          throw Exception('Internal Server Error');
        default:
          Fluttertoast.showToast(
            msg: 'Failed to fetch product details',
            toastLength: Toast.LENGTH_SHORT,
          );
          throw Exception('Failed to fetch product details');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Exception occurred: $e');
      Fluttertoast.showToast(
        msg: 'An error occurred while fetching products',
        toastLength: Toast.LENGTH_SHORT,
      );
      throw Exception('An error occurred while fetching products');
    }
  }

  static Future<ProductBrandResponseModel> fetchAllBrands() async {
    final Uri url = Uri.http(Config.apiURLYaquby, 'brand', {
      'USER': 'SUPER',
      'PASS': 'SUPER',
    });
    var response = await client.get(url);
    try {
      switch (response.statusCode) {
        case 200:
          if (kDebugMode) {
            print("200");
          }
          List<ProductBrand> brands = productBrandResponseJson(response.body);
          if (kDebugMode) {
            print(brands);
          }
          // Create a ProductResponseModel with the parsed list of products
          ProductBrandResponseModel pd = ProductBrandResponseModel(success: true, productsBrandsData: brands);
          if (kDebugMode) {
            print(brands);
          }
          return pd;
        case 400:
          Fluttertoast.showToast(
            msg: 'Bad request',
            toastLength: Toast.LENGTH_SHORT,
          );
          throw Exception('Bad request');
        case 401:
          Fluttertoast.showToast(
            msg: 'Unauthorized',
            toastLength: Toast.LENGTH_SHORT,
          );
          throw Exception('Unauthorized');
        case 500:
          Fluttertoast.showToast(
            msg: 'Internal Server Error',
            toastLength: Toast.LENGTH_SHORT,
          );
          throw Exception('Unauthorized');
        default:
          Fluttertoast.showToast(
            msg: 'Failed to fetch product brands',
            toastLength: Toast.LENGTH_SHORT,
          );
          return ProductBrandResponseModel(success: false, productsBrandsData: []);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception occurred: $e');
      }
      return ProductBrandResponseModel(success: false, productsBrandsData: []);
      // Handle the exception gracefully or perform any necessary actions
    }
  }

  static Future<ProductCategoryResponseModel> fetchAllCategories() async {
    final Uri url = Uri.http(Config.apiURLYaquby, 'category', {
      'USER': 'SUPER',
      'PASS': 'SUPER',
    });
    var response = await client.get(url);
    try {
      switch (response.statusCode) {
        case 200:
          if (kDebugMode) {
            print("200");
          }
          List<ProductCategory> categories = productCategoryResponseJson(response.body);
          if (kDebugMode) {
            print(categories);
          }
          // Create a ProductResponseModel with the parsed list of products
          ProductCategoryResponseModel pc = ProductCategoryResponseModel(success: true, productsCategoriesData: categories);
          if (kDebugMode) {
            print(categories);
          }
          return pc;
        case 400:
          Fluttertoast.showToast(
            msg: 'Bad request',
            toastLength: Toast.LENGTH_SHORT,
          );
          throw Exception('Bad request');
        case 401:
          Fluttertoast.showToast(
            msg: 'Unauthorized',
            toastLength: Toast.LENGTH_SHORT,
          );
          throw Exception('Unauthorized');
        default:
          Fluttertoast.showToast(
            msg: 'Failed to fetch product brands',
            toastLength: Toast.LENGTH_SHORT,
          );
          return ProductCategoryResponseModel(success: false, productsCategoriesData: []);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception occurred: $e');
      }
      return ProductCategoryResponseModel(success: false, productsCategoriesData: []);
      // Handle the exception gracefully or perform any necessary actions
    }
  }

  static Future<SalesSummaryResponse> getSalesSummeryList(String userid, String locationId, String startDate, String endDate) async {
    var loginDetails = await SharedService.loginDetails();
    Map<String, String> requestHeaders = {'Content-Type': 'application/json', 'Authorization': 'Bearer ${loginDetails!.data.token}'};

    SalesSummaryResponse returnEpmtyObject = SalesSummaryResponse(
      success: false,
      message: '',
      data: [],
    );

    var url = Uri.http(Config.apiURL.replaceFirst('https://', ''), Config.getSalesSummeryList, {
      // var url = Uri.https(Config.apiURL, Config.getAttendanceDetailsAPI, {
      'salesRepId': userid,
      'locationId': locationId,
      'fromDate': startDate,
      'toDate': endDate,
    });

    print(url);
    try {
      var response = await client.get(
        url,
        headers: requestHeaders,
      );
      switch (response.statusCode) {
        case 200:
          Fluttertoast.showToast(
            msg: 'Data fetched',
            toastLength: Toast.LENGTH_SHORT,
          );

          return salesSummaryResponseJson(response.body);

        case 400:
          Fluttertoast.showToast(
            msg: 'Bad request',
            toastLength: Toast.LENGTH_SHORT,
          );
          throw Exception('Bad request');
        case 401:
          Fluttertoast.showToast(
            msg: 'Unauthorized',
            toastLength: Toast.LENGTH_SHORT,
          );
          throw Exception('Unauthorized');
        case 500:
          Fluttertoast.showToast(
            msg: 'Internal Server Error',
            toastLength: Toast.LENGTH_SHORT,
          );
          throw Exception('Unauthorized');
        default:
          Fluttertoast.showToast(
            msg: 'Failed',
            toastLength: Toast.LENGTH_SHORT,
          );
          throw Exception('Failed');
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Failed to fetch history details',
        toastLength: Toast.LENGTH_SHORT,
      );
      return returnEpmtyObject; // or handle the error in a different way
    }
  }

  static Future<SalesDocDetailedResponse> getSalesSummeryDetailedDoc(String salesId) async {
    var loginDetails = await SharedService.loginDetails();
    Map<String, String> requestHeaders = {'Content-Type': 'application/json', 'Authorization': 'Bearer ${loginDetails!.data.token}'};

    SalesDocDetailedResponse returnEpmtyObject = SalesDocDetailedResponse(
      success: false,
      message: '',
      data: [],
    );

    var url = Uri.http(Config.apiURL.replaceFirst('https://', ''), Config.getSalesSummeryDetailed, {
      // var url = Uri.https(Config.apiURL, Config.getAttendanceDetailsAPI, {
      'salesId': salesId,
    });

    print(url);
    try {
      var response = await client.get(
        url,
        headers: requestHeaders,
      );
      switch (response.statusCode) {
        case 200:
          Fluttertoast.showToast(
            msg: 'Data fetched',
            toastLength: Toast.LENGTH_SHORT,
          );

          return salesDocDetailedResponseJson(response.body);

        case 400:
          Fluttertoast.showToast(
            msg: 'Bad request',
            toastLength: Toast.LENGTH_SHORT,
          );
          throw Exception('Bad request');
        case 401:
          Fluttertoast.showToast(
            msg: 'Unauthorized',
            toastLength: Toast.LENGTH_SHORT,
          );
          throw Exception('Unauthorized');
        case 500:
          Fluttertoast.showToast(
            msg: 'Internal Server Error',
            toastLength: Toast.LENGTH_SHORT,
          );
          throw Exception('Unauthorized');
        default:
          Fluttertoast.showToast(
            msg: 'Failed to fetch history details',
            toastLength: Toast.LENGTH_SHORT,
          );
          throw Exception('Failed to fetch history details');
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Failed to fetch history details',
        toastLength: Toast.LENGTH_SHORT,
      );
      return returnEpmtyObject; // or handle the error in a different way
    }
  }
}
