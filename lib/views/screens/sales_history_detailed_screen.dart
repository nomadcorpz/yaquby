import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yaquby/config.dart';
import 'package:yaquby/models/sales_history_detailed_doc_response.dart';
import 'package:yaquby/models/sales_history_summery_model.dart';
import 'package:yaquby/servives/api_services.dart';
import 'package:yaquby/servives/global_variables.dart';

class SalesHistoryDetailedScreen extends StatefulWidget {
  final SalesSummaryData salesData;

  SalesHistoryDetailedScreen({required this.salesData});

  @override
  _SalesHistoryDetailedScreenState createState() => _SalesHistoryDetailedScreenState();
}

class _SalesHistoryDetailedScreenState extends State<SalesHistoryDetailedScreen> {
  Future<SalesDocDetailedResponse>? salesDetailResponse;

  @override
  void initState() {
    super.initState();
    fetchSalesDetail();
  }

  void fetchSalesDetail() {
    salesDetailResponse = APIService.getSalesSummeryDetailedDoc(widget.salesData.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    DataManagerProvider dataManagerProvider = DataManagerProvider();
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        title: const Text('Sales detail', style: TextStyle(color: AppColors.white)),
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
      body: FutureBuilder<SalesDocDetailedResponse>(
        future: salesDetailResponse,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data available.'));
          } else {
            SalesDocDetailedResponse salesDetailData = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display SalesSummaryData at the top
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Table(
                      columnWidths: {
                        0: FixedColumnWidth(120), // Adjust column widths as needed
                      },
                      children: [
                        TableRow(
                          children: [
                            TableCell(
                              child: _buildHeaderItem('Sale ID:', widget.salesData.id),
                            ),
                            TableCell(
                              child: _buildHeaderItem('', ''),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            TableCell(
                              child: _buildHeaderItem('Sales Date:', widget.salesData.docDate),
                            ),
                            if (dataManagerProvider.hasAdminRole())
                              TableCell(
                                child: _buildHeaderItem('Total Cost:', 'BHD ${widget.salesData.totalCost.toStringAsFixed(2)}'),
                              )
                            else
                              TableCell(
                                child: _buildHeaderItem('Total Cost:', 'Admin users only'),
                              ),
                          ],
                        ),
                        TableRow(
                          children: [
                            TableCell(
                              child: _buildHeaderItem('Gross Amount:', 'BHD ${widget.salesData.grossAmount.toStringAsFixed(2)}'),
                            ),
                            TableCell(
                              child: _buildHeaderItem('Discount Amount:', 'BHD ${widget.salesData.discountAmount.toStringAsFixed(2)}'),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            TableCell(
                              child: _buildHeaderItem('Net Amount:', 'BHD ${widget.salesData.netAmount.toStringAsFixed(2)}'),
                            ),
                            TableCell(
                              child: _buildHeaderItem('Total Products:', widget.salesData.totalProducts.toString()),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: salesDetailData.data.length,
                    itemBuilder: (context, index) {
                      SalesDocDetailData item = salesDetailData.data[index];
                      return Card(
                        elevation: 5,
                        margin: EdgeInsets.all(10),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Item thumbnail image
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(item.itemImage), // Replace with your image URL
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              SizedBox(width: 10), // Add some spacing

                              // Item details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.itemName,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text('Item ID: ${item.itemId}'),
                                    Text('Brand: ${item.itemBrandName}'),
                                    Text('Category: ${item.itemCategoryName}'),
                                    SizedBox(height: 10), // Add some spacing
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: item.itemQty.toStringAsFixed(2),
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.red, // Change this to your desired color
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: ' x ',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black, // Price color
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'BHD ${item.itemPrice.toStringAsFixed(2)}',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.green, // Price color
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildHeaderItem(String label, dynamic date) {
    String formattedDate = '';
    if (label == 'Sales Date:') {
      if (date is DateTime) {
        final DateFormat formatter = DateFormat('yyyy-MM-dd');
        formattedDate = formatter.format(date);
      } else if (date is String) {
        final parsedDate = DateTime.parse(date); // Convert the string to DateTime
        final DateFormat formatter = DateFormat('yyyy-MM-dd');
        formattedDate = formatter.format(parsedDate);
      }
    } else {
      formattedDate = date.toString();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12, // Adjust font size as needed
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        Text(
          formattedDate,
          style: TextStyle(
            fontSize: 14, // Adjust font size as needed
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 10), // Add spacing between items
      ],
    );
  }
}
