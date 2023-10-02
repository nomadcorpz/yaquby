import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yaquby/config.dart';
import 'package:yaquby/models/attendance_request_model.dart';
import 'package:yaquby/models/login_response_model.dart';
import 'package:yaquby/models/sales_history_summery_model.dart';
import 'package:yaquby/servives/api_services.dart';
import 'package:yaquby/servives/global_variables.dart';
import 'package:yaquby/servives/shared_services.dart';
import 'package:yaquby/servives/token_manager.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:yaquby/views/screens/sales_history_detailed_screen.dart';

class SalesListHistoryScreen extends StatefulWidget {
  SalesListHistoryScreen({super.key});
  @override
  State<SalesListHistoryScreen> createState() => _SalesListHistoryScreenState();
}

class _SalesListHistoryScreenState extends State<SalesListHistoryScreen> {
  Future<SalesSummaryResponse>? salesResponseDataList;
  LoginResponseModel? _loginResponse;
  AttendanceRequestModel? _attendanceRequestModel;
  late String userid = "1";
  Userlocations? _selectedLocation;
  double? latitude;
  double? longitude;
  bool geoLoading = true;
  DateTime? selectedDate;
  String endDate = '';
  String startDate = '';
  bool showDatePicker = false; // Initially hide the date picker
  String buttonText = "Select Date Range"; // Initial button text
  Color buttonColor = Colors.blue; // Initial button color

  @override
  void initState() {
    super.initState();
    setUpDate();
    getSavedData();
    TokenManager().setContext(context);
  }

  Future<void> getSavedData() async {
    _loginResponse = await SharedService.loginDetails();
    _selectedLocation = await SharedService.getSelectedUserLocation();
    setState(() {
      userid = _loginResponse!.data.userId;
      salesResponseDataList = APIService.getSalesSummeryList(userid, _selectedLocation!.locationId.toString(), startDate, endDate);
    });
  }

  setUpDate() {
    DateTime now = DateTime.now();
    endDate = DateFormat('yyyy-MM-dd').format(now);
    startDate = DateFormat('yyyy-MM-dd').format(now.subtract(const Duration(days: 30)));
  }

  /// The method for [DateRangePickerSelectionChanged] callback, which will be
  /// called whenever a selection changed on the date picker widget.
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        startDate = DateFormat('yyyy-MM-dd').format(args.value.startDate);
        endDate = DateFormat('yyyy-MM-dd').format(args.value.endDate ?? args.value.startDate);
      }
    });
  }

  // Toggle the visibility of the date picker and update button text/color
  void toggleDatePickerVisibility() {
    setState(() {
      showDatePicker = !showDatePicker;
      if (showDatePicker) {
        buttonText = "Apply";
        buttonColor = Colors.red;
      } else {
        buttonText = "Select Date Range";
        buttonColor = Colors.blue;
      }
    });
  }

  // Call the API when applying date ranges
  void applyDateRanges() {
    setState(() {
      salesResponseDataList = APIService.getSalesSummeryList(userid, _selectedLocation!.locationId.toString(), startDate, endDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    DataManagerProvider dataManagerProvider = DataManagerProvider();
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        title: const Text('Sales History List', style: TextStyle(color: AppColors.white)),
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
        children: [
          Container(
            width: MediaQuery.of(context).size.width, // Set the desired width
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center, // Center the button
              children: <Widget>[
                const SizedBox(height: 10),
                Container(
                  color: AppColors.colorWhite,
                  child: Center(
                    child: Text.rich(
                      TextSpan(
                        text: 'Date Range from: ',
                        style: const TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: startDate,
                            style: const TextStyle(color: AppColors.cenmetrixOrange, fontWeight: FontWeight.bold),
                          ),
                          const TextSpan(
                            text: ' to ',
                            style: TextStyle(color: Colors.black),
                          ),
                          TextSpan(
                            text: endDate,
                            style: const TextStyle(color: AppColors.cenmetrixOrange, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        return buttonColor; // Use the dynamic button color
                      },
                    ),
                  ),
                  onPressed: () {
                    // Call the API when applying date ranges
                    toggleDatePickerVisibility(); // Hide the date picker

                    if (!showDatePicker) {
                      applyDateRanges();
                    }
                    // Toggle visibility and change button text/color
                  },
                  child: Text(buttonText), // Use the dynamic button text
                ),
                Visibility(
                  visible: showDatePicker, // Show or hide the date picker based on visibility
                  child: Column(
                    children: [
                      // ElevatedButton(
                      //   style: ButtonStyle(
                      //     backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      //           (Set<MaterialState> states) {
                      //         return Colors.red; // Use red for Apply button
                      //       },
                      //     ),
                      //   ),
                      //   onPressed: () {
                      //     applyDateRanges(); // Call the API when applying date ranges
                      //     toggleDatePickerVisibility(); // Hide the date picker
                      //   },
                      //   child: const Text("Apply"),
                      // ),
                      SfDateRangePicker(
                        onSelectionChanged: _onSelectionChanged,
                        selectionMode: DateRangePickerSelectionMode.range,
                        maxDate: DateTime.now(),
                        backgroundColor: Colors.white,
                        initialSelectedRange: PickerDateRange(
                          DateTime.now().subtract(const Duration(days: 30)),
                          DateTime.now().add(const Duration(days: 0)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          FutureBuilder<SalesSummaryResponse>(
            future: salesResponseDataList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data?.data.isEmpty == true) {
                return const Center(child: Text('No sales data available.'));
              } else {
                List<SalesSummaryData> salesDataList = snapshot.data!.data;
                return Expanded(
                  child: ListView.builder(
                    itemCount: salesDataList.length,
                    itemBuilder: (context, index) {
                      SalesSummaryData salesData = salesDataList.reversed.elementAt(index); // Reverse the list and access items
                      return Card(
                        margin: const EdgeInsets.all(10),
                        elevation: 5,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Text(
                              '${salesData.id}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(
                            'Date: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(salesData.docDate))}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 2),
                              dataManagerProvider.hasAdminRole()
                                  ? Text(
                                      'Total Cost: BHD ${salesData.totalCost.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    )
                                  : const Text(
                                      'Total Cost: Admins users only',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                              const SizedBox(height: 2),
                              Text(
                                'Gross Amount: BHD ${salesData.grossAmount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Discount Amount: BHD ${salesData.discountAmount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Net Amount: BHD ${salesData.netAmount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Total Products: ${salesData.totalProducts}',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          trailing: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SalesHistoryDetailedScreen(salesData: salesData),
                                ),
                              );
                            },
                            child: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
