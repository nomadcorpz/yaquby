import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:yaquby/models/category_response_model.dart';
import 'package:yaquby/models/login_response_model.dart';
import 'package:yaquby/models/rep_sales_target_response_model.dart';
import '../models/brand_response_model.dart';
import '../models/product_response_model.dart';
import 'api_services.dart';

class DataManagerProvider with ChangeNotifier {
  List<Product> products = [];
  List<ProductBrand> productBrands = [];
  List<ProductCategory> productCategories = [];

  RepSalesTargetResponseModel repTargets = RepSalesTargetResponseModel(
    success: false, // Set to false or any default value
    message: '', // Set to an empty string or any default value
    data: [], // Set to an empty List
  );

  var longitude;
  var latitude;
  String? cityName;
  String? address;
  String? subcity;

  String user = "";
  LoginResponseModel? loginResponse_DM;
  Userlocations? selectedLocation_DM;

  // Singleton pattern to ensure a single instance
  static final DataManagerProvider _instance = DataManagerProvider._internal();

  factory DataManagerProvider() {
    return _instance;
  }

  DataManagerProvider._internal();
  void updateProductSellingPrice(int productIndex, double newSellingPrice) {
    if (productIndex >= 0 && productIndex < products.length) {
      // Update the selling price of the product at the specified index
      products[productIndex].sellingPrice = newSellingPrice;

      // Notify listeners to rebuild the UI
      notifyListeners();
    }
  }

  bool hasAdminRole() {
    if (loginResponse_DM != null) {
      final roles = loginResponse_DM!.data.userroles;
      for (var i = 0; i < roles.length; i++) {}
      return roles.any((role) => role.roleName == 'Admin' || role.roleName == 'SuperAdmin');
    }
    return false;
  }

  // Fetch products by stock name and update the data
  // Future<void> fetchProductsByStockWithName(String productName) async {
  //   try {
  //     final response = await APIService.fetchProductsByStocksWithName(productName);
  //     if (kDebugMode) {
  //       print("API Response: $response");
  //     }

  //     if (response.success) {
  //       if (kDebugMode) {
  //         print("API Call Succeeded: ${response.productsData}");
  //       }
  //       products = response.productsData;
  //       notifyListeners(); // Notify listeners about the data change
  //     } else {
  //       if (kDebugMode) {
  //         print("API Call Failed: ${response}");
  //       }
  //       // Handle failure, show an error message
  //       // You may want to handle this differently depending on your UI structure.
  //     }
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print('Exception occurred: $e');
  //     }
  //     // Handle the exception gracefully or perform any necessary actions
  //   }
  // }

// Function to fetch products by stock name and retry on error

  Future<void> fetchProductsByStockWithName(String productName) async {
    const maxRetries = 100; // Maximum number of retry attempts
    int retryCount = 0;

    while (retryCount < maxRetries) {
      Fluttertoast.showToast(
        msg: 'Please Wait fetching data...',
        toastLength: Toast.LENGTH_SHORT,
      );
      try {
        final response = await APIService.fetchProductsByStocksWithName(productName);
        if (kDebugMode) {
          print("API Response: $response");
        }
        if (response.success) {
          if (kDebugMode) {
            print("API Call Succeeded: ${response.productsData}");
            Fluttertoast.showToast(
              msg: 'Products fetched',
              toastLength: Toast.LENGTH_SHORT,
            );
          }
          products = response.productsData;
          notifyListeners(); // Notify listeners about the data change
          break; // Exit the loop on success
        } else {
          if (kDebugMode) {
            print("API Call Failed: ${response}");
          }
          // Handle failure, show an error message
          // You may want to handle this differently depending on your UI structure.
          retryCount++; // Increment the retry count
        }
      } catch (e) {
        if (kDebugMode) {
          print('Exception occurred: $e');
        }
        // Handle the exception gracefully or perform any necessary actions
        retryCount++; // Increment the retry count
      }
    }

    if (retryCount == maxRetries) {
      // Handle the case where all retries failed
      print('All retry attempts failed');
      // You may want to show an error message to the user or take other actions
    }
  }

  Future<void> fetchAttendanceDetails(employeeID, fromDate, toDate) async {
    const maxRetries = 100; // Maximum number of retry attempts
    int retryCount = 0;

    while (retryCount < maxRetries) {
      Fluttertoast.showToast(
        msg: 'Please Wait fetching data...',
        toastLength: Toast.LENGTH_SHORT,
      );
      try {
        final response = await APIService.getAttendanceDetails(employeeID, fromDate, toDate);
        if (kDebugMode) {
          print("API Response: $response");
        }
        if (response.success) {
          if (kDebugMode) {
            //  print("API Call Succeeded: ${response.productsData}");
            Fluttertoast.showToast(
              msg: 'Products fetched',
              toastLength: Toast.LENGTH_SHORT,
            );
          }
          // products = response.productsData;
          notifyListeners(); // Notify listeners about the data change
          break; // Exit the loop on success
        } else {
          if (kDebugMode) {
            print("API Call Failed: ${response}");
          }
          // Handle failure, show an error message
          // You may want to handle this differently depending on your UI structure.
          retryCount++; // Increment the retry count
        }
      } catch (e) {
        if (kDebugMode) {
          print('Exception occurred: $e');
        }
        // Handle the exception gracefully or perform any necessary actions
        retryCount++; // Increment the retry count
      }
    }

    if (retryCount == maxRetries) {
      // Handle the case where all retries failed
      print('All retry attempts failed');
      // You may want to show an error message to the user or take other actions
    }
  }

  // Fetch all brands and update the data
  Future<void> fetchAllBrands() async {
    try {
      ProductBrandResponseModel response = await APIService.fetchAllBrands();
      if (response.success) {
        productBrands = response.productsBrandsData;
        notifyListeners(); // Notify listeners about the data change
      } else {
        // Handle failure, show an error message
        // You may want to handle this differently depending on your UI structure.
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception occurred: $e');
      }
      // Handle the exception gracefully or perform any necessary actions
      rethrow; // Rethrow the exception
    }
  }

  Future<void> fetchAllCategories() async {
    try {
      ProductCategoryResponseModel response = await APIService.fetchAllCategories();
      if (response.success) {
        productCategories = response.productsCategoriesData;
        notifyListeners(); // Notify listeners about the data change
      } else {
        // Handle failure, show an error message
        // You may want to handle this differently depending on your UI structure.
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception occurred: $e');
      }
      // Handle the exception gracefully or perform any necessary actions
      rethrow; // Rethrow the exception
    }
  }

  Future<void> fetchReptargets(employeeID) async {
    const maxRetries = 10; // Maximum number of retry attempts
    int retryCount = 0;

    while (retryCount < maxRetries) {
      Fluttertoast.showToast(
        msg: 'Please Wait fetching data...',
        toastLength: Toast.LENGTH_SHORT,
      );
      try {
        final response = await APIService.getRepSalesTargetDetails(employeeID);
        if (kDebugMode) {
          print("API Response: $response");
        }
        if (response.success) {
          if (kDebugMode) {
            //  print("API Call Succeeded: ${response.productsData}");
            Fluttertoast.showToast(
              msg: 'Products fetched',
              toastLength: Toast.LENGTH_SHORT,
            );
          }
          repTargets = response;
          notifyListeners(); // Notify listeners about the data change
          break; // Exit the loop on success
        } else {
          if (kDebugMode) {
            print("API Call Failed: ${response}");
          }
          // Handle failure, show an error message
          // You may want to handle this differently depending on your UI structure.
          retryCount++; // Increment the retry count
        }
      } catch (e) {
        if (kDebugMode) {
          print('Exception occurred: $e');
        }
        // Handle the exception gracefully or perform any necessary actions
        retryCount++; // Increment the retry count
      }
    }

    if (retryCount == maxRetries) {
      // Handle the case where all retries failed
      print('All retry attempts failed');
      // You may want to show an error message to the user or take other actions
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      // Request permission to access location
      bool serviceEnabled;
      LocationPermission permission;
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled
        return;
      }
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return;
      }
      if (permission == LocationPermission.denied) {
        // Request permission to access location
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
          // Permissions are denied, handle appropriately.
          return;
        }
      }
      // Get the current position
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      // Get the latitude and longitude
      //
      longitude = position.longitude;
      latitude = position.latitude;
      // Get the city name or address
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude!, longitude!);
      Placemark currentPlace = placemarks[0];

      cityName = currentPlace.locality;
      address = currentPlace.street;
      subcity = currentPlace.postalCode;
      print('Latitude: $latitude');
      print('Longitude: $longitude');
      print('City: $cityName');
      print('Address: $address');
      print('Subcity: $subcity');
    } catch (e) {
      print('Error: $e');
    }
  }
}

// You can create a function to easily access the DataManagerProvider instance
DataManagerProvider dataManagerProvider(BuildContext context) => Provider.of<DataManagerProvider>(context, listen: false);
