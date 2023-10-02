import 'package:flutter/material.dart'; // Import the SalesData class
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:yaquby/models/category_response_model.dart';
import 'package:yaquby/models/login_response_model.dart';
import 'package:yaquby/models/sales_detail_item.dart'; // Import the SalesDetailItem class
import 'package:yaquby/models/product_response_model.dart'; // Import your API service
import 'package:yaquby/servives/api_services.dart';
import 'package:yaquby/servives/shared_services.dart';
import 'package:yaquby/servives/token_manager.dart';
import '../../config.dart';
import '../../models/brand_response_model.dart';
import '../../servives/global_variables.dart';
import '../customWidgets/ProductImageWidget.dart';

class SalesSummaryScreen extends StatefulWidget {
  final List<CartItem> cartItems;

  const SalesSummaryScreen({
    super.key,
    required this.cartItems,
  });

  @override
  _SalesSummaryScreenState createState() => _SalesSummaryScreenState();
}

class _SalesSummaryScreenState extends State<SalesSummaryScreen> {
  DateTime selectedDate = DateTime.now();

  double totalSellingPrice = 0;
  int totalQuantities = 0;
  int totalUniqueItems = 0;
  double totalCostPrice = 0;
  double totalDiscountPrice = 0;
  double totalGrossAmount = 0;
  double totalNetAmount = 0;

  @override
  void initState() {
    super.initState();

    calculateTotals();
    getSavedData();
    TokenManager().setContext(context);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2023), // Adjust as needed
      lastDate: DateTime(2024), // Adjust as needed
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  LoginResponseModel? _loginResponse;
  Userlocations? _selectedLocation;

  String salesRepId = "0";
  int locationId = 0;
  late String userlocation = "selected_location";
  late DateTime _expirationTime;

  Future<void> getSavedData() async {
    _loginResponse = await SharedService.loginDetails();
    _selectedLocation = await SharedService.getSelectedUserLocation();

    if (_loginResponse != null) {
      setState(() {
        salesRepId = _loginResponse!.data.userId;
        print("ID - " + salesRepId);
        _expirationTime = DateTime.parse(_loginResponse!.data.expires);
        TokenManager().expirationTime = _expirationTime;
        print(_expirationTime);
      });
    }
    if (_selectedLocation != null) {
      setState(() {
        userlocation = _selectedLocation!.description;
        locationId = _selectedLocation!.locationId;
        print(userlocation);
        print(_selectedLocation!.description);
      });
    }
  }

  DataManagerProvider dataManagerProvider = DataManagerProvider();
  List<ProductBrand> productBrandList = [];
  List<ProductCategory> productCategoryList = [];

  SalesData calculateTotals() {
    totalSellingPrice = 0;
    totalQuantities = 0;
    totalUniqueItems = 0;
    totalCostPrice = 0;
    totalDiscountPrice = 0;
    totalGrossAmount = 0;
    totalNetAmount = 0;

    // Create a list to store sales details
    final List<SalesDetailItem> salesDetails = [];
    productBrandList = dataManagerProvider.productBrands;
    productCategoryList = dataManagerProvider.productCategories;

    for (final cartItem in widget.cartItems) {
      // Calculate the discounted price and other details
      double sellingPrice = calculateDiscountedPrice(
        cartItem.product.costPrice,
        cartItem.product.sellingPrice,
        cartItem.discount,
        cartItem.discountType,
        cartItem,
      );

      totalSellingPrice += sellingPrice * cartItem.quantity;
      totalQuantities += cartItem.quantity;
      totalCostPrice += cartItem.product.costPrice * cartItem.quantity; // Update total cost price
      totalDiscountPrice += (cartItem.product.sellingPrice - sellingPrice) * cartItem.quantity; // Update total discount price
      totalGrossAmount += cartItem.product.sellingPrice * cartItem.quantity; // Update total gross amount
      totalNetAmount += sellingPrice * cartItem.quantity; // Update total net amount

      // Create a SalesDetailItem for this cart item
      final salesDetail = SalesDetailItem(
        itemId: cartItem.product.productId,
        itemName: cartItem.product.productName,
        itemImage: cartItem.product.productImageUrl!,
        itemCost: cartItem.product.costPrice,
        itemPrice: cartItem.product.sellingPrice,
        itemDiscount: cartItem.discount,
        itemNetAmount: sellingPrice,
        itemQty: cartItem.quantity,
        itemBrandId: getProductBrandIdByName(cartItem.product.productBrand),
        itemBrandName: cartItem.product.productBrand,
        itemCategoryId: getProductCategoryIdByName(cartItem.product.productCategory),
        itemCategoryName: cartItem.product.productCategory,
      );

      // Add the sales detail to the list
      salesDetails.add(salesDetail);

      if (cartItem.quantity > 0) {
        totalUniqueItems++;
      }
    }

    // Update the salesData instance with the calculated values
    final SalesData salesData = SalesData(
      docDate: selectedDate.toIso8601String(),
      // Use selectedDate as the docDate
      salesRepId: salesRepId,
      // Replace with the sales representative's ID
      totalCost: totalCostPrice,
      // You can calculate these values if needed
      grossAmount: totalGrossAmount,
      // You can calculate these values if needed
      discountAmount: totalDiscountPrice,
      // You can calculate these values if needed
      netAmount: totalNetAmount,
      // Use the calculated totalSellingPrice
      totalProducts: totalUniqueItems,
      locationId: locationId,
      // Replace with the location ID
      longitude: dataManagerProvider.longitude,
      // Replace with the longitude
      latitude: dataManagerProvider.latitude,
      // Replace with the latitude
      deviceMAC: 'IN PROG...',
      deviceDateTime: DateTime.now().toIso8601String(),
      currentUser: salesRepId,
      // Replace with the current user
      salesDetails: salesDetails,
    );

    // You can now send the salesData object to your API
    return salesData;
  }

//productBrandList
// productCategoryList

  String getProductCategoryIdByName(String name) {
    ProductCategory empty = ProductCategory(productCategoryId: "null", productCategoryName: "null");
    final productCategory = productCategoryList.firstWhere(
      (category) => category.productCategoryName == name,
      orElse: () => empty, // Return null if not found
    );
    return productCategory.productCategoryId; // Return the found productBrandId or null
  }

  String getProductBrandIdByName(String name) {
    ProductBrand empty = ProductBrand(productBrandId: "null", productBrandName: "null");
    final productBrand = productBrandList.firstWhere(
      (brand) => brand.productBrandName == name,
      orElse: () => empty, // Return null if not found
    );
    return productBrand.productBrandId; // Return the found productBrandId or null
  }

  double calculateDiscountedPrice(
    double costPrice,
    double sellingPrice,
    double discount,
    String discountType,
    CartItem cartItem,
  ) {
    double discountedPrice;

    if (discountType == 'Percentage') {
      discountedPrice = applyPercentageDiscount(sellingPrice, discount);
    } else if (discountType == 'Value') {
      discountedPrice = applyValueDiscount(sellingPrice, discount);
    } else {
      // No discount
      discountedPrice = sellingPrice;
    }

    // Check if the discounted price is below the cost price
    if (discountedPrice < costPrice) {
      cartItem.isDiscountInvalid = true;
    } else {
      cartItem.isDiscountInvalid = false;
    }

    return discountedPrice;
  }

  double applyPercentageDiscount(double sellingPrice, double discount) {
    return sellingPrice - (sellingPrice * (discount / 100));
  }

  double applyValueDiscount(double sellingPrice, double discount) {
    return sellingPrice - discount;
  }

  Future<void> saveSalesData(SalesData salesData) async {
    try {
      // Convert the SalesData object to JSON
      final jsonData = salesData.toJson();

      //print("JSON '$jsonData'");

      // Make an API POST request with jsonData as the request body
      final response = await APIService.saveSalesDetails(salesData);
      // Handle the API response as needed
      if (response) {
        // Handle a successful response
        // You may want to show a success message to the user
        print("Success");

        await dataManagerProvider.fetchReptargets(dataManagerProvider.loginResponse_DM!.data.userId);

        // Call the refreshData method to refresh data when returning to home
        Navigator.popUntil(context, (route) => route.isFirst);
      } else {
        // Handle API errors, e.g., show an error message
        print("Error: $response");
        print("ERROR");
      }
    } catch (e) {
      // Handle exceptions, e.g., network errors
      // Handle exceptions, e.g., network errors
      print("Error: $e");
      print(e);
    }
  }

  void removeFromCart(int index) {
    setState(() {
      widget.cartItems.removeAt(index);
      calculateTotals();
    });
  }

  void changeSellingPrice(int index, double newSellingPrice) {
    print("${index} --- ${newSellingPrice}");
    setState(() {
      // Update the selling price of the item at the specified index
      widget.cartItems[index].product.sellingPrice = newSellingPrice;
      // Recalculate totals
      calculateTotals();
    });
  }

  late TextEditingController sellingPriceController;
  late TextEditingController discountController;
  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Summary'),
      ),
      body: Column(
        children: [
          Container(
            color: AppColors.cenmetrixBlue,
            // You can change this to your preferred shade of green
            padding: const EdgeInsets.all(0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    _selectDate(context); // Show the date picker
                  },
                  child: const Text(
                    'Select Date',
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  '$formattedDate',
                  style: const TextStyle(color: AppColors.white),
                )
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: widget.cartItems.length,
              itemBuilder: (context, index) {
                final cartItem = widget.cartItems[index];
                final isEvenIndex = index % 2 == 0;
                // double initialSellingPrice = cartItem.product.sellingPrice;
                // double initialCostPrice = cartItem.product.costPrice;

                sellingPriceController = TextEditingController(text: cartItem.product.sellingPrice.toString());
                discountController = TextEditingController(text: cartItem.discount.toString());
                return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    removeFromCart(index);
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16.0),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 36,
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(0),
                    child: Card(
                      color: isEvenIndex ? Colors.white : Colors.grey[200],
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProductImageWidget(
                            imageUrl: cartItem.product.productImageUrl!,
                            errorImageUrl: 'assets/images/image_not_found.png',
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cartItem.product.productName,
                                  style: const TextStyle(fontSize: 12),
                                ),
                                const SizedBox(height: 0),
                                Row(
                                  children: [
                                    Visibility(
                                      visible: dataManagerProvider.hasAdminRole(),
                                      child: Text('Cost Price: ${cartItem.product.costPrice.toStringAsFixed(2)}'),
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      'Selling Price: ',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        cartItem.product.sellingPrice.toString(), // Set the text value here
                                        style: TextStyle(
                                          color: (calculateDiscountedPrice(cartItem.product.costPrice, cartItem.product.sellingPrice,
                                                          cartItem.discount, cartItem.discountType, cartItem) ==
                                                      cartItem.product.costPrice) ||
                                                  (cartItem.product.sellingPrice <= cartItem.product.costPrice)
                                              ? AppColors.colorRed
                                              : AppColors.cenmetrixBlue,
                                        ),
                                      ),

                                      // TextField(
                                      //   style: TextStyle(
                                      //     color: calculateDiscountedPrice(cartItem.product.costPrice, cartItem.product.sellingPrice,
                                      //                 cartItem.discount, cartItem.discountType, cartItem) ==
                                      //             cartItem.product.costPrice
                                      //         ? AppColors.colorRed
                                      //         : AppColors.cenmetrixBlue,
                                      //   ),
                                      //   controller: sellingPriceController,
                                      //   decoration: const InputDecoration(
                                      //     hintText: 'Enter selling price',
                                      //   ),
                                      //   keyboardType: TextInputType.number,
                                      //   onSubmitted: (value) {
                                      //     print('Submitted: $value');
                                      //
                                      //     changeSellingPrice(index, double.tryParse(value) ?? 0.0);
                                      //
                                      //     calculateTotals();
                                      //   },
                                      //
                                      //   // onChanged: (value) {
                                      //   //   double sellingPrice =
                                      //   //       double.tryParse(value) ?? 0.0;
                                      //   //   cartItem.product.sellingPrice =
                                      //   //       sellingPrice;
                                      //   // },
                                      // ),
                                      //
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: () {
                                        setState(() {
                                          if (cartItem.quantity > 0) {
                                            cartItem.quantity--;
                                            calculateTotals();
                                          }
                                        });
                                      },
                                    ),
                                    Text(cartItem.quantity.toString()),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () {
                                        setState(() {
                                          cartItem.quantity++;
                                          calculateTotals();
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      'Discount Type:',
                                    ),
                                    const SizedBox(width: 4),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: TextField(
                                        controller: discountController,
                                        // Assign the controller here
                                        decoration: const InputDecoration(
                                          hintText: 'Enter discount',
                                        ),
                                        keyboardType: TextInputType.number,
                                        onSubmitted: (value) {
                                          double discount = double.tryParse(value) ?? 0.0;
                                          setState(() {
                                            cartItem.discount = discount;
                                            calculateTotals();
                                          });
                                          discountController.text = cartItem.discount as String;
                                        },
                                      ),
                                    ),
                                    DropdownButton<String>(
                                      value: cartItem.discountType,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          cartItem.discountType = newValue!;
                                          calculateTotals();
                                        });
                                      },
                                      items: ['Percentage', 'Value'].map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.end,
          //     children: [
          //       Text('Total Unique Items: $totalUniqueItems'),
          //       Text('Total Quantities: $totalQuantities'),
          //       //     Text('Total Selling Price: ${totalSellingPrice.toStringAsFixed(2)}'),
          //       Text('Total Gross Amount: ${totalGrossAmount.toStringAsFixed(2)}'),
          //       Text('Total Discount Amount: ${totalDiscountPrice.toStringAsFixed(2)}'), // Display total discount price
          //       // Display total gross amount
          //       Text('Total Net Amount: ${totalNetAmount.toStringAsFixed(2)}'),
          //     ],
          //   ),
          // ),

          ElevatedButton(
            onPressed: () async {
              // Implement your logic here to save the sales
              // You can access the sales data from the salesData object
              // Don't forget to send the data to your API
              // Recalculate totals
              await saveSalesData(calculateTotals());
            },
            child: const Text('Save My Sales'),
          ),
          Container(
            //    color: Colors.green[300],
            color: AppColors.cenmetrixBlue,
            // You can change this to your preferred shade of green
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Products: $totalUniqueItems',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white), // Text color: black for good readability on green background
                ),
                const SizedBox(height: 8),
                Text(
                  'Total Quantities: $totalQuantities',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white), // Text color: black for good readability on green background
                ),
                const SizedBox(height: 16),
                // Text('Total Selling Price: ${totalSellingPrice.toStringAsFixed(2)}'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Gross Amount:',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white), // Text color: black for good readability on green background
                    ),
                    Text(
                      '${totalGrossAmount.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 20, color: Colors.white), // Text color: black for good readability on green background
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Discount Amount:',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white), // Text color: black for good readability on green background
                    ),
                    Text(
                      '${totalDiscountPrice.toStringAsFixed(2)}',
                      // Display total discount price
                      style: const TextStyle(fontSize: 20, color: Colors.white), // Text color: black for good readability on green background
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Display total gross amount
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Net Amount:',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white), // Text color: black for good readability on green background
                    ),
                    Text(
                      '${totalNetAmount.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 20, color: Colors.white), // Text color: black for good readability on green background
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Add your logic here to save the sales
          // You can access the cart items from widget.cartItems
          // and their updated quantities and selling prices
          // once the "Save My Sales" button is clicked.
        ],
      ),
    );
  }
}
