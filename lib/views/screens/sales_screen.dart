import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:provider/provider.dart';
import 'package:yaquby/models/category_response_model.dart';
import 'package:yaquby/models/login_response_model.dart';
import 'package:yaquby/servives/global_variables.dart';
import 'package:yaquby/views/screens/sale_summary_screen.dart';
import '../../config.dart';
import '../../models/brand_response_model.dart';
import '../../models/product_response_model.dart';
import '../../servives/token_manager.dart';
import '../customWidgets/ProductImageWidget.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});
  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  List<CartItem> cartItems = [];

  DataManagerProvider dataManagerProvider = DataManagerProvider();

  // Function to add a product to the cart
  void addToCart(Product product) {
    setState(() {
      CartItem cartItem = cartItems.firstWhere(
        (item) => item.product.productId == product.productId,
        orElse: () => CartItem(product, 0),
      );
      cartItem.quantity++;
      if (!cartItems.contains(cartItem)) {
        cartItems.add(cartItem);
      }
    });
  }

  @override
  void initState() {
    TokenManager().setContext(context);
  } // Function to remove a product from the cart

  void removeFromCart(Product product) {
    setState(() {
      CartItem cartItem = cartItems.firstWhere(
        (item) => item.product.productId == product.productId,
        orElse: () => CartItem(product, 0),
      );
      if (cartItem.quantity > 0) {
        cartItem.quantity--;
        if (cartItem.quantity == 0) {
          cartItems.remove(cartItem);
        }
      }
    });
  }

  void _proceedToSalesSummary() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SalesSummaryScreen(cartItems: cartItems),
      ),
    );
  }

  List<Product> products = [];
  List<ProductBrand> productBrands = [];
  int quantity = 0;
  Product? selectedProduct;
  String? selectedBrand = "All"; // Initialize selectedBrand here
  String? selectedCategory = "All"; // Initialize selectedCategory here

  String searchQuery = '';

  List<Product> filteredProducts = [];
  LoginResponseModel? loginResponse;
  @override
  Widget build(BuildContext context) {
    // Access the DataManagerProvider instance
    final dataManagerProvider = Provider.of<DataManagerProvider>(context);
    products = dataManagerProvider.products;
    loginResponse = dataManagerProvider.loginResponse_DM;
    // Access the products from the dataManagerProvider

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        title: const Text('Sales', style: TextStyle(color: AppColors.white)),
        backgroundColor: AppColors.cenmetrixBlue,
        leading: IconButton(
          icon: Image.asset(
            'assets/images/ic_back_white.png',
            color: AppColors.white,
            height: 25,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Column(
              children: [
                Container(
                  child: DropdownButtonFormField<String>(
                    value: selectedBrand,
                    onChanged: (value) {
                      // _buildCategoryDropdownItems();
                      setState(() {
                        selectedBrand = value;
                        filteredProducts = products.where((product) {
                          return (selectedBrand == 'All' || product.productBrand == selectedBrand) &&
                              (selectedCategory == 'All' || product.productCategory == selectedCategory) &&
                              (product.productName.toLowerCase().contains(searchQuery));
                        }).toList();
                      });
                    },
                    items: _buildBrandDropdownItems(),
                    decoration: const InputDecoration(
                      labelText: 'Product Brand',
                    ),
                    itemHeight: 50,
                    menuMaxHeight: 200,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  child: DropdownButtonFormField<String>(
                    value: selectedCategory,
                    items: _buildCategoryDropdownItems(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value;
                        // Filter the products based on the selected category
                        filteredProducts = products.where((product) {
                          return (selectedBrand == 'All' || product.productBrand == selectedBrand) &&
                              (selectedCategory == 'All' || product.productCategory == selectedCategory) &&
                              (product.productName.toLowerCase().contains(searchQuery));
                        }).toList();
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Product Category',
                    ),
                    itemHeight: 50,
                    menuMaxHeight: 200,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value.toLowerCase();
                        filteredProducts = products.where((product) {
                          return (selectedBrand == 'All' || product.productBrand == selectedBrand) &&
                              (selectedCategory == 'All' || product.productCategory == selectedCategory) &&
                              (product.productName.toLowerCase().contains(searchQuery));
                        }).toList();
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Search by Product Name',
                    ),
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    String barcode = await FlutterBarcodeScanner.scanBarcode(
                      '#ff6666', // Color of the scan button
                      'Cancel', // Text for the cancel button
                      true, // Flashlight toggle
                      ScanMode.BARCODE, // Specify whether you want to scan a barcode or QR code
                    );

                    if (barcode != "-1") {
                      setState(() {
                        searchQuery = barcode.toLowerCase();
                        filteredProducts = products.where((product) {
                          return (product.barcode?.toLowerCase()?.contains(searchQuery) ?? false);
                        }).toList();
                      });
                      FlutterBeep.beep();
                    }
                  },
                  icon: Icon(Icons.barcode_reader),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              //   itemCount: filteredProducts.length,
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                //    final product = products[index];
                final product = filteredProducts[index];
                final isEvenIndex = index % 2 == 0;
                int cartQuantity =
                    cartItems.firstWhere((item) => item.product.productId == product.productId, orElse: () => CartItem(product, 0)).quantity;

                //--->>>     int quantity = cartItems[product.hashCode] ?? 0;
                CartItem cartItem = cartItems.firstWhere(
                  (item) => item.product.hashCode == product.hashCode,
                  orElse: () => CartItem(product, 0),
                );
                int quantity = cartItem.quantity;
                final bool isAdminOrSuperAdmin = dataManagerProvider.hasAdminRole(); // Check if the user has admin or superAdmin role

                return Center(
                  child: Container(
                    color: isEvenIndex ? Colors.white : Colors.grey[200],
                    height: 110,
                    child: ListTile(

                      leading: ProductImageWidget(
                        imageUrl: product.productImageUrl!,
                        errorImageUrl: 'assets/images/image_not_found.png',
                      ),

                      title: GestureDetector(
                        onTap: () => _showProductDetailsDialog(product),
                        child: Text(
                          product.productName,
                          style: const TextStyle(
                            fontSize: 10, // Adjust the font size as needed
                            fontWeight: FontWeight.bold, // Adjust the font weight as needed
                            color: AppColors.cenmetrixBlue, // Adjust the text color as needed
                            fontStyle: FontStyle.normal, // Adjust the font style as needed
                            letterSpacing: 2.0, // Adjust the letter spacing as needed
                            // You can add more properties like fontFamily, text alignment, etc.
                          ),
                        ),
                      ),

                      subtitle: Text(
                        isAdminOrSuperAdmin
                            ? // Conditionally show the cost
                            'Item No: ${product.productId}\nBrand: ${product.productBrand} \nCategory: ${product.productCategory} \nCost Price: ${product.costPrice.toStringAsFixed(3)} \nSelling Price: ${product.sellingPrice}\nStocks on Hand: ${product.stockOnHand}'
                            : 'Item No: ${product.productId}\nBrand: ${product.productBrand} \nCategory: ${product.productCategory} \nSelling Price: ${product.sellingPrice}\nStocks on Hand: ${product.stockOnHand}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.normal,
                          color: AppColors.black,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 0,
                        ),
                      ),
                      //    trailing: Text('\$${product.price.toStringAsFixed(2)}'),
                      trailing: Column(

                        children: [
                          Row(

                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.remove_circle_outline_sharp,
                                  color: (quantity! > 0) ? Colors.blueGrey : AppColors.lightGray, // Set color based on cart quantity
                                ),
                                onPressed: () {
                                  if (quantity! > 0) {
                                    setState(() {
                                      removeFromCart(product);
                                    });
                                  }
                                },
                              ),
                              Text('$cartQuantity'),
                              IconButton(
                                icon: Icon(
                                  Icons.add_circle_outline_sharp,
                                  color: (quantity! < (product.stockOnHand ?? 0))
                                      ? Colors.blueGrey
                                      : AppColors.lightGray, // Set color based on stock availability
                                ),
                                onPressed: () {
                                  if (quantity! < (product.stockOnHand ?? 0)) {
                                    setState(() {
                                      addToCart(product);
                                    });
                                  }
                                },
                              ),
                            ],
                          ),


                        ],
                      ),
isThreeLine: true,
                      // Add button and sample image here (you can customize it as needed)
                      // Example: trailing: IconButton(icon: Icon(Icons.add), onPressed: () => _addToCart(product)),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5), // Set the shadow color and opacity
                  spreadRadius: 2, // Set the spread radius of the shadow
                  blurRadius: 4, // Set the blur radius of the shadow
                  offset: const Offset(0, 3), // Set the offset for the shadow (x, y)
                ),
              ],
            ),
            child: Container(
              //    color: Colors.green[300],
              color: AppColors.cenmetrixBlue,
              // You can change this to your preferred shade of green
              padding: const EdgeInsets.all(2),
              child: ButtonBar(
                alignment: MainAxisAlignment.spaceBetween, // Align items at the start and end of the row
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total items: ${getTotalQuantity()}",
                        style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Total Products: ${getUniqueProductCount()}",
                        style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: _proceedToSalesSummary,
                    child: Text("Proceed Sales"),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  int getTotalQuantity() {
    int totalQuantity = 0;
    for (var cartItem in cartItems) {
      totalQuantity += cartItem.quantity;
    }
    return totalQuantity;
  }

  int getUniqueProductCount() {
    int uniqueProductCount = 0;
    for (var cartItem in cartItems) {
      if (cartItem.quantity > 0) {
        uniqueProductCount++;
      }
    }
    return uniqueProductCount;
  }

  List<DropdownMenuItem<String>> _buildBrandDropdownItems() {
    DataManagerProvider dataManagerProvider = DataManagerProvider();
    List<ProductBrand> prm = dataManagerProvider.productBrands;
    List<String> brands = ['All'];

    prm.forEach((element) {
      brands.add(element.productBrandName!);
    });

    return brands.map((brand) => DropdownMenuItem(value: brand, child: Text(brand))).toList();
  }

  List<DropdownMenuItem<String>> _buildCategoryDropdownItems() {
    DataManagerProvider dataManagerProvider = DataManagerProvider();
    List<ProductCategory> prm = dataManagerProvider.productCategories;
    List<String> categories = ['All'];

    prm.forEach((element) {
      categories.add(element.productCategoryName!);
    });

    return categories.map((category) => DropdownMenuItem(value: category, child: Text(category))).toList();
  }

  int dialogQuantity = 0;

  // void _showProductDetailsDialog(Product product) {
  //   setState(() {
  //     selectedProduct = product;
  //     dialogQuantity = cartItems.firstWhere((item) => item.product.productId == product.productId, orElse: () => CartItem(product, 0)).quantity;
  //   });
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text(product.productName),
  //         content: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Center(
  //               child: ProductImageWidget(
  //                 imageUrl: product.productImageUrl!,
  //                 errorImageUrl: 'assets/images/image_not_found.png',
  //               ),
  //             ),
  //             const SizedBox(height: 10),
  //             Text('Brand: ${product.productBrand}'),
  //             Text('Category: ${product.productCategory}'),
  //             Text('Cost Price: ${product.costPrice.toStringAsFixed(2)}'),
  //             Text('Selling Price: ${product.sellingPrice.toStringAsFixed(2)}'),
  //             Text('Stocks on Hand: ${product.stockOnHand}'),
  //             const SizedBox(height: 10),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 IconButton(
  //                   icon: const Icon(Icons.remove),
  //                   onPressed: () {
  //                     setState(() {
  //                       removeFromCart(selectedProduct!);
  //                       dialogQuantity = cartItems.firstWhere((item) => item.product.productId == product.productId).quantity;
  //                     });
  //                   },
  //                 ),
  //                 Text('$dialogQuantity'),
  //                 IconButton(
  //                   icon: const Icon(Icons.add),
  //                   onPressed: () {
  //                     setState(() {
  //                       addToCart(selectedProduct!);
  //                       dialogQuantity = cartItems.firstWhere((item) => item.product.productId == product.productId).quantity;
  //                     });
  //                   },
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.pop(context);
  //               addToCart(selectedProduct!);
  //             },
  //             child: const Text('Add to Sales Cart'),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               Navigator.pop(context);
  //               removeFromCart(selectedProduct!);
  //             },
  //             child: const Text('Remove from Cart'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  void _showProductDetailsDialog(Product product) {
    setState(() {
      selectedProduct = product;
      dialogQuantity = cartItems.firstWhere((item) => item.product.productId == product.productId, orElse: () => CartItem(product, 0)).quantity;
    });
    final TextEditingController sellingPriceController = TextEditingController();
    int selectedProductIndex = -1;

    // Initialize the sellingPriceController with the current selling price
    sellingPriceController.text = product.sellingPrice.toStringAsFixed(2);

    selectedProductIndex = dataManagerProvider.products.indexWhere((p) => p.productId == product.productId);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final bool isAdminOrSuperAdmin = dataManagerProvider.hasAdminRole();
        return AlertDialog(
          title: Text(product.productName),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: ProductImageWidget(
                  imageUrl: product.productImageUrl!,
                  errorImageUrl: 'assets/images/image_not_found.png',
                ),
              ),
              const SizedBox(height: 10),
              Text('Brand: ${product.productBrand}'),
              Text('Category: ${product.productCategory}'),
              Visibility(
                visible: isAdminOrSuperAdmin, // Check if the user has admin or superAdmin role
// Replace 'userIsAdmin' with your actual condition
                child: Text('Cost Price: ${product.costPrice.toStringAsFixed(2)}'),
              ),

              TextField(
                controller: sellingPriceController,
                decoration: const InputDecoration(labelText: 'Selling Price'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              Text('Stocks on Hand: ${product.stockOnHand}'),
              const SizedBox(height: 10),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     IconButton(
              //       icon: const Icon(Icons.remove),
              //       onPressed: () {
              //         setState(() {
              //           removeFromCart(product);
              //           dialogQuantity = cartItems.firstWhere((item) => item.product.productId == product.productId).quantity;
              //         });
              //       },
              //     ),
              //     Text('$dialogQuantity'),
              //     IconButton(
              //       icon: const Icon(Icons.add),
              //       onPressed: () {
              //         setState(() {
              //           addToCart(product);
              //           dialogQuantity = cartItems.firstWhere((item) => item.product.productId == product.productId).quantity;
              //         });
              //       },
              //     ),
              //   ],
              // ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final newSellingPrice = double.tryParse(sellingPriceController.text);
                if (newSellingPrice != null) {
                  dataManagerProvider.updateProductSellingPrice(selectedProductIndex, newSellingPrice);
                  // Close the dialog
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
            // TextButton(
            //   onPressed: () {
            //     Navigator.pop(context);
            //     removeFromCart(product);
            //   },
            //   child: const Text('Remove from Cart'),
            // ),
            // TextButton(
            //   onPressed: () {
            //     Navigator.pop(context);
            //     addToCart(product);
            //   },
            //   child: const Text('Add to Sales Cart'),
            // ),
          ],
        );
      },
    );
  }
}
class ProductListItem extends StatelessWidget {
  final String imageUrl;
  final String productName;
  final String productDetails;
  final String price;
  final VoidCallback onTap;
  final VoidCallback onRemove;
  final VoidCallback onAdd;
  final int cartQuantity;
  final int stockOnHand;
  final bool isAdminOrSuperAdmin;

  ProductListItem({
    required this.imageUrl,
    required this.productName,
    required this.productDetails,
    required this.price,
    required this.onTap,
    required this.onRemove,
    required this.onAdd,
    required this.cartQuantity,
    required this.stockOnHand,
    required this.isAdminOrSuperAdmin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 110,
      child: ListTile(
        leading: Image.network(
          imageUrl,
          errorBuilder: (context, error, stackTrace) => Image.asset(
            'assets/images/image_not_found.png',
            width: 50,
            height: 50,
          ),
          width: 50,
          height: 50,
        ),
        title: GestureDetector(
          onTap: onTap,
          child: Text(
            productName,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        subtitle: Text(
          productDetails,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.remove_circle_outline,
                    color: cartQuantity > 0 ? Colors.blueGrey : Colors.grey,
                  ),
                  onPressed: onRemove,
                ),
                Text('$cartQuantity'),
                IconButton(
                  icon: Icon(
                    Icons.add_circle_outline,
                    color: cartQuantity < stockOnHand ? Colors.blueGrey : Colors.grey,
                  ),
                  onPressed: onAdd,
                ),
              ],
            ),
            Text(
              isAdminOrSuperAdmin ? 'Price: $price' : 'Stock: $stockOnHand',
              style: const TextStyle(
                fontSize: 10,
                color: Colors.black,
              ),
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}